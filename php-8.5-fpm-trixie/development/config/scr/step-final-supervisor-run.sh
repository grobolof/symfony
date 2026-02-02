#!/bin/bash

alert_message "success" "Запускаем supervisord"

supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
