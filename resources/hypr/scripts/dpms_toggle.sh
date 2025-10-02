#!/usr/bin/env bash

if ! { [ "$1" == "on" ] || [ "$1" == "off" ] || [ -z "$1" ]; }; then
    echo "Usage: $0 [on|off]"
    exit 1
fi

action="$1"

if [ -z "$action" ]; then
    if hyprctl monitors -j | jq ".[] | .dpmsStatus" | grep -q "false"; then
        action="on"
    else
        action="off"
    fi
fi

hyprctl dispatch dpms "$action"

if which polychromatic-cli >/dev/null 2>/dev/null; then
    if [ "$action" = "on" ]; then
        brightness=100
    else
        brightness=0
    fi

    polychromatic-cli -d keyboard -o brightness -p "$brightness"
    polychromatic-cli -d mouse -o brightness -p "$brightness"
fi
