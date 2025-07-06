#!/usr/bin/env bash

for pid in $(pgrep -u "$USER"); do
    if grep -q "DISPLAY=" "/proc/$pid/environ" 2>/dev/null; then
	kill -15 "$pid"
    fi
done

sleep 5

for pid in $(pgrep -u "$USER"); do
    if grep -q "DISPLAY=" "/proc/$pid/environ" 2>/dev/null; then
	kill -9 "$pid"
    fi
done
