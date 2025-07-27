local module = {}

local statment = require(script.Parent.PlayerStatment)

local ResetTime = 2

function module:ResetCombo(plr:Player, oldcombo)
	local pstat = statment:GetStatment(plr)
	
	task.delay(ResetTime, function()
		local cc = pstat["Combo"]
		
		if cc == 5 then return end
		
		if cc-1 == oldcombo and not pstat["Attacking"] then
			pstat["Combo"] = 1
		end
	end)
end

function module:Combo(plr:Player, maxcombo:number)
	local pstat = statment:GetStatment(plr)
	
	if pstat["Combo"] +1 <= maxcombo then
		pstat["Combo"] += 1
	else
		pstat["Stunned"] = true
		pstat["Combo"] = 1

		task.wait(2)

		pstat["Stunned"] = false
	end
end

return module
