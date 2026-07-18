-- luacheck: ignore hl
local vars = require("vars")

-- opacity
hl.window_rule({
	match = { class = vars.terminal },
	opacity = "0.95 override 0.7 override",
})

hl.window_rule({
	match = { tag = "non_transparent" },
	opacity = "1.0 override",
})

-- edge cases
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	match = {
		title = ".*YouTube.*",
		class = vars.browser,
	},
	opacity = "1.0 override",
})

-- thunderbird mail pop-up
hl.window_rule({
	match = { class = "thunderbird" },
	float = true,
})

hl.window_rule({
	match = {
		class = "thunderbird",
		initial_title = "Mozilla Thunderbird",
	},
	float = false,
})

hl.window_rule({
	match = { class = "swayimg" },
	float = true,
})
