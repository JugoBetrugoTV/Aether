--[[
	Aether - Theme Management
	
	Manages visual themes and color schemes
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Theme management
Aether.Themes = {}
local Themes = Aether.Themes

-- Available themes
Themes.list = {
	["aether_blue"] = {
		name = "Aether Blue",
		colors = {
			primary = {r = 0, g = 0.8078, b = 0.8196},
			secondary = {r = 0, g = 0.4, b = 0.6},
			background = {r = 0, g = 0, b = 0, a = 0.8},
		}
	},
	["dark_mode"] = {
		name = "Dark Mode",
		colors = {
			primary = {r = 0.3, g = 0.3, b = 0.3},
			secondary = {r = 0.15, g = 0.15, b = 0.15},
			background = {r = 0.05, g = 0.05, b = 0.05, a = 0.9},
		}
	},
	["classic_gold"] = {
		name = "Classic Gold",
		colors = {
			primary = {r = 1, g = 0.82, b = 0},
			secondary = {r = 0.75, g = 0.5, b = 0.25},
			background = {r = 0.1, g = 0.05, b = 0, a = 0.8},
		}
	},
	["midnight_purple"] = {
		name = "Midnight Purple",
		colors = {
			primary = {r = 0.5, g = 0, b = 0.5},
			secondary = {r = 0.3, g = 0, b = 0.3},
			background = {r = 0.1, g = 0, b = 0.1, a = 0.8},
		}
	},
}

-- Current theme
Themes.current = "aether_blue"

--[[
	Get current theme
]]--
function Themes:GetCurrent()
	return self.list[self.current]
end

--[[
	Set theme
]]--
function Themes:SetTheme(themeName)
	if not self.list[themeName] then
		Aether:Error("Theme not found:", themeName)
		return false
	end
	
	self.current = themeName
	self:ApplyTheme()
	
	Aether:Print("Theme changed to:", self.list[themeName].name)
	return true
end

--[[
	Apply theme to UI elements
]]--
function Themes:ApplyTheme()
	local theme = self:GetCurrent()
	if not theme then return end
	
	-- Apply theme colors to panel bars
	if Aether.Panel and Aether.Panel.bars then
		for _, bar in pairs(Aether.Panel.bars) do
			if bar and bar.bg then
				local bg = theme.colors.background
				bar.bg:SetColorTexture(bg.r, bg.g, bg.b, bg.a or 0.8)
			end
		end
	end
	
	-- Additional theme application would go here
end
