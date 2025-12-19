# Changelog

All notable changes to Aether will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Complete implementation of all Leatrix Plus features
- Complete implementation of all Titan Panel plugins
- Full texture assets
- Enhanced theme system
- Cloud profile synchronization
- Plugin marketplace

## [1.0.0] - 2024-12-19

### Added

#### Core System
- Initial addon framework with modular architecture
- Saved variables system (AetherDB, AetherCharDB)
- Debug mode for troubleshooting
- Profile management system (create, delete, copy, rename)
- Profile import/export functionality
- Slash command interface (/aether, /ae)
- Complete constants and utilities library
- Multi-language support system

#### Panel System
- Titan Panel-style bar system
- Support for 4 main bars (Top 1/2, Bottom 1/2)
- Configurable bar height and opacity
- Plugin system with LibDataBroker support
- Plugin positioning (left, center, right)
- Auto-hide functionality
- Bar management system

#### Plugins
- **Bag Plugin** - Displays bag space with color coding
- **Clock Plugin** - Server and local time with 12/24h format
- **Gold Plugin** - Gold tracking with session statistics
- **Location Plugin** - Zone name and coordinates
- **Performance Plugin** - FPS, memory, and latency display
- **Repair Plugin** - Durability status (stub)
- **Volume Plugin** - Audio controls (stub)
- **XP Plugin** - Experience tracking (stub)
- **ItemLevel Plugin** - Average item level (stub)
- **Speed Plugin** - Movement speed (stub)
- **Currency Plugin** - Currency tracking (stub)

#### Automation Module
- Auto-accept quests
- Auto-turn-in quests (with reward selection)
- Auto-accept gossip options
- Auto-accept summon requests
- Auto-accept resurrection requests
- Auto-repair at vendors (with guild bank option)
- Auto-sell junk items
- Faster loot (reduced delay)

#### Social Module
- Block duel requests
- Block party invites
- Auto-accept party from friends/guild
- Social blocks system

#### Module Stubs
- Chat module framework
- Tooltip module framework
- Minimap module framework
- Frames module framework
- System module framework
- Media module framework
- Interface module framework

#### UI System
- Main options frame with category navigation
- Category selection system
- Theme management system
- Options panel framework
- Custom widgets framework

#### Themes
- **Aether Blue** (default) - Ethereal blue theme
- **Dark Mode** - Sleek dark theme
- **Classic Gold** - WoW classic gold theme
- **Midnight Purple** - Midnight expansion theme
- Custom theme support

#### Localization
- English (enUS) - Complete
- German (deDE) - Partial
- French (frFR) - Partial
- Spanish (esES) - Partial
- Italian (itIT) - Partial

#### Documentation
- Comprehensive README with features and usage
- Detailed INSTALLATION guide
- CONTRIBUTING guidelines
- Media assets README
- Inline code documentation
- Command reference

### Technical Details
- Modular architecture for easy maintenance
- Event-driven system for efficiency
- Lazy loading support
- Throttled updates for performance
- Safe function calls with error handling
- Deep table copying and merging utilities
- Version detection for WoW expansions
- Cross-version compatibility (11.2.7 and 12.0.0)

### Files Added
- 4 .toc files (Retail, Mainline, Vanilla, Cata)
- embeds.xml for library loading
- 6 Core files (Init, Constants, Utils, Profiles, Config, Commands)
- 5 Localization files (enUS, deDE, frFR, esES, itIT)
- 11 Module directories with base implementations
- 12 Plugin files
- 4 UI system files
- Media directory structure
- Documentation files (README, INSTALLATION, CONTRIBUTING, LICENSE)

### Known Limitations
- Libraries not included (must be downloaded separately)
- Texture assets are placeholders
- Some plugins are stubs (pending implementation)
- Some Leatrix Plus features not yet implemented
- Some Titan Panel features not yet implemented
- Options UI is basic (pending enhancement)

### Compatibility
- World of Warcraft Retail (11.2.7 - The War Within)
- World of Warcraft Midnight (12.0.0) - Prepared
- World of Warcraft Classic Era (1.15.3) - Prepared
- World of Warcraft Cataclysm Classic (4.4.0) - Prepared

### Dependencies
- Ace3 (AceAddon, AceDB, AceConfig, AceConsole, AceEvent, AceGUI, AceHook, AceLocale, AceTimer)
- LibSharedMedia-3.0
- LibDBIcon-1.0
- LibDataBroker-1.1
- LibQTip-1.0
- AceGUI-3.0-SharedMediaWidgets

## [0.1.0] - Development Phase

### In Development
- Core architecture
- Module system
- Plugin framework
- Basic implementations

---

## Release Notes Format

### Categories
- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Vulnerability fixes

### Version Format
- **Major.Minor.Patch** (e.g., 1.0.0)
- **Major** - Breaking changes
- **Minor** - New features (backward compatible)
- **Patch** - Bug fixes (backward compatible)

---

[Unreleased]: https://github.com/JugoBetrugoTV/Aether/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/JugoBetrugoTV/Aether/releases/tag/v1.0.0
