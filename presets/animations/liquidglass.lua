hl.config({
  animations = { enabled = true },
  general = { gaps_in = 6, gaps_out = 12, border_size = 2 },
  decoration = {
    rounding = 16,
    active_opacity = 0.98,
    inactive_opacity = 0.9,
    blur = {
      enabled = true,
      size = 5,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.25,
      popups = true,
      special = true,
    },
  },
})

hl.curve("glass", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("soft", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("fade", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "glass" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "soft" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "glass", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "fade", style = "popin 75%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "soft", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "glass", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "fade", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "soft", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.5, bezier = "glass", style = "slidefadevert -35%" })