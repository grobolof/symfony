#!/bin/bash
# Накатывает миграции Doctrine, когда доступны bin/console и база.
# Если СУБД ещё не готова — шаг не роняет контейнер, только предупреждает.
# Свежий skeleton без Version*.php — migrate не вызываем.

has_migrations() {
  [[ -d "$APP_PATH/migrations" ]] || return 1
  find "$APP_PATH/migrations" -name '*.php' -type f -print -quit | grep -q .
}

run_migrations() {
  php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
}

if [[ ! -f "$APP_PATH/bin/console" ]]; then
  log warning "bin/console не найден — миграции пропускаю"
elif ! php bin/console list --raw 2>/dev/null | grep -q '^doctrine:migrations:migrate'; then
  log warning "Doctrine Migrations не установлены — миграции пропускаю"
elif ! has_migrations; then
  log info "Зарегистрированных миграций нет — накатывать нечего"
elif [[ $DB_CONNECTION == sqlite ]]; then
  log info "Накатываю миграции Symfony (sqlite)…"
  if run_migrations; then
    log success "Миграции выполнены"
  else
    log warning "Миграции не выполнены — проверьте подключение к БД"
  fi
else
  log info "Жду СУБД $DB_HOST:$DB_PORT и накатываю миграции…"
  if ! wait-for-it "${DB_HOST}:${DB_PORT}" -t 60; then
    log warning "СУБД не отвечает — миграции пропускаю"
  else
    migrated=0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      if run_migrations; then
        migrated=1
        break
      fi
      sleep 3
    done
    if [[ $migrated == 1 ]]; then
      log success "Миграции выполнены"
    else
      log warning "Миграции не выполнены — проверьте подключение к БД"
    fi
  fi
fi
