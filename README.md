# Kairo UI Library
# Supports PC and Mobile!

Loadstring
```lua
local Kairo = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzzavi335/Kairo-Ui-Library/refs/heads/main/source.luau"))
```

CreateWindow:
```lua
local Window = Kairo:CreateWindow({
    Title = "Kairo UI",
    Theme = "Crimson",
    Size = UDim2.fromOffset(520, 420),
    Center = true,
    Draggable = true,
    MinimizeKey = Enum.KeyCode.RightShift,
    Config = {
        Enabled = true,
        Folder = "Kairo",
        AutoLoad = true
    }
})
```
AddParagraph:
```lua
Window:AddParagraph(MainTab, "Welcome", "This is the Kairo UI Library with all features!")
```

AddTab:
```lua
local MainTab = Window:CreateTab("Main", "rbxassetid://16932740082")
```
AddButton:
```lua
Window:AddButton(MainTab, "Click Me", "This button shows a notification", "rbxassetid://16932740082", function()
    -- Code here
end)
```
AddToggle:
```lua
local MyToggle = Window:AddToggle(MainTab, "Enable Feature", "Toggle this feature on or off", false, function(state)
    -- Code here
end, "FeatureToggle")
```
AddInput:
```lua
local MyInput = Window:AddInput(MainTab, "Username", "Enter your username", "Player123", function(value)
    -- Code here
end, "UsernameInput")
```
AddSlider:
```lua
local MySlider = Window:AddSlider(MainTab, "Volume", "Adjust game volume", 0, 100, 50, function(value)
    -- Code here
end, "VolumeSlider")
```
AddDropdown:
```lua
local MyDropdown = Window:AddDropdown(MainTab, "Weapon", "Select your weapon", 
    {"Sword", "Axe", "Bow", "Staff"}, false, "Sword", function(value)
    -- Code here
end, "WeaponDropdown")
```
AddNotification:
```lua
Window:Notify({
    Title = "Kairo UI Loaded",
    Description = "Welcome",
    Content = "Press RightShift to toggle the UI",
    Color = Color3.fromRGB(200, 0, 50),
    Delay = 5
})
```

SetTheme: ( not needed )
```lua
Window:SetTheme("Forest") -- Changes theme to Forest
```

Configs Management: ( not needed )
```lua
-- Save current settings
Window:SaveConfig("MySettings")

-- Load settings
Window:LoadConfig("MySettings")

-- Delete config
Window:DeleteConfig("OldConfig")

-- Get all config names
local configs = Window:GetConfigs()
for _, name in ipairs(configs) do
    print("Config:", name)
end
```

Credit to Itzzavi
