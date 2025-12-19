--[[
	Aether - Automation Module
	
	Main automation module that coordinates all automation features
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create module
local Module = {}
Module.name = "Automation"
Module.initialized = false

--[[
	Initialize the module
]]--
function Module:Initialize()
	if self.initialized then return end
	
	Aether:Debug("Initializing Automation module...")
	
	-- Register module with core
	Aether:RegisterModule(self.name, self)
	
	-- Mark as initialized
	self.initialized = true
	
	Aether:Debug("Automation module initialized")
end

--[[
	Reload the module with new settings
]]--
function Module:Reload()
	Aether:Debug("Reloading Automation module...")
	-- Submodules will handle their own reload
end

--[[
	Handle configuration changes
]]--
function Module:OnConfigChanged(category, setting, value)
	if category ~= "automation" then return end
	
	Aether:Debug("Automation config changed:", setting, "=", tostring(value))
	
	-- Notify submodules if needed
end

-- Initialize the module
Module:Initialize()
