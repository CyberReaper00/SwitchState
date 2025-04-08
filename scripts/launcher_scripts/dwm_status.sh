#!/bin/sh

while true; do
	volume=$(pamixer --get-volume)
	wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
	battery=$(cat /sys/class/power_supply/BAT0/capacity)
	time=$(date '+%d-%m-%Y | %I:%M %p')

    xsetroot -name "   ( Vol: [${volume:-N/A}%] ) ( WIFI: [${wifi:-N/A}] ) ( Batt: [${battery:-N/A}%] ) ( $time )  "
    sleep 1
done
