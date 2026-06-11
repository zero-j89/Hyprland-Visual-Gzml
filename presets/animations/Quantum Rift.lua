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

-- =========================
-- GZML / Quantum Rift Animations
-- =========================

-- Aggressive window motion
hl.curve("rift_in", {
  type = "bezier",
  points = { {0.04, 1.28}, {0.18, -0.42} }
})

hl.curve("rift_out", {
  type = "bezier",
  points = { {0.22, -0.75}, {0.88, 0.16} }
})

-- Cleaner opacity-safe fades
hl.curve("ghost_in", {
  type = "bezier",
  points = { {0.10, 0.0}, {0.22, 1.0} }
})

hl.curve("ghost_out", {
  type = "bezier",
  points = { {0.42, 0.0}, {0.82, 1.0} }
})

-- Spring movement curves
hl.curve("zero_grav", {
  type = "spring",
  mass = 1.15,
  stiffness = 48,
  dampening = 13
})

hl.curve("snap_core", {
  type = "spring",
  mass = 0.72,
  stiffness = 105,
  dampening = 8
})

hl.curve("heavy_drift", {
  type = "spring",
  mass = 1.45,
  stiffness = 42,
  dampening = 17
})

hl.curve("micro_bounce", {
  type = "spring",
  mass = 0.55,
  stiffness = 135,
  dampening = 9
})

-- =========================
-- Windows
-- =========================

hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "zero_grav", style = "slide" })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 13, bezier = "rift_in", style = "popin 28%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 11, bezier = "rift_out", style = "popin 52%" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "snap_core", style = "slide" })

-- =========================
-- Border / shadow / fade
-- =========================

hl.animation({ leaf = "border", enabled = true, speed = 12, spring = "micro_bounce" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 9, spring = "heavy_drift" })

hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "ghost_in" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 8, bezier = "ghost_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 9, bezier = "ghost_out" })

hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 8, bezier = "ghost_out" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 7, bezier = "ghost_out" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 8, bezier = "ghost_out" })

-- =========================
-- Layers / panels
-- =========================

-- Keep these less cursed because Quickshell/Noctalia panels can artifact.
hl.animation({ leaf = "layers", enabled = true, speed = 6, spring = "snap_core", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 8, spring = "micro_bounce", style = "popin 30%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 11, bezier = "ghost_out", style = "fade" })

-- =========================
-- Workspaces
-- =========================
-- This keeps the mixed diagonal/vertical feeling you liked.

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "heavy_drift", style = "slidefadevert 42%" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "rift_in", style = "slidefadevert 68%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "rift_out", style = "slidefade 28%" })

-- =========================
-- Special workspace / scratchpad
-- =========================

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 9, spring = "snap_core", style = "slidefadevert -82%" })