-- Aether: Constants.lua
-- Global constants and configuration values

Aether.Constants = {
	-- Addon info
	ADDON_NAME = "Aether",
	ADDON_VERSION = "1.0.0",
	ADDON_AUTHOR = "JugoBetrugoTV",
	
	-- Colors
	COLOR = {
		RED = "|cffff0000",
		GREEN = "|cff00ff00",
		BLUE = "|cff0000ff",
		YELLOW = "|cffffff00",
		ORANGE = "|cffff8000",
		PURPLE = "|cff8000ff",
		WHITE = "|cffffffff",
		GRAY = "|cff808080",
		END = "|r",
	},
	
	-- Class colors
	CLASS_COLORS = {
		WARRIOR = "|cffc79c6e",
		PALADIN = "|cfff58cba",
		HUNTER = "|cffabd473",
		ROGUE = "|cfffff569",
		PRIEST = "|cffffffff",
		DEATHKNIGHT = "|cffc41f3b",
		SHAMAN = "|cff0070de",
		MAGE = "|cff40c7eb",
		WARLOCK = "|cff8787ed",
		MONK = "|cff00ff96",
		DRUID = "|cffff7d0a",
		DEMONHUNTER = "|cffa330c9",
		EVOKER = "|cff33937f",
	},
	
	-- Panel constants
	PANEL = {
		MIN_HEIGHT = 16,
		MAX_HEIGHT = 48,
		DEFAULT_HEIGHT = 24,
		MIN_WIDTH = 100,
		MAX_WIDTH = 2000,
		DEFAULT_ALPHA = 0.8,
		BUTTON_SIZE = 20,
		BUTTON_PADDING = 4,
	},
	
	-- Plugin constants
	PLUGIN = {
		UPDATE_INTERVAL = 1, -- seconds
		FAST_UPDATE_INTERVAL = 0.1, -- seconds
	},
	
	-- Tooltip constants
	TOOLTIP = {
		ANCHOR_CURSOR = "ANCHOR_CURSOR",
		ANCHOR_TOP = "ANCHOR_TOP",
		ANCHOR_BOTTOM = "ANCHOR_BOTTOM",
		ANCHOR_LEFT = "ANCHOR_LEFT",
		ANCHOR_RIGHT = "ANCHOR_RIGHT",
	},
	
	-- Chat constants
	CHAT = {
		MAX_HISTORY_LINES = 1024,
		DEFAULT_HISTORY_LINES = 128,
		MIN_HISTORY_LINES = 32,
	},
	
	-- Camera constants
	CAMERA = {
		DEFAULT_MAX_ZOOM = 15,
		EXTENDED_MAX_ZOOM = 39,
	},
	
	-- Quality colors
	QUALITY_COLORS = {
		[0] = "|cff9d9d9d", -- Poor (Gray)
		[1] = "|cffffffff", -- Common (White)
		[2] = "|cff1eff00", -- Uncommon (Green)
		[3] = "|cff0070dd", -- Rare (Blue)
		[4] = "|cffa335ee", -- Epic (Purple)
		[5] = "|cffff8000", -- Legendary (Orange)
		[6] = "|cffe6cc80", -- Artifact (Gold)
		[7] = "|cff00ccff", -- Heirloom (Light Blue)
	},
	
	-- Money constants
	GOLD_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t",
	SILVER_ICON = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t",
	COPPER_ICON = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t",
	
	-- Texture paths
	TEXTURES = {
		LOGO = "Interface\\AddOns\\Aether\\Media\\Textures\\aether-icon",
		PANEL_BG = "Interface\\DialogFrame\\UI-DialogBox-Background",
		BUTTON_NORMAL = "Interface\\Buttons\\UI-Panel-Button-Up",
		BUTTON_PUSHED = "Interface\\Buttons\\UI-Panel-Button-Down",
		BUTTON_HIGHLIGHT = "Interface\\Buttons\\UI-Panel-Button-Highlight",
	},
	
	-- Sound paths
	SOUNDS = {
		CLICK = SOUNDKIT.U_CHAT_SCROLL_BUTTON,
		ERROR = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF,
		SUCCESS = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON,
	},
	
	-- Event priority
	EVENT_PRIORITY = {
		HIGHEST = 1,
		HIGH = 2,
		NORMAL = 3,
		LOW = 4,
		LOWEST = 5,
	},
}

-- Convenience access
local C = Aether.Constants
Aether.C = C

-- Helper function to get class color
function Aether:GetClassColor(class)
	return self.Constants.CLASS_COLORS[class] or self.Constants.COLOR.WHITE
end

-- Helper function to get quality color
function Aether:GetQualityColor(quality)
	return self.Constants.QUALITY_COLORS[quality] or self.Constants.COLOR.WHITE
end

-- Helper function to format money
function Aether:FormatMoney(copper)
	local gold = floor(copper / 10000)
	local silver = floor((copper % 10000) / 100)
	copper = copper % 100
	
	local str = ""
	if gold > 0 then
		str = str .. gold .. self.Constants.GOLD_ICON .. " "
	end
	if silver > 0 or gold > 0 then
		str = str .. silver .. self.Constants.SILVER_ICON .. " "
	end
	str = str .. copper .. self.Constants.COPPER_ICON
	
	return str
end
