#!/bin/bash

alert_message() {
    local type="$1"
    local message="$2"
    local COLS=$(tput cols 2>/dev/null) || COLS=80  # fallback если tput недоступен
    local RESET='\033[0m'

    local color
    local prefix

    case "$type" in
        "error")
            color='\033[0;41m'  # Красный фон
            prefix="[ОШИБКА] "
            ;;
        "warning")
            color='\033[0;43m'  # Желтый фон
            prefix="[ВНИМАНИЕ] "
            ;;
        "info")
            color='\033[0;44m'  # Синий фон
            prefix="[ИНФО] "
            ;;
        "success")
            color='\033[0;42m'  # Зеленый фон
            prefix="[УСПЕХ] "
            ;;
        *)
            color='\033[0;47m'  # Белый фон
            prefix=""
            ;;
    esac

    local full_text="${prefix}${message}"
    local text_length=${#full_text}
    local spaces=$((COLS - text_length))

    printf "${color}%s%${spaces}s${RESET}\n" "$full_text" ""
}
