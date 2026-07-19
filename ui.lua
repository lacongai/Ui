-- Roblox Modern UI Library - Glassmorphism Design
-- Premium Glass Effect with 60% Transparency

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Themes = {
    Ocean = Color3.fromRGB(0, 180, 255),
    Sunset = Color3.fromRGB(255, 100, 50),
    Aurora = Color3.fromRGB(0, 255, 180),
    Galaxy = Color3.fromRGB(150, 50, 255),
    Rose = Color3.fromRGB(255, 80, 150),
    Gold = Color3.fromRGB(255, 200, 50),
    Emerald = Color3.fromRGB(50, 255, 150),
    Ruby = Color3.fromRGB(255, 50, 50),
    Sapphire = Color3.fromRGB(50, 100, 255),
    Diamond = Color3.fromRGB(200, 220, 255),
    Magma = Color3.fromRGB(255, 100, 0),
    Frost = Color3.fromRGB(150, 255, 255)
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
    local theme = config.Theme or "Ocean"
    local toggleIcon = config.ToggleIcon
    local width = config.Width or 800
    local height = config.Height or 620

    local ThemeColor = Themes[theme] or Themes.Ocean
    local GlassColor = Color3.fromRGB(255, 255, 255)
    local GlassTransparency = 0.6

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PremiumUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Background Overlay
    local Overlay = Instance.new("Frame")
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.3
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.Parent = ScreenGui

    -- Main Window - Glassmorphism
    local MainFrame = Instance.new("Frame")
    MainFrame.BackgroundColor3 = GlassColor
    MainFrame.BackgroundTransparency = GlassTransparency
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 28)
    Corner.Parent = MainFrame

    -- Border Glow
    local BorderGlow = Instance.new("Frame")
    BorderGlow.BackgroundColor3 = ThemeColor
    BorderGlow.BackgroundTransparency = 0.5
    BorderGlow.BorderSizePixel = 0
    BorderGlow.Position = UDim2.new(0, -2, 0, -2)
    BorderGlow.Size = UDim2.new(1, 4, 1, 4)
    BorderGlow.ZIndex = 0
    BorderGlow.Parent = MainFrame

    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 30)
    BorderCorner.Parent = BorderGlow

    -- Inner Glow
    local InnerGlow = Instance.new("Frame")
    InnerGlow.BackgroundColor3 = ThemeColor
    InnerGlow.BackgroundTransparency = 0.85
    InnerGlow.BorderSizePixel = 0
    InnerGlow.Position = UDim2.new(0.05, 0, 0.05, 0)
    InnerGlow.Size = UDim2.new(0.9, 0, 0.9, 0)
    InnerGlow.ZIndex = 0
    InnerGlow.Parent = MainFrame

    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 26)
    InnerCorner.Parent = InnerGlow

    -- Floating Particles Background
    for i = 1, 20 do
        local Particle = Instance.new("Frame")
        Particle.BackgroundColor3 = ThemeColor
        Particle.BackgroundTransparency = 0.7
        Particle.BorderSizePixel = 0
        Particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
        Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Particle.ZIndex = 0
        Particle.Parent = MainFrame

        local ParticleCorner = Instance.new("UICorner")
        ParticleCorner.CornerRadius = UDim.new(1, 0)
        ParticleCorner.Parent = Particle

        TweenService:Create(Particle, TweenInfo.new(
            math.random(3, 8), 
            Enum.EasingStyle.Sine, 
            Enum.EasingDirection.InOut, 
            -1, 
            true
        ), {
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundTransparency = math.random(4, 8) / 10
        }):Play()
    end

    -- Top Section with Gradient
    local TopSection = Instance.new("Frame")
    TopSection.BackgroundColor3 = GlassColor
    TopSection.BackgroundTransparency = 0.2
    TopSection.BorderSizePixel = 0
    TopSection.Size = UDim2.new(1, 0, 0, 85)
    TopSection.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 28)
    TopCorner.Parent = TopSection

    -- Gradient Line
    local GradientLine = Instance.new("Frame")
    GradientLine.BackgroundColor3 = ThemeColor
    GradientLine.BackgroundTransparency = 0.3
    GradientLine.BorderSizePixel = 0
    GradientLine.Position = UDim2.new(0, 0, 1, -3)
    GradientLine.Size = UDim2.new(0.8, 0, 0, 3)
    GradientLine.Parent = TopSection

    -- Drag Area
    local DragArea = Instance.new("Frame")
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, -60, 1, 0)
    DragArea.Parent = TopSection

    -- Title with Glow Effect
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 28, 0, 14)
    TitleLabel.Size = UDim2.new(1, -100, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = ThemeColor
    TitleLabel.TextSize = 26
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopSection

    -- Title Shadow
    local TitleShadow = TitleLabel:Clone()
    TitleShadow.Position = UDim2.new(0, 30, 0, 16)
    TitleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    TitleShadow.TextTransparency = 0.7
    TitleShadow.ZIndex = -1
    TitleShadow.Parent = TopSection

    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(0, 28, 0, 48)
    SubLabel.Size = UDim2.new(1, -100, 0, 16)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.TextTransparency = 0.3
    SubLabel.Parent = TopSection

    -- Premium Badge
    local Badge = Instance.new("TextLabel")
    Badge.BackgroundColor3 = ThemeColor
    Badge.BackgroundTransparency = 0.85
    Badge.BorderSizePixel = 0
    Badge.Position = UDim2.new(0.7, 0, 0, 22)
    Badge.Size = UDim2.new(0, 80, 0, 24)
    Badge.Font = Enum.Font.GothamBold
    Badge.Text = "✦ PREMIUM"
    Badge.TextColor3 = ThemeColor
    Badge.TextSize = 9
    Badge.Parent = TopSection

    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(1, 0)
    BadgeCorner.Parent = Badge

    -- Close Button with Hover Animation
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundTransparency = 0.85
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -48, 0, 28)
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 18
    CloseBtn.Parent = TopSection

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        }):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.85,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, width, 0, 0),
            Position = UDim2.new(0.5, -width / 2, 0.5, 0)
        }):Play()
        TweenService:Create(Overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)

    MakeDragFromArea(MainFrame, DragArea)

    -- Sidebar - Glass Panel
    local Sidebar = Instance.new("Frame")
    Sidebar.BackgroundColor3 = GlassColor
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 8, 0, 85)
    Sidebar.Size = UDim2.new(0, 85, 1, -93)
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 20)
    SidebarCorner.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 6)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)

    -- Content Area - Glass Panel
    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundColor3 = GlassColor
    ContentArea.BackgroundTransparency = 0.3
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 100, 0, 85)
    ContentArea.Size = UDim2.new(1, -108, 1, -93)
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 20)
    ContentCorner.Parent = ContentArea

    -- Toggle Button - Floating Glass
    local ToggleBtn = Instance.new("Frame")
    ToggleBtn.BackgroundColor3 = GlassColor
    ToggleBtn.BackgroundTransparency = 0.3
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 20)
    ToggleCorner.Parent = ToggleBtn

    -- Toggle Glow Ring
    local ToggleRing = Instance.new("Frame")
    ToggleRing.BackgroundColor3 = ThemeColor
    ToggleRing.BackgroundTransparency = 0.6
    ToggleRing.BorderSizePixel = 0
    ToggleRing.Size = UDim2.new(1.15, 0, 1.15, 0)
    ToggleRing.Position = UDim2.new(-0.075, 0, -0.075, 0)
    ToggleRing.ZIndex = 0
    ToggleRing.Parent = ToggleBtn

    local RingCorner = Instance.new("UICorner")
    RingCorner.CornerRadius = UDim.new(0, 23)
    RingCorner.Parent = ToggleRing

    local ToggleInner = Instance.new("Frame")
    ToggleInner.BackgroundColor3 = ThemeColor
    ToggleInner.BackgroundTransparency = 0.85
    ToggleInner.BorderSizePixel = 0
    ToggleInner.Size = UDim2.new(1, 0, 1, 0)
    ToggleInner.Parent = ToggleBtn

    local InnerCorner2 = Instance.new("UICorner")
    InnerCorner2.CornerRadius = UDim.new(0, 18)
    InnerCorner2.Parent = ToggleInner

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 4)
    Padding.PaddingLeft = UDim.new(0, 4)
    Padding.PaddingRight = UDim.new(0, 4)
    Padding.PaddingTop = UDim.new(0, 4)
    Padding.Parent = ToggleInner

    if toggleIcon then
        local ToggleImg = Instance.new("ImageButton")
        ToggleImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleImg.BackgroundTransparency = 0.5
        ToggleImg.BorderSizePixel = 0
        ToggleImg.Size = UDim2.new(1, 0, 1, 0)
        ToggleImg.Image = GetIcon(toggleIcon)
        ToggleImg.ImageColor3 = ThemeColor
        ToggleImg.Parent = ToggleInner

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 14)
        ImgCorner.Parent = ToggleImg

        local visible = true
        ToggleImg.MouseButton1Click:Connect(function()
            visible = not visible
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {
                BackgroundTransparency = visible and GlassTransparency or 1,
                Size = visible and UDim2.new(0, width, 0, height) or UDim2.new(0, 0, 0, 0)
            }):Play()
        end)
    else
        local ToggleText = Instance.new("TextButton")
        ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.BackgroundTransparency = 0.5
        ToggleText.BorderSizePixel = 0
        ToggleText.Size = UDim2.new(1, 0, 1, 0)
        ToggleText.Font = Enum.Font.GothamBold
        ToggleText.Text = "◆"
        ToggleText.TextColor3 = ThemeColor
        ToggleText.TextSize = 34
        ToggleText.Parent = ToggleInner

        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 14)
        TxtCorner.Parent = ToggleText

        local visible = true
        ToggleText.MouseButton1Click:Connect(function()
            visible = not visible
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {
                BackgroundTransparency = visible and GlassTransparency or 1,
                Size = visible and UDim2.new(0, width, 0, height) or UDim2.new(0, 0, 0, 0)
            }):Play()
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

        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundColor3 = GlassColor
        TabBtn.BackgroundTransparency = 0.7
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 65)
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 14)
        TabCorner.Parent = TabBtn

        -- Tab Icon with Glow
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, -18, 0.5, -18)
        TabIcon.Size = UDim2.new(0, 36, 0, 36)
        TabIcon.Image = GetIcon(tabIcon)
        TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 200)
        TabIcon.Parent = TabBtn

        -- Icon Glow
        local IconGlow = Instance.new("Frame")
        IconGlow.BackgroundColor3 = ThemeColor
        IconGlow.BackgroundTransparency = 0.9
        IconGlow.BorderSizePixel = 0
        IconGlow.Position = UDim2.new(0.5, -24, 0.5, -24)
        IconGlow.Size = UDim2.new(0, 48, 0, 48)
        IconGlow.ZIndex = -1
        IconGlow.Parent = TabBtn

        local GlowCorner = Instance.new("UICorner")
        GlowCorner.CornerRadius = UDim.new(1, 0)
        GlowCorner.Parent = IconGlow

        -- Tooltip with Glass Effect
        local Tooltip = Instance.new("TextLabel")
        Tooltip.BackgroundColor3 = GlassColor
        Tooltip.BackgroundTransparency = 0.2
        Tooltip.BorderSizePixel = 0
        Tooltip.Position = UDim2.new(1, 12, 0.5, -14)
        Tooltip.Size = UDim2.new(0, 0, 0, 28)
        Tooltip.Font = Enum.Font.GothamSemibold
        Tooltip.Text = tabName
        Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tooltip.TextSize = 11
        Tooltip.Visible = false
        Tooltip.Parent = TabBtn

        local TipCorner = Instance.new("UICorner")
        TipCorner.CornerRadius = UDim.new(0, 10)
        TipCorner.Parent = Tooltip

        TabBtn.MouseEnter:Connect(function()
            Tooltip.Visible = true
            TweenService:Create(Tooltip, TweenInfo.new(0.15), {Size = UDim2.new(0, 110, 0, 28)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
        end)

        TabBtn.MouseLeave:Connect(function()
            TweenService:Create(Tooltip, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 28)}):Play()
            wait(0.15)
            Tooltip.Visible = false
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
        end)

        -- Indicator - Glowing Line
        local Indicator = Instance.new("Frame")
        Indicator.BackgroundColor3 = ThemeColor
        Indicator.BackgroundTransparency = 0.3
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(1, -4, 0, 4)
        Indicator.Size = UDim2.new(0, 4, 0, 0)
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = Indicator

        -- Indicator Glow
        local IndicatorGlow = Instance.new("Frame")
        IndicatorGlow.BackgroundColor3 = ThemeColor
        IndicatorGlow.BackgroundTransparency = 0.7
        IndicatorGlow.BorderSizePixel = 0
        IndicatorGlow.Position = UDim2.new(1, -8, 0, 0)
        IndicatorGlow.Size = UDim2.new(0, 12, 1, 0)
        IndicatorGlow.ZIndex = -1
        IndicatorGlow.Parent = TabBtn

        local GlowCorner2 = Instance.new("UICorner")
        GlowCorner2.CornerRadius = UDim.new(0, 6)
        GlowCorner2.Parent = IndicatorGlow

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = ThemeColor
        TabContent.ScrollBarBackgroundTransparency = 0.8
        TabContent.Visible = false
        TabContent.Parent = ContentArea

        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = TabContent
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 12)

        local ContentPad = Instance.new("UIPadding")
        ContentPad.Parent = TabContent
        ContentPad.PaddingTop = UDim.new(0, 16)
        ContentPad.PaddingLeft = UDim.new(0, 16)
        ContentPad.PaddingRight = UDim.new(0, 16)
        ContentPad.PaddingBottom = UDim.new(0, 16)

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
                t.Button:FindFirstChild("ImageLabel").ImageColor3 = Color3.fromRGB(180, 180, 200)
                TweenService:Create(t.Button, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
            end
            TabContent.Visible = true
            Indicator.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 1, -8)}):Play()
            TabIcon.ImageColor3 = ThemeColor
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        end)

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            wait()
            TabContent.Visible = true
            Indicator.Visible = true
            Indicator.Size = UDim2.new(0, 4, 1, -8)
            TabIcon.ImageColor3 = ThemeColor
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        end

        function Tab:AddSection(sname)
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = TabContent

            local SectionHead = Instance.new("TextLabel")
            SectionHead.BackgroundColor3 = GlassColor
            SectionHead.BackgroundTransparency = 0.2
            SectionHead.BorderSizePixel = 0
            SectionHead.Size = UDim2.new(1, 0, 0, 28)
            SectionHead.Font = Enum.Font.GothamBold
            SectionHead.Text = "✦ " .. sname
            SectionHead.TextColor3 = ThemeColor
            SectionHead.TextSize = 12
            SectionHead.TextXAlignment = Enum.TextXAlignment.Left
            SectionHead.Parent = SectionFrame

            local HeadCorner = Instance.new("UICorner")
            HeadCorner.CornerRadius = UDim.new(0, 10)
            HeadCorner.Parent = SectionHead

            -- Section line
            local SectionLine = Instance.new("Frame")
            SectionLine.BackgroundColor3 = ThemeColor
            SectionLine.BackgroundTransparency = 0.7
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0.3, 0, 0.5, 0)
            SectionLine.Size = UDim2.new(0.65, 0, 0, 1)
            SectionLine.Parent = SectionHead

            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.Position = UDim2.new(0, 0, 0, 28)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = SectionFrame

            local ContentListLayout = Instance.new("UIListLayout")
            ContentListLayout.Parent = SectionContent
            ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentListLayout.Padding = UDim.new(0, 8)

            function Section:AddToggle(tname, opts)
                opts = opts or {}
                local toggled = opts.Default or false

                local ToggleF = Instance.new("TextButton")
                ToggleF.BackgroundColor3 = GlassColor
                ToggleF.BackgroundTransparency = 0.5
                ToggleF.BorderSizePixel = 0
                ToggleF.Size = UDim2.new(1, 0, 0, 40)
                ToggleF.Text = ""
                ToggleF.Parent = SectionContent

                local ToggleFC = Instance.new("UICorner")
                ToggleFC.CornerRadius = UDim.new(0, 12)
                ToggleFC.Parent = ToggleF

                local ToggleL = Instance.new("TextLabel")
                ToggleL.BackgroundTransparency = 1
                ToggleL.Position = UDim2.new(0, 14, 0, 0)
                ToggleL.Size = UDim2.new(1, -70, 1, 0)
                ToggleL.Font = Enum.Font.Gotham
                ToggleL.Text = opts.Text or tname
                ToggleL.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleL.TextSize = 12
                ToggleL.TextXAlignment = Enum.TextXAlignment.Left
                ToggleL.Parent = ToggleF
                ToggleL.ZIndex = 2

                -- Toggle Switch - Premium Style
                local ToggleS = Instance.new("Frame")
                ToggleS.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                ToggleS.BackgroundTransparency = 0.5
                ToggleS.BorderSizePixel = 0
                ToggleS.Position = UDim2.new(1, -54, 0.5, -12)
                ToggleS.Size = UDim2.new(0, 44, 0, 24)
                ToggleS.Parent = ToggleF
                ToggleS.ZIndex = 2

                local ToggleSC = Instance.new("UICorner")
                ToggleSC.CornerRadius = UDim.new(1, 0)
                ToggleSC.Parent = ToggleS

                local ToggleInd = Instance.new("Frame")
                ToggleInd.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
                ToggleInd.BackgroundTransparency = 0.3
                ToggleInd.BorderSizePixel = 0
                ToggleInd.Position = UDim2.new(0, 3, 0.5, -9)
                ToggleInd.Size = UDim2.new(0, 18, 0, 18)
                ToggleInd.Parent = ToggleS
                ToggleInd.ZIndex = 3

                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(1, 0)
                IndCorner.Parent = ToggleInd

                -- Toggle Glow
                local ToggleGlow = Instance.new("Frame")
                ToggleGlow.BackgroundColor3 = ThemeColor
                ToggleGlow.BackgroundTransparency = 0.8
                ToggleGlow.BorderSizePixel = 0
                ToggleGlow.Position = UDim2.new(0, -6, 0, -6)
                ToggleGlow.Size = UDim2.new(1, 12, 1, 12)
                ToggleGlow.ZIndex = 1
                ToggleGlow.Parent = ToggleS

                local GlowCorner3 = Instance.new("UICorner")
                GlowCorner3.CornerRadius = UDim.new(1, 0)
                GlowCorner3.Parent = ToggleGlow

                local function UpdateToggle(state)
                    toggled = state
                    if toggled then
                        TweenService:Create(ToggleInd, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Position = UDim2.new(1, -21, 0.5, -9),
                            BackgroundColor3 = ThemeColor,
                            BackgroundTransparency = 0
                        }):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = ThemeColor,
                            BackgroundTransparency = 0.3
                        }):Play()
                        TweenService:Create(ToggleGlow, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundTransparency = 0.5
                        }):Play()
                    else
                        TweenService:Create(ToggleInd, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Position = UDim2.new(0, 3, 0.5, -9),
                            BackgroundColor3 = Color3.fromRGB(150, 150, 170),
                            BackgroundTransparency = 0.3
                        }):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 80),
                            BackgroundTransparency = 0.5
                        }):Play()
                        TweenService:Create(ToggleGlow, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundTransparency = 0.8
                        }):Play()
                    end
                    if opts.Callback then opts.Callback(toggled) end
                end

                ToggleF.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)

                ToggleF.MouseEnter:Connect(function()
                    TweenService:Create(ToggleF, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
                end)

                ToggleF.MouseLeave:Connect(function()
                    TweenService:Create(ToggleF, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
                end)

                UpdateToggle(toggled)

                return {SetValue = function(self, v) UpdateToggle(v) end, GetValue = function(self) return toggled end}
            end

            function Section:AddButton(bname, opts)
                opts = opts or {}
                local Btn = Instance.new("TextButton")
                Btn.BackgroundColor3 = ThemeColor
                Btn.BackgroundTransparency = 0.5
                Btn.BorderSizePixel = 0
                Btn.Size = UDim2.new(1, 0, 0, 38)
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Text = opts.Text or bname
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.TextSize = 12
                Btn.Parent = SectionContent

                local BtnC = Instance.new("UICorner")
                BtnC.CornerRadius = UDim.new(0, 12)
                BtnC.Parent = Btn

                -- Button Glow
                local BtnGlow = Instance.new("Frame")
                BtnGlow.BackgroundColor3 = ThemeColor
                BtnGlow.BackgroundTransparency = 0.8
                BtnGlow.BorderSizePixel = 0
                BtnGlow.Position = UDim2.new(0, -4, 0, -4)
                BtnGlow.Size = UDim2.new(1, 8, 1, 8)
                BtnGlow.ZIndex = -1
                BtnGlow.Parent = Btn

                local GlowCorner4 = Instance.new("UICorner")
                GlowCorner4.CornerRadius = UDim.new(0, 14)
                GlowCorner4.Parent = BtnGlow

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
                    TweenService:Create(BtnGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
                end)

                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
                    TweenService:Create(BtnGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
                end)

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
                    wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
                    if opts.Callback then opts.Callback() end
                end)

                return Btn
            end

            function Section:AddSlider(slname, opts)
                opts = opts or {}
                local min, max, default, increment = opts.Min or 0, opts.Max or 100, opts.Default or 0, opts.Increment or 1
                local val = default

                local SliderF = Instance.new("Frame")
                SliderF.BackgroundColor3 = GlassColor
                SliderF.BackgroundTransparency = 0.5
                SliderF.BorderSizePixel = 0
                SliderF.Size = UDim2.new(1, 0, 0, 72)
                SliderF.Parent = SectionContent

                local SliderFC = Instance.new("UICorner")
                SliderFC.CornerRadius = UDim.new(0, 12)
                SliderFC.Parent = SliderF

                local SliderL = Instance.new("TextLabel")
                SliderL.BackgroundTransparency = 1
                SliderL.Position = UDim2.new(0, 14, 0, 8)
                SliderL.Size = UDim2.new(1, -60, 0, 18)
                SliderL.Font = Enum.Font.GothamSemibold
                SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                SliderL.TextColor3 = Color3.fromRGB(235, 235, 245)
                SliderL.TextSize = 12
                SliderL.TextXAlignment = Enum.TextXAlignment.Left
                SliderL.Parent = SliderF

                local InputB = Instance.new("TextBox")
                InputB.BackgroundColor3 = GlassColor
                InputB.BackgroundTransparency = 0.4
                InputB.BorderSizePixel = 0
                InputB.Position = UDim2.new(1, -56, 0, 8)
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
                SliderB.BackgroundColor3 = GlassColor
                SliderB.BackgroundTransparency = 0.6
                SliderB.BorderSizePixel = 0
                SliderB.Position = UDim2.new(0, 14, 0, 36)
                SliderB.Size = UDim2.new(1, -28, 0, 14)
                SliderB.Parent = SliderF

                local SliderBC = Instance.new("UICorner")
                SliderBC.CornerRadius = UDim.new(1, 0)
                SliderBC.Parent = SliderB

                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = ThemeColor
                SliderFill.BackgroundTransparency = 0.2
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderB

                local SliderFillC = Instance.new("UICorner")
                SliderFillC.CornerRadius = UDim.new(1, 0)
                SliderFillC.Parent = SliderFill

                -- Fill Glow
                local FillGlow = Instance.new("Frame")
                FillGlow.BackgroundColor3 = ThemeColor
                FillGlow.BackgroundTransparency = 0.6
                FillGlow.BorderSizePixel = 0
                FillGlow.Position = UDim2.new(0, 0, 0, -4)
                FillGlow.Size = UDim2.new(1, 0, 1, 8)
                FillGlow.ZIndex = -1
                FillGlow.Parent = SliderFill

                local FillGlowCorner = Instance.new("UICorner")
                FillGlowCorner.CornerRadius = UDim.new(1, 0)
                FillGlowCorner.Parent = FillGlow

                local Thumb = Instance.new("Frame")
                Thumb.BackgroundColor3 = ThemeColor
                Thumb.BackgroundTransparency = 0
                Thumb.BorderSizePixel = 0
                Thumb.Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7)
                Thumb.Size = UDim2.new(0, 14, 0, 14)
                Thumb.Parent = SliderB

                local ThumbC = Instance.new("UICorner")
                ThumbC.CornerRadius = UDim.new(1, 0)
                ThumbC.Parent = Thumb

                -- Thumb Glow
                local ThumbGlow = Instance.new("Frame")
                ThumbGlow.BackgroundColor3 = ThemeColor
                ThumbGlow.BackgroundTransparency = 0.7
                ThumbGlow.BorderSizePixel = 0
                ThumbGlow.Position = UDim2.new(0, -6, 0, -6)
                ThumbGlow.Size = UDim2.new(1, 12, 1, 12)
                ThumbGlow.ZIndex = -1
                ThumbGlow.Parent = Thumb

                local ThumbGlowCorner = Instance.new("UICorner")
                ThumbGlowCorner.CornerRadius = UDim.new(1, 0)
                ThumbGlowCorner.Parent = ThumbGlow

                local dragging = false

                local function Update(input)
                    local pos = math.clamp((input.Position.X - SliderB.AbsolutePosition.X) / SliderB.AbsoluteSize.X, 0, 1)
                    val = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                    val = math.clamp(val, min, max)
                    SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    FillGlow.Size = UDim2.new((val - min) / (max - min), 0, 1, 8)
                    Thumb.Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7)
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
                        FillGlow.Size = UDim2.new((val - min) / (max - min), 0, 1, 8)
                        Thumb.Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7)
                        SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                        InputB.Text = tostring(val)
                        if opts.Callback then opts.Callback(val) end
                    else InputB.Text = tostring(val) end
                end)

                return {SetValue = function(self, v) 
                    val = math.clamp(v, min, max)
                    SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    FillGlow.Size = UDim2.new((val - min) / (max - min), 0, 1, 8)
                    Thumb.Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7)
                    SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                    InputB.Text = tostring(val)
                end, GetValue = function(self) return val end}
            end

            function Section:AddDropdown(dname, opts)
                opts = opts or {}
                local items = opts.Items or {}
                local current = opts.Default or (items[1] or "None")

                local DropF = Instance.new("Frame")
                DropF.BackgroundColor3 = GlassColor
                DropF.BackgroundTransparency = 0.5
                DropF.BorderSizePixel = 0
                DropF.Size = UDim2.new(1, 0, 0, 38)
                DropF.Parent = SectionContent

                local DropFC = Instance.new("UICorner")
                DropFC.CornerRadius = UDim.new(0, 12)
                DropFC.Parent = DropF

                local DropBtn = Instance.new("TextButton")
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 1, 0)
                DropBtn.Text = ""
                DropBtn.Parent = DropF

                local DropL = Instance.new("TextLabel")
                DropL.BackgroundTransparency = 1
                DropL.Position = UDim2.new(0, 14, 0, 0)
                DropL.Size = UDim2.new(1, -50, 1, 0)
                DropL.Font = Enum.Font.Gotham
                DropL.Text = current
                DropL.TextColor3 = Color3.fromRGB(235, 235, 245)
                DropL.TextSize = 12
                DropL.TextXAlignment = Enum.TextXAlignment.Left
                DropL.Parent = DropF

                local DropArrow = Instance.new("TextLabel")
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -32, 0, 0)
                DropArrow.Size = UDim2.new(0, 30, 1, 0)
                DropArrow.Font = Enum.Font.GothamBold
                DropArrow.Text = "▼"
                DropArrow.TextColor3 = ThemeColor
                DropArrow.TextSize = 10
                DropArrow.Parent = DropF

                local ItemC = Instance.new("Frame")
                ItemC.BackgroundColor3 = GlassColor
                ItemC.BackgroundTransparency = 0.3
                ItemC.BorderSizePixel = 0
                ItemC.Position = UDim2.new(0, 0, 1, 4)
                ItemC.Size = UDim2.new(1, 0, 0, 0)
                ItemC.Visible = false
                ItemC.Parent = DropF

                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 10)
                ItemCorner.Parent = ItemC

                local isOpen = false

                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    ItemC.Visible = isOpen
                    TweenService:Create(ItemC, TweenInfo.new(0.2), {
                        Size = isOpen and UDim2.new(1, 0, 0, 32 + (#items * 34)) or UDim2.new(1, 0, 0, 0)
                    }):Play()
                end)

                for i, item in ipairs(items) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.BackgroundColor3 = GlassColor
                    ItemBtn.BackgroundTransparency = 0.6
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Position = UDim2.new(0, 0, 0, 32 + (i-1) * 34)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 34)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = item
                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                    ItemBtn.TextSize = 11
                    ItemBtn.Parent = ItemC

                    local ItemBtnCorner = Instance.new("UICorner")
                    ItemBtnCorner.CornerRadius = UDim.new(0, 8)
                    ItemBtnCorner.Parent = ItemBtn

                    ItemBtn.MouseButton1Click:Connect(function()
                        current = item
                        DropL.Text = item
                        isOpen = false
                        TweenService:Create(ItemC, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        wait(0.15)
                        ItemC.Visible = false
                        if opts.Callback then opts.Callback(item) end
                    end)

                    ItemBtn.MouseEnter:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
                    end)

                    ItemBtn.MouseLeave:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play()
                    end)
                end

                return {SetValue = function(self, v) current = v; DropL.Text = v end, GetValue = function(self) return current end}
            end

            function Section:AddTextBox(tbname, opts)
                opts = opts or {}
                local text = opts.Default or ""

                local TBF = Instance.new("Frame")
                TBF.BackgroundColor3 = GlassColor
                TBF.BackgroundTransparency = 0.5
                TBF.BorderSizePixel = 0
                TBF.Size = UDim2.new(1, 0, 0, 68)
                TBF.Parent = SectionContent

                local TBFC = Instance.new("UICorner")
                TBFC.CornerRadius = UDim.new(0, 12)
                TBFC.Parent = TBF

                local TBL = Instance.new("TextLabel")
                TBL.BackgroundTransparency = 1
                TBL.Position = UDim2.new(0, 14, 0, 8)
                TBL.Size = UDim2.new(1, -28, 0, 18)
                TBL.Font = Enum.Font.GothamSemibold
                TBL.Text = opts.Text or tbname
                TBL.TextColor3 = Color3.fromRGB(235, 235, 245)
                TBL.TextSize = 12
                TBL.TextXAlignment = Enum.TextXAlignment.Left
                TBL.Parent = TBF

                local TB = Instance.new("TextBox")
                TB.BackgroundColor3 = GlassColor
                TB.BackgroundTransparency = 0.4
                TB.BorderSizePixel = 0
                TB.Position = UDim2.new(0, 14, 0, 30)
                TB.Size = UDim2.new(1, -28, 0, 28)
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
                    if child:IsA("GuiObject") then height = height + child.AbsoluteSize.Y + 8 end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, height + 28)
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