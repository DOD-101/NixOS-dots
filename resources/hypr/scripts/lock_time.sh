#!/usr/bin/env sh

time="$(date +%T)"
battery="$(cat "$HYPRLOCK_BAT_PATH")"

if [ -z "$battery" ]; then
    echo "$time"
else
    echo "$time | $battery%"
fi
