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
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "drift", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "quantum_in", style = "slide top" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 9, bezier = "quantum_out", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 15, spring = "settle", style = "slide" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 8, spring = "settle", style = "slide left" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 8, bezier = "soft_out", style = "slide right" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "drift", style = "slidefadevert 45%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "quantum_in", style = "slidefadevert 75%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "quantum_out", style = "slidefade 18%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 10, spring = "settle", style = "slidefadevert -110%" })