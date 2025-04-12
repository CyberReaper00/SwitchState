#!/bin/sh

while true; do
    battery=$(cat /sys/class/power_supply/BAT0/capacity)%
    volume=$(pamixer --get-volume)
    wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    time=$(date +"%d-%m-%Y | %I:%M:%S %p")
    xsetroot -name "( 🔊 [${volume:-N/A}%] ) ( 📶 [${wifi:-N/A}] ) ( 🔋 [${battery:-N/A}] ) ( 🕒 [${time:-N/A}] )"
    sleep 1
done
