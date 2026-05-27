hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 7,
    gaps_out = 16,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 20,
    active_opacity = 0.96,
    inactive_opacity = 0.82,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.18,
      vibrancy_darkness = 0.25,
      special = true,
      popups = true,
    },
  },
})

hl.curve("drift", { type = "spring", mass = 1.1, stiffness = 42, dampening = 9 })
hl.curve("float_in", { type = "bezier", points = { {0.05, 0.75}, {0.12, 1} } })
hl.curve("mist", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("fadeout", { type = "bezier", points = { {0.4, 0}, {1, 0.2} } })

hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "float_in" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "drift", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "float_in", style = "popin 92%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "fadeout", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, spring = "drift", style = "slide" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "mist" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "fadeout" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "float_in", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "fadeout", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, spring = "drift", style = "slidefade 18%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, spring = "drift", style = "slidefadevert -30%" })