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

echo "Add this after your normal Hyprland Lua animation config:"
echo
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/animations.lua")'
echo
echo "Add this after your normal Hyprland Lua decoration config:"
echo
echo '  dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")'
echo
echo "Add this to your Hyprland Lua startup config:"
echo
echo '  hl.exec_cmd("pgrep -f gzml-visual-tools >/dev/null || gzml-visual-tools")'
echo
echo "You can launch it manually with:"
echo
echo "  gzml-visual-tools"
