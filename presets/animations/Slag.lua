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
    rounding = 12,
    active_opacity = 0.98,
    inactive_opacity = 0.9,
  },
})
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "drift", style = "slide" })

-- appear gently
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "soft_in", style = "popin 20%" })

-- leave dramatically
hl.animation({ leaf = "windowsOut", enabled = true, speed = 9, bezier = "quantum_out", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 15, spring = "settle", style = "slide" })

-- panels
hl.animation({ leaf = "layersIn", enabled = true, speed = 8, spring = "settle", style = "slide right" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 8, bezier = "soft_out", style = "slide left" })

-- workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "drift", style = "slidefadevert 45%" })

-- new workspace calmly arrives
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "soft_in", style = "slidefade 18%" })

-- old workspace gets violently ejected
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "quantum_out", style = "slidefadevert 75%" })

-- special workspace retreats upward instead of emerging upward
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 10, spring = "settle", style = "slidefadevert 110%" })