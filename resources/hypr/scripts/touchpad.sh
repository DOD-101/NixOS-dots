#!/bin/bash

export STATUS_FILE="$XDG_RUNTIME_DIR/keyboard.status"

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    hyprctl keyword '$touchpadEnabled' "true" -r
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    hyprctl keyword '$touchpadEnabled' "false" -r
}

if ! [ -f "$STATUS_FILE" ]; then
    enable_touchpad
else
    if [ $(cat "$STATUS_FILE") = "true" ]; then
        disable_touchpad
    elif [ $(cat "$STATUS_FILE") = "false" ]; then
        enable_touchpad
    fi
fi
