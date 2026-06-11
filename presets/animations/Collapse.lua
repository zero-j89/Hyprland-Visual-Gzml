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
hl.animation({ leaf = "windowsIn", enabled = true, speed = 12, bezier = "soft_in", style = "slide top" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "quantum_out", style = "slide bottom" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 6, bezier = "soft_in", style = "slidefadevert 5%" })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 9, bezier = "quantum_out", style = "slidefadevert -100%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 12, spring = "settle", style = "slidefadevert -150%" })