--- **AceHook-3.0** offers safe Hooking/Unhooking of functions, methods and frame scripts.
-- @class file
-- @name AceHook-3.0
-- @release $Id: AceHook-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceHook-3.0", 8
local AceHook = LibStub:NewLibrary(MAJOR, MINOR)

if not AceHook then return end

AceHook.embeds = AceHook.embeds or {}
AceHook.registry = AceHook.registry or setmetatable({}, {__index = function(tbl, key) tbl[key] = {} return tbl[key] end})
AceHook.handlers = AceHook.handlers or {}
AceHook.actives = AceHook.actives or {}
AceHook.scripts = AceHook.scripts or {}
AceHook.onceSecure = AceHook.onceSecure or {}

-- Lua APIs
local pairs, next, type = pairs, next, type
local format = string.format
local error, assert = error, assert

-- WoW APIs  
local hooksecurefunc = hooksecurefunc
local issecurevariable = issecurevariable

--- Hook a function or a method on an object.
-- @paramsig [object], method, [handler], [hookSecure]
-- @param object The object to hook the method on (optional)
-- @param method The name of the method to hook
-- @param handler The handler for the hook (optional, defaults to the method name)
-- @param hookSecure If true, the hook will be created using hooksecurefunc (optional)
function AceHook:Hook(object, method, handler, hookSecure)
	if type(object) == "string" then
		-- Shift arguments
		method, handler, hookSecure = object, method, handler
		object = _G
	end
	
	if type(method) ~= "string" then
		error(format("Usage: Hook([object], method, [handler], [hookSecure]): 'method' - string expected, got %s", type(method)), 2)
	end
	
	if handler == nil then
		handler = method
	end
	
	if self.registry[self][method] then
		return -- Already hooked
	end
	
	local orig = object[method]
	if not orig then
		error(format("Attempt to hook a non-existing function %q", method), 2)
	end
	
	local uid = self
	local registry = AceHook.registry[uid]
	
	registry[method] = orig
	AceHook.actives[uid] = AceHook.actives[uid] or {}
	AceHook.actives[uid][method] = true
	
	if hookSecure or (object == _G and issecurevariable(method)) then
		hooksecurefunc(object, method, function(...)
			if type(handler) == "string" then
				self[handler](self, ...)
			else
				handler(...)
			end
		end)
	else
		object[method] = function(...)
			if type(handler) == "string" then
				return self[handler](self, ...)
			else
				return handler(...)
			end
		end
	end
end

--- Hook a script handler on a frame.
-- @paramsig frame, script, [handler], [hookSecure]
-- @param frame The frame to hook
-- @param script The script to hook (e.g., "OnShow", "OnHide")
-- @param handler The handler for the hook (optional, defaults to the script name)
-- @param hookSecure If true, the hook will be created using hooksecurefunc (optional)
function AceHook:HookScript(frame, script, handler, hookSecure)
	if type(frame) ~= "table" or type(frame.GetScript) ~= "function" then
		error(format("Usage: HookScript(frame, script, [handler]): 'frame' - expected frame, got %s", type(frame)), 2)
	end
	
	if type(script) ~= "string" then
		error(format("Usage: HookScript(frame, script, [handler]): 'script' - string expected, got %s", type(script)), 2)
	end
	
	if handler == nil then
		handler = script
	end
	
	local uid = self
	AceHook.scripts[uid] = AceHook.scripts[uid] or {}
	local registry = AceHook.scripts[uid]
	
	if registry[frame] and registry[frame][script] then
		return -- Already hooked
	end
	
	local orig = frame:GetScript(script)
	
	registry[frame] = registry[frame] or {}
	registry[frame][script] = orig
	
	if hookSecure then
		frame:HookScript(script, function(...)
			if type(handler) == "string" then
				self[handler](self, ...)
			else
				handler(...)
			end
		end)
	else
		frame:SetScript(script, function(...)
			if orig then
				orig(...)
			end
			if type(handler) == "string" then
				return self[handler](self, ...)
			else
				return handler(...)
			end
		end)
	end
end

--- Unhook a function.
-- @paramsig [object], method
-- @param object The object to unhook from (optional)
-- @param method The method to unhook
function AceHook:Unhook(object, method)
	if type(object) == "string" then
		method = object
		object = _G
	end
	
	local uid = self
	local registry = AceHook.registry[uid]
	
	if not registry or not registry[method] then
		return
	end
	
	object[method] = registry[method]
	registry[method] = nil
	AceHook.actives[uid][method] = nil
end

--- Unhook a frame script.
-- @paramsig frame, script
-- @param frame The frame
-- @param script The script to unhook
function AceHook:UnhookScript(frame, script)
	local uid = self
	local registry = AceHook.scripts[uid]
	
	if not registry or not registry[frame] or not registry[frame][script] then
		return
	end
	
	frame:SetScript(script, registry[frame][script])
	registry[frame][script] = nil
end

--- Unhook all hooks.
function AceHook:UnhookAll()
	local uid = self
	
	-- Unhook regular hooks
	local registry = AceHook.registry[uid]
	if registry then
		for method, orig in pairs(registry) do
			_G[method] = orig
		end
		AceHook.registry[uid] = {}
		AceHook.actives[uid] = {}
	end
	
	-- Unhook scripts
	local scripts = AceHook.scripts[uid]
	if scripts then
		for frame, handlers in pairs(scripts) do
			for script, orig in pairs(handlers) do
				frame:SetScript(script, orig)
			end
		end
		AceHook.scripts[uid] = {}
	end
end

--- Check if something is hooked.
-- @paramsig [object], method
-- @param object The object (optional)
-- @param method The method
-- @return True if hooked, false otherwise
function AceHook:IsHooked(object, method)
	if type(object) == "string" then
		method = object
	end
	
	local uid = self
	local registry = AceHook.registry[uid]
	return registry and registry[method] ~= nil
end

local mixins = {
	"Hook", "HookScript",
	"Unhook", "UnhookScript", "UnhookAll",
	"IsHooked",
}

function AceHook:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function AceHook:OnEmbedDisable(target)
	target:UnhookAll()
end

for target, v in pairs(AceHook.embeds) do
	AceHook:Embed(target)
end
