#!/bin/bash

alert_message "warning" "Проверка на то что Composer установлен"

composer --version

if [ $? -ne 0 ]; then
    alert_message "info" "Установка Composer"

    git clone https://github.com/composer/composer.git /composer
    cd /composer

    TAGS_STRING=$(git tag)

    # region Убрать пробелы
    TAGS_STRING=$(echo "$TAGS_STRING" | sed 's/^ *//g')
    # endregion

    # region Заменить переносы строк на «||»
    TAGS_STRING=${TAGS_STRING//$'\n'/\||}
    # endregion

    # region Разбить строку на массив по разделителю
    IFS='||' read -r -a TAGS_EMPTY_LINES <<< "$TAGS_STRING"
    # endregion

    # region Убрать пустые строки из массива
    for TAG in "${TAGS_EMPTY_LINES[@]}"; do
      if [[ -n "$TAG" ]]; then
        TAGS+=("$TAG")
      fi
    done
    # endregion

    # region Перевернуть массив
    reverse() {
        # first argument is the array to reverse
        # second is the output array
        declare -n arr="$1" rev="$2"
        for i in "${arr[@]}"
        do
            rev=("$i" "${rev[@]}")
        done
    }

    reverse TAGS TAGS_REVERSE
    # endregion

    for TAG in "${TAGS_REVERSE[@]}"
    do
        FIRST_CHARACTER=${TAG:0:1}

        if [[ $FIRST_CHARACTER -gt 1 ]] && [[ $TAG =~ ^[0-9.]+$ ]]
        then
            wget https://github.com/composer/composer/releases/download/$TAG/composer.phar
            chmod 755 composer.phar
            mv composer.phar /usr/local/bin/composer
            break
        fi
    done

    rm -rf /composer
    cd $APP_PATH
fi

alert_message "success" "Composer успешно установлен"
