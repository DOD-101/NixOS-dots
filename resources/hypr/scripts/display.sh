#!/bin/bash

export STATUS_FILE="$XDG_RUNTIME_DIR/display.status"

enable_display() {
    printf "true" >"$STATUS_FILE"
    hyprctl dispatch dpms on
}

disable_display() {
    printf "false" >"$STATUS_FILE"
    hyprctl dispatch dpms off
}

if ! [ -f "$STATUS_FILE" ]; then
    display_display
else
    if [ $(cat "$STATUS_FILE") = "true" ]; then
        disable_display
    elif [ $(cat "$STATUS_FILE") = "false" ]; then
        enable_display
    fi
fi
