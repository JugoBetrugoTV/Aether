--[[
	Aether - Profile Management
	
	This file handles profile creation, switching, and management
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create profiles table
Aether.Profiles = {}
local P = Aether.Profiles

-- Current profile name
P.currentProfile = nil

--[[
	Initialize profile system
]]--
function P:Initialize()
	Aether:Debug("Initializing profile system...")
	
	-- Ensure profiles table exists
	if not Aether.db.profiles then
		Aether.db.profiles = {}
	end
	
	-- Get or create default profile
	local playerName = Aether.U.GetFullPlayerName()
	
	if not Aether.db.profiles[playerName] then
		self:CreateProfile(playerName)
	end
	
	-- Load current profile
	self:LoadProfile(playerName)
end

--[[
	Create a new profile
]]--
function P:CreateProfile(name)
	if not name or name == "" then
		Aether:Error("Profile name cannot be empty")
		return false
	end
	
	if Aether.db.profiles[name] then
		Aether:Debug("Profile already exists:", name)
		return false
	end
	
	-- Create profile with default settings
	Aether.db.profiles[name] = Aether.U.DeepCopy(Aether.db.profile or {})
	
	Aether:Debug("Created profile:", name)
	return true
end

--[[
	Delete a profile
]]--
function P:DeleteProfile(name)
	if not name or name == "" then
		Aether:Error("Profile name cannot be empty")
		return false
	end
	
	if not Aether.db.profiles[name] then
		Aether:Error("Profile does not exist:", name)
		return false
	end
	
	if name == self.currentProfile then
		Aether:Error("Cannot delete the currently active profile")
		return false
	end
	
	Aether.db.profiles[name] = nil
	Aether:Debug("Deleted profile:", name)
	return true
end

--[[
	Load a profile
]]--
function P:LoadProfile(name)
	if not name or name == "" then
		Aether:Error("Profile name cannot be empty")
		return false
	end
	
	if not Aether.db.profiles[name] then
		Aether:Error("Profile does not exist:", name)
		return false
	end
	
	-- Save current profile if exists
	if self.currentProfile and Aether.db.profile then
		Aether.db.profiles[self.currentProfile] = Aether.U.DeepCopy(Aether.db.profile)
	end
	
	-- Load new profile
	Aether.db.profile = Aether.U.DeepCopy(Aether.db.profiles[name])
	self.currentProfile = name
	
	-- Reload all modules with new settings
	self:ReloadModules()
	
	Aether:Print("Loaded profile:", name)
	return true
end

--[[
	Copy a profile
]]--
function P:CopyProfile(sourceName, targetName)
	if not sourceName or sourceName == "" or not targetName or targetName == "" then
		Aether:Error("Profile names cannot be empty")
		return false
	end
	
	if not Aether.db.profiles[sourceName] then
		Aether:Error("Source profile does not exist:", sourceName)
		return false
	end
	
	if Aether.db.profiles[targetName] then
		Aether:Error("Target profile already exists:", targetName)
		return false
	end
	
	Aether.db.profiles[targetName] = Aether.U.DeepCopy(Aether.db.profiles[sourceName])
	
	Aether:Debug("Copied profile:", sourceName, "to", targetName)
	return true
end

--[[
	Rename a profile
]]--
function P:RenameProfile(oldName, newName)
	if not oldName or oldName == "" or not newName or newName == "" then
		Aether:Error("Profile names cannot be empty")
		return false
	end
	
	if not Aether.db.profiles[oldName] then
		Aether:Error("Profile does not exist:", oldName)
		return false
	end
	
	if Aether.db.profiles[newName] then
		Aether:Error("A profile with that name already exists:", newName)
		return false
	end
	
	-- Copy profile to new name
	Aether.db.profiles[newName] = Aether.db.profiles[oldName]
	Aether.db.profiles[oldName] = nil
	
	-- Update current profile name if needed
	if self.currentProfile == oldName then
		self.currentProfile = newName
	end
	
	Aether:Debug("Renamed profile:", oldName, "to", newName)
	return true
end

--[[
	Get list of all profiles
]]--
function P:GetProfileList()
	local profiles = {}
	
	for name, _ in pairs(Aether.db.profiles) do
		table.insert(profiles, name)
	end
	
	table.sort(profiles)
	return profiles
end

--[[
	Get current profile name
]]--
function P:GetCurrentProfile()
	return self.currentProfile
end

--[[
	Export profile to string
]]--
function P:ExportProfile(name)
	if not name or name == "" then
		name = self.currentProfile
	end
	
	if not Aether.db.profiles[name] then
		Aether:Error("Profile does not exist:", name)
		return nil
	end
	
	local profileData = Aether.db.profiles[name]
	local serialized = self:SerializeTable(profileData)
	local encoded = self:EncodeString(serialized)
	
	return encoded
end

--[[
	Import profile from string
]]--
function P:ImportProfile(encodedString, name)
	if not encodedString or encodedString == "" then
		Aether:Error("Import string cannot be empty")
		return false
	end
	
	if not name or name == "" then
		name = "Imported-" .. date("%Y%m%d-%H%M%S")
	end
	
	local decoded = self:DecodeString(encodedString)
	if not decoded then
		Aether:Error("Failed to decode import string")
		return false
	end
	
	local profileData = self:DeserializeTable(decoded)
	if not profileData then
		Aether:Error("Failed to deserialize import string")
		return false
	end
	
	Aether.db.profiles[name] = profileData
	Aether:Print("Imported profile:", name)
	return true
end

--[[
	Reset profile to defaults
]]--
function P:ResetProfile(name)
	if not name or name == "" then
		name = self.currentProfile
	end
	
	if not Aether.db.profiles[name] then
		Aether:Error("Profile does not exist:", name)
		return false
	end
	
	-- Clear profile
	Aether.db.profiles[name] = {}
	
	-- If it's the current profile, reload
	if name == self.currentProfile then
		Aether.db.profile = {}
		Aether:ApplyDefaults()
		self:ReloadModules()
	end
	
	Aether:Print("Reset profile:", name)
	return true
end

--[[
	Reload all modules
]]--
function P:ReloadModules()
	Aether:Debug("Reloading all modules...")
	
	for name, module in pairs(Aether.modules) do
		if module.Reload then
			local success, err = pcall(module.Reload, module)
			if not success then
				Aether:Error("Failed to reload module '" .. name .. "':", err)
			end
		elseif module.Initialize then
			local success, err = pcall(module.Initialize, module)
			if not success then
				Aether:Error("Failed to initialize module '" .. name .. "':", err)
			end
		end
	end
end

--[[
	Simple table serialization (for export/import)
]]--
function P:SerializeTable(tbl)
	local function serialize(t, depth)
		depth = depth or 0
		if depth > 10 then return "nil" end  -- Prevent infinite recursion
		
		local result = "{"
		local first = true
		
		for k, v in pairs(t) do
			if not first then result = result .. "," end
			first = false
			
			-- Serialize key
			if type(k) == "number" then
				result = result .. "[" .. k .. "]="
			else
				result = result .. "[" .. string.format("%q", tostring(k)) .. "]="
			end
			
			-- Serialize value
			if type(v) == "table" then
				result = result .. serialize(v, depth + 1)
			elseif type(v) == "string" then
				result = result .. string.format("%q", v)
			elseif type(v) == "boolean" or type(v) == "number" then
				result = result .. tostring(v)
			else
				result = result .. "nil"
			end
		end
		
		result = result .. "}"
		return result
	end
	
	return serialize(tbl)
end

--[[
	Simple table deserialization (for export/import)
]]--
function P:DeserializeTable(str)
	if not str or str == "" then return nil end
	
	local func, err = loadstring("return " .. str)
	if not func then
		Aether:Error("Failed to deserialize:", err)
		return nil
	end
	
	local success, result = pcall(func)
	if not success then
		Aether:Error("Failed to execute deserialization:", result)
		return nil
	end
	
	return result
end

--[[
	Simple base64-like encoding
]]--
function P:EncodeString(str)
	-- Simple encoding (in production, use proper base64)
	return str:gsub(".", function(c)
		return string.format("%02X", string.byte(c))
	end)
end

--[[
	Simple base64-like decoding
]]--
function P:DecodeString(str)
	-- Simple decoding (in production, use proper base64)
	return str:gsub("..", function(hex)
		return string.char(tonumber(hex, 16))
	end)
end
