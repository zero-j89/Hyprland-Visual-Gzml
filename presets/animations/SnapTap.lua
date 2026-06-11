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

-- new windows drop in from top
hl.animation({ leaf = "windowsIn", enabled = true, speed = 10, bezier = "quantum_in", style = "slide top" })

-- closing windows rip upward
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "quantum_out", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "settle", style = "slide" })