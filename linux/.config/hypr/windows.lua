-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--
-- Pinned apps teleport on purpose: the binding takes you to where the app
-- lives. Anything not listed here stays wherever you happen to be, which is
-- why the browser and plain terminals are deliberately absent.

o.window("^tmux-work$", { workspace = "9" })

-- Second brain: notes and todos together.
o.window("^chrome-app\\.notion\\.com__-Default$", { workspace = "8" })
o.window("^obsidian$", { workspace = "8" })

-- Agents: the Claude web UI and every terminal agent, which omarchy gives a
-- fixed app-id for exactly this purpose.
o.window("^chrome-claude\\.ai__-Default$", { workspace = "3" })
o.window("^org\\.omarchy\\.agent$", { workspace = "3" })

-- Comms live on the portrait panel.
o.window("^chrome-mail\\.proton\\.me__-Default$", { workspace = "2" })
