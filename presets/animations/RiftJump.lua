hl.config({
  animations = { enabled = true },
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 2,
  },
})

hl.curve("rift", { type = "bezier", points = { {0.0, 1.6}, {0.2, -0.55} } })
hl.curve("snapback", { type = "spring", mass = 0.55, stiffness = 130, dampening = 5 })
hl.curve("tearout", { type = "bezier", points = { {0.55, -0.8}, {0.95, 0.15} } })
hl.curve("smooth", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "smooth" })
hl.animation({ leaf = "border", enabled = true, speed = 25, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 70, bezier = "linear", style = "loop" })

hl.animation({ leaf = "windows", enabled = true, speed = 8, spring = "snapback", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "rift", style = "popin 25%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "tearout", style = "popin 10%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 10, spring = "snapback", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "rift" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "tearout" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "smooth" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 8, bezier = "rift", style = "popin 30%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "tearout", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 8, spring = "snapback", style = "slidefadevert 65%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7, bezier = "rift", style = "slidefadevert 65%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 6, bezier = "tearout", style = "slidefade 35%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 9, bezier = "rift", style = "slidefadevert -100%" })