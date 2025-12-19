--- **AceConfig-3.0** main library file that loads all AceConfig modules.
-- @class file
-- @name AceConfig-3.0
-- @release $Id$
local MAJOR, MINOR = "AceConfig-3.0", 3
local AceConfig = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConfig then return end

-- This is just a stub that ensures other modules are loaded
-- The real work is done by AceConfigRegistry, AceConfigDialog, and AceConfigCmd

--- Register an options table.
-- @param appName The application name
-- @param options The options table
-- @param slashcmd Slash command (optional)
function AceConfig:RegisterOptionsTable(appName, options, slashcmd)
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	AceConfigRegistry:RegisterOptionsTable(appName, options)
	
	if slashcmd then
		local AceConfigCmd = LibStub("AceConfigCmd-3.0")
		if type(slashcmd) == "table" then
			AceConfigCmd:CreateChatCommand(appName, unpack(slashcmd))
		else
			AceConfigCmd:CreateChatCommand(appName, slashcmd)
		end
	end
	
	return appName
end
