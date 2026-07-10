-- luacheck: ignore hl

local vars = require("vars")
local util = require("util")

-- monitors
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "0x0",
	scale = 1,
})

-- workspaces
util.workspacesForMonitor("eDP-1", 1)

hl.on("hyprland.start", function()
	hl.exec_cmd(vars.terminal, {
		workspace = "1 silent",
	})
	hl.exec_cmd(vars.browser, {
		workspace = "2 silent",
	})
end)

local touchpadEnabled = true

hl.bind(vars.mainMod .. "p", function()
	touchpadEnabled = not touchpadEnabled
	hl.device({
		name = "elan06fa:00-04f3:31ad-touchpad",
		enabled = touchpadEnabled,
	})
end)
