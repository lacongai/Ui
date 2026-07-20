--[[
    FloatingGUI.lua  —  Bản nâng cấp (v3): Hỗ trợ theme đa màu, cải thiện UI components
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--======================================================
-- THEME PRESETS
--======================================================
local Themes = {
    Dark = {
        Background = Color3.fromRGB(26, 26, 34),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(45, 45, 55),
        Border = Color3.fromRGB(60, 60, 75)
    },
    Red = {
        Background = Color3.fromRGB(30, 20, 20),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(50, 30, 30),
        Border = Color3.fromRGB(80, 40, 40)
    },
    Green = {
        Background = Color3.fromRGB(20, 30, 20),
        Accent = Color3.fromRGB(80, 255, 120),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(30, 50, 30),
        Border = Color3.fromRGB(40, 80, 40)
    },
    Blue = {
        Background = Color3.fromRGB(20, 25, 40),
        Accent = Color3.fromRGB(80, 180, 255),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(30, 40, 60),
        Border = Color3.fromRGB(40, 60, 90)
    },
    Purple = {
        Background = Color3.fromRGB(25, 20, 40),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(40, 30, 60),
        Border = Color3.fromRGB(60, 40, 90)
    },
    Pink = {
        Background = Color3.fromRGB(35, 20, 30),
        Accent = Color3.fromRGB(255, 120, 180),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(55, 30, 45),
        Border = Color3.fromRGB(80, 40, 60)
    },
    Orange = {
        Background = Color3.fromRGB(35, 25, 20),
        Accent = Color3.fromRGB(255, 150, 80),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(55, 40, 30),
        Border = Color3.fromRGB(80, 60, 40)
    },
    Yellow = {
        Background = Color3.fromRGB(35, 35, 20),
        Accent = Color3.fromRGB(255, 220, 80),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(55, 55, 30),
        Border = Color3.fromRGB(80, 80, 40)
    },
    Cyan = {
        Background = Color3.fromRGB(20, 35, 35),
        Accent = Color3.fromRGB(80, 220, 255),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(30, 55, 55),
        Border = Color3.fromRGB(40, 80, 80)
    },
    Magenta = {
        Background = Color3.fromRGB(35, 20, 35),
        Accent = Color3.fromRGB(255, 80, 200),
        Text = Color3.fromRGB(235, 235, 240),
        Secondary = Color3.fromRGB(55, 30, 55),
        Border = Color3.fromRGB(80, 40, 80)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 45),
        Accent = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(235, 240, 250),
        Secondary = Color3.fromRGB(25, 40, 65),
        Border = Color3.fromRGB(40, 70, 100)
    },
    Sunset = {
        Background = Color3.fromRGB(40, 20, 25),
        Accent = Color3.fromRGB(255, 150, 100),
        Text = Color3.fromRGB(250, 240, 235),
        Secondary = Color3.fromRGB(60, 30, 35),
        Border = Color3.fromRGB(90, 50, 45)
    },
    Neon = {
        Background = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(0, 255, 200),
        Text = Color3.fromRGB(200, 255, 240),
        Secondary = Color3.fromRGB(30, 30, 45),
        Border = Color3.fromRGB(0, 80, 70)
    },
    Royal = {
        Background = Color3.fromRGB(25, 20, 35),
        Accent = Color3.fromRGB(200, 150, 255),
        Text = Color3.fromRGB(240, 235, 250),
        Secondary = Color3.fromRGB(40, 30, 55),
        Border = Color3.fromRGB(70, 50, 100)
    },
    Forest = {
        Background = Color3.fromRGB(20, 30, 22),
        Accent = Color3.fromRGB(120, 255, 150),
        Text = Color3.fromRGB(230, 245, 235),
        Secondary = Color3.fromRGB(30, 45, 32),
        Border = Color3.fromRGB(50, 85, 55)
    },
    Lavender = {
        Background = Color3.fromRGB(30, 25, 40),
        Accent = Color3.fromRGB(200, 180, 255),
        Text = Color3.fromRGB(245, 240, 255),
        Secondary = Color3.fromRGB(45, 38, 58),
        Border = Color3.fromRGB(80, 65, 110)
    },
    Mint = {
        Background = Color3.fromRGB(22, 35, 30),
        Accent = Color3.fromRGB(150, 255, 220),
        Text = Color3.fromRGB(235, 250, 245),
        Secondary = Color3.fromRGB(32, 50, 42),
        Border = Color3.fromRGB(55, 90, 75)
    },
    Coral = {
        Background = Color3.fromRGB(40, 22, 25),
        Accent = Color3.fromRGB(255, 150, 150),
        Text = Color3.fromRGB(250, 240, 240),
        Secondary = Color3.fromRGB(60, 32, 35),
        Border = Color3.fromRGB(90, 50, 50)
    },
    Sky = {
        Background = Color3.fromRGB(18, 28, 45),
        Accent = Color3.fromRGB(135, 206, 255),
        Text = Color3.fromRGB(235, 245, 255),
        Secondary = Color3.fromRGB(28, 42, 65),
        Border = Color3.fromRGB(45, 75, 110)
    },
    Rose = {
        Background = Color3.fromRGB(35, 22, 28),
        Accent = Color3.fromRGB(255, 130, 170),
        Text = Color3.fromRGB(250, 240, 245),
        Secondary = Color3.fromRGB(55, 32, 40),
        Border = Color3.fromRGB(90, 45, 65)
    },
    Emerald = {
        Background = Color3.fromRGB(18, 32, 22),
        Accent = Color3.fromRGB(80, 220, 140),
        Text = Color3.fromRGB(235, 250, 240),
        Secondary = Color3.fromRGB(28, 48, 32),
        Border = Color3.fromRGB(45, 85, 55)
    },
    Ruby = {
        Background = Color3.fromRGB(35, 18, 18),
        Accent = Color3.fromRGB(220, 60, 80),
        Text = Color3.fromRGB(250, 235, 235),
        Secondary = Color3.fromRGB(55, 28, 28),
        Border = Color3.fromRGB(90, 40, 40)
    },
    Sapphire = {
        Background = Color3.fromRGB(18, 22, 40),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(235, 240, 255),
        Secondary = Color3.fromRGB(28, 35, 60),
        Border = Color3.fromRGB(45, 60, 100)
    },
    Amber = {
        Background = Color3.fromRGB(35, 28, 18),
        Accent = Color3.fromRGB(255, 190, 80),
        Text = Color3.fromRGB(250, 245, 235),
        Secondary = Color3.fromRGB(55, 42, 28),
        Border = Color3.fromRGB(90, 70, 40)
    }
}

--======================================================
-- TIỆN ÍCH
--======================================================
local function tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(60, 60, 75)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function glassSheen(obj, brightness)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1 - (brightness or 0.06)),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 1),
    })
    grad.Rotation = 90
    grad.Parent = obj
    return grad
end

local function makeDraggable(dragHandle, target)
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--======================================================
-- LIBRARY CHÍNH
--======================================================
local GUILib = {}
GUILib.__index = GUILib

function GUILib.new(config)
    config = config or {}

    local self = setmetatable({}, GUILib)

    -- Xử lý theme
    local themeName = config.Theme or "Dark"
    local theme = Themes[themeName] or Themes.Dark
    
    self.ThemeName = themeName
    self.ThemeColors = theme
    self.ThemeColor = theme.Background
    self.AccentColor = config.AccentColor or theme.Accent
    self.TextColor = theme.Text
    self.SecondaryColor = theme.Secondary
    self.BorderColor = theme.Border

    -- Cấu hình cơ bản
    self.Title = config.Title or "Floating GUI"
    self.Width = config.Width or 350
    self.Height = config.Height or 300
    self.Resizable = (config.Resizable == nil) and true or config.Resizable
    self.GlassTransparency = config.Transparency or 0.16
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    self.Tabs = {}
    self.ActiveTab = nil

    self:_Build()

    return self
end

function GUILib:ApplyTheme(themeName)
    local theme = Themes[themeName]
    if not theme then return end
    
    self.ThemeName = themeName
    self.ThemeColors = theme
    self.ThemeColor = theme.Background
    self.TextColor = theme.Text
    self.SecondaryColor = theme.Secondary
    self.BorderColor = theme.Border
    
    -- Cập nhật UI
    self:SetThemeColor(theme.Background)
    self:SetAccentColor(self.AccentColor) -- Giữ accent hiện tại hoặc reset về theme accent
    
    -- Cập nhật các thành phần khác
    self:UpdateUIComponents()
end

function GUILib:UpdateUIComponents()
    local T = self.GlassTransparency
    
    -- Cập nhật màu nền cho các thành phần
    for _, tab in ipairs(self.Tabs) do
        if tab.Page then
            -- Cập nhật các components trong tab
            for _, child in ipairs(tab.Page:GetChildren()) do
                if child:IsA("Frame") and child.BackgroundTransparency < 1 then
                    child.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

--======================================================
-- DỰNG GIAO DIỆN
--======================================================
function GUILib:_Build()
    local T = self.GlassTransparency
    local theme = self.ThemeColors

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    self.ScreenGui = screenGui

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.35
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    shadow.ZIndex = 0
    self.Shadow = shadow

    -- Glow
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://6014261993"
    glow.ImageColor3 = self.AccentColor
    glow.ImageTransparency = 0.82
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(99, 99, 99, 99)
    glow.ZIndex = 0
    self.GlowImage = glow

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width / 2, 0.5, -self.Height / 2)
    main.BackgroundColor3 = self.ThemeColor
    main.BackgroundTransparency = T
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    corner(main, 14)
    stroke(main, theme.Border, 1, 0.7)
    self.MainFrame = main

    -- Sync overlays
    local function SyncOverlay()
        shadow.Position = main.Position - UDim2.new(0, 18, 0, 12)
        shadow.Size = main.Size + UDim2.new(0, 46, 0, 46)
        glow.Position = main.Position - UDim2.new(0, 20, 0, 20)
        glow.Size = main.Size + UDim2.new(0, 40, 0, 40)
    end
    SyncOverlay()
    main:GetPropertyChangedSignal("Position"):Connect(SyncOverlay)
    main:GetPropertyChangedSignal("Size"):Connect(SyncOverlay)
    self._SyncOverlay = SyncOverlay

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = self.ThemeColor
    titleBar.BackgroundTransparency = math.clamp(T + 0.1, 0, 0.95)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    corner(titleBar, 14)
    glassSheen(titleBar, 0.05)
    self.TitleBar = titleBar

    local titleFix = Instance.new("Frame")
    titleFix.Name = "TitleFix"
    titleFix.Size = UDim2.new(1, 0, 0, 14)
    titleFix.Position = UDim2.new(0, 0, 1, -14)
    titleFix.BackgroundColor3 = self.ThemeColor
    titleFix.BackgroundTransparency = titleBar.BackgroundTransparency
    titleFix.BorderSizePixel = 0
    titleFix.ZIndex = titleBar.ZIndex
    titleFix.Parent = titleBar

    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = self.AccentColor
    dot.Position = UDim2.new(0, 12, 0.5, -3)
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Parent = titleBar
    corner(dot, 3)
    self.TitleDot = dot

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 26, 0, 0)
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = self.TextColor
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = titleBar
    self.TitleLabel = titleLabel

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.AutoButtonColor = false
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    closeBtn.BackgroundTransparency = 0.75
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
    closeBtn.Parent = titleBar
    corner(closeBtn, 7)

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.75, TextColor3 = Color3.fromRGB(255, 160, 160)}, 0.12)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)

    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeButton"
    minBtn.AutoButtonColor = false
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -58, 0, 7)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.BackgroundTransparency = 0.9
    minBtn.Text = "—"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.TextColor3 = self.TextColor
    minBtn.Parent = titleBar
    corner(minBtn, 7)

    minBtn.MouseEnter:Connect(function()
        tween(minBtn, {BackgroundTransparency = 0.75}, 0.12)
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, {BackgroundTransparency = 0.9}, 0.12)
    end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, self.Width, 0, 38)}, 0.22, Enum.EasingStyle.Quint)
        else
            tween(main, {Size = UDim2.new(0, self.Width, 0, self.Height)}, 0.22, Enum.EasingStyle.Quint)
        end
    end)
    self._minimized = function() return minimized end

    makeDraggable(titleBar, main)

    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 104, 1, -38)
    tabContainer.Position = UDim2.new(0, 0, 0, 38)
    tabContainer.BackgroundColor3 = self.SecondaryColor
    tabContainer.BackgroundTransparency = math.clamp(T + 0.05, 0, 0.95)
    tabContainer.BorderSizePixel = 0
    tabContainer.ClipsDescendants = true
    tabContainer.Parent = main
    self.TabContainer = tabContainer

    -- Tab Bar Line
    local tabBarLine = Instance.new("Frame")
    tabBarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabBarLine.BackgroundTransparency = 0.92
    tabBarLine.BorderSizePixel = 0
    tabBarLine.Position = UDim2.new(1, -1, 0, 0)
    tabBarLine.Size = UDim2.new(0, 1, 1, 0)
    tabBarLine.ZIndex = 3
    tabBarLine.Parent = tabContainer

    -- Tab Bar
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 1, 0)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 3
    tabBar.ScrollBarImageColor3 = self.AccentColor
    tabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabBar.Parent = tabContainer
    self.TabBar = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 0)
    tabPadding.PaddingBottom = UDim.new(0, 8)
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = tabBar

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 2)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "ContentArea"
    content.Size = UDim2.new(1, -104, 1, -38)
    content.Position = UDim2.new(0, 104, 0, 38)
    content.BackgroundColor3 = self.ThemeColor
    content.BackgroundTransparency = T
    content.BorderSizePixel = 0
    content.Parent = main
    self.ContentArea = content

    -- Resize Handle
    if self.Resizable then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.new(0, 18, 0, 18)
        resizeHandle.Position = UDim2.new(1, -18, 1, -18)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Parent = main

        for i = 0, 2 do
            for j = 0, (2 - i) do
                local grip = Instance.new("Frame")
                grip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                grip.BackgroundTransparency = 0.55
                grip.BorderSizePixel = 0
                grip.Size = UDim2.new(0, 2, 0, 2)
                grip.Position = UDim2.new(1, -5 - i * 5, 1, -5 - j * 5)
                grip.Parent = resizeHandle
                corner(grip, 1)
            end
        end

        local resizing = false
        local startInputPos, startSize

        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                startInputPos = input.Position
                startSize = main.Size

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        resizing = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startInputPos
                local newWidth = math.max(250, startSize.X.Offset + delta.X)
                local newHeight = math.max(200, startSize.Y.Offset + delta.Y)
                self:SetSize(newWidth, newHeight)
            end
        end)
    end

    -- Hotkey
    self._open = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.ToggleKey then
            self:Toggle(not self._open)
        end
    end)

    -- Open animation
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, self.Width * 0.94, 0, self.Height * 0.94)
    shadow.ImageTransparency = 1
    glow.ImageTransparency = 1
    tween(main, {
        Size = UDim2.new(0, self.Width, 0, self.Height),
        BackgroundTransparency = T,
    }, 0.22, Enum.EasingStyle.Back)
    tween(shadow, {ImageTransparency = 0.35}, 0.3)
    tween(glow, {ImageTransparency = 0.82}, 0.3)
end

--======================================================
-- API
--======================================================
function GUILib:SetTheme(themeName)
    self:ApplyTheme(themeName)
end

function GUILib:SetThemeColor(color)
    self.ThemeColor = color
    local T = self.GlassTransparency

    tween(self.MainFrame, {BackgroundColor3 = color}, 0.2)
    tween(self.TitleBar, {BackgroundColor3 = color}, 0.2)
    tween(self.ContentArea, {BackgroundColor3 = color}, 0.2)

    local titleFix = self.TitleBar:FindFirstChild("TitleFix")
    if titleFix then
        tween(titleFix, {BackgroundColor3 = color}, 0.2)
    end
end

function GUILib:SetAccentColor(color)
    self.AccentColor = color
    if self.GlowImage then
        tween(self.GlowImage, {ImageColor3 = color}, 0.2)
    end
    if self.TitleDot then
        tween(self.TitleDot, {BackgroundColor3 = color}, 0.2)
    end
    if self.ActiveTab and self.ActiveTab.Button then
        local indicator = self.ActiveTab.Button:FindFirstChild("Indicator")
        if indicator then
            tween(indicator, {BackgroundColor3 = color}, 0.2)
        end
    end
end

function GUILib:SetSize(width, height)
    self.Width = width
    self.Height = height
    if self._minimized and self._minimized() then
        self.MainFrame.Size = UDim2.new(0, width, 0, 38)
    else
        tween(self.MainFrame, {Size = UDim2.new(0, width, 0, height)}, 0.15)
    end
end

function GUILib:SetTitle(name)
    self.Title = name
    self.TitleLabel.Text = name
end

function GUILib:Toggle(visible)
    self._open = visible
    if visible then
        self.ScreenGui.Enabled = true
        self.MainFrame.BackgroundTransparency = 1
        tween(self.MainFrame, {BackgroundTransparency = self.GlassTransparency}, 0.15)
    else
        tween(self.MainFrame, {BackgroundTransparency = 1}, 0.12)
        task.delay(0.12, function()
            if not self._open then
                self.ScreenGui.Enabled = false
            end
        end)
    end
end

function GUILib:Destroy()
    self.ScreenGui:Destroy()
end

function GUILib:SetTransparency(value)
    value = math.clamp(value, 0, 0.6)
    self.GlassTransparency = value
    local T = value

    tween(self.MainFrame, {BackgroundTransparency = T}, 0.2)
    tween(self.TitleBar, {BackgroundTransparency = math.clamp(T + 0.1, 0, 0.95)}, 0.2)
    tween(self.ContentArea, {BackgroundTransparency = T}, 0.2)

    local titleFix = self.TitleBar:FindFirstChild("TitleFix")
    if titleFix then
        tween(titleFix, {BackgroundTransparency = math.clamp(T + 0.1, 0, 0.95)}, 0.2)
    end
end

function GUILib:SetToggleKey(keyCode)
    self.ToggleKey = keyCode
end

function GUILib:Notify(title, name, duration)
    duration = duration or 3

    local notif = Instance.new("Frame")
    notif.AnchorPoint = Vector2.new(1, 1)
    notif.Position = UDim2.new(1, -20, 1, -20)
    notif.Size = UDim2.new(0, 260, 0, 0)
    notif.BackgroundColor3 = self.ThemeColor
    notif.BackgroundTransparency = 0.15
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = self.ScreenGui
    corner(notif, 10)
    stroke(notif, self.ThemeColors.Border, 1, 0.7)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = self.AccentColor
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.Parent = notif
    corner(bar, 2)

    local titleL = Instance.new("TextLabel")
    titleL.BackgroundTransparency = 1
    titleL.Position = UDim2.new(0, 14, 0, 8)
    titleL.Size = UDim2.new(1, -24, 0, 18)
    titleL.Font = Enum.Font.GothamBold
    titleL.Text = title or "Thông báo"
    titleL.TextColor3 = self.TextColor
    titleL.TextSize = 13
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.Parent = notif

    local bodyL = Instance.new("TextLabel")
    bodyL.BackgroundTransparency = 1
    bodyL.Position = UDim2.new(0, 14, 0, 28)
    bodyL.Size = UDim2.new(1, -24, 0, 0)
    bodyL.Font = Enum.Font.Gotham
    bodyL.Text = name or ""
    bodyL.TextColor3 = Color3.fromRGB(210, 210, 216)
    bodyL.TextSize = 12
    bodyL.TextWrapped = true
    bodyL.TextXAlignment = Enum.TextXAlignment.Left
    bodyL.AutomaticSize = Enum.AutomaticSize.Y
    bodyL.Parent = notif

    task.wait()
    local targetHeight = 28 + bodyL.AbsoluteSize.Y + 12
    tween(notif, {Size = UDim2.new(0, 260, 0, targetHeight)}, 0.2, Enum.EasingStyle.Back)

    task.delay(duration, function()
        local t = tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(0, 260, 0, 0)}, 0.2)
        t.Completed:Wait()
        notif:Destroy()
    end)
end

--======================================================
-- TAB SYSTEM
--======================================================
local Tab = {}
Tab.__index = Tab

function GUILib:_AutoBalanceTabs()
    local tabBar = self.TabBar
    if not tabBar then return end
    
    task.wait()
    
    local tabButtons = {}
    for _, child in ipairs(tabBar:GetChildren()) do
        if child:IsA("TextButton") and child.Name:find("TabButton") then
            table.insert(tabButtons, child)
        end
    end
    
    if #tabButtons == 0 then return end
    
    local totalHeight = 0
    local spacing = 2
    
    for _, btn in ipairs(tabButtons) do
        totalHeight = totalHeight + btn.Size.Y.Offset + spacing
    end
    
    totalHeight = totalHeight + 8
    
    tabBar.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    tabBar.CanvasPosition = Vector2.new(0, 0)
end

function GUILib:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.AutoButtonColor = false
    tabButton.Size = UDim2.new(1, 0, 0, 30)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = "  " .. name
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 13
    tabButton.TextColor3 = Color3.fromRGB(170, 170, 178)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.TextTruncate = Enum.TextTruncate.AtEnd
    tabButton.Parent = self.TabBar
    corner(tabButton, 8)

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.BackgroundColor3 = self.AccentColor
    indicator.BorderSizePixel = 0
    indicator.Parent = tabButton
    corner(indicator, 2)

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self.AccentColor
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = self.ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = page

    local tabObj = setmetatable({
        Name = name,
        Button = tabButton,
        Page = page,
        Library = self,
    }, Tab)

    table.insert(self.Tabs, tabObj)

    tabButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabButton, {BackgroundTransparency = 0.85}, 0.12)
        end
    end)
    tabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabButton, {BackgroundTransparency = 1}, 0.12)
        end
    end)

    tabButton.MouseButton1Click:Connect(function()
        self:_SelectTab(tabObj)
    end)

    if #self.Tabs == 1 then
        self:_SelectTab(tabObj)
    end
    
    task.spawn(function()
        task.wait(0.05)
        self:_AutoBalanceTabs()
    end)

    return tabObj
end

function GUILib:_SelectTab(tabObj)
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(170, 170, 178)}, 0.15)
        local ind = t.Button:FindFirstChild("Indicator")
        if ind then
            tween(ind, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
        end
    end

    tabObj.Page.Visible = true
    tween(tabObj.Button, {BackgroundTransparency = 0.88, TextColor3 = self.TextColor}, 0.15)
    local ind = tabObj.Button:FindFirstChild("Indicator")
    if ind then
        tween(ind, {Size = UDim2.new(0, 3, 0, 18)}, 0.18, Enum.EasingStyle.Back)
    end

    self.ActiveTab = tabObj
    
    task.spawn(function()
        task.wait(0.05)
        self:_AutoBalanceTabs()
    end)
end

--======================================================
-- COMPONENTS
--======================================================

-- Button với border cải thiện
function Tab:AddButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.92
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = self.Library.TextColor
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = self.Page
    corner(btn, 8)
    stroke(btn, self.Library.ThemeColors.Border, 1, 0.7)

    btn.MouseEnter:Connect(function()
        tween(btn, {
            BackgroundColor3 = self.Library.AccentColor,
            BackgroundTransparency = 0.15,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.92,
            TextColor3 = self.Library.TextColor
        }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 5
        ripple.Parent = btn
        corner(ripple, 999)

        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
        tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.4)
        task.delay(0.4, function()
            ripple:Destroy()
        end)

        if callback then callback() end
    end)

    return btn
end

-- Toggle với màu sắc cải thiện và border
function Tab:AddToggle(name, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 34)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.94
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, self.Library.ThemeColors.Border, 1, 0.7)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -62, 1, 0)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = self.Library.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = default and self.Library.AccentColor or Color3.fromRGB(255, 255, 255)
    switch.BackgroundTransparency = default and 0.1 or 0.85
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = holder
    corner(switch, 10)
    stroke(switch, self.Library.ThemeColors.Border, 1, 0.5)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switch
    corner(knob, 8)
    stroke(knob, self.Library.ThemeColors.Border, 1, 0.5)

    local state = default or false
    local function updateVisual(s)
        local targetColor = s and self.Library.AccentColor or Color3.fromRGB(255, 255, 255)
        local targetTrans = s and 0.1 or 0.85
        tween(switch, {
            BackgroundColor3 = targetColor,
            BackgroundTransparency = targetTrans,
        }, 0.15)
        tween(knob, {Position = s and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.15, Enum.EasingStyle.Back)
    end

    -- Cập nhật border khi toggle
    local toggleStroke = switch:FindFirstChild("UIStroke")
    if toggleStroke then
        toggleStroke.Color = self.Library.ThemeColors.Border
    end

    switch.MouseButton1Click:Connect(function()
        state = not state
        updateVisual(state)
        if callback then callback(state) end
    end)

    return {
        Set = function(_, value)
            state = value
            updateVisual(state)
        end,
        Get = function() return state end,
    }
end

-- Slider với border và màu sắc cải thiện
function Tab:AddSlider(name, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 50)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.94
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, self.Library.ThemeColors.Border, 1, 0.7)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 8)
    label.Size = UDim2.new(1, -60, 0, 18)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = self.Library.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 44, 0, 18)
    valueLabel.Position = UDim2.new(1, -56, 0, 8)
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = self.Library.AccentColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    track.BackgroundTransparency = 0.85
    track.Parent = holder
    corner(track, 3)
    stroke(track, self.Library.ThemeColors.Border, 1, 0.5)

    local fill = Instance.new("Frame")
    local pct = (default - min) / (max - min)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = self.Library.AccentColor
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 7)
    stroke(knob, self.Library.AccentColor, 2, 0)

    local dragging = false
    local function updateFromInput(inputPos)
        local relX = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relX + 0.5)
        relX = (value - min) / (max - min)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
        return value
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input.Position.X)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input.Position.X)
        end
    end)

    return holder
end

-- Dropdown với border và màu sắc cải thiện
function Tab:AddDropdown(name, options, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.94
    holder.ClipsDescendants = true
    holder.Parent = self.Page
    corner(holder, 8)
    stroke(holder, self.Library.ThemeColors.Border, 1, 0.7)

    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, 36)
    main.BackgroundTransparency = 1
    main.Text = "  " .. name
    main.Font = Enum.Font.Gotham
    main.TextSize = 13
    main.TextColor3 = self.Library.TextColor
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.Parent = holder

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 24, 0, 36)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = self.Library.AccentColor
    arrow.TextSize = 13
    arrow.Parent = holder

    local listHolder = Instance.new("Frame")
    listHolder.Size = UDim2.new(1, 0, 0, #options * 28)
    listHolder.Position = UDim2.new(0, 0, 0, 36)
    listHolder.BackgroundTransparency = 1
    listHolder.Parent = holder

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = listHolder

    local expanded = false
    for _, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.AutoButtonColor = false
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  " .. option
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.TextColor3 = self.Library.TextColor
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Parent = listHolder

        optBtn.MouseEnter:Connect(function()
            tween(optBtn, {BackgroundTransparency = 0.85}, 0.1)
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, {BackgroundTransparency = 1}, 0.1)
        end)

        optBtn.MouseButton1Click:Connect(function()
            main.Text = "  " .. option
            expanded = false
            tween(holder, {Size = UDim2.new(1, 0, 0, 36)}, 0.15)
            tween(arrow, {Rotation = 0}, 0.15)
            if callback then callback(option) end
        end)
    end

    main.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            tween(holder, {Size = UDim2.new(1, 0, 0, 36 + #options * 28)}, 0.18)
            tween(arrow, {Rotation = 180}, 0.18)
        else
            tween(holder, {Size = UDim2.new(1, 0, 0, 36)}, 0.15)
            tween(arrow, {Rotation = 0}, 0.15)
        end
    end)

    return holder
end

-- Textbox với border cải thiện
function Tab:AddTextbox(name, placeholder, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 52)
    holder.BackgroundTransparency = 1
    holder.Parent = self.Page

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = self.Library.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 32)
    box.Position = UDim2.new(0, 0, 0, 18)
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundTransparency = 0.92
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 158)
    box.Text = ""
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = self.Library.TextColor
    box.ClearTextOnFocus = false
    box.Parent = holder
    corner(box, 8)
    local boxStroke = stroke(box, self.Library.ThemeColors.Border, 1, 0.7)

    box.Focused:Connect(function()
        tween(boxStroke, {Color = self.Library.AccentColor, Transparency = 0.3}, 0.15)
    end)
    box.FocusLost:Connect(function(enterPressed)
        tween(boxStroke, {Color = self.Library.ThemeColors.Border, Transparency = 0.7}, 0.15)
        if callback then callback(box.Text, enterPressed) end
    end)

    return box
end

function Tab:AddLabel(name)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = self.Library.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = self.Page
    return label
end

function Tab:AddSection(name)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 24)
    holder.BackgroundTransparency = 1
    holder.Parent = self.Page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = self.Library.AccentColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.9
    line.BorderSizePixel = 0
    line.Parent = holder

    return holder
end

return GUILib