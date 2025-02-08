#!/usr/bin/env sh

time="$(date +%T)"
battery="$(eww get EWW_BATTERY | jq .BAT0.capacity)"

if [ -z "$battery" ]; then
    echo "$time"
else
    echo "$time | $battery%"
fi
