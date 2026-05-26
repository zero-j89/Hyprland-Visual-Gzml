#!/usr/bin/env bash
# Wallpaper EffectZ - Disable / Restore Original

QS_DIR="$HOME/.config/quickshell-noctalia"
IDIR="$HOME/.config/swaync/images"

focused_monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

cache_dir="$HOME/.cache/gzml/wallpaper-effects"
mkdir -p "$cache_dir"

original_file="$cache_dir/original_${focused_monitor}.txt"

if [[ ! -f "$original_file" ]]; then
    notify-send -u normal -i "$IDIR/error.png" "Wallpaper EffectZ" "No original wallpaper found"
    exit 1
fi

wallpaper_original="$(cat "$original_file")"

if [[ -z "$wallpaper_original" || ! -f "$wallpaper_original" ]]; then
    notify-send -u normal -i "$IDIR/error.png" "Wallpaper EffectZ" "Original wallpaper missing"
    exit 1
fi

# Wallpaper handler
# Default: Noctalia / Quickshell
qs -p "$QS_DIR" ipc call wallpaper set "$wallpaper_original" "$focused_monitor"

# AWWW users:
# Comment the qs line above, then uncomment this:
# awww img --outputs "$focused_monitor" "$wallpaper_original"

wallust run "$wallpaper_original" -s

notify-send -u low -i "$IDIR/ja.png" "Wallpaper EffectZ" "Original wallpaper restored"
