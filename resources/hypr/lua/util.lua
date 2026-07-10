-- luacheck: ignore hl

local U = {}

---Create 3 workspaces for monitors
---@param monitor string Monitor name
---@param start integer starting workspace number
function U.workspacesForMonitor(monitor, start)
	hl.workspace_rule({ workspace = tostring(start), monitor = monitor, persistent = true, default = true })

	for i = start + 1, start + 2 do
		hl.workspace_rule({ workspace = tostring(i), monitor = monitor, persistent = true })
	end
end

return U
