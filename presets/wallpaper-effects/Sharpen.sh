#!/usr/bin/env bash
# Wallpaper EffectZ - Sharpen

QS_DIR="$HOME/.config/quickshell-noctalia"
IDIR="$HOME/.config/swaync/images"

focused_monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

cache_dir="$HOME/.cache/gzml/wallpaper-effects"
mkdir -p "$cache_dir"

original_file="$cache_dir/original_${focused_monitor}.txt"
wallpaper_output="$cache_dir/sharpen_${focused_monitor}.png"

current_wallpaper="$(qs -p "$QS_DIR" ipc call wallpaper get "$focused_monitor" | tail -n1)"

if [[ -z "$current_wallpaper" || ! -f "$current_wallpaper" ]]; then
    notify-send -u normal -i "$IDIR/error.png" "Wallpaper EffectZ" "Could not read current wallpaper"
    exit 1
fi

if [[ "$current_wallpaper" != "$cache_dir/"* ]]; then
    printf '%s\n' "$current_wallpaper" > "$original_file"
fi

if [[ ! -f "$original_file" ]]; then
    printf '%s\n' "$current_wallpaper" > "$original_file"
fi

wallpaper_original="$(cat "$original_file")"

if [[ -z "$wallpaper_original" || ! -f "$wallpaper_original" ]]; then
    notify-send -u normal -i "$IDIR/error.png" "Wallpaper EffectZ" "Could not read original wallpaper"
    exit 1
fi

rm -f "$wallpaper_output"

magick "$wallpaper_original" -sharpen 0x5 "$wallpaper_output"

if [[ ! -f "$wallpaper_output" ]]; then
    notify-send -u normal -i "$IDIR/error.png" "Wallpaper EffectZ" "Failed to create Sharpen effect"
    exit 1
fi

# Noctalia / Quickshell
qs -p "$QS_DIR" ipc call wallpaper set "$wallpaper_output" "$focused_monitor"

# AWWW
# awww img --outputs "$focused_monitor" "$wallpaper_output"

wallust run "$wallpaper_output" -s

notify-send -u low -i "$IDIR/ja.png" "Wallpaper EffectZ" "Sharpen applied"
