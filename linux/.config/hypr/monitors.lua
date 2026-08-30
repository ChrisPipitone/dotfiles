-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

hl.monitor({ output = "DP-1", mode = "2560x1440@143.87", position = "1080x0", scale = 1 })

-- transform 3 = rotated 270 degrees (portrait).
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@179.98", position = "0x0", scale = 1, transform = 3 })
