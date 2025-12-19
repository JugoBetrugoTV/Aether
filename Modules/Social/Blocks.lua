--[[
	Aether - Social Blocks
	Blocks duels, invites, etc.
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local Blocks = {}
Blocks.frame = CreateFrame("Frame")

function Blocks:Initialize()
	self.frame:RegisterEvent("DUEL_REQUESTED")
	self.frame:RegisterEvent("PARTY_INVITE_REQUEST")
	
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "DUEL_REQUESTED" and Aether.Config:Get("social", "blockDuels") then
			CancelDuel()
			Aether:Debug("Blocked duel request")
		elseif event == "PARTY_INVITE_REQUEST" and Aether.Config:Get("social", "blockPartyInvites") then
			DeclineGroup()
			Aether:Debug("Blocked party invite")
		end
	end)
end

Blocks:Initialize()
