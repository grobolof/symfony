#!/bin/bash

alert_message "info" "Замена переменных в конфигах на актуальные данные из переменных окружения"

# Заменить переменные nginx параметрами из файла .env
envsubst '$SERVER_NAME $APP_PATH' < /etc/nginx/conf.d/nginx.conf | tee /etc/nginx/conf.d/nginx-update.conf 2>&1 >/dev/null
mv -f /etc/nginx/conf.d/nginx-update.conf /etc/nginx/conf.d/nginx.conf

# Заменить переменные opcache параметрами из файла .env
envsubst '$APP_PATH' < /usr/local/etc/php/conf.d/opcache-recommended.ini | tee /usr/local/etc/php/conf.d/opcache-recommended-update.ini 2>&1 >/dev/null
mv -f /usr/local/etc/php/conf.d/opcache-recommended-update.ini /usr/local/etc/php/conf.d/opcache-recommended.ini
