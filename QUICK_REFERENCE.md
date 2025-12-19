# Aether Quick Reference

Quick reference for developers working on the Aether addon.

## File Structure at a Glance

```
Aether/
├── Core/           - Core addon systems
├── Modules/        - Feature modules
│   ├── Panel/      - Panel system
│   ├── Plugins/    - Panel plugins
│   ├── Automation/ - Automation features
│   └── ...         - Other modules
├── UI/             - User interface
├── Locales/        - Translations
├── Media/          - Assets (textures, fonts, sounds)
└── Libs/           - Required libraries (not included)
```

## Key Files

| File | Purpose |
|------|---------|
| `Core/Init.lua` | Main addon initialization |
| `Core/Constants.lua` | All constants and defaults |
| `Core/Utils.lua` | Utility functions |
| `Core/Config.lua` | Configuration management |
| `Core/Profiles.lua` | Profile system |
| `Core/Commands.lua` | Slash commands |

## Accessing Core Systems

```lua
-- Get the addon object
local Aether = _G["Aether"]

-- Access systems
Aether.U          -- Utils
Aether.C          -- Constants
Aether.Config     -- Configuration
Aether.Profiles   -- Profile management
Aether.Panel      -- Panel system
Aether.PluginSystem -- Plugin management
Aether.UI         -- UI system
Aether.Themes     -- Theme system
Aether.L          -- Localization
```

## Common Operations

### Get/Set Settings

```lua
-- Get a setting
local value = Aether.Config:Get("category", "settingName")

-- Set a setting
Aether.Config:Set("category", "settingName", value)

-- Toggle boolean setting
Aether.Config:Toggle("category", "settingName")
```

### Print Messages

```lua
-- Normal message
Aether:Print("Message")

-- Debug message (only if debug enabled)
Aether:Debug("Debug message")

-- Error message
Aether:Error("Error message")
```

### Register a Module

```lua
local MyModule = {}
MyModule.name = "MyModule"

function MyModule:Initialize()
    -- Module initialization
    Aether:RegisterModule(self.name, self)
end

function MyModule:Reload()
    -- Called when settings change
end

function MyModule:OnConfigChanged(category, setting, value)
    -- Called when config changes
end

MyModule:Initialize()
```

### Register a Plugin

```lua
local MyPlugin = {
    name = "MyPlugin",
    enabled = true,
    bar = "top1",           -- or "top2", "bottom1", "bottom2"
    position = "left",      -- or "center", "right"
    updateInterval = 1.0,   -- seconds
}

function MyPlugin:Initialize()
    -- Create frame
    self.frame = CreateFrame("Button", "AetherPlugin" .. self.name, UIParent)
    self.frame:SetSize(100, 24)
    
    -- Create text
    self.text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.text:SetPoint("CENTER")
    
    -- Set up events and tooltips
end

function MyPlugin:Update()
    -- Update display
    self.text:SetText("Your text here")
end

-- Register
if Aether.PluginSystem then
    Aether.PluginSystem:RegisterPlugin(MyPlugin)
end
```

## Utility Functions

### Formatting

```lua
-- Format money
Aether.U.FormatMoney(copperAmount)  -- "123g 45s 67c"

-- Format numbers
Aether.U.FormatNumber(1234567)       -- "1,234,567"

-- Format time
Aether.U.FormatTime(3661)            -- "01:01:01"
Aether.U.FormatTimeShort(3661)       -- "1.0h"

-- Format memory
Aether.U.FormatMemory(1024)          -- "1.00 MB"
```

### Colors

```lua
-- Color text
Aether.U.ColorText("Text", r, g, b)

-- Get class color
local r, g, b = Aether.U.GetClassColor("player")

-- Get item quality color
local r, g, b = Aether.U.GetItemQualityColor(3)  -- Epic = 3
```

### Tables

```lua
-- Deep copy
local copy = Aether.U.DeepCopy(table)

-- Merge tables
Aether.U.MergeTables(target, source)

-- Check if contains value
if Aether.U.TableContains(table, value) then end

-- Get table size
local size = Aether.U.TableSize(table)
```

### Player Info

```lua
-- Player info
Aether.U.GetPlayerName()        -- "PlayerName"
Aether.U.GetPlayerRealm()       -- "RealmName"
Aether.U.GetFullPlayerName()    -- "PlayerName-RealmName"
Aether.U.GetPlayerClass()       -- "WARRIOR"
Aether.U.GetPlayerLevel()       -- 70
Aether.U.GetPlayerFaction()     -- "Alliance"

-- State checks
Aether.U.IsInCombat()           -- true/false
Aether.U.IsResting()            -- true/false
```

### Game Data

```lua
-- Bag info
local free, total = Aether.U.GetBagSlotInfo()

-- Performance
local fps = Aether.U.GetFPS()
local home, world = Aether.U.GetLatency()
local memory = Aether.U.GetAddonMemory()

-- Items
Aether.U.IsJunkItem(itemLink)
Aether.U.IsItemSoulbound(bag, slot)
```

## Constants

```lua
-- Colors
Aether.C.COLORS.AETHER_BLUE
Aether.C.COLORS.GOLD
Aether.C.COLOR_CODES.AETHER     -- "|cff00CED1"
Aether.C.COLOR_CODES.CLOSE      -- "|r"

-- Panel
Aether.C.PANEL.DEFAULT_HEIGHT   -- 24
Aether.C.PANEL.DEFAULT_OPACITY  -- 0.8

-- Version detection
Aether.C.IS_RETAIL
Aether.C.IS_CLASSIC
Aether.C.IS_WAR_WITHIN
Aether.C.IS_MIDNIGHT
Aether.C.EXPANSION_LEVEL
```

## Event Handling

```lua
-- Register events
local frame = CreateFrame("Frame")
frame:RegisterEvent("EVENT_NAME")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "EVENT_NAME" then
        -- Handle event
    end
end)
```

## Common Events

| Event | When | Use For |
|-------|------|---------|
| `ADDON_LOADED` | Addon loads | Initialization |
| `PLAYER_LOGIN` | Player logs in | Post-init setup |
| `PLAYER_ENTERING_WORLD` | Enter world | World-specific setup |
| `BAG_UPDATE` | Bag changes | Update bag display |
| `PLAYER_MONEY` | Gold changes | Update gold display |
| `ZONE_CHANGED` | Zone changes | Update location |
| `MERCHANT_SHOW` | Merchant opened | Auto-repair/sell |
| `QUEST_DETAIL` | Quest offered | Auto-accept |
| `QUEST_COMPLETE` | Quest finished | Auto-turn-in |

## Localization

```lua
-- Get localized string
local text = Aether.L["KEY_NAME"]

-- Add translations in Locales/enUS.lua:
L["MY_KEY"] = "My Text"

-- Use in code:
Aether:Print(Aether.L["MY_KEY"])
```

## Testing

```lua
-- Enable debug mode
/aether debug

-- Reload UI
/reload

-- Check for errors
/console scriptErrors 1

-- Test specific feature
/aether panel  -- Toggle panel
/aether profile list  -- List profiles
```

## Debugging

```lua
-- Debug print
Aether:Debug("Debug info:", variable)

-- Safe function call
local success, result = pcall(function()
    -- Code that might error
end)

if not success then
    Aether:Error("Failed:", result)
end

-- Check if object exists
if SomeAPI and SomeAPI.Function then
    SomeAPI.Function()
end
```

## Performance

```lua
-- Throttle function
local throttled = Aether.U.Throttle(function()
    -- Called at most once per second
end, 1.0)

-- Debounce function
local debounced = Aether.U.Debounce(function()
    -- Called only after 1 second of no calls
end, 1.0)

-- Cache globals
local GetTime = GetTime
local floor = math.floor
```

## Combat Lockdown

```lua
-- Check before secure operations
if InCombatLockdown() then
    return  -- Don't modify protected frames
end

-- Wait for combat to end
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_ENABLED" then
        -- Safe to modify frames now
    end
end)
```

## Slash Commands

```lua
-- Add to Core/Commands.lua
function Cmd:HandleCommand(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, word:lower())
    end
    
    local command = args[1]
    
    if command == "mycommand" then
        -- Handle command
    end
end
```

## File Organization

### New Module
```
Modules/MyModule/
├── MyModule.xml       - Load order
├── MyModule.lua       - Main module
├── Feature1.lua       - Feature 1
└── Feature2.lua       - Feature 2
```

### New Plugin
```
Modules/Plugins/
└── MyPlugin.lua       - Self-contained plugin
```

## Code Style

- **Indentation:** 4 spaces (no tabs)
- **Naming:** camelCase for variables/functions, PascalCase for modules
- **Comments:** Use `--[[...]]--` for file headers, `--` for inline
- **Line length:** Keep under 120 characters
- **Globals:** Minimize, use local when possible

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: Add my feature"

# Push and create PR
git push origin feature/my-feature
```

## Resources

- **API Documentation:** https://warcraft.wiki.gg/
- **WowAce:** https://www.wowace.com/
- **Lua Reference:** https://www.lua.org/manual/5.1/
- **GitHub Repo:** https://github.com/JugoBetrugoTV/Aether

## Getting Help

1. Check this reference
2. Read the code documentation
3. Look at existing implementations
4. Ask in GitHub Discussions
5. Check WoW addon development resources

---

**Last Updated:** 2024-12-19
