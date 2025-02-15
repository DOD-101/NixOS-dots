#!/usr/bin/env bash

letter="$1"
shift_letter="$2"

osk_shift="$(eww get osk_shift)"

if [ "$osk_shift" == "true" ]; then
    wtype -M capslock -- "$shift_letter"
    eww update osk_shift=false
    exit 0
fi

wtype -- "$letter"
