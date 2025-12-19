-- Aether: Social/Blocks.lua
-- Block various social invitations

local SocialBlocks = {}
Aether:RegisterModule("SocialBlocks", SocialBlocks)

function SocialBlocks:Initialize()
	self:RegisterEvents()
end

function SocialBlocks:RegisterEvents()
	-- Block duels
	if Aether.db.profile.social.blockDuels then
		Aether:RegisterEvent("DUEL_REQUESTED", function() self:OnDuelRequested() end)
	end
	
	-- Block pet battle duels
	if Aether.db.profile.social.blockPetDuels then
		Aether:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", function() self:OnPetDuelRequested() end)
	end
	
	-- Block party invites
	if Aether.db.profile.social.blockPartyInvites then
		Aether:RegisterEvent("PARTY_INVITE_REQUEST", function(_, inviter) self:OnPartyInvite(inviter) end)
	end
end

function SocialBlocks:OnDuelRequested()
	CancelDuel()
	StaticPopup_Hide("DUEL_REQUESTED")
end

function SocialBlocks:OnPetDuelRequested()
	C_PetBattles.CancelPVPDuel()
	StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
end

function SocialBlocks:OnPartyInvite(inviter)
	-- Check if inviter is friend or guild member
	if Aether.db.profile.social.autoAcceptFriends and C_FriendList.IsFriend(inviter) then
		AcceptGroup()
		return
	end
	
	if Aether.db.profile.social.autoAcceptGuild and IsInGuild() then
		for i = 1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i)
			if name == inviter then
				AcceptGroup()
				return
			end
		end
	end
	
	-- Otherwise decline
	DeclineGroup()
	StaticPopup_Hide("PARTY_INVITE")
end
