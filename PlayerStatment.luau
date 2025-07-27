local module = {}

local ps = game:GetService("Players")
local reps = game:GetService("ReplicatedStorage")

module.AllStatments = {}
local Assets = reps.Assets
local combatAssets = Assets.Combat

function module:NewStatment(plr:Player)
	local default = {
		Combo = 1,
		Attacking = false,
		Stunned = false,
		Blocking = false,
		Attacked = false,
		Sword = false,
		SwordE = "Default",
		InAction = false,
	}
	local new = table.clone(default)
	module.AllStatments[plr.UserId] = new
end

function module:GetStatment(plr:Player)
	return module.AllStatments[plr.UserId]
end

ps.PlayerAdded:Connect(function(plr)
	module:NewStatment(plr)
	
	task.wait()
	
	local pstat = module:GetStatment(plr)
	local sword = combatAssets.Mesh.Swords:FindFirstChild(pstat["SwordE"])
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid")
	local rp = hum.RootPart
	
	if sword then
		local clone = sword:Clone()
		clone.Parent = rp
		clone.Name = "Sword"
		
		local Handler6D = Instance.new("Motor6D", rp)
		Handler6D.Name = "Handler6D"
		Handler6D.Part0 = char:FindFirstChild("Torso")
		Handler6D.Part1 = clone:FindFirstChild("Handler")
		Handler6D.C0 = clone:FindFirstChild("Handler"):GetAttribute("C0_torso")
		
		if clone:FindFirstChild("Sheath") then
			local Sheath6D = Instance.new("Motor6D", rp)
			Sheath6D.Name = "Sheath"
			Sheath6D.Part0 = char:FindFirstChild("Torso")
			Sheath6D.Part1 = clone:FindFirstChild("Sheath")
			Sheath6D.C0 = clone:FindFirstChild("Sheath"):GetAttribute("C0")
		end
	end
	
end)

return module
