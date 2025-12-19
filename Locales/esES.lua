--[[
	Aether - Spanish Localization (Español)
	
	This file contains all Spanish text strings for the addon
]]--

local ADDON_NAME = "Aether"
local L = {}

-- Copy English as base, then override with Spanish translations
if _G[ADDON_NAME] and _G[ADDON_NAME].L then
	for k, v in pairs(_G[ADDON_NAME].L) do
		L[k] = v
	end
end

-- Spanish translations
L["ADDON_NAME"] = "Aether"
L["ADDON_DESCRIPTION"] = "Addon todo en uno que combina características de Leatrix Plus y Titan Panel"

L["ENABLED"] = "Activado"
L["DISABLED"] = "Desactivado"
L["ENABLE"] = "Activar"
L["DISABLE"] = "Desactivar"
L["SETTINGS"] = "Configuración"
L["OPTIONS"] = "Opciones"
L["RESET"] = "Restablecer"
L["RESET_ALL"] = "Restablecer todo"

-- TODO: Add complete Spanish translations for all strings
-- For now, using English as fallback

-- Store in addon namespace
if AetherLocale then
	AetherLocale.esES = L
end
