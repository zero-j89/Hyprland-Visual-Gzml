#!/usr/bin/env python3

import os
import sys
import subprocess
from pathlib import Path
from shutil import copy2

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib, Gdk, GdkPixbuf

try:
    gi.require_version("AppIndicator3", "0.1")
    from gi.repository import AppIndicator3
    HAS_APPINDICATOR = True
except (ImportError, ValueError):
    AppIndicator3 = None
    HAS_APPINDICATOR = False


APP_ID = "gzml-visual-tools"
APP_DIR = Path(__file__).resolve().parent
PRESETS_DIR = APP_DIR / "presets"
ICON_PATH = APP_DIR / "assets" / "gzml.png"
LOCK_FILE = Path("/tmp/gzml-visual-tools.lock")

STATE_DIR = APP_DIR / ".state"
GZML_CONFIG_DIR = Path.home() / ".config/gzml-visual-tools/hypr"

GZML_ANIMATION_FILE = GZML_CONFIG_DIR / "animations.lua"
GZML_BLUR_FILE = GZML_CONFIG_DIR / "blur.lua"

ACTIVE_ANIMATION_FILE = GZML_ANIMATION_FILE
ACTIVE_BLUR_FILE = STATE_DIR / "active_blur_level"
ACTIVE_BORDER_FILE = STATE_DIR / "active_border_size"
ACTIVE_WALLPAPER_FILE = STATE_DIR / "active_wallpaper_preset"
ACTIVE_THEME_FILE = STATE_DIR / "active_theme_preset"
ACTIVE_TOOL_FILE = STATE_DIR / "active_tool_preset"

SUPPORTED_EXTENSIONS = (".sh", ".lua")

ANIMATION_INCLUDE_LINE = 'dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/animations.lua")'
BLUR_INCLUDE_LINE = 'dofile(os.getenv("HOME") .. "/.config/gzml-visual-tools/hypr/blur.lua")'


class GZMLTray:
    def __init__(self):
        self.indicator = None
        self.status_icon = None

        self.root_menu = Gtk.Menu()
        self.animation_menu = Gtk.Menu()
        self.wallpaper_menu = Gtk.Menu()
        self.theme_menu = Gtk.Menu()
        self.tools_menu = Gtk.Menu()
        self.blur_menu = Gtk.Menu()
        self.borders_menu = Gtk.Menu()

        self.control_center = None
        self.blur_apply_source = None
        self._control_center_building = False

        self.ensure_single_instance()
        self.ensure_generated_config_files()
        self.setup_tray()
        self.build_root_menu()

    def ensure_single_instance(self):
        if LOCK_FILE.exists():
            try:
                old_pid = int(LOCK_FILE.read_text().strip())
                os.kill(old_pid, 0)
                print(f"{APP_ID} already running with PID {old_pid}")
                sys.exit(0)
            except (ValueError, ProcessLookupError):
                LOCK_FILE.unlink(missing_ok=True)
        LOCK_FILE.write_text(str(os.getpid()))

    def cleanup_lock(self):
        try:
            if LOCK_FILE.exists() and LOCK_FILE.read_text().strip() == str(os.getpid()):
                LOCK_FILE.unlink(missing_ok=True)
        except Exception:
            pass

    def quit(self, *_):
        self.cleanup_lock()
        Gtk.main_quit()

    def ensure_generated_config_files(self):
        GZML_CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        STATE_DIR.mkdir(parents=True, exist_ok=True)

        created_files = []

        if not GZML_ANIMATION_FILE.exists():
            GZML_ANIMATION_FILE.write_text(
                "-- Generated/managed by GZML Visual Tools.\n"
                "-- Animation presets selected will be copied here.\n\n"
            )
            created_files.append("animations.lua")

        if not GZML_BLUR_FILE.exists():
            self.write_blur_config(0)
            created_files.append("blur.lua")

        # Generated files are created silently.
        # Startup and dofile instructions are handled by the installer/README. Remember you removed logic.

    def write_blur_config(self, level: int):
        GZML_CONFIG_DIR.mkdir(parents=True, exist_ok=True)

        if level <= 0:
            enabled = "false"
            size = 0
        else:
            enabled = "true"
            size = max(1, min(10, int(level)))
        GZML_BLUR_FILE.write_text(
            f"""-- Generated/managed by GZML Visual Tools.

hl.config({{
  decoration = {{
    blur = {{
      enabled = {enabled},
      size = {size},
      passes = 2,

      new_optimizations = true,
      xray = true,
      ignore_opacity = true,
      special = true,
      popups = true,
    }},
  }},
}})
"""
        )

    def setup_tray(self):
        icon = str(ICON_PATH) if ICON_PATH.exists() else "preferences-desktop-theme"

        if HAS_APPINDICATOR:
            self.indicator = AppIndicator3.Indicator.new(
                APP_ID,
                icon,
                AppIndicator3.IndicatorCategory.APPLICATION_STATUS,
            )
            self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
            self.indicator.set_title("GZML Visual Tools")
            self.indicator.set_menu(self.root_menu)
            return

        self.status_icon = Gtk.StatusIcon()
        self.status_icon.set_name(APP_ID)

        if ICON_PATH.exists():
            self.status_icon.set_from_file(str(ICON_PATH))
        else:
            self.status_icon.set_from_icon_name("preferences-desktop-theme")

        self.status_icon.set_visible(True)
        self.status_icon.connect("popup-menu", self.show_status_menu)
        self.status_icon.connect("activate", self.toggle_control_center)

    def show_status_menu(self, icon, button=0, time=0):
        self.refresh_all_submenus()
        self.root_menu.show_all()
        self.root_menu.popup(
            None,
            None,
            Gtk.StatusIcon.position_menu,
            self.status_icon,
            button,
            time,
        )

    def show_status_menu_left_click(self, icon):
        # Kept as a fallback helper, but left click now opens the control center..or it should.
        self.show_status_menu(icon, 1, Gtk.get_current_event_time())

    def toggle_control_center(self, *_):
        if self.control_center and self.control_center.get_visible():
            self.control_center.hide()
            return
        self.show_control_center()

    def on_control_center_close(self, *_):
        if self.control_center:
            self.control_center.hide()
        return True

    def show_control_center(self):
        # Rebuild every open so sliders/switches always reflect current state.
        if self.control_center is not None:
            self.control_center.destroy()
            self.control_center = None
        self.blur_apply_source = None
        self._control_center_building = False

        self._control_center_building = True

        self.control_center = Gtk.Window(title="GZML Control Center")
        self.control_center.set_name("gzml-control-center")
        self.control_center.set_default_size(700, 620)
        self.control_center.set_position(Gtk.WindowPosition.CENTER)
        self.control_center.connect("delete-event", self.on_control_center_close)

        self.control_center.set_decorated(True)
        self.control_center.set_keep_above(False)
        self.control_center.set_skip_taskbar_hint(False)
        self.control_center.set_skip_pager_hint(False)
        self.control_center.set_type_hint(Gdk.WindowTypeHint.NORMAL)

        css = b"""
        #gzml-control-center {
            border-radius: 18px;
        }
        """
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )

        outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)

        header = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        header.set_border_width(14)

        if ICON_PATH.exists():
            logo = Gtk.Image()
            try:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    str(ICON_PATH),
                    168,
                    168,
                    True,
                )
                logo.set_from_pixbuf(pixbuf)
            except Exception:
                logo.set_from_icon_name("preferences-desktop-theme", Gtk.IconSize.DIALOG)
            logo.set_size_request(168, 168)
            logo.set_halign(Gtk.Align.CENTER)
            logo.set_valign(Gtk.Align.CENTER)
            header.pack_start(logo, False, False, 0)

        title_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        title = Gtk.Label()
        title.set_markup('<span size="30000" weight="bold">GZML Visual Tools</span>')
        title.set_xalign(0)

        subtitle = Gtk.Label()
        subtitle.set_markup('<span size="15000">Hyprland Lua visual controls</span>')
        subtitle.set_xalign(0)

        title_box.pack_start(title, False, False, 0)
        title_box.pack_start(subtitle, False, False, 0)
        header.pack_start(title_box, True, True, 0)

        close_button = Gtk.Button(label="Close")
        close_button.set_halign(Gtk.Align.END)
        close_button.set_valign(Gtk.Align.CENTER)
        close_button.set_vexpand(False)
        close_button.set_hexpand(False)
        close_button.set_size_request(72, 32)
        close_button.connect("clicked", lambda *_: self.control_center.hide())
        header.pack_end(close_button, False, False, 0)

        outer.pack_start(header, False, False, 0)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)

        content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=14)
        content.set_border_width(16)

        content.pack_start(self.build_quick_actions_panel(), False, False, 0)
        content.pack_start(self.build_blur_panel(), False, False, 0)
        content.pack_start(self.build_borders_panel(), False, False, 0)
        content.pack_start(self.build_preset_panel("Animations", PRESETS_DIR / "animations", True), False, False, 0)
        content.pack_start(self.build_preset_panel("Wallpaper Effects", PRESETS_DIR / "wallpaper-effects", False), False, False, 0)
        content.pack_start(self.build_preset_panel("Themes", PRESETS_DIR / "themes", False), False, False, 0)
        content.pack_start(self.build_injector_panel(), False, False, 0)
        content.pack_start(self.build_about_panel(), False, False, 0)

        scrolled.add(content)
        outer.pack_start(scrolled, True, True, 0)

        self.control_center.add(outer)
        self.control_center.show_all()
        self.control_center.present()
        self._control_center_building = False


    def panel_frame(self, title: str):
        frame = Gtk.Frame(label=title)
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_border_width(12)
        frame.add(box)
        return frame, box

    def build_quick_actions_panel(self):
        frame, box = self.panel_frame("Quick Actions")

        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)

        reload_button = Gtk.Button(label="Reload Hyprland")
        reload_button.connect("clicked", lambda *_: self.run_detached(["hyprctl", "reload"]))
        row.pack_start(reload_button, False, False, 0)

        errors_button = Gtk.Button(label="Check Config Errors")
        errors_button.connect("clicked", lambda *_: self.run_detached(["hyprctl", "configerrors"]))
        row.pack_start(errors_button, False, False, 0)

        folder_button = Gtk.Button(label="Open GZML Hypr Config")
        folder_button.connect("clicked", lambda *_: self.run_detached(["xdg-open", str(GZML_CONFIG_DIR)]))
        row.pack_start(folder_button, False, False, 0)

        presets_button = Gtk.Button(label="Open Presets Folder")
        presets_button.connect("clicked", lambda *_: self.run_detached(["xdg-open", str(PRESETS_DIR)]))
        row.pack_start(presets_button, False, False, 0)

        box.pack_start(row, False, False, 0)
        return frame

    def build_blur_panel(self):
        frame, box = self.panel_frame("Blur")

        active_level = self.read_int_state(ACTIVE_BLUR_FILE, 0)

        label = Gtk.Label(label=self.blur_status_text(active_level))
        label.set_xalign(0)
        box.pack_start(label, False, False, 0)

        adjustment = Gtk.Adjustment(
            value=active_level,
            lower=0,
            upper=10,
            step_increment=1,
            page_increment=1,
            page_size=0,
        )

        scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=adjustment)
        scale.set_digits(0)
        scale.set_draw_value(False)
        scale.connect("value-changed", self.on_control_blur_scale_changed, label)

        box.pack_start(scale, False, False, 0)
        return frame

    def blur_status_text(self, level: int) -> str:
        if level <= 0:
            return "Current blur: Off"
        return f"Current blur: {level}"

    def build_borders_panel(self):
        frame, box = self.panel_frame("Borders")

        active_size = self.read_int_state(ACTIVE_BORDER_FILE, 2)

        label = Gtk.Label(label=f"Current border size: {active_size}px")
        label.set_xalign(0)
        box.pack_start(label, False, False, 0)

        adjustment = Gtk.Adjustment(
            value=active_size,
            lower=1,
            upper=10,
            step_increment=1,
            page_increment=1,
            page_size=0,
        )

        scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=adjustment)
        scale.set_digits(0)
        scale.set_draw_value(False)
        scale.connect("value-changed", self.on_control_border_scale_changed, label)

        box.pack_start(scale, False, False, 0)
        return frame

    def active_state_file_for_title(self, title: str):
        return {
            "Wallpaper Effects": ACTIVE_WALLPAPER_FILE,
            "Themes": ACTIVE_THEME_FILE,
            "Tools": ACTIVE_TOOL_FILE,
        }.get(title)

    def read_active_preset_path(self, title: str):
        state_file = self.active_state_file_for_title(title)
        if state_file is None:
            return None
        try:
            raw = state_file.read_text().strip()
            return Path(raw) if raw else None
        except Exception:
            return None

    def write_active_preset_path(self, title: str, preset: Path):
        state_file = self.active_state_file_for_title(title)
        if state_file is None:
            return
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        state_file.write_text(str(preset))

    def is_disabled_preset(self, preset: Path) -> bool:
        name = preset.stem.lower().replace("_", "-").replace(" ", "-")
        return name in {"disabled", "disable", "off", "none", "no-effect", "no-effects"}

    def is_active_control_preset(self, title: str, preset: Path, animations: bool) -> bool:
        if animations and preset.suffix == ".lua":
            return self.is_active_animation(preset)

        active = self.read_active_preset_path(title)

        # Wallpaper effects can be intentionally disabled. When no active
        # wallpaper effect preset has been recorded yet, treat a disabled/off
        # preset as the active/default state so the Control Center switch
        # reflects that correctly on open.
        if title == "Wallpaper Effects" and active is None:
            return self.is_disabled_preset(preset)

        try:
            return active is not None and active.resolve() == preset.resolve()
        except Exception:
            return active == preset

    def is_duplicate_quick_action_tool(self, preset: Path) -> bool:
        name = preset.stem.lower().replace("_", "-").replace(" ", "-")
        return ("hypr" in name and ("reload" in name or "refresh" in name))

    def build_preset_panel(self, title: str, folder: Path, animations: bool):
        frame, box = self.panel_frame(title)

        presets = self.get_preset_files(folder)
        if title == "Tools":
            presets = [p for p in presets if not self.is_duplicate_quick_action_tool(p)]

        if not presets:
            empty = Gtk.Label(label="No presets found.")
            empty.set_xalign(0)
            box.pack_start(empty, False, False, 0)
            return frame

        for preset in presets:
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)

            label = Gtk.Label(label=self.bspretty_name(preset))
            label.set_xalign(0)
            row.pack_start(label, True, True, 0)

            if title == "Tools":
                button = Gtk.Button(label="Run")
                button.connect("clicked", self.on_control_tool_button, preset)
                row.pack_end(button, False, False, 0)
            else:
                switch = Gtk.Switch()
                switch.set_active(self.is_active_control_preset(title, preset, animations))
                switch.connect("notify::active", self.on_control_preset_switch, title, preset, animations)
                row.pack_end(switch, False, False, 0)

            box.pack_start(row, False, False, 0)

        return frame

    def build_injector_panel(self):
        frame, box = self.panel_frame("Preset Injector")

        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)

        categories = [
            ("Animation", PRESETS_DIR / "animations"),
            ("Wallpaper", PRESETS_DIR / "wallpaper-effects"),
            ("Theme", PRESETS_DIR / "themes"),
            ("Tool", PRESETS_DIR / "tools"),
        ]

        for label, folder in categories:
            button = Gtk.Button(label=f"Add {label}")
            button.connect("clicked", self.inject_preset, folder)
            row.pack_start(button, False, False, 0)

        box.pack_start(row, False, False, 0)
        return frame

    def build_about_panel(self):
        frame, box = self.panel_frame("About")
        for line in [
            "GZML 2026 v0.6 beta",
            "GTK/AppIndicator tray + Hyprland Lua support",
            "Preset Driven Visual Tools for Hyprland",
        ]:
            label = Gtk.Label(label=line)
            label.set_xalign(0)
            box.pack_start(label, False, False, 0)
        return frame

    def on_control_blur_scale_changed(self, scale: Gtk.Scale, label: Gtk.Label):
        if self._control_center_building:
            return

        level = int(round(scale.get_value()))
        if int(scale.get_value()) != level:
            scale.set_value(level)

        label.set_text(self.blur_status_text(level))

        if self.blur_apply_source is not None:
            GLib.source_remove(self.blur_apply_source)
            self.blur_apply_source = None

        def apply_later():
            self.apply_blur(level, notify_user=True)
            self.refresh_submenu("Blur", self.blur_menu)
            self.blur_apply_source = None
            return False

        self.blur_apply_source = GLib.timeout_add(180, apply_later)

    def on_control_blur_toggled(self, button: Gtk.RadioButton, level: int):
        # Compatibility fallback for older radio-button UI.
        if not button.get_active():
            return
        self.apply_blur(level, notify_user=True)
        self.refresh_submenu("Blur", self.blur_menu)

    def on_control_border_scale_changed(self, scale: Gtk.Scale, label: Gtk.Label):
        size = int(scale.get_value())
        label.set_text(f"Current border size: {size}px")
        self.apply_border_size(size)
        self.refresh_submenu("Borders", self.borders_menu)

    def on_control_tool_button(self, button: Gtk.Button, preset: Path):
        self.on_preset_clicked(button, preset)

    def on_control_preset_switch(self, switch: Gtk.Switch, _param, title: str, preset: Path, animations: bool):
        # Turning it OFF manually is ignored for now because these categories are single active states member berries.
        if not switch.get_active():
            return

        if animations and preset.suffix == ".lua":
            self.apply_animation(preset)
        else:
            self.on_preset_clicked(switch, preset)
            self.write_active_preset_path(title, preset)

        self.refresh_all_submenus()
        if self.control_center and self.control_center.get_visible():
            self.show_control_center()

    def on_control_preset_toggled(self, button: Gtk.RadioButton, title: str, preset: Path, animations: bool):
        # Compatibility fallback for older radio button UI.
        if not button.get_active():
            return

        if animations and preset.suffix == ".lua":
            self.apply_animation(preset)
        else:
            self.on_preset_clicked(button, preset)
            self.write_active_preset_path(title, preset)

        self.refresh_all_submenus()
        if self.control_center and self.control_center.get_visible():
            self.show_control_center()

    def notify(self, title: str, message: str):
        subprocess.Popen(
            ["notify-send", title, message],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )

    def run_detached(self, cmd):
        subprocess.Popen(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )

    def run_shell(self, command: str):
        self.run_detached(["bash", "-lc", command])

    def bspretty_name(self, path: Path) -> str:
        name = path.stem
        if len(name) >= 3 and name[:2].isdigit():
            name = name[2:].lstrip(" -_")
        return name.replace("-", " ").replace("_", " ").title()

    def same_file_contents(self, a: Path, b: Path) -> bool:
        try:
            return a.read_bytes() == b.read_bytes()
        except Exception:
            return False

    def is_active_animation(self, preset: Path) -> bool:
        return (
            preset.suffix == ".lua"
            and ACTIVE_ANIMATION_FILE.exists()
            and self.same_file_contents(preset, ACTIVE_ANIMATION_FILE)
        )

    def get_preset_files(self, folder: Path):
        folder.mkdir(parents=True, exist_ok=True)
        files = []
        for ext in SUPPORTED_EXTENSIONS:
            files.extend(folder.glob(f"*{ext}"))
        return sorted(files, key=lambda p: p.name.lower())

    def clear_menu(self, menu: Gtk.Menu):
        for child in list(menu.get_children()):
            menu.remove(child)

    def read_int_state(self, path: Path, default: int) -> int:
        try:
            return int(path.read_text().strip())
        except Exception:
            return default

    def write_int_state(self, path: Path, value: int):
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        path.write_text(str(value))

    def build_root_menu(self):
        self.clear_menu(self.root_menu)

        control_center_item = Gtk.MenuItem(label="Open Control Center")
        control_center_item.connect("activate", self.toggle_control_center)
        self.root_menu.append(control_center_item)
        self.root_menu.append(Gtk.SeparatorMenuItem())

        self.root_menu.append(self.make_submenu_item("Animations", self.animation_menu))
        self.root_menu.append(self.make_submenu_item("Wallpaper Effects", self.wallpaper_menu))
        self.root_menu.append(self.make_submenu_item("Themes", self.theme_menu))
        self.root_menu.append(self.make_submenu_item("Tools", self.tools_menu))
        self.root_menu.append(self.make_submenu_item("Blur", self.blur_menu))
        self.root_menu.append(self.make_submenu_item("Borders", self.borders_menu))

        self.root_menu.append(Gtk.SeparatorMenuItem())

        injector_item = Gtk.MenuItem(label="Preset Injector")
        injector_menu = Gtk.Menu()
        injector_item.set_submenu(injector_menu)
        self.build_injector_menu(injector_menu)
        self.root_menu.append(injector_item)

        self.root_menu.append(Gtk.SeparatorMenuItem())

        about_item = Gtk.MenuItem(label="About")
        about_menu = Gtk.Menu()
        about_item.set_submenu(about_menu)
        self.build_about_menu(about_menu)
        self.root_menu.append(about_item)

        quit_item = Gtk.MenuItem(label="Quit")
        quit_item.connect("activate", self.quit)
        self.root_menu.append(quit_item)

        self.refresh_all_submenus()
        self.root_menu.show_all()

    def make_submenu_item(self, label: str, submenu: Gtk.Menu):
        item = Gtk.MenuItem(label=label)
        item.set_submenu(submenu)
        submenu.connect("show", lambda *_: self.refresh_submenu(label, submenu))
        return item

    def refresh_all_submenus(self):
        self.refresh_submenu("Animations", self.animation_menu)
        self.refresh_submenu("Wallpaper Effects", self.wallpaper_menu)
        self.refresh_submenu("Themes", self.theme_menu)
        self.refresh_submenu("Tools", self.tools_menu)
        self.refresh_submenu("Blur", self.blur_menu)
        self.refresh_submenu("Borders", self.borders_menu)

    def refresh_submenu(self, title: str, submenu: Gtk.Menu):
        if title == "Blur":
            self.refresh_blur_menu(submenu)
            return

        if title == "Borders":
            self.refresh_borders_menu(submenu)
            return

        folder_map = {
            "Animations": PRESETS_DIR / "animations",
            "Wallpaper Effects": PRESETS_DIR / "wallpaper-effects",
            "Themes": PRESETS_DIR / "themes",
            "Tools": PRESETS_DIR / "tools",
        }

        folder = folder_map[title]
        self.clear_menu(submenu)

        presets = self.get_preset_files(folder)
        radio_group = None

        if presets:
            for preset in presets:
                if title == "Animations" and preset.suffix == ".lua":
                    item = Gtk.RadioMenuItem.new_with_label_from_widget(
                        radio_group,
                        self.bspretty_name(preset),
                    )

                    if radio_group is None:
                        radio_group = item

                    if self.is_active_animation(preset):
                        item.set_active(True)

                    item.connect("toggled", self.on_animation_toggled, preset)
                else:
                    item = Gtk.MenuItem(label=self.bspretty_name(preset))
                    item.connect("activate", self.on_preset_clicked, preset)

                submenu.append(item)
        elif title != "Tools":
            empty = Gtk.MenuItem(label="No presets found")
            empty.set_sensitive(False)
            submenu.append(empty)

        if title == "Themes":
            if presets:
                submenu.append(Gtk.SeparatorMenuItem())
            coming_soon = Gtk.MenuItem(label="Coming Soon!")
            coming_soon.set_sensitive(False)
            submenu.append(coming_soon)

        if title == "Tools":
            self.add_tools_actions(submenu)

        submenu.show_all()

    def refresh_blur_menu(self, submenu: Gtk.Menu):
        self.clear_menu(submenu)

        active_level = self.read_int_state(ACTIVE_BLUR_FILE, 0)
        group = None

        for level in range(0, 11):
            label = "Off" if level == 0 else f"Blur {level}"
            item = Gtk.RadioMenuItem.new_with_label_from_widget(group, label)

            if group is None:
                group = item

            if level == active_level:
                item.set_active(True)

            item.connect("toggled", self.on_blur_toggled, level)
            submenu.append(item)

        submenu.show_all()

    def refresh_borders_menu(self, submenu: Gtk.Menu):
        self.clear_menu(submenu)

        active_size = self.read_int_state(ACTIVE_BORDER_FILE, 2)
        group = None

        for size in range(1, 11):
            label = f"{size}px"
            item = Gtk.RadioMenuItem.new_with_label_from_widget(group, label)

            if group is None:
                group = item

            if size == active_size:
                item.set_active(True)

            item.connect("toggled", self.on_border_toggled, size)
            submenu.append(item)

        submenu.show_all()

    def add_tools_actions(self, menu: Gtk.Menu):
        menu.append(Gtk.SeparatorMenuItem())

        refresh = Gtk.MenuItem(label="Refresh Preset Menus")
        refresh.connect("activate", self.on_refresh_clicked)
        menu.append(refresh)

        reload_hyprland = Gtk.MenuItem(label="Reload Hyprland")
        reload_hyprland.connect("activate", lambda *_: self.run_detached(["hyprctl", "reload"]))
        menu.append(reload_hyprland)

        open_generated_config = Gtk.MenuItem(label="Open GZML Hypr Config Folder")
        open_generated_config.connect(
            "activate",
            lambda *_: self.run_detached(["xdg-open", str(GZML_CONFIG_DIR)]),
        )
        menu.append(open_generated_config)

    def build_about_menu(self, menu: Gtk.Menu):
        self.clear_menu(menu)

        lines = [
            "GZML 2026 v0.6 beta",
            "Git zer0-j89",
            "GTK/AppIndicator tray &",
            "Hyprland .Lua support",
            "Preset driven visual tools",
        ]

        for line in lines:
            item = Gtk.MenuItem(label=line)
            item.set_sensitive(False)
            menu.append(item)

        menu.show_all()

    def build_injector_menu(self, menu: Gtk.Menu):
        self.clear_menu(menu)

        open_folder = Gtk.MenuItem(label="Open Presets Folder")
        open_folder.connect(
            "activate",
            lambda *_: self.run_detached(["xdg-open", str(PRESETS_DIR)]),
        )
        menu.append(open_folder)

        menu.append(Gtk.SeparatorMenuItem())

        categories = [
            ("Add Animation Preset", PRESETS_DIR / "animations"),
            ("Add Wallpaper Effect Preset", PRESETS_DIR / "wallpaper-effects"),
            ("Add Theme Preset", PRESETS_DIR / "themes"),
            ("Add Tool Preset", PRESETS_DIR / "tools"),
        ]

        for label, folder in categories:
            item = Gtk.MenuItem(label=label)
            item.connect("activate", self.inject_preset, folder)
            menu.append(item)

        menu.show_all()
# ---------------------------------------------------------------------------
# If you're reading this, thanks for checking out GZML Visual Tools.
# Built by zer0-j89 for the Hyprland community.
# ---------------------------------------------------------------------------
    def on_animation_toggled(self, item: Gtk.RadioMenuItem, preset: Path):
        if not item.get_active():
            return
        self.apply_animation(preset)

    def on_blur_toggled(self, item: Gtk.RadioMenuItem, level: int):
        if not item.get_active():
            return
        self.apply_blur(level)

    def on_border_toggled(self, item: Gtk.RadioMenuItem, size: int):
        if not item.get_active():
            return
        self.apply_border_size(size)

    def on_preset_clicked(self, item: Gtk.MenuItem, preset: Path):
        if preset.suffix == ".sh":
            self.run_shell(f'"{preset}"')
            return

        if preset.suffix == ".lua":
            self.apply_animation(preset)
            return

        self.notify("GZML Visual Tools", f"Unsupported file: {preset.name}")

    def apply_animation(self, preset: Path):
        name = self.bspretty_name(preset)

        try:
            ACTIVE_ANIMATION_FILE.parent.mkdir(parents=True, exist_ok=True)
            copy2(preset, ACTIVE_ANIMATION_FILE)

            self.notify("GZML Animations", f"{name} loaded")
            self.run_detached(["hyprctl", "reload"])

            GLib.timeout_add_seconds(
                1,
                lambda: self.run_detached(["hyprctl", "configerrors"]) or False,
            )

        except Exception as e:
            self.notify("GZML Animations", f"Failed: {e}")

    def apply_blur(self, level: int, notify_user: bool = True):
        try:
            level = max(0, min(10, int(level)))
            self.write_blur_config(level)
            self.write_int_state(ACTIVE_BLUR_FILE, level)

            self.run_detached(["hyprctl", "reload"])

            if notify_user:
                if level == 0:
                    self.notify("GZML Blur", "Blur disabled")
                else:
                    self.notify("GZML Blur", f"Blur level {level}")

        except Exception as e:
            print(f"GZML Blur failed: {e}", file=sys.stderr)

    def apply_border_size(self, size: int):
        try:
            self.run_detached(
                [
                    "hyprctl",
                    "eval",
                    f"hl.config({{ general = {{ border_size = {size} }} }})",
                ]
            )
            self.write_int_state(ACTIVE_BORDER_FILE, size)
            self.notify("GZML Borders", f"Border size {size}px")

        except Exception as e:
            self.notify("GZML Borders", f"Failed: {e}")

    def on_refresh_clicked(self, *_):
        self.refresh_all_submenus()
        self.notify("GZML Visual Tools", "Preset menus refreshed")

    def inject_preset(self, item: Gtk.MenuItem, category_folder: Path):
        category_folder.mkdir(parents=True, exist_ok=True)

        dialog = Gtk.FileChooserDialog(
            title="Choose preset file",
            action=Gtk.FileChooserAction.OPEN,
        )

        dialog.add_buttons(
            Gtk.STOCK_CANCEL,
            Gtk.ResponseType.CANCEL,
            Gtk.STOCK_OPEN,
            Gtk.ResponseType.OK,
        )

        file_filter = Gtk.FileFilter()
        file_filter.set_name("Preset files")
        file_filter.add_pattern("*.sh")
        file_filter.add_pattern("*.lua")
        dialog.add_filter(file_filter)

        response = dialog.run()

        if response == Gtk.ResponseType.OK:
            src = Path(dialog.get_filename())
            dst = category_folder / src.name

            try:
                copy2(src, dst)

                if dst.suffix == ".sh":
                    dst.chmod(dst.stat().st_mode | 0o111)

                self.notify("GZML Preset Injector", f"Added {dst.name}")
                self.refresh_all_submenus()

            except Exception as e:
                self.notify("GZML Preset Injector", f"Failed: {e}")

        dialog.destroy()


def main():
    app = GZMLTray()

    try:
        Gtk.main()
    finally:
        app.cleanup_lock()


if __name__ == "__main__":
    main()
