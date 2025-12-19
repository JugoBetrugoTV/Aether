-- Aether: Automation/Repair.lua
-- Auto-repair functionality

local RepairAutomation = {}
Aether:RegisterModule("RepairAutomation", RepairAutomation)

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

function RepairAutomation:Initialize()
	if Aether.db.profile.automation.autoRepair then
		Aether:RegisterEvent("MERCHANT_SHOW", function() self:OnMerchantShow() end)
	end
end

function RepairAutomation:OnMerchantShow()
	if not Aether.db.profile.automation.autoRepair then return end
	if not CanMerchantRepair() then return end
	
	local cost = GetRepairAllCost()
	if cost > 0 then
		local canUseGuildBank = Aether.db.profile.automation.useGuildBank and CanGuildBankRepair()
		
		if canUseGuildBank then
			RepairAllItems(true)
			Aether:Print(L["Items repaired for %s"]:format(Aether:FormatMoney(cost)))
			Aether:Print(L["Using guild bank for repairs"])
		elseif GetMoney() >= cost then
			RepairAllItems(false)
			Aether:Print(L["Items repaired for %s"]:format(Aether:FormatMoney(cost)))
		end
	end
end
