-- Aether: System/Camera.lua
-- Camera enhancements

local CameraSystem = {}
Aether:RegisterModule("CameraSystem", CameraSystem)

function CameraSystem:Initialize()
	if Aether.db.profile.system.maxCameraZoom then
		self:SetMaxZoom()
	end
end

function CameraSystem:SetMaxZoom()
	-- Increase max camera zoom distance
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
end

function CameraSystem:ResetZoom()
	-- Reset to default
	SetCVar("cameraDistanceMaxZoomFactor", 1.0)
end

function CameraSystem:Refresh()
	if Aether.db.profile.system.maxCameraZoom then
		self:SetMaxZoom()
	else
		self:ResetZoom()
	end
end
