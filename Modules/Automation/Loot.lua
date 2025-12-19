--[[
	Aether - Faster Loot
	
	Handles faster looting
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local FastLoot = {}
FastLoot.frame = CreateFrame("Frame")

function FastLoot:Initialize()
	self.frame:RegisterEvent("PLAYER_LOGIN")
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "PLAYER_LOGIN" then
			self:ApplyFasterLoot()
		end
	end)
end

function FastLoot:ApplyFasterLoot()
	if not Aether.Config:Get("automation", "fasterLoot") then
		return
	end
	
	-- Reduce loot delay
	if GetCVar("autoLootDelay") then
		SetCVar("autoLootDelay", "0")
		Aether:Debug("Applied faster loot")
	end
end

FastLoot:Initialize()
