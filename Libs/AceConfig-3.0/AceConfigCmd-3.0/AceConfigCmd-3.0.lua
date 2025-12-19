--- **AceConfigCmd-3.0** handles slash commands for config dialogs.
-- @class file
-- @name AceConfigCmd-3.0
-- @release $Id$
local MAJOR, MINOR = "AceConfigCmd-3.0", 14
local AceConfigCmd = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConfigCmd then return end

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConsole = LibStub("AceConsole-3.0", true)

-- Create slash command handler
function AceConfigCmd:CreateChatCommand(appName, ...)
	if type(appName) ~= "string" then
		error("Usage: CreateChatCommand(appName, ...): appName must be a string", 2)
	end
	
	local handler = function(input)
		-- Simple handler that just opens the config dialog
		local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
		if AceConfigDialog then
			AceConfigDialog:Open(appName)
		else
			print("Config dialog for " .. appName)
		end
	end
	
	-- Register the slash commands
	for i = 1, select("#", ...) do
		local cmd = select(i, ...)
		if cmd and cmd ~= "" then
			local name = "ACECFGCMD_"..appName.."_"..i
			_G["SLASH_"..name.."1"] = "/"..cmd
			SlashCmdList[name] = handler
		end
	end
end

--- Handle a slash command for a config table.
-- @param appName The application name
-- @param input The input string
function AceConfigCmd:HandleCommand(appName, input)
	local options = AceConfigRegistry:GetOptionsTable(appName)
	if not options then
		error(format("Cannot handle command for %q, no options table found", appName), 2)
	end
	
	-- Open dialog
	local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
	if AceConfigDialog then
		AceConfigDialog:Open(appName)
	end
end
