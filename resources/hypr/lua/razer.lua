-- luacheck: ignore hl

hl.on("hyprland.start", function()
	hl.exec_cmd("config-store set scroll_mode --value 0 --alternate 1")
	hl.exec_cmd("config-store set scroll_speed --value 3200 --alternate 7500")
	hl.exec_cmd("polychromatic-cli -d mouse -z main -o scroll_mode -p $(config-store get scroll_mode)")
	hl.exec_cmd("polychromatic-cli -d mouse --dpi $(config-store get scroll_speed)")
end)

hl.bind(
	"SHIFT + CTRL + ALT + F2",
	hl.dsp.exec_cmd("polychromatic-cli -d mouse -z main -o scroll_mode -p $(config-store toggle scroll_mode)")
)
hl.bind(
	"SHIFT + CTRL + ALT + F3",
	hl.dsp.exec_cmd("polychromatic-cli -d mouse --dpi $(config-store toggle scroll_speed)")
)
