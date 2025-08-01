#!/bin/bash
while read -r event; do
    if [[ $event == *"layout"* ]]; then
        pkill -RTMIN+2 waybar  # Сигнал Waybar на обновление
    fi
done < <(hyprctl -j devices | jq -r '.keyboards[] | .layout')
