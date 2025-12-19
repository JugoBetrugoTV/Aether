# Aether Media Assets

This directory contains all media assets for the Aether addon.

## Directory Structure

### Textures/
- **Panel/** - Panel bar backgrounds, borders, gradients, and highlights
- **Buttons/** - Button textures for different states (normal, hover, pressed)
- **Icons/** - Addon logo and module icons
- **Misc/** - Tooltip backgrounds, dividers, glow effects

### Fonts/
- Custom fonts for the addon (optional)
- Uses LibSharedMedia-3.0 for font management

### Sounds/
- UI sound effects (optional)

## Texture Format

All textures should be in **.tga** format (32-bit with alpha channel) for best compatibility with WoW.

## Creating Textures

For production use, create the following textures:

### Panel Textures (Textures/Panel/)
1. **bar-background.tga** - Main panel background (2048x32 pixels)
2. **bar-border.tga** - Border decoration (2048x32 pixels)
3. **bar-highlight.tga** - Hover/selection highlight (2048x32 pixels)
4. **bar-gradient.tga** - Optional gradient overlay (2048x32 pixels)

### Button Textures (Textures/Buttons/)
1. **button-normal.tga** - Default button state (64x32 pixels)
2. **button-hover.tga** - Hovered button state (64x32 pixels)
3. **button-pressed.tga** - Pressed button state (64x32 pixels)
4. **minimap-icon.tga** - Minimap button icon (32x32 pixels)

### Icons (Textures/Icons/)
1. **aether-logo.tga** - Main addon logo (64x64 pixels)
2. **module-icons.tga** - Icon atlas for module categories (512x512 pixels)

### Misc Textures (Textures/Misc/)
1. **tooltip-bg.tga** - Tooltip background (256x256 pixels)
2. **divider.tga** - UI divider line (512x2 pixels)
3. **glow.tga** - Glow effect for highlights (64x64 pixels)

## Color Schemes

The addon supports multiple color schemes:
- **Aether Blue** (default) - #00CED1
- **Dark Mode** - Dark theme with subtle highlights
- **Classic Gold** - WoW classic gold accents
- **Midnight Purple** - For the Midnight expansion
- **Custom** - User-defined colors

## Tools for Creating Textures

Recommended tools:
- **Adobe Photoshop** - Professional image editing
- **GIMP** - Free alternative to Photoshop
- **Paint.NET** - Lightweight image editor
- **Blender** - For 3D-rendered UI elements

## Notes

- All textures should have an alpha channel for transparency
- Use power-of-2 dimensions when possible (32, 64, 128, 256, 512, 1024, 2048)
- Keep file sizes reasonable for addon distribution
- Test textures in-game at different UI scales
- Consider creating both standard and high-resolution versions

## Placeholder Files

This initial release uses placeholder textures. Community contributions for high-quality textures are welcome!

To contribute textures, please:
1. Follow the size and format guidelines above
2. Use the color schemes defined in Core/Constants.lua
3. Include both normal and high-DPI versions if possible
4. Submit via GitHub pull request
