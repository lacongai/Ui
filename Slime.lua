--[[
    AuroraUI.lua
    ------------------------------------------------------------------
    Thư viện GUI Roblox phong cách tương lai - Cyberpunk/Neon với hiệu ứng
    ánh sáng, chuyển động mượt mà, thiết kế độc đáo chưa từng có.
    
    ĐIỂM NỔI BẬT:
    - Hiệu ứng glow/neon theo chuyển động chuột
    - Cửa sổ có thể resize kéo thả góc
    - Tab hiển thị dạng sidebar trượt
    - Hiệu ứng particle khi tương tác
    - Thanh công cụ di động (floating toolbar)
    - Animation 3D nhẹ khi chuyển tab
    - Hệ thống màu dynamic thay đổi theo thời gian
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--======================================================
-- TIỆN ÍCH
--======================================================
local function tween(obj, props, time, style, dir, delay)
    time = time or 0.2
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time, style, dir, 0, false, delay or 0)
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

local function glow(obj, color, size, transparency)
    local g = Instance.new("UIGlow")
    g.Color = color or Color3.fromRGB(0, 200, 255)
    g.Size = size or 30
    g.Transparency = transparency or 0.6
    g.Parent = obj
    return g
end

local function shadow(obj, size, color)
    local s = Instance.new("UIShadow")
    s.Size = size or 20
    s.Color = color or Color3.fromRGB(0, 0, 0)
    s.Transparency = 0.5
    s.Parent = obj
    return s
end

-- Tạo particle effect
local function createParticles(position, color, count)
    count = count or 8
    local container = Instance.new("Folder")
    container.Name = "Particles"
    container.Parent = game:GetService("CoreGui")
    
    for i = 1, count do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, 4, 0, 4)
        p.Position = UDim2.new(0, position.X + math.random(-5, 5), 0, position.Y + math.random(-5, 5))
        p.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255)
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.Parent = container
        corner(p, 2)
        
        local angle = math.random() * 2 * math.pi
        local speed = math.random(50, 150)
        local life = math.random(30, 60)
        
        task.spawn(function()
            for t = 1, life do
                p.Position = UDim2.new(0, p.Position.X.Offset + math.cos(angle) * speed/100, 
                                      0, p.Position.Y.Offset + math.sin(angle) * speed/100)
                p.BackgroundTransparency = t / life
                p.Size = UDim2.new(0, 4 * (1 - t/life), 0, 4 * (1 - t/life))
                task.wait()
            end
            p:Destroy()
        end)
    end
    
    task.delay(2, function()
        container:Destroy()
    end)
end

--======================================================
-- LIBRARY CHÍNH
--======================================================
local Library = {}
Library.__index = Library

-- Màu sắc dynamic
local ColorSchemes = {
    Cyber = {Primary = Color3.fromRGB(0, 255, 255), Secondary = Color3.fromRGB(255, 0, 255)},
    Inferno = {Primary = Color3.fromRGB(255, 100, 0), Secondary = Color3.fromRGB(255, 200, 0)},
    Frost = {Primary = Color3.fromRGB(100, 200, 255), Secondary = Color3.fromRGB(200, 255, 255)},
    Toxic = {Primary = Color3.fromRGB(0, 255, 100), Secondary = Color3.fromRGB(100, 255, 0)},
    Royal = {Primary = Color3.fromRGB(150, 0, 255), Secondary = Color3.fromRGB(255, 0, 200)},
}

local Window = {}
Window.__index = Window

--======================================================
-- Library:CreateWindow(config)
--======================================================
function Library:CreateWindow(config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    self.Title = config.Title or "Aurora"
    self.Width = config.Width or 600
    self.Height = config.Height or 420
    self.Theme = config.Theme or "Cyber"
    self.PrimaryColor = ColorSchemes[self.Theme].Primary
    self.SecondaryColor = ColorSchemes[self.Theme].Secondary
    
    self.Tabs = {}
    self.ActiveTab = nil
    self.IsOpen = true
    self._mouseDown = false
    self._resizing = false
    
    self:_Build()
    
    return self
end

--======================================================
-- DỰNG KHUNG CHÍNH (Phong cách Cyberpunk)
--======================================================
function Window:_Build()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuroraUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    self.ScreenGui = screenGui
    
    -- Main container với hiệu ứng glass morphism
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    corner(main, 20)
    self.Main = main
    
    -- Glow border animation
    local borderContainer = Instance.new("Frame")
    borderContainer.Name = "BorderContainer"
    borderContainer.Size = UDim2.new(1, 4, 1, 4)
    borderContainer.Position = UDim2.new(0, -2, 0, -2)
    borderContainer.BackgroundTransparency = 1
    borderContainer.Parent = main
    
    local borderGlow = Instance.new("Frame")
    borderGlow.Name = "BorderGlow"
    borderGlow.Size = UDim2.new(1, 0, 1, 0)
    borderGlow.BackgroundTransparency = 0.8
    borderGlow.BackgroundColor3 = self.PrimaryColor
    borderGlow.Parent = borderContainer
    corner(borderGlow, 22)
    glow(borderGlow, self.PrimaryColor, 40, 0.5)
    self.BorderGlow = borderGlow
    
    -- Gradient background
    local bgGradient = Instance.new("Frame")
    bgGradient.Size = UDim2.new(1, 0, 1, 0)
    bgGradient.BackgroundColor3 = Color3.fromRGB(12, 12, 24)
    bgGradient.BackgroundTransparency = 0.6
    bgGradient.Parent = main
    corner(bgGradient, 20)
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(
        Color3.fromRGB(12, 12, 24),
        Color3.fromRGB(24, 8, 32)
    )
    grad.Rotation = 45
    grad.Parent = bgGradient
    
    -- Title bar với hiệu ứng neon
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main
    
    local titleGlow = Instance.new("Frame")
    titleGlow.Size = UDim2.new(0.3, 0, 1, 0)
    titleGlow.Position = UDim2.new(0, -20, 0, 0)
    titleGlow.BackgroundColor3 = self.PrimaryColor
    titleGlow.BackgroundTransparency = 0.9
    titleGlow.Parent = titleBar
    glow(titleGlow, self.PrimaryColor, 80, 0.3)
    
    -- Title text với hiệu ứng scanline
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.Size = UDim2.new(0.6, 0, 1, 0)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "✦ " .. self.Title
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.TextTruncate = Enum.TextTruncate.AtEnd
    titleText.Parent = titleBar
    self.TitleText = titleText
    
    -- Nút điều khiển (Minimize, Maximize, Close)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 120, 1, 0)
    controls.Position = UDim2.new(1, -130, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = titleBar
    
    local btnSize = 28
    local btnPos = 0
    
    -- Minimize button
    local minBtn = self:_CreateControlButton(controls, "─", btnPos, btnSize)
    minBtn.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)
    btnPos = btnPos + 36
    
    -- Maximize button (resize)
    local maxBtn = self:_CreateControlButton(controls, "◻", btnPos, btnSize)
    maxBtn.MouseButton1Click:Connect(function()
        self:ToggleResize()
    end)
    btnPos = btnPos + 36
    
    -- Close button
    local closeBtn = self:_CreateControlButton(controls, "✕", btnPos, btnSize)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BackgroundTransparency = 0.8
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Resize handle (góc phải dưới)
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundColor3 = self.PrimaryColor
    resizeHandle.BackgroundTransparency = 0.8
    resizeHandle.Parent = main
    corner(resizeHandle, 10)
    glow(resizeHandle, self.PrimaryColor, 15, 0.3)
    self.ResizeHandle = resizeHandle
    
    -- Thanh tab sidebar (trượt ra từ trái)
    local tabSidebar = Instance.new("ScrollingFrame")
    tabSidebar.Name = "TabSidebar"
    tabSidebar.Size = UDim2.new(0, 0, 1, -50)
    tabSidebar.Position = UDim2.new(0, -200, 0, 50)
    tabSidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    tabSidebar.BackgroundTransparency = 0.5
    tabSidebar.BorderSizePixel = 0
    tabSidebar.ScrollBarThickness = 3
    tabSidebar.ScrollBarImageColor3 = self.PrimaryColor
    tabSidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabSidebar.Parent = main
    corner(tabSidebar, 0)
    self.TabSidebar = tabSidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabSidebar
    
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingTop = UDim.new(0, 10)
    tabPad.PaddingBottom = UDim.new(0, 10)
    tabPad.PaddingLeft = UDim.new(0, 8)
    tabPad.PaddingRight = UDim.new(0, 8)
    tabPad.Parent = tabSidebar
    
    -- Nút toggle sidebar
    local toggleSidebar = Instance.new("TextButton")
    toggleSidebar.Size = UDim2.new(0, 32, 0, 32)
    toggleSidebar.Position = UDim2.new(0, 12, 0, 58)
    toggleSidebar.BackgroundColor3 = self.PrimaryColor
    toggleSidebar.BackgroundTransparency = 0.7
    toggleSidebar.Text = "☰"
    toggleSidebar.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleSidebar.TextSize = 16
    toggleSidebar.Font = Enum.Font.GothamBold
    toggleSidebar.Parent = main
    corner(toggleSidebar, 8)
    glow(toggleSidebar, self.PrimaryColor, 20, 0.3)
    self.ToggleSidebar = toggleSidebar
    
    local sidebarOpen = false
    toggleSidebar.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        local targetSize = sidebarOpen and 200 or 0
        local targetPos = sidebarOpen and 0 or -200
        tween(tabSidebar, {Size = UDim2.new(0, targetSize, 1, -50), Position = UDim2.new(0, targetPos, 0, 50)}, 0.3, Enum.EasingStyle.Back)
        tween(toggleSidebar, {Position = UDim2.new(0, sidebarOpen and 220 or 12, 0, 58)}, 0.3, Enum.EasingStyle.Back)
    end)
    
    -- Content area
    local content = Instance.new("Frame")
    content.Name = "ContentArea"
    content.Position = UDim2.new(0, 60, 0, 58)
    content.Size = UDim2.new(1, -75, 1, -65)
    content.BackgroundTransparency = 1
    content.Parent = main
    self.ContentArea = content
    
    -- Floating toolbar (di chuyển được)
    self:_CreateToolbar()
    
    -- Hiệu ứng mouse tracking
    self:_StartMouseTracking()
    
    -- Drag window
    self:_MakeDraggable(titleBar)
    
    -- Resize window
    self:_SetupResize()
end

--======================================================
-- TẠO NÚT ĐIỀU KHIỂN
--======================================================
function Window:_CreateControlButton(parent, text, pos, size)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0, pos, 0.5, -size/2)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = parent
    corner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.3}, 0.1)
        tween(btn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.9}, 0.1)
        tween(btn, {TextColor3 = Color3.fromRGB(200, 200, 210)}, 0.1)
    end)
    
    return btn
end

--======================================================
-- FLOATING TOOLBAR
--======================================================
function Window:_CreateToolbar()
    local toolbar = Instance.new("Frame")
    toolbar.Name = "Toolbar"
    toolbar.Size = UDim2.new(0, 160, 0, 40)
    toolbar.Position = UDim2.new(0.5, -80, 1, -55)
    toolbar.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    toolbar.BackgroundTransparency = 0.3
    toolbar.Parent = self.Main
    corner(toolbar, 10)
    glow(toolbar, self.PrimaryColor, 20, 0.2)
    self.Toolbar = toolbar
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = toolbar
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = toolbar
    
    -- Nút toolbar
    local tools = {"◉", "◆", "◇", "▣"}
    for i, icon in ipairs(tools) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundTransparency = 1
        btn.Text = icon
        btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = toolbar
        
        btn.MouseEnter:Connect(function()
            tween(btn, {TextColor3 = self.PrimaryColor}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {TextColor3 = Color3.fromRGB(180, 180, 200)}, 0.15)
        end)
    end
    
    -- Drag toolbar
    self:_MakeDraggable(toolbar)
end

--======================================================
-- DRAGGABLE
--======================================================
function Window:_MakeDraggable(element)
    local dragging = false
    local dragStart, startPos
    
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    
    element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            self.Main.Position = newPos
        end
    end)
end

--======================================================
-- RESIZE WINDOW
--======================================================
function Window:_SetupResize()
    local handle = self.ResizeHandle
    local resizeData = {}
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeData.active = true
            resizeData.startPos = input.Position
            resizeData.startSize = self.Main.Size
            resizeData.startPos2 = self.Main.Position
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeData.active = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizeData.active and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeData.startPos
            local newWidth = math.max(300, resizeData.startSize.X.Offset + delta.X)
            local newHeight = math.max(200, resizeData.startSize.Y.Offset + delta.Y)
            
            self.Main.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
end

--======================================================
-- MOUSE TRACKING (hiệu ứng ánh sáng theo chuột)
--======================================================
function Window:_StartMouseTracking()
    local glow = self.BorderGlow
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            local guiPos = self.Main.AbsolutePosition
            local guiSize = self.Main.AbsoluteSize
            
            local relX = (mousePos.X - guiPos.X) / guiSize.X
            local relY = (mousePos.Y - guiPos.Y) / guiSize.Y
            
            if relX >= 0 and relX <= 1 and relY >= 0 and relY <= 1 then
                local hue = (relX + relY) / 2
                local color = Color3.fromHSV(hue, 0.8, 1)
                tween(glow, {BackgroundColor3 = color}, 0.1)
            end
        end
    end)
end

--======================================================
-- WINDOW API
--======================================================
function Window:Toggle(visible)
    self.IsOpen = visible
    if visible then
        tween(self.Main, {Size = UDim2.new(0, self.Width, 0, self.Height)}, 0.2, Enum.EasingStyle.Back)
    else
        tween(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
    end
end

function Window:ToggleResize()
    -- Toggle between normal and compact mode
    local isCompact = self.Main.Size.X.Offset < 400
    local targetWidth = isCompact and 600 or 320
    local targetHeight = isCompact and 420 or 280
    
    tween(self.Main, {Size = UDim2.new(0, targetWidth, 0, targetHeight)}, 0.3, Enum.EasingStyle.Back)
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

--======================================================
-- Window:AddTab({Title=, Icon=})
--======================================================
function Window:AddTab(config)
    config = config or {}
    local self = self
    
    local tabFrame = Instance.new("TextButton")
    tabFrame.Name = config.Title .. "Tab"
    tabFrame.Size = UDim2.new(1, -16, 0, 40)
    tabFrame.AutoButtonColor = false
    tabFrame.BackgroundTransparency = 0.9
    tabFrame.Text = ""
    tabFrame.Parent = self.TabSidebar
    corner(tabFrame, 8)
    
    -- Tab content container
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = config.Title .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = self.PrimaryColor
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = (#self.Tabs == 0)
    tabContent.Parent = self.ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = tabContent
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = tabContent
    
    -- Update canvas size
    local function updateCanvas()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()
    
    -- Tab label
    local iconMap = {
        home = "⌂", settings = "⚙", user = "👤", sword = "⚔", 
        star = "★", crown = "♛", heart = "♥", bell = "🔔"
    }
    local icon = iconMap[config.Icon] or "▪"
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. config.Title
    label.TextColor3 = (#self.Tabs == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabFrame
    
    -- Tab indicator (neon line)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 1, -8)
    indicator.Position = UDim2.new(0, 4, 0.5, -#self.Tabs * 4)
    indicator.BackgroundColor3 = self.PrimaryColor
    indicator.BackgroundTransparency = (#self.Tabs == 0) and 0.2 or 1
    indicator.Parent = tabFrame
    corner(indicator, 2)
    glow(indicator, self.PrimaryColor, 10, 0.3)
    
    local tabObj = {
        Name = config.Title,
        Frame = tabFrame,
        Label = label,
        Content = tabContent,
        Indicator = indicator,
        Window = self,
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        self.ActiveTab = tabObj
    end
    
    -- Tab click handler
    tabFrame.MouseButton1Click:Connect(function()
        self:_SelectTab(tabObj)
    end)
    
    -- Hover effects
    tabFrame.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabFrame, {BackgroundTransparency = 0.7}, 0.1)
        end
    end)
    tabFrame.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(tabFrame, {BackgroundTransparency = 0.9}, 0.1)
        end
    end)
    
    return tabObj
end

function Window:_SelectTab(tabObj)
    for _, tab in ipairs(self.Tabs) do
        local active = (tab == tabObj)
        tab.Content.Visible = active
        tab.Label.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
        tween(tab.Indicator, {BackgroundTransparency = active and 0.2 or 1}, 0.2)
        if active then
            tween(tab.Frame, {BackgroundTransparency = 0.7}, 0.15)
        else
            tween(tab.Frame, {BackgroundTransparency = 0.9}, 0.15)
        end
    end
    self.ActiveTab = tabObj
    
    -- Particle effect on tab switch
    local pos = tabObj.Frame.AbsolutePosition
    createParticles(Vector2.new(pos.X + 20, pos.Y + 20), self.PrimaryColor, 12)
end

--======================================================
-- Tab:AddSection(name)
--======================================================
function Tab:AddSection(name)
    local win = self.Window
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(20, 20, 36)
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.ClipsDescendants = true
    section.Parent = self.Content
    corner(section, 12)
    
    local borderGlow = Instance.new("Frame")
    borderGlow.Size = UDim2.new(1, 0, 1, 0)
    borderGlow.BackgroundTransparency = 0.9
    borderGlow.BackgroundColor3 = win.PrimaryColor
    borderGlow.Parent = section
    corner(borderGlow, 12)
    glow(borderGlow, win.PrimaryColor, 15, 0.2)
    
    local header = Instance.new("TextLabel")
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 14, 0, 10)
    header.Size = UDim2.new(1, -28, 0, 20)
    header.Font = Enum.Font.GothamBold
    header.Text = "▸ " .. name
    header.TextColor3 = Color3.fromRGB(200, 200, 220)
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section
    
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 12, 0, 38)
    body.Size = UDim2.new(1, -24, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = section
    
    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 8)
    bodyLayout.Parent = body
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = section
    
    return setmetatable({Window = win, Body = body, Section = section}, Section)
end

--======================================================
-- Section:AddButton({Text=, Callback=})
--======================================================
function Section:AddButton(config)
    config = config or {}
    local win = self.Window
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = win.PrimaryColor
    btn.BackgroundTransparency = 0.85
    btn.Text = "  " .. config.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = self.Body
    corner(btn, 8)
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0, 80, 1, 0)
    glow.Position = UDim2.new(0, -40, 0, 0)
    glow.BackgroundColor3 = win.PrimaryColor
    glow.BackgroundTransparency = 0.9
    glow.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.3}, 0.12)
        tween(glow, {Position = UDim2.new(1, -40, 0, 0)}, 0.3)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.85}, 0.12)
        tween(glow, {Position = UDim2.new(0, -40, 0, 0)}, 0.3)
    end)
    btn.MouseButton1Click:Connect(function()
        createParticles(btn.AbsolutePosition + Vector2.new(btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2), win.PrimaryColor, 15)
        if config.Callback then config.Callback() end
    end)
    
    return btn
end

--======================================================
-- Section:AddToggle({Text=, Default=, Callback=})
--======================================================
function Section:AddToggle(config)
    config = config or {}
    local win = self.Window
    local state = config.Default or false
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.95
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Text = config.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    -- Toggle switch (thiết kế hình tròn xoay)
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 48, 0, 26)
    switch.Position = UDim2.new(1, -56, 0.5, -13)
    switch.BackgroundColor3 = state and win.PrimaryColor or Color3.fromRGB(50, 50, 70)
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
    glow(knob, win.PrimaryColor, 10, state and 0.2 or 0)
    
    local function setState(v)
        state = v
        tween(switch, {BackgroundColor3 = v and win.PrimaryColor or Color3.fromRGB(50, 50, 70)}, 0.15)
        tween(knob, {Position = v and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)}, 0.15, Enum.EasingStyle.Back)
        tween(knob, {Size = UDim2.new(0, v and 22 or 20, 0, v and 22 or 20)}, 0.1)
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

--======================================================
-- Section:AddSlider({Text=, Min=, Max=, Default=, Increment=, Callback=})
--======================================================
function Section:AddSlider(config)
    config = config or {}
    local win = self.Window
    local min = config.Min or 0
    local max = config.Max or 100
    local inc = config.Increment or 1
    local val = config.Default or min
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 60)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.95
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 8)
    label.Size = UDim2.new(1, -80, 0, 16)
    label.Text = config.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -60, 0, 8)
    valueLabel.Size = UDim2.new(0, 48, 0, 16)
    valueLabel.Text = tostring(val)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = win.PrimaryColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder
    
    -- Slider track với hiệu ứng neon
    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 12, 0, 34)
    track.Size = UDim2.new(1, -24, 0, 10)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    track.BorderSizePixel = 0
    track.Parent = holder
    corner(track, 5)
    glow(track, win.PrimaryColor, 15, 0.1)
    
    local pct = (val - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = win.PrimaryColor
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 5)
    glow(fill, win.PrimaryColor, 20, 0.2)
    
    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 9)
    glow(knob, win.PrimaryColor, 20, 0.2)
    
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
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
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

--======================================================
-- Section:AddDropdown({Text=, Items=, Default=, Callback=})
--======================================================
function Section:AddDropdown(config)
    config = config or {}
    local win = self.Window
    local items = config.Items or {}
    local current = config.Default or items[1] or "None"
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.95
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
    main.Parent = holder
    
    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 24, 0, 40)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = win.PrimaryColor
    arrow.TextSize = 16
    arrow.Parent = holder
    
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Position = UDim2.new(0, 0, 0, 40)
    dropdown.BackgroundColor3 = Color3.fromRGB(16, 16, 32)
    dropdown.BackgroundTransparency = 0.3
    dropdown.BorderSizePixel = 0
    dropdown.ScrollBarThickness = 3
    dropdown.Parent = holder
    corner(dropdown, 0)
    
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
        optBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.AutoButtonColor = false
        optBtn.Parent = dropdown
        
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, {BackgroundTransparency = 0.5}, 0.1)
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
            if config.Callback then config.Callback(item) end
        end)
    end
    
    main.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local itemCount = #items
            local height = math.min(itemCount * 32, 150)
            tween(holder, {Size = UDim2.new(1, 0, 0, 40 + height)}, 0.2)
            tween(arrow, {Rotation = 180}, 0.2)
            dropdown.Size = UDim2.new(1, 0, 0, height)
            dropdown.CanvasSize = UDim2.new(0, 0, 0, itemCount * 32)
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

--======================================================
-- Section:AddTextBox({Text=, Placeholder=, Callback=})
--======================================================
function Section:AddTextBox(config)
    config = config or {}
    local win = self.Window
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 60)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.95
    holder.Parent = self.Body
    corner(holder, 8)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 6)
    label.Size = UDim2.new(1, -24, 0, 14)
    label.Text = config.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(150, 150, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local box = Instance.new("TextBox")
    box.Position = UDim2.new(0, 12, 0, 24)
    box.Size = UDim2.new(1, -24, 0, 28)
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
    
    -- Underline glow
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.6, 0, 0, 2)
    underline.Position = UDim2.new(0.5, -0.3, 1, -2)
    underline.BackgroundColor3 = win.PrimaryColor
    underline.BackgroundTransparency = 0.7
    underline.Parent = holder
    corner(underline, 2)
    glow(underline, win.PrimaryColor, 20, 0.1)
    
    box.Focused:Connect(function()
        tween(underline, {Size = UDim2.new(1, 0, 0, 2)}, 0.2)
        tween(underline, {BackgroundTransparency = 0.2}, 0.2)
    end)
    
    box.FocusLost:Connect(function(enterPressed)
        tween(underline, {Size = UDim2.new(0.6, 0, 0, 2)}, 0.2)
        tween(underline, {BackgroundTransparency = 0.7}, 0.2)
        if config.Callback then config.Callback(box.Text, enterPressed) end
    end)
    
    return {
        Set = function(_, v) box.Text = v end,
        Get = function() return box.Text end,
    }
end

return Library