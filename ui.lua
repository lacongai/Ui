-- UI Library with Icon System & Toggle Button - REDESIGNED
-- Created for Roblox

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Theme Colors
local Themes = {
    Dark = Color3.fromRGB(100, 150, 255),
    Red = Color3.fromRGB(255, 80, 80),
    Green = Color3.fromRGB(80, 255, 120),
    Blue = Color3.fromRGB(80, 180, 255),
    Purple = Color3.fromRGB(180, 100, 255),
    Pink = Color3.fromRGB(255, 120, 180),
    Orange = Color3.fromRGB(255, 150, 80),
    Yellow = Color3.fromRGB(255, 220, 80),
    Cyan = Color3.fromRGB(80, 220, 255),
    Magenta = Color3.fromRGB(255, 80, 200)
}

-- Icon Library
local IconLibrary = {
    home = "rbxassetid://10723434711",
    settings = "rbxassetid://10734950309",
    user = "rbxassetid://10747373176",
    shield = "rbxassetid://10723407389",
    sword = "rbxassetid://10723434518",
    target = "rbxassetid://10723407389",
    star = "rbxassetid://10709790948",
    crown = "rbxassetid://10709791437",
    info = "rbxassetid://10747384394",
    search = "rbxassetid://10734923214",
    menu = "rbxassetid://10747384394",
    plus = "rbxassetid://10747373176",
    minus = "rbxassetid://10734942835",
    close = "rbxassetid://10747384394",
    check = "rbxassetid://10709792537",
    bell = "rbxassetid://10709790644",
    heart = "rbxassetid://10709791437",
    flame = "rbxassetid://10709791151",
    gem = "rbxassetid://10709791682",
    coin = "rbxassetid://10709790537",
    box = "rbxassetid://10709789989"
}

local function GetIcon(iconName)
    if string.find(iconName, "rbxassetid://") then
        return iconName
    elseif IconLibrary[iconName] then
        return IconLibrary[iconName]
    else
        return "rbxassetid://10723434711"
    end
end

local function MakeDraggable(frame, dragSpeed)
    dragSpeed = dragSpeed or 0.25
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(dragSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
end

-- Create Window
function UI.CreateWindow(config)
    config = config or {}
    local title = config.Title or "UI Library"
    local subtitle = config.Subtitle or "by Replit"
    local toggleButton = config.ToggleButton or "round"
    local toggleIcon = config.ToggleIcon or nil
    local theme = config.Theme or "Dark"
    local width = config.Width or 650
    local height = config.Height or 500
    
    local ThemeColor = Themes[theme] or Themes["Dark"]
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MainUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Gradient Background
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.Parent = MainFrame

    -- Top Bar (Redesigned)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 65)
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 16)
    TopBarCorner.Parent = TopBar

    -- Border di TopBar
    local TopBarBorder = Instance.new("Frame")
    TopBarBorder.BackgroundColor3 = ThemeColor
    TopBarBorder.BorderSizePixel = 0
    TopBarBorder.Position = UDim2.new(0, 0, 1, -3)
    TopBarBorder.Size = UDim2.new(1, 0, 0, 3)
    TopBarBorder.Parent = TopBar

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 8)
    Title.Size = UDim2.new(0, 300, 0, 24)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 20, 0, 34)
    Subtitle.Size = UDim2.new(0, 300, 0, 14)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = subtitle
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TopBar

    -- Close Button (Redesigned)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundColor3 = Color3.fromRGB(240, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -45, 0, 18)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 60, 60)}):Play()
    end)

    -- Search Bar
    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name = "SearchContainer"
    SearchContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SearchContainer.BorderSizePixel = 0
    SearchContainer.Position = UDim2.new(0, 20, 0, 18)
    SearchContainer.Size = UDim2.new(0, 280, 0, 32)
    SearchContainer.Parent = TopBar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 8)
    SearchCorner.Parent = SearchContainer

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 65)
    TabContainer.Size = UDim2.new(0, 160, 1, -65)
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 12)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 160, 0, 65)
    ContentContainer.Size = UDim2.new(1, -160, 1, -65)
    ContentContainer.Parent = MainFrame

    MakeDraggable(MainFrame)

    -- Toggle Button (Redesigned)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Position = UDim2.new(0, 15, 0, 15)
    ToggleFrame.Size = UDim2.new(0, 55, 0, 55)
    ToggleFrame.Active = true
    ToggleFrame.Parent = ScreenGui

    if toggleButton == "round" then
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(1, 0)
        ToggleCorner.Parent = ToggleFrame
    else
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 12)
        ToggleCorner.Parent = ToggleFrame
    end

    local ToggleBorder = Instance.new("Frame")
    ToggleBorder.Name = "Border"
    ToggleBorder.BackgroundColor3 = ThemeColor
    ToggleBorder.BorderSizePixel = 0
    ToggleBorder.Size = UDim2.new(1, 0, 1, 0)
    ToggleBorder.Parent = ToggleFrame
    ToggleBorder.ZIndex = 0

    if toggleButton == "round" then
        local BorderCorner = Instance.new("UICorner")
        BorderCorner.CornerRadius = UDim.new(1, 0)
        BorderCorner.Parent = ToggleBorder
    end

    local TogglePadding = Instance.new("UIPadding")
    TogglePadding.PaddingBottom = UDim.new(0, 2)
    TogglePadding.PaddingLeft = UDim.new(0, 2)
    TogglePadding.PaddingRight = UDim.new(0, 2)
    TogglePadding.PaddingTop = UDim.new(0, 2)
    TogglePadding.Parent = ToggleBorder

    if toggleIcon then
        local ToggleImageButton = Instance.new("ImageButton")
        ToggleImageButton.Name = "ToggleButton"
        ToggleImageButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        ToggleImageButton.BorderSizePixel = 0
        ToggleImageButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleImageButton.Image = GetIcon(toggleIcon)
        ToggleImageButton.ImageColor3 = ThemeColor
        ToggleImageButton.Parent = ToggleBorder

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 10)
        ImgCorner.Parent = ToggleImageButton

        MakeDraggable(ToggleFrame)

        local isVisible = true
        ToggleImageButton.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end)
    else
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Text = "≡"
        ToggleButton.TextColor3 = ThemeColor
        ToggleButton.TextSize = 24
        ToggleButton.Parent = ToggleBorder

        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 10)
        TxtCorner.Parent = ToggleButton

        MakeDraggable(ToggleFrame)

        local isVisible = true
        ToggleButton.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end)
    end

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        Tabs = {},
        CurrentTab = nil,
        ThemeColor = ThemeColor
    }

    function Window:AddTab(config)
        config = config or {}
        local tabName = config.Title or "Tab"
        local tabIcon = config.Icon or "home"

        local Tab = {
            Name = tabName,
            Icon = tabIcon,
            Sections = {},
            Content = nil,
            Button = nil
        }

        -- Tab Button (Redesigned)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.Text = ""
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton

        -- Tab Icon
        local TabIconImage = Instance.new("ImageLabel")
        TabIconImage.Name = "Icon"
        TabIconImage.BackgroundTransparency = 1
        TabIconImage.Position = UDim2.new(0, 12, 0.5, -12)
        TabIconImage.Size = UDim2.new(0, 26, 0, 26)
        TabIconImage.Image = GetIcon(tabIcon)
        TabIconImage.ImageColor3 = Color3.fromRGB(200, 200, 200)
        TabIconImage.Parent = TabButton

        local TabBg = Instance.new("Frame")
        TabBg.Name = "Background"
        TabBg.BackgroundColor3 = ThemeColor
        TabBg.BorderSizePixel = 0
        TabBg.Size = UDim2.new(0, 0, 0, 3)
        TabBg.Position = UDim2.new(0, 0, 1, -3)
        TabBg.Parent = TabButton
        TabBg.ZIndex = 2

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = ThemeColor
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = TabContent
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 12)
        ContentPadding.PaddingRight = UDim.new(0, 12)
        ContentPadding.PaddingBottom = UDim.new(0, 15)

        Tab.Content = TabContent
        Tab.Button = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button:FindFirstChild("Background").Size = UDim2.new(0, 0, 0, 3)
                tab.Button:FindFirstChild("Icon").ImageColor3 = Color3.fromRGB(200, 200, 200)
            end

            TabContent.Visible = true
            TweenService:Create(TabBg, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 3)}):Play()
            TabIconImage.ImageColor3 = ThemeColor
            Window.CurrentTab = Tab
        end)

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            wait()
            TabContent.Visible = true
            TabBg.Size = UDim2.new(1, 0, 0, 3)
            TabIconImage.ImageColor3 = ThemeColor
            Window.CurrentTab = Tab
        end

        function Tab:AddSection(name)
            local Section = {
                Name = name,
                Components = {}
            }

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = TabContent

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Position = UDim2.new(0, 0, 0, 0)
            SectionTitle.Size = UDim2.new(1, 0, 0, 35)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = "  " .. name
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionTitleCorner = Instance.new("UICorner")
            SectionTitleCorner.CornerRadius = UDim.new(0, 10)
            SectionTitleCorner.Parent = SectionTitle

            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "Container"
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Position = UDim2.new(0, 0, 0, 35)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.Parent = SectionFrame

            local SectionList = Instance.new("UIListLayout")
            SectionList.Parent = SectionContainer
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 8)

            function Section:AddToggle(name, options)
                options = options or {}
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
                ToggleFrame.Parent = SectionContainer

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleFrame

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
                ToggleLabel.Font = Enum.Font.GothamSemibold
                ToggleLabel.Text = options.Text or name
                ToggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                ToggleLabel.TextSize = 13
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -40, 0.5, -11)
                ToggleButton.Size = UDim2.new(0, 38, 0, 22)
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(1, 0)
                ButtonCorner.Parent = ToggleButton

                local Indicator = Instance.new("Frame")
                Indicator.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                Indicator.BorderSizePixel = 0
                Indicator.Position = UDim2.new(0, 2, 0.5, -8)
                Indicator.Size = UDim2.new(0, 16, 0, 16)
                Indicator.Parent = ToggleButton

                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(1, 0)
                IndCorner.Parent = Indicator

                local toggled = options.Default or false

                local function UpdateToggle(state)
                    toggled = state
                    if toggled then
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = ThemeColor
                        }):Play()
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 150, 80)
                        }):Play()
                    else
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                        }):Play()
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        }):Play()
                    end
                    if options.Callback then
                        options.Callback(toggled)
                    end
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)

                UpdateToggle(toggled)

                return {
                    SetValue = function(self, value)
                        UpdateToggle(value)
                    end,
                    GetValue = function(self)
                        return toggled
                    end
                }
            end

            function Section:AddButton(name, options)
                options = options or {}
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Name = name
                ButtonFrame.BackgroundColor3 = ThemeColor
                ButtonFrame.BackgroundTransparency = 0.2
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
                ButtonFrame.Font = Enum.Font.GothamSemibold
                ButtonFrame.Text = options.Text or name
                ButtonFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonFrame.TextSize = 13
                ButtonFrame.Parent = SectionContainer

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 10)
                ButtonCorner.Parent = ButtonFrame

                ButtonFrame.MouseEnter:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                end)

                ButtonFrame.MouseLeave:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
                end)

                ButtonFrame.MouseButton1Click:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
                    wait(0.1)
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                    if options.Callback then
                        options.Callback()
                    end
                end)

                return ButtonFrame
            end

            function Section:AddSlider(name, options)
                options = options or {}
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local currentValue = default

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name
                SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 75)
                SliderFrame.Parent = SectionContainer

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 12, 0, 8)
                SliderLabel.Size = UDim2.new(1, -60, 0, 20)
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.Text = (options.Text or name) .. ": " .. tostring(currentValue)
                SliderLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderLabel.TextSize = 13
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame

                -- Input box
                local InputBox = Instance.new("TextBox")
                InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(1, -55, 0, 8)
                InputBox.Size = UDim2.new(0, 50, 0, 20)
                InputBox.Font = Enum.Font.Gotham
                InputBox.Text = tostring(currentValue)
                InputBox.TextColor3 = ThemeColor
                InputBox.TextSize = 11
                InputBox.Parent = SliderFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = InputBox

                local SliderBar = Instance.new("Frame")
                SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 12, 0, 38)
                SliderBar.Size = UDim2.new(1, -24, 0, 14)
                SliderBar.Parent = SliderFrame

                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar

                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = ThemeColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderBar

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                -- Thumb/Knob
                local Thumb = Instance.new("Frame")
                Thumb.BackgroundColor3 = ThemeColor
                Thumb.BorderSizePixel = 0
                Thumb.Position = UDim2.new((currentValue - min) / (max - min), -7, 0.5, -7)
                Thumb.Size = UDim2.new(0, 14, 0, 14)
                Thumb.Parent = SliderBar

                local ThumbCorner = Instance.new("UICorner")
                ThumbCorner.CornerRadius = UDim.new(1, 0)
                ThumbCorner.Parent = Thumb

                local dragging = false

                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                    currentValue = math.clamp(currentValue, min, max)
                    SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                    Thumb.Position = UDim2.new((currentValue - min) / (max - min), -7, 0.5, -7)
                    SliderLabel.Text = (options.Text or name) .. ": " .. tostring(currentValue)
                    InputBox.Text = tostring(currentValue)
                    if options.Callback then
                        options.Callback(currentValue)
                    end
                end

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                Thumb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                InputBox.FocusLost:Connect(function(enterPressed)
                    local val = tonumber(InputBox.Text)
                    if val then
                        currentValue = math.clamp(val, min, max)
                        SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                        Thumb.Position = UDim2.new((currentValue - min) / (max - min), -7, 0.5, -7)
                        SliderLabel.Text = (options.Text or name) .. ": " .. tostring(currentValue)
                        InputBox.Text = tostring(currentValue)
                        if options.Callback then
                            options.Callback(currentValue)
                        end
                    else
                        InputBox.Text = tostring(currentValue)
                    end
                end)

                return {
                    SetValue = function(self, value)
                        currentValue = math.clamp(value, min, max)
                        SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                        Thumb.Position = UDim2.new((currentValue - min) / (max - min), -7, 0.5, -7)
                        SliderLabel.Text = (options.Text or name) .. ": " .. tostring(currentValue)
                        InputBox.Text = tostring(currentValue)
                    end,
                    GetValue = function(self)
                        return currentValue
                    end
                }
            end

            function Section:AddDropdown(name, options)
                options = options or {}
                local items = options.Items or {}
                local default = options.Default or (items[1] or "None")
                local currentItem = default

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = name
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 38)
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContainer

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 0, 38)
                DropdownButton.Text = ""
                DropdownButton.Parent = DropdownFrame

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -35, 1, 0)
                DropdownLabel.Font = Enum.Font.GothamSemibold
                DropdownLabel.Text = (options.Text or name) .. ": " .. currentItem
                DropdownLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownLabel.TextSize = 13
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownButton

                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -28, 0, 0)
                DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Color3.fromRGB(180, 180, 180)
                DropdownArrow.TextSize = 11
                DropdownArrow.Parent = DropdownButton

                local ItemContainer = Instance.new("Frame")
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.Position = UDim2.new(0, 0, 0, 38)
                ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                ItemContainer.Parent = DropdownFrame

                local ItemList = Instance.new("UIListLayout")
                ItemList.Parent = ItemContainer
                ItemList.SortOrder = Enum.SortOrder.LayoutOrder

                local isOpen = false

                local function UpdateDropdown()
                    if isOpen then
                        local itemCount = #items
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 38 + (itemCount * 32))
                        }):Play()
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 180
                        }):Play()
                    else
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 38)
                        }):Play()
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                    end
                end

                for _, item in ipairs(items) do
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    ItemButton.BorderSizePixel = 0
                    ItemButton.Size = UDim2.new(1, 0, 0, 32)
                    ItemButton.Font = Enum.Font.Gotham
                    ItemButton.Text = item
                    ItemButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    ItemButton.TextSize = 12
                    ItemButton.Parent = ItemContainer

                    ItemButton.MouseButton1Click:Connect(function()
                        currentItem = item
                        DropdownLabel.Text = (options.Text or name) .. ": " .. currentItem
                        isOpen = false
                        UpdateDropdown()
                        if options.Callback then
                            options.Callback(currentItem)
                        end
                    end)
                end

                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    UpdateDropdown()
                end)

                return {
                    SetValue = function(self, value)
                        currentItem = value
                        DropdownLabel.Text = (options.Text or name) .. ": " .. currentItem
                    end,
                    GetValue = function(self)
                        return currentItem
                    end
                }
            end

            function Section:AddTextBox(name, options)
                options = options or {}
                local text = options.Default or ""

                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Name = name
                TextBoxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                TextBoxFrame.BorderSizePixel = 0
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 70)
                TextBoxFrame.Parent = SectionContainer

                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 10)
                TextBoxCorner.Parent = TextBoxFrame

                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Position = UDim2.new(0, 12, 0, 8)
                TextBoxLabel.Size = UDim2.new(1, -24, 0, 20)
                TextBoxLabel.Font = Enum.Font.GothamSemibold
                TextBoxLabel.Text = options.Text or name
                TextBoxLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                TextBoxLabel.TextSize = 12
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = TextBoxFrame

                local TextBox = Instance.new("TextBox")
                TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, 12, 0, 32)
                TextBox.Size = UDim2.new(1, -24, 0, 30)
                TextBox.Font = Enum.Font.Gotham
                TextBox.Text = text
                TextBox.PlaceholderText = options.Placeholder or ""
                TextBox.TextColor3 = ThemeColor
                TextBox.TextSize = 12
                TextBox.ClearTextOnFocus = false
                TextBox.Parent = TextBoxFrame

                local TextBoxCornerInner = Instance.new("UICorner")
                TextBoxCornerInner.CornerRadius = UDim.new(0, 8)
                TextBoxCornerInner.Parent = TextBox

                TextBox.FocusLost:Connect(function(enterPressed)
                    text = TextBox.Text
                    if options.Callback then
                        options.Callback(text, enterPressed)
                    end
                end)

                return {
                    SetValue = function(self, value)
                        text = value
                        TextBox.Text = value
                    end,
                    GetValue = function(self)
                        return text
                    end
                }
            end

            local function UpdateSectionSize()
                local totalHeight = 0
                for _, child in ipairs(SectionContainer:GetChildren()) do
                    if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                        totalHeight = totalHeight + child.AbsoluteSize.Y + 8
                    end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 35)
            end

            ContentList.Changed:Connect(function()
                UpdateSectionSize()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
            end)

            return Section
        end

        return Tab
    end

    return Window
end

return UI
