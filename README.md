# Aether - All-in-One WoW Addon

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![WoW](https://img.shields.io/badge/WoW-11.2.7%20%7C%2012.0.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**Aether** is a comprehensive World of Warcraft addon that combines all features from **Leatrix Plus** and **Titan Panel** into one beautiful, cohesive package.

</div>

---

## ✨ Features

### 🎛️ Titan Panel System
- **Multiple Bars** - Up to 4 main bars (2 top, 2 bottom) + 10 movable short bars
- **Built-in Plugins** - Bag, Clock, Gold, Location, Performance, Repair, Volume, XP, and more
- **Customizable** - Adjust height, opacity, colors, and positioning
- **Auto-hide** - Automatically hide bars when not needed
- **LibDataBroker Support** - Compatible with other LDB plugins

### 🤖 Automation Features
- **Quest Automation** - Auto-accept and turn in quests
- **Auto-Repair** - Automatic gear repair at vendors (guild bank support)
- **Auto-Sell** - Automatically sell junk items
- **Auto-Accept** - Summons, resurrections, and more
- **Faster Interactions** - Faster looting and movie skipping

### 👥 Social Features
- **Block System** - Block duels, pet battles, party invites, etc.
- **Auto-Accept** - Auto-accept from friends and guild members
- **Whisper Invites** - Whisper-based party invitations

### 💬 Chat Enhancements
- **Hide Elements** - Combat log, chat buttons, etc.
- **More Options** - Increase history, disable fade, arrow keys
- **Class Colors** - See class colors in chat
- **Customization** - Move editbox, adjust font sizes

### 🖼️ Interface Enhancements
- **Tooltip Improvements** - Item level, spec/role, health bars
- **Minimap Options** - Square minimap, combined buttons, scaling
- **Frame Management** - Move, scale, and hide UI frames
- **Class Colored Frames** - Color frames by class

### ⚙️ System Tweaks
- **Graphics** - Disable screen effects, alter weather
- **Camera** - Extended camera zoom distance
- **Audio** - Mute specific sounds, silence emotes
- **Performance** - Various performance optimizations

### 🎨 Visual Design
- **Multiple Themes** - Aether Blue, Dark Mode, Classic Gold, Midnight Purple
- **Custom Colors** - Create your own color schemes
- **Smooth Animations** - Fade effects and transitions
- **Professional Look** - Clean, modern interface design

### 📊 Profile System
- **Multiple Profiles** - Create unlimited profiles
- **Easy Switching** - Quick profile switching via command
- **Import/Export** - Share profiles with others
- **Per-Character** - Different settings for each character

---

## 📥 Installation

### Method 1: Manual Installation
1. Download the latest release from [GitHub Releases](https://github.com/JugoBetrugoTV/Aether/releases)
2. Extract the `Aether` folder to your WoW AddOns directory:
   - **Retail**: `World of Warcraft\_retail_\Interface\AddOns\`
   - **Classic Era**: `World of Warcraft\_classic_era_\Interface\AddOns\`
   - **Cataclysm**: `World of Warcraft\_classic_\Interface\AddOns\`
3. Restart WoW or reload UI (`/reload`)

### Method 2: Addon Manager
- **CurseForge**: Search for "Aether" in the CurseForge app
- **WoWUp**: Available through WoWUp addon manager
- **Wago**: Find it on Wago.io addon platform

### Required Libraries
Aether requires the following libraries (typically auto-downloaded by addon managers):
- Ace3 (complete suite)
- LibSharedMedia-3.0
- LibDBIcon-1.0
- LibDataBroker-1.1
- LibQTip-1.0

---

## 🎮 Usage

### Quick Start
1. Type `/aether` or `/ae` to open the options menu
2. Enable the features you want (everything is OFF by default)
3. Customize panel bars and plugins
4. Create profiles for different characters

### Slash Commands
```
/aether                  - Open main options
/ae                      - Shortcut for /aether

/aether panel            - Toggle panel visibility
/aether config           - Open configuration
/aether reset            - Reset all settings to defaults
/aether debug            - Toggle debug mode
/aether help             - Show help information
/aether version          - Show addon version

Profile Management:
/aether profile list     - List all profiles
/aether profile load <name> - Load a profile
/aether profile create <name> - Create new profile
/aether profile delete <name> - Delete a profile
/aether profile copy <source> <target> - Copy profile
/aether profile reset [name] - Reset profile to defaults
```

### Panel Configuration
The panel system can be configured through the options menu:
1. Open `/aether` and select "Panel"
2. Enable/disable individual bars (Top 1/2, Bottom 1/2)
3. Adjust bar height and opacity
4. Configure which plugins appear on each bar
5. Customize plugin positions (left, center, right)

### Plugin System
Built-in plugins include:
- **Bag** - Shows available bag space
- **Clock** - Server time and local time
- **Gold** - Gold tracking with session statistics
- **Location** - Current zone and coordinates
- **Performance** - FPS, memory, and latency
- **Repair** - Durability and repair costs
- **Volume** - Quick audio controls
- **XP** - Experience tracking (hides at max level)

Additional plugins can be enabled in settings.

---

## 🌍 Localization

Aether is fully localized in:
- 🇬🇧 English (enUS)
- 🇩🇪 German (deDE)
- 🇫🇷 French (frFR)
- 🇪🇸 Spanish (esES)
- 🇮🇹 Italian (itIT)

Help improve translations on [GitHub](https://github.com/JugoBetrugoTV/Aether/tree/main/Locales)!

---

## 🔧 Configuration

### Default Settings
All features are **disabled by default** (following Leatrix Plus philosophy). You must enable the features you want to use.

### Profiles
Create different profiles for different characters or situations:
- **PvE Profile** - Quest automation, auto-repair, etc.
- **PvP Profile** - Performance optimizations, minimal UI
- **Leveling Profile** - All automation features enabled
- **Raiding Profile** - Performance mode, reduced updates

### Themes
Choose from pre-made themes or create your own:
1. Open `/aether` > Themes
2. Select a theme or click "Custom"
3. Adjust colors for primary, secondary, and background
4. Apply to see changes immediately

---

## 🛠️ Development

### Project Structure
```
Aether/
├── Core/                 # Core addon functionality
├── Libs/                 # Required libraries (not included)
├── Locales/              # Language files
├── Media/                # Textures, fonts, sounds
├── Modules/              # Feature modules
│   ├── Automation/       # Quest, repair, sell automation
│   ├── Chat/             # Chat enhancements
│   ├── Frames/           # Frame management
│   ├── Interface/        # Interface tweaks
│   ├── Minimap/          # Minimap enhancements
│   ├── Panel/            # Panel system
│   ├── Plugins/          # Panel plugins
│   ├── Social/           # Social features
│   ├── System/           # System tweaks
│   ├── Tooltip/          # Tooltip enhancements
│   └── Media/            # Music/movie player
└── UI/                   # Options UI
```

### Contributing
Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Use 4 spaces for indentation (no tabs)
- Follow existing code style
- Comment complex logic
- Test thoroughly before submitting
- Update documentation as needed

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

### Inspiration
- **Leatrix Plus** - For comprehensive interface enhancements
- **Titan Panel** - For the panel system and plugin architecture

### Libraries
- **Ace3** - Framework and UI libraries
- **LibSharedMedia** - Shared media resources
- **LibDBIcon** - Minimap button support
- **LibDataBroker** - Plugin data broker
- **LibQTip** - Enhanced tooltips

### Community
Special thanks to the WoW addon development community for their tools, libraries, and support.

---

## 📞 Support

### Getting Help
- **Issues**: [GitHub Issues](https://github.com/JugoBetrugoTV/Aether/issues)
- **Discussions**: [GitHub Discussions](https://github.com/JugoBetrugoTV/Aether/discussions)
- **Discord**: Join our Discord server (coming soon)

### Reporting Bugs
When reporting bugs, please include:
1. Aether version
2. WoW version (Retail/Classic/Cataclysm)
3. Steps to reproduce
4. Error message (if any)
5. List of other addons installed

### Feature Requests
Feature requests are welcome! Please check existing issues first to avoid duplicates.

---

## 🗺️ Roadmap

### Version 1.1
- [ ] Complete all Leatrix Plus features
- [ ] Add all Titan Panel plugins
- [ ] Improve theme system
- [ ] Add more localization support

### Version 1.2
- [ ] Profile sharing via in-game links
- [ ] Advanced plugin customization
- [ ] Minimap button addon consolidation
- [ ] Performance optimizations

### Version 2.0
- [ ] Midnight (12.0.0) compatibility
- [ ] New UI framework
- [ ] Plugin marketplace
- [ ] Cloud profile sync

---

## 📈 Changelog

### Version 1.0.0 (Initial Release)
- ✨ Core addon framework
- ✨ Panel system with plugin architecture
- ✨ Basic automation features (quests, repair, sell)
- ✨ Social features (blocks, auto-accept)
- ✨ Core plugins (Bag, Clock, Gold, Location, Performance)
- ✨ Profile system with import/export
- ✨ Theme system with 4 pre-made themes
- ✨ Full localization support (5 languages)
- ✨ Slash command interface
- ✨ Basic UI options panel

---

<div align="center">

**Made with ❤️ for the WoW Community**

[Report Bug](https://github.com/JugoBetrugoTV/Aether/issues) · [Request Feature](https://github.com/JugoBetrugoTV/Aether/issues) · [Contribute](https://github.com/JugoBetrugoTV/Aether/pulls)

</div>