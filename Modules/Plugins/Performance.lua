-- Aether: Performance Plugin
-- Shows FPS, latency, and memory usage

local PluginPerformance = {}
Aether:RegisterModule("PluginPerformance", PluginPerformance)

PluginPerformance.enabled = true

function PluginPerformance:UpdateButton(button)
	local fps = GetFramerate()
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = math.max(latencyHome, latencyWorld)
	
	button.text:SetText(string.format("FPS: %d | %dms", fps, latency))
end

function PluginPerformance:OnTooltipShow(tooltip)
	tooltip:AddLine("Performance Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local fps = GetFramerate()
	tooltip:AddDoubleLine("FPS:", string.format("%.1f", fps), 1, 1, 1, 1, 1, 1)
	
	local _, _, latencyHome, latencyWorld = GetNetStats()
	tooltip:AddDoubleLine("Home Latency:", latencyHome.."ms", 1, 1, 1, 1, 1, 1)
	tooltip:AddDoubleLine("World Latency:", latencyWorld.."ms", 1, 1, 1, 1, 1, 1)
	
	UpdateAddOnMemoryUsage()
	local memory = GetAddOnMemoryUsage("Aether")
	tooltip:AddDoubleLine("Aether Memory:", string.format("%.2f MB", memory/1024), 1, 1, 1, 1, 1, 1)
	
	local totalMemory = 0
	for i = 1, C_AddOns.GetNumAddOns() do
		totalMemory = totalMemory + GetAddOnMemoryUsage(i)
	end
	tooltip:AddDoubleLine("Total Memory:", string.format("%.2f MB", totalMemory/1024), 1, 1, 1, 1, 1, 1)
end

function PluginPerformance:OnClick(button)
	collectgarbage()
	Aether:Print("Garbage collection performed")
end
