--- **AceTimer-3.0** provides a central facility for registering timers.
-- @class file
-- @name AceTimer-3.0
-- @release $Id: AceTimer-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceTimer-3.0", 17
local AceTimer = LibStub:NewLibrary(MAJOR, MINOR)

if not AceTimer then return end

AceTimer.embeds = AceTimer.embeds or {}
AceTimer.selfs = AceTimer.selfs or {}
AceTimer.hash = AceTimer.hash or {}
AceTimer.debug = false

-- Lua APIs
local type, unpack, next, error = type, unpack, next, error
local tonumber, pairs, pcall = tonumber, pairs, pcall

-- WoW APIs
local GetTime = GetTime
local C_TimerAfter = C_Timer.After
local C_TimerNewTicker = C_Timer.NewTicker

local function new(self, loop, func, delay, ...)
	if delay < 0.01 then
		delay = 0.01 -- Minimum delay
	end
	
	local id = {}
	local args = {...}
	local argCount = select("#", ...)
	
	local timer
	local callback = function()
		if type(func) == "string" then
			if not self[func] then
				AceTimer:CancelTimer(id)
				return
			end
			self[func](self, unpack(args, 1, argCount))
		else
			func(unpack(args, 1, argCount))
		end
		
		if not loop then
			AceTimer.selfs[id] = nil
			AceTimer.hash[id] = nil
		end
	end
	
	if loop then
		timer = C_TimerNewTicker(delay, callback)
	else
		C_TimerAfter(delay, callback)
	end
	
	AceTimer.hash[id] = timer
	AceTimer.selfs[id] = self
	return id
end

--- Schedule a new one-shot timer.
-- @param callback The callback function or method name
-- @param delay The delay in seconds
-- @param ... Arguments to pass to the callback
-- @return Opaque timer handle
function AceTimer:ScheduleTimer(func, delay, ...)
	if type(func) ~= "string" and type(func) ~= "function" then
		error("Usage: ScheduleTimer(callback, delay, ...): callback must be a function or method name", 2)
	end
	if type(delay) ~= "number" then
		error("Usage: ScheduleTimer(callback, delay, ...): delay must be a number", 2)
	end
	return new(self, false, func, delay, ...)
end

--- Schedule a repeating timer.
-- @param callback The callback function or method name
-- @param delay The delay in seconds
-- @param ... Arguments to pass to the callback
-- @return Opaque timer handle
function AceTimer:ScheduleRepeatingTimer(func, delay, ...)
	if type(func) ~= "string" and type(func) ~= "function" then
		error("Usage: ScheduleRepeatingTimer(callback, delay, ...): callback must be a function or method name", 2)
	end
	if type(delay) ~= "number" then
		error("Usage: ScheduleRepeatingTimer(callback, delay, ...): delay must be a number", 2)
	end
	return new(self, true, func, delay, ...)
end

--- Cancel a timer.
-- @param id The timer handle
function AceTimer:CancelTimer(id)
	local timer = AceTimer.hash[id]
	if timer and timer.Cancel then
		timer:Cancel()
	end
	AceTimer.hash[id] = nil
	AceTimer.selfs[id] = nil
end

--- Cancel all timers for this object.
function AceTimer:CancelAllTimers()
	for id, self in pairs(AceTimer.selfs) do
		if self == self then
			AceTimer:CancelTimer(id)
		end
	end
end

--- Get the time left for a timer.
-- @param id The timer handle
-- @return Time left in seconds, or false if the timer doesn't exist
function AceTimer:TimeLeft(id)
	local timer = AceTimer.hash[id]
	if timer and timer._remainingIterations then
		return timer._remainingIterations * timer._delay
	end
	return 0
end

local mixins = {
	"ScheduleTimer",
	"ScheduleRepeatingTimer",
	"CancelTimer",
	"CancelAllTimers",
	"TimeLeft",
}

function AceTimer:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function AceTimer:OnEmbedDisable(target)
	target:CancelAllTimers()
end

for target, v in pairs(AceTimer.embeds) do
	AceTimer:Embed(target)
end
