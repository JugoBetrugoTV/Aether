-- Aether: Commands.lua
-- Slash command handlers

local L = LibStub("AceLocale-3.0"):GetLocale("Aether")

-- Additional slash command functions
function Aether:ShowHelp()
	self:Print(L["Available commands:"])
	self:Print(L["/aether - Show options"])
	self:Print(L["/aether panel - Toggle panel"])
	self:Print(L["/aether reset - Reset all settings"])
end

function Aether:TogglePanelCommand()
	local panel = self:GetModule("Panel")
	if panel then
		panel:Toggle()
	else
		self:Print(L["Error: Module not found"])
	end
end

function Aether:ResetCommand()
	StaticPopup_Show("AETHER_RESET_CONFIRM")
end

-- Static popup for reset confirmation
StaticPopupDialogs["AETHER_RESET_CONFIRM"] = {
	text = "Are you sure you want to reset all Aether settings?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		Aether:ResetSettings()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}
