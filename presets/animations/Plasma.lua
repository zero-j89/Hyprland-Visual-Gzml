hl.config({
  animations = { enabled = true },

  general = {
    gaps_in = 3,
    gaps_out = 10,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
  },

  decoration = {
    rounding = 10,

    blur = {
      enabled = true,
      size = 5,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.5,
      popups = true,
      special = true,
    },
  },
})

hl.curve("default", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.curve("linear", {
  type = "bezier",
  points = {
    { 0, 0 },
    { 1, 1 },
  },
})

hl.curve("plasma_in", {
  type = "bezier",
  points = {
    { 0.05, 0.95 },
    { 0.10, 1.10 },
  },
})

hl.curve("plasma_out", {
  type = "bezier",
  points = {
    { 0.40, 0.0 },
    { 1.00, 0.25 },
  },
})

hl.curve("plasma_snap", {
  type = "bezier",
  points = {
    { 0.15, 0.0 },
    { 0.10, 1.0 },
  },
})

hl.curve("soft", {
  type = "bezier",
  points = {
    { 0.23, 1 },
    { 0.32, 1 },
  },
})

hl.animation({ leaf = "global", enabled = true, speed = 9, bezier = "soft" })

hl.animation({ leaf = "windows", enabled = true, speed = 8, bezier = "plasma_in", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 9, bezier = "plasma_in", style = "popin 35%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "plasma_out", style = "popin 25%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 8, bezier = "plasma_snap", style = "slide" })

hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "soft" })

hl.animation({ leaf = "layers", enabled = true, speed = 6, bezier = "plasma_snap", style = "popin 40%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 7, bezier = "plasma_in", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "plasma_out", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "plasma_snap", style = "slidefade 45%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8, bezier = "plasma_in", style = "slidefadevert -80%" })