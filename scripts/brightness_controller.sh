#!/usr/bin/env bash

idle=$(( 300 * 1000 ))
br_low="10%"
br_high="100%"
state="normal"

exclude_classes=("vlc" "youtube")

get_focused() {
    win_id=$(xdotool getwindowfocus)
    xprop -id "$win_id" WM_CLASS 2>/dev/null | awk -F '"' '{print $4}'
}

while true; do
    idle_ms=$(xprintidle)
    current_class=$(get_focused)

    echo "Idle: $idle_ms,  State: $state, Focused: $current_class"

    exclude=false
    for class in "${exclude_classes[@]}"; do
	echo "$class"
	if [ "$current_class" == "$class" ]; then
	    exclude=true
	    break
	fi
    done

    if (( idle_ms >= idle )) && [[ "$state" == "normal" ]] && [ "$exclude" == false ]; then
	brightnessctl set "$br_low"
	state="dimmed"
    elif (( idle_ms < idle )) && [[ "$state" == "dimmed" ]]; then
	brightnessctl set "$br_high"
	state="normal"
    fi

    sleep 1
done
