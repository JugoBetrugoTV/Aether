--[[
Aether - Media Module
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Module = {}
Module.name = "Media"
Module.initialized = false

function Module:Initialize()
if self.initialized then return end
Aether:Debug("Initializing Media module...")
Aether:RegisterModule(self.name, self)
self.initialized = true
end

function Module:Reload()
Aether:Debug("Reloading Media module...")
end

Module:Initialize()
