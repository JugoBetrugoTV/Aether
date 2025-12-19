-- Aether: Init.lua
-- Main initialization file for the Aether addon

-- Create the addon
Aether = LibStub("AceAddon-3.0"):NewAddon("Aether", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

-- Addon version
Aether.version = "1.0.0"
Aether.buildDate = "2025-01-01"

-- Module registry
Aether.modules = {}

function Aether:OnInitialize()
	-- Initialize the database
	self.db = LibStub("AceDB-3.0"):New("AetherDB", self:GetDefaults(), true)
	self.charDB = LibStub("AceDB-3.0"):New("AetherCharDB", self:GetCharDefaults(), true)
	
	-- Register slash commands
	self:RegisterChatCommand("aether", "SlashCommand")
	self:RegisterChatCommand("ae", "SlashCommand")
	
	-- Print welcome message
	self:Print(L["Addon loaded successfully"])
	self:Print(L["Type /aether for options"])
end

function Aether:OnEnable()
	-- Enable all modules
	self:InitializeModules()
	
	-- Register events
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
	self:RegisterEvent("PLAYER_LOGOUT", "OnPlayerLogout")
end

function Aether:OnDisable()
	-- Cleanup
end

function Aether:OnPlayerEnteringWorld()
	-- Called when player enters world
	self:RefreshAllModules()
end

function Aether:OnPlayerLogout()
	-- Save any unsaved data
end

function Aether:GetDefaults()
	return {
		profile = {
			-- Panel settings
			panel = {
				enabled = true,
				topBar1 = { enabled = true, height = 24, alpha = 0.8 },
				topBar2 = { enabled = false, height = 24, alpha = 0.8 },
				bottomBar1 = { enabled = true, height = 24, alpha = 0.8 },
				bottomBar2 = { enabled = false, height = 24, alpha = 0.8 },
				autoHide = false,
			},
			-- Plugin settings
			plugins = {
				bag = { enabled = true, showFree = true },
				clock = { enabled = true, use24Hour = true, serverTime = false },
				gold = { enabled = true, perCharacter = true },
				location = { enabled = true, showCoords = true },
				performance = { enabled = true, showFPS = true, showLatency = true },
				repair = { enabled = true },
				volume = { enabled = true },
				xp = { enabled = true, showRested = true },
			},
			-- Automation settings
			automation = {
				autoAcceptQuests = false,
				autoTurnInQuests = false,
				autoRepair = false,
				useGuildBank = false,
				autoSellJunk = false,
				fasterAutoLoot = false,
				autoAcceptSummon = false,
				autoAcceptResurrect = false,
			},
			-- Social settings
			social = {
				blockDuels = false,
				blockPetDuels = false,
				blockPartyInvites = false,
				blockFriendRequests = false,
				autoAcceptFriends = true,
				autoAcceptGuild = true,
			},
			-- Chat settings
			chat = {
				hideCombatLog = false,
				hideChatButtons = false,
				moveEditBoxToTop = false,
				classColorsInChat = true,
				disableChatFade = false,
				arrowKeysInChat = false,
				increaseChatHistory = false,
				chatHistoryLines = 128,
			},
			-- Tooltip settings
			tooltip = {
				showItemLevel = true,
				showItemID = false,
				showSpellID = false,
				showSpec = true,
				showClassColors = true,
				showGuildRank = true,
				showTargetOfTarget = true,
			},
			-- Minimap settings
			minimap = {
				squareMinimap = false,
				hideMinimapButton = false,
				buttonPosition = 225,
				showCoordinates = false,
			},
			-- Frame settings
			frames = {
				hideGryphons = false,
				hideAlertFrames = false,
				hideTalkingHead = false,
				classColoredFrames = false,
			},
			-- System settings
			system = {
				maxCameraZoom = false,
				muteGameSounds = false,
				easyItemDestroy = false,
				fasterMovieSkip = false,
			},
		},
	}
end

function Aether:GetCharDefaults()
	return {
		char = {
			gold = 0,
			lastPlayed = time(),
		},
	}
end

function Aether:InitializeModules()
	-- Initialize Panel module
	if self.modules.Panel then
		self.modules.Panel:Initialize()
	end
	
	-- Initialize other modules
	for name, module in pairs(self.modules) do
		if module.Initialize and name ~= "Panel" then
			module:Initialize()
		end
	end
end

function Aether:RefreshAllModules()
	for name, module in pairs(self.modules) do
		if module.Refresh then
			module:Refresh()
		end
	end
end

function Aether:RegisterModule(name, module)
	self.modules[name] = module
end

function Aether:GetModule(name)
	return self.modules[name]
end

function Aether:SlashCommand(input)
	input = strtrim(input or "")
	
	if input == "" or input == "options" or input == "config" then
		self:OpenConfig()
	elseif input == "panel" then
		self:TogglePanel()
	elseif input == "reset" then
		self:ResetSettings()
	else
		self:Print(L["Available commands:"])
		self:Print(L["/aether - Show options"])
		self:Print(L["/aether panel - Toggle panel"])
		self:Print(L["/aether reset - Reset all settings"])
	end
end

function Aether:OpenConfig()
	-- Open the config dialog
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")
	if AceConfigDialog then
		AceConfigDialog:Open("Aether")
	end
end

function Aether:TogglePanel()
	local panel = self:GetModule("Panel")
	if panel then
		panel:Toggle()
	end
end

function Aether:ResetSettings()
	self.db:ResetDB()
	self:Print("All settings have been reset to defaults.")
	ReloadUI()
end
