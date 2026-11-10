#!/usr/bin/env bash

YELLOW_BOLD="\e[1;33m"
RED_BOLD="\e[1;31m"
RESET="\e[0m"

DIR="$HOME/Sync/md-notes/"

error() {
  echo -e "${RED_BOLD}Error:${RESET} $1"
}

warn() {
  echo -e "${YELLOW_BOLD}Warning:${RESET} $1"
}

countdown() {
  local secs=${1:-4} key remaining
  local end=$((SECONDS + secs))

  while (((remaining = end - SECONDS) > 0)); do
    printf '\rProceeding in %d... (press Enter or Space to skip) ' "$remaining"
    if read -t 1 -n 1 -s -r key; then
      [[ -z $key || $key == " " ]] && break
    fi
  done

  printf '\r\033[K' # clear the countdown line
}

if [ ! -d "$DIR" ]; then
  error "$DIR doesn't exists. Ensure it does."
fi

shopt -s nullglob # unmatched globs expand to nothing instead of the literal pattern
files=("$DIR"Todo.sync-conflict-*.md)
shopt -u nullglob

if [ ${#files[@]} -ne 0 ]; then
  warn "Found ${#files[@]} conflicting Todo file(s):"
  printf '%s\n' "${files[@]}"

  echo ""

  countdown 5
fi

$EDITOR "${DIR}Todo.md"
