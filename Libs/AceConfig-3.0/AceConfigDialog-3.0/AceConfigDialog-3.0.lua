--- **AceConfigDialog-3.0** provides a GUI for configuring addons.
-- @class file
-- @name AceConfigDialog-3.0
-- @release $Id$
local MAJOR, MINOR = "AceConfigDialog-3.0", 80
local AceConfigDialog = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConfigDialog then return end

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

AceConfigDialog.OpenFrames = AceConfigDialog.OpenFrames or {}
AceConfigDialog.Status = AceConfigDialog.Status or {}

-- Basic frame creation
local function CreateDialog(appName)
	local frame = CreateFrame("Frame", "AceConfigDialog_"..appName, UIParent, "BackdropTemplate")
	frame:SetSize(600, 400)
	frame:SetPoint("CENTER")
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 }
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:Hide()
	
	-- Title
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -10)
	title:SetText(appName)
	frame.title = title
	
	-- Close button
	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -5, -5)
	frame.close = close
	
	return frame
end

--- Open a configuration dialog.
-- @param appName The application name
-- @param container The container to use (optional)
function AceConfigDialog:Open(appName, container)
	if not appName then
		error("Usage: Open(appName): appName must be provided", 2)
	end
	
	local frame = self.OpenFrames[appName]
	if not frame then
		frame = CreateDialog(appName)
		self.OpenFrames[appName] = frame
	end
	
	frame:Show()
end

--- Close a configuration dialog.
-- @param appName The application name
function AceConfigDialog:Close(appName)
	local frame = self.OpenFrames[appName]
	if frame then
		frame:Hide()
	end
end

--- Close all configuration dialogs.
function AceConfigDialog:CloseAll()
	for appName, frame in pairs(self.OpenFrames) do
		frame:Hide()
	end
end

--- Add to Blizzard options.
-- @param appName The application name
-- @param name The name for the options panel
-- @param parent Parent category (optional)
function AceConfigDialog:AddToBlizOptions(appName, name, parent)
	local options = AceConfigRegistry:GetOptionsTable(appName)
	if not options then
		error(format("Cannot add %q to Blizzard options, no options table found", appName), 2)
	end
	
	-- Create a simple panel
	local panel = CreateFrame("Frame", "AceConfigBlizPanel_"..appName)
	panel.name = name or appName
	panel.parent = parent
	
	-- Add to interface options (simplified)
	if Settings and Settings.RegisterCanvasLayoutCategory then
		-- Dragonflight/modern API
		local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(category)
	elseif InterfaceOptions_AddCategory then
		-- Legacy API
		InterfaceOptions_AddCategory(panel)
	end
	
	return panel
end

--- Set the default size for dialogs.
-- @param appName The application name
-- @param width Width
-- @param height Height
function AceConfigDialog:SetDefaultSize(appName, width, height)
	self.Status[appName] = self.Status[appName] or {}
	self.Status[appName].width = width
	self.Status[appName].height = height
end
