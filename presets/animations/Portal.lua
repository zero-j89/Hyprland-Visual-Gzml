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
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7, bezier = "quantum_in", style = "slidefadevert 100%" })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "quantum_out", style = "slidefade 100%" })