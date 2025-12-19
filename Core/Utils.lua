--[[
	Aether - Utility Functions
	
	This file contains common utility functions used throughout the addon
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create utils table
Aether.Utils = {}
local U = Aether.Utils

--[[
	Color a string with RGB values
]]--
function U.ColorText(text, r, g, b)
	return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text)
end

--[[
	Color a string with a hex color code
]]--
function U.ColorTextHex(text, hexColor)
	return hexColor .. text .. "|r"
end

--[[
	Get class color for a unit
]]--
function U.GetClassColor(unit)
	local _, class = UnitClass(unit or "player")
	if class and Aether.C.CLASS_COLORS[class] then
		local color = Aether.C.CLASS_COLORS[class]
		return color.r, color.g, color.b
	end
	return 1, 1, 1  -- Default to white
end

--[[
	Format gold/silver/copper
]]--
function U.FormatMoney(money)
	if not money or money == 0 then
		return "0|cffFFD700g|r"
	end
	
	local gold = math.floor(money / 10000)
	local silver = math.floor((money % 10000) / 100)
	local copper = money % 100
	
	local result = ""
	
	if gold > 0 then
		result = result .. gold .. "|cffFFD700g|r"
	end
	
	if silver > 0 then
		if result ~= "" then result = result .. " " end
		result = result .. silver .. "|cffC0C0C0s|r"
	end
	
	if copper > 0 or result == "" then
		if result ~= "" then result = result .. " " end
		result = result .. copper .. "|cffCD7F32c|r"
	end
	
	return result
end

--[[
	Format large numbers with commas
]]--
function U.FormatNumber(number)
	if not number then return "0" end
	
	local formatted = tostring(number)
	local k
	
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	
	return formatted
end

--[[
	Format time (seconds to HH:MM:SS)
]]--
function U.FormatTime(seconds)
	if not seconds or seconds < 0 then
		return "00:00:00"
	end
	
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	
	return string.format("%02d:%02d:%02d", hours, mins, secs)
end

--[[
	Format time in short format
]]--
function U.FormatTimeShort(seconds)
	if not seconds or seconds < 0 then
		return "0s"
	end
	
	if seconds >= 3600 then
		return string.format("%.1fh", seconds / 3600)
	elseif seconds >= 60 then
		return string.format("%.1fm", seconds / 60)
	else
		return string.format("%ds", seconds)
	end
end

--[[
	Round a number to specified decimal places
]]--
function U.Round(number, decimals)
	if not number then return 0 end
	decimals = decimals or 0
	local mult = 10^decimals
	return math.floor(number * mult + 0.5) / mult
end

--[[
	Deep copy a table
]]--
function U.DeepCopy(orig)
	local orig_type = type(orig)
	local copy
	
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[U.DeepCopy(orig_key)] = U.DeepCopy(orig_value)
		end
		setmetatable(copy, U.DeepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	
	return copy
end

--[[
	Merge two tables
]]--
function U.MergeTables(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" and type(t1[k]) == "table" then
			U.MergeTables(t1[k], v)
		else
			t1[k] = v
		end
	end
	return t1
end

--[[
	Check if a table contains a value
]]--
function U.TableContains(table, value)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

--[[
	Get table size
]]--
function U.TableSize(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

--[[
	Safe call a function
]]--
function U.SafeCall(func, ...)
	if type(func) == "function" then
		local success, result = pcall(func, ...)
		if not success then
			Aether:Error("Function call failed:", result)
			return nil
		end
		return result
	end
	return nil
end

--[[
	Create a throttled function
]]--
function U.Throttle(func, delay)
	local lastTime = 0
	
	return function(...)
		local now = GetTime()
		if now - lastTime >= delay then
			lastTime = now
			return func(...)
		end
	end
end

--[[
	Create a debounced function
]]--
function U.Debounce(func, delay)
	local timer = nil
	
	return function(...)
		if timer then
			timer:Cancel()
		end
		
		local args = {...}
		timer = C_Timer.NewTimer(delay, function()
			func(unpack(args))
			timer = nil
		end)
	end
end

--[[
	Get item quality color
]]--
function U.GetItemQualityColor(quality)
	quality = quality or 1
	local color = Aether.C.ITEM_QUALITY_COLORS[quality]
	if color then
		return color.r, color.g, color.b
	end
	return 1, 1, 1
end

--[[
	Check if player is in combat
]]--
function U.IsInCombat()
	return InCombatLockdown()
end

--[[
	Check if player is resting
]]--
function U.IsResting()
	return IsResting()
end

--[[
	Get player faction
]]--
function U.GetPlayerFaction()
	local faction = UnitFactionGroup("player")
	return faction
end

--[[
	Get player class
]]--
function U.GetPlayerClass()
	local _, class = UnitClass("player")
	return class
end

--[[
	Get player level
]]--
function U.GetPlayerLevel()
	return UnitLevel("player")
end

--[[
	Get player name
]]--
function U.GetPlayerName()
	local name = UnitName("player")
	return name
end

--[[
	Get player realm
]]--
function U.GetPlayerRealm()
	local realm = GetRealmName()
	return realm
end

--[[
	Get full player name (Name-Realm)
]]--
function U.GetFullPlayerName()
	return U.GetPlayerName() .. "-" .. U.GetPlayerRealm()
end

--[[
	Check if item is junk
]]--
function U.IsJunkItem(itemLink)
	if not itemLink then return false end
	
	local _, _, quality = GetItemInfo(itemLink)
	return quality == 0  -- Poor quality
end

--[[
	Get bag slot info
]]--
function U.GetBagSlotInfo()
	local free = 0
	local total = 0
	
	for bag = 0, NUM_BAG_SLOTS do
		local numSlots = C_Container.GetContainerNumSlots(bag) or 0
		local freeSlots = C_Container.GetContainerNumFreeSlots(bag) or 0
		total = total + numSlots
		free = free + freeSlots
	end
	
	return free, total
end

--[[
	Get addon memory usage
]]--
function U.GetAddonMemory()
	UpdateAddOnMemoryUsage()
	local memory = GetAddOnMemoryUsage(ADDON_NAME) or 0
	return memory
end

--[[
	Format memory size
]]--
function U.FormatMemory(kb)
	if kb < 1024 then
		return string.format("%.2f KB", kb)
	else
		return string.format("%.2f MB", kb / 1024)
	end
end

--[[
	Get FPS
]]--
function U.GetFPS()
	return math.floor(GetFramerate())
end

--[[
	Get latency
]]--
function U.GetLatency()
	local _, _, home, world = GetNetStats()
	return home, world
end

--[[
	Check if item is soulbound
]]--
function U.IsItemSoulbound(bag, slot)
	if not C_Container then return false end
	
	local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
	if not itemInfo then return false end
	
	-- Check tooltip for soulbound text
	local tooltip = CreateFrame("GameTooltip", "AetherScanTooltip", UIParent, "GameTooltipTemplate")
	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:SetBagItem(bag, slot)
	
	for i = 1, tooltip:NumLines() do
		local text = _G["AetherScanTooltipTextLeft" .. i]:GetText()
		if text and (text == ITEM_SOULBOUND or text == ITEM_BIND_ON_PICKUP) then
			tooltip:Hide()
			return true
		end
	end
	
	tooltip:Hide()
	return false
end

-- Export utils
Aether.U = U
