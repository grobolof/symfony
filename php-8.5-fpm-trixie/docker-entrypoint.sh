#!/usr/bin/env bash
# Готовит окружение Symfony и запускает Nginx + PHP-FPM.
set -e

source /tmp/scr/1-text-decoration.sh
log info "Готовлю контейнер Symfony…"

source /tmp/scr/2-variables-declaring.sh
source /tmp/scr/3-composer-install.sh
source /tmp/scr/4-variables-change.sh
source /tmp/scr/5-nginx-conf-def-disable.sh
source /tmp/scr/6-symfony-install.sh
source /tmp/scr/7-composer-install-packages.sh
source /tmp/scr/8-cron-configure.sh
source /tmp/scr/9-mailpit-configure.sh
source /tmp/scr/10-symfony-cache.sh
source /tmp/scr/11-symfony-migrations.sh
source /tmp/scr/12-symfony-permission.sh
source /tmp/scr/13-final-supervisor-run.sh
