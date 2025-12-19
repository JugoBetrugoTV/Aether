--[[
	Aether - Auto Repair
	
	Handles automatic repair at vendors
]]--

local ADDON_NAME = "Aether"
local Aether = _G[ADDON_NAME]

local AutoRepair = {}
AutoRepair.frame = CreateFrame("Frame")

function AutoRepair:Initialize()
	self.frame:RegisterEvent("MERCHANT_SHOW")
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		if event == "MERCHANT_SHOW" then
			self:OnMerchantShow()
		end
	end)
end

function AutoRepair:OnMerchantShow()
	if not Aether.Config:Get("automation", "autoRepair") then
		return
	end
	
	if not CanMerchantRepair() then
		return
	end
	
	local repairCost, canRepair = GetRepairAllCost()
	if not canRepair or repairCost == 0 then
		return
	end
	
	-- Try guild bank repair first if enabled
	local useGuildBank = Aether.Config:Get("automation", "autoRepairGuildBank")
	if useGuildBank and CanGuildBankRepair() then
		RepairAllItems(true)
		Aether:Print("Repaired using guild bank funds")
	elseif GetMoney() >= repairCost then
		RepairAllItems(false)
		Aether:Print("Repaired for " .. Aether.U.FormatMoney(repairCost))
	else
		Aether:Print("Not enough gold for repair. Need " .. Aether.U.FormatMoney(repairCost))
	end
end

AutoRepair:Initialize()
