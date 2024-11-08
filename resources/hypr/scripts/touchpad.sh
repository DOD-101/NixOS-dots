#!/usr/bin/env sh

var_name="hyprbind_touchpad"

if [ $(config-store check "$var_name") = "false" ]; then
    config-store set "$var_name" --value "false" --alternate "true"
    hyprctl keyword '$touchpadEnabled' "false" -r
else
    if [ $(config-store toggle "$var_name") = "true" ]; then
        hyprctl keyword '$touchpadEnabled' "false" -r
    else
        hyprctl keyword '$touchpadEnabled' "true" -r
    fi
fi
