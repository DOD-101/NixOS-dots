-- luacheck: ignore hl

local vars = require("vars")

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("EGL_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.config({
	misc = { force_default_wallpaper = 0 },
	input = {
		kb_options = "caps:escape",
		kb_layout = "de",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = false,
		},
	},
	general = {
		layout = "dwindle",
		allow_tearing = false,
	},
	dwindle = {
		preserve_split = true,
	},
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.workspace_rule({
	workspace = "special:float",
	on_created_empty = vars.terminal,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("wl-paste --watch cliphist store")
end)
