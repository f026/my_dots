current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')

# Увеличиваем или уменьшаем громкость
if [ "$1" == "up" ]; then
    wpctl set-sink-volume @DEFAULT_SINK@ +5%
    new_volume=$(($current_volume + 5))
elif [ "$1" == "down" ]; then
    wpctl set-sink-volume @DEFAULT_SINK@ -5%
    new_volume=$(($current_volume - 5))
else
    echo "Usage: $0 {up|down}"
    exit 1
fi

# Отправляем уведомление
dunstify -u low -h int:value:"$new_volume%" " " 
