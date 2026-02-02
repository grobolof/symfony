#!/bin/bash

alert_message "warning" "Проверка на то что Symfony установлен"

if [ ! -d $APP_PATH/public/ ]
then
  alert_message "info" "Установка Symfony"

  # Установить Symfony
  composer create-project symfony/skeleton $APP_PATH && cd $APP_PATH;

  # Отменить добавление рецептов Symfony
  composer config --json extra.symfony.docker 'false'

  # Установить пакеты
  composer require \
  symfony/orm-pack \
  symfony/serializer-pack \
  symfony/monolog-bundle \
  symfony/messenger \
  symfony/scheduler \
  symfony/security-bundle \
  symfony/validator \
  symfony/twig-bundle \
  symfony/asset \
  php-ds/php-ds

  composer require --dev \
  maker-bundle \
  orm-fixtures \
  profiler

  # Установить полные права на все папки и файлы
  chmod -R 777 .
fi

alert_message "success" "Symfony успешно установлен"
