# ARC GUI - Advanced UI Library for Roblox

## Overview
ARC GUI is an advanced UI library designed for Roblox, offering a modern and customizable interface. This library allows developers to create interactive and dynamic user interfaces with ease.

## Features
- Fully customizable UI themes
- Drag-and-drop functionality
- Animated windows and tabs
- Collapsible sections
- Buttons, toggles, sliders, and dropdowns
- Notification system

## Installation
To use ARC GUI in your Roblox project, insert the script into your game and require it.

```lua
local ARCGUI = loadstring()
```

## Getting Started
### Creating a Window
To create a main UI window, use the `CreateWindow` function:

```lua
local window = ARCGUI:CreateWindow({
    Title = "My UI",
    Size = UDim2.new(0, 650, 0, 500),
    Keybind = Enum.KeyCode.RightShift,
    Transparency = 0.1
})
```

### Adding Tabs
Tabs help organize UI elements within the window.

```lua
local mainTab = window:AddTab({ Name = "Main" })
```

### Adding Sections
Sections allow you to group elements inside tabs.

```lua
local settingsSection = mainTab:AddSection({ Name = "Settings", Expanded = true })
```

### Adding Elements
#### Buttons
```lua
settingsSection:AddButton({
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

#### Toggles
```lua
settingsSection:AddToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(state)
        print("Feature state: ", state)
    end
})
```

#### Sliders
```lua
settingsSection:AddSlider({
    Text = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Volume set to: ", value)
    end
})
```

#### Dropdowns
```lua
settingsSection:AddDropdown({
    Text = "Select Mode",
    Options = {"Easy", "Medium", "Hard"},
    Default = "Medium",
    Callback = function(selected)
        print("Mode selected: ", selected)
    end
})
```

### Notifications
You can send notifications within the UI.

```lua
window:Notify({
    Title = "Welcome",
    Text = "Thanks for using ARC GUI!",
    Duration = 3
})
```

## Keybinds
By default, pressing `RightShift` toggles the UI visibility. This can be customized when creating the window.

## License
This project is licensed under the MIT License. Feel free to use and modify it as needed.

## Credits
Developed by [Your Name].

