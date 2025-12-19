-- Aether: Clock Plugin
-- Shows current time

local PluginClock = {}
Aether:RegisterModule("PluginClock", PluginClock)

PluginClock.enabled = true

function PluginClock:UpdateButton(button)
	local hour, minute
	
	if Aether.db.profile.plugins.clock.serverTime then
		hour, minute = GetGameTime()
	else
		local timeStr = date("%H:%M")
		hour, minute = string.match(timeStr, "(%d+):(%d+)")
	end
	
	local format24 = Aether.db.profile.plugins.clock.use24Hour
	
	if format24 then
		button.text:SetText(string.format("%02d:%02d", hour, minute))
	else
		local ampm = hour >= 12 and "PM" or "AM"
		hour = hour % 12
		if hour == 0 then hour = 12 end
		button.text:SetText(string.format("%d:%02d %s", hour, minute, ampm))
	end
end

function PluginClock:OnTooltipShow(tooltip)
	tooltip:AddLine("Time Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local serverHour, serverMinute = GetGameTime()
	tooltip:AddDoubleLine("Server Time:", string.format("%02d:%02d", serverHour, serverMinute), 1, 1, 1, 1, 1, 1)
	
	local localTime = date("%H:%M")
	tooltip:AddDoubleLine("Local Time:", localTime, 1, 1, 1, 1, 1, 1)
	
	local dateStr = date("%A, %B %d, %Y")
	tooltip:AddDoubleLine("Date:", dateStr, 1, 1, 1, 1, 1, 1)
end
