#!/bin/bash

alert_message "info" "Отключение Nginx конфигурации по умолчанию"

unlink /etc/nginx/sites-enabled/default
