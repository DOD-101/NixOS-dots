#!/bin/sh

if [ -n "$(hyprctl getoption general:layout | grep master)" ]; then 
    hyprctl keyword general:layout "dwindle"
else 
    hyprctl keyword general:layout "master"
fi
