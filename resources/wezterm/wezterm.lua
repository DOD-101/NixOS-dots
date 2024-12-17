local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

local config = {
	font = wezterm.font("FiraCode Nerd Font Mono"),
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	font_size = 15.0,
	color_scheme = "current_theme",
	hide_tab_bar_if_only_one_tab = true,
}

modal.enable_defaults("https://github.com/MLFlexer/modal.wezterm")
local key_table = require("ui_mode").key_table

local icons = {
	left_seperator = wezterm.nerdfonts.ple_left_half_circle_thick,
	key_hint_seperator = " | ",
	mod_seperator = "-",
}
local hint_colors = {
	key_hint_seperator = "Yellow",
	key = "Green",
	hint = "Red",
	bg = "Black",
	left_bg = "Gray",
}
local mode_colors = { bg = "Red", fg = "Black" }
local status_text = require("ui_mode").get_hint_status_text(icons, hint_colors, mode_colors)

modal.add_mode("UI", key_table, status_text)

local function first_key()
	return modal.activate_mode("UI")
end

config.keys = {
	-- ...
	-- your other keybindings
	{
		key = "u",
		mods = "ALT",
		action = modal.activate_mode("UI"),
	},

	{
		key = "g",
		mods = "ALT",
		action = first_key(),
	},
}

modal.apply_to_config(config)

config.colors = nil

config.key_tables = modal.key_tables

return config
