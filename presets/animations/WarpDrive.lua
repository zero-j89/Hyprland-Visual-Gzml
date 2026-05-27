hl.config({
  animations = { enabled = true },
  general = { gaps_in = 5, gaps_out = 14, border_size = 2 },
  decoration = {
    rounding = 14,
    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.3,
      special = true,
      popups = true,
    },
  },
})

hl.curve("warp", { type = "bezier", points = { {0.05, 1.2}, {0.2, -0.35} } })
hl.curve("portal", { type = "bezier", points = { {0.1, 1}, {0, 1} } })
hl.curve("exit", { type = "bezier", points = { {0.38, 0.04}, {1, 0.07} } })
hl.curve("float", { type = "spring", mass = 0.9, stiffness = 70, dampening = 6 })

hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "portal" })
hl.animation({ leaf = "border", enabled = true, speed = 12, bezier = "warp" })
hl.animation({ leaf = "windows", enabled = true, speed = 6, spring = "float", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, spring = "float", style = "popin 55%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "exit", style = "popin 30%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 7, spring = "float", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "warp" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 6, bezier = "portal", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "exit", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, spring = "float", style = "slidefadevert 40%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 7, bezier = "portal", style = "slidefadevert -70%" })