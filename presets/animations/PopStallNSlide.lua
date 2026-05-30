hl.curve("pulse_in", { type = "bezier", points = { {0.06, 1.2}, {0.2, -0.22} } })
hl.curve("pulse_out", { type = "bezier", points = { {0.5, -0.35}, {0.88, 0.08} } })
hl.curve("heavy_drift", { type = "spring", mass = 1.25, stiffness = 68, dampening = 14 })
hl.curve("tight_snap", { type = "spring", mass = 0.65, stiffness = 125, dampening = 12 })

hl.animation({ leaf = "global", enabled = true, speed = 8, spring = "tight_snap" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "heavy_drift", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "pulse_in", style = "popin 30%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 9, bezier = "pulse_out", style = "popin 12%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 16, spring = "tight_snap", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "pulse_in" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "pulse_out" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 7, spring = "tight_snap", style = "popin 40%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "pulse_out", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "heavy_drift", style = "slidefadevert 40%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 8, bezier = "pulse_in", style = "slidefadevert 60%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 6, bezier = "pulse_out", style = "slidefade 22%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8, spring = "tight_snap", style = "slidefadevert -70%" })