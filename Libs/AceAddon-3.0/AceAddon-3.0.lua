--- **AceAddon-3.0** provides a framework for creating addons with modules and managing their lifecycle.
-- @class file
-- @name AceAddon-3.0
-- @release $Id: AceAddon-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceAddon-3.0", 14
local AceAddon, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceAddon then return end -- No upgrade needed

AceAddon.frame = AceAddon.frame or CreateFrame("Frame", "AceAddon30Frame") -- Our very own frame
AceAddon.addons = AceAddon.addons or {} -- Addon database
AceAddon.statuses = AceAddon.statuses or {} -- Addon statuses
AceAddon.initializequeue = AceAddon.initializequeue or {} -- Addons that are queued for initialization
AceAddon.enablequeue = AceAddon.enablequeue or {} -- Addons that are queued for enabling
AceAddon.embeds = AceAddon.embeds or setmetatable({}, {__index = function(tbl, key) tbl[key] = {} return tbl[key] end}) -- Embedded methods

-- Lua APIs
local tinsert, tconcat = table.insert, table.concat
local fmt = string.format
local tostring, select, pairs, type = tostring, select, pairs, type
local loadstring, assert, error = loadstring, assert, error
local setmetatable, getmetatable, rawget, rawset = setmetatable, getmetatable, rawget, rawset

-- WoW APIs
local _G = _G

xpcall = xpcall

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	if func then
		return xpcall(func, errorhandler, ...)
	end
end

--- Create a new AceAddon-3.0 addon.
-- @paramsig [object ,]name[, deps, ...]
-- @param object Table to use as a base for the addon (optional)
-- @param name Name of the addon object to create
-- @param deps List of dependencies for the addon
-- @usage
-- -- Create a simple addon object
-- MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceEvent-3.0")
-- 
-- -- Create a simple addon object with multiple dependencies
-- local MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceEvent-3.0", "AceDB-3.0")
function AceAddon:NewAddon(objectorname, ...)
	local object, name
	local i = 1
	if type(objectorname) == "table" then
		object = objectorname
		name = ...
		i = 2
	else
		name = objectorname
	end
	if type(name) ~= "string" then
		error(("Usage: NewAddon([object,] name, [lib, ...]): 'name' - string expected, got %s"):format(type(name)), 2)
	end
	if self.addons[name] then
		error(("Usage: NewAddon([object,] name, [lib, ...]): 'name' - Addon %q already exists."):format(name), 2)
	end
	
	object = object or {}
	object.name = name
	
	local addonmeta = {}
	local oldmeta = getmetatable(object)
	if oldmeta then
		for k, v in pairs(oldmeta) do addonmeta[k] = v end
	end
	addonmeta.__tostring = function() return name end
	setmetatable(object, addonmeta)
	
	self.addons[name] = object
	object.modules = {}
	object.orderedModules = {}
	object.defaultModuleLibraries = {}
	Embed(object) -- embed NewModule, GetModule methods
	self:EmbedLibraries(object, select(i, ...))
	
	-- Add to enable queue
	tinsert(self.enablequeue, object)
	return object
end

--- Get the addon object by its name from the internal AceAddon registry.
-- @param name unique name of the addon object
-- @usage
-- -- Get the Addon
-- local MyAddon = LibStub("AceAddon-3.0"):GetAddon("MyAddon")
function AceAddon:GetAddon(name)
	return self.addons[name]
end

--- Embeds a list of libraries into the target addon.
-- @paramsig target, [lib, ...]
-- @param target target object to embed into
-- @param lib List of Libraries to embed into the addon
function AceAddon:EmbedLibraries(target, ...)
	for i = 1, select("#", ...) do
		local lib = select(i, ...)
		self:EmbedLibrary(target, lib, false, 4)
	end
end

--- Embeds a library into the target addon.
-- @paramsig target, lib[, silent[, offset]]
-- @param target target object to embed into
-- @param lib Library to embed
-- @param silent Don't error if the library doesn't exist, just don't embed it
-- @param offset Offset for the error messages (optional)
function AceAddon:EmbedLibrary(target, lib, silent, offset)
	local maj, min = LibStub(lib, silent)
	if maj then
		safecall(LibStub(maj).Embed, LibStub(maj), target)
		tinsert(self.embeds[target], lib)
		return true
	elseif not silent then
		error(("Usage: EmbedLibrary(target, lib, [silent]): 'lib' - Library %s could not be found."):format(lib), (offset or 3))
	end
end

--- Return the specified module from an addon object.
-- @name //addon//:GetModule
-- @paramsig name[, silent]
-- @param name unique name of the module
-- @param silent if true, the module is optional, silently return nil if its not found (optional)
-- @usage
-- -- Get the module object
-- local MyModule = MyAddon:GetModule("MyModule")
local function GetModule(self, name, silent)
	if not self.modules[name] and not silent then
		error(("Usage: GetModule(name, [silent]): 'name' - Module %q does not exist."):format(name), 2)
	end
	return self.modules[name]
end

--- Create a new module for an addon.
-- @name //addon//:NewModule
-- @paramsig name[, prototype, libs...]
-- @param name unique name of the module
-- @param prototype object to derive the module from (optional)
-- @param libs List of libraries to embed into the addon
-- @usage
-- -- Create a module with some embeded libraries
-- local MyModule = MyAddon:NewModule("MyModule", "AceEvent-3.0", "AceHook-3.0")
local function NewModule(self, name, prototype, ...)
	if type(name) ~= "string" then
		error(("Usage: NewModule(name, [prototype, lib, ...]): 'name' - string expected, got %s"):format(type(name)), 2)
	end
	if self.modules[name] then
		error(("Usage: NewModule(name, [prototype, lib, ...]): 'name' - Module %q already exists."):format(name), 2)
	end
	
	local module = prototype and type(prototype) == "table" and prototype or {}
	module.name = name
	
	local mt = {}
	local oldmt = getmetatable(module)
	if oldmt then
		for k, v in pairs(oldmt) do mt[k] = v end
	end
	mt.__tostring = function() return name end
	setmetatable(module, mt)
	
	safecall(self.OnModuleCreated, self, module) -- notify the addon
	
	self.modules[name] = module
	tinsert(self.orderedModules, module)
	
	Embed(module, true) -- embed NewModule, GetModule methods
	
	-- Embed default libraries
	local libs = {}
	if prototype then tinsert(libs, prototype) end
	for i = 1, select("#", ...) do
		tinsert(libs, (select(i, ...)))
	end
	
	-- Add default module libraries
	for i = 1, #self.defaultModuleLibraries do
		tinsert(libs, self.defaultModuleLibraries[i])
	end
	
	AceAddon:EmbedLibraries(module, unpack(libs))
	
	safecall(module.OnInitialize, module)
	
	return module
end

--- Set default libraries for modules.
-- @name //addon//:SetDefaultModuleLibraries
-- @paramsig [lib, ...]
-- @param lib List of libraries to embed in all modules
local function SetDefaultModuleLibraries(self, ...)
	self.defaultModuleLibraries = {...}
end

--- Set default prototype for modules.
-- @name //addon//:SetDefaultModulePrototype
-- @paramsig prototype
-- @param prototype prototype to use for modules
local function SetDefaultModulePrototype(self, prototype)
	self.defaultModulePrototype = prototype
end

--- Set default state of a module.
-- @name //addon//:SetDefaultModuleState
-- @paramsig state
-- @param state Default state (enabled/disabled)
local function SetDefaultModuleState(self, state)
	self.defaultModuleState = state
end

--- Set the enable state of an addon or module
-- @name //addon//:SetEnabledState
-- @paramsig state
-- @param state the state to set
local function SetEnabledState(self, state)
	AceAddon.statuses[self.name] = state
end

--- Return an iterator of all modules.
-- @name //addon//:IterateModules
local function IterateModules(self)
	return pairs(self.modules)
end

local mixins = {
	NewModule = NewModule,
	GetModule = GetModule,
	SetDefaultModuleLibraries = SetDefaultModuleLibraries,
	SetDefaultModulePrototype = SetDefaultModulePrototype,
	SetDefaultModuleState = SetDefaultModuleState,
	SetEnabledState = SetEnabledState,
	IterateModules = IterateModules,
}

-- Embed all the mixins
function Embed(target, isModule)
	for k, v in pairs(mixins) do
		target[k] = v
	end
end

--- Enable the addon.
-- @name //addon//:Enable
local function Enable(self)
	AceAddon:EnableAddon(self)
end

--- Disable the addon.
-- @name //addon//:Disable
local function Disable(self)
	AceAddon:DisableAddon(self)
end

--- Enable an addon by name.
function AceAddon:EnableAddon(addon)
	if type(addon) == "string" then addon = self.addons[addon] end
	if not addon then return end
	
	if AceAddon.statuses[addon.name] then return end
	AceAddon.statuses[addon.name] = true
	
	safecall(addon.OnEnable, addon)
	
	-- Enable all modules
	for name, module in pairs(addon.modules) do
		AceAddon:EnableAddon(module)
	end
end

--- Disable an addon by name.
function AceAddon:DisableAddon(addon)
	if type(addon) == "string" then addon = self.addons[addon] end
	if not addon then return end
	
	if not AceAddon.statuses[addon.name] then return end
	AceAddon.statuses[addon.name] = false
	
	safecall(addon.OnDisable, addon)
	
	-- Disable all modules
	for name, module in pairs(addon.modules) do
		AceAddon:DisableAddon(module)
	end
end

--- Initialize the addon after creation.
function AceAddon:InitializeAddon(addon)
	safecall(addon.OnInitialize, addon)
end

-- Event handlers
AceAddon.frame:RegisterEvent("PLAYER_LOGIN")
AceAddon.frame:SetScript("OnEvent", function(this, event, ...)
	if event == "PLAYER_LOGIN" then
		for i = 1, #AceAddon.enablequeue do
			local addon = AceAddon.enablequeue[i]
			AceAddon:InitializeAddon(addon)
			AceAddon:EnableAddon(addon)
		end
		AceAddon.enablequeue = {}
	end
end)

--- Get an iterator over all registered addons.
-- @return iterator
function AceAddon:IterateAddons()
	return pairs(self.addons)
end

--- Get an iterator over all embedded libraries of an addon.
-- @param addon addon object to get embedds from
-- @return iterator
function AceAddon:IterateEmbed(addon)
	return pairs(self.embeds[addon])
end
