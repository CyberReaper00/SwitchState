#!/usr/bin/env bash

# Launch QTerminal with the first tab
qterminal &

# Wait a moment for QTerminal to open
sleep 2

# Open a new tab (Ctrl+Shift+T)
xdotool key "alt+shift+t"

# Wait a moment for the new tab to be ready
sleep 1

# Type the nvim command in the second tab and press Enter
xdotool type "nvim"
xdotool key "return"

exit 0
