-- luacheck: ignore hl

local vars = require("vars")

hl.bind("CTRL + ALT + v", hl.dsp.exec_cmd("dod-shell-launcher '&'"))
hl.bind(vars.mainMod .. "o", hl.dsp.exec_cmd("osk-toggle"))

hl.layer_rule({
	match = { namespace = "dod-shell-launcher" },
	dim_around = true,
})
