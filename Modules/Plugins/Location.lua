--[[
	Aether - Location Plugin
	
	Displays current zone and coordinates
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Plugin = {
	name = "Location",
	enabled = true,
	bar = "top1",
	position = "left",
	updateInterval = 0.5,
}

function Plugin:Initialize()
	self.frame = CreateFrame("Button", "AetherPluginLocation", UIParent)
	self.frame:SetSize(150, Aether.C.PANEL.DEFAULT_HEIGHT)
	
	self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.text:SetPoint("CENTER")
	self.text:SetTextColor(1, 1, 1)
	
	self.frame:RegisterEvent("ZONE_CHANGED")
	self.frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	
	self.frame:SetScript("OnEvent", function() self:Update() end)
	self.frame:SetScript("OnEnter", function() self:ShowTooltip() end)
	self.frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	self:Update()
end

function Plugin:Update()
	local zoneName = GetZoneText() or GetRealZoneText() or "Unknown"
	self.text:SetText(Aether.C.COLOR_CODES.AETHER .. zoneName .. Aether.C.COLOR_CODES.CLOSE)
	self.frame:SetWidth(self.text:GetStringWidth() + 10)
end

function Plugin:ShowTooltip()
	GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Location", 1, 1, 1)
	
	local zone = GetZoneText() or "Unknown"
	local subzone = GetSubZoneText() or ""
	
	GameTooltip:AddDoubleLine("Zone:", zone, 1, 1, 1, 1, 1, 1)
	if subzone ~= "" then
		GameTooltip:AddDoubleLine("Subzone:", subzone, 1, 1, 1, 1, 1, 1)
	end
	
	-- Get coordinates if available
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		if position then
			local x, y = position:GetXY()
			GameTooltip:AddDoubleLine("Coordinates:", string.format("%.1f, %.1f", x * 100, y * 100), 1, 1, 1, 1, 1, 1)
		end
	end
	
	GameTooltip:Show()
end

if Aether.PluginSystem then
	Aether.PluginSystem:RegisterPlugin(Plugin)
end
