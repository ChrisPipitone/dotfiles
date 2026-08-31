-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

hl.monitor({ output = "DP-1", mode = "2560x1440@143.87", position = "1080x0", scale = 1 })

-- transform 3 = rotated 270 degrees (portrait).
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@179.98", position = "0x0", scale = 1, transform = 3 })

-- Workspaces are pinned so they stop migrating between screens. The number row
-- is split by hand: 6-0 sit under the right hand on DP-1 (the primary set),
-- 1-2 stay on the portrait panel. 3/4/5 are retired in bindings.lua.
--
-- 9 spawns the dev session on first visit so the workspace carries the intent
-- rather than a startup script.
--
-- A rule applies when a workspace is created, so existing ones keep their
-- current monitor until they are recreated or you log in again.
for _, ws in ipairs({ "1", "2", "3" }) do
  hl.workspace_rule({ workspace = ws, monitor = "HDMI-A-1" })
end

for _, ws in ipairs({ "6", "7", "8", "9", "10" }) do
  hl.workspace_rule({ workspace = ws, monitor = "DP-1" })
end

-- The scratchpad stays a tiling workspace; it is just inset so it reads as a
-- panel over the current one. 384/216 leaves ~70% of DP-1. gaps_out needs a
-- scalar or a table keyed top/right/bottom/left — a positional table parses
-- but is silently ignored.
hl.workspace_rule({
  workspace = "special:scratchpad",
  gaps_out = { top = 216, right = 384, bottom = 216, left = 384 },
})

hl.workspace_rule({
  workspace = "9",
  on_created_empty = [[foot --app-id=tmux-work -e bash -c 'tmux attach || tmux new -s Work']],
})
