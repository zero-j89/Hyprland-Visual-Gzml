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


hl.curve("quantum_in", { type = "bezier", points = { {0.05, 1.15}, {0.22, -0.3} } })
hl.curve("quantum_out", { type = "bezier", points = { {0.25, -0.65}, {0.9, 0.12} } })

hl.curve("soft_in", { type = "bezier", points = { {0.12, 0.0}, {0.24, 1.0} } })
hl.curve("soft_out", { type = "bezier", points = { {0.4, 0.0}, {0.9, 1.0} } })

hl.curve("drift", { type = "spring", mass = 1.0, stiffness = 52, dampening = 15 })
hl.curve("settle", { type = "spring", mass = 0.8, stiffness = 85, dampening = 7 })

hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "drift", style = "slide" })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 8, bezier = "soft_in", style = "popin 6%" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "quantum_out", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "settle", style = "slide" })

hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "soft_in" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 8, bezier = "soft_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 10, bezier = "soft_out" })


hl.animation({ leaf = "border", enabled = true, speed = 12, spring = "settle" })

hl.animation({ leaf = "borderangle", enabled = true, speed = 18, bezier = "soft_in", style = "loop" })


hl.animation({ leaf = "layers", enabled = true, speed = 6, spring = "settle", style = "slide" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 7, spring = "settle", style = "slide right" })

hl.animation({ leaf = "layersOut", enabled = true, speed = 7, bezier = "soft_out", style = "slide left" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "drift", style = "slidefadevert 45%" })

-- new workspace barely moves into place
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 6, bezier = "soft_in", style = "slidefade 8%" })

-- old workspace gets ripped out vertically
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 9, bezier = "quantum_out", style = "slidefadevert 115%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 11, spring = "settle", style = "slidefadevert -140%" })