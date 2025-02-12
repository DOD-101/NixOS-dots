#!/bin/sh

if [ -n "$(ip route | grep "$1")" ]; then
    echo "wifi"
elif [ -n "$(ip route | grep "$2")" ]; then
    echo "ethernet"
else
    echo "none"
fi
