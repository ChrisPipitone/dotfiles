-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Vim-style focus. Omarchy binds J/K/L to other things, so clear them first.
hl.unbind("SUPER + J") -- was: Toggle window split
hl.unbind("SUPER + K") -- was: Keybindings menu
hl.unbind("SUPER + L") -- was: Toggle workspace layout

o.bind("SUPER + H", "Move focus to the Left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus Down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus Up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus to the Right", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the Left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window Down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window Up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the Right", hl.dsp.window.swap({ direction = "r" }))

-- Close on Q rather than Omarchy's W.
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- SUPER+K is taken by focus now, so the cheatsheet moves here.
o.bind("CTRL + ALT + K", "Show key binds", "omarchy-menu-keybindings")

-- Split on P, pseudo on SHIFT+P.
hl.unbind("SUPER + P")         -- was: Pseudo window
hl.unbind("SUPER + SHIFT + P") -- was: Google Photos
o.bind("SUPER + P", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + SHIFT + P", "Pseudo window", hl.dsp.window.pseudo())

hl.unbind("SUPER + SHIFT + W") -- was: Omawrite
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })
