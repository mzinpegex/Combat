local hitbox = {}
hitbox.__index = hitbox

local statment = require(script.Parent.PlayerStatment)
local types = require(script.Types)

local get_CFrame = {
	["Instance"] = function(point)
		return point.CFrame
	end,

	["CFrame"] = function(point)
		return point
	end,
}

function hitbox.CreateHitbox()
	local self = setmetatable({}, hitbox) :: types.Hitbox
	self.DetectionMode = "Default"
	self.Shape = Enum.PartType.Block
	self.Size = Vector3.new(5,5,5)
	self.CFrame = CFrame.new(0,0,0)
	self.Offset = CFrame.new(0,0,0)
	self.VelocityPredictionTime = 1
	self.VelocityPrediction = false
	self.OverlapParams = OverlapParams.new()
	self.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude;self.OverlapParams.FilterDescendantsInstances = {}
	self.HitList = {}
	self.TouchingParts = {}
	self.Connection = nil
	return self
end

function hitbox.CastSpatialQuery(self: types.Hitbox) : {BasePart}?
	local point_type: CFrame | string = typeof(self.CFrame)
	local point_cframe: CFrame = get_CFrame[point_type](self.CFrame)

	local parts
	local hitboxCFrame: CFrame = point_cframe * self.Offset

	if self.Shape == Enum.PartType.Block then
		parts = workspace:GetPartBoundsInBox(hitboxCFrame, self.Size, self.OverlapParams)
	elseif self.Shape == Enum.PartType.Ball then
		parts = workspace:GetPartBoundsInRadius(hitboxCFrame.Position, self.Size, self.OverlapParams)
	else
		error("Part type: " .. self.Shape .. " isn't compatible with this module")
	end

	return parts
end

return hitbox
