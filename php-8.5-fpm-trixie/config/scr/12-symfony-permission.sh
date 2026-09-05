#!/bin/bash
# Выставляет ACL на var/, чтобы PHP-FPM и CLI могли писать кэш и логи.
# Рекомендация Symfony: https://symfony.com/doc/current/setup/file_permissions.html

if [[ ! -d "$APP_PATH/var" ]]; then
  log warning "Каталог var не найден — права пропускаю"
else
  log info "Выставляю права на var для Symfony…"
  HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d' ' -f1)
  [[ -n "$HTTPDUSER" ]] || HTTPDUSER=www-data

  mkdir -p "$APP_PATH/var"
  setfacl -dR -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$APP_PATH/var"
  setfacl -R -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$APP_PATH/var"
  log success "Права на var выставлены"
fi
