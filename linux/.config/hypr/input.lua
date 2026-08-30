-- Omarchy defaults already set repeat_rate 40, numlock_by_default,
-- touchpad.scroll_factor 0.4, and the per-terminal scroll rules. Only the
-- differences live here.

hl.config({
  input = {
    kb_options = "caps:swapescape",
    repeat_delay = 600,

    tablet = {
      transform = 0,
    },
  },
})

-- Wacom Intuos BT M: map the tablet surface to the main display only,
-- otherwise it spans both monitors and the aspect ratio goes wrong.
hl.device({ name = "wacom-intuos-bt-m-pen", output = "DP-1" })
hl.device({ name = "wacom-intuos-bt-m-pad", output = "DP-1" })
