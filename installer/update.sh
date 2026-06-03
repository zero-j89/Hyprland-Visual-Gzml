#!/usr/bin/env bash

set -e

APP_NAME="GZML Visual Tools"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Updating $APP_NAME..."
echo

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required."
    exit 1
fi

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: this folder is not a git clone."
    echo "Run this from the direct clone install script of Hyprland-Visual-Gzml."
    exit 1
fi

cd "$REPO_DIR"

echo "Stopping running instance..."
pkill -f gzml-tray.py 2>/dev/null || true
pkill -f gzml-visual-tools 2>/dev/null || true

echo "Pulling latest changes..."
git pull

echo "Running installer..."
chmod +x "$REPO_DIR/installer/install.sh"
"$REPO_DIR/installer/install.sh"

echo
echo "$APP_NAME updated successfully."
echo "Launch with:"
echo "  gzml-visual-tools"
