# Aether Libraries

This directory should contain the required WoW addon libraries.

## Required Libraries

Aether requires the following libraries to function. Download them from the links below and extract them to this directory.

### Core Libraries

1. **LibStub** - https://www.wowace.com/projects/libstub/files
   - Extract to: `Libs/LibStub/`

2. **CallbackHandler-1.0** - https://www.wowace.com/projects/callbackhandler/files
   - Extract to: `Libs/CallbackHandler-1.0/`

### Ace3 Suite

Download the complete Ace3 package: https://www.wowace.com/projects/ace3/files

Extract the following to `Libs/`:
- `AceAddon-3.0/`
- `AceDB-3.0/`
- `AceDBOptions-3.0/`
- `AceConfig-3.0/` (includes Core, Dialog, Registry)
- `AceConsole-3.0/`
- `AceEvent-3.0/`
- `AceGUI-3.0/`
- `AceHook-3.0/`
- `AceLocale-3.0/`
- `AceTimer-3.0/`

### Additional Libraries

3. **LibSharedMedia-3.0** - https://www.wowace.com/projects/libsharedmedia-3-0/files
   - Extract to: `Libs/LibSharedMedia-3.0/`

4. **LibDBIcon-1.0** - https://www.wowace.com/projects/libdbicon-1-0/files
   - Extract to: `Libs/LibDBIcon-1.0/`

5. **LibDataBroker-1.1** - https://github.com/tekkub/libdatabroker-1-1
   - Extract to: `Libs/LibDataBroker-1.1/`

6. **LibQTip-1.0** - https://www.wowace.com/projects/libqtip-1-0/files
   - Extract to: `Libs/LibQTip-1.0/`

7. **AceGUI-3.0-SharedMediaWidgets** - https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets/files
   - Extract to: `Libs/AceGUI-3.0-SharedMediaWidgets/`

## After Installing Libraries

Once all libraries are extracted to this directory, you must:

1. Open `embeds.xml` in the root Aether folder
2. Uncomment all the library include lines (remove `<!--` and `-->`)
3. Save the file
4. Restart WoW or reload UI (`/reload`)

## Directory Structure

After installation, your `Libs/` folder should look like this:

```
Libs/
├── README.md (this file)
├── LibStub/
│   └── LibStub.lua
├── CallbackHandler-1.0/
│   └── CallbackHandler-1.0.xml
├── AceAddon-3.0/
│   └── AceAddon-3.0.xml
├── AceDB-3.0/
│   └── AceDB-3.0.xml
├── AceDBOptions-3.0/
│   └── AceDBOptions-3.0.xml
├── AceConfig-3.0/
│   └── AceConfig-3.0.xml
├── AceConsole-3.0/
│   └── AceConsole-3.0.xml
├── AceEvent-3.0/
│   └── AceEvent-3.0.xml
├── AceGUI-3.0/
│   └── AceGUI-3.0.xml
├── AceHook-3.0/
│   └── AceHook-3.0.xml
├── AceLocale-3.0/
│   └── AceLocale-3.0.xml
├── AceTimer-3.0/
│   └── AceTimer-3.0.xml
├── LibSharedMedia-3.0/
│   └── lib.xml
├── LibDBIcon-1.0/
│   └── LibDBIcon-1.0.lua
├── LibDataBroker-1.1/
│   └── LibDataBroker-1.1.lua
├── LibQTip-1.0/
│   └── LibQTip-1.0.lua
└── AceGUI-3.0-SharedMediaWidgets/
    └── widget.xml
```

## Using Addon Managers

If you use **CurseForge**, **WoWUp**, or **Wago** addon managers, they will automatically download and manage these libraries for you. You don't need to manually download them.

## Troubleshooting

### Addon won't load
- Make sure all libraries are in the correct folders
- Check that `embeds.xml` has been uncommented
- Verify folder names match exactly (case-sensitive)

### Missing library errors
- Download the missing library from the links above
- Extract to the correct `Libs/` subfolder
- Reload UI (`/reload`)

## Note

Libraries are **NOT** included in this repository to keep the download size small and to respect the original authors' distribution methods. They must be downloaded separately or obtained through addon managers.
