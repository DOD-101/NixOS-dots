---@diagnostic disable: undefined-global
--luacheck: globals swayimg

local function move_view(percent_x, percent_y)
	return function()
		local wnd = swayimg.get_window_size()
		local pos = swayimg.viewer.get_position()
		swayimg.viewer.set_abs_position(
			pos.x + math.floor(wnd.width * percent_x / 100),
			pos.y + math.floor(wnd.height * percent_y / 100)
		)
	end
end

swayimg.viewer.limit_preload(3)
swayimg.viewer.limit_history(2)
swayimg.viewer.set_window_background(0x00000000)

swayimg.viewer.on_key("h", move_view(10, 0))
swayimg.viewer.on_key("j", move_view(0, -10))
swayimg.viewer.on_key("k", move_view(0, 10))
swayimg.viewer.on_key("l", move_view(-10, 0))

swayimg.viewer.on_key("Shift+j", function()
	swayimg.viewer.switch_image("prev")
end)
swayimg.viewer.on_key("Shift+k", function()
	swayimg.viewer.switch_image("next")
end)
swayimg.viewer.on_key("Shift+equal", function()
	swayimg.viewer.set_fix_scale("fill")
end)

local antialiasing = true
swayimg.viewer.on_key("a", function()
	swayimg.enable_antialiasing(antialiasing)
	antialiasing = not antialiasing
end)

swayimg.viewer.on_key("r", function()
	swayimg.viewer.rotate(90)
end)
swayimg.viewer.on_key("Shift+r", function()
	swayimg.viewer.rotate(270)
end)

swayimg.gallery.on_key("h", function()
	swayimg.gallery.switch_image("left")
end)
swayimg.gallery.on_key("j", function()
	swayimg.gallery.switch_image("down")
end)
swayimg.gallery.on_key("k", function()
	swayimg.gallery.switch_image("up")
end)
swayimg.gallery.on_key("l", function()
	swayimg.gallery.switch_image("right")
end)
