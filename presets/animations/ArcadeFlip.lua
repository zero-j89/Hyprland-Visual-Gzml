hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 2,
    gaps_out = 6,
    border_size = 3,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 6,
    blur = {
      enabled = false,
      size = 2,
      passes = 1,
      new_optimizations = true,
    },
  },
})

hl.curve("arcade", { type = "bezier", points = { {0.1, 1.35}, {0.2, 1} } })
hl.curve("hard_exit", { type = "bezier", points = { {0.7, -0.4}, {1, 0} } })
hl.curve("instantish", { type = "bezier", points = { {0.05, 0}, {0.1, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 14, bezier = "instantish" })
hl.animation({ leaf = "border", enabled = true, speed = 40, bezier = "linear" })
hl.animation({ leaf = "windows", enabled = true, speed = 9, bezier = "arcade", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 12, bezier = "arcade", style = "popin 20%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 9, bezier = "hard_exit", style = "popin 10%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 12, bezier = "arcade", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "instantish" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 9, bezier = "arcade", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "hard_exit", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 10, bezier = "arcade", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 12, bezier = "arcade", style = "slidefade -65%" })