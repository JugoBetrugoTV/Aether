--- **LibDBIcon-1.0** provides minimap button functionality for LibDataBroker objects.
-- @class file
-- @name LibDBIcon-1.0
local MAJOR, MINOR = "LibDBIcon-1.0", 45
local LibDBIcon = LibStub:NewLibrary(MAJOR, MINOR)

if not LibDBIcon then return end

local LibDataBroker = LibStub("LibDataBroker-1.1", true)
if not LibDataBroker then
	error("LibDBIcon-1.0 requires LibDataBroker-1.1", 2)
end

LibDBIcon.objects = LibDBIcon.objects or {}
LibDBIcon.callbacks = LibDBIcon.callbacks or LibStub("CallbackHandler-1.0"):New(LibDBIcon)
LibDBIcon.notCreated = LibDBIcon.notCreated or {}

local isDraggingButton = false

local function CreateMinimapButton(name, object, db)
	local button = CreateFrame("Button", "LibDBIcon_"..name, Minimap)
	button:SetSize(32, 32)
	button:SetFrameStrata("MEDIUM")
	button:SetFrameLevel(8)
	button:RegisterForClicks("anyUp")
	button:RegisterForDrag("LeftButton")
	button:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
	
	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetSize(20, 20)
	icon:SetPoint("CENTER")
	icon:SetTexture(object.icon or [[Interface\Icons\INV_Misc_QuestionMark]])
	button.icon = icon
	
	local overlay = button:CreateTexture(nil, "OVERLAY")
	overlay:SetSize(53, 53)
	overlay:SetPoint("CENTER")
	overlay:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
	button.overlay = overlay
	
	button:SetScript("OnEnter", function(self)
		if object.OnTooltipShow then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			object.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		elseif object.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(object.tooltip)
			GameTooltip:Show()
		end
	end)
	
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	button:SetScript("OnClick", function(self, btn)
		if object.OnClick then
			object.OnClick(self, btn)
		end
	end)
	
	button:SetScript("OnDragStart", function(self)
		isDraggingButton = true
		self:LockHighlight()
		self:SetScript("OnUpdate", function(self)
			local mx, my = Minimap:GetCenter()
			local px, py = GetCursorPosition()
			local scale = Minimap:GetEffectiveScale()
			px, py = px / scale, py / scale
			
			local angle = math.atan2(py - my, px - mx)
			local x = math.cos(angle) * 80
			local y = math.sin(angle) * 80
			
			self:ClearAllPoints()
			self:SetPoint("CENTER", Minimap, "CENTER", x, y)
			
			if db then
				db.minimapPos = math.deg(angle)
			end
		end)
	end)
	
	button:SetScript("OnDragStop", function(self)
		isDraggingButton = false
		self:UnlockHighlight()
		self:SetScript("OnUpdate", nil)
	end)
	
	-- Position the button
	local angle = db and db.minimapPos or 225
	local x = math.cos(math.rad(angle)) * 80
	local y = math.sin(math.rad(angle)) * 80
	button:ClearAllPoints()
	button:SetPoint("CENTER", Minimap, "CENTER", x, y)
	
	if db and db.hide then
		button:Hide()
	end
	
	return button
end

--- Register a LibDataBroker object to have a minimap icon.
-- @param name The name of the data object
-- @param object The data object or data object name
-- @param db The database for storing position (must have fields: hide, minimapPos)
function LibDBIcon:Register(name, object, db)
	if not object.icon then
		object.icon = [[Interface\Icons\INV_Misc_QuestionMark]]
	end
	
	if LibDBIcon.objects[name] then return end
	
	if type(object) == "string" then
		object = LibDataBroker:GetDataObjectByName(object)
	end
	
	local button = CreateMinimapButton(name, object, db)
	LibDBIcon.objects[name] = {
		object = object,
		button = button,
		db = db,
	}
	
	LibDBIcon.callbacks:Fire("LibDBIcon_IconCreated", button, object, name)
end

--- Unregister a minimap icon.
-- @param name The name of the data object
function LibDBIcon:Unregister(name)
	if not LibDBIcon.objects[name] then return end
	
	LibDBIcon.objects[name].button:Hide()
	LibDBIcon.objects[name] = nil
end

--- Hide a minimap icon.
-- @param name The name of the data object
function LibDBIcon:Hide(name)
	if not LibDBIcon.objects[name] then return end
	LibDBIcon.objects[name].button:Hide()
end

--- Show a minimap icon.
-- @param name The name of the data object
function LibDBIcon:Show(name)
	if not LibDBIcon.objects[name] then return end
	LibDBIcon.objects[name].button:Show()
end

--- Check if an icon is registered.
-- @param name The name of the data object
-- @return True if registered
function LibDBIcon:IsRegistered(name)
	return LibDBIcon.objects[name] ~= nil
end

--- Refresh the icon.
-- @param name The name of the data object
function LibDBIcon:Refresh(name)
	if not LibDBIcon.objects[name] then return end
	
	local obj = LibDBIcon.objects[name]
	local object = obj.object
	
	if object.icon then
		obj.button.icon:SetTexture(object.icon)
	end
end

--- Get the button for a data object.
-- @param name The name of the data object
-- @return The button frame
function LibDBIcon:GetMinimapButton(name)
	if not LibDBIcon.objects[name] then return nil end
	return LibDBIcon.objects[name].button
end
