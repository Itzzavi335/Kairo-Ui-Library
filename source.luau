-- Kairo UI Library
local Kairo = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Functions
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
        
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        local Time = 0.5
        
        Circle:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            "Out", "Quad", Time, false
        )
        
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.01
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

-- Create Notification
local function MakeNotify(NotifyConfig)
    local Title = NotifyConfig.Title or "Notification"
    local Description = NotifyConfig.Description or "Description"
    local Content = NotifyConfig.Content or "Content"
    local Color = NotifyConfig.Color or Color3.fromRGB(255, 0, 255)
    local Time = NotifyConfig.Time or 0.5
    local Delay = NotifyConfig.Delay or 5
    
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
            NotifyLayout.BackgroundTransparency = 1
            NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
            NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.NotifyGui
        end
        
        local NotifyPosHeight = 0
        for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
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
        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = NotifyFrameReal

        local Top = Instance.new("Frame")
        Top.BackgroundTransparency = 1
        Top.Size = UDim2.new(1, 0, 0, 36)
        Top.Name = "Top"
        Top.Parent = NotifyFrameReal

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = Title
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, 0, 1, 0)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.Parent = Top

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Font = Enum.Font.GothamBold
        DescLabel.Text = Description
        DescLabel.TextColor3 = Color
        DescLabel.TextSize = 14
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.BackgroundTransparency = 1
        DescLabel.Size = UDim2.new(1, 0, 1, 0)
        DescLabel.Position = UDim2.new(0, TitleLabel.TextBounds.X + 15, 0, 0)
        DescLabel.Parent = Top

        local Close = Instance.new("TextButton")
        Close.Text = ""
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.BackgroundTransparency = 1
        Close.Position = UDim2.new(1, -5, 0.5, 0)
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

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Font = Enum.Font.GothamBold
        ContentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        ContentLabel.TextSize = 13
        ContentLabel.Text = Content
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Position = UDim2.new(0, 10, 0, 27)
        ContentLabel.Size = UDim2.new(1, -20, 0, 13)
        ContentLabel.Parent = NotifyFrameReal

        ContentLabel.Size = UDim2.new(1, -20, 0, 13 + (13 * (ContentLabel.TextBounds.X // ContentLabel.AbsoluteSize.X)))
        ContentLabel.TextWrapped = true

        if ContentLabel.AbsoluteSize.Y < 27 then
            NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
        else
            NotifyFrame.Size = UDim2.new(1, 0, 0, ContentLabel.AbsoluteSize.Y + 40)
        end
        
        local function CloseNotification()
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

function Kairo:CreateWindow(Properties)
    local Config = Properties.Config or {}
    local Theme = Properties.Theme or "Default"
    local CurrentTheme = Theme
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
        Cyan = Color3.fromRGB(0, 200, 255)
    }
    local CurrentColor = ThemeColors[Theme] or ThemeColors.Default
    
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
                OffsetY = OffsetY + 3 + child.Size.Y.Offset
            end
        end
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end

    TabScroll.ChildAdded:Connect(UpdateTabSize)
    TabScroll.ChildRemoved:Connect(UpdateTabSize)

    local function CreateTab(Properties)
        local TabName = Properties.Name or "Tab"
        local IconId = Properties.Icon or ""
        
        TabCount = TabCount + 1
        
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
        OptionSelecting.Text = Default or "Select Option"
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
        
        local dropdownData = {
            Options = Options,
            Value = Default,
            Open = false
        }
        
        local function UpdateSelectedDisplay()
            OptionSelecting.Text = dropdownData.Value or "Select Option"
        end
        
        UpdateSelectedDisplay()
        
        DropdownButton.Activated:Connect(function()
            CircleClick(DropdownButton, Mouse.X, Mouse.Y)
            
            -- Simple dropdown: just show the selected value
            if #Options > 0 then
                local currentIndex = table.find(Options, dropdownData.Value) or 1
                local nextIndex = currentIndex % #Options + 1
                dropdownData.Value = Options[nextIndex]
                UpdateSelectedDisplay()
                
                if Callback then Callback(dropdownData.Value) end
            end
        end)
        
        local dropdownFunc = {}
        dropdownFunc.Value = dropdownData.Value
        dropdownFunc.Options = Options
        
        function dropdownFunc:Set(value)
            dropdownData.Value = value
            UpdateSelectedDisplay()
            if Callback then Callback(value) end
        end
        
        function dropdownFunc:Refresh(newOptions, newValue)
            dropdownData.Options = newOptions or {}
            dropdownData.Value = newValue or nil
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
            Dragging = false
        }
        
        local function SetValue(value, instant)
            value = math.clamp(value, sliderData.Min, sliderData.Max)
            sliderData.Value = value
            
            ValueDisplay.Text = tostring(math.floor(value))
            
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
            local inputPos = input.Position
            local sliderPos = SliderFrame.AbsolutePosition
            local sliderSize = SliderFrame.AbsoluteSize
            
            local percentage = math.clamp((inputPos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = sliderData.Min + (percentage * (sliderData.Max - sliderData.Min))
            
            SetValue(value)
        end
        
        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderData.Dragging = true
                UpdateSliderFromInput(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliderData.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSliderFromInput(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and sliderData.Dragging then
                sliderData.Dragging = false
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

    -- Button events
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

    local windowAPI = {
        Tab = CreateTab,
        Button = CreateButton,
        Toggle = CreateToggle,
        Input = CreateInput,
        Dropdown = CreateDropdown,
        Slider = CreateSlider,
        Notification = MakeNotify,
        SetTheme = function(themeName)
            if ThemeColors[themeName] then
                CurrentTheme = themeName
                CurrentColor = ThemeColors[themeName]
                -- Update theme colors on existing elements
                for _, tab in pairs(TabElements) do
                    local chooseFrame = tab:FindFirstChild("ChooseFrame")
                    local chooseStroke = chooseFrame and chooseFrame:FindFirstChild("UIStroke")
                    if chooseFrame then chooseFrame.BackgroundColor3 = CurrentColor end
                    if chooseStroke then chooseStroke.Color = CurrentColor end
                end
                return true, CurrentColor
            end
            return false, nil
        end,
        Themes = ThemeColors,
        CurrentTheme = CurrentTheme,
        UI = {
            Main = Main,
            Holder = DropShadowHolder,
            Gui = ScreenGui
        }
    }
    
    -- Set windowAPI as metatable
    setmetatable(windowAPI, Kairo)
    
    return windowAPI
end

return Kairo
