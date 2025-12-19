-- Aether: Location Plugin
-- Shows current location and coordinates

local PluginLocation = {}
Aether:RegisterModule("PluginLocation", PluginLocation)

PluginLocation.enabled = true

function PluginLocation:UpdateButton(button)
	local zone = GetZoneText() or GetSubZoneText() or "Unknown"
	
	if Aether.db.profile.plugins.location.showCoords then
		local x, y = Aether.Utils:GetPlayerPosition()
		button.text:SetText(string.format("%s (%.1f, %.1f)", zone, x, y))
	else
		button.text:SetText(zone)
	end
end

function PluginLocation:OnTooltipShow(tooltip)
	tooltip:AddLine("Location Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local zone = GetZoneText() or "Unknown"
	local subzone = GetSubZoneText() or ""
	local x, y = Aether.Utils:GetPlayerPosition()
	
	tooltip:AddDoubleLine("Zone:", zone, 1, 1, 1, 1, 1, 1)
	if subzone ~= "" and subzone ~= zone then
		tooltip:AddDoubleLine("Subzone:", subzone, 1, 1, 1, 1, 1, 1)
	end
	tooltip:AddDoubleLine("Coordinates:", string.format("%.1f, %.1f", x, y), 1, 1, 1, 1, 1, 1)
	
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then
		local mapInfo = C_Map.GetMapInfo(mapID)
		if mapInfo then
			tooltip:AddDoubleLine("Map:", mapInfo.name, 1, 1, 1, 1, 1, 1)
		end
	end
end
