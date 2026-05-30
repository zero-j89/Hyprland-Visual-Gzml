-- GZML Magnetic Glass Animation Profile

hl.curve("magnet_pull", { type = "bezier", points = { {0.08, 1.18}, {0.18, 0.92} } })
hl.curve("soft_escape", { type = "bezier", points = { {0.42, -0.22}, {0.82, 0.18} } })
hl.curve("glass_drift", { type = "spring", mass = 1.4, stiffness = 58, dampening = 13 })
hl.curve("magnetic_snap", { type = "spring", mass = 0.65, stiffness = 145, dampening = 11 })
hl.curve("heavy_settle", { type = "spring", mass = 1.15, stiffness = 88, dampening = 18 })

hl.animation({ leaf = "global", enabled = true, speed = 7, spring = "heavy_settle" })

hl.animation({ leaf = "windows", enabled = true, speed = 6, spring = "glass_drift", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 11, bezier = "magnet_pull", style = "popin 28%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "soft_escape", style = "popin 12%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 18, spring = "magnetic_snap", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 6, bezier = "magnet_pull" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 5, bezier = "soft_escape" })

hl.animation({ leaf = "layers", enabled = true, speed = 6, spring = "glass_drift", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 9, spring = "magnetic_snap", style = "popin 38%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 7, bezier = "soft_escape", style = "fade" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 8, spring = "glass_drift", style = "slidefadevert 38%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 9, spring = "magnetic_snap", style = "slidefadevert 55%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "soft_escape", style = "slidefade 22%" })

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 9, spring = "magnetic_snap", style = "slidefadevert -65%" })