--[[
	Aether - Clock Plugin
	
	Displays server time and/or local time
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create plugin
local Plugin = {
	name = "Clock",
	enabled = true,
	bar = "top1",
	position = "right",
	updateInterval = 1.0,
	showServerTime = true,
	showLocalTime = false,
	use24Hour = true,
}

--[[
	Initialize the plugin
]]--
function Plugin:Initialize()
	-- Create frame
	self.frame = CreateFrame("Button", "AetherPluginClock", UIParent)
	self.frame:SetSize(100, Aether.C.PANEL.DEFAULT_HEIGHT)
	
	-- Create text
	self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.text:SetPoint("CENTER")
	self.text:SetTextColor(1, 1, 1)
	
	-- Tooltip
	self.frame:SetScript("OnEnter", function(frame)
		self:ShowTooltip()
	end)
	
	self.frame:SetScript("OnLeave", function(frame)
		GameTooltip:Hide()
	end)
	
	-- Click handler to toggle time format
	self.frame:SetScript("OnClick", function(frame, button)
		if button == "LeftButton" then
			self.use24Hour = not self.use24Hour
			self:Update()
		end
	end)
	
	-- Initial update
	self:Update()
end

--[[
	Update plugin display
]]--
function Plugin:Update()
	local timeStr = ""
	
	if self.showServerTime then
		local hour, minute = GetGameTime()
		if not self.use24Hour then
			local ampm = hour >= 12 and "PM" or "AM"
			hour = hour % 12
			if hour == 0 then hour = 12 end
			timeStr = string.format("%d:%02d %s", hour, minute, ampm)
		else
			timeStr = string.format("%02d:%02d", hour, minute)
		end
	elseif self.showLocalTime then
		local timeFormat = self.use24Hour and "%H:%M" or "%I:%M %p"
		timeStr = date(timeFormat)
	end
	
	self.text:SetText(Aether.C.COLOR_CODES.AETHER .. timeStr .. Aether.C.COLOR_CODES.CLOSE)
	
	-- Adjust frame width
	self.frame:SetWidth(self.text:GetStringWidth() + 10)
end

--[[
	Show tooltip
]]--
function Plugin:ShowTooltip()
	GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Time", 1, 1, 1)
	
	local serverHour, serverMinute = GetGameTime()
	local serverTime = string.format("%02d:%02d", serverHour, serverMinute)
	
	local localTime = date("%H:%M")
	local localDate = date("%A, %B %d, %Y")
	
	GameTooltip:AddDoubleLine("Server Time:", serverTime, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Local Time:", localTime, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Date:", localDate, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine(" ", 1, 1, 1)
	GameTooltip:AddLine("Click to toggle 12/24 hour format", 0.5, 0.5, 0.5)
	
	GameTooltip:Show()
end

-- Register plugin
if Aether.PluginSystem then
	Aether.PluginSystem:RegisterPlugin(Plugin)
end
