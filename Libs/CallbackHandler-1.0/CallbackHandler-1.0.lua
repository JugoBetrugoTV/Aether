--[[ $Id: CallbackHandler-1.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $ ]]
local MAJOR, MINOR = "CallbackHandler-1.0", 7
local CallbackHandler = LibStub:NewLibrary(MAJOR, MINOR)

if not CallbackHandler then return end -- No upgrade needed

local meta = {__index = function(tbl, key) tbl[key] = {} return tbl[key] end}

-- Lua APIs
local tconcat = table.concat
local assert, error, loadstring = assert, error, loadstring
local setmetatable, rawset, rawget = setmetatable, rawset, rawget
local next, select, pairs, type, tostring = next, select, pairs, type, tostring

local function Dispatch(handlers, ...)
	local index, method = next(handlers)
	if not method then return end
	repeat
		local success, err = pcall(method, index, ...)
		if not success then
			geterrorhandler()(err)
		end
		index, method = next(handlers, index)
	until not method
end

--------------------------------------------------------------------------
-- CallbackHandler:New
--
--   target            - target object to embed public APIs in
--   RegisterName      - name of the callback registration API, default "RegisterCallback"
--   UnregisterName    - name of the callback unregistration API, default "UnregisterCallback"
--   UnregisterAllName - name of the callback unregistration API, default "UnregisterAllCallbacks". false == don't publish this API.

function CallbackHandler.New(_self, target, RegisterName, UnregisterName, UnregisterAllName)

	RegisterName = RegisterName or "RegisterCallback"
	UnregisterName = UnregisterName or "UnregisterCallback"
	if UnregisterAllName == nil then	-- false is used to indicate "don't want this method"
		UnregisterAllName = "UnregisterAllCallbacks"
	end

	-- we declare all objects and exported APIs inside this closure to quickly gain access
	-- to e.g. function names, the "target" parameter, etc


	-- Create the registry object
	local events = setmetatable({}, meta)
	local registry = { recurse = 0, events = events }

	-- registry:Fire() - fires the given event/message into the registry
	function registry:Fire(eventname, ...)
		if not rawget(events, eventname) or not next(events[eventname]) then return end
		local oldrecurse = registry.recurse
		registry.recurse = oldrecurse + 1

		Dispatch(events[eventname], eventname, ...)

		registry.recurse = oldrecurse

		if registry.insertQueue and oldrecurse == 0 then
			-- Something in one of our callbacks wanted to register more callbacks; they got queued
			for event, callbacks in pairs(registry.insertQueue) do
				local first = not rawget(events, event) or not next(events[event])	-- test for empty before. not test for one member after. that one member may have been overwritten.
				for object, func in pairs(callbacks) do
					events[event][object] = func
					-- fire OnUsed callback?
					if first and registry.OnUsed then
						registry.OnUsed(registry, target, event)
						first = nil
					end
				end
			end
			registry.insertQueue = nil
		end
	end

	-- Registration of a callback, handles:
	--   self["method"], leads to self["method"](self, ...)
	--   self with function ref, leads to functionref(...)
	--   "addonId" (by name), leads to _G["addonId"]["method"](_G["addonId"], ...)
	--   all with an optional arg, which, if present, gets passed as first argument (after self if present)
	target[RegisterName] = function(self, eventname, method, ... --[[actually just a single arg]])
		if type(eventname) ~= "string" then
			error("Usage: "..RegisterName.."(eventname, method[, arg]): 'eventname' - string expected.", 2)
		end

		method = method or eventname

		local first = not rawget(events, eventname) or not next(events[eventname])	-- test for empty before. not test for one member after. that one member may have been overwritten.

		if type(method) ~= "string" and type(method) ~= "function" then
			error("Usage: "..RegisterName.."(\"eventname\", \"methodname\"): 'methodname' - string or function expected.", 2)
		end

		local regfunc

		if type(method) == "string" then
			-- self["method"] with arg
			if select("#", ...) >= 1 then	-- this is not the same as testing for arg==nil!
				local arg = select(1, ...)
				regfunc = function(...) self[method](self, arg, ...) end
			-- self["method"] without arg
			else
				regfunc = function(...) self[method](self, ...) end
			end
		else
			-- function ref with arg
			if select("#", ...) >= 1 then	-- this is not the same as testing for arg==nil!
				local arg = select(1, ...)
				regfunc = function(...) method(arg, ...) end
			-- function ref without arg
			else
				regfunc = method
			end
		end


		if registry.recurse < 1 then
			events[eventname][self] = regfunc
			-- fire OnUsed callback?
			if registry.OnUsed and first then
				registry.OnUsed(registry, target, eventname)
			end
		else
			-- we're currently processing a callback in this registry, so delay the registration of this new entry!
			registry.insertQueue = registry.insertQueue or setmetatable({}, meta)
			registry.insertQueue[eventname][self] = regfunc
		end
	end

	-- Unregister a callback
	target[UnregisterName] = function(self, eventname)
		if not self or not eventname then
			error("Usage: "..UnregisterName.."(eventname): 'self' and 'eventname' must be supplied", 2)
		end
		if not rawget(events, eventname) or not events[eventname][self] then
			return
		end
		events[eventname][self] = nil
		-- Fire OnUnused callback?
		if registry.OnUnused and not next(events[eventname]) then
			registry.OnUnused(registry, target, eventname)
		end
	end

	-- OPTIONAL: Unregister all callbacks for given selfs/addonIds
	if UnregisterAllName then
		target[UnregisterAllName] = function(...)
			if select("#", ...) < 1 then
				error("Usage: "..UnregisterAllName.."([whatFor]): missing 'self' or \"addonId\" to unregister events for.", 2)
			end
			if select("#", ...) == 1 and ... == target then
				target[UnregisterAllName] = nil
				target[UnregisterName] = nil
				target[RegisterName] = nil
				return
			end
			for i = 1, select("#", ...) do
				local self = select(i, ...)
				if self and type(self) == "string" then
					self = _G[self]
				end
				if self then
					for eventname, callbacks in pairs(events) do
						if callbacks[self] then
							callbacks[self] = nil
							-- Fire OnUnused callback?
							if registry.OnUnused and not next(callbacks) then
								registry.OnUnused(registry, target, eventname)
							end
						end
					end
				end
			end
		end
	end

	return registry
end


-- CallbackHandler purposefully does NOT do explicit embedding. Nor does it
-- try to upgrade old implicit embeds since the system is selfcontained and
-- relies on closures to work.
