--[[
	Aether - Italian Localization (Italiano)
	
	This file contains all Italian text strings for the addon
]]--

local ADDON_NAME = "Aether"
local L = {}

-- Copy English as base, then override with Italian translations
if _G[ADDON_NAME] and _G[ADDON_NAME].L then
	for k, v in pairs(_G[ADDON_NAME].L) do
		L[k] = v
	end
end

-- Italian translations
L["ADDON_NAME"] = "Aether"
L["ADDON_DESCRIPTION"] = "Addon tutto-in-uno che combina le funzionalità di Leatrix Plus e Titan Panel"

L["ENABLED"] = "Attivato"
L["DISABLED"] = "Disattivato"
L["ENABLE"] = "Attiva"
L["DISABLE"] = "Disattiva"
L["SETTINGS"] = "Impostazioni"
L["OPTIONS"] = "Opzioni"
L["RESET"] = "Ripristina"
L["RESET_ALL"] = "Ripristina tutto"

-- TODO: Add complete Italian translations for all strings
-- For now, using English as fallback

-- Store in addon namespace
if AetherLocale then
	AetherLocale.itIT = L
end
