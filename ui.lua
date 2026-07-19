-- Roblox 可配置 UI 库 v2.0 (修复版)
-- 使用方法: local UI = loadstring(game:HttpGet("你的链接"))()

return function()
    -- 错误处理包装
    local success, result = pcall(function()
        -- 等待必要的服务
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        
        local player = Players.LocalPlayer
        if not player then
            error("无法找到本地玩家")
        end
        
        local playerGui = player:WaitForChild("PlayerGui")
        
        -- 全局配置
        local UIConfig = {
            WindowTitle = "自定义窗口",
            Width = 400,
            Height = 350,
            PrimaryColor = Color3.fromRGB(35, 35, 45),
            SecondaryColor = Color3.fromRGB(50, 50, 65),
            AccentColor = Color3.fromRGB(100, 150, 255),
            TextColor = Color3.fromRGB(255, 255, 255),
            TabTextColor = Color3.fromRGB(180, 180, 200),
            SelectedTabColor = Color3.fromRGB(100, 150, 255),
            SectionTextColor = Color3.fromRGB(150, 150, 170),
            CornerRadius = 8,
            TitleBarHeight = 35,
            TabHeight = 40,
            Draggable = true,
            Minimizable = true
        }

        -- 创建 ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomUILibrary_" .. math.random(1000, 9999)
        screenGui.Parent = playerGui
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        -- 主窗口
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainWindow"
        mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.Height)
        mainFrame.Position = UDim2.new(0.5, -UIConfig.Width/2, 0.5, -UIConfig.Height/2)
        mainFrame.BackgroundColor3 = UIConfig.PrimaryColor
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = screenGui

        -- 窗口圆角
        local windowCorner = Instance.new("UICorner")
        windowCorner.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
        windowCorner.Parent = mainFrame

        -- 窗口边框
        local windowStroke = Instance.new("UIStroke")
        windowStroke.Color = UIConfig.AccentColor
        windowStroke.Thickness = 1.5
        windowStroke.Transparency = 0.4
        windowStroke.Parent = mainFrame

        -- 标题栏
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, UIConfig.TitleBarHeight)
        titleBar.BackgroundColor3 = UIConfig.SecondaryColor
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame

        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
        titleCorner.Parent = titleBar

        -- 标题文字
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = UIConfig.WindowTitle
        titleLabel.TextColor3 = UIConfig.TextColor
        titleLabel.TextSize = 15
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

        -- 最小化按钮
        local minimizeButton = Instance.new("TextButton")
        minimizeButton.Name = "MinimizeButton"
        minimizeButton.Size = UDim2.new(0, 30, 0, 30)
        minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
        minimizeButton.BackgroundColor3 = UIConfig.AccentColor
        minimizeButton.Text = "—"
        minimizeButton.TextColor3 = UIConfig.TextColor
        minimizeButton.TextSize = 18
        minimizeButton.Font = Enum.Font.GothamBold
        minimizeButton.BorderSizePixel = 0
        minimizeButton.Parent = titleBar

        local minimizeCorner = Instance.new("UICorner")
        minimizeCorner.CornerRadius = UDim.new(0, 4)
        minimizeCorner.Parent = minimizeButton

        local isMinimized = false
        minimizeButton.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            if isMinimized then
                mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.TitleBarHeight)
            else
                mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.Height)
            end
        end)

        -- 关闭按钮
        local closeButton = Instance.new("TextButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -35, 0.5, -15)
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        closeButton.Text = "✕"
        closeButton.TextColor3 = UIConfig.TextColor
        closeButton.TextSize = 16
        closeButton.Font = Enum.Font.GothamBold
        closeButton.BorderSizePixel = 0
        closeButton.Parent = titleBar

        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 4)
        closeCorner.Parent = closeButton

        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

        -- 标签栏容器
        local tabContainer = Instance.new("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2.new(0, 120, 1, -UIConfig.TitleBarHeight)
        tabContainer.Position = UDim2.new(0, 0, 0, UIConfig.TitleBarHeight)
        tabContainer.BackgroundColor3 = UIConfig.SecondaryColor
        tabContainer.BorderSizePixel = 0
        tabContainer.Parent = mainFrame

        local tabList = Instance.new("UIListLayout")
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 2)
        tabList.Parent = tabContainer

        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingTop = UDim.new(0, 5)
        tabPadding.PaddingLeft = UDim.new(0, 5)
        tabPadding.PaddingRight = UDim.new(0, 5)
        tabPadding.Parent = tabContainer

        -- 内容区域
        local contentArea = Instance.new("Frame")
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, -125, 1, -UIConfig.TitleBarHeight - 5)
        contentArea.Position = UDim2.new(0, 125, 0, UIConfig.TitleBarHeight)
        contentArea.BackgroundColor3 = UIConfig.PrimaryColor
        contentArea.BorderSizePixel = 0
        contentArea.ClipsDescendants = true
        contentArea.Parent = mainFrame

        -- 滚动框架
        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Name = "ContentScroller"
        scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.ScrollBarThickness = 4
        scrollingFrame.ScrollBarImageColor3 = UIConfig.AccentColor
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollingFrame.Parent = contentArea

        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 5)
        contentList.Parent = scrollingFrame

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 5)
        contentPadding.PaddingRight = UDim.new(0, 5)
        contentPadding.Parent = scrollingFrame

        -- 存储标签和内容的表
        local tabs = {}
        local currentTab = nil
        local firstTab = nil

        -- 拖动功能
        if UIConfig.Draggable then
            local dragging = false
            local dragStart, frameStart

            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    frameStart = mainFrame.Position
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)

            titleBar.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    mainFrame.Position = UDim2.new(
                        frameStart.X.Scale,
                        frameStart.X.Offset + delta.X,
                        frameStart.Y.Scale,
                        frameStart.Y.Offset + delta.Y
                    )
                end
            end)
        end

        -- 更新所有视觉元素
        function updateVisuals()
            mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, isMinimized and UIConfig.TitleBarHeight or UIConfig.Height)
            mainFrame.BackgroundColor3 = UIConfig.PrimaryColor
            titleBar.BackgroundColor3 = UIConfig.SecondaryColor
            tabContainer.BackgroundColor3 = UIConfig.SecondaryColor
            contentArea.BackgroundColor3 = UIConfig.PrimaryColor
            windowStroke.Color = UIConfig.AccentColor
            titleLabel.TextColor3 = UIConfig.TextColor
            titleLabel.Text = UIConfig.WindowTitle
            minimizeButton.BackgroundColor3 = UIConfig.AccentColor
            scrollingFrame.ScrollBarImageColor3 = UIConfig.AccentColor
            
            windowCorner.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
            titleCorner.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
            
            -- 更新标签颜色
            for _, tab in pairs(tabs) do
                if tab == currentTab then
                    tab.button.BackgroundColor3 = UIConfig.AccentColor
                    tab.button.TextColor3 = UIConfig.TextColor
                else
                    tab.button.BackgroundColor3 = UIConfig.SecondaryColor
                    tab.button.TextColor3 = UIConfig.TabTextColor
                end
            end
        end

        -- Window 对象
        local Window = {}
        
        -- 添加标签页
        function Window:AddTab(config)
            local tabConfig = config or {}
            local tabName = tabConfig.Title or "Tab"
            local tabIcon = tabConfig.Icon or ""
            
            local tabButton = Instance.new("TextButton")
            tabButton.Name = tabName .. "Tab"
            tabButton.Size = UDim2.new(1, -10, 0, UIConfig.TabHeight)
            tabButton.BackgroundColor3 = UIConfig.SecondaryColor
            tabButton.Text = ""
            tabButton.BorderSizePixel = 0
            tabButton.Parent = tabContainer
            tabButton.ZIndex = 2

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = tabButton

            -- 图标
            if tabIcon ~= "" then
                local iconImage = Instance.new("ImageLabel")
                iconImage.Name = "Icon"
                iconImage.Size = UDim2.new(0, 24, 0, 24)
                iconImage.Position = UDim2.new(0, 10, 0.5, -12)
                iconImage.BackgroundTransparency = 1
                iconImage.Image = tabIcon
                iconImage.Parent = tabButton
            end

            -- 标签文字
            local tabText = Instance.new("TextLabel")
            tabText.Size = UDim2.new(1, -15, 1, 0)
            tabText.Position = UDim2.new(0, tabIcon ~= "" and 40 or 10, 0, 0)
            tabText.BackgroundTransparency = 1
            tabText.Text = tabName
            tabText.TextColor3 = UIConfig.TabTextColor
            tabText.TextSize = 13
            tabText.Font = Enum.Font.GothamMedium
            tabText.TextXAlignment = Enum.TextXAlignment.Left
            tabText.Parent = tabButton

            -- 标签内容容器
            local tabContent = Instance.new("Frame")
            tabContent.Name = tabName .. "Content"
            tabContent.Size = UDim2.new(1, 0, 1, 0)
            tabContent.BackgroundTransparency = 1
            tabContent.Visible = false
            tabContent.Parent = scrollingFrame

            local tabContentList = Instance.new("UIListLayout")
            tabContentList.SortOrder = Enum.SortOrder.LayoutOrder
            tabContentList.Padding = UDim.new(0, 5)
            tabContentList.Parent = tabContent

            local tabData = {
                button = tabButton,
                content = tabContent,
                name = tabName
            }

            table.insert(tabs, tabData)
            
            if not firstTab then
                firstTab = tabData
                currentTab = tabData
                tabContent.Visible = true
                tabButton.BackgroundColor3 = UIConfig.AccentColor
                tabButton.TextColor3 = UIConfig.TextColor
            end

            -- 点击切换标签
            tabButton.MouseButton1Click:Connect(function()
                if currentTab then
                    currentTab.content.Visible = false
                    currentTab.button.BackgroundColor3 = UIConfig.SecondaryColor
                    currentTab.button.TextColor3 = UIConfig.TabTextColor
                end
                
                currentTab = tabData
                tabContent.Visible = true
                tabButton.BackgroundColor3 = UIConfig.AccentColor
                tabButton.TextColor3 = UIConfig.TextColor
            end)

            -- 返回 Tab 对象
            local Tab = {}
            
            -- 添加分区
            function Tab:AddSection(sectionName)
                local sectionFrame = Instance.new("Frame")
                sectionFrame.Name = sectionName .. "Section"
                sectionFrame.Size = UDim2.new(1, -10, 0, 30)
                sectionFrame.BackgroundTransparency = 1
                sectionFrame.Parent = tabContent

                local sectionLabel = Instance.new("TextLabel")
                sectionLabel.Size = UDim2.new(1, 0, 1, 0)
                sectionLabel.BackgroundTransparency = 1
                sectionLabel.Text = sectionName
                sectionLabel.TextColor3 = UIConfig.SectionTextColor
                sectionLabel.TextSize = 14
                sectionLabel.Font = Enum.Font.GothamBold
                sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
                sectionLabel.Parent = sectionFrame

                local sectionDivider = Instance.new("Frame")
                sectionDivider.Size = UDim2.new(1, 0, 0, 1)
                sectionDivider.Position = UDim2.new(0, 0, 1, 3)
                sectionDivider.BackgroundColor3 = UIConfig.AccentColor
                sectionDivider.BorderSizePixel = 0
                sectionDivider.BackgroundTransparency = 0.5
                sectionDivider.Parent = sectionFrame

                local Section = {}
                
                -- 添加按钮
                function Section:AddButton(config)
                    local buttonConfig = config or {}
                    local btnText = buttonConfig.Title or "Button"
                    local callback = buttonConfig.Callback or function() end
                    
                    local button = Instance.new("TextButton")
                    button.Name = btnText .. "Button"
                    button.Size = UDim2.new(1, 0, 0, 35)
                    button.BackgroundColor3 = UIConfig.AccentColor
                    button.Text = btnText
                    button.TextColor3 = UIConfig.TextColor
                    button.TextSize = 13
                    button.Font = Enum.Font.GothamMedium
                    button.BorderSizePixel = 0
                    button.Parent = tabContent

                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(0, 5)
                    btnCorner.Parent = button

                    button.MouseButton1Click:Connect(function()
                        pcall(callback)
                    end)
                    
                    return button
                end

                -- 添加标签
                function Section:AddLabel(config)
                    local labelConfig = config or {}
                    local labelText = labelConfig.Title or "Label"
                    
                    local label = Instance.new("TextLabel")
                    label.Name = labelText .. "Label"
                    label.Size = UDim2.new(1, 0, 0, 25)
                    label.BackgroundTransparency = 1
                    label.Text = labelText
                    label.TextColor3 = UIConfig.TextColor
                    label.TextSize = 13
                    label.Font = Enum.Font.Gotham
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = tabContent
                    
                    return label
                end

                -- 添加开关
                function Section:AddToggle(config)
                    local toggleConfig = config or {}
                    local toggleTitle = toggleConfig.Title or "Toggle"
                    local default = toggleConfig.Default or false
                    local callback = toggleConfig.Callback or function() end
                    
                    local toggleFrame = Instance.new("Frame")
                    toggleFrame.Name = toggleTitle .. "Toggle"
                    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
                    toggleFrame.BackgroundTransparency = 1
                    toggleFrame.Parent = tabContent

                    local toggleLabel = Instance.new("TextLabel")
                    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                    toggleLabel.BackgroundTransparency = 1
                    toggleLabel.Text = toggleTitle
                    toggleLabel.TextColor3 = UIConfig.TextColor
                    toggleLabel.TextSize = 13
                    toggleLabel.Font = Enum.Font.Gotham
                    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    toggleLabel.Parent = toggleFrame

                    local toggleButton = Instance.new("TextButton")
                    toggleButton.Size = UDim2.new(0, 45, 0, 20)
                    toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                    toggleButton.BackgroundColor3 = default and UIConfig.AccentColor or Color3.fromRGB(60, 60, 75)
                    toggleButton.Text = ""
                    toggleButton.BorderSizePixel = 0
                    toggleButton.Parent = toggleFrame

                    local toggleCorner = Instance.new("UICorner")
                    toggleCorner.CornerRadius = UDim.new(1, 0)
                    toggleCorner.Parent = toggleButton

                    local toggleDot = Instance.new("Frame")
                    toggleDot.Size = UDim2.new(0, 16, 0, 16)
                    toggleDot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    toggleDot.BorderSizePixel = 0
                    toggleDot.Parent = toggleButton

                    local dotCorner = Instance.new("UICorner")
                    dotCorner.CornerRadius = UDim.new(1, 0)
                    dotCorner.Parent = toggleDot

                    local toggled = default
                    toggleButton.MouseButton1Click:Connect(function()
                        toggled = not toggled
                        toggleButton.BackgroundColor3 = toggled and UIConfig.AccentColor or Color3.fromRGB(60, 60, 75)
                        toggleDot:TweenPosition(
                            toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                            "Out",
                            "Quad",
                            0.15
                        )
                        pcall(callback, toggled)
                    end)
                    
                    return toggleFrame
                end

                -- 添加滑动条
                function Section:AddSlider(config)
                    local sliderConfig = config or {}
                    local sliderTitle = sliderConfig.Title or "Slider"
                    local min = sliderConfig.Min or 0
                    local max = sliderConfig.Max or 100
                    local default = sliderConfig.Default or 50
                    local callback = sliderConfig.Callback or function() end
                    
                    local sliderFrame = Instance.new("Frame")
                    sliderFrame.Name = sliderTitle .. "Slider"
                    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                    sliderFrame.BackgroundTransparency = 1
                    sliderFrame.Parent = tabContent

                    local sliderLabel = Instance.new("TextLabel")
                    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                    sliderLabel.BackgroundTransparency = 1
                    sliderLabel.Text = sliderTitle .. ": " .. default
                    sliderLabel.TextColor3 = UIConfig.TextColor
                    sliderLabel.TextSize = 12
                    sliderLabel.Font = Enum.Font.Gotham
                    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    sliderLabel.Parent = sliderFrame

                    local sliderBar = Instance.new("Frame")
                    sliderBar.Size = UDim2.new(1, -10, 0, 6)
                    sliderBar.Position = UDim2.new(0, 5, 0, 28)
                    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                    sliderBar.BorderSizePixel = 0
                    sliderBar.Parent = sliderFrame

                    local barCorner = Instance.new("UICorner")
                    barCorner.CornerRadius = UDim.new(1, 0)
                    barCorner.Parent = sliderBar

                    local sliderFill = Instance.new("Frame")
                    local initPercent = (default - min) / (max - min)
                    sliderFill.Size = UDim2.new(initPercent, 0, 1, 0)
                    sliderFill.BackgroundColor3 = UIConfig.AccentColor
                    sliderFill.BorderSizePixel = 0
                    sliderFill.Parent = sliderBar

                    local fillCorner = Instance.new("UICorner")
                    fillCorner.CornerRadius = UDim.new(1, 0)
                    fillCorner.Parent = sliderFill

                    local sliderButton = Instance.new("TextButton")
                    sliderButton.Size = UDim2.new(0, 16, 0, 16)
                    sliderButton.Position = UDim2.new(initPercent, -8, 0.5, -8)
                    sliderButton.BackgroundColor3 = UIConfig.AccentColor
                    sliderButton.Text = ""
                    sliderButton.BorderSizePixel = 0
                    sliderButton.Parent = sliderBar

                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(1, 0)
                    btnCorner.Parent = sliderButton

                    local function updateSlider(percent)
                        local value = math.floor(min + (max - min) * percent)
                        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        sliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
                        sliderLabel.Text = sliderTitle .. ": " .. value
                        pcall(callback, value)
                    end

                    local isDraggingSlider = false
                    
                    sliderButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            isDraggingSlider = true
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            isDraggingSlider = false
                        end
                    end)

                    sliderBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local mousePos = input.Position.X
                            local barAbsPos = sliderBar.AbsolutePosition.X
                            local barWidth = sliderBar.AbsoluteSize.X
                            local percent = math.clamp((mousePos - barAbsPos) / barWidth, 0, 1)
                            updateSlider(percent)
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local mousePos = input.Position.X
                            local barAbsPos = sliderBar.AbsolutePosition.X
                            local barWidth = sliderBar.AbsoluteSize.X
                            local percent = math.clamp((mousePos - barAbsPos) / barWidth, 0, 1)
                            updateSlider(percent)
                        end
                    end)
                    
                    return sliderFrame
                end

                return Section
            end
            
            return Tab
        end

        -- 配置窗口属性
        function Window:Configure(config)
            if config.Title then UIConfig.WindowTitle = config.Title end
            if config.Width then UIConfig.Width = config.Width end
            if config.Height then UIConfig.Height = config.Height end
            if config.PrimaryColor then UIConfig.PrimaryColor = config.PrimaryColor end
            if config.SecondaryColor then UIConfig.SecondaryColor = config.SecondaryColor end
            if config.AccentColor then UIConfig.AccentColor = config.AccentColor end
            if config.TextColor then UIConfig.TextColor = config.TextColor end
            if config.CornerRadius then UIConfig.CornerRadius = config.CornerRadius end
            updateVisuals()
        end

        -- 销毁窗口
        function Window:Destroy()
            screenGui:Destroy()
        end

        -- 隐藏窗口
        function Window:Hide()
            screenGui.Enabled = false
        end

        -- 显示窗口
        function Window:Show()
            screenGui.Enabled = true
        end

        -- 更新配置（外部调用）
        _G.UpdateUIConfig = function(newConfig)
            for k, v in pairs(newConfig) do
                if UIConfig[k] ~= nil then
                    UIConfig[k] = v
                end
            end
            updateVisuals()
        end

        return Window
    end)
    
    -- 错误处理
    if not success then
        warn("UI 库加载失败:", result)
        
        -- 创建一个简单的错误提示 GUI
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ErrorGUI"
        errorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        
        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 300, 0, 100)
        errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        errorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        errorFrame.Parent = errorGui
        
        local errorText = Instance.new("TextLabel")
        errorText.Size = UDim2.new(1, -20, 1, -20)
        errorText.Position = UDim2.new(0, 10, 0, 10)
        errorText.BackgroundTransparency = 1
        errorText.Text = "UI 加载失败:\n" .. tostring(result)
        errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorText.TextSize = 14
        errorText.Font = Enum.Font.Gotham
        errorText.TextWrapped = true
        errorText.Parent = errorFrame
        
        return nil
    end
    
    return result
end