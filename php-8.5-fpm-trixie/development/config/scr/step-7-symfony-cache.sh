#!/bin/bash

alert_message "info" "Очистить/прогреть кэш"

php bin/console cache:clear && php bin/console cache:warmup
