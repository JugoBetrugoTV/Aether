-- Aether: Repair Plugin
-- Shows durability and repair cost

local PluginRepair = {}
Aether:RegisterModule("PluginRepair", PluginRepair)

PluginRepair.enabled = true

function PluginRepair:UpdateButton(button)
	local minDurability = 100
	
	for slot = 1, 18 do
		local current, maximum = GetInventoryItemDurability(slot)
		if current and maximum and maximum > 0 then
			local percent = (current / maximum) * 100
			if percent < minDurability then
				minDurability = percent
			end
		end
	end
	
	button.text:SetText(string.format("Durability: %d%%", minDurability))
	
	-- Color based on durability
	if minDurability < 25 then
		button.text:SetTextColor(1, 0, 0) -- Red
	elseif minDurability < 50 then
		button.text:SetTextColor(1, 1, 0) -- Yellow
	else
		button.text:SetTextColor(1, 1, 1) -- White
	end
end

function PluginRepair:OnTooltipShow(tooltip)
	tooltip:AddLine("Durability Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local slots = {
		[1] = "Head", [3] = "Shoulder", [5] = "Chest",
		[6] = "Waist", [7] = "Legs", [8] = "Feet",
		[9] = "Wrist", [10] = "Hands", [16] = "Main Hand",
		[17] = "Off Hand",
	}
	
	for slot, name in pairs(slots) do
		local current, maximum = GetInventoryItemDurability(slot)
		if current and maximum and maximum > 0 then
			local percent = (current / maximum) * 100
			local color
			if percent < 25 then
				color = {1, 0, 0}
			elseif percent < 50 then
				color = {1, 1, 0}
			else
				color = {1, 1, 1}
			end
			tooltip:AddDoubleLine(name..":", string.format("%d%%", percent), 1, 1, 1, color[1], color[2], color[3])
		end
	end
	
	tooltip:AddLine(" ")
	tooltip:AddLine("Visit a repair vendor to repair your items", 0.5, 0.5, 0.5)
end
