--[[
	Aether - Panel System
	
	Main panel system for Titan Panel-like functionality
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create module
local Panel = {}
Panel.name = "Panel"
Panel.initialized = false
Panel.bars = {}

--[[
	Initialize the panel system
]]--
function Panel:Initialize()
	if self.initialized then return end
	
	Aether:Debug("Initializing Panel system...")
	
	-- Register module
	Aether:RegisterModule(self.name, self)
	
	-- Create bars
	self:CreateBars()
	
	-- Apply settings
	self:ApplySettings()
	
	self.initialized = true
	Aether:Debug("Panel system initialized")
end

--[[
	Create panel bars
]]--
function Panel:CreateBars()
	-- Top Bar 1
	self.bars.top1 = self:CreateBar("AetherTopBar1", "TOP", UIParent, "TOP", 0, 0)
	
	-- Top Bar 2
	self.bars.top2 = self:CreateBar("AetherTopBar2", "TOP", self.bars.top1, "BOTTOM", 0, 0)
	
	-- Bottom Bar 1
	self.bars.bottom1 = self:CreateBar("AetherBottomBar1", "BOTTOM", UIParent, "BOTTOM", 0, 0)
	
	-- Bottom Bar 2
	self.bars.bottom2 = self:CreateBar("AetherBottomBar2", "BOTTOM", self.bars.bottom1, "TOP", 0, 0)
end

--[[
	Create a single bar
]]--
function Panel:CreateBar(name, point, relativeTo, relativePoint, x, y)
	local bar = CreateFrame("Frame", name, UIParent)
	bar:SetPoint(point, relativeTo, relativePoint, x, y)
	bar:SetHeight(Aether.C.PANEL.DEFAULT_HEIGHT)
	bar:SetWidth(UIParent:GetWidth())
	
	-- Background
	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints()
	bar.bg:SetColorTexture(0, 0, 0, Aether.C.PANEL.DEFAULT_OPACITY)
	
	-- Left content frame
	bar.left = CreateFrame("Frame", name .. "Left", bar)
	bar.left:SetPoint("LEFT", bar, "LEFT", 5, 0)
	bar.left:SetHeight(bar:GetHeight())
	bar.left:SetWidth(1)  -- Will expand with content
	
	-- Right content frame
	bar.right = CreateFrame("Frame", name .. "Right", bar)
	bar.right:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	bar.right:SetHeight(bar:GetHeight())
	bar.right:SetWidth(1)  -- Will expand with content
	
	-- Center content frame
	bar.center = CreateFrame("Frame", name .. "Center", bar)
	bar.center:SetPoint("LEFT", bar.left, "RIGHT", 5, 0)
	bar.center:SetPoint("RIGHT", bar.right, "LEFT", -5, 0)
	bar.center:SetHeight(bar:GetHeight())
	
	-- Plugins table
	bar.plugins = {
		left = {},
		center = {},
		right = {}
	}
	
	-- Hide by default
	bar:Hide()
	
	return bar
end

--[[
	Apply settings to bars
]]--
function Panel:ApplySettings()
	local enabled = Aether.Config:Get("panel", "enabled")
	local height = Aether.Config:Get("panel", "barHeight") or Aether.C.PANEL.DEFAULT_HEIGHT
	local opacity = Aether.Config:Get("panel", "backgroundOpacity") or Aether.C.PANEL.DEFAULT_OPACITY
	
	-- Apply to all bars
	for _, bar in pairs(self.bars) do
		if bar then
			bar:SetHeight(height)
			bar.bg:SetAlpha(opacity)
		end
	end
	
	-- Show/hide specific bars
	if enabled then
		if Aether.Config:Get("panel", "topBar1") then
			self.bars.top1:Show()
		else
			self.bars.top1:Hide()
		end
		
		if Aether.Config:Get("panel", "topBar2") then
			self.bars.top2:Show()
		else
			self.bars.top2:Hide()
		end
		
		if Aether.Config:Get("panel", "bottomBar1") then
			self.bars.bottom1:Show()
		else
			self.bars.bottom1:Hide()
		end
		
		if Aether.Config:Get("panel", "bottomBar2") then
			self.bars.bottom2:Show()
		else
			self.bars.bottom2:Hide()
		end
	else
		-- Hide all bars
		for _, bar in pairs(self.bars) do
			if bar then
				bar:Hide()
			end
		end
	end
end

--[[
	Get a bar by name
]]--
function Panel:GetBar(name)
	return self.bars[name]
end

--[[
	Add a plugin to a bar
]]--
function Panel:AddPlugin(barName, position, plugin)
	local bar = self.bars[barName]
	if not bar then
		Aether:Error("Bar not found:", barName)
		return false
	end
	
	if not position or (position ~= "left" and position ~= "center" and position ~= "right") then
		position = "left"
	end
	
	table.insert(bar.plugins[position], plugin)
	self:UpdateBar(bar)
	
	return true
end

--[[
	Remove a plugin from a bar
]]--
function Panel:RemovePlugin(barName, plugin)
	local bar = self.bars[barName]
	if not bar then
		return false
	end
	
	for pos, plugins in pairs(bar.plugins) do
		for i, p in ipairs(plugins) do
			if p == plugin then
				table.remove(plugins, i)
				self:UpdateBar(bar)
				return true
			end
		end
	end
	
	return false
end

--[[
	Update bar layout
]]--
function Panel:UpdateBar(bar)
	-- Layout plugins in left, center, right sections
	local function layoutPlugins(container, plugins)
		local xOffset = 0
		for _, plugin in ipairs(plugins) do
			if plugin.frame then
				plugin.frame:ClearAllPoints()
				plugin.frame:SetPoint("LEFT", container, "LEFT", xOffset, 0)
				xOffset = xOffset + plugin.frame:GetWidth() + 5
			end
		end
		container:SetWidth(math.max(1, xOffset))
	end
	
	layoutPlugins(bar.left, bar.plugins.left)
	layoutPlugins(bar.center, bar.plugins.center)
	layoutPlugins(bar.right, bar.plugins.right)
end

--[[
	Reload panel with new settings
]]--
function Panel:Reload()
	self:ApplySettings()
end

--[[
	Handle configuration changes
]]--
function Panel:OnConfigChanged(category, setting, value)
	if category ~= "panel" then return end
	self:ApplySettings()
end

-- Initialize
Panel:Initialize()

-- Export
Aether.Panel = Panel
