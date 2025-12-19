--- **AceGUI-3.0** provides a widget framework for creating GUIs.
-- @class file
-- @name AceGUI-3.0
-- @release $Id$
local MAJOR, MINOR = "AceGUI-3.0", 41
local AceGUI = LibStub:NewLibrary(MAJOR, MINOR)

if not AceGUI then return end

AceGUI.WidgetRegistry = AceGUI.WidgetRegistry or {}
AceGUI.WidgetBase = AceGUI.WidgetBase or {}
AceGUI.WidgetVersions = AceGUI.WidgetVersions or {}

-- Widget Base
local WidgetBase = AceGUI.WidgetBase
local WidgetRegistry = AceGUI.WidgetRegistry

--- Create a new widget.
-- @param type The widget type
-- @return The widget object
function AceGUI:Create(type)
	if not WidgetRegistry[type] then
		error(("Usage: AceGUI:Create(type): Unknown widget type %q"):format(tostring(type)), 2)
	end
	
	local widget = WidgetRegistry[type]()
	return widget
end

--- Register a widget type.
-- @param name The widget name
-- @param constructor The constructor function
-- @param version The version number
function AceGUI:RegisterWidgetType(name, constructor, version)
	if not name or not constructor then
		error("Usage: RegisterWidgetType(name, constructor, version): name and constructor required", 2)
	end
	
	local oldVersion = AceGUI.WidgetVersions[name]
	if oldVersion and oldVersion >= version then
		return -- Older version
	end
	
	AceGUI.WidgetVersions[name] = version
	WidgetRegistry[name] = constructor
end

--- Register a layout type.
-- @param name The layout name
-- @param constructor The constructor function
function AceGUI:RegisterLayout(name, func)
	if type(func) ~= "function" then
		error(("Usage: RegisterLayout(name, func): func must be a function, got %s"):format(type(func)), 2)
	end
	AceGUI.LayoutRegistry = AceGUI.LayoutRegistry or {}
	AceGUI.LayoutRegistry[name] = func
end

--- Get the layout function.
-- @param name The layout name
-- @return The layout function
function AceGUI:GetLayout(name)
	return AceGUI.LayoutRegistry and AceGUI.LayoutRegistry[name]
end

-- Widget Base Methods
function WidgetBase:SetWidth(width)
	self.frame:SetWidth(width)
	self.width = width
end

function WidgetBase:SetHeight(height)
	self.frame:SetHeight(height)
	self.height = height
end

function WidgetBase:SetPoint(...)
	return self.frame:SetPoint(...)
end

function WidgetBase:SetParent(parent)
	local frame = parent
	if parent.content then
		frame = parent.content
	elseif parent.frame then
		frame = parent.frame
	end
	self.frame:SetParent(frame)
	self.parent = parent
end

function WidgetBase:Show()
	self.frame:Show()
end

function WidgetBase:Hide()
	self.frame:Hide()
end

function WidgetBase:SetCallback(name, func)
	self.callbacks = self.callbacks or {}
	self.callbacks[name] = func
end

function WidgetBase:Fire(name, ...)
	if self.callbacks and self.callbacks[name] then
		self.callbacks[name](self, name, ...)
	end
end

function WidgetBase:SetDisabled(disabled)
	self.disabled = disabled
	if self.frame.Disable then
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end
end

function WidgetBase:IsVisible()
	return self.frame:IsVisible()
end

function WidgetBase:Release()
	-- Clean up
end

function WidgetBase:SetLabel(text)
	if self.label then
		self.label:SetText(text or "")
	end
end

function WidgetBase:SetText(text)
	if self.text then
		self.text:SetText(text or "")
	end
end

-- Simple Frame widget
local function CreateFrame_Widget()
	local widget = {}
	for k, v in pairs(WidgetBase) do
		widget[k] = v
	end
	
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(100, 100)
	widget.frame = frame
	widget.type = "Frame"
	
	return widget
end

-- Simple Label widget
local function CreateLabel_Widget()
	local widget = {}
	for k, v in pairs(WidgetBase) do
		widget[k] = v
	end
	
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(200, 20)
	
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("TOPLEFT")
	text:SetPoint("BOTTOMRIGHT")
	text:SetJustifyH("LEFT")
	text:SetJustifyV("TOP")
	
	widget.frame = frame
	widget.text = text
	widget.type = "Label"
	
	function widget:SetText(txt)
		text:SetText(txt or "")
	end
	
	return widget
end

-- Simple Button widget
local function CreateButton_Widget()
	local widget = {}
	for k, v in pairs(WidgetBase) do
		widget[k] = v
	end
	
	local frame = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
	frame:SetSize(100, 22)
	
	frame:SetScript("OnClick", function()
		widget:Fire("OnClick")
	end)
	
	widget.frame = frame
	widget.type = "Button"
	
	function widget:SetText(txt)
		frame:SetText(txt or "")
	end
	
	return widget
end

-- Simple EditBox widget
local function CreateEditBox_Widget()
	local widget = {}
	for k, v in pairs(WidgetBase) do
		widget[k] = v
	end
	
	local frame = CreateFrame("EditBox", nil, UIParent, "InputBoxTemplate")
	frame:SetSize(200, 20)
	frame:SetAutoFocus(false)
	
	frame:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		widget:Fire("OnEnterPressed", self:GetText())
	end)
	
	frame:SetScript("OnTextChanged", function(self)
		widget:Fire("OnTextChanged", self:GetText())
	end)
	
	widget.frame = frame
	widget.type = "EditBox"
	
	function widget:SetText(txt)
		frame:SetText(txt or "")
	end
	
	function widget:GetText()
		return frame:GetText()
	end
	
	return widget
end

-- Simple CheckBox widget
local function CreateCheckBox_Widget()
	local widget = {}
	for k, v in pairs(WidgetBase) do
		widget[k] = v
	end
	
	local frame = CreateFrame("CheckButton", nil, UIParent, "ChatConfigCheckButtonTemplate")
	frame:SetSize(24, 24)
	
	frame:SetScript("OnClick", function(self)
		widget:Fire("OnValueChanged", self:GetChecked())
	end)
	
	widget.frame = frame
	widget.type = "CheckBox"
	
	function widget:SetValue(value)
		frame:SetChecked(value)
	end
	
	function widget:GetValue()
		return frame:GetChecked()
	end
	
	return widget
end

-- Register basic widgets
AceGUI:RegisterWidgetType("Frame", CreateFrame_Widget, 1)
AceGUI:RegisterWidgetType("Label", CreateLabel_Widget, 1)
AceGUI:RegisterWidgetType("Button", CreateButton_Widget, 1)
AceGUI:RegisterWidgetType("EditBox", CreateEditBox_Widget, 1)
AceGUI:RegisterWidgetType("CheckBox", CreateCheckBox_Widget, 1)
