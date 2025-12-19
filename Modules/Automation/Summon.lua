--[[
	Aether - Auto Accept Summon
	
	Handles automatic summon acceptance
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local AutoSummon = {}
AutoSummon.frame = CreateFrame("Frame")

function AutoSummon:Initialize()
	self.frame:RegisterEvent("CONFIRM_SUMMON")
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "CONFIRM_SUMMON" then
			self:OnConfirmSummon()
		end
	end)
end

function AutoSummon:OnConfirmSummon()
	if not Aether.Config:Get("automation", "autoAcceptSummon") then
		return
	end
	
	-- Auto-accept summon
	C_SummonInfo.ConfirmSummon()
	Aether:Debug("Auto-accepted summon")
end

AutoSummon:Initialize()
