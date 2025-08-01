#!/bin/bash
# Получаем сырое сообщение от hyprctl
raw_msg=$(hyprctl switches -j)

# Извлекаем раскладку (вариант для формата "keyboard,layout")
layout=$(echo "$raw_msg" | grep -oP 'activelayout>>[^,]*,\K\w+')

# Альтернативный вариант, если предыдущий не сработает
if [ -z "$layout" ]; then
    layout=$(echo "$raw_msg" | jq -r '.keyboardLayout' | awk -F',' '{print $NF}')
fi

# Преобразуем в короткий формат
case "$layout" in
    "Russian") echo "RU" ;;
    "English") echo "EN" ;;
    *) echo "??" ;;
esac
