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

hl.window_rule({
	match = {
		tag = "closing",
	},
	border_color = "#FF0000",
})

local function cursorInTop()
	local top_border = hl.get_active_monitor().height / 10
	return hl.get_cursor_pos().y < top_border
end

local close_animation_timer = hl.timer(function()
	if cursorInTop() then
		hl.dispatch(hl.dsp.window.tag({ tag = "+closing" }))
	else
		hl.dispatch(hl.dsp.window.tag({ tag = "-closing" }))
	end
end, { timeout = 100, type = "repeat" })

close_animation_timer:set_enabled(false)

local longpress_release = false
hl.plugin.hyprgrass.bind({
	pattern = {
		kind = "longpress",
		fingers = 2,
	},
	action = function()
		if longpress_release then
			if cursorInTop() then
				hl.dispatch(hl.dsp.window.close())
				-- if the window didn't close for some reason remove the closing tag again
				hl.dispatch(hl.dsp.window.tag({ tag = "-closing" }))
			end

			close_animation_timer:set_enabled(false)
		else
			close_animation_timer:set_enabled(true)
		end
		hl.dispatch(hl.dsp.window.drag())

		longpress_release = not longpress_release
	end,
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
