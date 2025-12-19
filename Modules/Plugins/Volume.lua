-- Aether: Volume Plugin
-- Shows and controls volume

local PluginVolume = {}
Aether:RegisterModule("PluginVolume", PluginVolume)

PluginVolume.enabled = true

function PluginVolume:UpdateButton(button)
	local masterVolume = GetCVar("Sound_MasterVolume")
	local volume = tonumber(masterVolume) or 1
	
	button.text:SetText(string.format("Vol: %d%%", volume * 100))
end

function PluginVolume:OnTooltipShow(tooltip)
	tooltip:AddLine("Volume Controls", 1, 1, 1)
	tooltip:AddLine(" ")
	
	local masterVolume = tonumber(GetCVar("Sound_MasterVolume")) or 1
	local musicVolume = tonumber(GetCVar("Sound_MusicVolume")) or 1
	local sfxVolume = tonumber(GetCVar("Sound_SFXVolume")) or 1
	local ambientVolume = tonumber(GetCVar("Sound_AmbienceVolume")) or 1
	
	tooltip:AddDoubleLine("Master:", string.format("%d%%", masterVolume * 100), 1, 1, 1, 1, 1, 1)
	tooltip:AddDoubleLine("Music:", string.format("%d%%", musicVolume * 100), 1, 1, 1, 1, 1, 1)
	tooltip:AddDoubleLine("SFX:", string.format("%d%%", sfxVolume * 100), 1, 1, 1, 1, 1, 1)
	tooltip:AddDoubleLine("Ambient:", string.format("%d%%", ambientVolume * 100), 1, 1, 1, 1, 1, 1)
	
	tooltip:AddLine(" ")
	tooltip:AddLine("Right-click to mute/unmute", 0.5, 0.5, 0.5)
end

function PluginVolume:OnClick(button)
	if button == "RightButton" then
		-- Toggle mute
		local masterVolume = tonumber(GetCVar("Sound_MasterVolume")) or 1
		if masterVolume > 0 then
			SetCVar("Sound_MasterVolume", 0)
			Aether:Print("Sound muted")
		else
			SetCVar("Sound_MasterVolume", 1)
			Aether:Print("Sound unmuted")
		end
	else
		-- Open sound options
		Settings.OpenToCategory(Settings.AUDIO_LABEL)
	end
end
