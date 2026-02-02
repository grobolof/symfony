#!/bin/bash

alert_message "info" "Выставить разрешение для Symfony"

# Настройка разрешений для приложений Symfony
# Статья: https://symfony.com/doc/7.3/setup/file_permissions.html#configuring-permissions-for-symfony-applications
# Ошибка: Unable to create the storage directory (/pub/www/app/var/cache/dev/profiler).
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)

# Если переменная пустая, то присваиваем ей значение по умолчанию
if [[ -z "$HTTPDUSER" ]]; then
   HTTPDUSER=www-data
fi

setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX /tmp/symfony-cache
setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX /tmp/symfony-cache
