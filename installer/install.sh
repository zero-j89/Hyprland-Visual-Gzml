#!/usr/bin/env bash

set -e

APP_NAME="GZML Visual Tools"
INSTALL_DIR="$HOME/.local/share/gzml-visual-tools"
CONFIG_DIR="$HOME/.config/gzml-visual-tools"
BIN_DIR="$HOME/.local/bin"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing $APP_NAME..."
echo

if ! command -v pacman >/dev/null 2>&1; then
    echo "This installer currently supports Arch-based systems only."
    echo "Install dependencies manually, then re-run this script."
    exit 1
fi

echo "Checking required packages..."

REQUIRED_PACKAGES=(
    python
    python-gobject
    gtk3
    libappindicator-gtk3
    jq
    imagemagick
    libnotify
    git
)

MISSING_PACKAGES=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if (( ${#MISSING_PACKAGES[@]} > 0 )); then
    echo
    echo "Missing packages:"
    printf '  - %s\n' "${MISSING_PACKAGES[@]}"
    echo
    echo "Installing missing packages..."
    sudo pacman -S --needed "${MISSING_PACKAGES[@]}"
else
    echo "All required packages are installed."
fi

if ! command -v wallust >/dev/null 2>&1; then
    echo
    echo "WARNING: wallust was not found."
    echo "Wallpaper effects may not fully update colors without it."
fi

echo
echo "Creating directories..."

mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR/hypr"
mkdir -p "$BIN_DIR"

echo "Copying files..."

rm -rf "$INSTALL_DIR/assets"
rm -rf "$INSTALL_DIR/presets"
rm -f "$INSTALL_DIR/gzml-tray.py"

cp -r "$SCRIPT_DIR/assets" "$INSTALL_DIR/"
cp -r "$SCRIPT_DIR/presets" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/gzml-tray.py" "$INSTALL_DIR/"

chmod +x "$INSTALL_DIR/gzml-tray.py"

find "$INSTALL_DIR/presets" -type f -name "*.sh" -exec chmod +x {} \;

echo "Creating launcher..."

cat > "$BIN_DIR/gzml-visual-tools" << EOF
#!/usr/bin/env bash
exec "$INSTALL_DIR/gzml-tray.py"
EOF

chmod +x "$BIN_DIR/gzml-visual-tools"

echo "Creating updater launcher..."

cat > "$BIN_DIR/gzml-visual-tools-update" << 'EOF'
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
    echo "Error: git is required to update $APP_NAME."
    exit 1
fi

echo "Stopping running instance..."
pkill -f "$HOME/.local/share/gzml-visual-tools/gzml-tray.py" 2>/dev/null || true
echo "Downloading latest version..."
git clone --depth=1 "$REPO_URL" "$TMP_DIR/Hyprland-Visual-Gzml"

cd "$TMP_DIR/Hyprland-Visual-Gzml"

if [[ ! -f installer/install.sh ]]; then
    echo "Error: installer/install.sh not found in downloaded repo."
    exit 1
fi

echo "Running installer..."
chmod +x installer/install.sh
./installer/install.sh

echo
echo "$APP_NAME updated successfully."
echo
echo "Launch with:"
echo
echo "  gzml-visual-tools"
EOF

chmod +x "$BIN_DIR/gzml-visual-tools-update"

echo "Creating generated Hyprland config files..."

if [[ ! -f "$CONFIG_DIR/hypr/animations.lua" ]]; then
    cat > "$CONFIG_DIR/hypr/animations.lua" << 'EOF'
-- Generated/managed by GZML Visual Tools.
-- Animation presets selected from the tray will be copied here.

EOF
fi

if [[ ! -f "$CONFIG_DIR/hypr/blur.lua" ]]; then
    cat > "$CONFIG_DIR/hypr/blur.lua" << 'EOF'
-- Generated/managed by GZML Visual Tools.
-- Add this file after your normal Hyprland Lua decoration config:
-- dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")

hl.config({
  decoration = {
    blur = {
      enabled = false,
      size = 2,
      passes = 1,

      new_optimizations = true,
      xray = true,
      ignore_opacity = true,
      special = true,
      popups = true,
    },
  },
})
EOF
fi

echo
echo "Launching GZML Visual Tools..."

if pgrep -f "gzml-visual-tools" >/dev/null 2>&1; then
    echo "GZML Visual Tools already appears to be running."
else
    setsid -f "$BIN_DIR/gzml-visual-tools" >/dev/null 2>&1
fi

echo
echo "Installation complete."
echo

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *)
        echo "WARNING: ~/.local/bin is not currently in your PATH."
        echo "Add it to your shell config if gzml-visual-tools is not found."
        echo
        ;;
esac

echo "Add this after your Hyprland animation.lua config file:"
echo
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/animations.lua")'
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")'
echo
echo "Add this after your normal Hyprland decoration.lua if you have two seperate files:"
echo
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/animations.lua")'
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")'
echo
echo "Add this to your Startup config:"
echo
echo '  hl.exec_cmd("gzml-visual-tools")'
echo
echo "You can launch it manually with:"
echo
echo "  gzml-visual-tools"
echo
echo "You can update it with:"
echo
echo "  gzml-visual-tools-update"
