--- **AceConsole-3.0** provides registration facilities for slash commands.
-- @class file
-- @name AceConsole-3.0
-- @release $Id: AceConsole-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceConsole-3.0", 7

local AceConsole = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConsole then return end

AceConsole.commands = AceConsole.commands or {}
AceConsole.embeds = AceConsole.embeds or {}

-- Lua APIs
local tconcat, tostring, select = table.concat, tostring, select
local type, pairs, error = type, pairs, error
local format, strfind, strsub = string.format, string.find, string.sub
local max = math.max

--- Print to the default chat frame.
-- @param ... Messages to print
local function Print(...)
	return print(...)
end

--- Formatted print to the default chat frame.
-- @param format Format string
-- @param ... Arguments for format
local function Printf(format, ...)
	return Print(format:format(...))
end

--- Register a slash command.
-- @param command Name of your slash command (like "/mycommand")
-- @param func The function to call (or method name)
-- @param ... Additional slash commands (like "/mc", "/mycmd")
function AceConsole:RegisterChatCommand(command, func, ...)
	if type(command)~="string" then
		error("Usage: RegisterChatCommand(command, func): command must be a string", 2)
	end
	
	if type(func) ~= "string" and type(func) ~= "function" then
		error("Usage: RegisterChatCommand(command, func): func must be a string or function", 2)
	end
	
	local name = strupper(command)
	
	for i = 1, select("#", ...) + 1 do
		local cmd = i == 1 and command or select(i - 1, ...)
		if cmd then
			cmd = strupper(cmd)
			if cmd ~= "" then
				local func_ref
				if type(func) == "string" then
					func_ref = function(msg) 
						self[func](self, msg)
					end
				else
					func_ref = func
				end
				
				_G["SLASH_"..name..i] = "/"..strlower(cmd)
				self.commands[name] = func_ref
			end
		end
	end
	
	SlashCmdList[name] = function(msg, editbox)
		self.commands[name](msg, editbox)
	end
end

--- Unregister a slash command.
-- @param command The slash command to unregister
function AceConsole:UnregisterChatCommand(command)
	if type(command)~="string" then
		error("Usage: UnregisterChatCommand(command): command must be a string", 2)
	end
	
	local name = strupper(command)
	SlashCmdList[name] = nil
	_G["SLASH_"..name.."1"] = nil
	self.commands[name] = nil
end

--- Get arguments from a string.
-- @param str The string to parse
-- @return ... The parsed arguments
function AceConsole:GetArgs(str, numargs, startpos)
	numargs = numargs or 1
	startpos = max(startpos or 1, 1)
	
	local args = {}
	local arg, pos = self:GetArg(str, startpos)
	
	while arg do
		args[#args + 1] = arg
		if #args >= numargs then break end
		arg, pos = self:GetArg(str, pos)
	end
	
	return unpack(args)
end

--- Get a single argument from a string.
-- @param str The string to parse
-- @param startpos Starting position
-- @return arg, nextpos
function AceConsole:GetArg(str, startpos)
	startpos = max(startpos or 1, 1)
	
	-- Skip whitespace
	local _, endpos = strfind(str, "^%s*", startpos)
	if not endpos then
		return
	end
	
	startpos = endpos + 1
	if startpos > #str then
		return
	end
	
	-- Check for quoted string
	if strsub(str, startpos, startpos) == '"' then
		local _, argend = strfind(str, '^"(.-)"', startpos)
		if argend then
			return strsub(str, startpos + 1, argend - 1), argend + 1
		end
	end
	
	-- Get non-whitespace
	local argstart, argend = strfind(str, "^[^%s]+", startpos)
	if argstart then
		return strsub(str, argstart, argend), argend + 1
	end
end

local mixins = {
	"RegisterChatCommand",
	"UnregisterChatCommand",
	"Print",
	"Printf",
	"GetArgs",
	"GetArg",
}

-- Embeds AceConsole-3.0 into the target object
function AceConsole:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	target.Print = Print
	target.Printf = Printf
	self.embeds[target] = true
	return target
end

-- Upgrade embeds
for target, v in pairs(AceConsole.embeds) do
	AceConsole:Embed(target)
end
