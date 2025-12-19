# Installation and Setup Guide

This guide will help you install and configure Aether for World of Warcraft.

## Prerequisites

- World of Warcraft (Retail, Classic, or Cataclysm)
- Basic knowledge of WoW addons

## Installation Steps

### Step 1: Download Aether

Choose one of these methods:

#### Option A: GitHub Release (Recommended)
1. Go to [Aether Releases](https://github.com/JugoBetrugoTV/Aether/releases)
2. Download the latest `Aether-X.X.X.zip` file
3. Extract the ZIP file

#### Option B: Clone Repository
```bash
git clone https://github.com/JugoBetrugoTV/Aether.git
cd Aether
```

#### Option C: Addon Manager
Use CurseForge, WoWUp, or Wago addon managers to install automatically.

### Step 2: Install Required Libraries

Aether requires several libraries to function. These are typically included with addon managers but must be installed manually for GitHub downloads.

Download these libraries from WowAce:
1. **Ace3** - https://www.wowace.com/projects/ace3/files
2. **LibSharedMedia-3.0** - https://www.wowace.com/projects/libsharedmedia-3-0/files
3. **LibDBIcon-1.0** - https://www.wowace.com/projects/libdbicon-1-0/files
4. **LibDataBroker-1.1** - https://github.com/tekkub/libdatabroker-1-1
5. **LibQTip-1.0** - https://www.wowace.com/projects/libqtip-1-0/files
6. **AceGUI-3.0-SharedMediaWidgets** - https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets/files

### Step 3: Place Files in AddOns Directory

#### Windows
```
C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\Aether
```

#### macOS
```
/Applications/World of Warcraft/_retail_/Interface/AddOns/Aether
```

#### Linux
```
~/.wine/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/Aether
```

**Note**: Replace `_retail_` with `_classic_era_` or `_classic_` for other versions.

### Step 4: Extract Libraries

Place downloaded libraries in the `Aether/Libs/` directory:
```
Aether/
├── Libs/
│   ├── LibStub/
│   ├── CallbackHandler-1.0/
│   ├── AceAddon-3.0/
│   ├── AceDB-3.0/
│   ├── (... other Ace3 libraries)
│   ├── LibSharedMedia-3.0/
│   ├── LibDBIcon-1.0/
│   ├── LibDataBroker-1.1/
│   ├── LibQTip-1.0/
│   └── AceGUI-3.0-SharedMediaWidgets/
```

### Step 5: Enable Libraries in embeds.xml

Edit `Aether/embeds.xml` and uncomment the library includes:

```xml
<!-- Change this: -->
<!-- <Script file="Libs\LibStub\LibStub.lua"/> -->

<!-- To this: -->
<Script file="Libs\LibStub\LibStub.lua"/>
```

Do this for all library includes in the file.

### Step 6: Restart WoW

1. Close World of Warcraft completely
2. Start World of Warcraft
3. At the character selection screen, click "AddOns"
4. Verify that "Aether" is listed and checked
5. Log in to your character

## First-Time Setup

### Initial Configuration

1. Type `/aether` or `/ae` to open the options menu
2. You'll see the welcome screen

### Enable Panel

1. Select "Panel" from the left menu
2. Check "Enable Panel"
3. Enable the bars you want to see:
   - Top Bar 1
   - Top Bar 2 (optional)
   - Bottom Bar 1 (optional)
   - Bottom Bar 2 (optional)

### Configure Plugins

1. Select "Plugins" from the left menu
2. Enable the plugins you want to display:
   - Bag (shows bag space)
   - Clock (server/local time)
   - Gold (gold tracking)
   - Location (zone and coordinates)
   - Performance (FPS, latency, memory)
   - Repair (durability)
   - Volume (audio controls)
   - XP (experience bar)

3. Configure plugin positions:
   - Left - Typically for gold, location
   - Center - For clock or other centered info
   - Right - For bag, performance, repair

### Enable Automation

1. Select "Automation" from the left menu
2. Enable desired automation features:
   - Auto Accept Quests
   - Auto Turn In Quests
   - Auto Repair (with guild bank option)
   - Auto Sell Junk
   - Auto Accept Summon
   - Faster Loot

### Configure Social Features

1. Select "Social" from the left menu
2. Enable desired social features:
   - Block Duels (prevents duel spam)
   - Block Party Invites (with whitelist for friends)
   - Auto Accept Party from Friends/Guild

### Customize Appearance

1. Select "Themes" from the menu
2. Choose a pre-made theme:
   - Aether Blue (default)
   - Dark Mode
   - Classic Gold
   - Midnight Purple
3. Or create a custom theme

## Troubleshooting

### Addon Not Loading

**Problem**: Aether doesn't appear in addon list

**Solutions**:
1. Verify the folder is named exactly "Aether" (case-sensitive)
2. Check that the .toc file exists in the Aether folder
3. Make sure you're looking in the correct WoW version folder
4. Try running WoW as administrator (Windows)

### Missing Libraries Error

**Problem**: "Aether requires library X" error

**Solutions**:
1. Download the missing library from WowAce
2. Extract it to `Aether/Libs/LibraryName/`
3. Uncomment the library include in `embeds.xml`
4. Reload UI (`/reload`)

### Panel Not Showing

**Problem**: Panel enabled but not visible

**Solutions**:
1. Type `/aether panel` to toggle visibility
2. Check that at least one bar is enabled in settings
3. Verify panel is enabled in "Panel" settings
4. Make sure you have plugins enabled
5. Try `/reload` to refresh the UI

### Plugins Not Displaying

**Problem**: Plugins enabled but not showing on panel

**Solutions**:
1. Ensure the panel is enabled
2. Check that the bar the plugin is assigned to is enabled
3. Verify the plugin is enabled in "Plugins" settings
4. Some plugins (like XP) hide automatically at max level
5. Try `/reload`

### Performance Issues

**Problem**: Game lag or low FPS with Aether enabled

**Solutions**:
1. Disable unused plugins
2. Increase plugin update intervals in settings
3. Enable "Performance Mode" in System settings
4. Reduce panel opacity for better FPS
5. Disable animations in settings

### Slash Commands Not Working

**Problem**: `/aether` command does nothing

**Solutions**:
1. Check that Aether is enabled in addon list
2. Try `/ae` as an alternative
3. Look for error messages in chat
4. Type `/console scriptErrors 1` to enable error display
5. Check for addon conflicts

## Advanced Setup

### Creating Profiles

1. Type `/aether profile create MyProfile`
2. Configure settings as desired
3. Switch between profiles with `/aether profile load ProfileName`

### Exporting Profiles

1. Type `/aether profile export`
2. Copy the encoded string
3. Share with others or save for backup

### Importing Profiles

1. Obtain a profile string from another user
2. Type `/aether profile import`
3. Paste the string when prompted
4. The profile will be imported as "Imported"

### Keyboard Shortcuts

Set up keybindings in WoW's Key Bindings menu:
1. Press ESC > Key Bindings
2. Scroll to "Aether" section
3. Bind keys to common actions:
   - Toggle Panel
   - Toggle Main Menu
   - Toggle Specific Bars

## Addon Compatibility

### Known Compatible Addons
- ElvUI (some features may conflict)
- Bartender4 (works alongside)
- Bagnon/AdiBags (compatible)
- WeakAuras (fully compatible)
- DBM/BigWigs (fully compatible)

### Known Conflicts
- Other Titan Panel addons (not recommended together)
- Leatrix Plus (feature overlap, choose one)
- Some UI replacement addons may conflict

### Resolving Conflicts
1. Disable conflicting addons temporarily
2. Test Aether alone to verify it works
3. Re-enable addons one at a time
4. Report persistent conflicts on GitHub

## Getting Help

If you're still having issues:

1. **Check the FAQ** - Most common issues are covered
2. **Search GitHub Issues** - Someone may have had the same problem
3. **Enable Debug Mode** - Type `/aether debug` and check for error messages
4. **Report Bug** - Create a detailed bug report on GitHub

### Information to Include in Bug Reports
- Aether version (`/aether version`)
- WoW version (Retail/Classic/Cataclysm)
- Steps to reproduce the issue
- Any error messages
- List of other addons installed
- Screenshots if applicable

## Next Steps

Once installed and configured:
1. Explore all the settings categories
2. Customize to your playstyle
3. Create profiles for different characters
4. Join our community on Discord (coming soon)
5. Contribute to the project on GitHub

---

**Need more help?** Visit our [GitHub Issues](https://github.com/JugoBetrugoTV/Aether/issues) page.
