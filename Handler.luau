local module = {}

local runs = game:GetService("RunService")
local reps = game:GetService("ReplicatedStorage")

local statment = require(script.Parent.PlayerStatment)
local combo = require(script.Parent.Combo)
local hbmodule = require(script.Parent.HitBox)
local hitmanager = require(script.Parent.Combo.HitManager)

local assets = reps.Assets
local combatAssets = assets.Combat
local animations = combatAssets.Animations

function module:StopAnimations(plr, anim)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hum:Humanoid = char:FindFirstChildOfClass("Humanoid")
	
	for _,v in pairs(hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
		if v.Name == anim then
			v:Stop()
		end
	end
end 

module.M1 = function(plr)
	local pstat = statment:GetStatment(plr)
	
	if pstat["Attacking"] or pstat["Attacked"] or pstat["Stunned"] or pstat["Blocking"] or pstat["InAction"] or not pstat["Sword"] then return end
	pstat["Attacking"] = true; pstat["InAction"] = true
	
	local char = plr.Character or plr.CharacterAdded:Wait()

	local charparts = {
		["Head"] = char:FindFirstChild("Head"),
		["LArm"] = char:FindFirstChild("Left Arm"),
		["Torso"] = char:FindFirstChild("Torso"),
		["RArm"] = char:FindFirstChild("Right Arm"),
		["LLeg"] = char:FindFirstChild("Left Leg"),
		["RLeg"] = char:FindFirstChild("Right Leg"),
	}

	local hum:Humanoid = char:FindFirstChildOfClass("Humanoid")
	local animator = hum:FindFirstChildOfClass("Animator")
	local rp = hum.RootPart
	
	local trackF = animations:FindFirstChild(pstat["SwordE"]):FindFirstChild("Swings")
	
	local maxcombo = #trackF:GetChildren()
	
	module:StopAnimations(plr, "Idle")
	
	local track = animator:LoadAnimation(trackF:FindFirstChild(pstat["Combo"]))
	track:Play()
	
	task.delay(.15, function()
		local soundtrack = combatAssets.SFX:FindFirstChild(pstat["SwordE"]).Swing:Clone()
		soundtrack.Parent = rp
		soundtrack:Play()
		game.Debris:AddItem(soundtrack, soundtrack.TimeLength)
	end)
	
	local hb = hbmodule.CreateHitbox()
	hb.Size = Vector3.new(6,6,6)
	hb.CFrame = rp.CFrame + rp.CFrame.LookVector * hb.Size.Z/2
	hb.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	hb.OverlapParams.FilterDescendantsInstances = {char}
	
	local olaphb = hbmodule.CastSpatialQuery(hb)
	if #olaphb > 0 then
		if #olaphb > 0 then
			for _,v in pairs(olaphb) do
				if v.Parent:FindFirstChildOfClass("Humanoid") and not hb.HitList[v.Parent] then
					hb.HitList[v.Parent] = true
					
					hitmanager.Hit(v.Parent, pstat["SwordE"], tostring(pstat["Combo"]))
				end
			end
		end
	end
	
	task.delay(.65, function()
		if pstat["Combo"] == maxcombo then
			task.delay(.1, function()
				local soundtrack2 = combatAssets.SFX:FindFirstChild(pstat["SwordE"]).Swing:Clone()
				soundtrack2.Parent = rp
				soundtrack2:Play()
				game.Debris:AddItem(soundtrack2, soundtrack2.TimeLength)
			end)
			
			local hb2 = hbmodule.CreateHitbox()
			hb2.Size = Vector3.new(6,6,6)
			hb2.CFrame = rp.CFrame + rp.CFrame.LookVector * hb2.Size.Z/2
			hb2.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
			hb2.OverlapParams.FilterDescendantsInstances = {char}

			local olaphb2 = hbmodule.CastSpatialQuery(hb2)
			if #olaphb2 > 0 then
				for _,v in pairs(olaphb2) do
					if v.Parent:FindFirstChildOfClass("Humanoid") and not hb2.HitList[v.Parent] then
						hb2.HitList[v.Parent] = true
						hitmanager.Hit(v.Parent, pstat["SwordE"], "5f", rp.CFrame.LookVector * 75)
					end
				end
			end
		end
	end)
	
	track.Stopped:Connect(function()
		combo:ResetCombo(plr, pstat["Combo"])
		local idle = animator:LoadAnimation(trackF.Parent:FindFirstChild("Idle"))
		idle:Play()
		task.wait(.12)
		
		pstat["Attacking"] = false; pstat["InAction"] = false
		
		combo:Combo(plr, maxcombo)
	end)
end

module.M2 = function()
	
end

module.Blocking = function()
	
end

module.DrawSword = function(plr)
	local pstat = statment:GetStatment(plr)

	if pstat["Attacking"] or pstat["Attacked"] or pstat["Stunned"] or pstat["Blocking"] or pstat["InAction"] then return end
	pstat["InAction"] = true
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	
	local charparts = {
		["Head"] = char:FindFirstChild("Head"),
		["LArm"] = char:FindFirstChild("Left Arm"),
		["Torso"] = char:FindFirstChild("Torso"),
		["RArm"] = char:FindFirstChild("Right Arm"),
		["LLeg"] = char:FindFirstChild("Left Leg"),
		["RLeg"] = char:FindFirstChild("Right Leg"),
	}
	
	local hum:Humanoid = char:FindFirstChildOfClass("Humanoid")
	local animator = hum:FindFirstChildOfClass("Animator")
	local rp = hum.RootPart
	
	local sword = rp:FindFirstChild("Sword")
	
	if sword then
		if pstat["Sword"] == false then
			pstat["Sword"] = true
			local Handler6D = rp:FindFirstChild("Handler6D")
			Handler6D.Part0 = charparts["RArm"]
			Handler6D.C0 = sword:FindFirstChild("Handler"):GetAttribute("C0_arm")

			local trackF = animations:FindFirstChild(pstat["SwordE"])
			if trackF then
				local track = animator:LoadAnimation(trackF.Draw)
				track:Play()
				
				task.delay(.1, function()
					local soundtrack = combatAssets.SFX:FindFirstChild(pstat["SwordE"]).Draw:Clone()
					soundtrack.Parent = rp
					soundtrack:Play()
					game.Debris:AddItem(soundtrack, soundtrack.TimeLength)
				end)
				
				track.Stopped:Connect(function()
					local track2 = animator:LoadAnimation(trackF.Idle)
					track2:Play()
				end)
			end
		else
			pstat["Sword"] = false

			module:StopAnimations(plr, "Idle")

			local trackF = animations:FindFirstChild(pstat["SwordE"])
			if trackF then
				local track = animator:LoadAnimation(trackF.Sheath)
				track:Play()
				
				task.delay(.1, function()
					local soundtrack2 = combatAssets.SFX:FindFirstChild(pstat["SwordE"]).Swing:Clone()
					soundtrack2.Parent = rp
					soundtrack2:Play()
					game.Debris:AddItem(soundtrack2, soundtrack2.TimeLength)
					
					task.delay(.3, function()
						local soundtrack = combatAssets.SFX:FindFirstChild(pstat["SwordE"]).Sheath:Clone()
						soundtrack.Parent = rp
						soundtrack:Play()
						game.Debris:AddItem(soundtrack, soundtrack.TimeLength)
					end)
				end)
				
				while track.TimePosition < 1.3 do task.wait() end

				local Handler6D = rp:FindFirstChild("Handler6D")
				Handler6D.Part0 = charparts["Torso"]
				Handler6D.C0 = sword:FindFirstChild("Handler"):GetAttribute("C0_torso")
			end
		end

		task.wait(2)

		pstat["InAction"] = false
	end
end

return module
