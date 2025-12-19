--- **LibSharedMedia-3.0** provides a registry for media files (fonts, textures, sounds, statusbars).
-- @class file
-- @name LibSharedMedia-3.0
-- @release $Id$
local MAJOR, MINOR = "LibSharedMedia-3.0", 7000001
local LibSharedMedia = LibStub:NewLibrary(MAJOR, MINOR)

if not LibSharedMedia then return end

local _G = _G
local pairs, type = pairs, type

LibSharedMedia.MediaType = {
	BACKGROUND  = "background",
	BORDER      = "border",
	FONT        = "font",
	STATUSBAR   = "statusbar",
	SOUND       = "sound",
}

LibSharedMedia.registry = LibSharedMedia.registry or {}
LibSharedMedia.callbacks = LibSharedMedia.callbacks or LibStub("CallbackHandler-1.0"):New(LibSharedMedia)

local registry = LibSharedMedia.registry
for _, mediaType in pairs(LibSharedMedia.MediaType) do
	if not registry[mediaType] then
		registry[mediaType] = {}
	end
end

-- Default media
local function RegisterDefaults()
	-- Fonts
	LibSharedMedia:Register("font", "Arial Narrow", [[Fonts\ARIALN.TTF]])
	LibSharedMedia:Register("font", "Friz Quadrata TT", [[Fonts\FRIZQT__.TTF]])
	LibSharedMedia:Register("font", "Morpheus", [[Fonts\MORPHEUS.TTF]])
	LibSharedMedia:Register("font", "Skurri", [[Fonts\skurri.TTF]])
	
	-- Statusbars
	LibSharedMedia:Register("statusbar", "Blizzard", [[Interface\TargetingFrame\UI-StatusBar]])
	LibSharedMedia:Register("statusbar", "Blizzard Character Skills Bar", [[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]])
	
	-- Backgrounds
	LibSharedMedia:Register("background", "Blizzard Dialog Background", [[Interface\DialogFrame\UI-DialogBox-Background]])
	LibSharedMedia:Register("background", "Blizzard Tooltip", [[Interface\Tooltips\UI-Tooltip-Background]])
	
	-- Borders
	LibSharedMedia:Register("border", "Blizzard Dialog", [[Interface\DialogFrame\UI-DialogBox-Border]])
	LibSharedMedia:Register("border", "Blizzard Tooltip", [[Interface\Tooltips\UI-Tooltip-Border]])
	
	-- Sounds
	LibSharedMedia:Register("sound", "None", [[Interface\Quiet.ogg]])
end

--- Register a media file.
-- @param mediaType The type of media (font, statusbar, sound, etc.)
-- @param key The name/key for this media
-- @param path The file path or value
function LibSharedMedia:Register(mediaType, key, path)
	if type(mediaType) ~= "string" then
		error("Usage: Register(mediaType, key, path): mediaType must be a string", 2)
	end
	if type(key) ~= "string" then
		error("Usage: Register(mediaType, key, path): key must be a string", 2)
	end
	
	if not registry[mediaType] then
		registry[mediaType] = {}
	end
	
	registry[mediaType][key] = path
	
	-- Fire callback
	self.callbacks:Fire("LibSharedMedia_Registered", mediaType, key)
end

--- Fetch a media file path.
-- @param mediaType The type of media
-- @param key The name/key for this media
-- @return The file path
function LibSharedMedia:Fetch(mediaType, key)
	if not registry[mediaType] then
		error(("Usage: Fetch(mediaType, key): mediaType %q not found"):format(tostring(mediaType)), 2)
	end
	
	return registry[mediaType][key]
end

--- Check if a media file exists.
-- @param mediaType The type of media
-- @param key The name/key for this media
-- @return True if the media exists
function LibSharedMedia:IsValid(mediaType, key)
	return registry[mediaType] and registry[mediaType][key] ~= nil
end

--- Get a list of all registered media of a type.
-- @param mediaType The type of media
-- @return Table of media names
function LibSharedMedia:HashTable(mediaType)
	if not registry[mediaType] then
		return {}
	end
	
	local result = {}
	for key in pairs(registry[mediaType]) do
		result[key] = key
	end
	return result
end

--- Get an indexed list of all registered media of a type.
-- @param mediaType The type of media
-- @return Array of media names
function LibSharedMedia:List(mediaType)
	if not registry[mediaType] then
		return {}
	end
	
	local result = {}
	for key in pairs(registry[mediaType]) do
		result[#result + 1] = key
	end
	table.sort(result)
	return result
end

--- Get the default media for a type.
-- @param mediaType The type of media
-- @return The default media key
function LibSharedMedia:GetDefault(mediaType)
	-- Return the first registered media
	if registry[mediaType] then
		for key in pairs(registry[mediaType]) do
			return key
		end
	end
	return nil
end

--- Set the global default for a media type.
-- @param mediaType The type of media
-- @param key The default key
function LibSharedMedia:SetDefault(mediaType, key)
	-- This would typically save to a saved variable
	-- For now, we'll just verify it exists
	if not self:IsValid(mediaType, key) then
		error(("SetDefault: Invalid media %q for type %q"):format(tostring(key), tostring(mediaType)), 2)
	end
end

-- Register defaults
RegisterDefaults()
