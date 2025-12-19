-- Aether: Automation/Quest.lua
-- Auto-accept and turn in quests

local QuestAutomation = {}
Aether:RegisterModule("QuestAutomation", QuestAutomation)

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

function QuestAutomation:Initialize()
	if Aether.db.profile.automation.autoAcceptQuests or Aether.db.profile.automation.autoTurnInQuests then
		self:RegisterEvents()
	end
end

function QuestAutomation:RegisterEvents()
	Aether:RegisterEvent("QUEST_DETAIL", function() self:OnQuestDetail() end)
	Aether:RegisterEvent("QUEST_PROGRESS", function() self:OnQuestProgress() end)
	Aether:RegisterEvent("QUEST_COMPLETE", function() self:OnQuestComplete() end)
	Aether:RegisterEvent("GOSSIP_SHOW", function() self:OnGossipShow() end)
end

function QuestAutomation:OnQuestDetail()
	if Aether.db.profile.automation.autoAcceptQuests then
		AcceptQuest()
	end
end

function QuestAutomation:OnQuestProgress()
	if Aether.db.profile.automation.autoTurnInQuests and IsQuestCompletable() then
		CompleteQuest()
	end
end

function QuestAutomation:OnQuestComplete()
	if Aether.db.profile.automation.autoTurnInQuests then
		if GetNumQuestChoices() <= 1 then
			GetQuestReward(1)
		end
	end
end

function QuestAutomation:OnGossipShow()
	if Aether.db.profile.automation.autoAcceptQuests then
		local numAvailable = C_GossipInfo.GetNumAvailableQuests()
		if numAvailable > 0 then
			for i = 1, numAvailable do
				C_GossipInfo.SelectAvailableQuest(i)
			end
		end
		
		local numActive = C_GossipInfo.GetNumActiveQuests()
		if numActive > 0 and Aether.db.profile.automation.autoTurnInQuests then
			for i = 1, numActive do
				local questInfo = C_GossipInfo.GetActiveQuests()[i]
				if questInfo and questInfo.isComplete then
					C_GossipInfo.SelectActiveQuest(i)
				end
			end
		end
	end
end
