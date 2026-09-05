#!/bin/bash
# Создаёт проект Symfony, если bin/console ещё нет в каталоге приложения.

set_env() {
  local key=$1 value=$2 file="$APP_PATH/.env"
  [[ -f "$file" ]] || return 0
  local escaped=${value//\\/\\\\}
  escaped=${escaped//&/\\&}
  if grep -qE "^#?${key}=" "$file"; then
    sed -i "s|^#\?${key}=.*|${key}=${escaped}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

database_url() {
  case $DB_CONNECTION in
    pgsql)
      printf '"postgresql://%s:%s@%s:%s/%s?serverVersion=18&charset=utf8"' \
        "$DB_USERNAME" "$DB_PASSWORD" "$DB_HOST" "$DB_PORT" "$DB_DATABASE"
      ;;
    mysql)
      printf '"mysql://%s:%s@%s:%s/%s?serverVersion=8.0&charset=utf8mb4"' \
        "$DB_USERNAME" "$DB_PASSWORD" "$DB_HOST" "$DB_PORT" "$DB_DATABASE"
      ;;
    mariadb)
      printf '"mysql://%s:%s@%s:%s/%s?serverVersion=11&charset=utf8mb4"' \
        "$DB_USERNAME" "$DB_PASSWORD" "$DB_HOST" "$DB_PORT" "$DB_DATABASE"
      ;;
    sqlite)
      printf '"sqlite:///%s/var/data.db"' "$APP_PATH"
      ;;
  esac
}

if [[ -f "$APP_PATH/bin/console" ]]; then
  log success "Symfony уже есть в $APP_PATH — создавать не нужно"
else
  log info "Создаю проект Symfony, это может занять несколько минут…"
  composer create-project symfony/skeleton /tmp/symfony-app --no-interaction
  (
    cd /tmp/symfony-app
    composer config --json extra.symfony.docker 'false'
    composer require --no-interaction \
      symfony/orm-pack \
      symfony/serializer-pack \
      symfony/monolog-bundle \
      symfony/messenger \
      symfony/scheduler \
      symfony/security-bundle \
      symfony/validator \
      symfony/twig-bundle \
      symfony/asset \
      symfony/mailer \
      php-ds/php-ds
    composer require --dev --no-interaction \
      maker-bundle \
      orm-fixtures \
      profiler
  )
  cp -a /tmp/symfony-app/. "$APP_PATH/"
  rm -rf /tmp/symfony-app

  set_env DATABASE_URL "$(database_url)"

  mkdir -p "$APP_PATH/var"
  chmod -R ug+rwx "$APP_PATH/var"
  log success "Проект Symfony создан в $APP_PATH"
fi
