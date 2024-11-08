#!/usr/bin/env sh

var_name="hyprbind_display"

if [ $(config-store check "$var_name") = "false" ]; then
    config-store set "$var_name" --value "false" --alternate "true"
    hyprctl dispatch dpms off
else
    if [ $(config-store toggle "$var_name") = "true" ]; then
        hyprctl dispatch dpms on
    else
        hyprctl dispatch dpms off
    fi
fi
