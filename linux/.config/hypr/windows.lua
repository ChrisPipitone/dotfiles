-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Only fires for windows that OPEN on the scratchpad; a window moved there
-- later is handled by the SUPER + ALT + G binding instead. 60% of DP-1.
o.window({ workspace = "special:scratchpad" }, {
  float = true,
  center = true,
  size = { 1536, 864 },
})
