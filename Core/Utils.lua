-- Aether: Utils.lua
-- Utility functions

Aether.Utils = {}
local Utils = Aether.Utils

-- String utilities
function Utils:Trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function Utils:Split(str, delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(str, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(str, from, delim_from-1))
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from)
	end
	table.insert(result, string.sub(str, from))
	return result
end

function Utils:StartsWith(str, prefix)
	return str:sub(1, #prefix) == prefix
end

function Utils:EndsWith(str, suffix)
	return str:sub(-#suffix) == suffix
end

-- Table utilities
function Utils:TableCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Utils:TableCopy(orig_key)] = Utils:TableCopy(orig_value)
		end
		setmetatable(copy, Utils:TableCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

function Utils:TableCount(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

function Utils:TableContains(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

function Utils:TableMerge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" and type(t1[k]) == "table" then
			Utils:TableMerge(t1[k], v)
		else
			t1[k] = v
		end
	end
	return t1
end

-- Math utilities
function Utils:Round(num, decimals)
	local mult = 10^(decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end

function Utils:Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Color utilities
function Utils:HexToRGB(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
end

function Utils:RGBToHex(r, g, b)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function Utils:ColorText(text, r, g, b)
	return string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, text)
end

-- Unit utilities
function Utils:GetUnitColor(unit)
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				return color.r, color.g, color.b
			end
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = FACTION_BAR_COLORS[reaction]
			if color then
				return color.r, color.g, color.b
			end
		end
	end
	return 1, 1, 1
end

function Utils:GetUnitClassColor(unit)
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			return Aether:GetClassColor(class)
		end
	end
	return Aether.Constants.COLOR.WHITE
end

-- Time utilities
function Utils:FormatTime(seconds)
	local hours = floor(seconds / 3600)
	local mins = floor((seconds % 3600) / 60)
	local secs = floor(seconds % 60)
	
	if hours > 0 then
		return string.format("%d:%02d:%02d", hours, mins, secs)
	else
		return string.format("%d:%02d", mins, secs)
	end
end

function Utils:FormatShortTime(seconds)
	if seconds < 60 then
		return string.format("%ds", seconds)
	elseif seconds < 3600 then
		return string.format("%dm", floor(seconds / 60))
	else
		return string.format("%dh", floor(seconds / 3600))
	end
end

-- Position utilities
function Utils:GetPlayerPosition()
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		if position then
			local x, y = position:GetXY()
			return x * 100, y * 100
		end
	end
	return 0, 0
end

function Utils:GetPlayerZone()
	return GetZoneText() or GetSubZoneText() or "Unknown"
end

-- Item utilities
function Utils:GetItemQualityColor(quality)
	return Aether:GetQualityColor(quality)
end

function Utils:IsItemJunk(itemLink)
	if not itemLink then return false end
	local _, _, quality = GetItemInfo(itemLink)
	return quality == 0 -- Poor quality
end

-- Frame utilities
function Utils:CreateBackdrop(frame, insets)
	insets = insets or 0
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = insets, right = insets, top = insets, bottom = insets }
	})
	frame:SetBackdropColor(0, 0, 0, 0.8)
	frame:SetBackdropBorderColor(1, 1, 1, 1)
end

function Utils:FadeIn(frame, duration)
	duration = duration or 0.3
	UIFrameFadeIn(frame, duration, frame:GetAlpha(), 1)
end

function Utils:FadeOut(frame, duration)
	duration = duration or 0.3
	UIFrameFadeOut(frame, duration, frame:GetAlpha(), 0)
end

-- Debug utilities
function Utils:Debug(...)
	if Aether.db and Aether.db.profile.debug then
		print("|cff00ff00[Aether Debug]|r", ...)
	end
end

function Utils:PrintTable(tbl, indent)
	indent = indent or 0
	local prefix = string.rep("  ", indent)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(prefix .. tostring(k) .. " = {")
			Utils:PrintTable(v, indent + 1)
			print(prefix .. "}")
		else
			print(prefix .. tostring(k) .. " = " .. tostring(v))
		end
	end
end
