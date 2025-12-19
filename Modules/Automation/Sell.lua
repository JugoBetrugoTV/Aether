--[[
	Aether - Auto Sell Junk
	
	Handles automatic selling of junk items at vendors
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local AutoSell = {}
AutoSell.frame = CreateFrame("Frame")
AutoSell.totalSold = 0

function AutoSell:Initialize()
	self.frame:RegisterEvent("MERCHANT_SHOW")
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "MERCHANT_SHOW" then
			self:OnMerchantShow()
		end
	end)
end

function AutoSell:OnMerchantShow()
	if not Aether.Config:Get("automation", "autoSellJunk") then
		return
	end
	
	self.totalSold = 0
	
	-- Scan all bags for junk items
	for bag = 0, NUM_BAG_SLOTS do
		local numSlots = C_Container.GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
			if itemInfo then
				local itemLink = itemInfo.hyperlink
				local itemQuality = itemInfo.quality
				
				-- Sell poor quality (gray) items
				if itemQuality == 0 and not Aether.U.IsItemSoulbound(bag, slot) then
					local itemPrice = select(11, GetItemInfo(itemLink)) or 0
					if itemPrice > 0 then
						C_Container.UseContainerItem(bag, slot)
						self.totalSold = self.totalSold + (itemPrice * (itemInfo.stackCount or 1))
					end
				end
			end
		end
	end
	
	if self.totalSold > 0 then
		Aether:Print("Sold junk items for " .. Aether.U.FormatMoney(self.totalSold))
	end
end

AutoSell:Initialize()
