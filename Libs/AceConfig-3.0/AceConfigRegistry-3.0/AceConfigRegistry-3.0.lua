--- **AceConfigRegistry-3.0** manages AceConfig configuration tables.
-- @class file
-- @name AceConfigRegistry-3.0
-- @release $Id$
local MAJOR, MINOR = "AceConfigRegistry-3.0", 18
local AceConfigRegistry = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConfigRegistry then return end

AceConfigRegistry.tables = AceConfigRegistry.tables or {}

-- CallbackHandler
if not AceConfigRegistry.callbacks then
	AceConfigRegistry.callbacks = LibStub("CallbackHandler-1.0"):New(AceConfigRegistry)
end

local CallbackHandler = AceConfigRegistry.callbacks

--- Register a configuration table.
-- @param appName The application name
-- @param options The options table
function AceConfigRegistry:RegisterOptionsTable(appName, options)
	if type(appName) ~= "string" then
		error("Usage: RegisterOptionsTable(appName, options): appName must be a string", 2)
	end
	if type(options) ~= "table" and type(options) ~= "function" then
		error("Usage: RegisterOptionsTable(appName, options): options must be a table or function", 2)
	end
	
	self.tables[appName] = options
	CallbackHandler:Fire("ConfigTableChange", appName)
	return appName
end

--- Get a configuration table.
-- @param appName The application name
-- @return The options table
function AceConfigRegistry:GetOptionsTable(appName)
	local tbl = self.tables[appName]
	if type(tbl) == "function" then
		tbl = tbl()
	end
	return tbl
end

--- Notify that a configuration table has changed.
-- @param appName The application name
function AceConfigRegistry:NotifyChange(appName)
	CallbackHandler:Fire("ConfigTableChange", appName)
end

--- Validate options table (basic validation).
-- @param options The options table
-- @param name The name for error messages
-- @return true if valid, or error
function AceConfigRegistry:ValidateOptionsTable(options, name)
	if type(options) ~= "table" then
		error(format("%s: expected table, got %s", name or "Options", type(options)), 3)
	end
	return true
end
