-- Aether: Chat/Enhancements.lua
-- Chat enhancements and improvements

local ChatEnhancements = {}
Aether:RegisterModule("ChatEnhancements", ChatEnhancements)

function ChatEnhancements:Initialize()
	self:ApplyEnhancements()
end

function ChatEnhancements:ApplyEnhancements()
	-- Hide chat buttons
	if Aether.db.profile.chat.hideChatButtons then
		self:HideChatButtons()
	end
	
	-- Move edit box to top
	if Aether.db.profile.chat.moveEditBoxToTop then
		self:MoveEditBoxToTop()
	end
	
	-- Class colors in chat
	if Aether.db.profile.chat.classColorsInChat then
		self:EnableClassColors()
	end
	
	-- Disable chat fade
	if Aether.db.profile.chat.disableChatFade then
		self:DisableChatFade()
	end
	
	-- Increase chat history
	if Aether.db.profile.chat.increaseChatHistory then
		self:IncreaseChatHistory()
	end
end

function ChatEnhancements:HideChatButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]
		if chatFrame then
			local buttonFrame = _G["ChatFrame"..i.."ButtonFrame"]
			if buttonFrame then
				buttonFrame:Hide()
			end
		end
	end
end

function ChatEnhancements:MoveEditBoxToTop()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]
		local editBox = _G["ChatFrame"..i.."EditBox"]
		if chatFrame and editBox then
			editBox:ClearAllPoints()
			editBox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 0, 0)
			editBox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 0)
		end
	end
end

function ChatEnhancements:EnableClassColors()
	-- This is typically done through SetChatColorNameByClass
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]
		if chatFrame then
			ToggleChatColorNamesByClassGroup(true, "SAY")
			ToggleChatColorNamesByClassGroup(true, "EMOTE")
			ToggleChatColorNamesByClassGroup(true, "YELL")
			ToggleChatColorNamesByClassGroup(true, "GUILD")
			ToggleChatColorNamesByClassGroup(true, "OFFICER")
			ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
			ToggleChatColorNamesByClassGroup(true, "WHISPER")
			ToggleChatColorNamesByClassGroup(true, "PARTY")
			ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID")
			ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
			ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
			ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
		end
	end
end

function ChatEnhancements:DisableChatFade()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]
		if chatFrame then
			chatFrame:SetFading(false)
		end
	end
end

function ChatEnhancements:IncreaseChatHistory()
	local lines = Aether.db.profile.chat.chatHistoryLines or 128
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]
		if chatFrame then
			chatFrame:SetMaxLines(lines)
		end
	end
end
