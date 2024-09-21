#!/bin/sh

total="$(cat /proc/meminfo | awk '/MemTotal:/ {print($2)}')"
available="$(cat /proc/meminfo | awk '/MemAvailable:/ {print($2)}')"

# Perform arithmetic operations to divide by 1 million
total_GB=$((total / 1000000))
available_GB=$((available / 1000000))

used_GB=$((total_GB - available_GB))
# Echo the results
echo "$total_GB""GB/""$used_GB""GB"