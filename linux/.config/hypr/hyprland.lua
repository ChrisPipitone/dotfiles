-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.windows")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Rootless Docker: daemon socket lives in the user runtime dir, not /var/run.
-- Hyprland-launched apps (Super+Shift+D -> omarchy-launch-docker-tui) need both:
-- DOCKER_HOST so the client finds the daemon, OMARCHY_DOCKER_SOCKET so the
-- launcher stops routing through pkexec to a root daemon that isn't running.
hl.env("DOCKER_HOST", "unix:///run/user/1000/docker.sock")
hl.env("OMARCHY_DOCKER_SOCKET", "/run/user/1000/docker.sock")
