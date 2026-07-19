-- Roblox Modern UI Library - Premium Glass Design
-- Độ trong suốt 60% với hiệu ứng thủy tinh hiện đại

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Bảng màu mở rộng với nhiều lựa chọn đa dạng
local Themes = {
    -- Màu cơ bản
    Dark = Color3.fromRGB(100, 150, 255),
    Red = Color3.fromRGB(255, 80, 80),
    Green = Color3.fromRGB(80, 255, 120),
    Blue = Color3.fromRGB(80, 180, 255),
    Purple = Color3.fromRGB(180, 100, 255),
    Pink = Color3.fromRGB(255, 120, 180),
    Orange = Color3.fromRGB(255, 150, 80),
    Yellow = Color3.fromRGB(255, 220, 80),
    Cyan = Color3.fromRGB(80, 220, 255),
    Magenta = Color3.fromRGB(255, 80, 200),
    -- Màu Premium
    Rose = Color3.fromRGB(255, 100, 130),
    Violet = Color3.fromRGB(130, 80, 255),
    Teal = Color3.fromRGB(80, 200, 200),
    Coral = Color3.fromRGB(255, 130, 100),
    Mint = Color3.fromRGB(100, 255, 180),
    Amber = Color3.fromRGB(255, 180, 60),
    Lavender = Color3.fromRGB(180, 140, 255),
    Sky = Color3.fromRGB(100, 200, 255),
    Blush = Color3.fromRGB(255, 150, 180),
    Lime = Color3.fromRGB(150, 255, 80),
    -- Màu Neon
    NeonPink = Color3.fromRGB(255, 20, 147),
    NeonBlue = Color3.fromRGB(0, 150, 255),
    NeonGreen = Color3.fromRGB(57, 255, 20),
    NeonOrange = Color3.fromRGB(255, 140, 0),
    NeonPurple = Color3.fromRGB(180, 0, 255),
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
    box = "rbxassetid://10709789989",
    music = "rbxassetid://10709792891",
    book = "rbxassetid://10709790258",
    cloud = "rbxassetid://10709790443",
    compass = "rbxassetid://10709790537",
    diamond = "rbxassetid://10709790644",
    eye = "rbxassetid://10709790755",
    feather = "rbxassetid://10709790866",
    key = "rbxassetid://10709790948",
    lock = "rbxassetid://10709791055",
    map = "rbxassetid://10709791151",
    moon = "rbxassetid://10709791263",
    sun = "rbxassetid://10709791374",
    tree = "rbxassetid://10709791437",
    wand = "rbxassetid://10709791548",
}

local function GetIcon(name)
    if string.find(name, "rbxassetid://") then return name end
    return IconLibrary[name] or IconLibrary.home
end

-- Tạo hiệu ứng chuyển màu gradient
local function CreateGradient(colors, angle)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = angle or 45
    for i, color in ipairs(colors) do
        local stop = Instance.new("NumberSequenceKeypoint")
        stop.Time = (i - 1) / (#colors - 1)
        stop.Value = color
        gradient.Color = NumberSequence.new(gradient.Color or NumberSequence.new(), stop)
    end
    return gradient
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
    local SecondaryColor = ThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.3)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- === CỬA SỔ CHÍNH - THIẾT KẾ THỦY TINH HIỆN ĐẠI ===
    local MainFrame = Instance.new("Frame")
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
    MainFrame.BackgroundTransparency = 0.4 -- 60% độ trong suốt
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Bo góc chính - bo tròn hơn
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 28)
    Corner.Parent = MainFrame

    -- Viền phát sáng cho hiệu ứng Glass
    local BorderGlow = Instance.new("Frame")
    BorderGlow.BackgroundTransparency = 0.85
    BorderGlow.BackgroundColor3 = ThemeColor
    BorderGlow.BorderSizePixel = 0
    BorderGlow.Position = UDim2.new(-0.02, 0, -0.02, 0)
    BorderGlow.Size = UDim2.new(1.04, 0, 1.04, 0)
    BorderGlow.ZIndex = 0
    BorderGlow.Parent = MainFrame
    
    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 32)
    BorderCorner.Parent = BorderGlow

    -- Hiệu ứng mờ Glass (ImageLabel với blur)
    local GlassBlur = Instance.new("ImageLabel")
    GlassBlur.BackgroundTransparency = 1
    GlassBlur.Position = UDim2.new(0, 0, 0, 0)
    GlassBlur.Size = UDim2.new(1, 0, 1, 0)
    GlassBlur.Image = "rbxassetid://6014261993"
    GlassBlur.ImageColor3 = Color3.fromRGB(30, 30, 50)
    GlassBlur.ImageTransparency = 0.6
    GlassBlur.ScaleType = Enum.ScaleType.Slice
    GlassBlur.SliceCenter = Rect.new(99, 99, 99, 99)
    GlassBlur.ZIndex = 0
    GlassBlur.Parent = MainFrame

    -- Lớp phủ gradient chuyển động
    local GradientOverlay = Instance.new("Frame")
    GradientOverlay.BackgroundTransparency = 0.85
    GradientOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GradientOverlay.BorderSizePixel = 0
    GradientOverlay.Size = UDim2.new(1, 0, 1, 0)
    GradientOverlay.ZIndex = 1
    GradientOverlay.Parent = MainFrame
    
    local GradOverlayCorner = Instance.new("UICorner")
    GradOverlayCorner.CornerRadius = UDim.new(0, 28)
    GradOverlayCorner.Parent = GradientOverlay

    -- Hiệu ứng ánh sáng chuyển động
    local ShineEffect = Instance.new("ImageLabel")
    ShineEffect.BackgroundTransparency = 1
    ShineEffect.Size = UDim2.new(1.5, 0, 1, 0)
    ShineEffect.Image = "rbxassetid://6014261993"
    ShineEffect.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ShineEffect.ImageTransparency = 0.85
    ShineEffect.ScaleType = Enum.ScaleType.Slice
    ShineEffect.SliceCenter = Rect.new(99, 99, 99, 99)
    ShineEffect.ZIndex = 2
    ShineEffect.Parent = MainFrame

    -- Animation ánh sáng
    local shineAngle = 0
    RunService.Heartbeat:Connect(function(dt)
        shineAngle = (shineAngle + dt * 15) % 360
        ShineEffect.Position = UDim2.new(math.sin(math.rad(shineAngle)) * 0.2 + 0.3, 0, 0, 0)
    end)

    -- === HEADER ===
    local TopSection = Instance.new("Frame")
    TopSection.BackgroundTransparency = 0.6
    TopSection.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    TopSection.BorderSizePixel = 0
    TopSection.Size = UDim2.new(1, 0, 0, 80)
    TopSection.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 28)
    TopCorner.Parent = TopSection

    -- Thanh gradient trang trí
    local AccentBar = Instance.new("Frame")
    AccentBar.BackgroundTransparency = 0.1
    AccentBar.BackgroundColor3 = ThemeColor
    AccentBar.BorderSizePixel = 0
    AccentBar.Position = UDim2.new(0, 0, 1, -3)
    AccentBar.Size = UDim2.new(0.7, 0, 0, 3)
    AccentBar.Parent = TopSection
    AccentBar.ZIndex = 10
    
    local AccentGrad = Instance.new("UIGradient")
    AccentGrad.Rotation = 90
    AccentGrad.Color = NumberSequence.new({
        NumberSequenceKeypoint.new(0, ThemeColor),
        NumberSequenceKeypoint.new(0.5, SecondaryColor),
        NumberSequenceKeypoint.new(1, ThemeColor)
    })
    AccentGrad.Parent = AccentBar

    -- Vùng kéo
    local DragArea = Instance.new("Frame")
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, -50, 1, 0)
    DragArea.Parent = TopSection

    -- Tiêu đề với hiệu ứng bóng
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 24, 0, 12)
    TitleLabel.Size = UDim2.new(1, -80, 0, 28)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 24
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopSection
    
    -- Bóng chữ cho tiêu đề
    local TitleGlow = Instance.new("TextLabel")
    TitleGlow.BackgroundTransparency = 1
    TitleGlow.Position = UDim2.new(0, 26, 0, 14)
    TitleGlow.Size = UDim2.new(1, -80, 0, 28)
    TitleGlow.Font = Enum.Font.GothamBold
    TitleGlow.Text = title
    TitleGlow.TextColor3 = ThemeColor
    TitleGlow.TextSize = 24
    TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
    TitleGlow.TextTransparency = 0.7
    TitleGlow.ZIndex = 0
    TitleGlow.Parent = TopSection

    -- Phụ đề
    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(0, 24, 0, 44)
    SubLabel.Size = UDim2.new(1, -80, 0, 14)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = TopSection

    -- Nút đóng với hiệu ứng hover
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -45, 0, 25)
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopSection

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(40, 30, 30),
            TextColor3 = Color3.fromRGB(255, 120, 120)
        }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    MakeDragFromArea(MainFrame, DragArea)

    -- === THANH BÊN ===
    local Sidebar = Instance.new("Frame")
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
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

    -- === VÙNG NỘI DUNG ===
    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 100, 0, 80)
    ContentArea.Size = UDim2.new(1, -100, 1, -80)
    ContentArea.Parent = MainFrame

    -- === NÚT THU GỌN ===
    local ToggleBtn = Instance.new("Frame")
    ToggleBtn.BackgroundTransparency = 0.3
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Position = UDim2.new(0, 16, 0, 16)
    ToggleBtn.Size = UDim2.new(0, 64, 0, 64)
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 20)
    ToggleCorner.Parent = ToggleBtn
    
    -- Hiệu ứng phát sáng cho nút toggle
    local ToggleGlow = Instance.new("Frame")
    ToggleGlow.BackgroundTransparency = 0.7
    ToggleGlow.BackgroundColor3 = ThemeColor
    ToggleGlow.BorderSizePixel = 0
    ToggleGlow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    ToggleGlow.Size = UDim2.new(1.1, 0, 1.1, 0)
    ToggleGlow.ZIndex = 0
    ToggleGlow.Parent = ToggleBtn
    
    local ToggleGlowCorner = Instance.new("UICorner")
    ToggleGlowCorner.CornerRadius = UDim.new(0, 22)
    ToggleGlowCorner.Parent = ToggleGlow

    local ToggleInner = Instance.new("Frame")
    ToggleInner.BackgroundTransparency = 0.1
    ToggleInner.BackgroundColor3 = ThemeColor
    ToggleInner.BorderSizePixel = 0
    ToggleInner.Size = UDim2.new(1, 0, 1, 0)
    ToggleInner.Parent = ToggleBtn
    ToggleInner.ZIndex = 1

    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 18)
    InnerCorner.Parent = ToggleInner

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 3)
    Padding.PaddingLeft = UDim.new(0, 3)
    Padding.PaddingRight = UDim.new(0, 3)
    Padding.PaddingTop = UDim.new(0, 3)
    Padding.Parent = ToggleInner

    if toggleIcon then
        local ToggleImg = Instance.new("ImageButton")
        ToggleImg.BackgroundTransparency = 0.3
        ToggleImg.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
        ToggleImg.BorderSizePixel = 0
        ToggleImg.Size = UDim2.new(1, 0, 1, 0)
        ToggleImg.Image = GetIcon(toggleIcon)
        ToggleImg.ImageColor3 = ThemeColor
        ToggleImg.Parent = ToggleInner

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 16)
        ImgCorner.Parent = ToggleImg

        local visible = true
        ToggleImg.MouseButton1Click:Connect(function()
            visible = not visible
            local targetSize = visible and UDim2.new(0, width, 0, height) or UDim2.new(0, 0, 0, 0)
            local targetPos = visible and UDim2.new(0.5, -width / 2, 0.5, -height / 2) or UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = targetSize,
                Position = targetPos
            }):Play()
        end)
    else
        local ToggleText = Instance.new("TextButton")
        ToggleText.BackgroundTransparency = 0.3
        ToggleText.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
        ToggleText.BorderSizePixel = 0
        ToggleText.Size = UDim2.new(1, 0, 1, 0)
        ToggleText.Font = Enum.Font.GothamBold
        ToggleText.Text = "◆"
        ToggleText.TextColor3 = ThemeColor
        ToggleText.TextSize = 32
        ToggleText.Parent = ToggleInner

        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 16)
        TxtCorner.Parent = ToggleText

        local visible = true
        ToggleText.MouseButton1Click:Connect(function()
            visible = not visible
            local targetSize = visible and UDim2.new(0, width, 0, height) or UDim2.new(0, 0, 0, 0)
            local targetPos = visible and UDim2.new(0.5, -width / 2, 0.5, -height / 2) or UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = targetSize,
                Position = targetPos
            }):Play()
        end)
    end

    local Window = {
        Tabs = {},
        ThemeColor = ThemeColor,
        SecondaryColor = SecondaryColor,
        MainFrame = MainFrame,
        ContentArea = ContentArea,
        ScreenGui = ScreenGui
    }

    function Window:AddTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Title or "Tab"
        local tabIcon = cfg.Icon or "home"

        -- Nút Tab
        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundTransparency = 0.4
        TabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 70)
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 16)
        TabCorner.Parent = TabBtn

        -- Icon Tab
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, -18, 0.5, -18)
        TabIcon.Size = UDim2.new(0, 36, 0, 36)
        TabIcon.Image = GetIcon(tabIcon)
        TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 200)
        TabIcon.Parent = TabBtn

        -- Tooltip với thiết kế thủy tinh
        local Tooltip = Instance.new("TextLabel")
        Tooltip.BackgroundTransparency = 0.2
        Tooltip.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
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
        TipCorner.CornerRadius = UDim.new(0, 10)
        TipCorner.Parent = Tooltip

        TabBtn.MouseEnter:Connect(function()
            Tooltip.Visible = true
            TweenService:Create(Tooltip, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 120, 0, 24)
            }):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.1
            }):Play()
        end)

        TabBtn.MouseLeave:Connect(function()
            TweenService:Create(Tooltip, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 0, 0, 24)
            }):Play()
            wait(0.15)
            Tooltip.Visible = false
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.4
            }):Play()
        end)

        -- Chỉ báo tab được chọn với hiệu ứng phát sáng
        local Indicator = Instance.new("Frame")
        Indicator.BackgroundTransparency = 0.1
        Indicator.BackgroundColor3 = ThemeColor
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(1, -4, 0, 0)
        Indicator.Size = UDim2.new(0, 4, 0, 0)
        Indicator.Visible = false
        Indicator.Parent = TabBtn
        Indicator.ZIndex = 5
        
        local IndGlow = Instance.new("Frame")
        IndGlow.BackgroundTransparency = 0.7
        IndGlow.BackgroundColor3 = ThemeColor
        IndGlow.BorderSizePixel = 0
        IndGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
        IndGlow.Size = UDim2.new(2, 0, 2, 0)
        IndGlow.ZIndex = 0
        IndGlow.Parent = Indicator
        
        local IndGlowCorner = Instance.new("UICorner")
        IndGlowCorner.CornerRadius = UDim.new(0, 4)
        IndGlowCorner.Parent = IndGlow

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = ThemeColor
        TabContent.ScrollBarImageTransparency = 0.5
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
                local ind = t.Button:FindFirstChild("Frame")
                if ind then
                    ind.Visible = false
                    ind.Size = UDim2.new(0, 4, 0, 0)
                end
                local img = t.Button:FindFirstChild("ImageLabel")
                if img then
                    img.ImageColor3 = Color3.fromRGB(180, 180, 200)
                end
                TweenService:Create(t.Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.4
                }):Play()
            end
            TabContent.Visible = true
            Indicator.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 4, 1, 0)
            }):Play()
            TabIcon.ImageColor3 = ThemeColor
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.1
            }):Play()
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
            SectionHead.BackgroundTransparency = 0.3
            SectionHead.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
            SectionHead.BorderSizePixel = 0
            SectionHead.Size = UDim2.new(1, 0, 0, 30)
            SectionHead.Font = Enum.Font.GothamBold
            SectionHead.Text = "✦ " .. sname
            SectionHead.TextColor3 = ThemeColor
            SectionHead.TextSize = 13
            SectionHead.TextXAlignment = Enum.TextXAlignment.Left
            SectionHead.Parent = SectionFrame

            local HeadCorner = Instance.new("UICorner")
            HeadCorner.CornerRadius = UDim.new(0, 12)
            HeadCorner.Parent = SectionHead

            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.Position = UDim2.new(0, 0, 0, 34)
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
                ToggleF.BackgroundTransparency = 0.3
                ToggleF.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
                ToggleF.BorderSizePixel = 0
                ToggleF.Size = UDim2.new(1, 0, 0, 38)
                ToggleF.Text = ""
                ToggleF.Parent = SectionContent

                local ToggleFC = Instance.new("UICorner")
                ToggleFC.CornerRadius = UDim.new(0, 12)
                ToggleFC.Parent = ToggleF

                local ToggleL = Instance.new("TextLabel")
                ToggleL.BackgroundTransparency = 1
                ToggleL.Position = UDim2.new(0, 12, 0, 0)
                ToggleL.Size = UDim2.new(1, -65, 1, 0)
                ToggleL.Font = Enum.Font.Gotham
                ToggleL.Text = opts.Text or tname
                ToggleL.TextColor3 = Color3.fromRGB(235, 235, 240)
                ToggleL.TextSize = 12
                ToggleL.TextXAlignment = Enum.TextXAlignment.Left
                ToggleL.Parent = ToggleF
                ToggleL.ZIndex = 2

                local ToggleS = Instance.new("Frame")
                ToggleS.BackgroundTransparency = 0.3
                ToggleS.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                ToggleS.BorderSizePixel = 0
                ToggleS.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleS.Size = UDim2.new(0, 40, 0, 20)
                ToggleS.Parent = ToggleF
                ToggleS.ZIndex = 2

                local ToggleSC = Instance.new("UICorner")
                ToggleSC.CornerRadius = UDim.new(1, 0)
                ToggleSC.Parent = ToggleS

                local ToggleInd = Instance.new("Frame")
                ToggleInd.BackgroundTransparency = 0.2
                ToggleInd.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
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
                        TweenService:Create(ToggleInd, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = ThemeColor,
                            BackgroundTransparency = 0
                        }):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.2), {
                            BackgroundColor3 = ThemeColor,
                            BackgroundTransparency = 0.2
                        }):Play()
                    else
                        TweenService:Create(ToggleInd, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(100, 100, 120),
                            BackgroundTransparency = 0.2
                        }):Play()
                        TweenService:Create(ToggleS, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                            BackgroundTransparency = 0.3
                        }):Play()
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
                Btn.BackgroundTransparency = 0.4
                Btn.BackgroundColor3 = ThemeColor
                Btn.BorderSizePixel = 0
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Text = opts.Text or bname
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.TextSize = 12
                Btn.Parent = SectionContent

                local BtnC = Instance.new("UICorner")
                BtnC.CornerRadius = UDim.new(0, 12)
                BtnC.Parent = Btn

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        Size = UDim2.new(1, 4, 0, 37)
                    }):Play()
                end)

                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.4,
                        Size = UDim2.new(1, 0, 0, 35)
                    }):Play()
                end)

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.6,
                        Size = UDim2.new(1, -4, 0, 33)
                    }):Play()
                    wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.1,
                        Size = UDim2.new(1, 4, 0, 37)
                    }):Play()
                    wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.4,
                        Size = UDim2.new(1, 0, 0, 35)
                    }):Play()
                    if opts.Callback then opts.Callback() end
                end)

                return Btn
            end

            function Section:AddSlider(slname, opts)
                opts = opts or {}
                local min, max, default, increment = opts.Min or 0, opts.Max or 100, opts.Default or 0, opts.Increment or 1
                local val = default

                local SliderF = Instance.new("Frame")
                SliderF.BackgroundTransparency = 0.3
                SliderF.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
                SliderF.BorderSizePixel = 0
                SliderF.Size = UDim2.new(1, 0, 0, 68)
                SliderF.Parent = SectionContent

                local SliderFC = Instance.new("UICorner")
                SliderFC.CornerRadius = UDim.new(0, 12)
                SliderFC.Parent = SliderF

                local SliderL = Instance.new("TextLabel")
                SliderL.BackgroundTransparency = 1
                SliderL.Position = UDim2.new(0, 12, 0, 6)
                SliderL.Size = UDim2.new(1, -60, 0, 18)
                SliderL.Font = Enum.Font.GothamSemibold
                SliderL.Text = (opts.Text or slname) .. ": " .. tostring(val)
                SliderL.TextColor3 = Color3.fromRGB(235, 235, 240)
                SliderL.TextSize = 12
                SliderL.TextXAlignment = Enum.TextXAlignment.Left
                SliderL.Parent = SliderF

                local InputB = Instance.new("TextBox")
                InputB.BackgroundTransparency = 0.4
                InputB.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                InputB.BorderSizePixel = 0
                InputB.Position = UDim2.new(1, -52, 0, 6)
                InputB.Size = UDim2.new(0, 48, 0, 18)
                InputB.Font = Enum.Font.Gotham
                InputB.Text = tostring(val)
                InputB.TextColor3 = ThemeColor
                InputB.TextSize = 11
                InputB.Parent = SliderF

                local InputBC = Instance.new("UICorner")
                InputBC.CornerRadius = UDim.new(0, 8)
                InputBC.Parent = InputB

                local SliderB = Instance.new("Frame")
                SliderB.BackgroundTransparency = 0.4
                SliderB.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                SliderB.BorderSizePixel = 0
                SliderB.Position = UDim2.new(0, 12, 0, 32)
                SliderB.Size = UDim2.new(1, -24, 0, 12)
                SliderB.Parent = SliderF

                local SliderBC = Instance.new("UICorner")
                SliderBC.CornerRadius = UDim.new(1, 0)
                SliderBC.Parent = SliderB

                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundTransparency = 0.1
                SliderFill.BackgroundColor3 = ThemeColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderB

                local SliderFillC = Instance.new("UICorner")
                SliderFillC.CornerRadius = UDim.new(1, 0)
                SliderFillC.Parent = SliderFill

                local Thumb = Instance.new("Frame")
                Thumb.BackgroundTransparency = 0.1
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
                DropF.BackgroundTransparency = 0.3
                DropF.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
                DropF.BorderSizePixel = 0
                DropF.Size = UDim2.new(1, 0, 0, 36)
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
                DropL.Position = UDim2.new(0, 12, 0, 0)
                DropL.Size = UDim2.new(1, -45, 1, 0)
                DropL.Font = Enum.Font.Gotham
                DropL.Text = current
                DropL.TextColor3 = Color3.fromRGB(235, 235, 240)
                DropL.TextSize = 12
                DropL.TextXAlignment = Enum.TextXAlignment.Left
                DropL.Parent = DropF

                local DropArrow = Instance.new("TextLabel")
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -30, 0, 0)
                DropArrow.Size = UDim2.new(0, 30, 1, 0)
                DropArrow.Font = Enum.Font.GothamBold
                DropArrow.Text = "▾"
                DropArrow.TextColor3 = ThemeColor
                DropArrow.TextSize = 12
                DropArrow.Parent = DropF

                local ItemC = Instance.new("Frame")
                ItemC.BackgroundTransparency = 0.3
                ItemC.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
                ItemC.BorderSizePixel = 0
                ItemC.Position = UDim2.new(0, 0, 1, 0)
                ItemC.Size = UDim2.new(1, 0, 0, 0)
                ItemC.Visible = false
                ItemC.Parent = DropF
                ItemC.ZIndex = 10

                local ItemCCorner = Instance.new("UICorner")
                ItemCCorner.CornerRadius = UDim.new(0, 12)
                ItemCCorner.Parent = ItemC

                local isOpen = false

                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    ItemC.Visible = isOpen
                    ItemC.Size = isOpen and UDim2.new(1, 0, 0, 8 + (#items * 32)) or UDim2.new(1, 0, 0, 0)
                end)

                for i, item in ipairs(items) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.BackgroundTransparency = 0.5
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Position = UDim2.new(0, 0, 0, 4 + (i-1) * 32)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 32)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = item
                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
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
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0.2,
                            BackgroundColor3 = Color3.fromRGB(28, 28, 42)
                        }):Play()
                    end)

                    ItemBtn.MouseLeave:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0.5,
                            BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                        }):Play()
                    end)
                end

                return {SetValue = function(self, v) current = v; DropL.Text = v end, GetValue = function(self) return current end}
            end

            function Section:AddTextBox(tbname, opts)
                opts = opts or {}
                local text = opts.Default or ""

                local TBF = Instance.new("Frame")
                TBF.BackgroundTransparency = 0.3
                TBF.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
                TBF.BorderSizePixel = 0
                TBF.Size = UDim2.new(1, 0, 0, 65)
                TBF.Parent = SectionContent

                local TBFC = Instance.new("UICorner")
                TBFC.CornerRadius = UDim.new(0, 12)
                TBFC.Parent = TBF

                local TBL = Instance.new("TextLabel")
                TBL.BackgroundTransparency = 1
                TBL.Position = UDim2.new(0, 12, 0, 6)
                TBL.Size = UDim2.new(1, -24, 0, 18)
                TBL.Font = Enum.Font.GothamSemibold
                TBL.Text = opts.Text or tbname
                TBL.TextColor3 = Color3.fromRGB(235, 235, 240)
                TBL.TextSize = 12
                TBL.TextXAlignment = Enum.TextXAlignment.Left
                TBL.Parent = TBF

                local TB = Instance.new("TextBox")
                TB.BackgroundTransparency = 0.4
                TB.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
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
                TBC.CornerRadius = UDim.new(0, 10)
                TBC.Parent = TB

                TB.FocusLost:Connect(function(enterPressed)
                    text = TB.Text
                    if opts.Callback then opts.Callback(text, enterPressed) end
                end)

                return {SetValue = function(self, v) text = v; TB.Text = v end, GetValue = function(self) return text end}
            end

            local function UpdateSize()
                local height = 0
                for _, child in ipairs(SectionContent:GetChildren()) do
                    if child:IsA("GuiObject") then height = height + child.AbsoluteSize.Y + 6 end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, height + 34)
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