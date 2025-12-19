--[[
Aether - Currency Plugin
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Plugin = {
name = "Currency",
enabled = false,  -- Disabled by default, enable in settings
bar = "top1",
position = "left",
updateInterval = 1.0,
}

function Plugin:Initialize()
self.frame = CreateFrame("Button", "AetherPlugin" .. self.name, UIParent)
self.frame:SetSize(100, 24)

self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
self.text:SetPoint("CENTER")
self.text:SetText(self.name)
end

function Plugin:Update()
-- Implementation pending
end

if Aether.PluginSystem then
Aether.PluginSystem:RegisterPlugin(Plugin)
end
