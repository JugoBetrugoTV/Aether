--[[
	Aether - French Localization (Français)
	
	This file contains all French text strings for the addon
]]--

local ADDON_NAME = "Aether"
local L = {}

-- Copy English as base, then override with French translations
if _G[ADDON_NAME] and _G[ADDON_NAME].L then
	for k, v in pairs(_G[ADDON_NAME].L) do
		L[k] = v
	end
end

-- French translations
L["ADDON_NAME"] = "Aether"
L["ADDON_DESCRIPTION"] = "Addon tout-en-un combinant les fonctionnalités de Leatrix Plus et Titan Panel"

L["ENABLED"] = "Activé"
L["DISABLED"] = "Désactivé"
L["ENABLE"] = "Activer"
L["DISABLE"] = "Désactiver"
L["SETTINGS"] = "Paramètres"
L["OPTIONS"] = "Options"
L["RESET"] = "Réinitialiser"
L["RESET_ALL"] = "Tout réinitialiser"

-- TODO: Add complete French translations for all strings
-- For now, using English as fallback

-- Store in addon namespace
if AetherLocale then
	AetherLocale.frFR = L
end
