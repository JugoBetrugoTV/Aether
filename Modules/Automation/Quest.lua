--[[
	Aether - Quest Automation
	
	Handles automatic quest acceptance and turn-in
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

-- Create submodule
local QuestAuto = {}
QuestAuto.name = "QuestAutomation"
QuestAuto.frame = CreateFrame("Frame")

--[[
	Initialize quest automation
]]--
function QuestAuto:Initialize()
	Aether:Debug("Initializing Quest Automation...")
	
	-- Register events
	self.frame:RegisterEvent("QUEST_DETAIL")
	self.frame:RegisterEvent("QUEST_PROGRESS")
	self.frame:RegisterEvent("QUEST_COMPLETE")
	self.frame:RegisterEvent("GOSSIP_SHOW")
	
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		self:OnEvent(event, ...)
	end)
end

--[[
	Handle events
]]--
function QuestAuto:OnEvent(event, ...)
	if event == "QUEST_DETAIL" then
		self:HandleQuestDetail()
	elseif event == "QUEST_PROGRESS" then
		self:HandleQuestProgress()
	elseif event == "QUEST_COMPLETE" then
		self:HandleQuestComplete()
	elseif event == "GOSSIP_SHOW" then
		self:HandleGossip()
	end
end

--[[
	Handle quest detail (accept quest)
]]--
function QuestAuto:HandleQuestDetail()
	if not Aether.Config:Get("automation", "autoAcceptQuests") then
		return
	end
	
	-- Auto-accept quest
	if QuestGetAutoAccept and QuestGetAutoAccept() then
		return  -- Already auto-accepting
	end
	
	if not QuestFlagsPVP or not QuestFlagsPVP() then
		C_Timer.After(0.1, function()
			if QuestFrame and QuestFrame:IsVisible() then
				AcceptQuest()
			end
		end)
	end
end

--[[
	Handle quest progress
]]--
function QuestAuto:HandleQuestProgress()
	if not Aether.Config:Get("automation", "autoTurnInQuests") then
		return
	end
	
	-- Check if quest is complete
	if IsQuestCompletable and IsQuestCompletable() then
		C_Timer.After(0.1, function()
			CompleteQuest()
		end)
	end
end

--[[
	Handle quest complete (turn in)
]]--
function QuestAuto:HandleQuestComplete()
	if not Aether.Config:Get("automation", "autoTurnInQuests") then
		return
	end
	
	-- Get number of rewards
	local numRewards = GetNumQuestChoices and GetNumQuestChoices() or 0
	
	if numRewards <= 1 then
		-- No choice or only one item, complete automatically
		C_Timer.After(0.1, function()
			if numRewards == 1 then
				GetQuestReward(1)
			else
				GetQuestReward()
			end
		end)
	end
	-- If multiple rewards, let player choose
end

--[[
	Handle gossip (auto-accept gossip options)
]]--
function QuestAuto:HandleGossip()
	if not Aether.Config:Get("automation", "autoAcceptGossip") then
		return
	end
	
	-- Auto-select first gossip option if only one is available
	if C_GossipInfo and C_GossipInfo.GetOptions then
		local options = C_GossipInfo.GetOptions()
		if options and #options == 1 then
			C_Timer.After(0.1, function()
				C_GossipInfo.SelectOption(1)
			end)
		end
	end
end

-- Initialize
QuestAuto:Initialize()
