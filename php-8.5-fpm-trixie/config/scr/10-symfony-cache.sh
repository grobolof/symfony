#!/bin/bash
# Сбрасывает и прогревает кэш Symfony (cache:clear + cache:warmup).
# Если консоли ещё нет — шаг пропускается.

if [[ ! -f "$APP_PATH/bin/console" ]]; then
  log warning "bin/console не найден — очистку кэша пропускаю"
else
  log info "Очищаю кэш Symfony…"
  if php bin/console cache:clear --no-interaction && php bin/console cache:warmup --no-interaction; then
    log success "Кэш Symfony очищен"
  else
    log warning "Не удалось очистить кэш Symfony"
  fi
fi
