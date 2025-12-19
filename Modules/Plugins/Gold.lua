--[[
	Aether - Gold Plugin
	
	Displays gold amount with tracking
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create plugin
local Plugin = {
	name = "Gold",
	enabled = true,
	bar = "top1",
	position = "left",
	updateInterval = 1.0,
	sessionStart = 0,
	sessionGold = 0,
}

--[[
	Initialize the plugin
]]--
function Plugin:Initialize()
	-- Create frame
	self.frame = CreateFrame("Button", "AetherPluginGold", UIParent)
	self.frame:SetSize(100, Aether.C.PANEL.DEFAULT_HEIGHT)
	
	-- Create text
	self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.text:SetPoint("CENTER")
	self.text:SetTextColor(1, 1, 1)
	
	-- Track session start
	self.sessionStart = GetMoney()
	self.sessionGold = 0
	
	-- Register events
	self.frame:RegisterEvent("PLAYER_MONEY")
	self.frame:SetScript("OnEvent", function(frame, event)
		if event == "PLAYER_MONEY" then
			local current = GetMoney()
			self.sessionGold = current - self.sessionStart
			self:Update()
		end
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
	local money = GetMoney()
	local gold = math.floor(money / 10000)
	
	self.text:SetText(Aether.C.COLOR_CODES.GOLD .. gold .. "g" .. Aether.C.COLOR_CODES.CLOSE)
	
	-- Adjust frame width
	self.frame:SetWidth(self.text:GetStringWidth() + 10)
end

--[[
	Show tooltip
]]--
function Plugin:ShowTooltip()
	GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Gold", 1, 1, 1)
	
	local money = GetMoney()
	GameTooltip:AddDoubleLine("Total:", Aether.U.FormatMoney(money), 1, 1, 1)
	
	GameTooltip:AddLine(" ", 1, 1, 1)
	GameTooltip:AddLine("Session:", 0.8, 0.8, 0.8)
	
	local sessionColor = self.sessionGold >= 0 and "|cff00FF00" or "|cffFF0000"
	local sessionSign = self.sessionGold >= 0 and "+" or ""
	GameTooltip:AddLine(sessionSign .. Aether.U.FormatMoney(math.abs(self.sessionGold)), 1, 1, 1)
	
	GameTooltip:Show()
end

-- Register plugin
if Aether.PluginSystem then
	Aether.PluginSystem:RegisterPlugin(Plugin)
end
