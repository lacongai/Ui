--[[
    SlimeUI.lua - UI Hoàn Chỉnh, Không Lỗi
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======================================================
-- TIỆN ÍCH
-- ======================================================
local function tween(obj, props, time)
    time = time or 0.2
    local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function createParticles(position, color)
    color = color or Color3.fromRGB(100, 150, 255)
    for i = 1, 10 do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, 3, 0, 3)
        p.Position = UDim2.new(0, position.X + math.random(-10, 10), 0, position.Y + math.random(-10, 10))
        p.BackgroundColor3 = color
        p.BorderSizePixel = 0
        p.Parent = game:GetService("CoreGui")
        corner(p, 2)
        
        local angle = math.random() * 2 * math.pi
        local speed = math.random(50, 150)
        
        task.spawn(function()
            for t = 1, 30 do
                p.Position = UDim2.new(0, p.Position.X.Offset + math.cos(angle) * speed/100, 
                                      0, p.Position.Y.Offset + math.sin(angle) * speed/100)
                p.BackgroundTransparency = t / 30
                p.Size = UDim2.new(0, 3 * (1 - t/30), 0, 3 * (1 - t/30))
                task.wait()
            end
            p:Destroy()
        end)
    end
end

-- ======================================================
-- WINDOW CLASS
-- ======================================================
local Window = {}
Window.__index = Window

function Window.new(config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    self.Title = config.Title or "Slime Hub"
    self.Width = config.Width or 520
    self.Height = config.Height or 400
    self.Tabs = {}
    self.ActiveTab = nil
    self.IsMinimized = false
    self.IsMaximized = false
    self.NormalWidth = self.Width
    self.NormalHeight = self.Height
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SlimeUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    self.ScreenGui = screenGui
    
    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    corner(main, 14)
    self.Main = main
    
    -- Glow Border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    border.BackgroundTransparency = 0.6
    border.Parent = main
    corner(border, 16)
    self.Border = border
    
    -- Gradient Background
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    bg.BackgroundTransparency = 0
    bg.Parent = main
    corner(bg, 14)
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(
        Color3.fromRGB(18, 18, 28),
        Color3.fromRGB(28, 18, 38)
    )
    grad.Rotation = 45
    grad.Parent = bg
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    corner(titleBar, 14)
    self.TitleBar = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 14, 0, 0)
    titleText.Size = UDim2.new(0.6, 0, 1, 0)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "◆ " .. self.Title
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    self.TitleText = titleText
    
    -- Control Buttons
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 100, 1, 0)
    controls.Position = UDim2.new(1, -108, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = titleBar
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(0, 2, 0.5, -14)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.BackgroundTransparency = 0.85
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.AutoButtonColor = false
    minBtn.Parent = controls
    corner(minBtn, 6)
    self.MinBtn = minBtn
    
    minBtn.MouseEnter:Connect(function()
        tween(minBtn, {BackgroundTransparency = 0.3}, 0.1)
        tween(minBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, {BackgroundTransparency = 0.85}, 0.1)
        tween(minBtn, {TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
    end)
    minBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Maximize Button
    local maxBtn = Instance.new("TextButton")
    maxBtn.Size = UDim2.new(0, 28, 0, 28)
    maxBtn.Position = UDim2.new(0, 34, 0.5, -14)
    maxBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    maxBtn.BackgroundTransparency = 0.85
    maxBtn.Text = "□"
    maxBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    maxBtn.TextSize = 14
    maxBtn.Font = Enum.Font.GothamBold
    maxBtn.AutoButtonColor = false
    maxBtn.Parent = controls
    corner(maxBtn, 6)
    self.MaxBtn = maxBtn
    
    maxBtn.MouseEnter:Connect(function()
        tween(maxBtn, {BackgroundTransparency = 0.3}, 0.1)
        tween(maxBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    maxBtn.MouseLeave:Connect(function()
        tween(maxBtn, {BackgroundTransparency = 0.85}, 0.1)
        tween(maxBtn, {TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
    end)
    maxBtn.MouseButton1Click:Connect(function()
        self:ToggleMaximize()
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(0, 66, 0.5, -14)
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
        self:Destroy()
    end)
    
    -- Tab Bar
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Position = UDim2.new(0, 0, 0, 44)
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    tabBar.BackgroundTransparency = 0.3
    tabBar.BorderSizePixel = 0
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.ScrollBarThickness = 3
    tabBar.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.Parent = main
    self.TabBar = tabBar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar
    
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0, 8)
    tabPad.PaddingRight = UDim.new(0, 8)
    tabPad.PaddingTop = UDim.new(0, 4)
    tabPad.PaddingBottom = UDim.new(0, 4)
    tabPad.Parent = tabBar
    
    local function updateTabCanvas()
        tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 16, 0, 0)
    end
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)
    updateTabCanvas()
    
    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "ContentArea"
    content.Position = UDim2.new(0, 0, 0, 84)
    content.Size = UDim2.new(1, 0, 1, -84)
    content.BackgroundTransparency = 1
    content.Parent = main
    self.ContentArea = content
    
    -- Drag Window
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
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
    
    -- Resize Handle
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 16, 0, 16)
    resizeHandle.Position = UDim2.new(1, -16, 1, -16)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    resizeHandle.BackgroundTransparency = 0.7
    resizeHandle.Parent = main
    corner(resizeHandle, 4)
    self.ResizeHandle = resizeHandle
    
    local resizeData = {}
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeData.active = true
            resizeData.startPos = input.Position
            resizeData.startSize = main.Size
        end
    end)
    resizeHandle.InputEnded:Connect(function()
        resizeData.active = false
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizeData.active and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeData.startPos
            local newWidth = math.max(300, resizeData.startSize.X.Offset + delta.X)
            local newHeight = math.max(200, resizeData.startSize.Y.Offset + delta.Y)
            main.Size = UDim2.new(0, newWidth, 0, newHeight)
            self.Width = newWidth
            self.Height = newHeight
            if not self.IsMaximized then
                self.NormalWidth = newWidth
                self.NormalHeight = newHeight
            end
        end
    end)
    
    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                self:ToggleVisible(not self.ScreenGui.Enabled)
            end
        end
    end)
    
    -- Notification System
    function self:Notify(config)
        config = config or {}
        local notif = Instance.new("Frame")
        notif.AnchorPoint = Vector2.new(1, 1)
        notif.Position = UDim2.new(1, -16, 1, -16)
        notif.Size = UDim2.new(0, 280, 0, 0)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.ClipsDescendants = true
        notif.ZIndex = 50
        notif.Parent = screenGui
        corner(notif, 12)
        
        local borderN = Instance.new("Frame")
        borderN.Size = UDim2.new(1, 0, 0, 3)
        borderN.BackgroundColor3 = config.Type == "Success" and Color3.fromRGB(80, 220, 120) or 
                                    config.Type == "Warning" and Color3.fromRGB(255, 200, 80) or
                                    Color3.fromRGB(80, 140, 255)
        borderN.BorderSizePixel = 0
        borderN.Parent = notif
        corner(borderN, 12)
        
        local titleN = Instance.new("TextLabel")
        titleN.BackgroundTransparency = 1
        titleN.Position = UDim2.new(0, 14, 0, 14)
        titleN.Size = UDim2.new(1, -28, 0, 18)
        titleN.Font = Enum.Font.GothamBold
        titleN.Text = config.Title or "Notification"
        titleN.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleN.TextSize = 14
        titleN.TextXAlignment = Enum.TextXAlignment.Left
        titleN.Parent = notif
        
        local bodyN = Instance.new("TextLabel")
        bodyN.BackgroundTransparency = 1
        bodyN.Position = UDim2.new(0, 14, 0, 36)
        bodyN.Size = UDim2.new(1, -28, 0, 0)
        bodyN.Font = Enum.Font.Gotham
        bodyN.Text = config.Text or ""
        bodyN.TextColor3 = Color3.fromRGB(180, 180, 210)
        bodyN.TextSize = 12
        bodyN.TextWrapped = true
        bodyN.TextXAlignment = Enum.TextXAlignment.Left
        bodyN.AutomaticSize = Enum.AutomaticSize.Y
        bodyN.Parent = notif
        
        task.wait()
        local height = 50 + bodyN.AbsoluteSize.Y
        tween(notif, {Size = UDim2.new(0, 280, 0, height)}, 0.25)
        
        task.delay(config.Duration or 3, function()
            tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(0, 280, 0, 0)}, 0.2)
            task.delay(0.25, function() notif:Destroy() end)
        end)
    end
    
    return self
end

-- ======================================================
-- WINDOW METHODS
-- ======================================================

function Window:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    if self.IsMinimized then
        tween(self.Main, {Size = UDim2.new(0, self.Width, 0, 44)}, 0.25)
        if self.MinBtn then
            self.MinBtn.Text = "▢"
        end
    else
        local h = self.IsMaximized and 600 or self.Height
        tween(self.Main, {Size = UDim2.new(0, self.Width, 0, h)}, 0.25)
        if self.MinBtn then
            self.MinBtn.Text = "─"
        end
    end
end

function Window:ToggleMaximize()
    self.IsMaximized = not self.IsMaximized
    if self.IsMaximized then
        self.NormalWidth = self.Width
        self.NormalHeight = self.Height
        self.Width = 800
        self.Height = 600
        tween(self.Main, {
            Size = UDim2.new(0, 800, 0, 600),
            Position = UDim2.new(0.5, -400, 0.5, -300)
        }, 0.25)
        if self.MaxBtn then
            self.MaxBtn.Text = "❐"
        end
    else
        self.Width = self.NormalWidth
        self.Height = self.NormalHeight
        tween(self.Main, {
            Size = UDim2.new(0, self.NormalWidth, 0, self.NormalHeight),
            Position = UDim2.new(0.5, -self.NormalWidth/2, 0.5, -self.NormalHeight/2)
        }, 0.25)
        if self.MaxBtn then
            self.MaxBtn.Text = "□"
        end
    end
end

function Window:ToggleVisible(visible)
    if self.ScreenGui then
        self.ScreenGui.Enabled = visible
    end
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- ======================================================
-- WINDOW:AddTab
-- ======================================================
function Window:AddTab(config)
    config = config or {}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = config.Title .. "Tab"
    tabBtn.Size = UDim2.new(0, 100, 1, -8)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.BackgroundTransparency = 0.92
    tabBtn.Text = "  " .. (config.Icon or "◆") .. " " .. config.Title
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabBar
    corner(tabBtn, 6)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 24, 0, 3)
    indicator.Position = UDim2.new(0.5, -12, 1, -4)
    indicator.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    indicator.BackgroundTransparency = (#self.Tabs == 0) and 0 or 1
    indicator.BorderSizePixel = 0
    indicator.Parent = tabBtn
    corner(indicator, 2)
    
    local page = Instance.new("ScrollingFrame")
    page.Name = config.Title .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (#self.Tabs == 0)
    page.Parent = self.ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
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
        Button = tabBtn,
        Indicator = indicator,
        Page = page,
        Layout = layout,
        Window = self,
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        self.ActiveTab = tabObj
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        self:_SelectTab(tabObj)
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabBtn, {BackgroundTransparency = 0.7}, 0.1)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabBtn, {BackgroundTransparency = 0.92}, 0.1)
        end
    end)
    
    return tabObj
end

-- ======================================================
-- WINDOW:_SelectTab
-- ======================================================
function Window:_SelectTab(tabObj)
    for _, tab in ipairs(self.Tabs) do
        local active = (tab == tabObj)
        tab.Page.Visible = active
        tab.Button.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 200)
        tween(tab.Indicator, {BackgroundTransparency = active and 0 or 1}, 0.2)
        if active then
            tween(tab.Button, {BackgroundTransparency = 0.6}, 0.15)
            local pos = tab.Button.AbsolutePosition
            createParticles(Vector2.new(pos.X + 50, pos.Y + 20), Color3.fromRGB(80, 140, 255))
        else
            tween(tab.Button, {BackgroundTransparency = 0.92}, 0.15)
        end
    end
    self.ActiveTab = tabObj
end

-- ======================================================
-- TAB CLASS
-- ======================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(window)
    local self = setmetatable({}, Tab)
    self.Window = window
    return self
end

function Tab:AddSection(name)
    local win = self.Window
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    section.BackgroundTransparency = 0.5
    section.BorderSizePixel = 0
    section.ClipsDescendants = true
    section.Parent = self.Page
    corner(section, 10)
    
    local header = Instance.new("TextLabel")
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 14, 0, 8)
    header.Size = UDim2.new(1, -28, 0, 20)
    header.Font = Enum.Font.GothamBold
    header.Text = "▸ " .. name
    header.TextColor3 = Color3.fromRGB(200, 200, 230)
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section
    
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 10, 0, 36)
    body.Size = UDim2.new(1, -20, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = section
    
    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 6)
    bodyLayout.Parent = body
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = section
    
    local sectionObj = {
        Window = win,
        Body = body,
        Section = section,
    }
    
    setmetatable(sectionObj, Section)
    return sectionObj
end

-- ======================================================
-- SECTION CLASS
-- ======================================================
local Section = {}
Section.__index = Section

function Section:AddButton(config)
    config = config or {}
    local win = self.Window
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(60, 100, 220)
    btn.BackgroundTransparency = 0.75
    btn.Text = "  " .. (config.Icon or "▶") .. " " .. config.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = self.Body
    corner(btn, 8)
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0, 60, 1, 0)
    glow.Position = UDim2.new(0, -30, 0, 0)
    glow.BackgroundColor3 = Color3.fromRGB(60, 100, 220)
    glow.BackgroundTransparency = 0.9
    glow.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.25}, 0.12)
        tween(glow, {Position = UDim2.new(1, -30, 0, 0)}, 0.4)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.75}, 0.12)
        tween(glow, {Position = UDim2.new(0, -30, 0, 0)}, 0.4)
    end)
    btn.MouseButton1Click:Connect(function()
        local pos = btn.AbsolutePosition
        createParticles(Vector2.new(pos.X + btn.AbsoluteSize.X/2, pos.Y + btn.AbsoluteSize.Y/2), Color3.fromRGB(60, 100, 220))
        if config.Callback then config.Callback() end
    end)
    
    return btn
end

function Section:AddToggle(config)
    config = config or {}
    local win = self.Window
    local state = config.Default or false
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    holder.BackgroundTransparency = 0.6
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Text = config.Text or "Toggle"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 48, 0, 26)
    switch.Position = UDim2.new(1, -56, 0.5, -13)
    switch.BackgroundColor3 = state and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(50, 50, 75)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = holder
    corner(switch, 13)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = state and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switch
    corner(knob, 10)
    
    local function setState(v)
        state = v
        tween(switch, {BackgroundColor3 = v and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(50, 50, 75)}, 0.15)
        tween(knob, {Position = v and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)}, 0.15)
        if config.Callback then config.Callback(v) end
    end
    
    switch.MouseButton1Click:Connect(function()
        setState(not state)
    end)
    
    return {
        Set = function(_, v) setState(v) end,
        Get = function() return state end,
    }
end

function Section:AddSlider(config)
    config = config or {}
    local win = self.Window
    local min = config.Min or 0
    local max = config.Max or 100
    local inc = config.Increment or 1
    local val = config.Default or min
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 54)
    holder.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    holder.BackgroundTransparency = 0.6
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 6)
    label.Size = UDim2.new(1, -80, 0, 16)
    label.Text = config.Text or "Slider"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -60, 0, 6)
    valueLabel.Size = UDim2.new(0, 48, 0, 16)
    valueLabel.Text = tostring(val)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Color3.fromRGB(80, 140, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder
    
    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 14, 0, 32)
    track.Size = UDim2.new(1, -28, 0, 8)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    track.BorderSizePixel = 0
    track.Parent = holder
    corner(track, 4)
    
    local pct = (val - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 4)
    
    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 8)
    
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
        Get = function() return val end,
    }
end

function Section:AddDropdown(config)
    config = config or {}
    local win = self.Window
    local items = config.Items or {}
    local current = config.Default or items[1] or "None"
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    holder.BackgroundTransparency = 0.6
    holder.ClipsDescendants = true
    holder.Parent = self.Body
    corner(holder, 8)
    
    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, 40)
    main.BackgroundTransparency = 1
    main.Text = "  " .. current
    main.Font = Enum.Font.Gotham
    main.TextSize = 13
    main.TextColor3 = Color3.fromRGB(200, 200, 220)
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.AutoButtonColor = false
    main.Parent = holder
    
    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 24, 0, 40)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = Color3.fromRGB(80, 140, 255)
    arrow.TextSize = 16
    arrow.Parent = holder
    
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Position = UDim2.new(0, 0, 0, 40)
    dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 42)
    dropdown.BackgroundTransparency = 0.3
    dropdown.BorderSizePixel = 0
    dropdown.ScrollBarThickness = 3
    dropdown.Parent = holder
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownLayout.Parent = dropdown
    
    local expanded = false
    
    for i, item in ipairs(items) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.BackgroundTransparency = 0.9
        optBtn.Text = "  " .. item
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.AutoButtonColor = false
        optBtn.Parent = dropdown
        
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, {BackgroundTransparency = 0.4}, 0.1)
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, {BackgroundTransparency = 0.9}, 0.1)
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
        Get = function() return current end,
    }
end

function Section:AddTextBox(config)
    config = config or {}
    local win = self.Window
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 56)
    holder.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    holder.BackgroundTransparency = 0.6
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 4)
    label.Size = UDim2.new(1, -28, 0, 14)
    label.Text = config.Text or "Input"
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(150, 150, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local box = Instance.new("TextBox")
    box.Position = UDim2.new(0, 14, 0, 22)
    box.Size = UDim2.new(1, -28, 0, 28)
    box.BackgroundTransparency = 1
    box.PlaceholderText = config.Placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
    box.Text = ""
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = Color3.fromRGB(220, 220, 240)
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = holder
    
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.5, 0, 0, 2)
    underline.Position = UDim2.new(0.5, -0.25, 1, -2)
    underline.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    underline.BackgroundTransparency = 0.7
    underline.Parent = holder
    corner(underline, 2)
    
    box.Focused:Connect(function()
        tween(underline, {Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 0.2}, 0.2)
    end)
    box.FocusLost:Connect(function(enterPressed)
        tween(underline, {Size = UDim2.new(0.5, 0, 0, 2), BackgroundTransparency = 0.7}, 0.2)
        if config.Callback then config.Callback(box.Text, enterPressed) end
    end)
    
    return {
        Set = function(_, v) box.Text = v end,
        Get = function() return box.Text end,
    }
end

-- ======================================================
-- LIBRARY
-- ======================================================
local Library = {}

function Library:CreateWindow(config)
    return Window.new(config)
end

return Library