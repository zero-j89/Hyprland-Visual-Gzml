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

-- ============================================================
-- GZML VOID-RIFT ANIMATION RICE
-- ============================================================

-- violent entrance / exit curves for motion only
hl.curve("void_in", {
  type = "bezier",
  points = { {0.03, 1.35}, {0.17, -0.45} }
})

hl.curve("void_out", {
  type = "bezier",
  points = { {0.20, -0.85}, {0.82, 0.18} }
})

-- workspace diagonal rift curves
hl.curve("rift_in", {
  type = "bezier",
  points = { {0.08, 1.20}, {0.28, -0.28} }
})

hl.curve("rift_out", {
  type = "bezier",
  points = { {0.18, -0.55}, {0.88, 0.10} }
})

-- opacity-safe curves
hl.curve("phase_in", {
  type = "bezier",
  points = { {0.12, 0.0}, {0.24, 1.0} }
})

hl.curve("phase_out", {
  type = "bezier",
  points = { {0.42, 0.0}, {0.86, 1.0} }
})

-- springs
hl.curve("orbit", {
  type = "spring",
  mass = 1.35,
  stiffness = 44,
  dampening = 14
})

hl.curve("snap", {
  type = "spring",
  mass = 0.62,
  stiffness = 128,
  dampening = 8
})

hl.curve("gravity", {
  type = "spring",
  mass = 1.75,
  stiffness = 38,
  dampening = 18
})



hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "orbit", style = "slide" })

-- windows appear like they punch into existence
hl.animation({ leaf = "windowsIn", enabled = true, speed = 14, bezier = "void_in", style = "popin 22%" })

-- windows collapse harder on exit
hl.animation({ leaf = "windowsOut", enabled = true, speed = 12, bezier = "void_out", style = "popin 65%" })

-- moving tiled/floating windows gets a fast magnetic snap
hl.animation({ leaf = "windowsMove", enabled = true, speed = 18, spring = "snap", style = "slide" })


hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "phase_in" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 8, bezier = "phase_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 10, bezier = "phase_out" })

hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 9, bezier = "phase_out" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 8, bezier = "phase_out" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 10, bezier = "phase_out" })


	
-- animated gradient border orbit
hl.animation({ leaf = "borderangle", enabled = true, speed = 22, bezier = "phase_in", style = "loop" })



-- panels should NOT use the same violence as windows
-- this makes panels feel like glass sheets sliding in




hl.animation({ leaf = "layersOut", enabled = true, speed = 12, bezier = "phase_out", style = "fade" })


hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "gravity", style = "slidefadevert 44%" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "rift_in", style = "slidefadevert 72%" })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "rift_out", style = "slidefade 24%" })




hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 10, spring = "snap", style = "slidefadevert -88%" })