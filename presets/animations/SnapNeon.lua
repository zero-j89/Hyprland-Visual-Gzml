hl.config({
  animations = { enabled = true },
  general = { gaps_in = 4, gaps_out = 8, border_size = 2 },
  decoration = {
    rounding = 12,
    blur = { enabled = false, size = 3, passes = 2, new_optimizations = true },
  },
})

hl.curve("snap", { type = "bezier", points = { {0.12, 1.15}, {0.28, 1} } })
hl.curve("fast", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "snap" })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "snap" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "snap", style = "popin 75%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "fast", style = "popin 40%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "snap", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 20, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "fast" })
hl.animation({ leaf = "layers", enabled = true, speed = 6, bezier = "snap", style = "popin 70%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "snap", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "snap", style = "slidefadevert -40%" })