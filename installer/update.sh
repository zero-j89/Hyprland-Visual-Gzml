#!/usr/bin/env bash

set -e

APP_NAME="GZML Visual Tools"
REPO_URL="https://github.com/zero-j89/Hyprland-Visual-Gzml.git"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Updating $APP_NAME..."
echo

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required."
    exit 1
fi

echo "Stopping running instance..."
pkill -f gzml-tray.py 2>/dev/null || true
pkill -f gzml-visual-tools 2>/dev/null || true

echo "Downloading latest version..."
git clone --depth=1 "$REPO_URL" "$TMP_DIR/Hyprland-Visual-Gzml"

cd "$TMP_DIR/Hyprland-Visual-Gzml"

if [ ! -f "installer/install.sh" ]; then
    echo "Error: installer/install.sh not found."
    exit 1
fi

echo "Running installer..."
chmod +x installer/install.sh
./installer/install.sh

echo
echo "$APP_NAME updated successfully."
echo
echo "Launch with:"
echo "  gzml-visual-tools"
