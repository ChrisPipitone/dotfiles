-- See current bindings and descriptions:
--   omarchy menu keybindings --print
--
-- Omarchy's preinstalled app/webapp bindings are switched off in hyprland.lua
-- (omarchy_preinstalled_bindings = false), so every launcher below is declared
-- here rather than inherited. Home row first: SUPER + <letter> for anything
-- reached daily, SUPER + ALT for the rest.

------------------------------------------------------------------ direction --

-- hjkl is the only direction system; the arrow bindings are dropped below.
hl.unbind("SUPER + J") -- was: Toggle window split
hl.unbind("SUPER + K") -- was: Keybindings menu
hl.unbind("SUPER + L") -- was: Toggle workspace layout

o.bind("SUPER + H", "Move focus to the Left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus Down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus Up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus to the Right", hl.dsp.focus({ direction = "r" }))

-- Swap sits one modifier off focus. SHIFT is reserved for things that are
-- rare enough not to hurt.
hl.unbind("SUPER + SHIFT + H")
hl.unbind("SUPER + SHIFT + J")
hl.unbind("SUPER + SHIFT + K")
hl.unbind("SUPER + SHIFT + L")
hl.unbind("SUPER + ALT + K") -- was: Tmux keybindings (now CTRL + ALT + T)

o.bind("SUPER + ALT + H", "Swap window to the Left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + ALT + J", "Swap window Down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + ALT + K", "Swap window Up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + ALT + L", "Swap window to the Right", hl.dsp.window.swap({ direction = "r" }))

-- Resize is infrequent, so it takes the deepest tier. Replaces the twelve
-- MINUS/EQUAL bindings, which sat nowhere near the home row.
o.bind("SUPER + CTRL + ALT + H", "Narrow window", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + CTRL + ALT + L", "Widen window", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + CTRL + ALT + K", "Shorten window", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + CTRL + ALT + J", "Heighten window", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

-- The keybindings menu prints these as MINUS/EQUAL, but they are bound as
-- keycodes, and unbind matches the literal string including modifier order.
for _, key in ipairs({ "code:20", "code:21" }) do
  for _, mods in ipairs({
    "SUPER",
    "SUPER + SHIFT",
    "SUPER + ALT",
    "SUPER + SHIFT + ALT",
    "SUPER + CTRL",
    "SUPER + CTRL + SHIFT",
  }) do
    hl.unbind(mods .. " + " .. key)
  end
end

for _, key in ipairs({ "LEFT", "RIGHT", "UP", "DOWN" }) do
  hl.unbind("SUPER + " .. key)             -- was: focus
  hl.unbind("SUPER + SHIFT + " .. key)     -- was: swap window
  hl.unbind("SUPER + ALT + " .. key)       -- was: move window into group
  hl.unbind("SUPER + SHIFT + ALT + " .. key) -- was: move workspace to monitor
end

-- Rarely used, and with two monitors direction barely matters — one key that
-- cycles is enough.
o.bind("SUPER + ALT + W", "Move workspace to next monitor", hl.dsp.workspace.move({ monitor = "+1" }))

-- Workspace numbers move off SHIFT; grouping used to own SUPER + ALT + 1-5.
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
  o.bind("SUPER + ALT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end

--------------------------------------------------------------------- window --

-- Close on Q rather than Omarchy's W, which frees W for the layout toggle.
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Flip the current pair between side-by-side and stacked. T for tiling, with
-- float toggle one modifier deeper on the same key.
hl.unbind("SUPER + P") -- was: Pseudo window, which goes unused here
hl.unbind("SUPER + T") -- was: Toggle window floating/tiling
o.bind("SUPER + T", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

hl.unbind("SUPER + SHIFT + N") -- was: Editor

o.bind("SUPER + W", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Pop-out moves aside so Obsidian can have O.
hl.unbind("SUPER + O")
o.bind("SUPER + ALT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

------------------------------------------------------------------ scratchpad --

-- Grouping is unused, so its G keys go to the scratchpad instead.
hl.unbind("SUPER + G")       -- was: Toggle window grouping
hl.unbind("SUPER + ALT + G") -- was: Move window out of group
hl.unbind("SUPER + S")       -- was: Toggle scratchpad
hl.unbind("SUPER + ALT + S") -- was: Move window to scratchpad

o.bind("SUPER + G", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + ALT + G", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Remaining grouping bindings, unused without groups. SUPER + ALT + 1-5 was
-- also grouping, but the workspace loop above already rebound those keys —
-- unbinding them here would undo it.
hl.unbind("SUPER + ALT + TAB")
hl.unbind("SUPER + ALT + SHIFT + TAB")
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")
hl.unbind("SUPER + ALT + mouse_down")
hl.unbind("SUPER + ALT + mouse_up")

-------------------------------------------------------------------- launchers --

-- omarchy-launch-or-focus matches class OR title, so a bare name like "Notion"
-- also matches any terminal that happens to have it in the title. Match the
-- Chromium app class instead, which nothing else can collide with.
local function webapp(url, class)
  return "omarchy-launch-or-focus "
    .. o.shell_quote(class)
    .. " "
    .. o.shell_quote("omarchy-launch-webapp " .. url)
end

hl.unbind("SUPER + C") -- was: Universal copy, moved to SUPER + ALT + C
o.bind("SUPER + C", "Claude", webapp("https://claude.ai", "chrome-claude.ai__-Default"))
o.bind("SUPER + B", "Browser", { omarchy = "browser" })

-- F carries the file manager and full screen; stock spells the cwd variant
-- SUPER + ALT + SHIFT, so unbind has to match that order exactly.
hl.unbind("SUPER + F")
hl.unbind("SUPER + ALT + F")           -- was: Full width
hl.unbind("SUPER + SHIFT + F")         -- was: File manager
hl.unbind("SUPER + ALT + SHIFT + F")   -- was: File manager (cwd)
hl.unbind("SUPER + SHIFT + B")         -- duplicate of SUPER + B
hl.unbind("SUPER + SHIFT + RETURN")    -- duplicate of SUPER + B

o.bind("SUPER + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + ALT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + CTRL + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.unbind("SUPER + SHIFT + CTRL + A") -- was: Agent
hl.unbind("SUPER + M")                -- full screen moved to SUPER + ALT + F
o.bind("SUPER + A", "Agent", "omarchy-agent --pick")
o.bind("SUPER + D", "Docker", { tui = "omarchy-launch-docker-tui" })
o.bind("SUPER + E", "Proton Mail", webapp("https://mail.proton.me", "chrome-mail.proton.me__-Default"))
o.bind("SUPER + N", "Notion", webapp("https://www.notion.so", "chrome-www.notion.so__-Default"))
o.bind("SUPER + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + Y", "YouTube", { webapp = "https://youtube.com/" })

-- Mirrors default/hypr/bindings/clipboard.lua, whose helpers are file-local.
-- Terminals take CTRL+Insert since CTRL+C interrupts there. The down/up split
-- works around Hyprland leaving synthetic key state stuck.
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

o.bind("SUPER + ALT + C", "Universal copy", function()
  if active_window_is_terminal() then
    send_shortcut_once("CTRL", "Insert")()
  else
    send_shortcut_once("CTRL", "C")()
  end
end)

o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + CTRL + RETURN", "Herdr", { omarchy = "terminal-herdr" })
o.bind("SUPER + ALT + M", "Music", { omarchy = "spotify" })
o.bind("SUPER + ALT + S", "Signal", { omarchy = "signal" })
o.bind("SUPER + ALT + P", "Passwords", { omarchy = "1password" })

------------------------------------------------------------------------ menus --

-- SUPER + K is focus now, so the cheatsheet lives here, with tmux's alongside it.
o.bind("CTRL + ALT + K", "Show key binds", "omarchy-menu-keybindings")
o.bind("CTRL + ALT + T", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

------------------------------------------------------------------ menus, take 2 --

-- Apps menu is reached far more often than the root menu, so they trade places.
hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + SPACE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy-menu toggle")

-- The SHIFT chords whose ALT equivalent was unoccupied. The rest stay put:
-- their ALT slot already holds the lighter half of the same pair (one
-- notification vs all, show reminders vs clear).
hl.unbind("SUPER + SHIFT + BACKSPACE")
o.bind("SUPER + ALT + BACKSPACE", "Toggle window gaps", "omarchy-hyprland-window-gaps-toggle")

hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + ALT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

hl.unbind("SUPER + SHIFT + ALT + B")
o.bind("SUPER + ALT + B", "Browser (private)", { omarchy = "browser --private" })

hl.unbind("SUPER + SHIFT + CTRL + SPACE")
o.bind("SUPER + CTRL + ALT + SPACE", "Theme menu", "omarchy-menu toggle theme")
