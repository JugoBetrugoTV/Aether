--[[
	Aether - All-in-One WoW Addon
	Core Initialization
	
	This file initializes the Aether addon using AceAddon-3.0
]]--

-- Create the main addon object
-- For now, we'll use a simple structure that doesn't require Ace3
-- This allows the addon to load even without the full library suite
local ADDON_NAME = "Aether"
local ADDON_VERSION = "1.0.0"

-- Create global addon namespace
Aether = Aether or {}
local Aether = Aether

-- Store addon info
Aether.name = ADDON_NAME
Aether.version = ADDON_VERSION
Aether.loaded = false

-- Module storage
Aether.modules = {}
Aether.plugins = {}

-- Event frame
Aether.eventFrame = CreateFrame("Frame")

-- Saved variables (initialized on ADDON_LOADED)
Aether.db = nil
Aether.charDB = nil

-- Debug mode
Aether.debug = false

--[[
	Print function
]]--
function Aether:Print(...)
	local msg = string.join(" ", tostringall(...))
	print("|cff00CED1[Aether]|r " .. msg)
end

--[[
	Debug print function
]]--
function Aether:Debug(...)
	if self.debug then
		local msg = string.join(" ", tostringall(...))
		print("|cff808080[Aether Debug]|r " .. msg)
	end
end

--[[
	Error print function
]]--
function Aether:Error(...)
	local msg = string.join(" ", tostringall(...))
	print("|cffFF0000[Aether Error]|r " .. msg)
end

--[[
	Register a module
]]--
function Aether:RegisterModule(name, module)
	if self.modules[name] then
		self:Debug("Module already registered:", name)
		return false
	end
	
	self.modules[name] = module
	self:Debug("Registered module:", name)
	return true
end

--[[
	Get a module
]]--
function Aether:GetModule(name)
	return self.modules[name]
end

--[[
	Register a plugin
]]--
function Aether:RegisterPlugin(name, plugin)
	if self.plugins[name] then
		self:Debug("Plugin already registered:", name)
		return false
	end
	
	self.plugins[name] = plugin
	self:Debug("Registered plugin:", name)
	return true
end

--[[
	Get a plugin
]]--
function Aether:GetPlugin(name)
	return self.plugins[name]
end

--[[
	Initialize the addon
]]--
function Aether:Initialize()
	if self.loaded then
		return
	end
	
	self:Debug("Initializing Aether...")
	
	-- Initialize saved variables if they don't exist
	if not AetherDB then
		AetherDB = {}
	end
	
	if not AetherCharDB then
		AetherCharDB = {}
	end
	
	self.db = AetherDB
	self.charDB = AetherCharDB
	
	-- Apply default settings
	self:ApplyDefaults()
	
	-- Initialize modules
	self:InitializeModules()
	
	-- Mark as loaded
	self.loaded = true
	
	self:Print("v" .. self.version .. " loaded! Type |cff00CED1/aether|r or |cff00CED1/ae|r to open options.")
end

--[[
	Apply default settings
]]--
function Aether:ApplyDefaults()
	-- Set up default database structure
	if not self.db.profile then
		self.db.profile = {}
	end
	
	if not self.db.global then
		self.db.global = {
			version = self.version,
		}
	end
	
	if not self.charDB.settings then
		self.charDB.settings = {}
	end
	
	-- Module defaults (everything OFF by default, like Leatrix Plus)
	local defaults = {
		-- Panel settings
		panel = {
			enabled = false,
			topBar1 = true,
			topBar2 = false,
			bottomBar1 = false,
			bottomBar2 = false,
			autoHide = false,
			barHeight = 24,
			backgroundOpacity = 0.8,
		},
		
		-- Automation settings
		automation = {
			autoAcceptQuests = false,
			autoTurnInQuests = false,
			autoAcceptGossip = false,
			autoAcceptSummon = false,
			autoAcceptRes = false,
			autoReleaseInPvP = false,
			autoSellJunk = false,
			autoRepair = false,
			autoRepairGuildBank = false,
			fasterLoot = false,
			fasterMovieSkip = false,
		},
		
		-- Social settings
		social = {
			blockDuels = false,
			blockPetDuels = false,
			blockPartyInvites = false,
			blockFriendRequests = false,
			blockSharedQuests = false,
			autoAcceptPartyFromFriends = false,
			autoAcceptQuestSync = false,
			whisperInvites = false,
		},
		
		-- Chat settings
		chat = {
			hideCombatLog = false,
			hideChatButtons = false,
			unclampChatFrame = false,
			moveEditboxToTop = false,
			moreFontSizes = false,
			disableSticky = false,
			arrowKeysInChat = false,
			disableFade = false,
			classColors = false,
			increasedHistory = false,
		},
		
		-- Tooltip settings
		tooltip = {
			anchorToCursor = false,
			showItemLevel = false,
			showSpecRole = false,
			classColoredBorders = false,
			showHealthBar = false,
			showTargetOfTarget = false,
		},
		
		-- Minimap settings
		minimap = {
			squareMinimap = false,
			combineAddonButtons = false,
			hideBorder = false,
			scale = 1.0,
		},
		
		-- Frame settings
		frames = {
			classColoredFrames = false,
			hideAlertFrames = false,
			hideTalkingHead = false,
			hideEventToasts = false,
			hideBossBanner = false,
		},
		
		-- System settings
		system = {
			disableScreenGlow = false,
			disableScreenEffects = false,
			alterWeather = false,
			weatherDensity = 0.5,
			maxCameraZoom = 2.6,
			silenceEmotesWhileRested = false,
		},
	}
	
	-- Merge defaults with existing settings
	for category, settings in pairs(defaults) do
		if not self.db.profile[category] then
			self.db.profile[category] = {}
		end
		
		for setting, value in pairs(settings) do
			if self.db.profile[category][setting] == nil then
				self.db.profile[category][setting] = value
			end
		end
	end
end

--[[
	Initialize all modules
]]--
function Aether:InitializeModules()
	for name, module in pairs(self.modules) do
		if module.Initialize then
			local success, err = pcall(module.Initialize, module)
			if not success then
				self:Error("Failed to initialize module '" .. name .. "':", err)
			else
				self:Debug("Initialized module:", name)
			end
		end
	end
end

--[[
	Event handler
]]--
local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		if addonName == ADDON_NAME then
			Aether:Initialize()
		end
	elseif event == "PLAYER_LOGIN" then
		-- Post-login initialization
		if Aether.loaded then
			Aether:Debug("Player logged in")
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- World entry initialization
		if Aether.loaded then
			Aether:Debug("Player entering world")
		end
	end
end

-- Register events
Aether.eventFrame:RegisterEvent("ADDON_LOADED")
Aether.eventFrame:RegisterEvent("PLAYER_LOGIN")
Aether.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Aether.eventFrame:SetScript("OnEvent", OnEvent)

-- Export to global namespace
_G["Aether"] = Aether
