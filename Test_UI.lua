-- =============================================================================
-- FULL SCRIPT: SECURITY LAB HUB (COMPLETE)
-- =============================================================================

local GUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lacongai/Ui/refs/heads/main/h.lua"))()
local Save = loadstring(game:HttpGet("https://raw.githubusercontent.com/lacongai/Ui/refs/heads/main/save.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/lacongai/Ui/refs/heads/main/notify.lua"))()


-- 1. Xử lý Save/Load
local SaveFile = Save.new("ui_settings.json")
local Config = {
    Aimbot = false,
    ESP = false,
    FOVColor = "Trắng", -- Lưu tên màu để load
    ESPColor = "Đỏ"
}

-- Load từ file
local loaded = SaveFile:Read()
if loaded and type(loaded) == "table" then
    for i, v in pairs(loaded) do Config[i] = v end
end

function SaveSettings()
    SaveFile:Write(Config)
end

-- Hàm chuyển đổi tên màu sang Color3
local function GetColor(name)
    local colors = {
        ["Trắng"] = Color3.fromRGB(255, 255, 255),
        ["Đỏ"] = Color3.fromRGB(255, 0, 0),
        ["Xanh"] = Color3.fromRGB(0, 255, 0),
        ["Vàng"] = Color3.fromRGB(255, 255, 0)
    }
    return colors[name] or Color3.fromRGB(255, 255, 255)
end

-- 2. Khởi tạo Window
local window = GUILib.new({
    Title = "Security Lab Hub",
    Width = 350,
    Height = 250,
    Theme = "Ruby",
    -- AccentColor = Color3.fromRGB(255, 90, 90),  -- Màu nền
    ColorMode = "random"  -- Tắt hiệu ứng
})



-- 3. Logic & Drawing
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.NumSides = 60; FOVCircle.Filled = false
local ESPLine = Drawing.new("Line")
ESPLine.Visible = false; ESPLine.Thickness = 1

RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    
    -- FOV Update
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = 100
    FOVCircle.Color = GetColor(Config.FOVColor)
    FOVCircle.Visible = Config.Aimbot
    
    -- ESP Logic
    if Config.ESP then
        local myPos = Char.HumanoidRootPart.Position
        local found = false
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (myPos - v.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 60 then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    if onScreen then
                        ESPLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        ESPLine.To = Vector2.new(screenPos.X, screenPos.Y)
                        ESPLine.Color = GetColor(Config.ESPColor)
                        ESPLine.Visible = true
                        found = true; break
                    end
                end
            end
        end
        if not found then ESPLine.Visible = false end
    else
        ESPLine.Visible = false
    end
end)

-- 4. UI Tabs
local TabAimbot = window:AddTab("Aimbot")
TabAimbot:AddToggle("Bật Aimbot", Config.Aimbot, function(s) Config.Aimbot = s; SaveSettings() end)
TabAimbot:AddDropdown("Màu FOV", {"Trắng", "Đỏ", "Xanh"}, function(c) Config.FOVColor = c; SaveSettings() end)

local TabESP = window:AddTab("ESP")
TabESP:AddToggle("Bật ESP Dây", Config.ESP, function(s) Config.ESP = s; SaveSettings() end)
TabESP:AddDropdown("Màu ESP", {"Đỏ", "Vàng", "Trắng"}, function(c) Config.ESPColor = c; SaveSettings() end)
TabESP:AddSection("MÀU")
TabESP:AddLabel("Đây là một dòng chữ ví dụ")

local TabInfo = window:AddTab("Thông tin")
TabInfo:AddButton("Xóa File Lưu", function() SaveFile:Write({}) Notify:Info("Hệ thống", "Đã reset cài đặt", 3) end)

-- Tạo tab settings để người dùng tự chọn phím tắt
local tabSettings = window:AddTab("Settings")

tabSettings:AddSection("PHÍM TẮT")

-- Dropdown để chọn phím
tabSettings:AddDropdown("Phím tắt hiển thị", {
    "F1", "F2", "F3", "F4", 
    "Insert", "Home", "PageUp",
    "LeftShift", "RightShift",
    "LeftControl", "RightControl"
}, function(selected)
    local keyMap = {
        ["F1"] = Enum.KeyCode.F1,
        ["F2"] = Enum.KeyCode.F2,
        ["F3"] = Enum.KeyCode.F3,
        ["F4"] = Enum.KeyCode.F4,
        ["Insert"] = Enum.KeyCode.Insert,
        ["Home"] = Enum.KeyCode.Home,
        ["PageUp"] = Enum.KeyCode.PageUp,
        ["LeftShift"] = Enum.KeyCode.LeftShift,
        ["RightShift"] = Enum.KeyCode.RightShift,
        ["LeftControl"] = Enum.KeyCode.LeftControl,
        ["RightControl"] = Enum.KeyCode.RightControl,
    }
    window:SetToggleKey(keyMap[selected])
    window:Notify("Phím tắt", "Đã đổi sang: " .. selected, 2)
end)

-- Hoặc dùng button để set nhanh
tabSettings:AddButton("Set phím tắt = F1", function()
    window:SetToggleKey(Enum.KeyCode.F1)
    window:Notify("Phím tắt", "Đã đổi sang F1", 2)
end)

tabSettings:AddButton("Set phím tắt = Insert", function()
    window:SetToggleKey(Enum.KeyCode.Insert)
    window:Notify("Phím tắt", "Đã đổi sang Insert", 2)
end)

tabSettings:AddButton("Reset về RightShift", function()
    window:SetToggleKey(Enum.KeyCode.RightShift)
    window:Notify("Phím tắt", "Đã reset về RightShift", 2)
end)

-- 5. RGB Effect
--task.spawn(function()
--    local hue = 0
--    while task.wait(0.01) do
--        hue = (hue + 0.005) % 1
--        window:SetAccentColor(Color3.fromHSV(hue, 1, 1))
--    end
--end)

Notify:Success("Chào kỹ sư!", "Script đang chạy mượt mà", 3)

-- window:Toggle(true)
