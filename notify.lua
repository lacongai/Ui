-- Notification System
-- Custom notification and popup system

local Notify = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local NotificationQueue = {}
local ActiveNotifications = {}
local MaxNotifications = 5

-- Tạo ScreenGui cho notifications
local function CreateNotificationGui()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local existingGui = playerGui:FindFirstChild("CustomNotifications")
    if existingGui then
        return existingGui
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomNotifications"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = playerGui
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(1, -320, 0, 20)
    Container.Size = UDim2.new(0, 300, 1, -40)
    Container.Parent = ScreenGui
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.Parent = Container
    
    return ScreenGui
end

-- Tạo notification
local function CreateNotification(title, message, duration, notifType)
    local gui = CreateNotificationGui()
    local container = gui:FindFirstChild("Container")
    
    local typeColors = {
        success = Color3.fromRGB(50, 200, 100),
        error = Color3.fromRGB(220, 50, 50),
        warning = Color3.fromRGB(255, 170, 50),
        info = Color3.fromRGB(100, 150, 255),
        default = Color3.fromRGB(70, 70, 70)
    }
    
    local color = typeColors[notifType] or typeColors.default
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(1, 0, 0, 0)
    NotifFrame.ClipsDescendants = true
    NotifFrame.Position = UDim2.new(0, 350, 0, 0)
    NotifFrame.Parent = container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = NotifFrame
    
    local Accent = Instance.new("Frame")
    Accent.BackgroundColor3 = color
    Accent.BorderSizePixel = 0
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.Parent = NotifFrame
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 10)
    AccentCorner.Parent = Accent
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 8)
    Title.Size = UDim2.new(1, -30, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 1
    Title.Parent = NotifFrame
    
    local Message = Instance.new("TextLabel")
    Message.Name = "Message"
    Message.BackgroundTransparency = 1
    Message.Position = UDim2.new(0, 15, 0, 28)
    Message.Size = UDim2.new(1, -30, 0, 0)
    Message.Font = Enum.Font.Gotham
    Message.Text = message
    Message.TextColor3 = Color3.fromRGB(200, 200, 200)
    Message.TextSize = 12
    Message.TextWrapped = true
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.TextTransparency = 1
    Message.AutomaticSize = Enum.AutomaticSize.Y
    Message.Parent = NotifFrame
    
    wait()
    local textHeight = Message.AbsoluteSize.Y
    local totalHeight = math.max(60, textHeight + 40)
    
    NotifFrame.Size = UDim2.new(1, 0, 0, totalHeight)
    
    return NotifFrame, Title, Message, totalHeight
end

-- Hiển thị notification với animation
local function ShowNotification(notifFrame, title, message, duration)
    table.insert(ActiveNotifications, notifFrame)
    
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    local titleLabel = notifFrame:FindFirstChild("Title")
    local messageLabel = notifFrame:FindFirstChild("Message")
    
    TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(messageLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    spawn(function()
        wait(duration)
        
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(messageLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        
        local tween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 350, 0, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            for i, notif in ipairs(ActiveNotifications) do
                if notif == notifFrame then
                    table.remove(ActiveNotifications, i)
                    break
                end
            end
            notifFrame:Destroy()
        end)
    end)
end

-- Process notification queue
local function ProcessQueue()
    while #NotificationQueue > 0 do
        if #ActiveNotifications < MaxNotifications then
            local notifData = table.remove(NotificationQueue, 1)
            local frame, title, message = CreateNotification(
                notifData.title,
                notifData.message,
                notifData.duration,
                notifData.type
            )
            ShowNotification(frame, title, message, notifData.duration)
            wait(0.2)
        else
            wait(0.5)
        end
    end
end

-- Main notification function
function Notify:Notification(config)
    config = config or {}
    local title = config.Title or "Notification"
    local message = config.Message or ""
    local duration = config.Duration or 5
    local notifType = config.Type or "default"
    
    table.insert(NotificationQueue, {
        title = title,
        message = message,
        duration = duration,
        type = notifType
    })
    
    spawn(ProcessQueue)
end

-- Success notification
function Notify:Success(title, message, duration)
    self:Notification({
        Title = title,
        Message = message,
        Duration = duration or 3,
        Type = "success"
    })
end

-- Error notification
function Notify:Error(title, message, duration)
    self:Notification({
        Title = title,
        Message = message,
        Duration = duration or 5,
        Type = "error"
    })
end

-- Warning notification
function Notify:Warning(title, message, duration)
    self:Notification({
        Title = title,
        Message = message,
        Duration = duration or 4,
        Type = "warning"
    })
end

-- Info notification
function Notify:Info(title, message, duration)
    self:Notification({
        Title = title,
        Message = message,
        Duration = duration or 3,
        Type = "info"
    })
end

-- Popup Dialog (Yes/No)
function Notify:Popup(config)
    config = config or {}
    local title = config.Title or "Confirm"
    local message = config.Message or "Are you sure?"
    local confirmText = config.ConfirmText or "Yes"
    local cancelText = config.CancelText or "No"
    local onConfirm = config.OnConfirm or function() end
    local onCancel = config.OnCancel or function() end
    
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local PopupGui = Instance.new("ScreenGui")
    PopupGui.Name = "CustomPopup"
    PopupGui.ResetOnSpawn = false
    PopupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupGui.DisplayOrder = 999
    PopupGui.Parent = playerGui
    
    local Overlay = Instance.new("Frame")
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.Parent = PopupGui
    
    local PopupFrame = Instance.new("Frame")
    PopupFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PopupFrame.BorderSizePixel = 0
    PopupFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    PopupFrame.Size = UDim2.new(0, 400, 0, 200)
    PopupFrame.Parent = PopupGui
    
    local PopupCorner = Instance.new("UICorner")
    PopupCorner.CornerRadius = UDim.new(0, 12)
    PopupCorner.Parent = PopupFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 20)
    TitleLabel.Size = UDim2.new(1, -40, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = PopupFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0, 20, 0, 55)
    MessageLabel.Size = UDim2.new(1, -40, 0, 80)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.TextSize = 14
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = PopupFrame
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.Position = UDim2.new(1, -180, 1, -50)
    ConfirmButton.Size = UDim2.new(0, 80, 0, 35)
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.Text = confirmText
    ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmButton.TextSize = 13
    ConfirmButton.Parent = PopupFrame
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCorner.Parent = ConfirmButton
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    CancelButton.BorderSizePixel = 0
    CancelButton.Position = UDim2.new(1, -90, 1, -50)
    CancelButton.Size = UDim2.new(0, 70, 0, 35)
    CancelButton.Font = Enum.Font.GothamBold
    CancelButton.Text = cancelText
    CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CancelButton.TextSize = 13
    CancelButton.Parent = PopupFrame
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 8)
    CancelCorner.Parent = CancelButton
    
    ConfirmButton.MouseButton1Click:Connect(function()
        PopupGui:Destroy()
        onConfirm()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        PopupGui:Destroy()
        onCancel()
    end)
    
    Overlay.MouseButton1Click:Connect(function()
        PopupGui:Destroy()
        onCancel()
    end)
end

-- Simple alert (OK only)
function Notify:Alert(title, message, callback)
    self:Popup({
        Title = title,
        Message = message,
        ConfirmText = "OK",
        CancelText = "",
        OnConfirm = callback or function() end
    })
end

-- Clear all notifications
function Notify:ClearAll()
    for _, notif in ipairs(ActiveNotifications) do
        notif:Destroy()
    end
    ActiveNotifications = {}
    NotificationQueue = {}
end

return Notify
