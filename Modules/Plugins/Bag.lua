-- Aether: Bag Plugin
-- Shows bag space information

local PluginBag = {}
Aether:RegisterModule("PluginBag", PluginBag)

PluginBag.enabled = true

function PluginBag:UpdateButton(button)
	local free, total = 0, 0
	for i = 0, NUM_BAG_SLOTS do
		local numFree, bagType = C_Container.GetContainerNumFreeSlots(i)
		local numSlots = C_Container.GetContainerNumSlots(i)
		free = free + (numFree or 0)
		total = total + (numSlots or 0)
	end
	
	button.text:SetText(string.format("Bags: %d/%d", free, total))
end

function PluginBag:OnTooltipShow(tooltip)
	tooltip:AddLine("Bag Space", 1, 1, 1)
	tooltip:AddLine(" ")
	
	for i = 0, NUM_BAG_SLOTS do
		local numFree = C_Container.GetContainerNumFreeSlots(i)
		local numSlots = C_Container.GetContainerNumSlots(i)
		local bagName = C_Container.GetBagName(i) or "Bag "..i
		tooltip:AddDoubleLine(bagName, string.format("%d/%d", numFree, numSlots), 1, 1, 1, 1, 1, 1)
	end
end

function PluginBag:OnClick(button)
	ToggleAllBags()
end
