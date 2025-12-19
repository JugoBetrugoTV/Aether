-- Aether: XP Plugin
-- Shows experience information

local PluginXP = {}
Aether:RegisterModule("PluginXP", PluginXP)

PluginXP.enabled = true

function PluginXP:UpdateButton(button)
	if UnitLevel("player") >= GetMaxPlayerLevel() then
		button.text:SetText("Max Level")
		return
	end
	
	local current = UnitXP("player")
	local max = UnitXPMax("player")
	local percent = (current / max) * 100
	
	button.text:SetText(string.format("XP: %d%%", percent))
end

function PluginXP:OnTooltipShow(tooltip)
	tooltip:AddLine("Experience Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local level = UnitLevel("player")
	tooltip:AddDoubleLine("Level:", level, 1, 1, 1, 1, 1, 1)
	
	if level < GetMaxPlayerLevel() then
		local current = UnitXP("player")
		local max = UnitXPMax("player")
		local percent = (current / max) * 100
		local remaining = max - current
		
		tooltip:AddDoubleLine("XP:", string.format("%d / %d (%.1f%%)", current, max, percent), 1, 1, 1, 1, 1, 1)
		tooltip:AddDoubleLine("Remaining:", remaining, 1, 1, 1, 1, 1, 1)
		
		local rested = GetXPExhaustion()
		if rested and rested > 0 then
			local restedPercent = (rested / max) * 100
			tooltip:AddDoubleLine("Rested:", string.format("%d (%.1f%%)", rested, restedPercent), 0, 0.5, 1, 0, 0.5, 1)
		end
	else
		tooltip:AddLine("You are at maximum level", 1, 1, 1)
	end
end
