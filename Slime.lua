--[[
    ApexUI.lua - Thư viện GUI Hiện Đại
    Phong cách: Slime UI / Windows 11 / Discord / Apple
    Hỗ trợ theme, gradient, animation mượt mà
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======================================================
-- ICON LIBRARY
-- ======================================================
local IconLibrary = {
    home     = "rbxassetid://10723434711",
    settings = "rbxassetid://10734950309",
    user     = "rbxassetid://10747373176",
    shield   = "rbxassetid://10723407389",
    sword    = "rbxassetid://10723434518",
    star     = "rbxassetid://10709790948",
    crown    = "rbxassetid://10709791437",
    info     = "rbxassetid://10747384394",
    menu     = "rbxassetid://10747384394",
    plus     = "rbxassetid://10747373176",
    minus    = "rbxassetid://10734942835",
    close    = "rbxassetid://10747384394",
    check    = "rbxassetid://10709792537",
    bell     = "rbxassetid://10709790644",
    heart    = "rbxassetid://10709791437",
    flame    = "rbxassetid://10709791151",
    gem      = "rbxassetid://10709791682",
    coin     = "rbxassetid://10709790537",
    box      = "rbxassetid://10709789989",
    gear     = "rbxassetid://10734950309",
    lock     = "rbxassetid://10723407389",
    unlock   = "rbxassetid://10747373176",
    eye      = "rbxassetid://10709790948",
    ghost    = "rbxassetid://10709791437",
    robot    = "rbxassetid://10747384394",
    alien    = "rbxassetid://10734942835",
    cat      = "rbxassetid://10747384394",
    dog      = "rbxassetid://10709792537",
    dragon   = "rbxassetid://10709790644",
    skull    = "rbxassetid://10709791437",
    devil    = "rbxassetid://10709791151",
    angel    = "rbxassetid://10709791682",
    wizard   = "rbxassetid://10709790537",
    knight   = "rbxassetid://10709789989",
    mage     = "rbxassetid://10723434711",
    hunter   = "rbxassetid://10734950309",
    assassin = "rbxassetid://10747373176",
    tank     = "rbxassetid://10723407389",
    healer   = "rbxassetid://10723434518",
    dps      = "rbxassetid://10709790948",
    fire     = "rbxassetid://10709791437",
    lightning = "rbxassetid://10747384394",
    moon     = "rbxassetid://10734942835",
    sun      = "rbxassetid://10747384394",
    cloud    = "rbxassetid://10709792537",
    music    = "rbxassetid://10709790644",
    game     = "rbxassetid://10709791437",
    rocket   = "rbxassetid://10709791151",
    target   = "rbxassetid://10709791682",
    flag     = "rbxassetid://10709790537",
    trophy   = "rbxassetid://10709789989",
    medal    = "rbxassetid://10723434711",
    phoenix  = "rbxassetid://10734950309"
}

-- ======================================================
-- THEMES
-- ======================================================
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(100, 130, 255),
        Text = Color3.fromRGB(235, 235, 240),
        Border = Color3.fromRGB(55, 55, 75),
        GradientTop = Color3.fromRGB(20, 20, 30),
        GradientBottom = Color3.fromRGB(35, 35, 50)
    },
    
    Ruby = {
        Primary = Color3.fromRGB(35, 18, 28),
        Secondary = Color3.fromRGB(50, 25, 38),
        Accent = Color3.fromRGB(255, 150, 200),
        Text = Color3.fromRGB(255, 240, 248),
        Border = Color3.fromRGB(180, 120, 200),
        GradientTop = Color3.fromRGB(255, 150, 200),
        GradientBottom = Color3.fromRGB(150, 220, 255)
    },
    
    Ocean = {
        Primary = Color3.fromRGB(10, 22, 42),
        Secondary = Color3.fromRGB(18, 38, 60),
        Accent = Color3.fromRGB(80, 200, 255),
        Text = Color3.fromRGB(235, 245, 255),
        Border = Color3.fromRGB(40, 80, 120),
        GradientTop = Color3.fromRGB(80, 200, 255),
        GradientBottom = Color3.fromRGB(20, 80, 180)
    },
    
    Emerald = {
        Primary = Color3.fromRGB(12, 28, 18),
        Secondary = Color3.fromRGB(22, 45, 30),
        Accent = Color3.fromRGB(80, 220, 140),
        Text = Color3.fromRGB(235, 255, 240),
        Border = Color3.fromRGB(50, 100, 70),
        GradientTop = Color3.fromRGB(80, 220, 140),
        GradientBottom = Color3.fromRGB(20, 120, 80)
    },
    
    Purple = {
        Primary = Color3.fromRGB(22, 12, 38),
        Secondary = Color3.fromRGB(38, 22, 58),
        Accent = Color3.fromRGB(180, 120, 255),
        Text = Color3.fromRGB(245, 235, 255),
        Border = Color3.fromRGB(80, 50, 140),
        GradientTop = Color3.fromRGB(180, 120, 255),
        GradientBottom = Color3.fromRGB(100, 50, 200)
    },
    
    Sunset = {
        Primary = Color3.fromRGB(42, 18, 22),
        Secondary = Color3.fromRGB(62, 28, 32),
        Accent = Color3.fromRGB(255, 150, 100),
        Text = Color3.fromRGB(255, 245, 235),
        Border = Color3.fromRGB(200, 100, 80),
        GradientTop = Color3.fromRGB(255, 150, 100),
        GradientBottom = Color3.fromRGB(255, 80, 80)
    },
    
    Forest = {
        Primary = Color3.fromRGB(12, 25, 12),
        Secondary = Color3.fromRGB(22, 42, 22),
        Accent = Color3.fromRGB(120, 255, 150),
        Text = Color3.fromRGB(240, 255, 240),
        Border = Color3.fromRGB(60, 140, 80),
        GradientTop = Color3.fromRGB(120, 255, 150),
        GradientBottom = Color3.fromRGB(40, 180, 80)
    },
    
    Midnight = {
        Primary = Color3.fromRGB(8, 8, 22),
        Secondary = Color3.fromRGB(18, 18, 42),
        Accent = Color3.fromRGB(150, 130, 255),
        Text = Color3.fromRGB(240, 235, 255),
        Border = Color3.fromRGB(60, 50, 120),
        GradientTop = Color3.fromRGB(150, 130, 255),
        GradientBottom = Color3.fromRGB(60, 30, 200)
    },
    
    Aurora = {
        Primary = Color3.fromRGB(8, 22, 32),
        Secondary = Color3.fromRGB(18, 38, 52),
        Accent = Color3.fromRGB(100, 255, 220),
        Text = Color3.fromRGB(230, 255, 250),
        Border = Color3.fromRGB(40, 150, 150),
        GradientTop = Color3.fromRGB(100, 255, 220),
        GradientBottom = Color3.fromRGB(40, 180, 255)
    },
    
    Candy = {
        Primary = Color3.fromRGB(42, 12, 28),
        Secondary = Color3.fromRGB(62, 22, 42),
        Accent = Color3.fromRGB(255, 150, 200),
        Text = Color3.fromRGB(255, 240, 248),
        Border = Color3.fromRGB(220, 100, 160),
        GradientTop = Color3.fromRGB(255, 150, 200),
        GradientBottom = Color3.fromRGB(255, 100, 150)
    },
    
    Neon = {
        Primary = Color3.fromRGB(8, 8, 22),
        Secondary = Color3.fromRGB(18, 18, 38),
        Accent = Color3.fromRGB(0, 255, 200),
        Text = Color3.fromRGB(200, 255, 240),
        Border = Color3.fromRGB(0, 180, 160),
        GradientTop = Color3.fromRGB(0, 255, 200),
        GradientBottom = Color3.fromRGB(255, 0, 200)
    },
    
    Galaxy = {
        Primary = Color3.fromRGB(12, 6, 28),
        Secondary = Color3.fromRGB(22, 12, 48),
        Accent = Color3.fromRGB(200, 150, 255),
        Text = Color3.fromRGB(245, 235, 255),
        Border = Color3.fromRGB(120, 60, 200),
        GradientTop = Color3.fromRGB(200, 150, 255),
        GradientBottom = Color3.fromRGB(100, 40, 200)
    },
    
    Slime = {
        Primary = Color3.fromRGB(12, 28, 18),
        Secondary = Color3.fromRGB(22, 45, 30),
        Accent = Color3.fromRGB(80, 255, 150),
        Text = Color3.fromRGB(230, 255, 240),
        Border = Color3.fromRGB(60, 180, 100),
        GradientTop = Color3.fromRGB(80, 255, 150),
        GradientBottom = Color3.fromRGB(40, 200, 80)
    },
    
    Windows = {
        Primary = Color3.fromRGB(20, 20, 28),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(60, 60, 75),
        GradientTop = Color3.fromRGB(20, 20, 28),
        GradientBottom = Color3.fromRGB(45, 45, 55)
    },
    
    Discord = {
        Primary = Color3.fromRGB(32, 34, 38),
        Secondary = Color3.fromRGB(47, 49, 54),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(60, 62, 68),
        GradientTop = Color3.fromRGB(32, 34, 38),
        GradientBottom = Color3.fromRGB(47, 49, 54)
    }
}

-- ======================================================
-- RAINBOW THEME
-- ======================================================
local RainbowTheme = {
    Primary = Color3.fromRGB(18, 18, 32),
    Secondary = Color3.fromRGB(28, 28, 48),
    Accent = Color3.fromRGB(255, 100, 100),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(80, 80, 120),
    GradientTop = Color3.fromRGB(255, 100, 100),
    GradientBottom = Color3.fromRGB(100, 100, 255),
    IsRainbow = true
}

-- ======================================================
-- UTILITY
-- ======================================================
local function tween(obj, props, time, style, dir)
    time = time or 0.25
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time, style, dir)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255, 255, 255)
    s.Thickness = thickness or 1
    s.Transparency = trans or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function applyGradient(obj, topColor, bottomColor, rotation)
    local old = obj:FindFirstChild("UIGradient")
    if old then old:Destroy() end
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, topColor),
        ColorSequenceKeypoint.new(1, bottomColor)
    })
    grad.Rotation = rotation or 90
    grad.Parent = obj
    return grad
end

-- ======================================================
-- WINDOW
-- ======================================================
local Window = {}
Window.__index = Window

function Window.new(config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    
    -- Xử lý theme
    local themeName = config.Theme or "Dark"
    local isRainbow = (themeName == "Rainbow" or themeName == "RGB")
    local theme = isRainbow and RainbowTheme or Themes[themeName] or Themes.Dark
    
    self.ThemeName = themeName
    self.Theme = theme
    self.IsRainbow = isRainbow
    self.Title = config.Title or "Apex Hub"
    self.Width = config.Width or 520
    self.Height = config.Height or 440
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Hue = 0
    self.MinSize = {Width = 400, Height = 300}
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ApexUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    self.ScreenGui = screenGui
    
    -- === MAIN FRAME ===
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
    main.BackgroundColor3 = theme.Primary
    main.BackgroundTransparency = 0.03
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    corner(main, 16)
    stroke(main, theme.Border, 1.5, 0.25)
    applyGradient(main, theme.GradientTop, theme.GradientBottom, 90)
    self.Main = main
    
    -- Glow shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    shadow.ZIndex = -1
    shadow.Parent = main
    self.Shadow = shadow
    
    -- === HEADER ===
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = theme.Secondary
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = main
    corner(header, 16)
    self.Header = header
    
    -- Title với icon
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 24, 0, 24)
    titleIcon.Position = UDim2.new(0, 14, 0.5, -12)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = IconLibrary[config.Icon] or IconLibrary.star
    titleIcon.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 46, 0, 0)
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    self.TitleLabel = titleLabel
    
    -- Control Buttons
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 100, 1, 0)
    controls.Position = UDim2.new(1, -108, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header
    
    -- Resize Button (thu nhỏ)
    local resizeBtn = Instance.new("TextButton")
    resizeBtn.Size = UDim2.new(0, 30, 0, 30)
    resizeBtn.Position = UDim2.new(0, 2, 0.5, -15)
    resizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    resizeBtn.BackgroundTransparency = 0.85
    resizeBtn.Text = "─"
    resizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    resizeBtn.TextSize = 16
    resizeBtn.Font = Enum.Font.GothamBold
    resizeBtn.AutoButtonColor = false
    resizeBtn.Parent = controls
    corner(resizeBtn, 6)
    self.ResizeBtn = resizeBtn
    
    resizeBtn.MouseEnter:Connect(function()
        tween(resizeBtn, {BackgroundTransparency = 0.3}, 0.1)
        tween(resizeBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    resizeBtn.MouseLeave:Connect(function()
        tween(resizeBtn, {BackgroundTransparency = 0.85}, 0.1)
        tween(resizeBtn, {TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
    end)
    resizeBtn.MouseButton1Click:Connect(function()
        self:ToggleResize()
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0, 66, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.BackgroundTransparency = 0.75
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = controls
    corner(closeBtn, 6)
    
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.1}, 0.1)
        tween(closeBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.75}, 0.1)
        tween(closeBtn, {TextColor3 = Color3.fromRGB(255, 200, 200)}, 0.1)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- === TAB BAR ===
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Size = UDim2.new(1, 0, 0, 44)
    tabBar.Position = UDim2.new(0, 0, 0, 50)
    tabBar.BackgroundColor3 = theme.Secondary
    tabBar.BackgroundTransparency = 0.15
    tabBar.BorderSizePixel = 0
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.ScrollBarThickness = 2
    tabBar.ScrollBarImageColor3 = theme.Accent
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.Parent = main
    self.TabBar = tabBar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 3)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar
    
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0, 10)
    tabPad.PaddingRight = UDim.new(0, 10)
    tabPad.Parent = tabBar
    
    local function updateTabCanvas()
        tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 20, 0, 0)
    end
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)
    
    -- === CONTENT AREA ===
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 1, -94)
    contentArea.Position = UDim2.new(0, 0, 0, 94)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    self.ContentArea = contentArea
    
    -- === DRAG ===
    local dragging = false
    local dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- === RESIZE ===
    local resizeData = {}
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 16, 0, 16)
    resizeHandle.Position = UDim2.new(1, -16, 1, -16)
    resizeHandle.BackgroundColor3 = theme.Accent
    resizeHandle.BackgroundTransparency = 0.7
    resizeHandle.Parent = main
    corner(resizeHandle, 4)
    self.ResizeHandle = resizeHandle
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeData.active = true
            resizeData.startPos = input.Position
            resizeData.startSize = main.Size
            resizeData.startPosUI = main.Position
        end
    end)
    resizeHandle.InputEnded:Connect(function()
        resizeData.active = false
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizeData.active and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeData.startPos
            local newWidth = math.max(self.MinSize.Width, resizeData.startSize.X.Offset + delta.X)
            local newHeight = math.max(self.MinSize.Height, resizeData.startSize.Y.Offset + delta.Y)
            self:SetSize(newWidth, newHeight)
        end
    end)
    
    -- === HOTKEY ===
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            self:Toggle()
        end
    end)
    
    -- Rainbow effect
    if isRainbow then
        task.spawn(function()
            while self.Visible do
                self.Hue = (self.Hue + 0.003) % 1
                local color = Color3.fromHSV(self.Hue, 1, 1)
                self:SetAccentColor(color)
                task.wait(0.02)
            end
        end)
    end
    
    return self
end

-- ======================================================
-- WINDOW METHODS
-- ======================================================

function Window:SetAccentColor(color)
    self.Theme.Accent = color
    -- Update border
    local border = self.Main:FindFirstChild("UIStroke")
    if border then
        border.Color = color
    end
    -- Update resize handle
    if self.ResizeHandle then
        self.ResizeHandle.BackgroundColor3 = color
    end
    -- Update tab bar scroll
    if self.TabBar then
        self.TabBar.ScrollBarImageColor3 = color
    end
end

function Window:SetSize(width, height)
    self.Width = width
    self.Height = height
    self.Main.Size = UDim2.new(0, width, 0, height)
    self.Main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    -- Update shadow
    if self.Shadow then
        self.Shadow.Size = UDim2.new(1, 20, 1, 20)
        self.Shadow.Position = UDim2.new(0, -10, 0, -10)
    end
end

function Window:ToggleResize()
    if self.Width == self.MinSize.Width and self.Height == self.MinSize.Height then
        self:SetSize(520, 440)
        self.ResizeBtn.Text = "─"
    else
        self:SetSize(self.MinSize.Width, self.MinSize.Height)
        self.ResizeBtn.Text = "□"
    end
end

function Window:Toggle()
    self.Visible = not self.Visible
    if self.Visible then
        self.ScreenGui.Enabled = true
        tween(self.Main, {BackgroundTransparency = 0.03}, 0.2)
    else
        tween(self.Main, {BackgroundTransparency = 1}, 0.15)
        task.delay(0.15, function()
            if not self.Visible then
                self.ScreenGui.Enabled = false
            end
        end)
    end
end

function Window:Close()
    tween(self.Main, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, 0.3, Enum.EasingStyle.Back)
    tween(self.Shadow, {ImageTransparency = 1}, 0.3)
    task.delay(0.35, function()
        self.ScreenGui:Destroy()
    end)
end

function Window:Notify(config)
    config = config or {}
    
    local notif = Instance.new("Frame")
    notif.AnchorPoint = Vector2.new(1, 1)
    notif.Position = UDim2.new(1, -16, 1, -16)
    notif.Size = UDim2.new(0, 320, 0, 0)
    notif.BackgroundColor3 = self.Theme.Primary
    notif.BackgroundTransparency = 0.03
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.ZIndex = 50
    notif.Parent = self.ScreenGui
    corner(notif, 12)
    stroke(notif, self.Theme.Border, 1, 0.25)
    applyGradient(notif, self.Theme.GradientTop, self.Theme.GradientBottom, 90)
    
    local iconMap = {
        Success = "✔",
        Warning = "⚠",
        Error = "✖",
        Info = "ⓘ"
    }
    local icon = iconMap[config.Type] or "◆"
    local iconColor = config.Type == "Success" and Color3.fromRGB(80, 220, 120) or
                      config.Type == "Warning" and Color3.fromRGB(255, 200, 80) or
                      config.Type == "Error" and Color3.fromRGB(255, 80, 80) or
                      self.Theme.Accent
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 12)
    iconLabel.Size = UDim2.new(0, 24, 0, 24)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = iconColor
    iconLabel.TextSize = 18
    iconLabel.Parent = notif
    
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 44, 0, 12)
    title.Size = UDim2.new(1, -56, 0, 18)
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title or "Notification"
    title.TextColor3 = self.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notif
    
    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 44, 0, 34)
    body.Size = UDim2.new(1, -56, 0, 0)
    body.Font = Enum.Font.Gotham
    body.Text = config.Text or ""
    body.TextColor3 = Color3.fromRGB(180, 180, 210)
    body.TextSize = 12
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = notif
    
    task.wait()
    local height = 50 + body.AbsoluteSize.Y
    tween(notif, {Size = UDim2.new(0, 320, 0, height)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(config.Duration or 3, function()
        tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(0, 320, 0, 0)}, 0.2)
        task.delay(0.25, function() notif:Destroy() end)
    end)
end

-- ======================================================
-- WINDOW:AddTab
-- ======================================================
function Window:AddTab(config)
    config = config or {}
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextColor3 = (#self.Tabs == 0) and self.Theme.Text or Color3.fromRGB(150, 150, 180)
    btn.AutoButtonColor = false
    btn.Parent = self.TabBar
    corner(btn, 8)
    stroke(btn, self.Theme.Accent, 1, (#self.Tabs == 0) and 0.3 or 1)
    
    -- Icon + Text
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 8, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = IconLibrary[config.Icon] or IconLibrary.star
    icon.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 30, 0, 0)
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Title or "Tab"
    label.TextColor3 = btn.TextColor3
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    -- Auto size
    btn.Size = UDim2.new(0, label.TextBounds.X + 46, 0, 34)
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self.Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (#self.Tabs == 0)
    page.Parent = self.ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = page
    
    local function updateCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()
    
    local tabObj = {
        Title = config.Title,
        Button = btn,
        Label = label,
        Page = page,
        Layout = layout,
        Window = self
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        self.ActiveTab = tabObj
    end
    
    btn.MouseButton1Click:Connect(function()
        self:_SelectTab(tabObj)
    end)
    
    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(btn, {BackgroundTransparency = 0.85}, 0.15)
            tween(label, {TextColor3 = self.Theme.Text}, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(btn, {BackgroundTransparency = 1}, 0.15)
            tween(label, {TextColor3 = Color3.fromRGB(150, 150, 180)}, 0.15)
        end
    end)
    
    return tabObj
end

function Window:_SelectTab(tabObj)
    for _, tab in ipairs(self.Tabs) do
        local active = (tab == tabObj)
        tab.Page.Visible = active
        tab.Label.TextColor3 = active and self.Theme.Text or Color3.fromRGB(150, 150, 180)
        tween(tab.Button, {BackgroundTransparency = active and 0.85 or 1}, 0.2)
        local btnStroke = tab.Button:FindFirstChild("UIStroke")
        if btnStroke then
            btnStroke.Transparency = active and 0.3 or 1
            btnStroke.Color = self.Theme.Accent
        end
    end
    self.ActiveTab = tabObj
end

-- ======================================================
-- TAB COMPONENT
-- ======================================================
local TabComponent = {}
TabComponent.__index = TabComponent

function Window:GetTabObject(tab)
    local obj = setmetatable({}, TabComponent)
    obj.Window = self
    obj.Page = tab.Page
    return obj
end

-- ======================================================
-- SECTION
-- ======================================================
function TabComponent:AddSection(title)
    local win = self.Window
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = win.Theme.Secondary
    section.BackgroundTransparency = 0.3
    section.BorderSizePixel = 0
    section.ClipsDescendants = true
    section.Parent = self.Page
    corner(section, 10)
    stroke(section, win.Theme.Border, 1, 0.3)
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundColor3 = win.Theme.Accent
    header.BackgroundTransparency = 0.12
    header.BorderSizePixel = 0
    header.Parent = section
    corner(header, 10)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -28, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = string.upper(title)
    label.TextColor3 = win.Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header
    
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 10, 0, 38)
    body.Size = UDim2.new(1, -20, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = section
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = body
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = section
    
    return {
        Body = body,
        Window = win,
        Section = section
    }
end

-- ======================================================
-- BUTTON
-- ======================================================
function TabComponent:AddButton(config)
    config = config or {}
    local win = self.Window
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = win.Theme.Accent
    btn.BackgroundTransparency = 0.65
    btn.Text = config.Text or "Button"
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = win.Theme.Text
    btn.AutoButtonColor = false
    btn.Parent = self.Page
    corner(btn, 8)
    stroke(btn, win.Theme.Accent, 1, 0.3)
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.15}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.65}, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, {Size = UDim2.new(1, 0, 0, 34)}, 0.08)
        task.delay(0.08, function()
            tween(btn, {Size = UDim2.new(1, 0, 0, 38)}, 0.08, Enum.EasingStyle.Back)
        end)
        if config.Callback then config.Callback() end
    end)
    
    return btn
end

-- ======================================================
-- TOGGLE
-- ======================================================
function TabComponent:AddToggle(config)
    config = config or {}
    local win = self.Window
    local state = config.Default or false
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 38)
    holder.BackgroundColor3 = win.Theme.Secondary
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, win.Theme.Border, 1, 0.3)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Text = config.Text or "Toggle"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = win.Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Position = UDim2.new(1, -56, 0.5, -12)
    switch.BackgroundColor3 = state and win.Theme.Accent or Color3.fromRGB(50, 50, 75)
    switch.BorderSizePixel = 0
    switch.Parent = holder
    corner(switch, 12)
    stroke(switch, win.Theme.Accent, 1, state and 0.3 or 0.5)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    corner(knob, 9)
    
    local function setState(v)
        state = v
        tween(switch, {
            BackgroundColor3 = v and win.Theme.Accent or Color3.fromRGB(50, 50, 75)
        }, 0.2)
        tween(knob, {
            Position = v and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
        }, 0.2, Enum.EasingStyle.Back)
        if config.Callback then config.Callback(v) end
    end
    
    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setState(not state)
        end
    end)
    
    return {
        Set = function(_, v) setState(v) end,
        Get = function() return state end
    }
end

-- ======================================================
-- SLIDER
-- ======================================================
function TabComponent:AddSlider(config)
    config = config or {}
    local win = self.Window
    local min = config.Min or 0
    local max = config.Max or 100
    local inc = config.Increment or 1
    local val = config.Default or min
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 54)
    holder.BackgroundColor3 = win.Theme.Secondary
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, win.Theme.Border, 1, 0.3)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 4)
    label.Size = UDim2.new(1, -80, 0, 16)
    label.Text = config.Text or "Slider"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = win.Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -60, 0, 4)
    valueLabel.Size = UDim2.new(0, 48, 0, 16)
    valueLabel.Text = tostring(val)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = win.Theme.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder
    
    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 14, 0, 30)
    track.Size = UDim2.new(1, -28, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    track.BorderSizePixel = 0
    track.Parent = holder
    corner(track, 3)
    
    local fill = Instance.new("Frame")
    local pct = (val - min) / (max - min)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = win.Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)
    
    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 8)
    stroke(knob, win.Theme.Accent, 2, 0.2)
    
    local dragging = false
    
    local function update(inputX)
        local relX = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor((min + (max - min) * relX) / inc + 0.5) * inc
        value = math.clamp(value, min, max)
        relX = (value - min) / (max - min)
        
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        val = value
        if config.Callback then config.Callback(value) end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input.Position.X)
        end
    end)
    track.InputEnded:Connect(function()
        dragging = false
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)
    
    return {
        Set = function(_, v)
            local relX = (v - min) / (max - min)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            knob.Position = UDim2.new(relX, 0, 0.5, 0)
            valueLabel.Text = tostring(v)
            val = v
        end,
        Get = function() return val end
    }
end

-- ======================================================
-- DROPDOWN
-- ======================================================
function TabComponent:AddDropdown(config)
    config = config or {}
    local win = self.Window
    local items = config.Items or {}
    local current = config.Default or items[1] or "None"
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = win.Theme.Secondary
    holder.BackgroundTransparency = 0.5
    holder.ClipsDescendants = true
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, win.Theme.Border, 1, 0.3)
    
    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, 40)
    main.BackgroundTransparency = 1
    main.Text = "  " .. current
    main.Font = Enum.Font.Gotham
    main.TextSize = 13
    main.TextColor3 = win.Theme.Text
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.AutoButtonColor = false
    main.Parent = holder
    
    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 24, 0, 40)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = win.Theme.Accent
    arrow.TextSize = 14
    arrow.Parent = holder
    
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Position = UDim2.new(0, 0, 0, 40)
    dropdown.BackgroundColor3 = win.Theme.Primary
    dropdown.BackgroundTransparency = 0.2
    dropdown.BorderSizePixel = 0
    dropdown.ScrollBarThickness = 3
    dropdown.Parent = holder
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownLayout.Parent = dropdown
    
    local expanded = false
    
    for _, item in ipairs(items) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  " .. item
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.AutoButtonColor = false
        optBtn.Parent = dropdown
        
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, {BackgroundTransparency = 0.5}, 0.1)
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, {BackgroundTransparency = 1}, 0.1)
        end)
        optBtn.MouseButton1Click:Connect(function()
            current = item
            main.Text = "  " .. item
            expanded = false
            tween(holder, {Size = UDim2.new(1, 0, 0, 40)}, 0.15)
            tween(arrow, {Rotation = 0}, 0.15)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
            if config.Callback then config.Callback(item) end
        end)
    end
    
    main.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local height = math.min(#items * 32, 130)
            tween(holder, {Size = UDim2.new(1, 0, 0, 40 + height)}, 0.2)
            tween(arrow, {Rotation = 180}, 0.2)
            dropdown.Size = UDim2.new(1, 0, 0, height)
            dropdown.CanvasSize = UDim2.new(0, 0, 0, #items * 32)
        else
            tween(holder, {Size = UDim2.new(1, 0, 0, 40)}, 0.15)
            tween(arrow, {Rotation = 0}, 0.15)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
    
    return {
        Set = function(_, v)
            current = v
            main.Text = "  " .. v
        end,
        Get = function() return current end
    }
end

-- ======================================================
-- TEXTBOX
-- ======================================================
function TabComponent:AddTextbox(config)
    config = config or {}
    local win = self.Window
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 56)
    holder.BackgroundColor3 = win.Theme.Secondary
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, win.Theme.Border, 1, 0.3)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 4)
    label.Size = UDim2.new(1, -28, 0, 14)
    label.Text = config.Text or "Input"
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(180, 180, 210)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local box = Instance.new("TextBox")
    box.Position = UDim2.new(0, 14, 0, 22)
    box.Size = UDim2.new(1, -28, 0, 28)
    box.BackgroundTransparency = 1
    box.PlaceholderText = config.Placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(130, 130, 160)
    box.Text = ""
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = win.Theme.Text
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = holder
    
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.5, 0, 0, 2)
    underline.Position = UDim2.new(0.5, -0.25, 1, -2)
    underline.BackgroundColor3 = win.Theme.Accent
    underline.BackgroundTransparency = 0.6
    underline.Parent = holder
    corner(underline, 1)
    
    box.Focused:Connect(function()
        tween(underline, {
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundTransparency = 0.1
        }, 0.2)
    end)
    box.FocusLost:Connect(function(enterPressed)
        tween(underline, {
            Size = UDim2.new(0.5, 0, 0, 2),
            BackgroundTransparency = 0.6
        }, 0.2)
        if config.Callback then config.Callback(box.Text, enterPressed) end
    end)
    
    return {
        Set = function(_, v) box.Text = v end,
        Get = function() return box.Text end
    }
end

-- ======================================================
-- LABEL
-- ======================================================
function TabComponent:AddLabel(config)
    config = config or {}
    local win = self.Window
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = config.Text or ""
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = config.Color or Color3.fromRGB(180, 180, 210)
    label.TextXAlignment = config.Align or Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = self.Page
    
    return label
end

-- ======================================================
-- LIBRARY
-- ======================================================
local Library = {}

function Library:CreateWindow(config)
    return Window.new(config)
end

function Library:GetThemes()
    local names = {}
    for name, _ in pairs(Themes) do
        table.insert(names, name)
    end
    table.insert(names, "Rainbow")
    return names
end

function Library:GetIcons()
    local names = {}
    for name, _ in pairs(IconLibrary) do
        table.insert(names, name)
    end
    return names
end

return Library