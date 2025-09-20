#!/usr/bin/env sh

time="$(date +%T)"
battery="$(cat "/sys/class/power_supply/@HYPRLOCK_BATTERY@/capacity")"

if [ -z "$battery" ]; then
    echo "$time"
else
    echo "$time | $battery%"
fi
