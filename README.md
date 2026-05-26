
# GZML Visual Tools
<img width="941" height="800" alt="Screenshot_25-May_23-08-19_13914" src="https://github.com/user-attachments/assets/7ec0ad9c-c2d3-439b-97e9-2a21649c6cf0" />


GZML Visual Tools is a lightweight system tray application for Hyprland that provides quick access to visual customization features without requiring users to constantly edit configuration files.

The project was originally built for my own desktop workflow but has since grown into a modular customization toolkit focused on Hyprland's modern Lua configuration system.

Using the tray menu, users can:

- Switch animation presets
- Apply wallpaper effects
- Adjust blur intensity
- Adjust border sizes
- Import custom presets
- Reload Hyprland
- Manage visual settings from a single location

Most functionality is handled through small, readable scripts that can easily be modified or expanded by users.

The long-term goal is to provide a centralized visual management utility for Hyprland while remaining lightweight, modular, and easy to customize.

---
<img width="1038" height="1081" alt="Screenshot_25-May_23-08-56_15981" src="https://github.com/user-attachments/assets/3cd6de8c-e84c-4f93-a656-3fa1a9a21637" />

## Why GZML Visual Tools?

Many Hyprland users enjoy tweaking their desktops, but even simple changes often require:

- Editing configuration files
- Reloading Hyprland

- Remembering configuration syntax
- Searching through multiple folders

GZML Visual Tools reduces that friction by exposing commonly modified visual settings through an easy-to-access tray interface.

Instead of editing configuration files every time you want to experiment, most actions can be performed directly from the tray.

---

## Current Features

---

### 🎞 Animations

Load and switch between Hyprland animation presets directly from the tray.

- Active preset checkmark support
- One-click Hyprland reload
- Lua preset support
- Easy preset expansion

---
<img width="1114" height="1075" alt="Screenshot_25-May_23-09-05_25541" src="https://github.com/user-attachments/assets/f3ae0a1f-3346-4078-8330-712fc5343ec5" />

### 🖼 Wallpaper Effects

Apply ImageMagick-powered wallpaper effects directly from the tray.

Current effects include:

- Black & White
- Charcoal
- Edge Detect
- Emboss
- Frame Raised
- Frame Sunk
- Negate
- Oil Paint
- Posterize
- Polaroid
- Sepia Tone
- Sharpen
- Solarize
- Vignette
- Vignette Black
- Zoomed

Wallpaper effects are self-contained scripts and can easily be modified, replaced, or expanded by users.

---
<img width="1174" height="990" alt="Screenshot_25-May_23-09-16_31430" src="https://github.com/user-attachments/assets/4e2cd2aa-bdf1-4a3a-8a9d-063aff630b16" />

### 🌫 Blur Controls

Control Hyprland blur levels directly from the tray.

Available levels:

```text
Off
Level 1
Level 2
Level 3
Level 4
Level 5
```

---
<img width="853" height="741" alt="Screenshot_25-May_23-03-56_24873" src="https://github.com/user-attachments/assets/4c6ad1eb-b7a6-4a47-b265-d58b7e7c0bf4" />
### 🔲 Border Controls

Adjust Hyprland border size without manually editing configuration files.

```text
1px - 10px
```

---

### 📦 Preset Injector

Import custom presets directly from the tray.

Supports:

- Animations
- Wallpaper Effects
- Themes
- Tools

---

## Requirements

### Required

- Python 3
- python-gobject
- GTK3
- AppIndicator3
- Hyprland
- ImageMagick
- wallust
- jq

### Optional

- Noctalia Shell
- AWWW
- GZML Shell

---

# Hyprland Lua Setup

GZML Visual Tools was designed around the newer Hyprland Lua configuration system.

To enable Blur Controls, add the following line **after your normal decoration configuration has loaded**.

Example:

```lua
dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")
```

This should generally be placed at the end of your decorations configuration so GZML overrides are applied last.

---

# Startup

Example using the Hyprland Lua startup system:

```lua
hl.on("hyprland.start", function()
   hl.exec_cmd(os.getenv("HOME") .. "/Projects/gzml-plugin/gzml-visual-tools/gzml-tray.py")
end)
```

Future installer releases will automatically create a launcher command, eliminating the need for manual path editing.

---

# Wallpaper Handler Support

Wallpaper effects default to Noctalia Shell.

Each wallpaper effect script contains handler lines similar to:

```bash
# Noctalia / Quickshell
qs -p "$QS_DIR" ipc call wallpaper set "$wallpaper_output" "$focused_monitor"

# AWWW
# awww img --outputs "$focused_monitor" "$wallpaper_output"
```

If you use AWWW instead of Noctalia:

1. Comment out the Noctalia line.
2. Uncomment the AWWW line.

This keeps wallpaper effects portable across different Hyprland setups.

---

# Project Philosophy

GZML Visual Tools is intentionally simple.

Rather than requiring large desktop frameworks or complicated configuration systems, most functionality is exposed through small standalone scripts that can be modified and extended by the user.

The goal is:

- Flexibility
- Readability
- Simplicity
- Ease of customization

---

# About The Author

My name is J (zer0-j89).

I am primarily a mycologist and technology enthusiast who began my Linux journey with Arch Linux roughly six months ago.

GZML Visual Tools started as a personal learning project to explore:

- Python
- GTK
- Hyprland Lua
- Linux desktop customization

while creating something useful for both myself and the wider Hyprland community.
This project remains a work in progress and will continue evolving as I learn.

---

# Current Status

```text
GZML Visual Tools
Version: 0.1
Author: zer0-j89
Status: Work In Progress
```

---

# Roadmap

## Planned

- Automatic dependency detection
- Theme management
- Additional wallpaper effects
- Additional visual controls
- Improved tray interactions
- Better support for non-Noctalia environments

---
<img width="2560" height="1440" alt="Screenshot_25-May_23-03-38_20800" src="https://github.com/user-attachments/assets/dc4f5f03-4b90-47e5-ad10-8c7a0ce2d9f0" />

# License

License selection is still pending.

Until an official license is chosen, please provide credit to the original project and contributors when redistributing or modifying substantial portions of the code.

> ⚠️ Early Release Notice
>
> GZML Visual Tools is currently in active development.
> Expect bugs, rough edges, and occasional breaking changes between versions.
