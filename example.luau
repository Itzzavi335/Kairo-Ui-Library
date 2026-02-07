local Kairo = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzzavi335/Kairo-Ui-Library/refs/heads/main/source.luau"))()

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

local MainTab = Window:CreateTab("Main", "rbxassetid://16932740082")
local VisualsTab = Window:CreateTab("Visuals", "rbxassetid://16932740082")
local CombatTab = Window:CreateTab("Combat", "rbxassetid://16932740082")

Window:AddParagraph(MainTab, "Welcome to Kairo UI", "Complete UI library with all features included.")

Window:AddButton(MainTab, "Show Notification", "Display a sample notification", "rbxassetid://16932740082", function()
    Window:Notify({
        Title = "Kairo UI",
        Description = "Notification",
        Content = "This is a sample notification!",
        Color = Color3.fromRGB(200, 0, 50),
        Delay = 3
    })
end)

Window:AddToggle(MainTab, "Enable Feature", "Toggle this feature on or off", false, function(state)
    print("Toggle:", state)
end, "MainToggle")

Window:AddInput(MainTab, "Username", "Enter your username", "Player123", function(value)
    print("Input:", value)
end, "UsernameInput")

Window:AddDropdown(MainTab, "Weapon", "Select your weapon", {"Sword", "Axe", "Bow", "Staff"}, false, "Sword", function(value)
    print("Dropdown:", value)
end, "WeaponDropdown")

Window:AddSlider(MainTab, "Volume", "Adjust game volume", 0, 100, 50, function(value)
    print("Slider:", value)
end, "VolumeSlider")

Window:AddParagraph(VisualsTab, "Visual Settings", "Customize your visual experience.")

Window:AddToggle(VisualsTab, "ESP", "Show player outlines", true, function(state)
    print("ESP:", state)
end, "ESPToggle")

Window:AddToggle(VisualsTab, "Chams", "See players through walls", false, function(state)
    print("Chams:", state)
end, "ChamsToggle")

Window:AddSlider(VisualsTab, "Brightness", "Adjust screen brightness", 0, 100, 75, function(value)
    print("Brightness:", value)
end, "BrightnessSlider")

Window:AddDropdown(VisualsTab, "ESP Color", "Select ESP color", {"Red", "Green", "Blue", "Yellow", "Purple"}, false, "Red", function(value)
    print("ESP Color:", value)
end, "ESPColorDropdown")

Window:AddInput(VisualsTab, "ESP Filter", "Filter ESP by player name", "", function(value)
    print("ESP Filter:", value)
end, "ESPFilterInput")

Window:AddParagraph(CombatTab, "Combat Features", "Enable combat enhancements.")

Window:AddToggle(CombatTab, "Aimbot", "Automatic aiming assistance", false, function(state)
    print("Aimbot:", state)
end, "AimbotToggle")

Window:AddButton(CombatTab, "Kill All", "Eliminate all enemies", "rbxassetid://16932740082", function()
    print("Kill All activated!")
end)

Window:AddDropdown(CombatTab, "Target Mode", "Select targeting mode", {"Closest", "Farthest", "Random", "Highest Health", "Lowest Health"}, false, "Closest", function(value)
    print("Target Mode:", value)
end, "TargetModeDropdown")

Window:AddSlider(CombatTab, "Aimbot FOV", "Field of View for aimbot", 1, 100, 30, function(value)
    print("Aimbot FOV:", value)
end, "AimbotFOVSlider")

Window:AddInput(CombatTab, "Ignore List", "Players to ignore (comma separated)", "", function(value)
    print("Ignore List:", value)
end, "IgnoreListInput")

Window:AddParagraph(CombatTab, "Warning", "Use combat features responsibly and follow game rules.")

Window:Notify({
    Title = "Kairo UI Loaded",
    Description = "Success",
    Content = "Press RightShift to toggle the UI",
    Color = Color3.fromRGB(200, 0, 50),
    Delay = 5
})
