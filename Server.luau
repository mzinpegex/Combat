local reps = game:GetService("ReplicatedStorage")
local sss = game:GetService("ServerScriptService")

local handler = require(sss.Assets.Combat.Modules.Handler)

local remote = reps.Assets.Remotes.Combat

remote.OnServerEvent:Connect(function(plr, action, ...)
	local data = {...}
	
	handler[action](plr, data)
end)
