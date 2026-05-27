hl.config({
  animations = { enabled = true },
  general = { gaps_in = 5, gaps_out = 10, border_size = 2 },
  decoration = {
    rounding = 10,
    blur = { enabled = false, size = 3, passes = 2, new_optimizations = true },
  },
})

hl.curve("bounce", { type = "spring", mass = 0.7, stiffness = 115, dampening = 4 })
hl.curve("throw", { type = "bezier", points = { {0.2, -0.5}, {0.8, 1.35} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 9, bezier = "quick" })
hl.animation({ leaf = "windows", enabled = true, speed = 8, spring = "bounce", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 9, spring = "bounce", style = "popin 65%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "throw", style = "popin 35%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 9, spring = "bounce", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 30, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 7, spring = "bounce", style = "popin 60%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "bounce", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 7, spring = "bounce", style = "slidefadevert -60%" })