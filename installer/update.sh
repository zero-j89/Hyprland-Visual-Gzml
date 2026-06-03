#!/usr/bin/env bash

set -e

APP_NAME="GZML Visual Tools"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$REPO_DIR/installer/install.sh"

echo "Checking for $APP_NAME updates..."
echo

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required."
    exit 1
fi

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: this folder is not a git clone."
    echo "Please update manually from the GitHub repo."
    exit 1
fi

cd "$REPO_DIR"

echo "Fetching latest changes..."
git fetch

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse @{u})"

if [ "$LOCAL" = "$REMOTE" ]; then
    echo
    echo "$APP_NAME is already up to date."
    exit 0
fi

echo
echo "Update found."
echo

echo "Stopping running instance..."
pkill -f gzml-tray.py 2>/dev/null || true
pkill -f gzml-visual-tools 2>/dev/null || true

echo "Pulling latest version..."
git pull --ff-only

if [ ! -f "$INSTALLER" ]; then
    echo "Error: installer not found at:"
    echo "  $INSTALLER"
    exit 1
fi

echo "Running installer..."
chmod +x "$INSTALLER"
"$INSTALLER"

echo
echo "$APP_NAME updated successfully."
echo
echo "Launch with:"
echo "  gzml-visual-tools"
