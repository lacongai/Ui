-- Roblox Modern UI Library - Completely Redesigned
-- New Shape Design - Not Traditional Rectangle

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

local IconLibrary = {
    home = "rbxassetid://10723434711",
    settings = "rbxassetid://10734950309",
    user = "rbxassetid://10747373176",
    shield = "rbxassetid://10723407389",
    sword = "rbxassetid://10723434518",
    star = "rbxassetid://10709790948",
    crown = "rbxassetid://10709791437",
    info = "rbxassetid://10747384394",
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

local function GetIcon(name)
    if string.find(name, "rbxassetid://") then return name end
    return IconLibrary[name] or IconLibrary.home
end

local function MakeDragFromArea(frame, area)
    local dragging = false
    local dragStart = nil
    local frameStart = nil

    area.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end)

    area.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
        end
    end)
end

function UI.CreateWindow(config)
    config = config or {}
    local title = config.Title or "Hub"
    local subtitle = config.Subtitle or ""
    local theme = config.Theme or "Dark"
    local toggleIcon = config.ToggleIcon
    local width = config.Width or 750
    local height = config.Height or 580

    local ThemeColor = Themes[theme] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Window with Modern Shape
    local MainFrame = Instance.new("Frame")
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 24)
    Corner.Parent = MainFrame

    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -30, 0, -30)
    Glow.Size = UDim2.new(1, 60, 1, 60)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://6014261993"
    Glow.ImageColor3 = ThemeColor
    Glow.ImageTransparency = 0.75
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(99, 99, 99, 99)
    Glow.Parent = MainFrame

    -- Top Section (Header with Diagonal Design)
    local TopSection = Instance.new("Frame")
    TopSection.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    TopSection.BorderSizePixel = 0
    TopSection.Size = UDim2.new(1, 0, 0, 80)
    TopSection.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 24)
    TopCorner.Parent = TopSection

    -- Diagonal Accent Bar
    local DiagonalBar = Instance.new("Frame")
    DiagonalBar.BackgroundColor3 = ThemeColor
    DiagonalBar.BorderSizePixel = 0
    DiagonalBar.Position = UDim2.new(0, 0, 1, -5)
    DiagonalBar.Size = UDim2.new(0.6, 0, 0, 5)
    DiagonalBar.Parent = TopSection
    DiagonalBar.ZIndex = 10

    -- Drag Area
    local DragArea = Instance.new("Frame")
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, -50, 1, 0)
    DragArea.Parent = TopSection

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 24, 0, 12)
    TitleLabel.Size = UDim2.new(1, -80, 0, 28)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = ThemeColor
    TitleLabel.TextSize = 24
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopSection

    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(0, 24, 0, 44)
    SubLabel.Size = UDim2.new(1, -80, 0, 14)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = TopSection

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -45, 0, 25)
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopSection

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MakeDragFromArea(MainFrame, DragArea)

    -- Sidebar (Icon Tabs - Vertical)
    local Sidebar = Instance.new("Frame")
    Sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 80)
    Sidebar.Size = UDim2.new(0, 100, 1, -80)
    Sidebar.Parent = MainFrame

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 100, 0, 80)
    ContentArea.Size = UDim2.new(1, -100, 1, -80)
    ContentArea.Parent = MainFrame

    -- Toggle Button (Corner of Screen)
    local ToggleBtn = Instance.new("Frame")
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Position = UDim2.new(0, 16, 0, 16)
    ToggleBtn.Size = UDim2.new(0, 64, 0, 64)
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 16)
    ToggleCorner.Parent = ToggleBtn

    local ToggleInner = Instance.new("Frame")
    ToggleInner.BackgroundColor3 = ThemeColor
    ToggleInner.BorderSizePixel = 0
    ToggleInner.Size = UDim2.new(1, 0, 1, 0)
    ToggleInner.Parent = ToggleBtn
    ToggleInner.ZIndex = 0

    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 14)
    InnerCorner.Parent = ToggleInner

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 3)
    Padding.PaddingLeft = UDim.new(0, 3)
    Padding.PaddingRight = UDim.new(0, 3)
    Padding.PaddingTop = UDim.new(0, 3)
    Padding.Parent = ToggleInner

    if toggleIcon then
        local ToggleImg = Instance.new("ImageButton")
        ToggleImg.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        ToggleImg.BorderSizePixel = 0
        ToggleImg.Size = UDim2.new(1, 0, 1, 0)
        ToggleImg.Image = GetIcon(toggleIcon)
        ToggleImg.ImageColor3 = ThemeColor
        ToggleImg.Parent = ToggleInner

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 12)
        ImgCorner.Parent = ToggleImg

        local visible = true
        ToggleImg.MouseButton1Click:Connect(function()
            visible = not visible
            MainFrame.Visible = visible
        end)
    else
        local ToggleText = Instance.new("TextButton")
        ToggleText.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        ToggleText.BorderSizePixel = 0
        ToggleText.Size = UDim2.new(1, 0, 1, 0)
        ToggleText.Font = Enum.Font.GothamBold
        ToggleText.Text = "◆"
        ToggleText.TextColor3 = ThemeColor
        ToggleText.TextSize = 32
        ToggleText.Parent = ToggleInner

        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 12)
        TxtCorner.Parent = ToggleText

        local visible = true
        ToggleText.MouseButton1Click:Connect(function()
            visible = not visible
            MainFrame.Visible = visible
        end)
    end

    local Window = {
        Tabs = {},
        ThemeColor = ThemeColor,
        MainFrame = MainFrame,
        ContentArea = ContentArea,
        ScreenGui = ScreenGui
    }

    function Window:AddTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Title or "Tab"
        local tabIcon = cfg.Icon or "home"

        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 70)
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 14)
        TabCorner.Parent = TabBtn

        -- Tab Icon
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, -18, 0.5, -18)
        TabIcon.Size = UDim2.new(0, 36, 0, 36)
        TabIcon.Image = GetIcon(tabIcon)
        TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        TabIcon.Parent = TabBtn

        -- Tooltip
        local Tooltip = Instance.new("TextLabel")
        Tooltip.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        Tooltip.BorderSizePixel = 0
        Tooltip.Position = UDim2.new(1, 12, 0.5, -12)
        Tooltip.Size = UDim2.new(0, 0, 0, 24)
        Tooltip.Font = Enum.Font.GothamSemibold
        Tooltip.Text = tabName
        Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tooltip.TextSize = 11
        Tooltip.Visible = false
        Tooltip.Parent = TabBtn

        local TipCorner = Instance.new("UICorner")
        TipCorner.CornerRadius = UDim.new(0, 8)
        TipCorner.Parent = Tooltip

        TabBtn.MouseEnter:Connect(function()
            Tooltip.Visible = true
            TweenService:Create(Tooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 24)}):Play()
        end)

        TabBtn.MouseLeave:Connect(function()
            TweenService:Create(Tooltip, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 24)}):Play()
            wait(0.15)
            Tooltip.Visible = false
        end)

        -- Indicator
        local Indicator = Instance.new("Frame")
        Indicator.BackgroundColor3 = ThemeColor
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(1, -4, 0, 0)
        Indicator.Size = UDim2.new(0, 4, 0, 0)
        Indicator.Visible = false
        Indicator.Parent = TabBtn
        Indicator.ZIndex = 5

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = ThemeColor
        TabContent.Visible = false
        TabContent.Parent = ContentArea

        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = TabContent
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)

        local ContentPad = Instance.new("UIPadding")
        ContentPad.Parent = TabContent
        ContentPad.PaddingTop = UDim.new(0, 14)
        ContentPad.PaddingLeft = UDim.new(0, 14)
        ContentPad.PaddingRight = UDim.new(0, 14)
        ContentPad.PaddingBottom = UDim.new(0, 14)

        local Tab = {
            Name = tabName,
            Icon = tabIcon,
            Button = TabBtn,
            Content = TabContent
        }

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Button:FindFirstChild("Frame").Visible = false
                t.Button:FindFirstChild("ImageLabel").ImageColor3 = Color3.fromRGB(180, 180, 180)
            end
            TabContent.Visible = true
            Indicator.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.25), {Size = UDim2.new(0, 4, 1, 0)}):Play()
            TabIcon.ImageColor3 = ThemeColor
        end)

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            wait()
            TabContent.Visible = true
            Indicator.Visible = true
            Indicator.Size = UDim2.new(0, 4, 1, 0)
            TabIcon.ImageColor3 = ThemeColor
        end

        function Tab:AddSection(sname)
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = TabContent

            local SectionHead = Instance.new("TextLabel")
            SectionHead.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            SectionHead.BorderSizePixel = 0
            SectionHead.Size = UDim2.new(1, 0, 0, 26)
            SectionHead.Font = Enum.Font.GothamBold
            SectionHead.Text = "◆ " .. sname
            SectionHead.TextColor3 = ThemeColor
            SectionHead.TextSize = 12
            SectionHead.TextXAlignment = Enum.TextXAlignment.Left
            SectionHead.Parent = SectionFrame

            local HeadCorner = Instance.new("UICorner")
            HeadCorner.CornerRadius = UDim.new(0, 10)
            HeadCorner.Parent = SectionHead

            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.Position = UDim2.new(0, 0, 0, 26)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = SectionFrame

            local ContentListLayout = Instance.new("UIListLayout")
            ContentListLayout.Parent = SectionContent
            ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentListLayout.Padding = UDim.new(0, 6)

            function Section:AddToggle(tname, opts)
                opts = opts or {}
                local toggled = opts.Default or false

                local ToggleF = Instance.new("TextButton")
                ToggleF.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                ToggleF.BorderSizePixel = 0
                ToggleF.Size = UDim2.new(1, 0, 0, 38)
                ToggleF.Text = ""
                ToggleF.Parent = SectionContent

                local ToggleFC = Instance.new("UICorner")
                ToggleFC.CornerRadius = UDim.new(0, 10)
                ToggleFC.Parent = ToggleF

                local ToggleL = Instance.new("TextLabel")
                ToggleL.BackgroundTransparency = 1
                ToggleL.Position = UDim2.new(0, 12, 0, 0)
                ToggleL.Size = UDim2.new(1, -65, 1, 0)
                ToggleL.Font = Enum.Font.Gotham
                ToggleL.Text = opts.Text or tname
                ToggleL.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleL.TextSize = 12
                ToggleL.TextXAlignment = Enum.TextXAlignment.Left
                ToggleL.Parent = ToggleF
                ToggleL.ZIndex = 2

                local ToggleS = Instance.new("Frame")
                ToggleS.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                ToggleS.BorderSizePixel = 0
                ToggleS.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleS.Size = UDim2.new(0, 40, 0, 20)
                ToggleS.Parent = ToggleF
                ToggleS.ZIndex = 2

                local ToggleSC = Instance.new("UICorner")
                ToggleSC.CornerRadius = UDim.new(1, 0)
                ToggleSC.Parent = ToggleS

                local ToggleInd = Instance.new("Frame")
                ToggleInd.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                ToggleInd.BorderSizePixel = 0
                ToggleInd.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleInd.Size = UDim2.new(0, 16, 0, 16)
                ToggleInd.Parent = ToggleS
                ToggleInd.ZIndex = 3

                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(1, 0)
                IndCorner.Parent = ToggleInd

                local function UpdateToggle(state)
                    toggled = state
                    if toggled then
                        TweenService:Create(ToggleInd, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = ThemeColor}):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 80)}):Play()
                    else
                        TweenService:Create(ToggleInd, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}):Play()
                    end
                    if opts.Callback then opts.Callback(toggled) end
                end

                ToggleF.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)

                UpdateToggle(toggled)

                return {SetValue = function(self, v) UpdateToggle(v) end, GetValue = function(self) return toggled end}
            end

            function Section:AddButton(bname, opts)
                opts = opts or {}
                local Btn = Instance.new("TextButton")
                Btn.BackgroundColor3 = ThemeColor
                Btn.BackgroundTransparency = 0.2
                Btn.BorderSizePixel = 0
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Text = opts.Text or bname
                Btn.TextColor3 = Color3.fromRGB(235, 235, 235)
                Btn.TextSize = 12
                Btn.Parent = SectionContent

                local BtnC = Instance.new("UICorner")
                BtnC.CornerRadius = UDim.new(0, 10)
                BtnC.Parent = Btn

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
                end)

                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
                end)

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
                    wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                    if opts.Callback then opts.Callback() end
                end)

                return Btn
            end

            function Section:AddSlider(slname, opts)
                opts = opts or {}
                local min, max, default, increment = opts.Min or 0, opts.Max or 100, opts.Default or 0, opts.Increment or 1
                local val = default

                local SliderF = Instance.new("Frame")
                SliderF.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                SliderF.BorderSizePixel = 0
                SliderF.Size = UDim2.new(1, 0, 0, 68)
                SliderF.Parent = SectionContent

                local SliderFC = Instance.new("UICorner")
                SliderFC.CornerRadius = UDim.new(0, 10)
                SliderFC.Parent = SliderF

                local SliderL = Instance.new("TextLabel")
                SliderL.BackgroundTransparency = 1
                SliderL.Position = UDim2.new(0, 12, 0, 6)
                SliderL.Size = UDim2.new(1, -60, 0, 18)
                SliderL.Font = Enum.Font.GothamSemibold
                SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                SliderL.TextColor3 = Color3.fromRGB(235, 235, 235)
                SliderL.TextSize = 12
                SliderL.TextXAlignment = Enum.TextXAlignment.Left
                SliderL.Parent = SliderF

                local InputB = Instance.new("TextBox")
                InputB.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                InputB.BorderSizePixel = 0
                InputB.Position = UDim2.new(1, -52, 0, 6)
                InputB.Size = UDim2.new(0, 48, 0, 18)
                InputB.Font = Enum.Font.Gotham
                InputB.Text = tostring(val)
                InputB.TextColor3 = ThemeColor
                InputB.TextSize = 11
                InputB.Parent = SliderF

                local InputBC = Instance.new("UICorner")
                InputBC.CornerRadius = UDim.new(0, 6)
                InputBC.Parent = InputB

                local SliderB = Instance.new("Frame")
                SliderB.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                SliderB.BorderSizePixel = 0
                SliderB.Position = UDim2.new(0, 12, 0, 32)
                SliderB.Size = UDim2.new(1, -24, 0, 12)
                SliderB.Parent = SliderF

                local SliderBC = Instance.new("UICorner")
                SliderBC.CornerRadius = UDim.new(1, 0)
                SliderBC.Parent = SliderB

                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = ThemeColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderB

                local SliderFillC = Instance.new("UICorner")
                SliderFillC.CornerRadius = UDim.new(1, 0)
                SliderFillC.Parent = SliderFill

                local Thumb = Instance.new("Frame")
                Thumb.BackgroundColor3 = ThemeColor
                Thumb.BorderSizePixel = 0
                Thumb.Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6)
                Thumb.Size = UDim2.new(0, 12, 0, 12)
                Thumb.Parent = SliderB

                local ThumbC = Instance.new("UICorner")
                ThumbC.CornerRadius = UDim.new(1, 0)
                ThumbC.Parent = Thumb

                local dragging = false

                local function Update(input)
                    local pos = math.clamp((input.Position.X - SliderB.AbsolutePosition.X) / SliderB.AbsoluteSize.X, 0, 1)
                    val = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                    val = math.clamp(val, min, max)
                    SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    Thumb.Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6)
                    SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                    InputB.Text = tostring(val)
                    if opts.Callback then opts.Callback(val) end
                end

                SliderB.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end
                end)

                Thumb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                InputB.FocusLost:Connect(function()
                    local v = tonumber(InputB.Text)
                    if v then
                        val = math.clamp(v, min, max)
                        SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                        Thumb.Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6)
                        SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                        InputB.Text = tostring(val)
                        if opts.Callback then opts.Callback(val) end
                    else InputB.Text = tostring(val) end
                end)

                return {SetValue = function(self, v) val = math.clamp(v, min, max); SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); Thumb.Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6); SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val); InputB.Text = tostring(val) end, GetValue = function(self) return val end}
            end

            function Section:AddDropdown(dname, opts)
                opts = opts or {}
                local items = opts.Items or {}
                local current = opts.Default or (items[1] or "None")

                local DropF = Instance.new("Frame")
                DropF.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                DropF.BorderSizePixel = 0
                DropF.Size = UDim2.new(1, 0, 0, 36)
                DropF.Parent = SectionContent

                local DropFC = Instance.new("UICorner")
                DropFC.CornerRadius = UDim.new(0, 10)
                DropFC.Parent = DropF

                local DropBtn = Instance.new("TextButton")
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 1, 0)
                DropBtn.Text = ""
                DropBtn.Parent = DropF

                local DropL = Instance.new("TextLabel")
                DropL.BackgroundTransparency = 1
                DropL.Position = UDim2.new(0, 12, 0, 0)
                DropL.Size = UDim2.new(1, -45, 1, 0)
                DropL.Font = Enum.Font.Gotham
                DropL.Text = current
                DropL.TextColor3 = Color3.fromRGB(235, 235, 235)
                DropL.TextSize = 12
                DropL.TextXAlignment = Enum.TextXAlignment.Left
                DropL.Parent = DropF

                local DropArrow = Instance.new("TextLabel")
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -30, 0, 0)
                DropArrow.Size = UDim2.new(0, 30, 1, 0)
                DropArrow.Font = Enum.Font.GothamBold
                DropArrow.Text = "▼"
                DropArrow.TextColor3 = ThemeColor
                DropArrow.TextSize = 10
                DropArrow.Parent = DropF

                local ItemC = Instance.new("Frame")
                ItemC.BackgroundTransparency = 1
                ItemC.BorderSizePixel = 0
                ItemC.Position = UDim2.new(0, 0, 1, 0)
                ItemC.Size = UDim2.new(1, 0, 0, 0)
                ItemC.Visible = false
                ItemC.Parent = DropF

                local isOpen = false

                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    ItemC.Visible = isOpen
                    ItemC.Size = isOpen and UDim2.new(1, 0, 0, 30 + (#items * 32)) or UDim2.new(1, 0, 0, 0)
                end)

                for i, item in ipairs(items) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Position = UDim2.new(0, 0, 0, 30 + (i-1) * 32)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 32)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = item
                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    ItemBtn.TextSize = 11
                    ItemBtn.Parent = ItemC

                    ItemBtn.MouseButton1Click:Connect(function()
                        current = item
                        DropL.Text = item
                        isOpen = false
                        ItemC.Size = UDim2.new(1, 0, 0, 0)
                        ItemC.Visible = false
                        if opts.Callback then opts.Callback(item) end
                    end)

                    ItemBtn.MouseEnter:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
                    end)

                    ItemBtn.MouseLeave:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
                    end)
                end

                return {SetValue = function(self, v) current = v; DropL.Text = v end, GetValue = function(self) return current end}
            end

            function Section:AddTextBox(tbname, opts)
                opts = opts or {}
                local text = opts.Default or ""

                local TBF = Instance.new("Frame")
                TBF.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                TBF.BorderSizePixel = 0
                TBF.Size = UDim2.new(1, 0, 0, 65)
                TBF.Parent = SectionContent

                local TBFC = Instance.new("UICorner")
                TBFC.CornerRadius = UDim.new(0, 10)
                TBFC.Parent = TBF

                local TBL = Instance.new("TextLabel")
                TBL.BackgroundTransparency = 1
                TBL.Position = UDim2.new(0, 12, 0, 6)
                TBL.Size = UDim2.new(1, -24, 0, 18)
                TBL.Font = Enum.Font.GothamSemibold
                TBL.Text = opts.Text or tbname
                TBL.TextColor3 = Color3.fromRGB(235, 235, 235)
                TBL.TextSize = 12
                TBL.TextXAlignment = Enum.TextXAlignment.Left
                TBL.Parent = TBF

                local TB = Instance.new("TextBox")
                TB.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                TB.BorderSizePixel = 0
                TB.Position = UDim2.new(0, 12, 0, 28)
                TB.Size = UDim2.new(1, -24, 0, 28)
                TB.Font = Enum.Font.Gotham
                TB.Text = text
                TB.PlaceholderText = opts.Placeholder or ""
                TB.TextColor3 = ThemeColor
                TB.TextSize = 12
                TB.ClearTextOnFocus = false
                TB.Parent = TBF

                local TBC = Instance.new("UICorner")
                TBC.CornerRadius = UDim.new(0, 8)
                TBC.Parent = TB

                TB.FocusLost:Connect(function()
                    text = TB.Text
                    if opts.Callback then opts.Callback(text) end
                end)

                return {SetValue = function(self, v) text = v; TB.Text = v end, GetValue = function(self) return text end}
            end

            local function UpdateSize()
                local height = 0
                for _, child in ipairs(SectionContent:GetChildren()) do
                    if child:IsA("GuiObject") then height = height + child.AbsoluteSize.Y + 6 end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, height + 26)
            end

            ContentList.Changed:Connect(function()
                UpdateSize()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
            end)

            return Section
        end

        return Tab
    end

    return Window
end

return UI
