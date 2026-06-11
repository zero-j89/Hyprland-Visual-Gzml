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

-- materialize softly
hl.animation({ leaf = "windowsIn", enabled = true, speed = 10, bezier = "soft_in", style = "popin 15%" })

-- violently pulled upward when closed
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "quantum_out", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "settle", style = "slide" })

-- panels feel separate from windows
hl.animation({ leaf = "layersIn", enabled = true, speed = 7, spring = "settle", style = "slide right" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 7, bezier = "soft_out", style = "slide left" })

-- dimensional workspace effect
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "drift", style = "slidefadevert 45%" })

-- new workspace quietly glides in
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7, bezier = "soft_in", style = "slidefade 12%" })

-- old workspace gets ejected upward dramatically
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 8, bezier = "quantum_out", style = "slidefadevert 90%" })

-- scratchpad/special workspace feels like another dimension
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 11, spring = "settle", style = "slidefadevert 125%" })