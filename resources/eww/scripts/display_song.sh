#!/usr/bin/env sh

song="$(playerctl metadata --format '{{ title }} - {{ artist }}')"

last_song="$(config-store get last_song -v)"

if [ "$song" != "$last_song" ]; then
    config-store set last_song -v "$song" >/dev/null
    eww update playing="$(playerctl metadata --format '{{ title }} - {{ artist }}')"
    echo 1
else
    echo 0
fi
