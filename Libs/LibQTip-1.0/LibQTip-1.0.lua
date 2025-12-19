--- **LibQTip-1.0** provides flexible tooltips with multiple columns and rows.
-- @class file
-- @name LibQTip-1.0
local MAJOR, MINOR = "LibQTip-1.0", 91
local LibQTip = LibStub:NewLibrary(MAJOR, MINOR)

if not LibQTip then return end

LibQTip.tipPrototype = LibQTip.tipPrototype or {}
LibQTip.tips = LibQTip.tips or {}
LibQTip.frameMetatable = LibQTip.frameMetatable or {}

local tipPrototype = LibQTip.tipPrototype
local tips = LibQTip.tips

--- Acquire a tooltip with the given key and column count.
-- @param key The unique key for this tooltip
-- @param columns The number of columns
-- @param ... Column justifications ("LEFT", "CENTER", "RIGHT")
-- @return The tooltip frame
function LibQTip:Acquire(key, columns, ...)
	if not key or type(key) ~= "string" then
		error("Usage: LibQTip:Acquire(key, columns, ...): key must be a string", 2)
	end
	
	columns = columns or 1
	
	local tip = tips[key]
	if tip then
		tip:Clear()
		return tip
	end
	
	-- Create new tooltip
	tip = CreateFrame("GameTooltip", "LibQTip_"..key, UIParent, "GameTooltipTemplate")
	tip:SetFrameStrata("TOOLTIP")
	tip.key = key
	tip.columns = columns
	tip.lines = {}
	
	-- Add methods
	for k, v in pairs(tipPrototype) do
		tip[k] = v
	end
	
	tips[key] = tip
	return tip
end

--- Release a tooltip.
-- @param tip The tooltip to release
function LibQTip:Release(tip)
	if not tip then return end
	tip:Hide()
	tip:SetParent(nil)
	tip:ClearAllPoints()
end

--- Check if a tooltip is acquired.
-- @param key The tooltip key
-- @return True if acquired
function LibQTip:IsAcquired(key)
	return tips[key] ~= nil
end

-- Tooltip prototype methods

--- Add a line to the tooltip.
-- @param ... Column text values
-- @return Line number
function tipPrototype:AddLine(...)
	local lineNum = #self.lines + 1
	self.lines[lineNum] = {...}
	
	local text = ""
	for i = 1, select("#", ...) do
		local val = select(i, ...)
		if val then
			text = text .. tostring(val) .. " "
		end
	end
	
	if self.AddLine then
		GameTooltip.AddLine(self, text:trim())
	end
	
	return lineNum
end

--- Add a header to the tooltip.
-- @param text The header text
function tipPrototype:AddHeader(text)
	return self:AddLine(text)
end

--- Add a separator line.
function tipPrototype:AddSeparator()
	return self:AddLine(" ")
end

--- Set a cell's text.
-- @param lineNum The line number
-- @param colNum The column number
-- @param text The text to set
function tipPrototype:SetCell(lineNum, colNum, text)
	if not self.lines[lineNum] then
		self.lines[lineNum] = {}
	end
	self.lines[lineNum][colNum] = text
end

--- Set a line's text color.
-- @param lineNum The line number
-- @param r Red (0-1)
-- @param g Green (0-1)
-- @param b Blue (0-1)
-- @param a Alpha (0-1)
function tipPrototype:SetLineColor(lineNum, r, g, b, a)
	-- Would normally set color on text objects
end

--- Set cell text color.
-- @param lineNum The line number
-- @param colNum The column number
-- @param r Red (0-1)
-- @param g Green (0-1)
-- @param b Blue (0-1)
-- @param a Alpha (0-1)
function tipPrototype:SetCellColor(lineNum, colNum, r, g, b, a)
	-- Would normally set color on text objects
end

--- Set line script.
-- @param lineNum The line number
-- @param script The script name (e.g., "OnEnter", "OnLeave")
-- @param handler The script handler
function tipPrototype:SetLineScript(lineNum, script, handler)
	-- Would normally set script on line frame
end

--- Set cell script.
-- @param lineNum The line number
-- @param colNum The column number
-- @param script The script name
-- @param handler The script handler
function tipPrototype:SetCellScript(lineNum, colNum, script, handler)
	-- Would normally set script on cell frame
end

--- Clear the tooltip.
function tipPrototype:Clear()
	self.lines = {}
	if GameTooltip.ClearLines and self.ClearLines then
		GameTooltip.ClearLines(self)
	end
end

--- Smart anchor the tooltip to a frame.
-- @param parent The parent frame
-- @param anchor The anchor point
function tipPrototype:SmartAnchorTo(parent, anchor)
	self:SetOwner(parent, anchor or "ANCHOR_NONE")
	
	if not anchor or anchor == "ANCHOR_NONE" then
		-- Smart positioning
		local x, y = parent:GetCenter()
		local screenWidth = UIParent:GetWidth()
		local screenHeight = UIParent:GetHeight()
		
		if x < screenWidth / 2 then
			self:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		else
			self:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		end
	end
end

--- Update the tooltip.
function tipPrototype:UpdateTooltip()
	-- Would normally update all cells and formatting
end

--- Get the number of lines.
-- @return Line count
function tipPrototype:GetLineCount()
	return #self.lines
end

--- Set column layout.
-- @param columns Number of columns
-- @param ... Column justifications
function tipPrototype:SetColumnLayout(columns, ...)
	self.columns = columns
end
