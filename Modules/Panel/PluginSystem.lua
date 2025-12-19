--[[
	Aether - Plugin System
	
	Plugin registration and management system
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create plugin system
local PluginSystem = {}
PluginSystem.plugins = {}
PluginSystem.updateInterval = 1.0
PluginSystem.lastUpdate = 0

--[[
	Register a plugin
]]--
function PluginSystem:RegisterPlugin(plugin)
	if not plugin or not plugin.name then
		Aether:Error("Invalid plugin registration")
		return false
	end
	
	if self.plugins[plugin.name] then
		Aether:Debug("Plugin already registered:", plugin.name)
		return false
	end
	
	-- Set defaults
	plugin.enabled = plugin.enabled ~= false
	plugin.bar = plugin.bar or "top1"
	plugin.position = plugin.position or "left"
	plugin.updateInterval = plugin.updateInterval or 1.0
	plugin.lastUpdate = 0
	
	-- Create plugin frame if Initialize method exists
	if plugin.Initialize and type(plugin.Initialize) == "function" then
		local success, err = pcall(plugin.Initialize, plugin)
		if not success then
			Aether:Error("Failed to initialize plugin '" .. plugin.name .. "':", err)
			return false
		end
	end
	
	self.plugins[plugin.name] = plugin
	
	-- Add to panel
	if Aether.Panel and plugin.enabled then
		Aether.Panel:AddPlugin(plugin.bar, plugin.position, plugin)
	end
	
	Aether:Debug("Registered plugin:", plugin.name)
	return true
end

--[[
	Unregister a plugin
]]--
function PluginSystem:UnregisterPlugin(name)
	local plugin = self.plugins[name]
	if not plugin then
		return false
	end
	
	-- Remove from panel
	if Aether.Panel then
		Aether.Panel:RemovePlugin(plugin.bar, plugin)
	end
	
	-- Cleanup
	if plugin.Cleanup and type(plugin.Cleanup) == "function" then
		pcall(plugin.Cleanup, plugin)
	end
	
	self.plugins[name] = nil
	Aether:Debug("Unregistered plugin:", name)
	return true
end

--[[
	Get a plugin
]]--
function PluginSystem:GetPlugin(name)
	return self.plugins[name]
end

--[[
	Update all plugins
]]--
function PluginSystem:UpdatePlugins()
	local now = GetTime()
	
	if now - self.lastUpdate < self.updateInterval then
		return
	end
	
	self.lastUpdate = now
	
	for name, plugin in pairs(self.plugins) do
		if plugin.enabled and plugin.Update and type(plugin.Update) == "function" then
			if now - plugin.lastUpdate >= plugin.updateInterval then
				plugin.lastUpdate = now
				local success, err = pcall(plugin.Update, plugin)
				if not success then
					Aether:Error("Failed to update plugin '" .. name .. "':", err)
				end
			end
		end
	end
end

--[[
	Start update ticker
]]--
function PluginSystem:StartUpdates()
	if self.updateTicker then
		return
	end
	
	self.updateTicker = C_Timer.NewTicker(0.1, function()
		self:UpdatePlugins()
	end)
end

--[[
	Stop update ticker
]]--
function PluginSystem:StopUpdates()
	if self.updateTicker then
		self.updateTicker:Cancel()
		self.updateTicker = nil
	end
end

-- Start updates
PluginSystem:StartUpdates()

-- Export
Aether.PluginSystem = PluginSystem
