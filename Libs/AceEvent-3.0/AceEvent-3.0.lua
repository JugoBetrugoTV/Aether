--- **AceEvent-3.0** provides event registration and secure dispatching.
-- All dispatching is done using **CallbackHandler-1.0**. AceEvent is a simple wrapper around
-- CallbackHandler, and dispatches all game events or addon message to the registrees.
-- @class file
-- @name AceEvent-3.0
-- @release $Id: AceEvent-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $

local MAJOR, MINOR = "AceEvent-3.0", 4
local AceEvent = LibStub:NewLibrary(MAJOR, MINOR)

if not AceEvent then return end

-- Lua APIs
local pairs = pairs

AceEvent.frame = AceEvent.frame or CreateFrame("Frame", "AceEvent30Frame") -- our  own  frame to hook scripts
AceEvent.embeds = AceEvent.embeds or {} -- what objects embed this lib

-- APIs and registry for blizzard events, using CallbackHandler lib
if not AceEvent.events then
	AceEvent.events = LibStub("CallbackHandler-1.0"):New(AceEvent,
		"RegisterEvent", "UnregisterEvent", "UnregisterAllEvents")
end

function AceEvent.events:OnUsed(target, eventname)
	AceEvent.frame:RegisterEvent(eventname)
end

function AceEvent.events:OnUnused(target, eventname)
	AceEvent.frame:UnregisterEvent(eventname)
end


-- APIs and registry for IPC messages, using CallbackHandler lib
if not AceEvent.messages then
	AceEvent.messages = LibStub("CallbackHandler-1.0"):New(AceEvent,
		"RegisterMessage", "UnregisterMessage", "UnregisterAllMessages"
	)
	AceEvent.SendMessage = AceEvent.messages.Fire
end

--- embedding and embed handling
local mixins = {
	"RegisterEvent", "UnregisterEvent",
	"RegisterMessage", "UnregisterMessage",
	"SendMessage",
	"UnregisterAllEvents", "UnregisterAllMessages",
}

--- Register for a Blizzard Event.
-- @name AceEvent:RegisterEvent
-- @class function
-- @paramsig event[, callback[, arg]]
-- @param event The event to register for
-- @param callback The callback function to call when the event is triggered (funcref or method, defaults to event name)
-- @param arg An optional argument to pass to the callback function

--- Unregister an event.
-- @name AceEvent:UnregisterEvent
-- @class function
-- @paramsig event
-- @param event The event to unregister

--- Register for a custom AceEvent-internal message.
-- @name AceEvent:RegisterMessage
-- @class function
-- @paramsig message[, callback[, arg]]
-- @param message The message to register for
-- @param callback The callback function to call when the message is triggered (funcref or method, defaults to message name)
-- @param arg An optional argument to pass to the callback function

--- Unregister a message
-- @name AceEvent:UnregisterMessage
-- @class function
-- @paramsig message
-- @param message The message to unregister

--- Send a message over the AceEvent-3.0 internal message system to other addons registered for this message.
-- @name AceEvent:SendMessage
-- @class function
-- @paramsig message, ...
-- @param message The message to send
-- @param ... Any arguments to the message

-- Embeds AceEvent-3.0 into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed AceEvent-3.0 in
function AceEvent:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

-- AceEvent:OnEmbedDisable( target )
-- target (object) - target object that is being disabled
--
-- Unregister all events messages etc when the target disables.
-- this method is called by the target's OnDisable function.
function AceEvent:OnEmbedDisable(target)
	target:UnregisterAllEvents()
	target:UnregisterAllMessages()
end

-- Script to fire blizzard events into the event listeners
AceEvent.frame:SetScript("OnEvent", function(this, event, ...)
	AceEvent.events:Fire(event, ...)
end)

--- Finally: upgrade our old embeds
for target, v in pairs(AceEvent.embeds) do
	AceEvent:Embed(target)
end
