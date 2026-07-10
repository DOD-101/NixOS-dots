-- luacheck: ignore hl
if hl.plugin.hyprgrass == nil then
	return
end

local vars = require("vars")

hl.config({
	plugin = {
		hyprgrass = {
			sensitivity = 4.0,
			edge_margin = 40,
		},
	},
})

hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "edge",
		origin = "r",
		direction = "l",
	},
	action = hl.dsp.focus({ workspace = "+1" }),
})

hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "edge",
		origin = "l",
		direction = "r",
	},
	action = hl.dsp.focus({ workspace = "-1" }),
})

hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "tap",
		fingers = 3,
	},
	action = hl.dsp.exec_cmd(vars.terminal),
})

hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "tap",
		fingers = 4,
	},
	action = hl.dsp.exec_cmd("xournalpp"),
})

-- TODO: add dynamic window close (by dragging to top of screen)
hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "longpress",
		fingers = 2,
	},
	action = hl.dsp.window.drag(),
	mouse = true,
})

hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "longpress",
		fingers = 3,
	},
	action = hl.dsp.window.resize(),
	mouse = true,
})
