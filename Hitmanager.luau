local hit = {}

local runs = game:GetService("RunService")
local reps = game:GetService("ReplicatedStorage")

local statment = require(script.Parent.Parent.PlayerStatment)
local types = require(script.Parent.Parent.HitBox.Types)

local damages = {
	Default = {
		["1"] = 6,
		["2"] = 7,
		["3"] = 5,
		["4"] = 6,
		["5"] = 7,
		["5f"] = 9,
	}
}
local assets = reps.Assets
local combatAssets = assets.Combat

function Emit(vfx)
	game.Debris:AddItem(vfx, 10)
	for _,v in pairs(vfx:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local emitcount = v:GetAttribute("EmitCount")
			v:Emit(emitcount)
		end
	end
end


function hit.HighLight()
	local self = setmetatable({}, hit) :: types.HighlightModule
	
	self.Parent = nil
	self.DephtMode = Enum.HighlightDepthMode.Occluded
	self.FillColor = Color3.new(1,0,0)
	self.FillTransparency = .5
	self.OutlineColor = Color3.new(.75,.75,.75)
	self.OutlineTransparency = .25
	
	self.FadeIn = true
	self.FadeInTime = .125
	self.FadeOut = true
	self.FadeOutTime = .25
	self.LifeTime = .25
	
	return self
end

function hit._createhl(self: types.HighlightModule)
	local hl = Instance.new("Highlight", self.Parent)
	hl.DepthMode = self.DephtMode
	hl.FillColor = self.FillColor
	hl.OutlineColor = self.OutlineColor
	
	if self.FadeIn == true then
		hl.FillTransparency = 0
		hl.OutlineTransparency = 0
		
		local tween = game:GetService("TweenService"):Create(hl, TweenInfo.new(self.FadeInTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FillTransparency = self.FillTransparency, OutlineTransparency = self.OutlineTransparency})
		tween:Play()
		tween.Completed:Wait()
	else
		hl.FillTransparency = self.FillTransparency
		hl.OutlineTransparency = self.OutlineTransparency
	end
	if self.FadeOut == true then
		game.Debris:AddItem(hl, self.LifeTime + self.FadeOutTime)
		
		task.delay(self.LifeTime, function()
			local tween = game:GetService("TweenService"):Create(hl, TweenInfo.new(self.FadeOutTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FillTransparency = 1, OutlineTransparency = 1})
			tween:Play()
			tween.Completed:Wait()
		end)
	else
		game.Debris:AddItem(hl, self.LifeTime)
	end
	
	return hl
end

function hit.Hit(hitted, swordE, combo, direction)
	local hum:Humanoid = hitted:FindFirstChildOfClass("Humanoid")
	
	local hlchanger = hit.HighLight()
	hlchanger.Parent = hitted
	
	local hl = hit._createhl(hlchanger)
	
	hum:TakeDamage(damages[swordE][combo])
	
	local fx = combatAssets.FX:FindFirstChild(swordE).NormalImpact.Attachment:Clone()
	fx.Parent = hum.RootPart
	Emit(fx)
	
	if combo == "5f" then
		local force = direction + Vector3.new(0, game.Workspace.Gravity*.2, 0)
		hum.RootPart:ApplyImpulse(force * hum.RootPart.AssemblyMass)
		
		local track = hum.Animator:LoadAnimation(combatAssets.Animations:FindFirstChild(swordE).Hitted.Knockback)
		track:Play()
	else
		local track = hum.Animator:LoadAnimation(combatAssets.Animations:FindFirstChild(swordE).Hitted.Hurt)
		track:Play()
	end
end

return hit
