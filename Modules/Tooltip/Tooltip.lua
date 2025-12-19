--[[
Aether - Tooltip Module
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Module = {}
Module.name = "Tooltip"
Module.initialized = false

function Module:Initialize()
if self.initialized then return end
Aether:Debug("Initializing Tooltip module...")
Aether:RegisterModule(self.name, self)
self.initialized = true
end

function Module:Reload()
Aether:Debug("Reloading Tooltip module...")
end

Module:Initialize()
