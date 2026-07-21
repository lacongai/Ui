--[[
    FluentUI.lua
    ------------------------------------------------------------------
    Thư viện GUI Roblox viết MỚI HOÀN TOÀN (không tái sử dụng UI cũ),
    phong cách hiện đại kiểu Fluent UI / Windows 11 / Discord / Apple:
    bo góc, có border khắp nơi, nhiều theme dựng sẵn (mỗi theme là một
    dải gradient 2 màu), tab nằm ngang cuộn được, icon cho tab, mọi
    điều khiển đều có animation mượt, có hệ thống Notification.

    CÁCH DÙNG (đúng theo API bạn yêu cầu):

        local Library = require(path.to.FluentUI)

        local Window = Library:CreateWindow({
            Title = "My Hub",
            Theme = "Ruby",     -- Dark / Ruby / Ocean / Emerald / Purple / Sunset / Rainbow
            Width = 500,
            Height = 360,
        })

        local Tab = Window:AddTab({Title = "Combat", Icon = "sword"})
        local Section = Tab:AddSection("Main")

        Section:AddButton({Text = "Execute", Callback = function() end})
        Section:AddToggle({Text = "Auto Farm", Default = false, Callback = function(v) end})
        Section:AddSlider({Text = "WalkSpeed", Min = 16, Max = 100, Default = 16, Increment = 1, Callback = function(v) end})
        Section:AddDropdown({Text = "Theme", Items = {"Dark","Ruby","Ocean","Purple","Rainbow"}, Default = "Ruby", Callback = function(v) end})
        Section:AddTextBox({Text = "Player", Placeholder = "Enter Name", Callback = function(text) end})

        Window:Notify({Title = "Saved", Text = "Settings Saved.", Type = "Success"})

    Cũng chấp nhận đổi màu thủ công nếu muốn:
        Library:CreateWindow({ThemeColor = Color3.fromRGB(...), AccentColor = Color3.fromRGB(...)})
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = obj
	return c
end

local function border(obj, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.75
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

local function gradient(obj, colorA, colorB, rotation, transparency)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(colorA, colorB)
	g.Rotation = rotation or 90
	if transparency then
		g.Transparency = transparency
	end
	g.Parent = obj
	return g
end

-- Tự tính CanvasSize thủ công cho ScrollingFrame (an toàn hơn
-- AutomaticCanvasSize, không bị hiện tượng tự cuộn theo phần tử mới)
local function autoCanvasY(scrollFrame, listLayout, pad)
	pad = pad or 12
	local function update()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + pad)
		scrollFrame.CanvasPosition = Vector2.new(scrollFrame.CanvasPosition.X, 0)
	end
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
	update()
end

local function autoCanvasX(scrollFrame, listLayout, pad)
	pad = pad or 12
	local function update()
		scrollFrame.CanvasSize = UDim2.new(0, listLayout.AbsoluteContentSize.X + pad, 0, 0)
	end
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
	update()
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
-- THƯ VIỆN ICON — chỉ cần gõ tên, không cần rbxassetid://
--======================================================
local IconLibrary = {
	home     = "rbxassetid://10723434711",
	settings = "rbxassetid://10734950309",
	user     = "rbxassetid://10747373176",
	shield   = "rbxassetid://10723407389",
	sword    = "rbxassetid://10723434518",
	star     = "rbxassetid://10709790948",
	crown    = "rbxassetid://10709791437",
	heart    = "rbxassetid://10709791437",
	bell     = "rbxassetid://10709790644",
	coin     = "rbxassetid://10709790537",
	gem      = "rbxassetid://10709791682",
	box      = "rbxassetid://10709789989",
	info     = "rbxassetid://10747384394",
	check    = "rbxassetid://10709792537",
	flame    = "rbxassetid://10709791151",
}

local function GetIcon(name)
	if not name then return nil end
	if type(name) == "string" and string.find(name, "rbxassetid://") then
		return name
	end
	return IconLibrary[name]
end

--======================================================
-- THEME — mỗi theme là một cặp màu Gradient + màu Accent riêng
--======================================================
local Themes = {
	Dark = {
		Primary = Color3.fromRGB(40, 40, 48),
		Secondary = Color3.fromRGB(20, 20, 26),
		Accent = Color3.fromRGB(110, 140, 255),
	},
	Ruby = {
		Primary = Color3.fromRGB(255, 190, 220),
		Secondary = Color3.fromRGB(180, 235, 255),
		Accent = Color3.fromRGB(255, 110, 170),
	},
	Ocean = {
		Primary = Color3.fromRGB(150, 220, 255),
		Secondary = Color3.fromRGB(50, 80, 150),
		Accent = Color3.fromRGB(90, 190, 255),
	},
	Emerald = {
		Primary = Color3.fromRGB(160, 255, 200),
		Secondary = Color3.fromRGB(25, 75, 55),
		Accent = Color3.fromRGB(80, 255, 150),
	},
	Purple = {
		Primary = Color3.fromRGB(215, 175, 255),
		Secondary = Color3.fromRGB(55, 30, 90),
		Accent = Color3.fromRGB(180, 110, 255),
	},
	Sunset = {
		Primary = Color3.fromRGB(255, 185, 120),
		Secondary = Color3.fromRGB(160, 55, 115),
		Accent = Color3.fromRGB(255, 140, 90),
	},
	Rainbow = {
		Primary = Color3.fromRGB(255, 255, 255),
		Secondary = Color3.fromRGB(210, 210, 210),
		Accent = Color3.fromRGB(255, 255, 255),
		IsRainbow = true,
	},
}

local function ResolveTheme(themeInput, accentOverride, mainOverride)
	local preset
	if type(themeInput) == "string" then
		preset = Themes[themeInput] or Themes.Dark
	end
	local primary = preset and preset.Primary or mainOverride or Themes.Dark.Primary
	local secondary = preset and preset.Secondary or mainOverride or Themes.Dark.Secondary
	local accent = accentOverride or (preset and preset.Accent) or Themes.Dark.Accent
	local isRainbow = preset and preset.IsRainbow or false
	return primary, secondary, accent, isRainbow
end

--======================================================
-- LIBRARY CHÍNH
--======================================================
local Library = {}
Library.__index = Library
Library.Themes = Themes
Library.Icons = IconLibrary

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

--======================================================
-- Library:CreateWindow(config)
--======================================================
function Library:CreateWindow(config)
	config = config or {}

	local primary, secondary, accent, isRainbow = ResolveTheme(
		config.Theme or config.ThemeColor,
		config.AccentColor,
		config.ThemeColor
	)

	local self = setmetatable({}, Window)
	self.Title = config.Title or "My Hub"
	self.Width = config.Width or 500
	self.Height = config.Height or 360
	self.SurfaceColor = Color3.fromRGB(24, 24, 30) -- nền khối nội dung (đọc chữ rõ)
	self.PrimaryColor = primary
	self.SecondaryColor = secondary
	self.AccentColor = accent
	self.TextColor = Color3.fromRGB(240, 240, 245)
	self.IsRainbow = isRainbow

	self.Tabs = {}
	self.ActiveTab = nil

	self:_Build()

	if isRainbow then
		self:_StartRainbow()
	end

	return self
end

--======================================================
-- DỰNG KHUNG CHÍNH
--======================================================
function Window:_Build()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FluentUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 100
	screenGui.Parent = PlayerGui
	self.ScreenGui = screenGui

	------------------------------------------------------------------
	-- KHUNG NGOÀI: viền + gradient theo theme (Ruby: hồng -> xanh, v.v.)
	------------------------------------------------------------------
	local outer = Instance.new("Frame")
	outer.Name = "Outer"
	outer.Size = UDim2.new(0, self.Width, 0, self.Height)
	outer.Position = UDim2.new(0.5, -self.Width / 2, 0.5, -self.Height / 2)
	outer.BackgroundColor3 = self.PrimaryColor
	outer.BorderSizePixel = 0
	outer.Parent = screenGui
	corner(outer, 16)
	self.Outer = outer

	local grad = gradient(outer, self.PrimaryColor, self.SecondaryColor, 100)
	self.Gradient = grad

	local outerStroke = border(outer, Color3.fromRGB(255, 255, 255), 1.2, 0.6)
	self.OuterStroke = outerStroke

	------------------------------------------------------------------
	-- KHUNG NỘI DUNG (đặt lùi vào 2px để lộ viền gradient bao quanh)
	------------------------------------------------------------------
	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Position = UDim2.new(0, 2, 0, 2)
	main.Size = UDim2.new(1, -4, 1, -4)
	main.BackgroundColor3 = self.SurfaceColor
	main.BackgroundTransparency = 0.06
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = outer
	corner(main, 14)
	self.MainFrame = main

	------------------------------------------------------------------
	-- HEADER
	------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 46)
	header.BackgroundColor3 = self.SurfaceColor
	header.BackgroundTransparency = 0.1
	header.BorderSizePixel = 0
	header.Parent = main
	corner(header, 14)
	self.Header = header

	local headerFix = Instance.new("Frame")
	headerFix.BackgroundColor3 = header.BackgroundColor3
	headerFix.BackgroundTransparency = header.BackgroundTransparency
	headerFix.BorderSizePixel = 0
	headerFix.Position = UDim2.new(0, 0, 1, -14)
	headerFix.Size = UDim2.new(1, 0, 0, 14)
	headerFix.Parent = header
	self.HeaderFix = headerFix

	local headerLine = Instance.new("Frame")
	headerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headerLine.BackgroundTransparency = 0.9
	headerLine.BorderSizePixel = 0
	headerLine.Position = UDim2.new(0, 0, 1, -1)
	headerLine.Size = UDim2.new(1, 0, 0, 1)
	headerLine.ZIndex = 2
	headerLine.Parent = header

	local dot = Instance.new("Frame")
	dot.BackgroundColor3 = self.AccentColor
	dot.Position = UDim2.new(0, 16, 0.5, -4)
	dot.Size = UDim2.new(0, 8, 0, 8)
	dot.ZIndex = 2
	dot.Parent = header
	corner(dot, 4)
	self.TitleDot = dot

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 32, 0, 0)
	titleLabel.Size = UDim2.new(1, -110, 1, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = self.Title
	titleLabel.TextColor3 = self.TextColor
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 2
	titleLabel.Parent = header
	self.TitleLabel = titleLabel

	local closeBtn = Instance.new("TextButton")
	closeBtn.AutoButtonColor = false
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -38, 0, 9)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
	closeBtn.BackgroundTransparency = 0.8
	closeBtn.Text = "✕"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 13
	closeBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
	closeBtn.ZIndex = 2
	closeBtn.Parent = header
	corner(closeBtn, 8)

	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 160, 160)}, 0.12)
	end)
	closeBtn.MouseButton1Click:Connect(function()
		self:Toggle(false)
	end)

	makeDraggable(header, outer)

	self._open = true
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == Enum.KeyCode.RightShift then
			self:Toggle(not self._open)
		end
	end)

	------------------------------------------------------------------
	-- TAB BAR NẰM NGANG (cuộn ngang nếu nhiều tab)
	------------------------------------------------------------------
	local tabBar = Instance.new("ScrollingFrame")
	tabBar.Name = "TabBar"
	tabBar.Position = UDim2.new(0, 0, 0, 46)
	tabBar.Size = UDim2.new(1, 0, 0, 46)
	tabBar.BackgroundColor3 = self.SurfaceColor
	tabBar.BackgroundTransparency = 0.15
	tabBar.BorderSizePixel = 0
	tabBar.ScrollingDirection = Enum.ScrollingDirection.X
	tabBar.ScrollBarThickness = 3
	tabBar.ScrollBarImageColor3 = self.AccentColor
	tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabBar.Parent = main
	self.TabBar = tabBar

	local tabBarLine = Instance.new("Frame")
	tabBarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabBarLine.BackgroundTransparency = 0.92
	tabBarLine.BorderSizePixel = 0
	tabBarLine.Position = UDim2.new(0, 0, 1, -1)
	tabBarLine.Size = UDim2.new(1, 0, 0, 1)
	tabBarLine.Parent = tabBar

	local tabList = Instance.new("UIListLayout")
	tabList.FillDirection = Enum.FillDirection.Horizontal
	tabList.SortOrder = Enum.SortOrder.LayoutOrder
	tabList.Padding = UDim.new(0, 6)
	tabList.VerticalAlignment = Enum.VerticalAlignment.Center
	tabList.Parent = tabBar
	self._TabListLayout = tabList

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingLeft = UDim.new(0, 10)
	tabPad.PaddingRight = UDim.new(0, 10)
	tabPad.PaddingTop = UDim.new(0, 6)
	tabPad.PaddingBottom = UDim.new(0, 6)
	tabPad.Parent = tabBar

	autoCanvasX(tabBar, tabList, 20)

	------------------------------------------------------------------
	-- VÙNG NỘI DUNG TAB (cuộn dọc)
	------------------------------------------------------------------
	local content = Instance.new("Frame")
	content.Name = "ContentArea"
	content.Position = UDim2.new(0, 0, 0, 92)
	content.Size = UDim2.new(1, 0, 1, -92)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Parent = main
	self.ContentArea = content

	------------------------------------------------------------------
	-- HIỆU ỨNG MỞ CỬA SỔ (phóng to nhẹ, không ẩn phần tử nào)
	------------------------------------------------------------------
	local finalSize = outer.Size
	outer.Size = UDim2.new(0, self.Width * 0.94, 0, self.Height * 0.94)
	tween(outer, {Size = finalSize}, 0.22, Enum.EasingStyle.Back)
end

--======================================================
-- RAINBOW / RGB THEME — tự động chạy window:SetAccentColor(...)
--======================================================
function Window:_StartRainbow()
	task.spawn(function()
		local hue = 0
		while self.ScreenGui and self.ScreenGui.Parent do
			hue = (hue + 0.004) % 1
			local c1 = Color3.fromHSV(hue, 0.55, 1)
			local c2 = Color3.fromHSV((hue + 0.5) % 1, 0.55, 1)
			self.Gradient.Color = ColorSequence.new(c1, c2)
			self:SetAccentColor(Color3.fromHSV(hue, 0.85, 1))
			task.wait(0.05)
		end
	end)
end

--======================================================
-- API WINDOW
--======================================================
function Window:SetAccentColor(color)
	self.AccentColor = color
	tween(self.TitleDot, {BackgroundColor3 = color}, 0.15)
	tween(self.TabBar, {ScrollBarImageColor3 = color}, 0.15)
	if self.ActiveTab then
		local ind = self.ActiveTab.Button:FindFirstChild("Indicator")
		if ind then ind.BackgroundColor3 = color end
	end
end

function Window:SetTheme(name)
	local primary, secondary, accent, isRainbow = ResolveTheme(name)
	self.PrimaryColor = primary
	self.SecondaryColor = secondary
	self.IsRainbow = isRainbow
	if not isRainbow then
		self.Gradient.Color = ColorSequence.new(primary, secondary)
	end
	self:SetAccentColor(accent)
	if isRainbow then
		self:_StartRainbow()
	end
end

function Window:Toggle(visible)
	self._open = visible
	self.ScreenGui.Enabled = visible
end

function Window:Destroy()
	self.ScreenGui:Destroy()
end

--======================================================
-- NOTIFICATION
--======================================================
local NotifyStyles = {
	Success = {Icon = "✔", Color = Color3.fromRGB(90, 220, 140)},
	Warning = {Icon = "⚠", Color = Color3.fromRGB(255, 190, 80)},
	Info    = {Icon = "ⓘ", Color = Color3.fromRGB(110, 170, 255)},
}

function Window:Notify(opts)
	opts = opts or {}
	local style = NotifyStyles[opts.Type] or NotifyStyles.Info
	local duration = opts.Duration or 3

	local notif = Instance.new("Frame")
	notif.AnchorPoint = Vector2.new(1, 1)
	notif.Position = UDim2.new(1, -20, 1, -20)
	notif.Size = UDim2.new(0, 270, 0, 0)
	notif.BackgroundColor3 = self.SurfaceColor
	notif.BackgroundTransparency = 0.08
	notif.BorderSizePixel = 0
	notif.ClipsDescendants = true
	notif.ZIndex = 50
	notif.Parent = self.ScreenGui
	corner(notif, 12)
	border(notif, style.Color, 1, 0.5)

	local iconLabel = Instance.new("TextLabel")
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.new(0, 12, 0, 10)
	iconLabel.Size = UDim2.new(0, 24, 0, 24)
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.Text = style.Icon
	iconLabel.TextColor3 = style.Color
	iconLabel.TextSize = 18
	iconLabel.ZIndex = 51
	iconLabel.Parent = notif

	local titleL = Instance.new("TextLabel")
	titleL.BackgroundTransparency = 1
	titleL.Position = UDim2.new(0, 42, 0, 8)
	titleL.Size = UDim2.new(1, -54, 0, 18)
	titleL.Font = Enum.Font.GothamBold
	titleL.Text = opts.Title or "Notification"
	titleL.TextColor3 = self.TextColor
	titleL.TextSize = 13
	titleL.TextXAlignment = Enum.TextXAlignment.Left
	titleL.ZIndex = 51
	titleL.Parent = notif

	local bodyL = Instance.new("TextLabel")
	bodyL.BackgroundTransparency = 1
	bodyL.Position = UDim2.new(0, 42, 0, 26)
	bodyL.Size = UDim2.new(1, -54, 0, 0)
	bodyL.Font = Enum.Font.Gotham
	bodyL.Text = opts.Text or ""
	bodyL.TextColor3 = Color3.fromRGB(200, 200, 208)
	bodyL.TextSize = 12
	bodyL.TextWrapped = true
	bodyL.TextXAlignment = Enum.TextXAlignment.Left
	bodyL.AutomaticSize = Enum.AutomaticSize.Y
	bodyL.ZIndex = 51
	bodyL.Parent = notif

	task.wait()
	local targetHeight = 26 + bodyL.AbsoluteSize.Y + 14
	tween(notif, {Size = UDim2.new(0, 270, 0, targetHeight)}, 0.22, Enum.EasingStyle.Back)

	task.delay(duration, function()
		local t = tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(0, 270, 0, 0)}, 0.2)
		t.Completed:Wait()
		notif:Destroy()
	end)
end

--======================================================
-- Window:AddTab({Title=, Icon=})
--======================================================
function Window:AddTab(cfg)
	cfg = cfg or {}
	local name = cfg.Title or "Tab"
	local order = #self.Tabs + 1

	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "TabButton"
	tabButton.AutoButtonColor = false
	tabButton.LayoutOrder = order
	tabButton.AutomaticSize = Enum.AutomaticSize.X
	tabButton.Size = UDim2.new(0, 0, 1, 0)
	tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.BackgroundTransparency = (order == 1) and 0.85 or 1
	tabButton.Text = ""
	tabButton.Parent = self.TabBar
	corner(tabButton, 10)

	local iconId = GetIcon(cfg.Icon)
	local textOffset = 14

	if iconId then
		local iconImg = Instance.new("ImageLabel")
		iconImg.BackgroundTransparency = 1
		iconImg.Position = UDim2.new(0, 12, 0.5, -8)
		iconImg.Size = UDim2.new(0, 16, 0, 16)
		iconImg.Image = iconId
		iconImg.ImageColor3 = (order == 1) and self.AccentColor or Color3.fromRGB(170, 170, 178)
		iconImg.Parent = tabButton
		textOffset = 34
	end

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, textOffset, 0, 0)
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Font = Enum.Font.GothamSemibold
	label.Text = name
	label.TextColor3 = (order == 1) and self.TextColor or Color3.fromRGB(170, 170, 178)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tabButton

	local rightPad = Instance.new("UIPadding")
	rightPad.PaddingRight = UDim.new(0, 14)
	rightPad.Parent = tabButton

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.AnchorPoint = Vector2.new(0.5, 1)
	indicator.Position = UDim2.new(0.5, 0, 1, -3)
	indicator.Size = UDim2.new(0, (order == 1) and 18 or 0, 0, 3)
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
	page.Visible = (order == 1)
	page.Parent = self.ContentArea

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 12)
	layout.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)
	pad.PaddingBottom = UDim.new(0, 14)
	pad.Parent = page

	autoCanvasY(page, layout, 16)

	local tabObj = setmetatable({
		Name = name,
		Button = tabButton,
		Icon = iconId and tabButton:FindFirstChildOfClass("ImageLabel") or nil,
		Label = label,
		Page = page,
		Window = self,
	}, Tab)

	table.insert(self.Tabs, tabObj)
	if order == 1 then
		self.ActiveTab = tabObj
	end

	tabButton.MouseEnter:Connect(function()
		if self.ActiveTab ~= tabObj then
			tween(tabButton, {BackgroundTransparency = 0.9}, 0.12)
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

	return tabObj
end

function Window:_SelectTab(tabObj)
	for _, t in ipairs(self.Tabs) do
		local active = (t == tabObj)
		t.Page.Visible = active
		tween(t.Button, {BackgroundTransparency = active and 0.85 or 1}, 0.15)
		tween(t.Label, {TextColor3 = active and self.TextColor or Color3.fromRGB(170, 170, 178)}, 0.15)
		if t.Icon then
			tween(t.Icon, {ImageColor3 = active and self.AccentColor or Color3.fromRGB(170, 170, 178)}, 0.15)
		end
		local ind = t.Button:FindFirstChild("Indicator")
		if ind then
			tween(ind, {Size = UDim2.new(0, active and 18 or 0, 0, 3)}, 0.18, Enum.EasingStyle.Back)
		end
	end
	self.ActiveTab = tabObj
end

--======================================================
-- Tab:AddSection(name)
--======================================================
function Tab:AddSection(name)
	local win = self.Window

	local sectionFrame = Instance.new("Frame")
	sectionFrame.BackgroundColor3 = win.SurfaceColor
	sectionFrame.BackgroundTransparency = 0.25
	sectionFrame.BorderSizePixel = 0
	sectionFrame.Size = UDim2.new(1, 0, 0, 0)
	sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
	sectionFrame.Parent = self.Page
	corner(sectionFrame, 12)
	border(sectionFrame, win.AccentColor, 1, 0.75)

	local head = Instance.new("TextLabel")
	head.BackgroundTransparency = 1
	head.Position = UDim2.new(0, 14, 0, 10)
	head.Size = UDim2.new(1, -28, 0, 18)
	head.Font = Enum.Font.GothamBold
	head.Text = name
	head.TextColor3 = win.TextColor
	head.TextSize = 13
	head.TextXAlignment = Enum.TextXAlignment.Left
	head.Parent = sectionFrame

	local body = Instance.new("Frame")
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0, 12, 0, 34)
	body.Size = UDim2.new(1, -24, 0, 0)
	body.AutomaticSize = Enum.AutomaticSize.Y
	body.Parent = sectionFrame

	local bodyLayout = Instance.new("UIListLayout")
	bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	bodyLayout.Padding = UDim.new(0, 8)
	bodyLayout.Parent = body

	local bottomPad = Instance.new("UIPadding")
	bottomPad.PaddingBottom = UDim.new(0, 12)
	bottomPad.Parent = sectionFrame

	return setmetatable({Window = win, Body = body}, Section)
end

--======================================================
-- Section:AddButton({Text=, Callback=})
--======================================================
function Section:AddButton(opts)
	opts = opts or {}
	local win = self.Window

	local btn = Instance.new("TextButton")
	btn.AutoButtonColor = false
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = win.AccentColor
	btn.BackgroundTransparency = 0.82
	btn.Text = opts.Text or "Button"
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.TextColor3 = win.TextColor
	btn.ClipsDescendants = true
	btn.Parent = self.Body
	corner(btn, 9)
	border(btn, win.AccentColor, 1, 0.6)

	btn.MouseEnter:Connect(function()
		tween(btn, {BackgroundTransparency = 0.3}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundTransparency = 0.82}, 0.15)
	end)
	btn.MouseButton1Click:Connect(function()
		tween(btn, {Size = UDim2.new(1, -6, 0, 33)}, 0.07)
		task.delay(0.07, function()
			tween(btn, {Size = UDim2.new(1, 0, 0, 36)}, 0.12, Enum.EasingStyle.Back)
		end)
		if opts.Callback then opts.Callback() end
	end)

	return btn
end

--======================================================
-- Section:AddToggle({Text=, Default=, Callback=})
--======================================================
function Section:AddToggle(opts)
	opts = opts or {}
	local win = self.Window
	local state = opts.Default or false

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 38)
	holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holder.BackgroundTransparency = 0.94
	holder.Parent = self.Body
	corner(holder, 9)
	border(holder, win.AccentColor, 1, 0.75)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Size = UDim2.new(1, -66, 1, 0)
	label.Text = opts.Text or "Toggle"
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = win.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 42, 0, 22)
	switch.Position = UDim2.new(1, -52, 0.5, -11)
	switch.BackgroundColor3 = state and win.AccentColor or Color3.fromRGB(70, 70, 78)
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = holder
	corner(switch, 11)
	local switchStroke = border(switch, win.AccentColor, 1.2, state and 0.3 or 1)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = switch
	corner(knob, 9)

	local function apply(v)
		state = v
		tween(switch, {BackgroundColor3 = v and win.AccentColor or Color3.fromRGB(70, 70, 78)}, 0.15)
		tween(switchStroke, {Transparency = v and 0.3 or 1}, 0.15)
		tween(knob, {Position = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.15, Enum.EasingStyle.Back)
	end

	switch.MouseButton1Click:Connect(function()
		apply(not state)
		if opts.Callback then opts.Callback(state) end
	end)

	return {
		Set = function(_, v) apply(v) end,
		Get = function() return state end,
	}
end

--======================================================
-- Section:AddSlider({Text=, Min=, Max=, Default=, Increment=, Callback=})
--======================================================
function Section:AddSlider(opts)
	opts = opts or {}
	local win = self.Window
	local min = opts.Min or 0
	local max = opts.Max or 100
	local increment = opts.Increment or 1
	local val = opts.Default or min

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 52)
	holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holder.BackgroundTransparency = 0.94
	holder.Parent = self.Body
	corner(holder, 9)
	border(holder, win.AccentColor, 1, 0.75)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 8)
	label.Size = UDim2.new(1, -60, 0, 16)
	label.Text = opts.Text or "Slider"
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = win.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(1, -56, 0, 8)
	valueLabel.Size = UDim2.new(0, 44, 0, 16)
	valueLabel.Text = tostring(val)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 13
	valueLabel.TextColor3 = win.AccentColor
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = holder

	local track = Instance.new("Frame")
	track.Position = UDim2.new(0, 12, 0, 32)
	track.Size = UDim2.new(1, -24, 0, 8)
	track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	track.BackgroundTransparency = 0.85
	track.Parent = holder
	corner(track, 4)

	local pct = (val - min) / (max - min)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = win.AccentColor
	fill.BorderSizePixel = 0
	fill.Parent = track
	corner(fill, 4)

	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(pct, 0, 0.5, 0)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.ZIndex = 2
	knob.Parent = track
	corner(knob, 7)
	border(knob, win.AccentColor, 2, 0)

	local dragging = false
	local function update(inputX)
		local relX = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor((min + (max - min) * relX) / increment + 0.5) * increment
		value = math.clamp(value, min, max)
		relX = (value - min) / (max - min)
		fill.Size = UDim2.new(relX, 0, 1, 0)
		knob.Position = UDim2.new(relX, 0, 0.5, 0)
		valueLabel.Text = tostring(value)
		val = value
		if opts.Callback then opts.Callback(value) end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input.Position.X)
		end
	end)
	track.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input.Position.X)
		end
	end)

	return {
		Set = function(_, v) update(track.AbsolutePosition.X + ((v - min) / (max - min)) * track.AbsoluteSize.X) end,
		Get = function() return val end,
	}
end

--======================================================
-- Section:AddDropdown({Text=, Items=, Default=, Callback=})
--======================================================
function Section:AddDropdown(opts)
	opts = opts or {}
	local win = self.Window
	local items = opts.Items or {}
	local current = opts.Default or items[1] or "None"

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 38)
	holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holder.BackgroundTransparency = 0.94
	holder.ClipsDescendants = true
	holder.Parent = self.Body
	corner(holder, 9)
	border(holder, win.AccentColor, 1, 0.75)

	local main = Instance.new("TextButton")
	main.Size = UDim2.new(1, 0, 0, 38)
	main.BackgroundTransparency = 1
	main.Text = "  " .. (opts.Text or "Dropdown") .. ": " .. current
	main.Font = Enum.Font.Gotham
	main.TextSize = 13
	main.TextColor3 = win.TextColor
	main.TextXAlignment = Enum.TextXAlignment.Left
	main.Parent = holder

	local arrow = Instance.new("TextLabel")
	arrow.BackgroundTransparency = 1
	arrow.Position = UDim2.new(1, -30, 0, 0)
	arrow.Size = UDim2.new(0, 24, 0, 38)
	arrow.Font = Enum.Font.GothamBold
	arrow.Text = "▾"
	arrow.TextColor3 = win.AccentColor
	arrow.TextSize = 13
	arrow.Parent = holder

	local listHolder = Instance.new("Frame")
	listHolder.Position = UDim2.new(0, 0, 0, 38)
	listHolder.Size = UDim2.new(1, 0, 0, #items * 30)
	listHolder.BackgroundTransparency = 1
	listHolder.Parent = holder

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = listHolder

	local expanded = false
	for i, item in ipairs(items) do
		local optBtn = Instance.new("TextButton")
		optBtn.AutoButtonColor = false
		optBtn.LayoutOrder = i
		optBtn.Size = UDim2.new(1, 0, 0, 30)
		optBtn.BackgroundColor3 = win.AccentColor
		optBtn.BackgroundTransparency = 1
		optBtn.Text = "  " .. item
		optBtn.Font = Enum.Font.Gotham
		optBtn.TextSize = 12
		optBtn.TextColor3 = win.TextColor
		optBtn.TextXAlignment = Enum.TextXAlignment.Left
		optBtn.Parent = listHolder

		optBtn.MouseEnter:Connect(function()
			tween(optBtn, {BackgroundTransparency = 0.85}, 0.1)
		end)
		optBtn.MouseLeave:Connect(function()
			tween(optBtn, {BackgroundTransparency = 1}, 0.1)
		end)
		optBtn.MouseButton1Click:Connect(function()
			current = item
			main.Text = "  " .. (opts.Text or "Dropdown") .. ": " .. current
			expanded = false
			tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.15)
			tween(arrow, {Rotation = 0}, 0.15)
			if opts.Callback then opts.Callback(item) end
		end)
	end

	main.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			tween(holder, {Size = UDim2.new(1, 0, 0, 38 + #items * 30)}, 0.18)
			tween(arrow, {Rotation = 180}, 0.18)
		else
			tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.15)
			tween(arrow, {Rotation = 0}, 0.15)
		end
	end)

	return {
		Set = function(_, v)
			current = v
			main.Text = "  " .. (opts.Text or "Dropdown") .. ": " .. current
		end,
		Get = function() return current end,
	}
end

--======================================================
-- Section:AddTextBox({Text=, Placeholder=, Callback=})
--======================================================
function Section:AddTextBox(opts)
	opts = opts or {}
	local win = self.Window

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 56)
	holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holder.BackgroundTransparency = 0.94
	holder.Parent = self.Body
	corner(holder, 9)
	local holderStroke = border(holder, win.AccentColor, 1, 0.75)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(1, -24, 0, 14)
	label.Text = opts.Text or "TextBox"
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextColor3 = Color3.fromRGB(180, 180, 188)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local box = Instance.new("TextBox")
	box.Position = UDim2.new(0, 12, 0, 22)
	box.Size = UDim2.new(1, -24, 0, 26)
	box.BackgroundTransparency = 1
	box.PlaceholderText = opts.Placeholder or ""
	box.PlaceholderColor3 = Color3.fromRGB(140, 140, 148)
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.TextColor3 = win.TextColor
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ClearTextOnFocus = false
	box.Parent = holder

	box.Focused:Connect(function()
		tween(holderStroke, {Transparency = 0.2}, 0.15)
	end)
	box.FocusLost:Connect(function(enterPressed)
		tween(holderStroke, {Transparency = 0.75}, 0.15)
		if opts.Callback then opts.Callback(box.Text, enterPressed) end
	end)

	return {
		Set = function(_, v) box.Text = v end,
		Get = function() return box.Text end,
	}
end

return Library
