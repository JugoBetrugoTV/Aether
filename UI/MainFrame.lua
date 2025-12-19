--[[
	Aether - Main UI Frame
	
	Main options frame for the addon
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create UI table
Aether.UI = Aether.UI or {}
local UI = Aether.UI

-- Main frame
UI.mainFrame = nil

--[[
	Create the main options frame
]]--
function UI:CreateMainFrame()
	if self.mainFrame then
		return self.mainFrame
	end
	
	-- Create main frame
	local frame = CreateFrame("Frame", "AetherMainFrame", UIParent, "BasicFrameTemplateWithInset")
	frame:SetSize(800, 600)
	frame:SetPoint("CENTER")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetFrameStrata("DIALOG")
	frame:Hide()
	
	-- Title
	frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	frame.title:SetPoint("TOP", frame.TitleBg, 0, -3)
	frame.title:SetText("Aether v" .. Aether.version)
	
	-- Category list (left side)
	frame.categoryList = CreateFrame("ScrollFrame", "AetherCategoryList", frame, "UIPanelScrollFrameTemplate")
	frame.categoryList:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -30)
	frame.categoryList:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
	frame.categoryList:SetWidth(150)
	
	-- Category buttons
	frame.categories = {}
	local categories = {
		{name = "General", icon = nil},
		{name = "Panel", icon = nil},
		{name = "Plugins", icon = nil},
		{name = "Automation", icon = nil},
		{name = "Social", icon = nil},
		{name = "Chat", icon = nil},
		{name = "Tooltip", icon = nil},
		{name = "Minimap", icon = nil},
		{name = "Frames", icon = nil},
		{name = "System", icon = nil},
		{name = "Media", icon = nil},
		{name = "Interface", icon = nil},
		{name = "Profiles", icon = nil},
	}
	
	for i, category in ipairs(categories) do
		local btn = CreateFrame("Button", "AetherCategoryBtn" .. i, frame.categoryList, "UIPanelButtonTemplate")
		btn:SetSize(140, 30)
		btn:SetPoint("TOP", 0, -(i - 1) * 35)
		btn:SetText(category.name)
		btn:SetScript("OnClick", function()
			self:SelectCategory(category.name)
		end)
		
		frame.categories[category.name] = btn
	end
	
	-- Content area (right side)
	frame.content = CreateFrame("Frame", "AetherContent", frame)
	frame.content:SetPoint("TOPLEFT", frame.categoryList, "TOPRIGHT", 10, 0)
	frame.content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
	
	-- Content title
	frame.contentTitle = frame.content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	frame.contentTitle:SetPoint("TOP", frame.content, "TOP", 0, -10)
	frame.contentTitle:SetText("Welcome to Aether")
	
	-- Content text
	frame.contentText = frame.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.contentText:SetPoint("TOPLEFT", frame.content, "TOPLEFT", 10, -40)
	frame.contentText:SetPoint("TOPRIGHT", frame.content, "TOPRIGHT", -10, -40)
	frame.contentText:SetJustifyH("LEFT")
	frame.contentText:SetJustifyV("TOP")
	frame.contentText:SetText(
		"Aether is an all-in-one addon combining Leatrix Plus and Titan Panel features.\n\n" ..
		"Select a category from the left to configure settings.\n\n" ..
		"Type /aether or /ae for quick access to this menu."
	)
	
	self.mainFrame = frame
	return frame
end

--[[
	Show the main frame
]]--
function UI:Show()
	if not self.mainFrame then
		self:CreateMainFrame()
	end
	
	self.mainFrame:Show()
end

--[[
	Hide the main frame
]]--
function UI:Hide()
	if self.mainFrame then
		self.mainFrame:Hide()
	end
end

--[[
	Toggle the main frame
]]--
function UI:Toggle()
	if self.mainFrame and self.mainFrame:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

--[[
	Select a category
]]--
function UI:SelectCategory(categoryName)
	if not self.mainFrame then return end
	
	-- Update category buttons
	for name, btn in pairs(self.mainFrame.categories) do
		if name == categoryName then
			btn:Disable()
		else
			btn:Enable()
		end
	end
	
	-- Update content
	self.mainFrame.contentTitle:SetText(categoryName)
	self.mainFrame.contentText:SetText("Settings for " .. categoryName .. " will appear here.")
	
	-- TODO: Load actual category content
end

-- Initialize on load
C_Timer.After(0, function()
	if Aether and Aether.Commands then
		-- Override config command to open our UI
		local oldOpenConfig = Aether.Commands.OpenConfig
		Aether.Commands.OpenConfig = function(self)
			UI:Show()
		end
	end
end)
