--[[
	Aether - German Localization (Deutsch)
	
	This file contains all German text strings for the addon
]]--

local ADDON_NAME = "Aether"
local L = {}

-- Copy English as base, then override with German translations
if _G[ADDON_NAME] and _G[ADDON_NAME].L then
	for k, v in pairs(_G[ADDON_NAME].L) do
		L[k] = v
	end
end

-- German translations
L["ADDON_NAME"] = "Aether"
L["ADDON_DESCRIPTION"] = "Alles-in-Einem-Addon mit Leatrix Plus und Titan Panel Funktionen"

L["ENABLED"] = "Aktiviert"
L["DISABLED"] = "Deaktiviert"
L["ENABLE"] = "Aktivieren"
L["DISABLE"] = "Deaktivieren"
L["SETTINGS"] = "Einstellungen"
L["OPTIONS"] = "Optionen"
L["RESET"] = "Zurücksetzen"
L["RESET_ALL"] = "Alles zurücksetzen"

-- TODO: Add complete German translations for all strings
-- For now, using English as fallback

-- Store in addon namespace
if AetherLocale then
	AetherLocale.deDE = L
end
