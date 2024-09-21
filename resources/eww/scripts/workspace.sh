#!/bin/sh
ACTIVEWORKSPACE=$(hyprctl activeworkspace | awk '{print $3; exit}')
echo $ACTIVEWORKSPACE