#!/bin/sh

# amixer -D pulse sget Master | awk -F '[^0-9]+' '/Front Left:/{print $3}'
wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2 * 100 + 0.5}' | tr -d '[]'
