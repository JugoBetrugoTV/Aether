--[[
	Aether - Performance Plugin
	
	Displays FPS, memory, and latency
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Plugin = {
	name = "Performance",
	enabled = true,
	bar = "top1",
	position = "right",
	updateInterval = 2.0,
}

function Plugin:Initialize()
	self.frame = CreateFrame("Button", "AetherPluginPerformance", UIParent)
	self.frame:SetSize(120, Aether.C.PANEL.DEFAULT_HEIGHT)
	
	self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.text:SetPoint("CENTER")
	self.text:SetTextColor(1, 1, 1)
	
	self.frame:SetScript("OnEnter", function() self:ShowTooltip() end)
	self.frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	self:Update()
end

function Plugin:Update()
	local fps = Aether.U.GetFPS()
	local home, world = Aether.U.GetLatency()
	
	-- Color code FPS
	local fpsColor
	if fps >= 60 then
		fpsColor = Aether.C.COLOR_CODES.GREEN
	elseif fps >= 30 then
		fpsColor = Aether.C.COLOR_CODES.YELLOW
	else
		fpsColor = Aether.C.COLOR_CODES.RED
	end
	
	self.text:SetText(fpsColor .. fps .. " FPS" .. Aether.C.COLOR_CODES.CLOSE)
	self.frame:SetWidth(self.text:GetStringWidth() + 10)
end

function Plugin:ShowTooltip()
	GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Performance", 1, 1, 1)
	
	local fps = Aether.U.GetFPS()
	local home, world = Aether.U.GetLatency()
	local memory = Aether.U.GetAddonMemory()
	
	GameTooltip:AddDoubleLine("FPS:", fps, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Home Latency:", home .. " ms", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("World Latency:", world .. " ms", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Addon Memory:", Aether.U.FormatMemory(memory), 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end

if Aether.PluginSystem then
	Aether.PluginSystem:RegisterPlugin(Plugin)
end
