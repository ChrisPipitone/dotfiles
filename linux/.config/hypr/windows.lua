-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--
-- Pinned apps teleport on purpose: the binding takes you to where the app
-- lives. Anything not listed here stays wherever you happen to be, which is
-- why the browser and plain terminals are deliberately absent.

o.window("^tmux-work$", { workspace = "9" })

-- Second brain: notes and todos together.
o.window("^chrome-app\\.notion\\.com__-Default$", { workspace = "8" })
o.window("^obsidian$", { workspace = "8" })

-- Comms live on the portrait panel.
o.window("^chrome-mail\\.proton\\.me__-Default$", { workspace = "2" })
