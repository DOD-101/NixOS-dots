#!/bin/sh

eval img_path="~/.config/eww/current_cover.png"

playerctl metadata | awk '/mpris:artUrl/ {print( $3) }' | xargs -I {} curl "{}" -o "$img_path"

echo "$img_path"
