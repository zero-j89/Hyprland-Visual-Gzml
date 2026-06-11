hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 12,
    active_opacity = 0.98,
    inactive_opacity = 0.9,
  },
})


-- ============================================================
-- CELESTIAL EJECTION
-- inspired by Hyprland Hall of Fame space/fantasy-style rices
-- ============================================================

hl.curve("star_birth", {
  type = "bezier",
  points = { {0.10, 0.0}, {0.18, 1.0} }
})

hl.curve("solar_flare", {
  type = "bezier",
  points = { {0.18, -0.75}, {0.86, 0.18} }
})

hl.curve("orbit_drift", {
  type = "spring",
  mass = 1.0,
  stiffness = 48,
  dampening = 14
})

hl.curve("gravity_snap", {
  type = "spring",
  mass = 0.8,
  stiffness = 92,
  dampening = 8
})

hl.curve("soft_fade", {
  type = "bezier",
  points = { {0.35, 0.0}, {0.85, 1.0} }
})

-- windows: appear calm, exit violently
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "orbit_drift", style = "slide" })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 8, bezier = "star_birth", style = "popin 8%" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "solar_flare", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "gravity_snap", style = "slide" })

-- fades: clean, not artifact-hungry
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "star_birth" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 8, bezier = "star_birth" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 10, bezier = "soft_fade" })

-- panels: HUD sweep, not window physics
hl.animation({ leaf = "layers", enabled = true, speed = 6, spring = "gravity_snap", style = "slide" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 7, spring = "gravity_snap", style = "slide right" })

hl.animation({ leaf = "layersOut", enabled = true, speed = 7, bezier = "soft_fade", style = "slide left" })

-- workspaces: orbital handoff
-- new reality barely moves in
-- old reality gets thrown off vertically
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "orbit_drift", style = "slidefadevert 45%" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 6, bezier = "star_birth", style = "slidefade 6%" })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 9, bezier = "solar_flare", style = "slidefadevert 125%" })

-- special workspace: moon-drop / hidden orbit
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 11, spring = "gravity_snap", style = "slidefadevert -150%" })

-- optional living border
-- Hyprland warns this constantly renders frames, so delete if GPU idle suffers.
hl.animation({ leaf = "borderangle", enabled = true, speed = 20, bezier = "star_birth", style = "loop" })