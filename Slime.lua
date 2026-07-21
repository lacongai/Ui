--[[
    AuraUI.lua - UI Phong Cách Mới, Hiện Đại, Độc Đáo
    Thiết kế theo phong cách Neon/Liquid với hiệu ứng mượt mà
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======================================================
-- TIỆN ÍCH
-- ======================================================
local function tween(obj, props, time, style, dir)
    time = time or 0.3
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
    s.Transparency = trans or 0.8
    s.Parent = obj
    return s
end

-- ======================================================
-- HIỆU ỨNG LIQUID / AURA
-- ======================================================
local function createAura(parent, color)
    local aura = Instance.new("Frame")
    aura.Size = UDim2.new(1, 10, 1, 10)
    aura.Position = UDim2.new(0, -5, 0, -5)
    aura.BackgroundColor3 = color or Color3.fromRGB(100, 80, 255)
    aura.BackgroundTransparency = 0.7
    aura.BorderSizePixel = 0
    aura.ZIndex = 0
    aura.Parent = parent
    corner(aura, 14)
    return aura
end

-- ======================================================
-- WINDOW CLASS
-- ======================================================
local Window = {}
Window.__index = Window

function Window.new(config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    self.Title = config.Title or "Aura Hub"
    self.Width = config.Width or 480
    self.Height = config.Height or 420
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Color = config.Color or Color3.fromRGB(100, 80, 255)
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    self.ScreenGui = screenGui
    
    -- === MAIN FRAME ===
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    corner(main, 16)
    self.Main = main
    
    -- Aura Glow
    local aura = createAura(main, self.Color)
    self.Aura = aura
    
    -- === HEADER ===
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 52)
    header.BackgroundColor3 = Color3.fromRGB(20, 18, 35)
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    header.Parent = main
    corner(header, 16)
    self.Header = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 16, 0, 0)
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "✦ " .. self.Title
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    self.TitleLabel = title
    
    -- Close Button (Chỉ có nút close)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.BackgroundTransparency = 0.8
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    corner(closeBtn, 8)
    
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.1}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.8}, 0.15)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- === TAB SYSTEM (Dạng Icon + Text bên trái) ===
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 120, 1, -52)
    tabContainer.Position = UDim2.new(0, 0, 0, 52)
    tabContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 28)
    tabContainer.BackgroundTransparency = 0.4
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = main
    self.TabContainer = tabContainer
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 1, 1, -20)
    divider.Position = UDim2.new(1, 0, 0, 10)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.9
    divider.BorderSizePixel = 0
    divider.Parent = tabContainer
    
    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Vertical
    tabList.Padding = UDim.new(0, 4)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.Parent = tabContainer
    
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingTop = UDim.new(0, 12)
    tabPad.PaddingBottom = UDim.new(0, 12)
    tabPad.Parent = tabContainer
    
    -- === CONTENT AREA ===
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -120, 1, -52)
    contentArea.Position = UDim2.new(0, 120, 0, 52)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    self.ContentArea = contentArea
    
    -- === DRAG (Chỉ kéo bằng header) ===
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
    
    -- === HOTKEY ===
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            self:Toggle()
        end
    end)
    
    return self
end

-- ======================================================
-- WINDOW METHODS
-- ======================================================

function Window:Toggle()
    self.Visible = not self.Visible
    if self.Visible then
        self.ScreenGui.Enabled = true
        tween(self.Main, {BackgroundTransparency = 0.05}, 0.2)
        tween(self.Aura, {BackgroundTransparency = 0.7}, 0.2)
    else
        tween(self.Main, {BackgroundTransparency = 1}, 0.15)
        tween(self.Aura, {BackgroundTransparency = 1}, 0.15)
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
    }, 0.25, Enum.EasingStyle.Back)
    tween(self.Aura, {BackgroundTransparency = 1}, 0.25)
    task.delay(0.3, function()
        self.ScreenGui:Destroy()
    end)
end

-- ======================================================
-- WINDOW:AddTab
-- ======================================================
function Window:AddTab(config)
    config = config or {}
    
    -- Tab Button (Dạng icon + text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = (#self.Tabs == 0) and 0.85 or 1
    btn.Text = config.Icon or "◆"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = (#self.Tabs == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 180)
    btn.AutoButtonColor = false
    btn.Parent = self.TabContainer
    corner(btn, 10)
    
    -- Label dưới icon
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 28)
    label.Size = UDim2.new(1, 0, 0, 14)
    label.Font = Enum.Font.Gotham
    label.Text = config.Title or "Tab"
    label.TextColor3 = (#self.Tabs == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 160)
    label.TextSize = 10
    label.Parent = btn
    
    -- Indicator (đường viền sáng)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.BackgroundColor3 = self.Color
    indicator.BackgroundTransparency = (#self.Tabs == 0) and 0 or 1
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    corner(indicator, 2)
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self.Color
    page.ScrollBarImageTransparency = 0.5
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (#self.Tabs == 0)
    page.Parent = self.ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = page
    
    local function updateCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()
    
    local tabObj = {
        Title = config.Title,
        Button = btn,
        Indicator = indicator,
        Page = page,
        Layout = layout,
        Window = self,
        Label = label
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
            tween(label, {TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabObj then
            tween(btn, {BackgroundTransparency = 1}, 0.15)
            tween(label, {TextColor3 = Color3.fromRGB(130, 130, 160)}, 0.15)
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
        tab.Button.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 180)
        tab.Label.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 160)
        tab.Button.BackgroundTransparency = active and 0.85 or 1
        tween(tab.Indicator, {
            Size = active and UDim2.new(0.6, 0, 0, 2) or UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = active and 0 or 1
        }, 0.25)
    end
    self.ActiveTab = tabObj
end

-- ======================================================
-- COMPONENTS
-- ======================================================

-- Tab Object để thêm components
local TabComponent = {}
TabComponent.__index = TabComponent

function Window:GetTabObject(tab)
    local obj = setmetatable({}, TabComponent)
    obj.Window = self
    obj.Page = tab.Page
    obj.Layout = tab.Layout
    return obj
end

-- ======================================================
-- SECTION
-- ======================================================
function TabComponent:AddSection(config)
    config = config or {}
    local win = self.Window
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(25, 25, 42)
    section.BackgroundTransparency = 0.3
    section.BorderSizePixel = 0
    section.ClipsDescendants = true
    section.Parent = self.Page
    corner(section, 12)
    stroke(section, win.Color, 1, 0.6)
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = win.Color
    header.BackgroundTransparency = 0.7
    header.BorderSizePixel = 0
    header.Parent = section
    corner(header, 12)
    
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 14, 0, 0)
    title.Size = UDim2.new(1, -28, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title or "Section"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Body
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 10, 0, 42)
    body.Size = UDim2.new(1, -20, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = section
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = body
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = section
    
    return {
        Body = body,
        Layout = layout,
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
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = win.Color
    btn.BackgroundTransparency = 0.7
    btn.Text = config.Icon and (config.Icon .. " " .. config.Text) or config.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.AutoButtonColor = false
    btn.Parent = self.Page
    corner(btn, 10)
    stroke(btn, win.Color, 1, 0.5)
    
    -- Glow effect on hover
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.2}, 0.15)
        tween(btn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.7}, 0.15)
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Click effect
        tween(btn, {Size = UDim2.new(1, 0, 0, 36)}, 0.08)
        task.delay(0.08, function()
            tween(btn, {Size = UDim2.new(1, 0, 0, 40)}, 0.08)
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
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 10)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Text = config.Text or "Toggle"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Position = UDim2.new(1, -56, 0.5, -12)
    switch.BackgroundColor3 = state and win.Color or Color3.fromRGB(50, 50, 75)
    switch.BorderSizePixel = 0
    switch.Parent = holder
    corner(switch, 12)
    stroke(switch, win.Color, 1, state and 0.3 or 0.6)
    
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
            BackgroundColor3 = v and win.Color or Color3.fromRGB(50, 50, 75)
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
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 10)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 4)
    label.Size = UDim2.new(1, -80, 0, 16)
    label.Text = config.Text or "Slider"
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -60, 0, 4)
    valueLabel.Size = UDim2.new(0, 48, 0, 16)
    valueLabel.Text = tostring(val)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = win.Color
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
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = win.Color
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)
    
    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 8)
    stroke(knob, win.Color, 2, 0.2)
    
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
    track.InputEnded:Connect(function() dragging = false end)
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
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    holder.BackgroundTransparency = 0.5
    holder.ClipsDescendants = true
    holder.Parent = self.Page
    corner(holder, 10)
    
    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, 40)
    main.BackgroundTransparency = 1
    main.Text = "  " .. current
    main.Font = Enum.Font.Gotham
    main.TextSize = 13
    main.TextColor3 = Color3.fromRGB(220, 220, 240)
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.AutoButtonColor = false
    main.Parent = holder
    
    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 24, 0, 40)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = win.Color
    arrow.TextSize = 14
    arrow.Parent = holder
    
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Position = UDim2.new(0, 0, 0, 40)
    dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
    dropdown.BackgroundTransparency = 0.3
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
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    holder.BackgroundTransparency = 0.5
    holder.Parent = self.Page
    corner(holder, 10)
    
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
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = holder
    
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.5, 0, 0, 2)
    underline.Position = UDim2.new(0.5, -0.25, 1, -2)
    underline.BackgroundColor3 = win.Color
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
-- NOTIFICATION
-- ======================================================
function Window:Notify(config)
    config = config or {}
    
    local notif = Instance.new("Frame")
    notif.AnchorPoint = Vector2.new(1, 1)
    notif.Position = UDim2.new(1, -16, 1, -16)
    notif.Size = UDim2.new(0, 300, 0, 0)
    notif.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.ZIndex = 50
    notif.Parent = self.ScreenGui
    corner(notif, 12)
    stroke(notif, self.Color, 1, 0.5)
    
    -- Color bar
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = config.Type == "Success" and Color3.fromRGB(80, 220, 120) or
                           config.Type == "Warning" and Color3.fromRGB(255, 200, 80) or
                           self.Color
    bar.BorderSizePixel = 0
    bar.Parent = notif
    corner(bar, 12)
    
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 18, 0, 12)
    title.Size = UDim2.new(1, -28, 0, 18)
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title or "Notification"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notif
    
    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 18, 0, 34)
    body.Size = UDim2.new(1, -28, 0, 0)
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
    tween(notif, {Size = UDim2.new(0, 300, 0, height)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(config.Duration or 3, function()
        tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 0)}, 0.2)
        task.delay(0.25, function() notif:Destroy() end)
    end)
end

-- ======================================================
-- LIBRARY
-- ======================================================
local Library = {}

function Library:CreateWindow(config)
    return Window.new(config)
end

return Library