-- Aether: Gold Plugin
-- Shows current gold

local PluginGold = {}
Aether:RegisterModule("PluginGold", PluginGold)

PluginGold.enabled = true

function PluginGold:UpdateButton(button)
	local money = GetMoney()
	local gold = floor(money / 10000)
	
	button.text:SetText(string.format("%d"..Aether.Constants.GOLD_ICON, gold))
	
	-- Save character gold
	if Aether.charDB then
		Aether.charDB.char.gold = money
	end
end

function PluginGold:OnTooltipShow(tooltip)
	tooltip:AddLine("Gold Information", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local money = GetMoney()
	tooltip:AddDoubleLine("Current Character:", Aether:FormatMoney(money), 1, 1, 1, 1, 1, 1)
	
	-- Show total across characters (would need saved data)
	tooltip:AddLine(" ")
	tooltip:AddLine("Click to open currency frame", 0.5, 0.5, 0.5)
end

function PluginGold:OnClick(button)
	ToggleCharacter("TokenFrame")
end
