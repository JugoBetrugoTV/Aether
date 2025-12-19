--[[
	Aether - Auto Accept Social
	Auto-accept from friends/guild
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local AutoAccept = {}
AutoAccept.frame = CreateFrame("Frame")

function AutoAccept:Initialize()
	self.frame:RegisterEvent("PARTY_INVITE_REQUEST")
	
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "PARTY_INVITE_REQUEST" then
			self:OnPartyInvite(...)
		end
	end)
end

function AutoAccept:OnPartyInvite(sender)
	if not Aether.Config:Get("social", "autoAcceptPartyFromFriends") then
		return
	end
	
	-- Check if sender is friend or guild member
	if C_FriendList.IsFriend(sender) or IsGuildMember(sender) then
		AcceptGroup()
		Aether:Debug("Auto-accepted party invite from", sender)
	end
end

AutoAccept:Initialize()
