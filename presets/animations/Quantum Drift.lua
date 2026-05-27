hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 2,
    gaps_out = 10,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 18,
    active_opacity = 0.98,
    inactive_opacity = 0.9,
    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.32,
      vibrancy_darkness = 0.35,
      special = true,
      popups = true,
    },
  },
})

hl.curve("quantum_in", { type = "bezier", points = { {0.05, 1.25}, {0.22, -0.3} } })
hl.curve("quantum_out", { type = "bezier", points = { {0.55, -0.65}, {0.9, 0.12} } })
hl.curve("drift", { type = "spring", mass = 1.0, stiffness = 72, dampening = 5 })
hl.curve("settle", { type = "spring", mass = 0.8, stiffness = 95, dampening = 7 })

hl.animation({ leaf = "global", enabled = true, speed = 8, spring = "settle" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, spring = "drift", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 9, bezier = "quantum_in", style = "popin 35%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "quantum_out", style = "popin 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 9, spring = "settle", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "quantum_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "quantum_out" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 7, spring = "settle", style = "popin 45%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "quantum_out", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "drift", style = "slidefadevert 45%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "quantum_in", style = "slidefadevert 65%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 6, bezier = "quantum_out", style = "slidefade 25%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8, spring = "settle", style = "slidefadevert -75%" })