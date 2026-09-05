#!/bin/bash
# Выставляет ACL на var/, чтобы PHP-FPM и CLI могли писать кэш и логи.
# Рекомендация Symfony: https://symfony.com/doc/current/setup/file_permissions.html
# На bind-mount (macOS Docker Desktop) POSIX ACL часто недоступен — тогда chmod.

if [[ ! -d "$APP_PATH/var" ]]; then
  log warning "Каталог var не найден — права пропускаю"
else
  log info "Выставляю права на var для Symfony…"
  HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d' ' -f1)
  [[ -n "$HTTPDUSER" ]] || HTTPDUSER=www-data

  mkdir -p "$APP_PATH/var"
  if setfacl -dR -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$APP_PATH/var" 2>/dev/null \
     && setfacl -R -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$APP_PATH/var" 2>/dev/null; then
    log success "Права на var выставлены"
  else
    chmod -R a+rwX "$APP_PATH/var"
    log success "Права на var выставлены (chmod: ACL недоступен на этом томе)"
  fi
fi
