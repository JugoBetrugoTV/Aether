--[[
	Aether - Constants
	
	This file contains all constant values used throughout the addon
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create constants table
Aether.Constants = {}
local C = Aether.Constants

-- Addon Info
C.ADDON_NAME = ADDON_NAME
C.ADDON_VERSION = "1.0.0"
C.ADDON_AUTHOR = "JugoBetrugoTV"

-- Colors (RGB format 0-1)
C.COLORS = {
	-- Theme colors
	AETHER_BLUE = {r = 0, g = 0.8078, b = 0.8196},  -- #00CED1
	DARK_BLUE = {r = 0, g = 0.4, b = 0.6},
	LIGHT_BLUE = {r = 0.3, g = 0.9, b = 1},
	
	-- Classic WoW colors
	GOLD = {r = 1, g = 0.82, b = 0},
	COPPER = {r = 0.75, g = 0.5, b = 0.25},
	
	-- Status colors
	GREEN = {r = 0, g = 1, b = 0},
	YELLOW = {r = 1, g = 1, b = 0},
	ORANGE = {r = 1, g = 0.5, b = 0},
	RED = {r = 1, g = 0, b = 0},
	WHITE = {r = 1, g = 1, b = 1},
	GRAY = {r = 0.5, g = 0.5, b = 0.5},
	BLACK = {r = 0, g = 0, b = 0},
	
	-- Midnight theme
	MIDNIGHT_PURPLE = {r = 0.5, g = 0, b = 0.5},
	DARK_PURPLE = {r = 0.3, g = 0, b = 0.3},
}

-- Class colors (from Blizzard)
C.CLASS_COLORS = {}
if RAID_CLASS_COLORS then
	for class, color in pairs(RAID_CLASS_COLORS) do
		C.CLASS_COLORS[class] = {r = color.r, g = color.g, b = color.b}
	end
end

-- Color hex codes
C.COLOR_CODES = {
	AETHER = "|cff00CED1",
	GOLD = "|cffFFD700",
	GREEN = "|cff00FF00",
	RED = "|cffFF0000",
	YELLOW = "|cffFFFF00",
	ORANGE = "|cffFF8000",
	WHITE = "|cffFFFFFF",
	GRAY = "|cff808080",
	CLOSE = "|r",
}

-- Panel constants
C.PANEL = {
	MIN_HEIGHT = 16,
	MAX_HEIGHT = 48,
	DEFAULT_HEIGHT = 24,
	MIN_OPACITY = 0,
	MAX_OPACITY = 1,
	DEFAULT_OPACITY = 0.8,
	MAX_SHORT_BARS = 10,
}

-- Plugin constants
C.PLUGIN = {
	UPDATE_INTERVAL = 1,  -- seconds
	TOOLTIP_UPDATE_INTERVAL = 0.5,  -- seconds
}

-- Chat constants
C.CHAT = {
	DEFAULT_HISTORY = 128,
	EXTENDED_HISTORY = 2048,
	MAX_FONT_SIZE = 32,
	MIN_FONT_SIZE = 8,
}

-- Minimap constants
C.MINIMAP = {
	MIN_SCALE = 0.5,
	MAX_SCALE = 2.0,
	DEFAULT_SCALE = 1.0,
	DEFAULT_SIZE = 140,
}

-- Camera constants
C.CAMERA = {
	DEFAULT_MAX_ZOOM = 2.6,
	EXTENDED_MAX_ZOOM = 3.5,
	MAX_EXTENDED_ZOOM = 10.0,
}

-- Automation constants
C.AUTOMATION = {
	LOOT_DELAY = 0.3,  -- seconds
	QUEST_DELAY = 0.1,  -- seconds
	REPAIR_THRESHOLD = 0.8,  -- 80% durability
}

-- Item quality colors
C.ITEM_QUALITY_COLORS = {
	[0] = {r = 0.61, g = 0.61, b = 0.61},  -- Poor (Gray)
	[1] = {r = 1, g = 1, b = 1},           -- Common (White)
	[2] = {r = 0.12, g = 1, b = 0},        -- Uncommon (Green)
	[3] = {r = 0, g = 0.44, b = 0.87},     -- Rare (Blue)
	[4] = {r = 0.64, g = 0.21, b = 0.93},  -- Epic (Purple)
	[5] = {r = 1, g = 0.5, b = 0},         -- Legendary (Orange)
	[6] = {r = 0.9, g = 0.8, b = 0.5},     -- Artifact (Light Yellow)
	[7] = {r = 0, g = 0.8, b = 1},         -- Heirloom (Light Blue)
}

-- Junk item subtypes for auto-sell
C.JUNK_SUBTYPES = {
	-- Add common junk item subtypes
}

-- Module names
C.MODULES = {
	PANEL = "Panel",
	AUTOMATION = "Automation",
	SOCIAL = "Social",
	CHAT = "Chat",
	TOOLTIP = "Tooltip",
	MINIMAP = "Minimap",
	FRAMES = "Frames",
	SYSTEM = "System",
	MEDIA = "Media",
	INTERFACE = "Interface",
}

-- Plugin names
C.PLUGINS = {
	BAG = "Bag",
	CLOCK = "Clock",
	GOLD = "Gold",
	LOCATION = "Location",
	LOOT_TYPE = "LootType",
	PERFORMANCE = "Performance",
	REPAIR = "Repair",
	VOLUME = "Volume",
	XP = "XP",
	ITEM_LEVEL = "ItemLevel",
	SPEED = "Speed",
	CURRENCY = "Currency",
}

-- Slash commands
C.SLASH_COMMANDS = {
	"/aether",
	"/ae",
}

-- Help text
C.HELP_TEXT = [[
|cff00CED1Aether|r - All-in-One WoW Addon

Commands:
  /aether or /ae - Open main options
  /aether panel - Toggle panel
  /aether config - Open configuration
  /aether reset - Reset to defaults
  /aether profile <name> - Switch profile
  /aether debug - Toggle debug mode
  /aether help - Show this help

For more information, visit: https://github.com/JugoBetrugoTV/Aether
]]

-- Frame strata levels
C.FRAME_STRATA = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	FULLSCREEN = "FULLSCREEN",
	FULLSCREEN_DIALOG = "FULLSCREEN_DIALOG",
	TOOLTIP = "TOOLTIP",
}

-- API version detection
C.IS_RETAIL = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
C.IS_CLASSIC = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
C.IS_TBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
C.IS_WRATH = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
C.IS_CATA = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)

-- Get current expansion info
local expansionLevel = GetExpansionLevel and GetExpansionLevel() or 0
C.EXPANSION_LEVEL = expansionLevel
C.IS_WAR_WITHIN = (expansionLevel >= 10)  -- The War Within is expansion 10
C.IS_MIDNIGHT = (expansionLevel >= 11)     -- Midnight is expansion 11

-- Locale
C.LOCALE = GetLocale()

-- Export constants
Aether.C = C
