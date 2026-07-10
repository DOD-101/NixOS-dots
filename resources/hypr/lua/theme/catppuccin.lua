---@diagnostic disable: undefined-global
-- luacheck: ignore hl
-- luacheck: ignore color
hl.config({
	general = {
		gaps_in = 10,
		gaps_out = {
			top = 10,
			right = 15,
			bottom = 15,
			left = 15,
		},
		border_size = 2,
		col = {
			active_border = color.extras.accent,
			inactive_border = color.black,
		},
	},
	decoration = {
		rounding = 12,
		active_opacity = 0.95,
		inactive_opacity = 0.9,
		blur = {
			enabled = true,
			size = 2,
			passes = 2,
			noise = 0,
		},
		shadow = {
			enabled = false,
		},
	},
	animations = {
		enabled = true,
	},
})

-- curves
hl.curve("windows", {
	type = "bezier",
	points = {
		{ 0.39, 0.575 },
		{ 0.565, 1.0 },
	},
})

hl.curve("windowsIn", {
	type = "bezier",
	points = {
		{ 0.55, 0.055 },
		{ 0.675, 0.19 },
	},
})

hl.curve("border", {
	type = "bezier",
	points = {
		{ 0.5, 0.5 },
		{ 0.5, 0.5 },
	},
})

hl.curve("workspaces", {
	type = "bezier",
	points = {
		{ 0.455, 0.03 },
		{ 0.515, 0.955 },
	},
})

hl.curve("fade", {
	type = "bezier",
	points = {
		{ 0.19, 1.0 },
		{ 0.22, 1.0 },
	},
})

hl.curve("fadeIn", {
	type = "bezier",
	points = {
		{ 0.785, 0.135 },
		{ 0.15, 0.86 },
	},
})

hl.curve("fadeSwitch", {
	type = "bezier",
	points = {
		{ 0.77, 0.0 },
		{ 0.175, 1.0 },
	},
})

-- animations
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 7,
	bezier = "windows",
})

hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "windows",
	style = "popin 50%",
})

hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 5,
	bezier = "windows",
})

hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 7,
	bezier = "fade",
})

hl.animation({
	leaf = "fadeIn",
	enabled = false,
	speed = 3,
	bezier = "fadeIn",
})

hl.animation({
	leaf = "fadeSwitch",
	enabled = true,
	speed = 5,
	bezier = "fadeSwitch",
})

hl.animation({
	leaf = "border",
	enabled = true,
	speed = 4,
	bezier = "border",
})

hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 5,
	bezier = "workspaces",
})
