--- **AceLocale-3.0** manages localization in addons, allowing for multiple locale to be registered with fallback to the base locale for untranslated strings.
-- @class file
-- @name AceLocale-3.0
-- @release $Id: AceLocale-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceLocale-3.0", 6

local AceLocale = LibStub:NewLibrary(MAJOR, MINOR)

if not AceLocale then return end

AceLocale.apps = AceLocale.apps or {}
AceLocale.appnames = AceLocale.appnames or {}

-- Lua APIs
local assert, tostring, error = assert, tostring, error
local getmetatable, setmetatable, rawset, rawget = getmetatable, setmetatable, rawset, rawget

local function new(self)
	local t = {}
	local mt = {
		__index = function(t, k)
			rawset(t, k, k) -- Set the key itself as the value
			return k
		end
	}
	return setmetatable(t, mt)
end

--- Register a new locale (or extend an existing one) for the specified application.
-- @paramsig application, locale, [silent]
-- @param application Name of the addon/module/etc
-- @param locale Name of the locale to register (e.g., "enUS", "deDE")
-- @param silent If true, the locale will be registered silently (no error if it exists)
-- @return The locale table, or nil if a different locale was registered as the current locale
function AceLocale:NewLocale(application, locale, isDefault)
	local app = AceLocale.apps[application]
	
	if not app then
		app = {}
		AceLocale.apps[application] = app
		AceLocale.appnames[application] = {}
	end
	
	local obj = AceLocale.appnames[application][locale]
	if not obj then
		obj = new(self)
		AceLocale.appnames[application][locale] = obj
	end
	
	-- Set as default if this is the game locale or explicitly default
	local gameLocale = GetLocale()
	if locale == gameLocale or isDefault then
		AceLocale.apps[application] = obj
	end
	
	return obj
end

--- Return a locale table for the given application.
-- @param application Name of the addon/module/etc
-- @param silent If true, the locale will be returned silently (no error if it doesn't exist)
-- @return The locale table
function AceLocale:GetLocale(application, silent)
	if not silent and not AceLocale.apps[application] then
		error(("Usage: GetLocale(application, [silent]): 'application' - No locales registered for %q"):format(tostring(application)), 2)
	end
	return AceLocale.apps[application]
end
