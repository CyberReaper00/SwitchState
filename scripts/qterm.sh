#!/usr/bin/env bash

# Launch QTerminal with the first tab
qterminal &
sleep 2

xdotool key "alt+shift+t"
sleep 1

xdotool type "nvim"
xdotool key "return"

exit 0
