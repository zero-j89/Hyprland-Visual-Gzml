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
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "quantum_in", style = "slide left" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 11, bezier = "quantum_out", style = "slide right" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 8, spring = "settle", style = "slide left" })

hl.animation({ leaf = "layersOut", enabled = true, speed = 8, bezier = "soft_out", style = "slide right" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "quantum_in", style = "slidefade 70%" })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 8, bezier = "quantum_out", style = "slidefade 70%" })