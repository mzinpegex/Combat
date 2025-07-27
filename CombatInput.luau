local uis = game:GetService("UserInputService")
local reps = game:GetService("ReplicatedStorage")

local remote = reps.Assets.Remotes.Combat
local fov = 45

game.Workspace.CurrentCamera.FieldOfView = fov

uis.InputBegan:Connect(function(key, gpe)
	if gpe then return end
	
	if key.UserInputType == Enum.UserInputType.MouseButton1 then
		remote:FireServer("M1")
	elseif key.UserInputType == Enum.UserInputType.MouseButton2 then
		remote:FireServer("M2")
	elseif key.KeyCode == Enum.KeyCode.F then
		remote:FireServer("Blocking", true)
	elseif key.KeyCode == Enum.KeyCode.R then
		remote:FireServer("DrawSword")
	end
end)

uis.InputEnded:Connect(function(key, gpe)
	if gpe then return end
	
	if key.KeyCode == Enum.KeyCode.F then
		remote:FireServer("Blocking", false)
	end
end)
