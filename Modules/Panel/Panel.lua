-- Aether: Panel.lua
-- Main panel/bar system (Titan Panel style)

local Panel = {}
Aether:RegisterModule("Panel", Panel)

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

Panel.bars = {}
Panel.plugins = {}

function Panel:Initialize()
	if not Aether.db.profile.panel.enabled then return end
	
	self:CreateBars()
	self:LoadPlugins()
end

function Panel:CreateBars()
	-- Create Top Bar 1
	self.bars.topBar1 = self:CreateBar("AetherTopBar1", "TOP")
	
	-- Create Bottom Bar 1
	self.bars.bottomBar1 = self:CreateBar("AetherBottomBar1", "BOTTOM")
	
	self:UpdateBars()
end

function Panel:CreateBar(name, anchor)
	local bar = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
	bar:SetHeight(Aether.db.profile.panel.topBar1.height)
	bar:SetPoint("TOPLEFT", UIParent, anchor.."LEFT", 0, anchor == "TOP" and 0 or 0)
	bar:SetPoint("TOPRIGHT", UIParent, anchor.."RIGHT", 0, anchor == "TOP" and 0 or 0)
	
	bar:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	bar:SetBackdropColor(0, 0, 0, Aether.db.profile.panel.topBar1.alpha)
	bar:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
	-- Create plugin container
	bar.leftPlugins = CreateFrame("Frame", nil, bar)
	bar.leftPlugins:SetPoint("LEFT", bar, "LEFT", 8, 0)
	bar.leftPlugins:SetSize(400, bar:GetHeight() - 8)
	
	bar.rightPlugins = CreateFrame("Frame", nil, bar)
	bar.rightPlugins:SetPoint("RIGHT", bar, "RIGHT", -8, 0)
	bar.rightPlugins:SetSize(400, bar:GetHeight() - 8)
	
	bar.anchor = anchor
	bar:Show()
	
	return bar
end

function Panel:UpdateBars()
	for name, bar in pairs(self.bars) do
		if bar then
			bar:SetAlpha(Aether.db.profile.panel.topBar1.alpha)
		end
	end
end

function Panel:LoadPlugins()
	-- Register built-in plugins
	self:RegisterPlugin("Bag", Aether:GetModule("PluginBag"))
	self:RegisterPlugin("Clock", Aether:GetModule("PluginClock"))
	self:RegisterPlugin("Gold", Aether:GetModule("PluginGold"))
	self:RegisterPlugin("Location", Aether:GetModule("PluginLocation"))
	self:RegisterPlugin("Performance", Aether:GetModule("PluginPerformance"))
	self:RegisterPlugin("Repair", Aether:GetModule("PluginRepair"))
	self:RegisterPlugin("Volume", Aether:GetModule("PluginVolume"))
	self:RegisterPlugin("XP", Aether:GetModule("PluginXP"))
	
	-- Create plugin buttons
	self:CreatePluginButtons()
end

function Panel:RegisterPlugin(name, plugin)
	if plugin then
		self.plugins[name] = plugin
	end
end

function Panel:CreatePluginButtons()
	local leftX = 0
	local rightX = 0
	
	for name, plugin in pairs(self.plugins) do
		if plugin and plugin.enabled then
			local button = self:CreatePluginButton(name, plugin)
			if button then
				-- Place on left side by default
				button:SetPoint("LEFT", self.bars.topBar1.leftPlugins, "LEFT", leftX, 0)
				leftX = leftX + button:GetWidth() + 4
			end
		end
	end
end

function Panel:CreatePluginButton(name, plugin)
	local button = CreateFrame("Button", "AetherPlugin"..name, self.bars.topBar1.leftPlugins)
	button:SetSize(100, 20)
	
	button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.text:SetPoint("CENTER")
	button.text:SetText(name)
	
	button:SetScript("OnClick", function(self, btn)
		if plugin.OnClick then
			plugin:OnClick(btn)
		end
	end)
	
	button:SetScript("OnEnter", function(self)
		if plugin.OnTooltipShow then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			plugin:OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)
	
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	-- Update button text periodically
	if plugin.UpdateButton then
		button.updateTimer = C_Timer.NewTicker(1, function()
			if plugin.UpdateButton then
				plugin:UpdateButton(button)
			end
		end)
	end
	
	button:Show()
	return button
end

function Panel:Toggle()
	for name, bar in pairs(self.bars) do
		if bar:IsShown() then
			bar:Hide()
		else
			bar:Show()
		end
	end
end

function Panel:Show()
	for name, bar in pairs(self.bars) do
		bar:Show()
	end
end

function Panel:Hide()
	for name, bar in pairs(self.bars) do
		bar:Hide()
	end
end

function Panel:Refresh()
	self:UpdateBars()
end
