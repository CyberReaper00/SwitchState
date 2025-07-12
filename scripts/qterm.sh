#!/usr/bin/env bash

# Launch QTerminal with the first tab
qterminal &

# Wait a moment for QTerminal to open
sleep 2

# Open a new tab (Ctrl+Shift+T)
xdotool type "tmux"
xdotool key "return"

exit 0
