# Contributing to Aether

Thank you for your interest in contributing to Aether! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:
- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Code Contributions
- Fix bugs
- Implement new features
- Improve performance
- Enhance documentation
- Add translations

### Non-Code Contributions
- Report bugs
- Suggest features
- Improve documentation
- Create textures/media
- Translate to other languages
- Help users in discussions

## Development Setup

### Prerequisites
- World of Warcraft (Retail, Classic, or Cataclysm)
- Git
- Text editor (VS Code, Sublime, Atom, etc.)
- Basic knowledge of Lua

### Setting Up Development Environment

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/Aether.git
   cd Aether
   ```

2. **Set up remote**
   ```bash
   git remote add upstream https://github.com/JugoBetrugoTV/Aether.git
   ```

3. **Install to WoW**
   - Create a symbolic link (recommended) or copy folder:
   ```bash
   # Windows (as Administrator)
   mklink /D "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\Aether" "C:\path\to\your\Aether"
   
   # macOS/Linux
   ln -s /path/to/your/Aether "/Applications/World of Warcraft/_retail_/Interface/AddOns/Aether"
   ```

4. **Install libraries** (see INSTALLATION.md)

5. **Enable debug mode**
   - In-game: `/aether debug`
   - In Core/Init.lua, set `Aether.debug = true`

### Testing Your Changes

1. **In-game testing**
   - Reload UI after changes: `/reload`
   - Test all affected features
   - Check for errors: `/console scriptErrors 1`

2. **Manual testing checklist**
   - Test with fresh character
   - Test with existing settings
   - Test profile switching
   - Test each modified feature
   - Verify no Lua errors

## Coding Standards

### Lua Style Guidelines

#### Indentation and Spacing
```lua
-- Use 4 spaces (not tabs)
function MyFunction()
    if condition then
        -- Indented block
    end
end

-- Space after commas
local table = {item1, item2, item3}

-- Spaces around operators
local result = value1 + value2
```

#### Naming Conventions
```lua
-- PascalCase for module/class names
local MyModule = {}

-- camelCase for functions
function myFunction()
end

-- camelCase for local variables
local myVariable = 10

-- UPPER_CASE for constants
local MAX_VALUE = 100

-- Descriptive names
local playerGold = 0  -- Good
local pg = 0          -- Bad
```

#### Comments
```lua
--[[
    Multi-line comment for file headers
    and function documentation
]]--

-- Single line comments for brief explanations

-- TODO: Add feature X
-- FIXME: Bug in Y
-- NOTE: Important information
```

#### Functions
```lua
--[[
    Function description
    
    @param param1 Description of param1
    @param param2 Description of param2
    @return Description of return value
]]--
function MyModule:MyFunction(param1, param2)
    -- Function body
    return result
end
```

#### Tables
```lua
-- Use consistent formatting
local table = {
    key1 = value1,
    key2 = value2,
    key3 = value3,
}

-- For arrays
local array = {
    "item1",
    "item2",
    "item3",
}
```

### WoW API Best Practices

```lua
-- Check for API availability
if C_SomeAPI and C_SomeAPI.SomeFunction then
    C_SomeAPI.SomeFunction()
end

-- Handle different WoW versions
if Aether.C.IS_RETAIL then
    -- Retail-specific code
elseif Aether.C.IS_CLASSIC then
    -- Classic-specific code
end

-- Use secure functions appropriately
-- Don't break combat lockdown
if InCombatLockdown() then
    return  -- Defer action
end
```

### Error Handling

```lua
-- Always use pcall for risky operations
local success, result = pcall(function()
    return riskyOperation()
end)

if not success then
    Aether:Error("Operation failed:", result)
    return
end

-- Validate inputs
function MyFunction(param)
    if not param then
        Aether:Error("Parameter required")
        return false
    end
    
    -- Function logic
    return true
end
```

### Performance Considerations

```lua
-- Cache global lookups
local GetTime = GetTime
local floor = math.floor

-- Throttle frequent updates
local lastUpdate = 0
local function OnUpdate()
    local now = GetTime()
    if now - lastUpdate < 1 then
        return
    end
    lastUpdate = now
    
    -- Update logic
end

-- Use events instead of OnUpdate when possible
frame:RegisterEvent("BAG_UPDATE")
frame:SetScript("OnEvent", OnBagUpdate)
```

## Submitting Changes

### Creating a Branch

```bash
# Update your fork
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/my-feature-name
```

### Making Changes

1. **Make your changes**
   - Focus on one feature/fix per branch
   - Keep changes minimal and focused
   - Test thoroughly

2. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: description of change"
   ```

### Commit Message Guidelines

```
# Format
<type>: <subject>

<body>

<footer>

# Types
feat: New feature
fix: Bug fix
docs: Documentation changes
style: Code style changes (formatting)
refactor: Code refactoring
test: Adding tests
chore: Maintenance tasks

# Examples
feat: Add XP plugin to panel system

Implemented experience tracking plugin with rested XP display
and time-to-level calculations.

Closes #123

fix: Correct gold calculation in Gold plugin

The session gold tracking was not properly resetting on reload.
Fixed by storing session start in saved variables.
```

### Creating a Pull Request

1. **Push to your fork**
   ```bash
   git push origin feature/my-feature-name
   ```

2. **Open Pull Request on GitHub**
   - Go to your fork on GitHub
   - Click "Pull Request"
   - Select your feature branch
   - Fill out the PR template
   - Describe your changes clearly
   - Reference any related issues

3. **PR Review Process**
   - Maintainers will review your code
   - Address any requested changes
   - Once approved, it will be merged

## Reporting Bugs

### Before Reporting
- Search existing issues
- Test with only Aether enabled
- Try latest version
- Check INSTALLATION.md

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
 - Aether Version: [e.g., 1.0.0]
 - WoW Version: [e.g., Retail 11.2.7]
 - Other Addons: [list them]

**Error Message**
```
Paste any error messages here
```

**Additional context**
Any other relevant information.
```

## Suggesting Features

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Any other relevant information, mockups, etc.
```

## Translation Contributions

Help translate Aether to more languages!

1. Copy `Locales/enUS.lua` to your language code (e.g., `ptBR.lua`)
2. Translate all strings
3. Add your locale to `Locales/Locales.xml`
4. Test in-game
5. Submit PR

## Documentation Contributions

Documentation improvements are always welcome!
- Fix typos
- Clarify instructions
- Add examples
- Improve formatting

## Questions?

- **GitHub Discussions**: For general questions
- **GitHub Issues**: For bug reports and feature requests
- **Discord**: Join our community (coming soon)

Thank you for contributing to Aether! 🎉
