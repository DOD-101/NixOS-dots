-- luacheck: ignore hl

local vars = require("vars")
local mainMod = vars.mainMod

hl.bind(mainMod .. "y", hl.dsp.window.fullscreen())

hl.bind(mainMod .. "CTRL + Delete", hl.dsp.exit())

hl.bind(mainMod .. "q", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. "r", hl.dsp.exec_cmd(vars.menu))

hl.bind(mainMod .. "c", hl.dsp.window.close())
hl.bind(mainMod .. "v", function()
	hl.dispatch(hl.dsp.window.float())
	hl.dispatch(hl.dsp.window.resize({
		x = 960,
		y = 640,
		relative = false,
	}))
end)

-- move focus (vim motions)
hl.bind(mainMod .. "h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. "j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. "k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "l", hl.dsp.focus({ direction = "right" }))

-- resize active window
hl.bind(mainMod .. "ALT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. "ALT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind(mainMod .. "ALT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. "ALT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))

-- move active window
hl.bind(mainMod .. "SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. "SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "SHIFT + l", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. "s", hl.dsp.layout("togglesplit"))

-- move (window) to workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. "+ SHIFT +" .. key, hl.dsp.window.move({ workspace = i }))
end

-- special workspace
hl.bind(mainMod .. "SHIFT + n", hl.dsp.window.move({ workspace = "special:float" }))
hl.bind(mainMod .. "n", hl.dsp.workspace.toggle_special("float"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy ; wl-paste > ~/Data/screenshot.png]]))

hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim - | wl-copy ; wl-paste > ~/Data/screenshot.png]]))

-- Audio
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%+"),
	{ repeating = true, locked = true }
)

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%-"),
	{ repeating = true, locked = true }
)

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind(
	"CTRL + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("spotify_player playback volume --offset 5"),
	{ repeating = true, locked = true }
)

hl.bind(
	"CTRL + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("spotify_player playback volume --offset -- -5"),
	{ repeating = true, locked = true }
)

hl.bind("CTRL + XF86AudioPlay", hl.dsp.exec_cmd("spotify_player playback play-pause"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- backlight
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { repeating = true, locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true, locked = true })

-- move/resize windows with mouse
hl.bind(mainMod .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Display
hl.bind(mainMod .. "b", hl.dsp.exec_cmd("dpms-toggle"), { locked = true })

-- Toggle window transparency
hl.bind(mainMod .. "i", hl.dsp.window.tag({ tag = "non_transparent" }))

if vars.hypr_config.hyprlock.enable then
	hl.bind(vars.mainMod .. "Delete", hl.dsp.exec_cmd("hyprlock"))
end
