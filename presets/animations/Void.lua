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
    rounding = 14,
    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.35,
      special = true,
      popups = true,
    },
  },
})

hl.curve("void_in", { type = "bezier", points = { {0.02, 1.45}, {0.18, -0.45} } })
hl.curve("void_out", { type = "bezier", points = { {0.6, -0.7}, {1, 0.05} } })
hl.curve("snap", { type = "spring", mass = 0.6, stiffness = 125, dampening = 5 })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "void_in" })
hl.animation({ leaf = "border", enabled = true, speed = 35, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 85, bezier = "linear", style = "loop" })

hl.animation({ leaf = "windows", enabled = true, speed = 8, spring = "snap", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "void_in", style = "popin 20%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "void_out", style = "popin 12%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 10, spring = "snap", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "void_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "void_out" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 8, bezier = "void_in", style = "popin 25%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "void_out", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 8, spring = "snap", style = "slidefadevert 75%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 9, bezier = "void_in", style = "slidefadevert -90%" })