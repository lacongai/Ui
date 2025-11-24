-- ui.lua
local Save = require(game.ReplicatedStorage:WaitForChild("save"))
local Notify = require(game.ReplicatedStorage:WaitForChild("notify"))

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local UI = {}
local Settings = Save:Read() -- Load settings từ save.lua

function UI:CreateWindow(title, version)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUI"
    ScreenGui.Parent = LP.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Size = UDim2.new(0, 520, 0, 420)
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = MainFrame
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title.." | "..version
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold

    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = MainFrame
    TabHolder.Size = UDim2.new(0, 140, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0,8)

    local PageHolder = Instance.new("Frame")
    PageHolder.Parent = MainFrame
    PageHolder.Size = UDim2.new(1, -150, 1, -50)
    PageHolder.Position = UDim2.new(0, 150, 0, 45)
    PageHolder.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", PageHolder).CornerRadius = UDim.new(0,8)

    local Window = {Main = MainFrame, Tabs = {}, TabHolder = TabHolder, PageHolder = PageHolder}

    function Window:AddTab(data)
        local Title = data.Title or "Tab"
        local Icon = data.Icon or ""

        local Btn = Instance.new("TextButton")
        Btn.Parent = TabHolder
        Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Btn.Size = UDim2.new(1, -10, 0, 45)
        Btn.Position = UDim2.new(0, 5, 0, (#Window.Tabs*50 + 5))
        Btn.Text = ""
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        local I = Instance.new("ImageLabel")
        I.Parent = Btn
        I.Size = UDim2.new(0,28,0,28)
        I.Position = UDim2.new(0,8,0.5,-14)
        I.BackgroundTransparency = 1
        if Icon:find("rbxassetid") then
            I.Image = Icon
        else
            local icons = {home="rbxassetid://4483345998", settings="rbxassetid://3926307971", info="rbxassetid://4483345998"}
            I.Image = icons[Icon] or ""
        end

        local T = Instance.new("TextLabel")
        T.Parent = Btn
        T.Size = UDim2.new(1,-40,1,0)
        T.Position = UDim2.new(0,40,0,0)
        T.Text = Title
        T.TextColor3 = Color3.new(1,1,1)
        T.BackgroundTransparency = 1
        T.TextSize = 16
        T.Font = Enum.Font.GothamMedium

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = PageHolder
        Page.Size = UDim2.new(1,0,1,0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0,0,0,0)

        table.insert(Window.Tabs,{Btn=Btn,Page=Page})

        Btn.MouseButton1Click:Connect(function()
            for _,t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            end
            Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            Page.Visible = true
        end)

        -- Return Section API
        local SectionAPI = {}

        function SectionAPI:AddToggle(name, default, callback)
            local key = "toggle_"..name
            if Settings[key] == nil then Settings[key] = default end

            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1,-20,0,35)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Frame.Position = UDim2.new(0,10,0,#Page:GetChildren()*40)
            Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.Text = name
            Label.TextColor3 = Color3.new(1,1,1)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 16

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0.25,0,0.7,0)
            Btn.Position = UDim2.new(0.7,5,0.15,0)
            Btn.Text = Settings[key] and "ON" or "OFF"
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,200,0) or Color3.fromRGB(180,0,0)
            Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,6)

            Btn.MouseButton1Click:Connect(function()
                Settings[key] = not Settings[key]
                Btn.Text = Settings[key] and "ON" or "OFF"
                Btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,200,0) or Color3.fromRGB(180,0,0)
                Save:Write(Settings)
                if callback then callback(Settings[key]) end
                Notify(name.." changed: "..tostring(Settings[key]))
            end)

            -- Auto load
            if callback then callback(Settings[key]) end
        end

        function SectionAPI:AddDropdown(name, options, default, callback)
            local key = "dropdown_"..name
            if Settings[key] == nil then Settings[key] = default or options[1] end

            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1,-20,0,40)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Frame.Position = UDim2.new(0,10,0,#Page:GetChildren()*45)
            Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.6,0,1,0)
            Label.Text = name..": "..Settings[key]
            Label.TextColor3 = Color3.new(1,1,1)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 15

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0.35,0,0.7,0)
            Btn.Position = UDim2.new(0.6,5,0.15,0)
            Btn.Text = "▼"
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
            Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,6)

            Btn.MouseButton1Click:Connect(function()
                for _,v in ipairs(Frame:GetChildren()) do
                    if v:IsA("TextButton") and v ~= Btn then v:Destroy() end
                end
                local y = 35
                for _,opt in ipairs(options) do
                    local Item = Instance.new("TextButton")
                    Item.Parent = Frame
                    Item.Size = UDim2.new(1,0,0,25)
                    Item.Position = UDim2.new(0,0,0,y)
                    Item.Text = opt
                    Item.BackgroundColor3 = Color3.fromRGB(30,30,30)
                    Item.TextColor3 = Color3.new(1,1,1)
                    Item.Font = Enum.Font.Gotham
                    Item.TextSize = 14
                    Instance.new("UICorner",Item).CornerRadius = UDim.new(0,4)
                    y=y+28

                    Item.MouseButton1Click:Connect(function()
                        Settings[key] = opt
                        Label.Text = name..": "..opt
                        Save:Write(Settings)
                        if callback then callback(opt) end
                        Item.Parent:ClearAllChildren()
                    end)
                end
            end)

            if callback then callback(Settings[key]) end
        end

        function SectionAPI:AddSlider(name, min, max, default, callback)
            local key = "slider_"..name
            if Settings[key] == nil then Settings[key] = default or min end

            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1,-20,0,50)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Frame.Position = UDim2.new(0,10,0,#Page:GetChildren()*55)
            Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(1,0,0,20)
            Label.Text = name..": "..Settings[key]
            Label.TextColor3 = Color3.new(1,1,1)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 15

            local SliderFrame = Instance.new("Frame", Frame)
            SliderFrame.Size = UDim2.new(1,-20,0,15)
            SliderFrame.Position = UDim2.new(0,10,0,25)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
            local Fill = Instance.new("Frame", SliderFrame)
            Fill.Size = UDim2.new((Settings[key]-min)/(max-min),0,1,0)
            Fill.BackgroundColor3 = Color3.fromRGB(0,120,255)

            local dragging = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            SliderFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X)/SliderFrame.AbsoluteSize.X,0,1)
                    local val = math.floor(min + (max-min)*pct)
                    Settings[key] = val
                    Fill.Size = UDim2.new(pct,0,1,0)
                    Label.Text = name..": "..val
                    Save:Write(Settings)
                    if callback then callback(val) end
                end
            end)
            if callback then callback(Settings[key]) end
        end

        return SectionAPI
    end

    -- Nút ẩn/hiện UI
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.Size = UDim2.new(0,65,0,65)
    ToggleBtn.Position = UDim2.new(0.05,0,0.25,0)
    ToggleBtn.Image = "rbxassetid://16105711875"

    local corner = Instance.new("UICorner", ToggleBtn)
    corner.CornerRadius = UDim.new(1,0) -- tròn 100%
    --corner.CornerRadius = UDim.new(0,14) -- vuông bo góc

    local UIShown = true
    ToggleBtn.MouseButton1Click:Connect(function()
        UIShown = not UIShown
        MainFrame.Visible = UIShown
    end)

    Notify("UI Loaded!")
    return Window
end

return UI