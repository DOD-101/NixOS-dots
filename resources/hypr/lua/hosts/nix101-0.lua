-- luacheck: ignore hl

local vars = require("vars")
local util = require("util")

-- monitors
hl.monitor({
	output = "DP-4",
	mode = "3440x1440@180",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "DP-6",
	mode = "3440x1440@180",
	position = "3440x0",
	scale = 1,
})

-- workspaces
util.workspacesForMonitor("DP-4", 1)
util.workspacesForMonitor("DP-6", 4)

hl.on("hyprland.start", function()
	hl.exec_cmd(vars.terminal, {
		workspace = "1 silent",
	})
	hl.exec_cmd(vars.browser, {
		workspace = "4 silent",
	})
end)

hl.bind("XF86Tools", hl.dsp.exec_cmd(vars.terminal))
hl.bind("XF86Launch9", hl.dsp.exec_cmd("keepassxc"))
hl.bind("XF86Launch8", hl.dsp.exec_cmd("gimp"))
hl.bind("XF86Launch7", hl.dsp.exec_cmd("steam"))
hl.bind("XF86Launch6", hl.dsp.exec_cmd(vars.browser))
hl.bind("XF86Launch5", hl.dsp.exec_cmd("vesktop"))
