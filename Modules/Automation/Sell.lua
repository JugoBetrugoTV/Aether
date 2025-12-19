-- Aether: Automation/Sell.lua
-- Auto-sell junk items

local SellAutomation = {}
Aether:RegisterModule("SellAutomation", SellAutomation)

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

function SellAutomation:Initialize()
	if Aether.db.profile.automation.autoSellJunk then
		Aether:RegisterEvent("MERCHANT_SHOW", function() self:OnMerchantShow() end)
	end
end

function SellAutomation:OnMerchantShow()
	if not Aether.db.profile.automation.autoSellJunk then return end
	
	local totalValue = 0
	
	for bag = 0, NUM_BAG_SLOTS do
		local numSlots = C_Container.GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local info = C_Container.GetContainerItemInfo(bag, slot)
			if info then
				local itemLink = info.hyperlink
				if itemLink then
					local _, _, quality, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(itemLink)
					if quality == 0 and vendorPrice and vendorPrice > 0 then
						-- Sell junk item
						local stackCount = info.stackCount or 1
						C_Container.UseContainerItem(bag, slot)
						totalValue = totalValue + (vendorPrice * stackCount)
					end
				end
			end
		end
	end
	
	if totalValue > 0 then
		Aether:Print(L["Sold junk for %s"]:format(Aether:FormatMoney(totalValue)))
	end
end
