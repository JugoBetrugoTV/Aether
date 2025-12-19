--[[
	Aether - Slash Commands
	
	This file handles all slash commands for the addon
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create commands table
Aether.Commands = {}
local Cmd = Aether.Commands

--[[
	Initialize slash commands
]]--
function Cmd:Initialize()
	Aether:Debug("Registering slash commands...")
	
	SLASH_AETHER1 = "/aether"
	SLASH_AETHER2 = "/ae"
	
	SlashCmdList["AETHER"] = function(msg)
		self:HandleCommand(msg)
	end
end

--[[
	Handle slash command
]]--
function Cmd:HandleCommand(msg)
	-- Parse command and arguments
	local args = {}
	for word in msg:gmatch("%S+") do
		table.insert(args, word:lower())
	end
	
	local command = args[1] or ""
	
	-- Handle commands
	if command == "" or command == "config" or command == "options" then
		self:OpenConfig()
	elseif command == "panel" then
		self:TogglePanel()
	elseif command == "reset" then
		self:ResetSettings()
	elseif command == "profile" then
		self:HandleProfile(args)
	elseif command == "debug" then
		self:ToggleDebug()
	elseif command == "help" or command == "?" then
		self:ShowHelp()
	elseif command == "version" or command == "v" then
		self:ShowVersion()
	elseif command == "status" then
		self:ShowStatus()
	else
		Aether:Print("Unknown command. Type '/aether help' for help.")
	end
end

--[[
	Open configuration
]]--
function Cmd:OpenConfig()
	-- For now, print a message
	-- In production, this would open the options frame
	Aether:Print("Opening configuration... (UI not yet implemented)")
	
	-- Try to open Blizzard options if available
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)
	elseif Settings and Settings.OpenToCategory then
		Settings.OpenToCategory(ADDON_NAME)
	end
end

--[[
	Toggle panel
]]--
function Cmd:TogglePanel()
	local enabled = Aether.Config:Get("panel", "enabled")
	Aether.Config:Set("panel", "enabled", not enabled)
	
	if not enabled then
		Aether:Print("Panel enabled")
	else
		Aether:Print("Panel disabled")
	end
end

--[[
	Reset settings
]]--
function Cmd:ResetSettings()
	-- Confirmation would be nice here
	Aether:Print("Resetting all settings to defaults...")
	Aether.Config:ResetAll()
end

--[[
	Handle profile commands
]]--
function Cmd:HandleProfile(args)
	local subcommand = args[2] or ""
	
	if subcommand == "" or subcommand == "list" then
		-- List profiles
		local profiles = Aether.Profiles:GetProfileList()
		local current = Aether.Profiles:GetCurrentProfile()
		
		Aether:Print("Available profiles:")
		for _, name in ipairs(profiles) do
			if name == current then
				Aether:Print("  " .. Aether.C.COLOR_CODES.GREEN .. name .. " (current)" .. Aether.C.COLOR_CODES.CLOSE)
			else
				Aether:Print("  " .. name)
			end
		end
	elseif subcommand == "load" or subcommand == "switch" then
		-- Switch profile
		local profileName = args[3]
		if profileName then
			Aether.Profiles:LoadProfile(profileName)
		else
			Aether:Print("Usage: /aether profile load <name>")
		end
	elseif subcommand == "create" or subcommand == "new" then
		-- Create profile
		local profileName = args[3]
		if profileName then
			if Aether.Profiles:CreateProfile(profileName) then
				Aether:Print("Created profile:", profileName)
			end
		else
			Aether:Print("Usage: /aether profile create <name>")
		end
	elseif subcommand == "delete" or subcommand == "remove" then
		-- Delete profile
		local profileName = args[3]
		if profileName then
			if Aether.Profiles:DeleteProfile(profileName) then
				Aether:Print("Deleted profile:", profileName)
			end
		else
			Aether:Print("Usage: /aether profile delete <name>")
		end
	elseif subcommand == "copy" then
		-- Copy profile
		local sourceName = args[3]
		local targetName = args[4]
		if sourceName and targetName then
			if Aether.Profiles:CopyProfile(sourceName, targetName) then
				Aether:Print("Copied profile:", sourceName, "to", targetName)
			end
		else
			Aether:Print("Usage: /aether profile copy <source> <target>")
		end
	elseif subcommand == "reset" then
		-- Reset profile
		local profileName = args[3] or Aether.Profiles:GetCurrentProfile()
		Aether.Profiles:ResetProfile(profileName)
	else
		Aether:Print("Profile commands:")
		Aether:Print("  /aether profile list - List all profiles")
		Aether:Print("  /aether profile load <name> - Load a profile")
		Aether:Print("  /aether profile create <name> - Create a new profile")
		Aether:Print("  /aether profile delete <name> - Delete a profile")
		Aether:Print("  /aether profile copy <source> <target> - Copy a profile")
		Aether:Print("  /aether profile reset [name] - Reset a profile")
	end
end

--[[
	Toggle debug mode
]]--
function Cmd:ToggleDebug()
	Aether.debug = not Aether.debug
	
	if Aether.debug then
		Aether:Print("Debug mode enabled")
	else
		Aether:Print("Debug mode disabled")
	end
end

--[[
	Show help
]]--
function Cmd:ShowHelp()
	print(Aether.C.HELP_TEXT)
end

--[[
	Show version
]]--
function Cmd:ShowVersion()
	Aether:Print("Version " .. Aether.version)
	
	-- Show API info
	local apiVersion = select(4, GetBuildInfo())
	Aether:Print("WoW API Version:", apiVersion)
	
	-- Show expansion
	if Aether.C.IS_MIDNIGHT then
		Aether:Print("Expansion: Midnight (12.0+)")
	elseif Aether.C.IS_WAR_WITHIN then
		Aether:Print("Expansion: The War Within (11.0+)")
	else
		Aether:Print("Expansion Level:", Aether.C.EXPANSION_LEVEL)
	end
end

--[[
	Show status
]]--
function Cmd:ShowStatus()
	Aether:Print("Status:")
	Aether:Print("  Version:", Aether.version)
	Aether:Print("  Loaded:", Aether.loaded and "Yes" or "No")
	Aether:Print("  Debug:", Aether.debug and "On" or "Off")
	Aether:Print("  Modules:", Aether.U.TableSize(Aether.modules))
	Aether:Print("  Plugins:", Aether.U.TableSize(Aether.plugins))
	Aether:Print("  Profile:", Aether.Profiles.currentProfile or "None")
	Aether:Print("  Memory:", Aether.U.FormatMemory(Aether.U.GetAddonMemory()))
end
