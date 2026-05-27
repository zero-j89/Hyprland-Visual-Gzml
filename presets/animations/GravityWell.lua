hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 6,
    gaps_out = 18,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },
  decoration = {
    rounding = 18,
    active_opacity = 0.98,
    inactive_opacity = 0.88,
    blur = {
      enabled = true,
      size = 5,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.35,
      special = true,
      popups = true,
    },
  },
})

hl.curve("gravity", { type = "spring", mass = 1.35, stiffness = 48, dampening = 5 })
hl.curve("heavy_in", { type = "spring", mass = 1.6, stiffness = 60, dampening = 7 })
hl.curve("collapse", { type = "bezier", points = { {0.8, -0.2}, {1, 0.2} } })
hl.curve("soft", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 6, bezier = "soft" })
hl.animation({ leaf = "windows", enabled = true, speed = 6, spring = "gravity", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, spring = "heavy_in", style = "popin 30%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "collapse", style = "popin 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 7, spring = "gravity", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "soft" })
hl.animation({ leaf = "layers", enabled = true, speed = 6, spring = "gravity", style = "popin 40%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "collapse", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, spring = "gravity", style = "slidefadevert 55%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 7, spring = "heavy_in", style = "slidefadevert -90%" })