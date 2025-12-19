--[[
	Aether - Auto Accept Resurrect
	
	Handles automatic resurrection acceptance
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local AutoRes = {}
AutoRes.frame = CreateFrame("Frame")

function AutoRes:Initialize()
	self.frame:RegisterEvent("RESURRECT_REQUEST")
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "RESURRECT_REQUEST" then
			self:OnResurrectRequest(...)
		end
	end)
end

function AutoRes:OnResurrectRequest(name)
	if not Aether.Config:Get("automation", "autoAcceptRes") then
		return
	end
	
	-- Auto-accept resurrection
	AcceptResurrect()
	Aether:Debug("Auto-accepted resurrection from", name)
end

AutoRes:Initialize()
