hl.config({
  general = {
    -- 2px reads as a hairline at 2560x1440.
    border_size = 3,

    gaps_in = 5,
    gaps_out = 12,

  },

  decoration = {
    rounding = 5,

    -- The strongest focus cue available. Omarchy's default opacity split is
    -- 0.985 vs 0.96, a 2.5% difference that is effectively invisible.
    dim_inactive = true,
    dim_strength = 0.15,

    -- Lifts the focused window off the ones behind it.
    shadow = {
      enabled = true,
      range = 20,
      render_power = 3,
      color = "rgba(00000055)",
    },

    -- Costs GPU every frame, and this box has already had one amdgpu hang.
    blur = {
      enabled = false,
    },
  },
})

-- Instant workspace switching, no slide.
hl.animation({ leaf = "workspaces", enabled = false })
