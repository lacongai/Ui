-- Roblox UI Library - Professional Design
-- Modern, Clean, Professional

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
        return IconLibrary.home
    end
end

-- Make Draggable (Fix: Only from title bar)
local function MakeDraggableFromArea(frame, dragArea)
    local dragging = false
    local dragStart = nil
    local frameStart = nil

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end)

    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create Window
function UI.CreateWindow(config)
    config = config or {}
    local title = config.Title or "UI Library"
    local subtitle = config.Subtitle or "by Replit"
    local theme = config.Theme or "Dark"
    local toggleIcon = config.ToggleIcon or nil
    local width = config.Width or 700
    local height = config.Height or 550

    local ThemeColor = Themes[theme] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame

    -- Glow Shadow
    local Shadow = Instance.new("ImageLabel")
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

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 75)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 20)
    HeaderCorner.Parent = Header

    -- Accent Line
    local AccentLine = Instance.new("Frame")
    AccentLine.BackgroundColor3 = ThemeColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Position = UDim2.new(0, 0, 1, -4)
    AccentLine.Size = UDim2.new(0.5, 0, 0, 4)
    AccentLine.Parent = Header
    AccentLine.ZIndex = 10

    -- Drag Area (Only this should be draggable)
    local DragArea = Instance.new("Frame")
    DragArea.Name = "DragArea"
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, -50, 1, 0)
    DragArea.Position = UDim2.new(0, 0, 0, 0)
    DragArea.Parent = Header

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    TitleLabel.Size = UDim2.new(1, -40, 0, 28)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = ThemeColor
    TitleLabel.TextSize = 22
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 20, 0, 42)
    SubtitleLabel.Size = UDim2.new(1, -40, 0, 16)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseButton"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -50, 0, 20)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 18
    CloseBtn.Parent = Header

    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Setup Dragging
    MakeDraggableFromArea(MainFrame, DragArea)

    -- Tab Container (Sidebar)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 75)
    TabContainer.Size = UDim2.new(0, 90, 1, -75)
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 12)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 90, 0, 75)
    ContentContainer.Size = UDim2.new(1, -90, 1, -75)
    ContentContainer.Parent = MainFrame

    -- Toggle Button
    local ToggleBtn = Instance.new("Frame")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    ToggleBtn.Parent = ScreenGui

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 14)
    ToggleBtnCorner.Parent = ToggleBtn

    local ToggleBorder = Instance.new("Frame")
    ToggleBorder.BackgroundColor3 = ThemeColor
    ToggleBorder.BorderSizePixel = 0
    ToggleBorder.Size = UDim2.new(1, 0, 1, 0)
    ToggleBorder.Parent = ToggleBtn
    ToggleBorder.ZIndex = 0

    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 14)
    BorderCorner.Parent = ToggleBorder

    local BorderPadding = Instance.new("UIPadding")
    BorderPadding.PaddingBottom = UDim.new(0, 2)
    BorderPadding.PaddingLeft = UDim.new(0, 2)
    BorderPadding.PaddingRight = UDim.new(0, 2)
    BorderPadding.PaddingTop = UDim.new(0, 2)
    BorderPadding.Parent = ToggleBorder

    if toggleIcon then
        local ToggleImg = Instance.new("ImageButton")
        ToggleImg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        ToggleImg.BorderSizePixel = 0
        ToggleImg.Size = UDim2.new(1, 0, 1, 0)
        ToggleImg.Image = GetIcon(toggleIcon)
        ToggleImg.ImageColor3 = ThemeColor
        ToggleImg.Parent = ToggleBorder

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 12)
        ImgCorner.Parent = ToggleImg

        local isVisible = true
        ToggleImg.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end)
    else
        local ToggleText = Instance.new("TextButton")
        ToggleText.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        ToggleText.BorderSizePixel = 0
        ToggleText.Size = UDim2.new(1, 0, 1, 0)
        ToggleText.Font = Enum.Font.GothamBold
        ToggleText.Text = "◆"
        ToggleText.TextColor3 = ThemeColor
        ToggleText.TextSize = 28
        ToggleText.Parent = ToggleBorder

        local TextCorner = Instance.new("UICorner")
        TextCorner.CornerRadius = UDim.new(0, 12)
        TextCorner.Parent = ToggleText

        local isVisible = true
        ToggleText.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end)
    end

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
            Sections = {}
        }

        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 65)
        TabBtn.Text = ""
        TabBtn.Parent = TabContainer

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 12)
        TabBtnCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, -15, 0.5, -15)
        TabIcon.Size = UDim2.new(0, 30, 0, 30)
        TabIcon.Image = GetIcon(tabIcon)
        TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        TabIcon.Parent = TabBtn

        local TabTooltip = Instance.new("TextLabel")
        TabTooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabTooltip.BorderSizePixel = 0
        TabTooltip.Position = UDim2.new(1, 10, 0.5, -10)
        TabTooltip.Size = UDim2.new(0, 0, 0, 20)
        TabTooltip.Font = Enum.Font.GothamSemibold
        TabTooltip.Text = tabName
        TabTooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabTooltip.TextSize = 11
        TabTooltip.Visible = false
        TabTooltip.Parent = TabBtn

        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 6)
        TooltipCorner.Parent = TabTooltip

        TabBtn.MouseEnter:Connect(function()
            TabTooltip.Visible = true
            TweenService:Create(TabTooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, 110, 0, 20)}):Play()
        end)

        TabBtn.MouseLeave:Connect(function()
            TweenService:Create(TabTooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 20)}):Play()
            wait(0.2)
            TabTooltip.Visible = false
        end)

        local TabIndicator = Instance.new("Frame")
        TabIndicator.BackgroundColor3 = ThemeColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 1, -3)
        TabIndicator.Size = UDim2.new(0, 0, 0, 3)
        TabIndicator.Visible = false
        TabIndicator.Parent = TabBtn
        TabIndicator.ZIndex = 5

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
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
        Tab.Button = TabBtn

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Button:FindFirstChild("TabIndicator").Visible = false
                t.Button:FindFirstChild("ImageLabel").ImageColor3 = Color3.fromRGB(180, 180, 180)
            end

            TabContent.Visible = true
            TabIndicator.Visible = true
            TweenService:Create(TabIndicator, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 3)}):Play()
            TabIcon.ImageColor3 = ThemeColor
            Window.CurrentTab = Tab
        end)

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            wait()
            TabContent.Visible = true
            TabIndicator.Visible = true
            TabIndicator.Size = UDim2.new(1, 0, 0, 3)
            TabIcon.ImageColor3 = ThemeColor
            Window.CurrentTab = Tab
        end

        function Tab:AddSection(name)
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = TabContent

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Size = UDim2.new(1, 0, 0, 28)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = "◆ " .. name
            SectionTitle.TextColor3 = ThemeColor
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local TitleCorner = Instance.new("UICorner")
            TitleCorner.CornerRadius = UDim.new(0, 10)
            TitleCorner.Parent = SectionTitle

            local SectionContainer = Instance.new("Frame")
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Position = UDim2.new(0, 0, 0, 28)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.Parent = SectionFrame

            local ContainerList = Instance.new("UIListLayout")
            ContainerList.Parent = SectionContainer
            ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerList.Padding = UDim.new(0, 6)

            function Section:AddToggle(name, options)
                options = options or {}
                local toggled = options.Default or false

                local ToggleFrame = Instance.new("TextButton")
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
                ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
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
                ButtonFrame.BackgroundColor3 = ThemeColor
                ButtonFrame.BackgroundTransparency = 0.2
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
                ButtonFrame.Font = Enum.Font.GothamSemibold
                ButtonFrame.Text = options.Text or name
                ButtonFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonFrame.TextSize = 12
                ButtonFrame.Parent = SectionContainer

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 10)
                BtnCorner.Parent = ButtonFrame

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
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 68)
                SliderFrame.Parent = SectionContainer

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 12, 0, 6)
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
                InputBox.Position = UDim2.new(1, -52, 0, 6)
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
                SliderBar.Position = UDim2.new(0, 12, 0, 32)
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
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
                DropdownFrame.Parent = SectionContainer

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 10)
                DropdownCorner.Parent = DropdownFrame

                local DropdownBtn = Instance.new("TextButton")
                DropdownBtn.BackgroundTransparency = 1
                DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
                DropdownBtn.Text = ""
                DropdownBtn.Parent = DropdownFrame

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

                local Arrow = Instance.new("TextLabel")
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -30, 0, 0)
                Arrow.Size = UDim2.new(0, 30, 1, 0)
                Arrow.Font = Enum.Font.GothamBold
                Arrow.Text = "▼"
                Arrow.TextColor3 = ThemeColor
                Arrow.TextSize = 10
                Arrow.Parent = DropdownFrame

                local ItemContainer = Instance.new("Frame")
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.BorderSizePixel = 0
                ItemContainer.Position = UDim2.new(0, 0, 1, 0)
                ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                ItemContainer.Visible = false
                ItemContainer.Parent = DropdownFrame

                local itemCount = #items
                local isOpen = false

                DropdownBtn.MouseButton1Click:Connect(function()
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
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Position = UDim2.new(0, 0, 0, 30 + (i-1) * 32)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 32)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = item
                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    ItemBtn.TextSize = 11
                    ItemBtn.Parent = ItemContainer

                    ItemBtn.MouseButton1Click:Connect(function()
                        currentItem = item
                        DropdownLabel.Text = item
                        isOpen = false
                        ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                        ItemContainer.Visible = false
                        if options.Callback then
                            options.Callback(item)
                        end
                    end)

                    ItemBtn.MouseEnter:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    end)

                    ItemBtn.MouseLeave:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
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
                    if child:IsA("GuiObject") and child.Name ~= "UIListLayout" then
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
