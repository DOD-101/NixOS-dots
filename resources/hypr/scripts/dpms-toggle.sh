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

hyprctl dispatch "hl.dsp.dpms({ action = \"$action\" })"

if busctl --user status org.razer >/dev/null 2>/dev/null; then
    if [ "$action" = "on" ]; then
        brightness=100
    else
        brightness=0
    fi

    for device in $(busctl tree --user org.razer |
        awk '/\/org\/razer\/device\// {print $NF}'); do
        busctl call --user \
            org.razer \
            "$device" \
            razer.device.lighting.brightness \
            setBrightness \
            d "$brightness"
    done
fi
