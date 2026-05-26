#!/usr/bin/env bash

# GZML Blur Levels
# 0 = off
# 1-10 = increasing blur strength

notif="$HOME/.config/swaync/images/ja.png"

level="${1:-}"

if [[ -z "$level" ]]; then
  level="$(printf '%s\n' 0 1 2 3 4 5 6 7 8 9 10 | rofi -dmenu -p 'Blur Level')"
fi

[[ "$level" =~ ^([0-9]|10)$ ]] || exit 1

if [[ "$level" == "0" ]]; then
  hyprctl eval 'hl.config({ decoration = { blur = { enabled = false } } })'
  notify-send -e -u low -i "$notif" "GZML Blur" "Blur disabled"
else
  hyprctl eval "hl.config({ decoration = { blur = { enabled = true, size = $level } } })"
  notify-send -e -u low -i "$notif" "GZML Blur" "Blur level $level applied"
fi
