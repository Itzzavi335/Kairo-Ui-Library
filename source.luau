local Kairo = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui") or LocalPlayer.PlayerGui
local HttpService = game:GetService("HttpService")

local ThemeColors = {
    Default = Color3.fromRGB(255, 0, 255),
    Pink = Color3.fromRGB(255, 100, 200),
    Forest = Color3.fromRGB(0, 120, 80),
    Crimson = Color3.fromRGB(200, 0, 50),
    Blue = Color3.fromRGB(0, 120, 255),
    Red = Color3.fromRGB(255, 50, 50),
    Green = Color3.fromRGB(0, 200, 80),
    Orange = Color3.fromRGB(255, 120, 0),
    Purple = Color3.fromRGB(160, 0, 255),
    Cyan = Color3.fromRGB(0, 200, 255),
    Midnight = Color3.fromRGB(10, 30, 60),
    Ocean = Color3.fromRGB(0, 150, 200),
    Sunset = Color3.fromRGB(255, 100, 50),
    Gold = Color3.fromRGB(255, 200, 0),
    Emerald = Color3.fromRGB(0, 200, 150),
    Lavender = Color3.fromRGB(180, 130, 255),
    Teal = Color3.fromRGB(0, 150, 150),
    Rose = Color3.fromRGB(255, 100, 150),
    Sky = Color3.fromRGB(100, 180, 255),
    Amber = Color3.fromRGB(255, 150, 0),
    Neon = Color3.fromRGB(0, 255, 200),
    Royal = Color3.fromRGB(100, 0, 200)
}

local function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.9
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button
        
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        
        local Size = 0
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.Y * 1.5
        else
            Size = Button.AbsoluteSize.X * 1.5
        end

        local Time = 0.5
        Circle:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            "Out", "Quad", Time, false
        )
        
        for i = 1, 10 do
            Circle.ImageTransparency += 0.01
            wait(Time/10)
        end
        Circle:Destroy()
    end)
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

function Kairo:CreateWindow(Properties)
    local Config = Properties.Config or {}
    local Theme = Properties.Theme or "Default"
    local CurrentTheme = Theme
    local CurrentColor = ThemeColors[Theme]
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "KairoUI"
    ScreenGui.Parent = CoreGui

    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.Size = Properties.Size or UDim2.fromOffset(520, 420)
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = ScreenGui
    
    if Properties.Center then
        DropShadowHolder.Position = UDim2.new(0.5, -DropShadowHolder.Size.X.Offset/2, 0.5, -DropShadowHolder.Size.Y.Offset/2)
    else
        DropShadowHolder.Position = UDim2.new(0, 50, 0, 50)
    end

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    local Main = Instance.new("Frame")
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(50, 50, 50)
    UIStroke.Thickness = 1.6
    UIStroke.Parent = Main

    local Top = Instance.new("Frame")
    Top.BackgroundTransparency = 1
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Font = Enum.Font.GothamBold
    Title.Text = Properties.Title or "Kairo UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Parent = Top

    local Close = Instance.new("TextButton")
    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Image = "rbxassetid://9886659671"
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(1, -8, 1, -8)
    CloseIcon.Parent = Close

    local Min = Instance.new("TextButton")
    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundTransparency = 1
    Min.Position = UDim2.new(1, -42, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    Min.Name = "Min"
    Min.Parent = Top

    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Image = "rbxassetid://9886659276"
    MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinIcon.BackgroundTransparency = 1
    MinIcon.ImageTransparency = 0.2
    MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinIcon.Size = UDim2.new(1, -9, 1, -9)
    MinIcon.Parent = Min

    local MaxRestore = Instance.new("TextButton")
    MaxRestore.Font = Enum.Font.SourceSans
    MaxRestore.Text = ""
    MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
    MaxRestore.BackgroundTransparency = 1
    MaxRestore.Position = UDim2.new(1, -78, 0.5, 0)
    MaxRestore.Size = UDim2.new(0, 25, 0, 25)
    MaxRestore.Name = "MaxRestore"
    MaxRestore.Parent = Top

    local MaxIcon = Instance.new("ImageLabel")
    MaxIcon.Image = "rbxassetid://9886659406"
    MaxIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MaxIcon.BackgroundTransparency = 1
    MaxIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MaxIcon.Size = UDim2.new(1, -8, 1, -8)
    MaxIcon.Parent = MaxRestore

    local TabFrame = Instance.new("Frame")
    TabFrame.BackgroundTransparency = 1
    TabFrame.Position = UDim2.new(0, 9, 0, 50)
    TabFrame.Size = UDim2.new(0, 120, 1, -59)
    TabFrame.Name = "TabFrame"
    TabFrame.Parent = Main

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 2)
    TabCorner.Parent = TabFrame

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, -50)
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = TabFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 3)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll

    local ContentFrame = Instance.new("Frame")
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 138, 0, 50)
    ContentFrame.Size = UDim2.new(1, -147, 1, -59)
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 2)
    ContentCorner.Parent = ContentFrame

    local ContentTitle = Instance.new("TextLabel")
    ContentTitle.Font = Enum.Font.GothamBold
    ContentTitle.Text = "Main"
    ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContentTitle.TextSize = 24
    ContentTitle.TextWrapped = true
    ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
    ContentTitle.BackgroundTransparency = 1
    ContentTitle.Size = UDim2.new(1, 0, 0, 30)
    ContentTitle.Position = UDim2.new(0, 10, 0, 0)
    ContentTitle.Name = "ContentTitle"
    ContentTitle.Parent = ContentFrame

    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    ContentScroll.ScrollBarThickness = 0
    ContentScroll.Active = true
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.ClipsDescendants = true
    ContentScroll.Position = UDim2.new(0, 10, 0, 35)
    ContentScroll.Size = UDim2.new(1, -20, 1, -35)
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Parent = ContentFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ContentScroll

    local UIObjects = {
        Main = Main,
        DropShadowHolder = DropShadowHolder,
        ScreenGui = ScreenGui
    }

    local ThemeElements = {}
    local TabContents = {}
    local CurrentTab = nil
    local TabCount = 0
    
    local ToggleElements = {}
    local SliderElements = {}
    local DropdownElements = {}
    local TabElements = {}

    local function UpdateTabSize()
        local OffsetY = 0
        for _, child in TabScroll:GetChildren() do
            if child:IsA("Frame") then
                OffsetY += 3 + child.Size.Y.Offset
            end
        end
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end

    local function UpdateContentSize()
        if CurrentTab and TabContents[CurrentTab] then
            local OffsetY = 0
            for _, child in TabContents[CurrentTab]:GetChildren() do
                if child:IsA("Frame") then
                    OffsetY += 8 + child.Size.Y.Offset
                end
            end
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
    end

    TabScroll.ChildAdded:Connect(UpdateTabSize)
    TabScroll.ChildRemoved:Connect(UpdateTabSize)

    local function UpdateAllThemeElements(newColor)
        for _, toggle in pairs(ToggleElements) do
            if toggle and toggle:IsA("Frame") then
                local featureFrame = toggle:FindFirstChild("FeatureFrame")
                local toggleCircle = toggle:FindFirstChild("ToggleCircle")
                local frameStroke = featureFrame and featureFrame:FindFirstChild("UIStroke")
                local toggleTitle = toggle:FindFirstChild("ToggleTitle")
                
                if toggleCircle then
                    local isOn = toggleCircle.Position == UDim2.new(0, 15, 0, 0)
                    if isOn then
                        toggleCircle.BackgroundColor3 = newColor
                        if frameStroke then frameStroke.Color = newColor end
                        if toggleTitle then toggleTitle.TextColor3 = newColor end
                    end
                end
            end
        end
        
        for _, slider in pairs(SliderElements) do
            if slider and slider:IsA("Frame") then
                local sliderFill = slider:FindFirstChild("SliderFill")
                local sliderCircle = slider:FindFirstChild("SliderCircle")
                local circleStroke = sliderCircle and sliderCircle:FindFirstChild("UIStroke")
                
                if sliderFill then sliderFill.BackgroundColor3 = newColor end
                if sliderCircle then sliderCircle.BackgroundColor3 = newColor end
                if circleStroke then circleStroke.Color = newColor end
            end
        end
        
        for _, dropdown in pairs(DropdownElements) do
            if dropdown and dropdown:IsA("Frame") then
                local dropdownList = dropdown:FindFirstChild("DropdownList")
                if not dropdownList then
                    dropdownList = ScreenGui:FindFirstChild("DropdownList")
                end
                
                if dropdownList then
                    local listScroll = dropdownList:FindFirstChild("ListScroll")
                    if listScroll then
                        for _, option in listScroll:GetChildren() do
                            if option:IsA("Frame") and option.Name == "Option" then
                                local chooseFrame = option:FindFirstChild("ChooseFrame")
                                local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
                                local optionText = option:FindFirstChild("OptionText")
                                
                                if chooseFrame then chooseFrame.BackgroundColor3 = newColor end
                                if chooseStroke then chooseStroke.Color = newColor end
                                if optionText and optionText.TextColor3.r > 0.5 then
                                    optionText.TextColor3 = newColor
                                end
                            end
                        end
                    end
                end
            end
        end
        
        for _, tab in pairs(TabElements) do
            if tab and tab:IsA("Frame") then
                local chooseFrame = tab:FindFirstChild("ChooseFrame")
                local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
                
                if chooseFrame then chooseFrame.BackgroundColor3 = newColor end
                if chooseStroke then chooseStroke.Color = newColor end
            end
        end
        
        for _, element in pairs(ThemeElements) do
            if element and element:IsA("Frame") and element:FindFirstChild("ChooseFrame") then
                local chooseFrame = element.ChooseFrame
                if chooseFrame then
                    chooseFrame.BackgroundColor3 = newColor
                    local stroke = chooseFrame:FindFirstChild("UIStroke")
                    if stroke then stroke.Color = newColor end
                end
            end
        end
        
        return newColor
    end

    local function SetTheme(themeName)
        if ThemeColors[themeName] then
            CurrentTheme = themeName
            CurrentColor = ThemeColors[themeName]
            UpdateAllThemeElements(CurrentColor)
            return true, CurrentColor
        end
        return false, nil
    end

    local function CreateTab(Properties)
        local TabName = Properties.Name or "Tab"
        local IconId = Properties.Icon or ""
        
        TabCount += 1
        
        local Tab = Instance.new("Frame")
        Tab.BackgroundTransparency = 1
        Tab.Size = UDim2.new(1, 0, 0, 30)
        Tab.LayoutOrder = TabCount
        Tab.Name = "Tab"
        Tab.Parent = TabScroll

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = Tab

        local TabButton = Instance.new("TextButton")
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Text = TabName
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.Position = UDim2.new(0, 30, 0, 0)
        TabLabel.Name = "TabLabel"
        TabLabel.Parent = Tab

        local FeatureImg = Instance.new("ImageLabel")
        FeatureImg.Image = IconId
        FeatureImg.BackgroundTransparency = 1
        FeatureImg.Position = UDim2.new(0, 9, 0, 7)
        FeatureImg.Size = UDim2.new(0, 16, 0, 16)
        FeatureImg.Name = "FeatureImg"
        FeatureImg.Parent = Tab

        local ChooseFrame = Instance.new("Frame")
        ChooseFrame.BackgroundColor3 = CurrentColor
        ChooseFrame.BorderSizePixel = 0
        ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
        ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
        ChooseFrame.Name = "ChooseFrame"
        ChooseFrame.Parent = Tab
        ChooseFrame.Visible = false

        local ChooseStroke = Instance.new("UIStroke")
        ChooseStroke.Color = CurrentColor
        ChooseStroke.Thickness = 1.6
        ChooseStroke.Parent = ChooseFrame

        local ChooseCorner = Instance.new("UICorner")
        ChooseCorner.Parent = ChooseFrame
        
        table.insert(TabElements, Tab)
        
        local TabContent = Instance.new("Frame")
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.Visible = false
        TabContent.LayoutOrder = TabCount
        TabContent.Name = TabName.."Content"
        TabContent.Parent = ContentScroll
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = TabContent

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
        end)
        
        TabContents[TabName] = TabContent
        
        local function SwitchToTab()
            for name, container in pairs(TabContents) do
                container.Visible = false
            end
            
            for _, tabFrame in TabScroll:GetChildren() do
                if tabFrame:IsA("Frame") and tabFrame.Name == "Tab" then
                    local chooseFrame = tabFrame:FindFirstChild("ChooseFrame")
                    if chooseFrame then chooseFrame.Visible = false end
                    tabFrame.BackgroundTransparency = 1
                end
            end
            
            TabContent.Visible = true
            ChooseFrame.Visible = true
            Tab.BackgroundTransparency = 0.92
            ContentTitle.Text = TabName
            CurrentTab = TabName
        end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            SwitchToTab()
        end)
        
        if TabCount == 1 then
            SwitchToTab()
        end

        return {
            Name = TabName,
            Container = TabContent,
            Select = SwitchToTab
        }
    end

    local function CreateSection(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Section"
        local Content = Properties.Content or ""
        
        if not TabContents[TabName] then return end
        
        local Section = Instance.new("Frame")
        Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Section.BackgroundTransparency = 0.935
        Section.Size = UDim2.new(1, 0, 0, 46)
        Section.Name = "Section"
        Section.Parent = TabContents[TabName]

        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 4)
        SectionCorner.Parent = Section

        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.Text = Title
        SectionTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        SectionTitle.TextSize = 13
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Position = UDim2.new(0, 10, 0, 10)
        SectionTitle.Size = UDim2.new(1, -20, 0, 13)
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Parent = Section

        local SectionContent = Instance.new("TextLabel")
        SectionContent.Font = Enum.Font.GothamBold
        SectionContent.Text = Content
        SectionContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionContent.TextSize = 12
        SectionContent.TextTransparency = 0.6
        SectionContent.TextXAlignment = Enum.TextXAlignment.Left
        SectionContent.BackgroundTransparency = 1
        SectionContent.Position = UDim2.new(0, 10, 0, 23)
        SectionContent.Name = "SectionContent"
        SectionContent.Parent = Section

        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 40, math.huge))
        
        SectionContent.Size = UDim2.new(1, -20, 0, textSize.Y)
        SectionContent.TextWrapped = true
        Section.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33))

        return {
            Title = SectionTitle,
            Content = SectionContent,
            Frame = Section
        }
    end

    local function CreateButton(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Button"
        local Content = Properties.Content or ""
        local Icon = Properties.Icon or "rbxassetid://16932740082"
        local Callback = Properties.Callback
        
        if not TabContents[TabName] then return end
        
        local Button = Instance.new("Frame")
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundTransparency = 0.935
        Button.Size = UDim2.new(1, 0, 0, 46)
        Button.Name = "Button"
        Button.Parent = TabContents[TabName]

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        local ButtonTitle = Instance.new("TextLabel")
        ButtonTitle.Font = Enum.Font.GothamBold
        ButtonTitle.Text = Title
        ButtonTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        ButtonTitle.TextSize = 13
        ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
        ButtonTitle.BackgroundTransparency = 1
        ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
        ButtonTitle.Size = UDim2.new(1, -100, 0, 13)
        ButtonTitle.Name = "ButtonTitle"
        ButtonTitle.Parent = Button

        local ButtonContent = Instance.new("TextLabel")
        ButtonContent.Font = Enum.Font.GothamBold
        ButtonContent.Text = Content
        ButtonContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonContent.TextSize = 12
        ButtonContent.TextTransparency = 0.6
        ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
        ButtonContent.BackgroundTransparency = 1
        ButtonContent.Position = UDim2.new(0, 10, 0, 23)
        ButtonContent.Name = "ButtonContent"
        ButtonContent.Parent = Button
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 120, math.huge))
        
        ButtonContent.Size = UDim2.new(1, -100, 0, textSize.Y)
        ButtonContent.TextWrapped = true
        Button.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33))

        local ButtonButton = Instance.new("TextButton")
        ButtonButton.Font = Enum.Font.SourceSans
        ButtonButton.Text = ""
        ButtonButton.BackgroundTransparency = 1
        ButtonButton.Size = UDim2.new(1, 0, 1, 0)
        ButtonButton.Name = "ButtonButton"
        ButtonButton.Parent = Button

        local FeatureFrame = Instance.new("Frame")
        FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
        FeatureFrame.BackgroundTransparency = 1
        FeatureFrame.Position = UDim2.new(1, -15, 0.5, 0)
        FeatureFrame.Size = UDim2.new(0, 25, 0, 25)
        FeatureFrame.Name = "FeatureFrame"
        FeatureFrame.Parent = Button

        local FeatureImg = Instance.new("ImageLabel")
        FeatureImg.Image = Icon
        FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
        FeatureImg.BackgroundTransparency = 1
        FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        FeatureImg.Size = UDim2.new(1, 0, 1, 0)
        FeatureImg.Name = "FeatureImg"
        FeatureImg.Parent = FeatureFrame

        ButtonButton.Activated:Connect(function()
            CircleClick(ButtonButton, Mouse.X, Mouse.Y)
            if Callback then Callback() end
        end)

        return {
            Title = ButtonTitle,
            Content = ButtonContent,
            Frame = Button,
            Button = ButtonButton
        }
    end

    local function CreateToggle(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Toggle"
        local Content = Properties.Content or ""
        local Default = Properties.Default or false
        local Callback = Properties.Callback
        
        if not TabContents[TabName] then return end
        
        local Toggle = Instance.new("Frame")
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.BackgroundTransparency = 0.935
        Toggle.Size = UDim2.new(1, 0, 0, 46)
        Toggle.Name = "Toggle"
        Toggle.Parent = TabContents[TabName]

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = Toggle

        local ToggleTitle = Instance.new("TextLabel")
        ToggleTitle.Font = Enum.Font.GothamBold
        ToggleTitle.Text = Title
        ToggleTitle.TextSize = 13
        ToggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        ToggleTitle.BackgroundTransparency = 1
        ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
        ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
        ToggleTitle.Name = "ToggleTitle"
        ToggleTitle.Parent = Toggle

        local ToggleContent = Instance.new("TextLabel")
        ToggleContent.Font = Enum.Font.GothamBold
        ToggleContent.Text = Content
        ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleContent.TextSize = 12
        ToggleContent.TextTransparency = 0.6
        ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
        ToggleContent.BackgroundTransparency = 1
        ToggleContent.Position = UDim2.new(0, 10, 0, 23)
        ToggleContent.Size = UDim2.new(1, -100, 0, 12)
        ToggleContent.Name = "ToggleContent"
        ToggleContent.Parent = Toggle
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 120, math.huge))
        
        ToggleContent.Size = UDim2.new(1, -100, 0, textSize.Y)
        ToggleContent.TextWrapped = true
        Toggle.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33))

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = Toggle

        local FeatureFrame = Instance.new("Frame")
        FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
        FeatureFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        FeatureFrame.BackgroundTransparency = 0.2
        FeatureFrame.Position = UDim2.new(1, -30, 0.5, 0)
        FeatureFrame.Size = UDim2.new(0, 30, 0, 15)
        FeatureFrame.Name = "FeatureFrame"
        FeatureFrame.Parent = Toggle

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.Parent = FeatureFrame

        local FrameStroke = Instance.new("UIStroke")
        FrameStroke.Color = Color3.fromRGB(100, 100, 100)
        FrameStroke.Thickness = 1.5
        FrameStroke.Parent = FeatureFrame

        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Position = Default and UDim2.new(0, 15, 0, 0) or UDim2.new(0, 0, 0, 0)
        ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
        ToggleCircle.Name = "ToggleCircle"
        ToggleCircle.Parent = FeatureFrame

        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(0, 15)
        CircleCorner.Parent = ToggleCircle
        
        table.insert(ToggleElements, Toggle)
        
        local State = Default or false
        
        local function UpdateState(value)
            State = value
            if value then
                TweenService:Create(
                    ToggleTitle,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextColor3 = CurrentColor}
                ):Play()
                TweenService:Create(
                    ToggleCircle,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(0, 15, 0, 0), BackgroundColor3 = CurrentColor}
                ):Play()
                TweenService:Create(
                    FrameStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Color = CurrentColor}
                ):Play()
            else
                TweenService:Create(
                    ToggleTitle,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextColor3 = Color3.fromRGB(230, 230, 230)}
                ):Play()
                TweenService:Create(
                    ToggleCircle,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}
                ):Play()
                TweenService:Create(
                    FrameStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Color = Color3.fromRGB(100, 100, 100)}
                ):Play()
            end
            if Callback then Callback(State) end
        end
        
        UpdateState(State)
        
        ToggleButton.Activated:Connect(function()
            CircleClick(ToggleButton, Mouse.X, Mouse.Y) 
            UpdateState(not State)
        end)

        return {
            Value = State,
            Set = UpdateState,
            Title = ToggleTitle,
            Content = ToggleContent,
            Frame = Toggle
        }
    end

    local function CreateInput(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Input"
        local Content = Properties.Content or ""
        local Placeholder = Properties.Placeholder or "Enter text..."
        local Default = Properties.Default or ""
        local Callback = Properties.Callback
        
        if not TabContents[TabName] then return end
        
        local Input = Instance.new("Frame")
        Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Input.BackgroundTransparency = 0.935
        Input.Size = UDim2.new(1, 0, 0, 46)
        Input.Name = "Input"
        Input.Parent = TabContents[TabName]

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 4)
        InputCorner.Parent = Input

        local InputTitle = Instance.new("TextLabel")
        InputTitle.Font = Enum.Font.GothamBold
        InputTitle.Text = Title
        InputTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        InputTitle.TextSize = 13
        InputTitle.TextXAlignment = Enum.TextXAlignment.Left
        InputTitle.BackgroundTransparency = 1
        InputTitle.Position = UDim2.new(0, 10, 0, 10)
        InputTitle.Size = UDim2.new(1, -180, 0, 13)
        InputTitle.Name = "InputTitle"
        InputTitle.Parent = Input

        local InputContent = Instance.new("TextLabel")
        InputContent.Font = Enum.Font.GothamBold
        InputContent.Text = Content
        InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputContent.TextSize = 12
        InputContent.TextTransparency = 0.6
        InputContent.TextWrapped = true
        InputContent.TextXAlignment = Enum.TextXAlignment.Left
        InputContent.BackgroundTransparency = 1
        InputContent.Position = UDim2.new(0, 10, 0, 23)
        InputContent.Size = UDim2.new(1, -180, 0, 12)
        InputContent.Name = "InputContent"
        InputContent.Parent = Input
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 200, math.huge))
        
        InputContent.Size = UDim2.new(1, -180, 0, textSize.Y)
        InputContent.TextWrapped = true
        Input.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33))

        local InputFrame = Instance.new("Frame")
        InputFrame.AnchorPoint = Vector2.new(1, 0.5)
        InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        InputFrame.BackgroundTransparency = 0.95
        InputFrame.ClipsDescendants = true
        InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
        InputFrame.Size = UDim2.new(0, 148, 0, 30)
        InputFrame.Name = "InputFrame"
        InputFrame.Parent = Input

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 4)
        FrameCorner.Parent = InputFrame

        local InputTextBox = Instance.new("TextBox")
        InputTextBox.CursorPosition = -1
        InputTextBox.Font = Enum.Font.GothamBold
        InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        InputTextBox.PlaceholderText = Placeholder
        InputTextBox.Text = Default
        InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputTextBox.TextSize = 12
        InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
        InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
        InputTextBox.BackgroundTransparency = 1
        InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
        InputTextBox.Size = UDim2.new(1, -10, 1, -8)
        InputTextBox.Name = "InputTextBox"
        InputTextBox.Parent = InputFrame
        
        local inputData = {
            Value = Default
        }
        
        function inputData:Set(value)
            InputTextBox.Text = value
            inputData.Value = value
            if Callback then Callback(value) end
        end
        
        InputTextBox.FocusLost:Connect(function(enterPressed)
            inputData:Set(InputTextBox.Text)
        end)

        return inputData
    end

    local function CreateDropdown(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Dropdown"
        local Content = Properties.Content or ""
        local Options = Properties.Options or {}
        local Multi = Properties.Multi or false
        local Default = Properties.Default or nil
        local Callback = Properties.Callback
        
        if not TabContents[TabName] then return end
        
        local Dropdown = Instance.new("Frame")
        Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dropdown.BackgroundTransparency = 0.935
        Dropdown.Size = UDim2.new(1, 0, 0, 46)
        Dropdown.Name = "Dropdown"
        Dropdown.Parent = TabContents[TabName]

        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 4)
        DropdownCorner.Parent = Dropdown

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Text = ""
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = Dropdown

        local DropdownTitle = Instance.new("TextLabel")
        DropdownTitle.Font = Enum.Font.GothamBold
        DropdownTitle.Text = Title
        DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        DropdownTitle.TextSize = 13
        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        DropdownTitle.BackgroundTransparency = 1
        DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
        DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
        DropdownTitle.Name = "DropdownTitle"
        DropdownTitle.Parent = Dropdown

        local DropdownContent = Instance.new("TextLabel")
        DropdownContent.Font = Enum.Font.GothamBold
        DropdownContent.Text = Content
        DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownContent.TextSize = 12
        DropdownContent.TextTransparency = 0.6
        DropdownContent.TextWrapped = true
        DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
        DropdownContent.BackgroundTransparency = 1
        DropdownContent.Position = UDim2.new(0, 10, 0, 23)
        DropdownContent.Size = UDim2.new(1, -180, 0, 12)
        DropdownContent.Name = "DropdownContent"
        DropdownContent.Parent = Dropdown
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 200, math.huge))
        
        DropdownContent.Size = UDim2.new(1, -180, 0, textSize.Y)
        DropdownContent.TextWrapped = true
        Dropdown.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33))

        local SelectOptionsFrame = Instance.new("Frame")
        SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
        SelectOptionsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SelectOptionsFrame.BackgroundTransparency = 0.95
        SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
        SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
        SelectOptionsFrame.Name = "SelectOptionsFrame"
        SelectOptionsFrame.Parent = Dropdown

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 4)
        FrameCorner.Parent = SelectOptionsFrame

        local OptionSelecting = Instance.new("TextLabel")
        OptionSelecting.Font = Enum.Font.GothamBold
        OptionSelecting.Text = "Select Option"
        OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionSelecting.TextSize = 12
        OptionSelecting.TextTransparency = 0.6
        OptionSelecting.TextWrapped = true
        OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
        OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
        OptionSelecting.BackgroundTransparency = 1
        OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
        OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
        OptionSelecting.Name = "OptionSelecting"
        OptionSelecting.Parent = SelectOptionsFrame

        local OptionImg = Instance.new("ImageLabel")
        OptionImg.Image = "rbxassetid://16851841101"
        OptionImg.ImageColor3 = Color3.fromRGB(230, 230, 230)
        OptionImg.AnchorPoint = Vector2.new(1, 0.5)
        OptionImg.BackgroundTransparency = 1
        OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
        OptionImg.Size = UDim2.new(0, 25, 0, 25)
        OptionImg.Name = "OptionImg"
        OptionImg.Parent = SelectOptionsFrame
        
        local DropdownList = Instance.new("Frame")
        DropdownList.AnchorPoint = Vector2.new(1, 0)
        DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownList.BorderSizePixel = 0
        DropdownList.Position = UDim2.new(1, -12, 0, 35)
        DropdownList.Size = UDim2.new(0, 160, 0, 0)
        DropdownList.Name = "DropdownList"
        DropdownList.Visible = false
        DropdownList.ClipsDescendants = true
        DropdownList.ZIndex = 10
        DropdownList.Parent = ScreenGui

        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 4)
        ListCorner.Parent = DropdownList

        local ListStroke = Instance.new("UIStroke")
        ListStroke.Color = Color3.fromRGB(255, 255, 255)
        ListStroke.Thickness = 2.5
        ListStroke.Transparency = 0.8
        ListStroke.Parent = DropdownList

        local ListScroll = Instance.new("ScrollingFrame")
        ListScroll.ScrollBarThickness = 0
        ListScroll.Active = true
        ListScroll.BackgroundTransparency = 1
        ListScroll.Size = UDim2.new(1, -10, 1, -10)
        ListScroll.Position = UDim2.new(0, 5, 0, 5)
        ListScroll.Name = "ListScroll"
        ListScroll.ZIndex = 11
        ListScroll.Parent = DropdownList

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 3)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = ListScroll
        
        table.insert(DropdownElements, Dropdown)
        
        local dropdownData = {
            Options = Options,
            Value = Multi and (Default or {}) or Default,
            Multi = Multi,
            Open = false
        }
        
        local function UpdateListSize()
            local totalHeight = 0
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") then
                    totalHeight += child.Size.Y.Offset + 3
                end
            end
            ListScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
            DropdownList.Size = UDim2.new(0, 160, 0, math.min(150, totalHeight + 10))
        end
        
        local function UpdateSelectedDisplay()
            if dropdownData.Multi then
                if #dropdownData.Value > 0 then
                    local displayText = ""
                    for i, v in ipairs(dropdownData.Value) do
                        if i > 3 then
                            displayText = displayText .. ", ..."
                            break
                        end
                        displayText = displayText .. (i > 1 and ", " or "") .. v
                    end
                    OptionSelecting.Text = displayText
                else
                    OptionSelecting.Text = "Select Option"
                end
            else
                OptionSelecting.Text = dropdownData.Value or "Select Option"
            end
        end
        
        local function ToggleDropdown()
            dropdownData.Open = not dropdownData.Open
            if dropdownData.Open then
                local dropdownAbsPos = Dropdown.AbsolutePosition
                local dropdownAbsSize = Dropdown.AbsoluteSize
                DropdownList.Position = UDim2.new(0, dropdownAbsPos.X + dropdownAbsSize.X - 172, 0, dropdownAbsPos.Y + dropdownAbsSize.Y + 5)
                
                DropdownList.Visible = true
                TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(0, 160, 0, math.min(150, ListScroll.CanvasSize.Y.Offset + 10))}):Play()
                TweenService:Create(OptionImg, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(0, 160, 0, 0)}):Play()
                TweenService:Create(OptionImg, TweenInfo.new(0.3), {Rotation = 0}):Play()
                task.wait(0.3)
                DropdownList.Visible = false
            end
        end
        
        local function CreateOption(optionName)
            local Option = Instance.new("Frame")
            Option.BackgroundTransparency = 0.999
            Option.BorderSizePixel = 0
            Option.Size = UDim2.new(1, 0, 0, 30)
            Option.Name = "Option"
            Option.ZIndex = 12
            Option.Parent = ListScroll

            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 3)
            OptionCorner.Parent = Option

            local OptionButton = Instance.new("TextButton")
            OptionButton.Font = Enum.Font.GothamBold
            OptionButton.Text = ""
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 1, 0)
            OptionButton.Name = "OptionButton"
            OptionButton.ZIndex = 13
            OptionButton.Parent = Option

            local OptionText = Instance.new("TextLabel")
            OptionText.Font = Enum.Font.GothamBold
            OptionText.Text = optionName
            OptionText.TextSize = 13
            OptionText.TextColor3 = Color3.fromRGB(230, 230, 230)
            OptionText.TextXAlignment = Enum.TextXAlignment.Left
            OptionText.BackgroundTransparency = 1
            OptionText.Position = UDim2.new(0, 8, 0, 8)
            OptionText.Size = UDim2.new(1, -16, 0, 13)
            OptionText.Name = "OptionText"
            OptionText.ZIndex = 14
            OptionText.Parent = Option

            local ChooseFrame = Instance.new("Frame")
            ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
            ChooseFrame.BackgroundColor3 = CurrentColor
            ChooseFrame.BorderSizePixel = 0
            ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
            ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
            ChooseFrame.Name = "ChooseFrame"
            ChooseFrame.ZIndex = 15
            ChooseFrame.Parent = Option
            
            local ChooseStroke = Instance.new("UIStroke")
            ChooseStroke.Color = CurrentColor
            ChooseStroke.Thickness = 1.6
            ChooseStroke.Transparency = 0.999
            ChooseStroke.ZIndex = 16
            ChooseStroke.Parent = ChooseFrame
            
            local ChooseCorner = Instance.new("UICorner")
            ChooseCorner.Parent = ChooseFrame
            
            local function UpdateOptionVisual()
                local isSelected = false
                if dropdownData.Multi then
                    isSelected = table.find(dropdownData.Value, optionName) ~= nil
                else
                    isSelected = dropdownData.Value == optionName
                end
                
                if isSelected then
                    TweenService:Create(ChooseStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
                    TweenService:Create(ChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 1, 0, 12)}):Play()
                    TweenService:Create(Option, TweenInfo.new(0.2), {BackgroundTransparency = 0.935}):Play()
                    TweenService:Create(OptionText, TweenInfo.new(0.2), {TextColor3 = CurrentColor}):Play()
                else
                    TweenService:Create(ChooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
                    TweenService:Create(ChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(Option, TweenInfo.new(0.2), {BackgroundTransparency = 0.999}):Play()
                    TweenService:Create(OptionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                end
            end
            
            OptionButton.Activated:Connect(function()
                CircleClick(OptionButton, Mouse.X, Mouse.Y)
                
                if dropdownData.Multi then
                    local index = table.find(dropdownData.Value, optionName)
                    if index then
                        table.remove(dropdownData.Value, index)
                    else
                        table.insert(dropdownData.Value, optionName)
                    end
                else
                    for _, child in ListScroll:GetChildren() do
                        if child:IsA("Frame") and child.Name == "Option" then
                            local childChooseFrame = child:FindFirstChild("ChooseFrame")
                            local childChooseStroke = childChooseFrame and childChooseFrame:FindFirstChild("UIStroke")
                            local childOptionText = child:FindFirstChild("OptionText")
                            
                            if childOptionText and childOptionText.Text ~= optionName then
                                if childChooseStroke then
                                    TweenService:Create(childChooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
                                end
                                if childChooseFrame then
                                    TweenService:Create(childChooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                                end
                                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 0.999}):Play()
                                TweenService:Create(childOptionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                            end
                        end
                    end
                    
                    dropdownData.Value = optionName
                end
                
                UpdateOptionVisual()
                UpdateSelectedDisplay()
                
                if Callback then
                    Callback(dropdownData.Value)
                end
                
                if not dropdownData.Multi then
                    ToggleDropdown()
                end
            end)
            
            UpdateOptionVisual()
            return Option
        end
        
        for _, option in ipairs(dropdownData.Options) do
            CreateOption(option)
        end
        
        UpdateListSize()
        UpdateSelectedDisplay()
        
        DropdownButton.Activated:Connect(function()
            CircleClick(DropdownButton, Mouse.X, Mouse.Y)
            ToggleDropdown()
        end)
        
        local dropdownConnection
        dropdownConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dropdownData.Open and DropdownList.Visible then
                    local mousePos = input.Position
                    local dropdownPos = DropdownList.AbsolutePosition
                    local dropdownSize = DropdownList.AbsoluteSize
                    local selectFramePos = SelectOptionsFrame.AbsolutePosition
                    local selectFrameSize = SelectOptionsFrame.AbsoluteSize
                    
                    if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                           mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) and
                       not (mousePos.X >= selectFramePos.X and mousePos.X <= selectFramePos.X + selectFrameSize.X and
                           mousePos.Y >= selectFramePos.Y and mousePos.Y <= selectFramePos.Y + selectFrameSize.Y) then
                        ToggleDropdown()
                    end
                end
            end
        end)
        
        Dropdown.Destroying:Connect(function()
            if dropdownConnection then dropdownConnection:Disconnect() end
            DropdownList:Destroy()
        end)
        
        local dropdownFunc = {}
        dropdownFunc.Value = dropdownData.Value
        dropdownFunc.Options = dropdownData.Options
        
        function dropdownFunc:Set(value)
            if dropdownData.Multi then
                dropdownData.Value = value or {}
            else
                dropdownData.Value = value
            end
            UpdateSelectedDisplay()
            
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") and child.Name == "Option" then
                    local optionName = child.OptionText.Text
                    local isSelected = false
                    if dropdownData.Multi then
                        isSelected = table.find(dropdownData.Value, optionName) ~= nil
                    else
                        isSelected = dropdownData.Value == optionName
                    end
                    
                    local chooseFrame = child:FindFirstChild("ChooseFrame")
                    local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
                    local optionText = child:FindFirstChild("OptionText")
                    if chooseFrame and chooseStroke and optionText then
                        if isSelected then
                            TweenService:Create(chooseStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
                            TweenService:Create(chooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 1, 0, 12)}):Play()
                            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 0.935}):Play()
                            TweenService:Create(optionText, TweenInfo.new(0.2), {TextColor3 = CurrentColor}):Play()
                        else
                            TweenService:Create(chooseStroke, TweenInfo.new(0.2), {Transparency = 0.999}):Play()
                            TweenService:Create(chooseFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 0.999}):Play()
                            TweenService:Create(optionText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                        end
                    end
                end
            end
        end
        
        function dropdownFunc:Refresh(newOptions, newValue)
            for _, child in ListScroll:GetChildren() do
                if child:IsA("Frame") then child:Destroy() end
            end
            
            dropdownData.Options = newOptions or {}
            dropdownData.Value = newValue or (dropdownData.Multi and {} or nil)
            
            for _, option in ipairs(dropdownData.Options) do
                CreateOption(option)
            end
            
            UpdateListSize()
            UpdateSelectedDisplay()
            dropdownFunc.Value = dropdownData.Value
            dropdownFunc.Options = dropdownData.Options
        end
        
        return dropdownFunc
    end

    local function CreateSlider(Properties)
        local TabName = Properties.Tab
        local Title = Properties.Title or "Slider"
        local Content = Properties.Content or ""
        local Min = Properties.Min or 0
        local Max = Properties.Max or 100
        local Default = Properties.Default or Min
        local Callback = Properties.Callback
        
        if not TabContents[TabName] then return end
        
        local Slider = Instance.new("Frame")
        Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Slider.BackgroundTransparency = 0.935
        Slider.Size = UDim2.new(1, 0, 0, 46)
        Slider.Name = "Slider"
        Slider.Parent = TabContents[TabName]

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = Slider

        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Font = Enum.Font.GothamBold
        SliderTitle.Text = Title
        SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        SliderTitle.TextSize = 13
        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position = UDim2.new(0, 10, 0, 10)
        SliderTitle.Size = UDim2.new(1, -60, 0, 13)
        SliderTitle.Name = "SliderTitle"
        SliderTitle.Parent = Slider

        local SliderContent = Instance.new("TextLabel")
        SliderContent.Font = Enum.Font.GothamBold
        SliderContent.Text = Content
        SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderContent.TextSize = 12
        SliderContent.TextTransparency = 0.6
        SliderContent.TextXAlignment = Enum.TextXAlignment.Left
        SliderContent.BackgroundTransparency = 1
        SliderContent.Position = UDim2.new(0, 10, 0, 23)
        SliderContent.Size = UDim2.new(1, -60, 0, 12)
        SliderContent.Name = "SliderContent"
        SliderContent.Parent = Slider
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Content, 12, Enum.Font.GothamBold, Vector2.new(ContentScroll.AbsoluteSize.X - 80, math.huge))
        
        SliderContent.Size = UDim2.new(1, -60, 0, textSize.Y)
        SliderContent.TextWrapped = true

        local ValueDisplay = Instance.new("TextLabel")
        ValueDisplay.Font = Enum.Font.GothamBold
        ValueDisplay.Text = tostring(Default or Min)
        ValueDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueDisplay.TextSize = 13
        ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        ValueDisplay.AnchorPoint = Vector2.new(1, 0)
        ValueDisplay.BackgroundTransparency = 1
        ValueDisplay.Position = UDim2.new(1, -10, 0, 10)
        ValueDisplay.Size = UDim2.new(0, 40, 0, 13)
        ValueDisplay.Name = "ValueDisplay"
        ValueDisplay.Parent = Slider

        Slider.Size = UDim2.new(1, 0, 0, math.max(46, textSize.Y + 33 + 25))
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.AnchorPoint = Vector2.new(0, 0)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderFrame.BackgroundTransparency = 0.5
        SliderFrame.Position = UDim2.new(0, 10, 0, textSize.Y + 33)
        SliderFrame.Size = UDim2.new(1, -20, 0, 3)
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Parent = Slider

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 2)
        FrameCorner.Parent = SliderFrame

        local SliderFill = Instance.new("Frame")
        SliderFill.AnchorPoint = Vector2.new(0, 0.5)
        SliderFill.BackgroundColor3 = CurrentColor
        SliderFill.Position = UDim2.new(0, 0, 0.5, 0)
        SliderFill.Size = UDim2.new(0.5, 0, 0, 3)
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderFrame

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 2)
        FillCorner.Parent = SliderFill

        local SliderCircle = Instance.new("Frame")
        SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        SliderCircle.BackgroundColor3 = CurrentColor
        SliderCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        SliderCircle.Size = UDim2.new(0, 12, 0, 12)
        SliderCircle.Name = "SliderCircle"
        SliderCircle.Parent = SliderFrame

        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(0, 6)
        CircleCorner.Parent = SliderCircle

        local CircleStroke = Instance.new("UIStroke")
        CircleStroke.Color = Color3.fromRGB(255, 255, 255)
        CircleStroke.Thickness = 1
        CircleStroke.Parent = SliderCircle
        
        table.insert(SliderElements, SliderFrame)
        
        local sliderData = {
            Min = Min,
            Max = Max,
            Value = Default or Min,
            Dragging = false,
            TouchInput = nil
        }
        
        local function Round(num, decimalPlaces)
            local mult = 10^(decimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end
        
        local function SetValue(value, instant)
            value = math.clamp(value, sliderData.Min, sliderData.Max)
            sliderData.Value = Round(value, 0)
            
            ValueDisplay.Text = tostring(sliderData.Value)
            
            local percentage = (sliderData.Value - sliderData.Min) / (sliderData.Max - sliderData.Min)
            
            if instant then
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderCircle.Position = UDim2.new(percentage, 0, 0.5, 0)
            else
                TweenService:Create(
                    SliderFill,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(percentage, 0, 1, 0)}
                ):Play()
                TweenService:Create(
                    SliderCircle,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = UDim2.new(percentage, 0, 0.5, 0)}
                ):Play()
            end
            
            if Callback then Callback(sliderData.Value) end
        end
        
        SetValue(Default or Min, true)
        
        local function UpdateSliderFromInput(input)
            local inputPos
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                inputPos = input.Position
            elseif input.UserInputType == Enum.UserInputType.Touch then
                inputPos = input.Position
            else return end
            
            local sliderPos = SliderFrame.AbsolutePosition
            local sliderSize = SliderFrame.AbsoluteSize
            
            local percentage = math.clamp((inputPos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = sliderData.Min + (percentage * (sliderData.Max - sliderData.Min))
            
            SetValue(value)
        end
        
        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliderData.Dragging = true
                sliderData.TouchInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
                UpdateSliderFromInput(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliderData.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
               (input.UserInputType == Enum.UserInputType.Touch and sliderData.TouchInput and input == sliderData.TouchInput)) then
                UpdateSliderFromInput(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 and sliderData.Dragging) or
               (input.UserInputType == Enum.UserInputType.Touch and sliderData.TouchInput and input == sliderData.TouchInput) then
                sliderData.Dragging = false
                sliderData.TouchInput = nil
            end
        end)
        
        local sliderFunc = {}
        sliderFunc.Value = sliderData.Value
        
        function sliderFunc:Set(value)
            SetValue(value)
            sliderFunc.Value = sliderData.Value
        end
        
        return sliderFunc
    end

    local function CreateNotification(Properties)
        local Title = Properties.Title or "Notification"
        local Description = Properties.Description or "Description"
        local Content = Properties.Content or "Content"
        local Color = Properties.Color or CurrentColor
        local Time = Properties.Time or 0.5
        local Delay = Properties.Delay or 5
        
        spawn(function()
            if not CoreGui:FindFirstChild("NotifyGui") then
                local NotifyGui = Instance.new("ScreenGui")
                NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                NotifyGui.Name = "NotifyGui"
                NotifyGui.Parent = CoreGui
            end
            
            if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
                local NotifyLayout = Instance.new("Frame")
                NotifyLayout.AnchorPoint = Vector2.new(1, 1)
                NotifyLayout.BackgroundTransparency = 0.999
                NotifyLayout.BorderSizePixel = 0
                NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
                NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
                NotifyLayout.Name = "NotifyLayout"
                NotifyLayout.Parent = CoreGui.NotifyGui
                
                local Count = 0
                CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                    Count = 0
                    for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                        TweenService:Create(
                            v,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12)*Count))}
                        ):Play()
                        Count = Count + 1
                    end
                end)
            end
            
            local NotifyPosHeight = 0
            for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                NotifyPosHeight = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
            end
            
            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.BackgroundTransparency = 1
            NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
            NotifyFrame.Name = "NotifyFrame"
            NotifyFrame.AnchorPoint = Vector2.new(0, 1)
            NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeight))
            NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout

            local NotifyFrameReal = Instance.new("Frame")
            NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
            NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
            NotifyFrameReal.Name = "NotifyFrameReal"
            NotifyFrameReal.Parent = NotifyFrame

            local UICorner = Instance.new("UICorner")
            UICorner.Parent = NotifyFrameReal

            local DropShadowHolder = Instance.new("Frame")
            DropShadowHolder.BackgroundTransparency = 1
            DropShadowHolder.BorderSizePixel = 0
            DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
            DropShadowHolder.ZIndex = 0
            DropShadowHolder.Name = "DropShadowHolder"
            DropShadowHolder.Parent = NotifyFrameReal

            local DropShadow = Instance.new("ImageLabel")
            DropShadow.Image = "rbxassetid://6015897843"
            DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            DropShadow.ImageTransparency = 0.5
            DropShadow.ScaleType = Enum.ScaleType.Slice
            DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
            DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            DropShadow.BackgroundTransparency = 1
            DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            DropShadow.Size = UDim2.new(1, 47, 1, 47)
            DropShadow.ZIndex = 0
            DropShadow.Name = "DropShadow"
            DropShadow.Parent = DropShadowHolder

            local Top = Instance.new("Frame")
            Top.BackgroundTransparency = 1
            Top.Size = UDim2.new(1, 0, 0, 36)
            Top.Name = "Top"
            Top.Parent = NotifyFrameReal

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = Title
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Position = UDim2.new(0, 10, 0, 0)
            TextLabel.Parent = Top

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.Thickness = 0.3
            UIStroke.Parent = TextLabel

            local UICorner1 = Instance.new("UICorner")
            UICorner1.Parent = Top

            local TextLabel1 = Instance.new("TextLabel")
            TextLabel1.Font = Enum.Font.GothamBold
            TextLabel1.Text = Description
            TextLabel1.TextColor3 = Color
            TextLabel1.TextSize = 14
            TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel1.BackgroundTransparency = 1
            TextLabel1.Size = UDim2.new(1, 0, 1, 0)
            TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
            TextLabel1.Parent = Top

            local UIStroke1 = Instance.new("UIStroke")
            UIStroke1.Color = Color
            UIStroke1.Thickness = 0.4
            UIStroke1.Parent = TextLabel1

            local Close = Instance.new("TextButton")
            Close.Font = Enum.Font.SourceSans
            Close.Text = ""
            Close.AnchorPoint = Vector2.new(1, 0.5)
            Close.BackgroundTransparency = 1
            Close.Position = UDim2.new(1, -5, 0.5, 0)
            Close.Size = UDim2.new(0, 25, 0, 25)
            Close.Name = "Close"
            Close.Parent = Top

            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Image = "rbxassetid://9886659671"
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.new(0.49, 0, 0.5, 0)
            ImageLabel.Size = UDim2.new(1, -8, 1, -8)
            ImageLabel.Parent = Close

            local TextLabel2 = Instance.new("TextLabel")
            TextLabel2.Font = Enum.Font.GothamBold
            TextLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
            TextLabel2.TextSize = 13
            TextLabel2.Text = Content
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Position = UDim2.new(0, 10, 0, 27)
            TextLabel2.Parent = NotifyFrameReal
            TextLabel2.Size = UDim2.new(1, -20, 0, 13)

            TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
            TextLabel2.TextWrapped = true

            if TextLabel2.AbsoluteSize.Y < 27 then
                NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
            else
                NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
            end
            
            local waitbruh = false
            local function CloseNotification()
                if waitbruh then return false end
                waitbruh = true
                TweenService:Create(
                    NotifyFrameReal,
                    TweenInfo.new(Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(0, 400, 0, 0)}
                ):Play()
                task.wait(Time / 1.2)
                NotifyFrame:Destroy()
            end
            
            Close.Activated:Connect(CloseNotification)
            
            TweenService:Create(
                NotifyFrameReal,
                TweenInfo.new(Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                {Position = UDim2.new(0, 0, 0, 0)}
            ):Play()
            task.wait(Delay)
            CloseNotification()
        end)
    end

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)

    local OldPos = DropShadowHolder.Position
    local OldSize = DropShadowHolder.Size
    
    MaxRestore.Activated:Connect(function()
        CircleClick(MaxRestore, Mouse.X, Mouse.Y)
        if MaxIcon.Image == "rbxassetid://9886659406" then
            MaxIcon.Image = "rbxassetid://9886659001"
            OldPos = DropShadowHolder.Position
            OldSize = DropShadowHolder.Size
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        else
            MaxIcon.Image = "rbxassetid://9886659406"
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos}):Play()
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Size = OldSize}):Play()
        end
    end)

    if Properties.MinimizeKey then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Properties.MinimizeKey then
                DropShadowHolder.Visible = not DropShadowHolder.Visible
            end
        end)
    end

    if Properties.Draggable then
        MakeDraggable(Top, DropShadowHolder)
    end

    UpdateTabSize()

    return {
        Tab = CreateTab,
        Section = CreateSection,
        Button = CreateButton,
        Toggle = CreateToggle,
        Input = CreateInput,
        Dropdown = CreateDropdown,
        Slider = CreateSlider,
        Notification = CreateNotification,
        SetTheme = SetTheme,
        Themes = ThemeColors,
        UI = {
            Main = Main,
            Holder = DropShadowHolder,
            Gui = ScreenGui
        }
    }
end

return Kairo
