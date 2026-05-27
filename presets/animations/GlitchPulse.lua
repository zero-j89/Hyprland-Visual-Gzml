hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 3,
    gaps_out = 9,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 8,
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.22,
      popups = true,
    },
  },
})

hl.curve("glitch_in", { type = "bezier", points = { {0.02, 1.4}, {0.12, -0.25} } })
hl.curve("glitch_out", { type = "bezier", points = { {0.75, -0.35}, {0.9, 0.1} } })
hl.curve("snap", { type = "bezier", points = { {0.12, 1}, {0.18, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 12, bezier = "snap" })
hl.animation({ leaf = "windows", enabled = true, speed = 8, bezier = "glitch_in", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 10, bezier = "glitch_in", style = "popin 45%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "glitch_out", style = "popin 20%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 10, bezier = "snap", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 50, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 80, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 9, bezier = "glitch_in" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 8, bezier = "glitch_in", style = "popin 35%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 6, bezier = "glitch_out", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 8, bezier = "glitch_in", style = "slidefade 45%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 10, bezier = "glitch_in", style = "slidefadevert -80%" })