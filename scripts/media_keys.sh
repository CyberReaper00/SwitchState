#!/usr/bin/env bash

step="50%"

case "$1" in
    "up")
	pactl set-sink-volume @DEFAULT_SINK@ "+${step}"
	crnt_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%')
	xsetroot -name "Volume: ${crnt_vol}"
	sleep 2
	;;
    "down")
	pactl set-sink-volume @DEFAULT_SINK@ "-${step}"
	crnt_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%')
	xsetroot -name "Volume: ${crnt_vol}"
	sleep 2
	;;
    "mute")
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	mute_sts=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
	if [ "$mute_sts" = "yes" ]; then
	    xsetroot -name "Volume: Muted"
	    sleep 2
	else
	    crnt_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%')
	    xsetroot -name "Volume: ${crnt_vol}"
	    sleep 2
	fi
	;;
    *)
	xsetroot -name "Volume didnt change"
	exit 1
	;;
esac
