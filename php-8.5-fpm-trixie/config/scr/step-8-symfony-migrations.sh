#!/bin/bash

alert_message "info" "Накатить миграции"

php bin/console doctrine:migrations:migrate -n
