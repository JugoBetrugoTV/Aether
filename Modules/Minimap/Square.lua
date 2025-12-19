-- Aether: Minimap/Square.lua
-- Square minimap functionality

local MinimapSquare = {}
Aether:RegisterModule("MinimapSquare", MinimapSquare)

function MinimapSquare:Initialize()
	if Aether.db.profile.minimap.squareMinimap then
		self:MakeSquare()
	end
end

function MinimapSquare:MakeSquare()
	-- Make the minimap square
	Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetQuestBlobRingScalar(0)
	
	-- Adjust the border
	if MinimapBorder then
		MinimapBorder:Hide()
	end
	
	-- Create custom border
	if not self.border then
		self.border = CreateFrame("Frame", "AetherMinimapBorder", Minimap, "BackdropTemplate")
		self.border:SetAllPoints(Minimap)
		self.border:SetBackdrop({
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		self.border:SetBackdropBorderColor(1, 1, 1, 1)
	end
	self.border:Show()
end

function MinimapSquare:MakeRound()
	-- Restore round minimap
	Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
	
	if self.border then
		self.border:Hide()
	end
	
	if MinimapBorder then
		MinimapBorder:Show()
	end
end

function MinimapSquare:Refresh()
	if Aether.db.profile.minimap.squareMinimap then
		self:MakeSquare()
	else
		self:MakeRound()
	end
end
