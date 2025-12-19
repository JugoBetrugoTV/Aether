--[[
	Aether - Social Module
	Main social module coordinator
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Module = {}
Module.name = "Social"
Module.initialized = false

function Module:Initialize()
	if self.initialized then return end
	Aether:Debug("Initializing Social module...")
	Aether:RegisterModule(self.name, self)
	self.initialized = true
end

function Module:Reload()
	Aether:Debug("Reloading Social module...")
end

Module:Initialize()
