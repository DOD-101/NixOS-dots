#!/bin/sh

used_correctly="0"

if [ "$1" = "-c" -o "$1" = "--caps-lock" -o "$2" = "-c" -o "$2" = "--caps-lock" ]; then
	used_correctly="1"
	capslock="$(find -L /sys/class/leds/ -maxdepth 2 -type f -wholename '*/input*::capslock/brightness' 2>/dev/null | xargs awk '{sum+=$1} END {print sum}')"
	if [ "$capslock" != 0 ]; then
		echo 1
	else
		echo 0
	fi
fi

if [ "$1" = "-n" -o "$1" = "--num-lock" -o "$2" = "-n" -o "$2" = "--num-lock" ]; then
	used_correctly="1"
	numslock="$(find -L /sys/class/leds/ -maxdepth 2 -type f -wholename '*/input*::numlock/brightness' 2>/dev/null | xargs awk '{sum+=$1} END {print sum}')"
	if [ "$numslock" != 0 ]; then
		echo 1
	else
		echo 0
	fi
fi

if [ "$used_correctly" = "0" ]; then
	echo "Wrong usage:"
	echo "-c --caps-lock prints capslock state"
	echo "-n --nums-lock prints numlock state"
fi
