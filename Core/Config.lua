--[[
	Aether - Configuration
	
	This file handles the main configuration options
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create config table
Aether.Config = {}
local Cfg = Aether.Config

--[[
	Get a setting value
]]--
function Cfg:Get(category, setting)
	if not category or not setting then
		return nil
	end
	
	if not Aether.db or not Aether.db.profile then
		return nil
	end
	
	if not Aether.db.profile[category] then
		return nil
	end
	
	return Aether.db.profile[category][setting]
end

--[[
	Set a setting value
]]--
function Cfg:Set(category, setting, value)
	if not category or not setting then
		return false
	end
	
	if not Aether.db or not Aether.db.profile then
		return false
	end
	
	if not Aether.db.profile[category] then
		Aether.db.profile[category] = {}
	end
	
	Aether.db.profile[category][setting] = value
	
	-- Notify modules of the change
	self:NotifyChange(category, setting, value)
	
	return true
end

--[[
	Toggle a boolean setting
]]--
function Cfg:Toggle(category, setting)
	local current = self:Get(category, setting)
	if type(current) == "boolean" then
		self:Set(category, setting, not current)
		return not current
	end
	return nil
end

--[[
	Get all settings for a category
]]--
function Cfg:GetCategory(category)
	if not category then
		return nil
	end
	
	if not Aether.db or not Aether.db.profile then
		return nil
	end
	
	return Aether.db.profile[category]
end

--[[
	Set all settings for a category
]]--
function Cfg:SetCategory(category, settings)
	if not category or not settings then
		return false
	end
	
	if not Aether.db or not Aether.db.profile then
		return false
	end
	
	Aether.db.profile[category] = Aether.U.DeepCopy(settings)
	
	-- Notify modules of the change
	self:NotifyChange(category, nil, settings)
	
	return true
end

--[[
	Reset a category to defaults
]]--
function Cfg:ResetCategory(category)
	if not category then
		return false
	end
	
	if not Aether.db or not Aether.db.profile then
		return false
	end
	
	Aether.db.profile[category] = {}
	Aether:ApplyDefaults()
	
	-- Notify modules of the change
	self:NotifyChange(category, nil, nil)
	
	Aether:Print("Reset category:", category)
	return true
end

--[[
	Reset all settings to defaults
]]--
function Cfg:ResetAll()
	if not Aether.db or not Aether.db.profile then
		return false
	end
	
	Aether.db.profile = {}
	Aether:ApplyDefaults()
	
	-- Reload all modules
	Aether.Profiles:ReloadModules()
	
	Aether:Print("Reset all settings to defaults")
	return true
end

--[[
	Notify modules of a configuration change
]]--
function Cfg:NotifyChange(category, setting, value)
	-- Fire event for modules to handle
	for moduleName, module in pairs(Aether.modules) do
		if module.OnConfigChanged then
			local success, err = pcall(module.OnConfigChanged, module, category, setting, value)
			if not success then
				Aether:Error("Failed to notify module '" .. moduleName .. "':", err)
			end
		end
	end
end

--[[
	Import settings from another addon (if possible)
]]--
function Cfg:ImportFromAddon(addonName)
	Aether:Print("Import from other addons not yet implemented")
	-- This would require knowledge of other addon's saved variable structure
	-- Could support importing from Leatrix Plus or Titan Panel in the future
end

--[[
	Export current settings
]]--
function Cfg:ExportSettings()
	return Aether.Profiles:ExportProfile(Aether.Profiles.currentProfile)
end

--[[
	Import settings
]]--
function Cfg:ImportSettings(encodedString)
	return Aether.Profiles:ImportProfile(encodedString, "Imported")
end
