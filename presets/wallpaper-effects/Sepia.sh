#!/usr/bin/env bash
# Wallpaper EffectZ - Sepia Tone

QS_DIR="$HOME/.config/quickshell-noctalia"
IDIR="$HOME/.config/swaync/images"

focused_monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

cache_dir="$HOME/.cache/gzml/wallpaper-effects"
mkdir -p "$cache_dir"

original_file="$cache_dir/original_${focused_monitor}.txt"
wallpaper_output="$cache_dir/wallpaper_modified_${focused_monitor}.png"

current_wallpaper="$(qs -p "$QS_DIR" ipc call wallpaper get "$focused_monitor" | tail -n1)"

if [[ "$current_wallpaper" != "$cache_dir/"* ]]; then
    printf '%s\n' "$current_wallpaper" > "$original_file"
fi

wallpaper_original="$(cat "$original_file")"

rm -f "$wallpaper_output"

magick "$wallpaper_original" -sepia-tone 65% "$wallpaper_output"

# Noctalia / Quickshell
qs -p "$QS_DIR" ipc call wallpaper set "$wallpaper_output" "$focused_monitor"

# AWWW
# awww img --outputs "$focused_monitor" "$wallpaper_output"

wallust run "$wallpaper_output" -s

notify-send -u low -i "$IDIR/ja.png" "Wallpaper EffectZ" "Sepia Tone applied"
