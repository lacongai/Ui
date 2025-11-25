-- UI Library - MODERN UNIQUE DESIGN
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

-- Create Window - MODERN DESIGN
function UI.CreateWindow(config)
    config = config or {}
    local title = config.Title or "UI Library"
    local subtitle = config.Subtitle or "by Replit"
    local toggleButton = config.ToggleButton or "round"
    local toggleIcon = config.ToggleIcon or nil
    local theme = config.Theme or "Dark"
    local width = config.Width or 700
    local height = config.Height or 550
    
    local ThemeColor = Themes[theme] or Themes["Dark"]
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MainUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Container (Hexagon-like shape with asymmetric top)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame

    -- Shadow/Glow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -25, 0, -25)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = ThemeColor
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.Parent = MainFrame

    -- Top Bar (Asymmetric Design)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 70)
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 20)
    TopBarCorner.Parent = TopBar

    -- Accent Line (diagonal aesthetic)
    local AccentLine = Instance.new("Frame")
    AccentLine.BackgroundColor3 = ThemeColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Position = UDim2.new(0, 0, 1, -4)
    AccentLine.Size = UDim2.new(0.4, 0, 0, 4)
    AccentLine.Parent = TopBar
    AccentLine.ZIndex = 2

    -- Title with better styling
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 12)
    Title.Size = UDim2.new(0, 400, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = ThemeColor
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 20, 0, 40)
    Subtitle.Size = UDim2.new(0, 300, 0, 15)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = subtitle
    Subtitle.TextColor3 = Color3.fromRGB(130, 130, 130)
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TopBar

    -- Close Button (Modern style)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -50, 0, 15)
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.TextSize = 20
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)

    -- Tab Container (Sidebar - Compact)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.Size = UDim2.new(0, 80, 1, -70)
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 80, 0, 70)
    ContentContainer.Size = UDim2.new(1, -80, 1, -70)
    ContentContainer.Parent = MainFrame

    MakeDraggable(TopBar)

    -- Minimize Protection Barrier
    local MinimizeBarrier = Instance.new("Frame")
    MinimizeBarrier.Name = "MinimizeBarrier"
    MinimizeBarrier.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MinimizeBarrier.BorderSizePixel = 0
    MinimizeBarrier.Position = UDim2.new(0, 0, 0, 55)
    MinimizeBarrier.Size = UDim2.new(1, 0, 0, 15)
    MinimizeBarrier.Parent = MainFrame
    MinimizeBarrier.ZIndex = 10

    -- Toggle Button (Compact, modern)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Position = UDim2.new(0, 15, 0, 15)
    ToggleFrame.Size = UDim2.new(0, 60, 0, 60)
    ToggleFrame.Active = true
    ToggleFrame.Parent = ScreenGui

    if toggleButton == "round" then
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(1, 0)
        ToggleCorner.Parent = ToggleFrame
    else
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 15)
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
        ToggleImageButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        ToggleImageButton.BorderSizePixel = 0
        ToggleImageButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleImageButton.Image = GetIcon(toggleIcon)
        ToggleImageButton.ImageColor3 = ThemeColor
        ToggleImageButton.Parent = ToggleBorder

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 12)
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
        ToggleButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Text = "◆"
        ToggleButton.TextColor3 = ThemeColor
        ToggleButton.TextSize = 28
        ToggleButton.Parent = ToggleBorder

        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 12)
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
        ThemeColor = ThemeColor,
        IsMinimized = false
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

        -- Tab Button (Icon + Title in tooltip style)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 60)
        TabButton.Text = ""
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 12)
        TabCorner.Parent = TabButton

        -- Tab Icon
        local TabIconImage = Instance.new("ImageLabel")
        TabIconImage.Name = "Icon"
        TabIconImage.BackgroundTransparency = 1
        TabIconImage.Position = UDim2.new(0.5, -15, 0.5, -15)
        TabIconImage.Size = UDim2.new(0, 30, 0, 30)
        TabIconImage.Image = GetIcon(tabIcon)
        TabIconImage.ImageColor3 = Color3.fromRGB(180, 180, 180)
        TabIconImage.Parent = TabButton

        -- Tab Title Tooltip (show on hover)
        local TabTooltip = Instance.new("TextLabel")
        TabTooltip.Name = "Tooltip"
        TabTooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabTooltip.BorderSizePixel = 0
        TabTooltip.Position = UDim2.new(1, 10, 0.5, -10)
        TabTooltip.Size = UDim2.new(0, 0, 0, 20)
        TabTooltip.Font = Enum.Font.GothamSemibold
        TabTooltip.Text = tabName
        TabTooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabTooltip.TextSize = 11
        TabTooltip.Visible = false
        TabTooltip.Parent = TabButton

        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 6)
        TooltipCorner.Parent = TabTooltip

        TabButton.MouseEnter:Connect(function()
            TabTooltip.Visible = true
            TweenService:Create(TabTooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 20)}):Play()
        end)

        TabButton.MouseLeave:Connect(function()
            TweenService:Create(TabTooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 20)}):Play()
            wait(0.2)
            TabTooltip.Visible = false
        end)

        -- Selected indicator
        local SelectedIndicator = Instance.new("Frame")
        SelectedIndicator.Name = "Indicator"
        SelectedIndicator.BackgroundColor3 = ThemeColor
        SelectedIndicator.BorderSizePixel = 0
        SelectedIndicator.Position = UDim2.new(0, 0, 1, -3)
        SelectedIndicator.Size = UDim2.new(0, 0, 0, 3)
        SelectedIndicator.Visible = false
        SelectedIndicator.Parent = TabButton
        SelectedIndicator.ZIndex = 5

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
        ContentList.Padding = UDim.new(0, 8)

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 12)
        ContentPadding.PaddingLeft = UDim.new(0, 12)
        ContentPadding.PaddingRight = UDim.new(0, 12)
        ContentPadding.PaddingBottom = UDim.new(0, 12)

        Tab.Content = TabContent
        Tab.Button = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button:FindFirstChild("Indicator").Visible = false
                tab.Button:FindFirstChild("Icon").ImageColor3 = Color3.fromRGB(180, 180, 180)
            end

            TabContent.Visible = true
            SelectedIndicator.Visible = true
            TweenService:Create(SelectedIndicator, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 3)}):Play()
            TabIconImage.ImageColor3 = ThemeColor
            Window.CurrentTab = Tab
        end)

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            wait()
            TabContent.Visible = true
            SelectedIndicator.Visible = true
            SelectedIndicator.Size = UDim2.new(1, 0, 0, 3)
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

            -- Compact Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Position = UDim2.new(0, 0, 0, 0)
            SectionTitle.Size = UDim2.new(1, 0, 0, 28)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = "◆ " .. name
            SectionTitle.TextColor3 = ThemeColor
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionTitleCorner = Instance.new("UICorner")
            SectionTitleCorner.CornerRadius = UDim.new(0, 10)
            SectionTitleCorner.Parent = SectionTitle

            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "Container"
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Position = UDim2.new(0, 0, 0, 28)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.Parent = SectionFrame

            local SectionList = Instance.new("UIListLayout")
            SectionList.Parent = SectionContainer
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 6)

            function Section:AddToggle(name, options)
                options = options or {}
                local toggled = options.Default or false
                
                local ToggleFrame = Instance.new("TextButton")
                ToggleFrame.Name = name
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
                ToggleFrame.Text = ""
                ToggleFrame.Parent = SectionContainer

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 10)
                ToggleCorner.Parent = ToggleFrame

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = options.Text or name
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                ToggleLabel.ZIndex = 2

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                ToggleSwitch.Parent = ToggleFrame
                ToggleSwitch.ZIndex = 2

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                local Indicator = Instance.new("Frame")
                Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                Indicator.BorderSizePixel = 0
                Indicator.Position = UDim2.new(0, 2, 0.5, -8)
                Indicator.Size = UDim2.new(0, 16, 0, 16)
                Indicator.Parent = ToggleSwitch
                Indicator.ZIndex = 3

                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = Indicator

                local function UpdateToggle(state)
                    toggled = state
                    if toggled then
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = ThemeColor
                        }):Play()
                        TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 150, 80)
                        }):Play()
                    else
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                        }):Play()
                        TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        }):Play()
                    end
                    if options.Callback then
                        options.Callback(toggled)
                    end
                end

                ToggleFrame.MouseButton1Click:Connect(function()
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
                ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
                ButtonFrame.Font = Enum.Font.GothamSemibold
                ButtonFrame.Text = options.Text or name
                ButtonFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonFrame.TextSize = 12
                ButtonFrame.Parent = SectionContainer

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 10)
                ButtonCorner.Parent = ButtonFrame

                ButtonFrame.MouseEnter:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
                end)

                ButtonFrame.MouseLeave:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
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
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 70)
                SliderFrame.Parent = SectionContainer

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 12, 0, 8)
                SliderLabel.Size = UDim2.new(1, -60, 0, 18)
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.Text = (options.Text or name) .. ": " .. tostring(currentValue)
                SliderLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame

                local InputBox = Instance.new("TextBox")
                InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(1, -52, 0, 8)
                InputBox.Size = UDim2.new(0, 48, 0, 18)
                InputBox.Font = Enum.Font.Gotham
                InputBox.Text = tostring(currentValue)
                InputBox.TextColor3 = ThemeColor
                InputBox.TextSize = 11
                InputBox.Parent = SliderFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = InputBox

                local SliderBar = Instance.new("Frame")
                SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 12, 0, 34)
                SliderBar.Size = UDim2.new(1, -24, 0, 12)
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

                local Thumb = Instance.new("Frame")
                Thumb.BackgroundColor3 = ThemeColor
                Thumb.BorderSizePixel = 0
                Thumb.Position = UDim2.new((currentValue - min) / (max - min), -6, 0.5, -6)
                Thumb.Size = UDim2.new(0, 12, 0, 12)
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
                    Thumb.Position = UDim2.new((currentValue - min) / (max - min), -6, 0.5, -6)
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

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                InputBox.FocusLost:Connect(function()
                    local val = tonumber(InputBox.Text)
                    if val then
                        currentValue = math.clamp(val, min, max)
                        SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                        Thumb.Position = UDim2.new((currentValue - min) / (max - min), -6, 0.5, -6)
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
                        Thumb.Position = UDim2.new((currentValue - min) / (max - min), -6, 0.5, -6)
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
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
                DropdownFrame.Parent = SectionContainer

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 10)
                DropdownCorner.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Text = ""
                DropdownButton.Parent = DropdownFrame

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -45, 1, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = currentItem
                DropdownLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownLabel.TextSize = 12
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame

                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
                DropdownArrow.Size = UDim2.new(0, 30, 1, 0)
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = ThemeColor
                DropdownArrow.TextSize = 10
                DropdownArrow.Parent = DropdownFrame

                local ItemContainer = Instance.new("Frame")
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.BorderSizePixel = 0
                ItemContainer.Position = UDim2.new(0, 0, 1, 0)
                ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                ItemContainer.Visible = false
                ItemContainer.Parent = DropdownFrame

                local itemCount = #items
                local isOpen = false

                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        ItemContainer.Visible = true
                        ItemContainer.Size = UDim2.new(1, 0, 0, 30 + (itemCount * 32))
                    else
                        ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                        ItemContainer.Visible = false
                    end
                end)

                for i, item in ipairs(items) do
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.Name = item
                    ItemButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    ItemButton.BorderSizePixel = 0
                    ItemButton.Position = UDim2.new(0, 0, 0, 30 + (i-1) * 32)
                    ItemButton.Size = UDim2.new(1, 0, 0, 32)
                    ItemButton.Font = Enum.Font.Gotham
                    ItemButton.Text = item
                    ItemButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    ItemButton.TextSize = 11
                    ItemButton.Parent = ItemContainer

                    ItemButton.MouseButton1Click:Connect(function()
                        currentItem = item
                        DropdownLabel.Text = item
                        isOpen = false
                        ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                        ItemContainer.Visible = false
                        if options.Callback then
                            options.Callback(item)
                        end
                    end)

                    ItemButton.MouseEnter:Connect(function()
                        TweenService:Create(ItemButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    end)

                    ItemButton.MouseLeave:Connect(function()
                        TweenService:Create(ItemButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                    end)
                end

                return {
                    SetValue = function(self, value)
                        currentItem = value
                        DropdownLabel.Text = value
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
                TextBoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                TextBoxFrame.BorderSizePixel = 0
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 65)
                TextBoxFrame.Parent = SectionContainer

                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 10)
                TextBoxCorner.Parent = TextBoxFrame

                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Position = UDim2.new(0, 12, 0, 6)
                TextBoxLabel.Size = UDim2.new(1, -24, 0, 18)
                TextBoxLabel.Font = Enum.Font.GothamSemibold
                TextBoxLabel.Text = options.Text or name
                TextBoxLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                TextBoxLabel.TextSize = 12
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = TextBoxFrame

                local TextBox = Instance.new("TextBox")
                TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, 12, 0, 28)
                TextBox.Size = UDim2.new(1, -24, 0, 28)
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

                TextBox.FocusLost:Connect(function()
                    text = TextBox.Text
                    if options.Callback then
                        options.Callback(text)
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
                        totalHeight = totalHeight + child.AbsoluteSize.Y + 6
                    end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 28)
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
