--[[
	Aether - Bag Plugin
	
	Displays bag space information
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create plugin
local Plugin = {
	name = "Bag",
	enabled = true,
	bar = "top1",
	position = "right",
	updateInterval = 1.0,
}

--[[
	Initialize the plugin
]]--
function Plugin:Initialize()
	-- Create frame
	self.frame = CreateFrame("Button", "AetherPluginBag", UIParent)
	self.frame:SetSize(100, Aether.C.PANEL.DEFAULT_HEIGHT)
	
	-- Create text
	self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.text:SetPoint("CENTER")
	self.text:SetTextColor(1, 1, 1)
	
	-- Register events
	self.frame:RegisterEvent("BAG_UPDATE")
	self.frame:SetScript("OnEvent", function(frame, event)
		self:Update()
	end)
	
	-- Tooltip
	self.frame:SetScript("OnEnter", function(frame)
		self:ShowTooltip()
	end)
	
	self.frame:SetScript("OnLeave", function(frame)
		GameTooltip:Hide()
	end)
	
	-- Initial update
	self:Update()
end

--[[
	Update plugin display
]]--
function Plugin:Update()
	local free, total = Aether.U.GetBagSlotInfo()
	local used = total - free
	
	-- Color code based on space
	local color
	local pct = free / total
	if pct > 0.5 then
		color = Aether.C.COLOR_CODES.GREEN
	elseif pct > 0.25 then
		color = Aether.C.COLOR_CODES.YELLOW
	else
		color = Aether.C.COLOR_CODES.RED
	end
	
	self.text:SetText(color .. free .. "/" .. total .. Aether.C.COLOR_CODES.CLOSE)
	
	-- Adjust frame width to text
	self.frame:SetWidth(self.text:GetStringWidth() + 10)
end

--[[
	Show tooltip
]]--
function Plugin:ShowTooltip()
	GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Bag Space", 1, 1, 1)
	
	local free, total = Aether.U.GetBagSlotInfo()
	local used = total - free
	
	GameTooltip:AddDoubleLine("Free:", free, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Used:", used, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Total:", total, 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end

-- Register plugin
if Aether.PluginSystem then
	Aether.PluginSystem:RegisterPlugin(Plugin)
end
