--[[
Aether - System Module
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Module = {}
Module.name = "System"
Module.initialized = false

function Module:Initialize()
if self.initialized then return end
Aether:Debug("Initializing System module...")
Aether:RegisterModule(self.name, self)
self.initialized = true
end

function Module:Reload()
Aether:Debug("Reloading System module...")
end

Module:Initialize()
