#!/usr/bin/env bash

set -u

last_layout=""

while true; do
    current_layout=$(
        hyprctl devices 2>/dev/null |
        grep -B 5 "main: yes" |
        grep "active keymap:" |
        head -n 1 |
        awk -F ': ' '{print $2}'
    )

    case "$current_layout" in
        "English (US)"|"English"|"en_US"|"us")
            layout_name="EN"
            ;;
        "Russian"|"ru_RU"|"ru")
            layout_name="RU"
            ;;
        *)
            layout_name="$current_layout"
            ;;
    esac

    if [[ -n "$layout_name" && "$layout_name" != "$last_layout" ]]; then
        printf '%s\n' "$layout_name"
        last_layout="$layout_name"
    fi

    sleep 0.5
done
