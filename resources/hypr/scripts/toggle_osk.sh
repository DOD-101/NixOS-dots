#!/usr/bin/env bash

# @param $1 action The action to perform (get|set)
# @param $2 property The property to perform the action on
# @param $3 value The value to set the property to (true|false)
property() {
    opts=("--user" "${1}-property" "dod.shell.Daemon" "/dod/shell/Daemon" "dod.shell.Daemon.Osk.State" "$2")

    if [[ -n "${3+x}" ]]; then
        opts+=("b" "$3")
    fi

    busctl "${opts[@]}"

}

if property "get" "Active" | grep --silent true; then
    property "set" "ActiveLocked" "false"
    property "set" "Active" "false"
    property "set" "ActiveLocked" "true"
else
    property "set" "ActiveLocked" "false"
    property "set" "Active" "true"
fi
