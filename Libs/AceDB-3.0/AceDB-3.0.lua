--- **AceDB-3.0** manages the SavedVariables for your addon.
-- It offers profile management, smart defaults and namespaces for modules.\\
-- Data can be saved on a per-character, per-realm, per-class or per-faction basis.
-- @class file
-- @name AceDB-3.0
-- @release $Id: AceDB-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $

local MAJOR, MINOR = "AceDB-3.0", 27
local AceDB = LibStub:NewLibrary(MAJOR, MINOR)

if not AceDB then return end

-- Lua APIs
local type, pairs, next, error = type, pairs, next, error
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget
local _G = _G

-- WoW APIs
local UnitClass = UnitClass

-- DB Utilities
AceDB.db_registry = AceDB.db_registry or {}
AceDB.frame = AceDB.frame or CreateFrame("Frame")

local DBObjectLib = {}

-- Metatable to proxy onto a database table
local function initdb(parentdb, name, defaults, defaultProfile, olddb, globalname)
	local db = {}
	local tablename = name
	local sv = parentdb.sv
	
	-- Generate the DB table
	local profileKey
	if sv.profileKeys then
		profileKey = sv.profileKeys[parentdb.keys.profile]
	end
	
	if not profileKey or not sv.profiles or not sv.profiles[profileKey] then
		profileKey = defaultProfile or "Default"
		sv.profileKeys = sv.profileKeys or {}
		sv.profileKeys[parentdb.keys.profile] = profileKey
	end
	
	sv.profiles = sv.profiles or {}
	sv.profiles[profileKey] = sv.profiles[profileKey] or {}
	
	db.profile = sv.profiles[profileKey]
	db.global = sv.global or {}
	sv.global = db.global
	
	db.char = sv.char or {}
	sv.char = db.char
	db.realm = sv.realm or {}
	sv.realm = db.realm
	db.class = sv.class or {}
	sv.class = db.class
	db.race = sv.race or {}
	sv.race = db.race
	db.faction = sv.faction or {}
	sv.faction = db.faction
	db.factionrealm = sv.factionrealm or {}
	sv.factionrealm = db.factionrealm
	db.locale = sv.locale or {}
	sv.locale = db.locale
	
	-- Copy methods
	db.RegisterCallback = parentdb.RegisterCallback
	db.UnregisterCallback = parentdb.UnregisterCallback
	db.UnregisterAllCallbacks = parentdb.UnregisterAllCallbacks
	db.RegisterDefaults = parentdb.RegisterDefaults
	db.ResetProfile = parentdb.ResetProfile
	db.ResetDB = parentdb.ResetDB
	
	db.keys = parentdb.keys
	db.sv = sv
	db.defaults = defaults
	db.parent = parentdb
	
	-- Return the initialized DB
	return db
end

--- Create a new database object.
-- @param tbl The name of the savedvariable table or a table to use instead
-- @param defaults A table of database defaults
-- @param defaultProfile The name of the default profile (defaults to "Default")
function AceDB:New(tbl, defaults, defaultProfile)
	if type(tbl) == "string" then
		local name = tbl
		tbl = _G[name]
		if not tbl then
			tbl = {}
			_G[name] = tbl
		end
	end
	
	if type(tbl) ~= "table" then
		error("Usage: AceDB:New(tbl, defaults, defaultProfile): tbl must be a table or string", 2)
	end
	
	-- Generate the profile key
	local playerName = UnitName("player")
	local realmName = GetRealmName()
	local className = select(2, UnitClass("player"))
	local race = select(2, UnitRace("player"))
	local faction = UnitFactionGroup("player")
	
	local profileKey = playerName .. " - " .. realmName
	local charKey = profileKey
	local realmKey = realmName
	local classKey = className
	local raceKey = race
	local factionKey = faction
	local factionrealmKey = faction .. " - " .. realmName
	local localeKey = GetLocale()
	
	-- Create DB object
	local db = {}
	db.sv = tbl
	db.keys = {
		profile = profileKey,
		char = charKey,
		realm = realmKey,
		class = classKey,
		race = raceKey,
		faction = factionKey,
		factionrealm = factionrealmKey,
		locale = localeKey,
	}
	db.callbacks = LibStub("CallbackHandler-1.0"):New(db)
	
	-- Initialize
	local newdb = initdb(db, "db", defaults, defaultProfile)
	
	-- Embed methods from DBObjectLib
	for name, func in pairs(DBObjectLib) do
		newdb[name] = func
	end
	
	-- Apply defaults
	if defaults then
		newdb:RegisterDefaults(defaults)
	end
	
	AceDB.db_registry[newdb] = true
	return newdb
end

--- Register your database defaults.
-- @param defaults A table of database defaults
function DBObjectLib:RegisterDefaults(defaults)
	if defaults then
		self.defaults = defaults
		-- Apply defaults to profile
		if defaults.profile then
			for k, v in pairs(defaults.profile) do
				if self.profile[k] == nil then
					self.profile[k] = v
				end
			end
		end
		-- Apply defaults to global
		if defaults.global then
			for k, v in pairs(defaults.global) do
				if self.global[k] == nil then
					self.global[k] = v
				end
			end
		end
	end
end

--- Reset the current profile to the default values (if specified).
function DBObjectLib:ResetProfile()
	local profile = self.profile
	for k in pairs(profile) do
		profile[k] = nil
	end
	-- Reapply defaults
	if self.defaults and self.defaults.profile then
		for k, v in pairs(self.defaults.profile) do
			profile[k] = v
		end
	end
	if self.callbacks then
		self.callbacks:Fire("OnProfileReset")
		self.callbacks:Fire("OnDatabaseReset")
	end
end

--- Reset the entire database, using the string defaultProfile as the new default profile.
-- @param defaultProfile The profile name to use as the default
function DBObjectLib:ResetDB(defaultProfile)
	local sv = self.sv
	-- Clear everything
	for k in pairs(sv) do
		sv[k] = nil
	end
	
	local playerName = UnitName("player")
	local realmName = GetRealmName()
	local profileKey = defaultProfile or (playerName .. " - " .. realmName)
	
	sv.profileKeys = {}
	sv.profileKeys[self.keys.profile] = profileKey
	sv.profiles = {}
	sv.profiles[profileKey] = {}
	
	-- Reinit
	self.profile = sv.profiles[profileKey]
	self.global = {}
	sv.global = self.global
	self.char = {}
	sv.char = self.char
	self.realm = {}
	sv.realm = self.realm
	self.class = {}
	sv.class = self.class
	self.race = {}
	sv.race = self.race
	self.faction = {}
	sv.faction = self.faction
	self.factionrealm = {}
	sv.factionrealm = self.factionrealm
	self.locale = {}
	sv.locale = self.locale
	
	-- Reapply defaults
	if self.defaults then
		self:RegisterDefaults(self.defaults)
	end
	
	if self.callbacks then
		self.callbacks:Fire("OnDatabaseReset")
	end
end

--- Get the name of the current profile.
function DBObjectLib:GetCurrentProfile()
	return self.sv.profileKeys[self.keys.profile]
end

--- Set the current profile.
-- @param name The name of the profile to set
function DBObjectLib:SetProfile(name)
	if type(name) ~= "string" then
		error("Usage: db:SetProfile(name): name must be a string", 2)
	end
	
	local sv = self.sv
	local oldProfile = sv.profileKeys[self.keys.profile]
	
	-- Create new profile if it doesn't exist
	sv.profiles = sv.profiles or {}
	sv.profiles[name] = sv.profiles[name] or {}
	
	-- Change profile
	sv.profileKeys[self.keys.profile] = name
	self.profile = sv.profiles[name]
	
	-- Reapply defaults
	if self.defaults and self.defaults.profile then
		for k, v in pairs(self.defaults.profile) do
			if self.profile[k] == nil then
				self.profile[k] = v
			end
		end
	end
	
	if self.callbacks then
		self.callbacks:Fire("OnProfileChanged", name, oldProfile)
	end
end

--- Get a list of available profiles.
function DBObjectLib:GetProfiles()
	local profiles = {}
	if self.sv.profiles then
		for name in pairs(self.sv.profiles) do
			profiles[name] = true
		end
	end
	return profiles
end

--- Delete a profile.
-- @param name The name of the profile to delete
-- @param silent If true, do not raise an error if the profile does not exist
function DBObjectLib:DeleteProfile(name, silent)
	if type(name) ~= "string" then
		error("Usage: db:DeleteProfile(name): name must be a string", 2)
	end
	
	if self.sv.profileKeys[self.keys.profile] == name then
		error("Cannot delete the currently active profile", 2)
	end
	
	if not self.sv.profiles[name] and not silent then
		error("Profile does not exist", 2)
	end
	
	self.sv.profiles[name] = nil
	
	if self.callbacks then
		self.callbacks:Fire("OnProfileDeleted", name)
	end
end

--- Copy a profile.
-- @param name The name of the profile to copy
-- @param silent If true, do not raise an error if the profile does not exist
function DBObjectLib:CopyProfile(name, silent)
	if type(name) ~= "string" then
		error("Usage: db:CopyProfile(name): name must be a string", 2)
	end
	
	if not self.sv.profiles[name] and not silent then
		error("Profile does not exist", 2)
	end
	
	local source = self.sv.profiles[name]
	local dest = self.profile
	
	-- Clear current profile
	for k in pairs(dest) do
		dest[k] = nil
	end
	
	-- Deep copy
	local function copy(src, dst)
		for k, v in pairs(src) do
			if type(v) == "table" then
				dst[k] = {}
				copy(v, dst[k])
			else
				dst[k] = v
			end
		end
	end
	
	copy(source, dest)
	
	if self.callbacks then
		self.callbacks:Fire("OnProfileCopied", name)
	end
end
