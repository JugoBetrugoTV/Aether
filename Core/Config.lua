-- Aether: Config.lua
-- Configuration UI setup

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

function Aether:SetupConfig()
	local options = {
		type = "group",
		name = "Aether",
		args = {
			general = {
				type = "group",
				name = L["Settings"],
				order = 1,
				args = {
					desc = {
						type = "description",
						name = L["All-in-One addon combining Leatrix Plus and Titan Panel features"],
						order = 0,
					},
					version = {
						type = "description",
						name = "Version: " .. self.version,
						order = 1,
					},
				},
			},
			panel = {
				type = "group",
				name = L["Panel"],
				order = 2,
				args = {
					enabled = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Show Panel"],
						get = function() return self.db.profile.panel.enabled end,
						set = function(_, value) self.db.profile.panel.enabled = value end,
						order = 1,
					},
				},
			},
			automation = {
				type = "group",
				name = L["Automation"],
				order = 3,
				args = {
					autoAcceptQuests = {
						type = "toggle",
						name = L["Auto Accept Quests"],
						desc = L["Automatically accept and turn in quests"],
						get = function() return self.db.profile.automation.autoAcceptQuests end,
						set = function(_, value) self.db.profile.automation.autoAcceptQuests = value end,
						order = 1,
					},
					autoRepair = {
						type = "toggle",
						name = L["Auto Repair"],
						desc = L["Automatically repair items"],
						get = function() return self.db.profile.automation.autoRepair end,
						set = function(_, value) self.db.profile.automation.autoRepair = value end,
						order = 2,
					},
				},
			},
			profiles = AceDBOptions:GetOptionsTable(self.db),
		},
	}
	
	AceConfig:RegisterOptionsTable("Aether", options)
	AceConfigDialog:AddToBlizOptions("Aether", "Aether")
	
	return options
end

-- Initialize config on addon load
Aether:SetupConfig()
