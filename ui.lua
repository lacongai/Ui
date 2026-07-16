-- ============================================
--   UI Library Pro - Modern & Smooth Design
--   Tác giả: Roblox Script Hub
--   Version: 2.0
-- ============================================

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============================================
--   MÀU SẮC CHỦ ĐẠO
-- ============================================
local Themes = {
    Ocean = {
        Primary = Color3.fromRGB(0, 180, 255),
        Secondary = Color3.fromRGB(0, 100, 200),
        Background = Color3.fromRGB(10, 14, 23),
        Surface = Color3.fromRGB(20, 26, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 160, 180),
        Accent = Color3.fromRGB(0, 220, 255),
    },
    Sunset = {
        Primary = Color3.fromRGB(255, 100, 80),
        Secondary = Color3.fromRGB(200, 50, 100),
        Background = Color3.fromRGB(20, 10, 20),
        Surface = Color3.fromRGB(35, 20, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 150, 160),
        Accent = Color3.fromRGB(255, 180, 50),
    },
    Forest = {
        Primary = Color3.fromRGB(50, 220, 100),
        Secondary = Color3.fromRGB(30, 160, 70),
        Background = Color3.fromRGB(8, 20, 12),
        Surface = Color3.fromRGB(18, 35, 22),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(140, 180, 150),
        Accent = Color3.fromRGB(100, 255, 150),
    },
    Purple = {
        Primary = Color3.fromRGB(160, 80, 255),
        Secondary = Color3.fromRGB(100, 40, 200),
        Background = Color3.fromRGB(15, 8, 25),
        Surface = Color3.fromRGB(28, 18, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(170, 150, 190),
        Accent = Color3.fromRGB(200, 130, 255),
    },
    Dark = {
        Primary = Color3.fromRGB(200, 200, 210),
        Secondary = Color3.fromRGB(100, 100, 120),
        Background = Color3.fromRGB(8, 8, 10),
        Surface = Color3.fromRGB(18, 18, 22),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(130, 130, 145),
        Accent = Color3.fromRGB(220, 220, 235),
    }
}

local CurrentTheme = Themes.Ocean

-- ============================================
--   HÀM TIỆN ÍCH
-- ============================================
local function CreateRipple(parent, color)
    local Ripple = Instance.new("Frame")
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    Ripple.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    Ripple.BackgroundTransparency = 0.7
    Ripple.ClipsDescendants = true
    Ripple.BorderSizePixel = 0
    Ripple.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Ripple
    
    TweenService:Create(Ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1,
    }):Play()
    
    game:GetService("Debris"):AddItem(Ripple, 0.6)
end

local function CreateGlow(parent, color, size)
    local Glow = Instance.new("ImageLabel")
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1, size or 40, 1, size or 40)
    Glow.Position = UDim2.new(0.5, -(size or 40)/2, 0.5, -(size or 40)/2)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://6014261993"
    Glow.ImageColor3 = color or CurrentTheme.Primary
    Glow.ImageTransparency = 0.8
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(99, 99, 99, 99)
    Glow.Parent = parent
    return Glow
end

-- ============================================
--   TẠO WINDOW CHÍNH
-- ============================================
function UILibrary:CreateWindow(title, subtitle, theme)
    title = title or "UI Library"
    subtitle = subtitle or "Modern Interface"
    CurrentTheme = Themes[theme] or Themes.Ocean
    local Theme = CurrentTheme
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibraryPro"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Window Frame
    local Window = Instance.new("Frame")
    Window.Name = "MainWindow"
    Window.BackgroundColor3 = Theme.Background
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0.5, -225, 0.5, -175)
    Window.Size = UDim2.new(0, 0, 0, 0)
    Window.ClipsDescendants = true
    Window.Parent = ScreenGui
    
    -- Window Corner
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 16)
    WindowCorner.Parent = Window
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.Position = UDim2.new(0.5, -30, 0.5, -30)
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Theme.Primary
    Shadow.ImageTransparency = 0.85
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.Parent = Window
    Shadow.ZIndex = 0
    
    -- ============================================
    --   HEADER
    -- ============================================
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = Theme.Surface
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.Parent = Window
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 12)
    TitleLabel.Size = UDim2.new(1, -80, 0, 24)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(0, 20, 0, 38)
    SubLabel.Size = UDim2.new(1, -80, 0, 16)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Theme.TextDim
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = Header
    
    -- Accent Line
    local AccentLine = Instance.new("Frame")
    AccentLine.BackgroundColor3 = Theme.Primary
    AccentLine.BorderSizePixel = 0
    AccentLine.Position = UDim2.new(0, 20, 1, -2)
    AccentLine.Size = UDim2.new(0.3, 0, 0, 2)
    AccentLine.Parent = Header
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = Theme.Surface
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -14)
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.TextDim
    CloseBtn.TextSize = 14
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Surface}):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Window, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.BackgroundColor3 = Theme.Surface
    MinBtn.BorderSizePixel = 0
    MinBtn.Position = UDim2.new(1, -82, 0.5, -14)
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme.TextDim
    MinBtn.TextSize = 18
    MinBtn.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinBtn
    
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(Window, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 70)}):Play()
        else
            TweenService:Create(Window, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 350)}):Play()
        end
    end)
    
    -- Drag
    local DragArea = Instance.new("Frame")
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, -120, 1, 0)
    DragArea.Parent = Header
    
    local dragging = false
    local dragStart = nil
    local frameStart = nil
    
    DragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = Window.Position
        end
    end)
    DragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, 
                                        frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
        end
    end)
    
    -- ============================================
    --   TAB BAR
    -- ============================================
    local TabBar = Instance.new("Frame")
    TabBar.BackgroundColor3 = Theme.Background
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 70)
    TabBar.Size = UDim2.new(1, 0, 0, 42)
    TabBar.Parent = Window
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 0)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar
    
    -- ============================================
    --   CONTENT AREA
    -- ============================================
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundColor3 = Theme.Background
    ContentArea.BackgroundTransparency = 0
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 0, 0, 112)
    ContentArea.Size = UDim2.new(1, 0, 1, -112)
    ContentArea.ScrollBarThickness = 4
    ContentArea.ScrollBarImageColor3 = Theme.Primary
    ContentArea.ScrollBarImageTransparency = 0.5
    ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentArea.Parent = Window
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 12)
    ContentPadding.PaddingLeft = UDim.new(0, 12)
    ContentPadding.PaddingRight = UDim.new(0, 12)
    ContentPadding.PaddingBottom = UDim.new(0, 12)
    ContentPadding.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = ContentArea
    
    -- ============================================
    --   ANIMATION OPEN
    -- ============================================
    TweenService:Create(Window, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 350)
    }):Play()
    
    -- ============================================
    --   TẠO TAB
    -- ============================================
    local Tabs = {}
    local ActiveTab = nil
    
    function Tabs:AddTab(name, icon)
        name = name or "Tab"
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(0, 90, 1, 0)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = 12
        TabBtn.Parent = TabBar
        
        -- Indicator
        local Indicator = Instance.new("Frame")
        Indicator.BackgroundColor3 = Theme.Primary
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(0.3, 0, 1, -3)
        Indicator.Size = UDim2.new(0.4, 0, 0, 3)
        Indicator.Visible = false
        Indicator.Parent = TabBtn
        
        local TabContent = Instance.new("Frame")
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabContent
        
        TabBtn.MouseEnter:Connect(function()
            if not ActiveTab or ActiveTab ~= TabBtn then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not ActiveTab or ActiveTab ~= TabBtn then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play()
            end
        end)
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(TabBar:GetChildren()) do
                if child:IsA("TextButton") then
                    local ind = child:FindFirstChild("Indicator")
                    if ind then ind.Visible = false end
                    TweenService:Create(child, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play()
                end
            end
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("Frame") and child ~= ContentPadding and child ~= ContentLayout then
                    child.Visible = false
                end
            end
            Indicator.Visible = true
            TabContent.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
            ActiveTab = TabBtn
            -- Update canvas size
            wait(0.1)
            ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        if not ActiveTab then
            wait(0.1)
            TabBtn.MouseButton1Click:Fire()
        end
        
        -- ============================================
        --   TẠO SECTION
        -- ============================================
        local Sections = {}
        
        function Sections:AddSection(title)
            title = title or "Section"
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.BackgroundColor3 = Theme.Surface
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 14, 0, 8)
            SectionTitle.Size = UDim2.new(1, -28, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            -- Section Content
            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 32)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = SectionFrame
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 4)
            SectionContentLayout.Parent = SectionContent
            
            local function UpdateSectionHeight()
                local height = 32
                for _, child in pairs(SectionContent:GetChildren()) do
                    if child:IsA("Frame") and child.Visible then
                        height = height + child.AbsoluteSize.Y + 4
                    end
                end
                SectionFrame.Size = UDim2.new(1, 0, 0, height)
            end
            
            SectionContentLayout.Changed:Connect(function()
                UpdateSectionHeight()
                ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            end)
            
            -- ============================================
            --   TẠO TOGGLE
            -- ============================================
            local function CreateToggle(config)
                config = config or {}
                local name = config.Name or "Toggle"
                local desc = config.Description or ""
                local default = config.Default or false
                local callback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.BackgroundColor3 = Theme.Background
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
                ToggleFrame.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                if desc ~= "" then
                    ToggleLabel.Text = name .. " - " .. desc
                    ToggleLabel.TextSize = 11
                    ToggleLabel.TextColor3 = Theme.TextDim
                end
                
                local ToggleBtn = Instance.new("Frame")
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ToggleBtn.BorderSizePixel = 0
                ToggleBtn.Position = UDim2.new(1, -48, 0.5, -12)
                ToggleBtn.Size = UDim2.new(0, 36, 0, 24)
                ToggleBtn.Parent = ToggleFrame
                
                local ToggleCorner2 = Instance.new("UICorner")
                ToggleCorner2.CornerRadius = UDim.new(1, 0)
                ToggleCorner2.Parent = ToggleBtn
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
                ToggleDot.Size = UDim2.new(0, 16, 0, 16)
                ToggleDot.Parent = ToggleBtn
                
                local ToggleDotCorner = Instance.new("UICorner")
                ToggleDotCorner.CornerRadius = UDim.new(1, 0)
                ToggleDotCorner.Parent = ToggleDot
                
                local ClickBtn = Instance.new("TextButton")
                ClickBtn.BackgroundTransparency = 1
                ClickBtn.Size = UDim2.new(1, 0, 1, 0)
                ClickBtn.Text = ""
                ClickBtn.Parent = ToggleFrame
                
                local toggled = default
                
                local function UpdateToggle(state)
                    toggled = state
                    if toggled then
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary}):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -19, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }):Play()
                    else
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 3, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(160, 160, 170)
                        }):Play()
                    end
                    callback(toggled)
                end
                
                ClickBtn.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)
                
                UpdateToggle(default)
                
                return {
                    SetValue = function(_, state) UpdateToggle(state) end,
                    GetValue = function() return toggled end
                }
            end
            
            -- ============================================
            --   TẠO SLIDER
            -- ============================================
            local function CreateSlider(config)
                config = config or {}
                local name = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or 50
                local callback = config.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.BackgroundColor3 = Theme.Background
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 52)
                SliderFrame.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 12, 0, 6)
                SliderLabel.Size = UDim2.new(1, -80, 0, 16)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = name
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(1, -60, 0, 6)
                ValueLabel.Size = UDim2.new(0, 50, 0, 16)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Theme.Primary
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBg = Instance.new("Frame")
                SliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                SliderBg.BorderSizePixel = 0
                SliderBg.Position = UDim2.new(0, 12, 0, 30)
                SliderBg.Size = UDim2.new(1, -24, 0, 6)
                SliderBg.Parent = SliderFrame
                
                local SliderBgCorner = Instance.new("UICorner")
                SliderBgCorner.CornerRadius = UDim.new(1, 0)
                SliderBgCorner.Parent = SliderBg
                
                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = Theme.Primary
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderBg
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderThumb = Instance.new("Frame")
                SliderThumb.BackgroundColor3 = Theme.Primary
                SliderThumb.BorderSizePixel = 0
                SliderThumb.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
                SliderThumb.Size = UDim2.new(0, 16, 0, 16)
                SliderThumb.Parent = SliderBg
                
                local SliderThumbCorner = Instance.new("UICorner")
                SliderThumbCorner.CornerRadius = UDim.new(1, 0)
                SliderThumbCorner.Parent = SliderThumb
                
                local Glow = CreateGlow(SliderThumb, Theme.Primary, 30)
                Glow.ImageTransparency = 0.6
                
                local dragging = false
                local value = default
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    value = math.floor((min + (max - min) * pos) / 1 + 0.5) * 1
                    value = math.clamp(value, min, max)
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    SliderThumb.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end
                
                SliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                SliderThumb.InputBegan:Connect(function(input)
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
                
                return {
                    SetValue = function(_, v)
                        value = math.clamp(v, min, max)
                        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                        SliderThumb.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
                        ValueLabel.Text = tostring(value)
                        callback(value)
                    end,
                    GetValue = function() return value end
                }
            end
            
            -- ============================================
            --   TẠO BUTTON
            -- ============================================
            local function CreateButton(config)
                config = config or {}
                local name = config.Name or "Button"
                local desc = config.Description or ""
                local callback = config.Callback or function() end
                
                local BtnFrame = Instance.new("TextButton")
                BtnFrame.BackgroundColor3 = Theme.Primary
                BtnFrame.BackgroundTransparency = 0.85
                BtnFrame.BorderSizePixel = 0
                BtnFrame.Size = UDim2.new(1, 0, 0, 36)
                BtnFrame.Font = Enum.Font.GothamSemibold
                BtnFrame.Text = name
                BtnFrame.TextColor3 = Theme.Text
                BtnFrame.TextSize = 12
                BtnFrame.Parent = SectionContent
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = BtnFrame
                
                BtnFrame.MouseEnter:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
                end)
                BtnFrame.MouseLeave:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
                end)
                BtnFrame.MouseButton1Click:Connect(function()
                    CreateRipple(BtnFrame, Theme.Primary)
                    callback()
                end)
                
                return BtnFrame
            end
            
            -- ============================================
            --   TẠO DROPDOWN
            -- ============================================
            local function CreateDropdown(config)
                config = config or {}
                local name = config.Name or "Dropdown"
                local options = config.Options or {}
                local default = config.Default or options[1] or ""
                local callback = config.Callback or function() end
                
                local DropFrame = Instance.new("Frame")
                DropFrame.BackgroundColor3 = Theme.Background
                DropFrame.BorderSizePixel = 0
                DropFrame.Size = UDim2.new(1, 0, 0, 40)
                DropFrame.Parent = SectionContent
                
                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 8)
                DropCorner.Parent = DropFrame
                
                local DropLabel = Instance.new("TextLabel")
                DropLabel.BackgroundTransparency = 1
                DropLabel.Position = UDim2.new(0, 12, 0, 0)
                DropLabel.Size = UDim2.new(1, -50, 1, 0)
                DropLabel.Font = Enum.Font.Gotham
                DropLabel.Text = name
                DropLabel.TextColor3 = Theme.Text
                DropLabel.TextSize = 12
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropLabel.Parent = DropFrame
                
                local DropBtn = Instance.new("TextButton")
                DropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                DropBtn.BorderSizePixel = 0
                DropBtn.Position = UDim2.new(1, -120, 0.5, -14)
                DropBtn.Size = UDim2.new(0, 100, 0, 28)
                DropBtn.Font = Enum.Font.Gotham
                DropBtn.Text = tostring(default)
                DropBtn.TextColor3 = Theme.Text
                DropBtn.TextSize = 12
                DropBtn.Parent = DropFrame
                
                local DropBtnCorner = Instance.new("UICorner")
                DropBtnCorner.CornerRadius = UDim.new(0, 6)
                DropBtnCorner.Parent = DropBtn
                
                local DropArrow = Instance.new("TextLabel")
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -24, 0.5, -10)
                DropArrow.Size = UDim2.new(0, 20, 0, 20)
                DropArrow.Font = Enum.Font.GothamBold
                DropArrow.Text = "▼"
                DropArrow.TextColor3 = Theme.TextDim
                DropArrow.TextSize = 10
                DropArrow.Parent = DropBtn
                
                local DropList = Instance.new("Frame")
                DropList.BackgroundColor3 = Theme.Surface
                DropList.BorderSizePixel = 0
                DropList.Position = UDim2.new(0, 0, 1, 4)
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropList.ClipsDescendants = true
                DropList.Visible = false
                DropList.Parent = DropBtn
                
                local DropListCorner = Instance.new("UICorner")
                DropListCorner.CornerRadius = UDim.new(0, 6)
                DropListCorner.Parent = DropList
                
                local DropListLayout = Instance.new("UIListLayout")
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropListLayout.Padding = UDim.new(0, 2)
                DropListLayout.Parent = DropList
                
                local isOpen = false
                
                for _, item in ipairs(options) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Size = UDim2.new(1, 0, 0, 28)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = tostring(item)
                    ItemBtn.TextColor3 = Theme.TextDim
                    ItemBtn.TextSize = 11
                    ItemBtn.Parent = DropList
                    
                    ItemBtn.MouseEnter:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
                    end)
                    ItemBtn.MouseLeave:Connect(function()
                        TweenService:Create(ItemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
                    end)
                    ItemBtn.MouseButton1Click:Connect(function()
                        DropBtn.Text = tostring(item)
                        DropList.Visible = false
                        DropList.Size = UDim2.new(1, 0, 0, 0)
                        isOpen = false
                        callback(item)
                    end)
                end
                
                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        DropList.Visible = true
                        DropList.Size = UDim2.new(1, 0, 0, #options * 30)
                    else
                        DropList.Size = UDim2.new(1, 0, 0, 0)
                        wait(0.15)
                        DropList.Visible = false
                    end
                end)
                
                return {
                    SetValue = function(_, v)
                        DropBtn.Text = tostring(v)
                        callback(v)
                    end,
                    GetValue = function() return DropBtn.Text end
                }
            end
            
            return {
                Toggle = CreateToggle,
                Slider = CreateSlider,
                Button = CreateButton,
                Dropdown = CreateDropdown,
            }
        end
        
        return {
            AddSection = Sections.AddSection,
            Tab = TabBtn,
            Content = TabContent,
        }
    end
    
    return {
        AddTab = Tabs.AddTab,
        Window = Window,
        ScreenGui = ScreenGui,
        SetTheme = function(_, theme)
            CurrentTheme = Themes[theme] or Themes.Ocean
            -- Có thể thêm logic update theme tại đây
        end
    }
end

return UILibrary