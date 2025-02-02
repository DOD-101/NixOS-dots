#!/bin/sh

volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

if echo "$volume" | grep "MUTED" >/dev/null 2>&1; then
    echo "muted"
else
    echo "$volume" | awk '{printf "%d", $2 * 100 + 0.5}' | tr -d '[]'
fi
