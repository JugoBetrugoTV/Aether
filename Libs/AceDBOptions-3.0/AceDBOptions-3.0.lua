--- AceDBOptions-3.0 provides a universal AceConfig options screen for managing AceDB-3.0 profiles.
-- @class file
-- @name AceDBOptions-3.0
-- @release $Id: AceDBOptions-3.0.lua 1298 2022-12-06 20:23:11Z nevcairiel $
local MAJOR, MINOR = "AceDBOptions-3.0", 15
local AceDBOptions = LibStub:NewLibrary(MAJOR, MINOR)

if not AceDBOptions then return end

local AceConfigRegistry

--- Get the option table for the given database.
-- @param db The database to get options for
-- @return An option table suitable for AceConfig
function AceDBOptions:GetOptionsTable(db)
	if not db or not db.RegisterDefaults then
		error("Usage: GetOptionsTable(db): db must be an AceDB database", 2)
	end
	
	local options = {
		type = "group",
		name = "Profiles",
		desc = "Manage profiles for this addon",
		args = {
			desc = {
				type = "description",
				name = "You can change the active profile, create new profiles, or delete existing profiles.",
				order = 0,
			},
			current = {
				type = "select",
				name = "Current Profile",
				desc = "Select the active profile",
				get = function() return db:GetCurrentProfile() end,
				set = function(info, value) db:SetProfile(value) end,
				values = function()
					local profiles = {}
					for name in pairs(db:GetProfiles()) do
						profiles[name] = name
					end
					return profiles
				end,
				order = 1,
			},
			new = {
				type = "input",
				name = "New Profile",
				desc = "Create a new profile",
				set = function(info, value)
					if value and value ~= "" then
						db:SetProfile(value)
					end
				end,
				order = 2,
			},
			choose = {
				type = "select",
				name = "Copy From",
				desc = "Copy settings from another profile",
				get = function() return "" end,
				set = function(info, value)
					if value and value ~= "" then
						db:CopyProfile(value, true)
					end
				end,
				values = function()
					local profiles = {}
					for name in pairs(db:GetProfiles()) do
						if name ~= db:GetCurrentProfile() then
							profiles[name] = name
						end
					end
					return profiles
				end,
				order = 3,
			},
			delete = {
				type = "select",
				name = "Delete Profile",
				desc = "Delete a profile",
				get = function() return "" end,
				set = function(info, value)
					if value and value ~= "" and value ~= db:GetCurrentProfile() then
						db:DeleteProfile(value, true)
					end
				end,
				values = function()
					local profiles = {}
					for name in pairs(db:GetProfiles()) do
						if name ~= db:GetCurrentProfile() then
							profiles[name] = name
						end
					end
					return profiles
				end,
				order = 4,
				confirm = true,
				confirmText = "Are you sure you want to delete this profile?",
			},
			reset = {
				type = "execute",
				name = "Reset Profile",
				desc = "Reset the current profile to default values",
				func = function() db:ResetProfile() end,
				order = 5,
				confirm = true,
				confirmText = "Are you sure you want to reset the current profile?",
			},
		},
	}
	
	return options
end
