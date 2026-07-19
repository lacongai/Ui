
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
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = obj
	return c
end

local function stroke(obj, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 75)
	s.Thickness = thickness or 1
	s.Parent = obj
	return s
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

	-- Cấu hình có thể thay đổi bằng script
	self.Title = config.Title or "Floating GUI"
	self.Width = config.Width or 350
	self.Height = config.Height or 300
	self.ThemeColor = config.ThemeColor or Color3.fromRGB(28, 28, 38)
	self.AccentColor = config.AccentColor or Color3.fromRGB(90, 120, 255)
	self.TextColor = config.TextColor or Color3.fromRGB(230, 230, 235)
	self.Resizable = (config.Resizable == nil) and true or config.Resizable

	self.Tabs = {}
	self.ActiveTab = nil

	self:_Build()

	return self
end

--======================================================
-- DỰNG GIAO DIỆN GỐC
--======================================================
function GUILib:_Build()
	-- ScreenGui gốc
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FloatingGUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = PlayerGui
	self.ScreenGui = screenGui

	-- Khung chính (Main Frame)
	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Size = UDim2.new(0, self.Width, 0, self.Height)
	main.Position = UDim2.new(0.5, -self.Width / 2, 0.5, -self.Height / 2)
	main.BackgroundColor3 = self.ThemeColor
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = screenGui
	corner(main, 10)
	stroke(main, Color3.fromRGB(50, 50, 65), 1)
	self.MainFrame = main

	-- Thanh tiêu đề (Title Bar) - dùng để kéo thả
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.BackgroundColor3 = self.ThemeColor
	titleBar.BorderSizePixel = 0
	titleBar.Parent = main
	corner(titleBar, 10)
	self.TitleBar = titleBar

	-- Che góc bo tròn phía dưới titlebar cho liền mạch
	local titleFix = Instance.new("Frame")
	titleFix.Size = UDim2.new(1, 0, 0, 10)
	titleFix.Position = UDim2.new(0, 0, 1, -10)
	titleFix.BackgroundColor3 = self.ThemeColor
	titleFix.BorderSizePixel = 0
	titleFix.ZIndex = titleBar.ZIndex
	titleFix.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.Size = UDim2.new(1, -90, 1, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = self.Title
	titleLabel.TextColor3 = self.TextColor
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar
	self.TitleLabel = titleLabel

	-- Nút đóng
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 26, 0, 26)
	closeBtn.Position = UDim2.new(1, -32, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Parent = titleBar
	corner(closeBtn, 6)

	closeBtn.MouseButton1Click:Connect(function()
		self:Toggle(false)
	end)

	-- Nút thu nhỏ (minimize)
	local minBtn = Instance.new("TextButton")
	minBtn.Name = "MinimizeButton"
	minBtn.Size = UDim2.new(0, 26, 0, 26)
	minBtn.Position = UDim2.new(1, -62, 0, 5)
	minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	minBtn.Text = "—"
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 14
	minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	minBtn.Parent = titleBar
	corner(minBtn, 6)

	local minimized = false
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			tween(main, {Size = UDim2.new(0, self.Width, 0, 36)}, 0.2)
		else
			tween(main, {Size = UDim2.new(0, self.Width, 0, self.Height)}, 0.2)
		end
	end)
	self._minimized = function() return minimized end

	makeDraggable(titleBar, main)

	-- Thanh Tab (bên trái)
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(0, 90, 1, -36)
	tabBar.Position = UDim2.new(0, 0, 0, 36)
	tabBar.BackgroundColor3 = Color3.fromRGB(
		math.clamp(self.ThemeColor.R * 255 - 8, 0, 255) / 255 * 255,
		0, 0
	)
	tabBar.BackgroundColor3 = self.ThemeColor:Lerp(Color3.new(0, 0, 0), 0.15)
	tabBar.BorderSizePixel = 0
	tabBar.Parent = main
	self.TabBar = tabBar

	local tabList = Instance.new("UIListLayout")
	tabList.Padding = UDim.new(0, 4)
	tabList.SortOrder = Enum.SortOrder.LayoutOrder
	tabList.Parent = tabBar

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingTop = UDim.new(0, 8)
	tabPadding.PaddingLeft = UDim.new(0, 6)
	tabPadding.PaddingRight = UDim.new(0, 6)
	tabPadding.Parent = tabBar

	-- Vùng nội dung (bên phải)
	local content = Instance.new("Frame")
	content.Name = "ContentArea"
	content.Size = UDim2.new(1, -90, 1, -36)
	content.Position = UDim2.new(0, 90, 0, 36)
	content.BackgroundColor3 = self.ThemeColor
	content.BorderSizePixel = 0
	content.Parent = main
	self.ContentArea = content

	-- Tay cầm resize (góc dưới phải)
	if self.Resizable then
		local resizeHandle = Instance.new("Frame")
		resizeHandle.Name = "ResizeHandle"
		resizeHandle.Size = UDim2.new(0, 16, 0, 16)
		resizeHandle.Position = UDim2.new(1, -16, 1, -16)
		resizeHandle.BackgroundTransparency = 1
		resizeHandle.Parent = main

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

	-- Cho phép mở lại bằng phím tắt (RightShift) khi đóng
	self._open = true
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == Enum.KeyCode.RightShift then
			self:Toggle(not self._open)
		end
	end)
end

--======================================================
-- API: ĐỔI MÀU / KÍCH THƯỚC BẰNG SCRIPT
--======================================================
function GUILib:SetThemeColor(color)
	self.ThemeColor = color
	tween(self.MainFrame, {BackgroundColor3 = color}, 0.2)
	tween(self.TitleBar, {BackgroundColor3 = color}, 0.2)
	tween(self.ContentArea, {BackgroundColor3 = color}, 0.2)
	tween(self.TabBar, {BackgroundColor3 = color:Lerp(Color3.new(0, 0, 0), 0.15)}, 0.2)

	for _, child in ipairs(self.TitleBar:GetChildren()) do
		if child.Name == "TitleFix" or (child:IsA("Frame") and child ~= self.TitleBar) then
			child.BackgroundColor3 = color
		end
	end
end

function GUILib:SetAccentColor(color)
	self.AccentColor = color
	-- Cập nhật các phần tử đang dùng màu nhấn (tab đang chọn, nút bật/tắt, slider...)
	if self.ActiveTab and self.ActiveTab.Button then
		self.ActiveTab.Button.BackgroundColor3 = color
	end
end

function GUILib:SetSize(width, height)
	self.Width = width
	self.Height = height
	if self._minimized and self._minimized() then
		self.MainFrame.Size = UDim2.new(0, width, 0, 36)
	else
		tween(self.MainFrame, {Size = UDim2.new(0, width, 0, height)}, 0.15)
	end
end

function GUILib:SetTitle(text)
	self.Title = text
	self.TitleLabel.Text = text
end

function GUILib:Toggle(visible)
	self._open = visible
	self.ScreenGui.Enabled = visible
end

function GUILib:Destroy()
	self.ScreenGui:Destroy()
end

--======================================================
-- HỆ THỐNG TAB
--======================================================
local Tab = {}
Tab.__index = Tab

function GUILib:AddTab(name)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "TabButton"
	tabButton.Size = UDim2.new(1, 0, 0, 30)
	tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	tabButton.Text = name
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 13
	tabButton.TextColor3 = self.TextColor
	tabButton.Parent = self.TabBar
	corner(tabButton, 6)

	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
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

	tabButton.MouseButton1Click:Connect(function()
		self:_SelectTab(tabObj)
	end)

	-- Chọn tab đầu tiên làm mặc định
	if #self.Tabs == 1 then
		self:_SelectTab(tabObj)
	end

	return tabObj
end

function GUILib:_SelectTab(tabObj)
	for _, t in ipairs(self.Tabs) do
		t.Page.Visible = false
		t.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	end
	tabObj.Page.Visible = true
	tabObj.Button.BackgroundColor3 = self.AccentColor
	self.ActiveTab = tabObj
end

--======================================================
-- CÁC THÀNH PHẦN (COMPONENTS) TRONG TAB
--======================================================

-- Nút bấm
function Tab:AddButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.TextColor3 = self.Library.TextColor
	btn.AutoButtonColor = false
	btn.Parent = self.Page
	corner(btn, 6)

	btn.MouseEnter:Connect(function()
		tween(btn, {BackgroundColor3 = self.Library.AccentColor}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.15)
	end)
	btn.MouseButton1Click:Connect(function()
		tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.08)
		task.wait(0.08)
		tween(btn, {BackgroundColor3 = self.Library.AccentColor}, 0.15)
		if callback then callback() end
	end)

	return btn
end

-- Công tắc bật/tắt
function Tab:AddToggle(text, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 30)
	holder.BackgroundTransparency = 1
	holder.Parent = self.Page

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = self.Library.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 40, 0, 20)
	switch.Position = UDim2.new(1, -40, 0.5, -10)
	switch.BackgroundColor3 = default and self.Library.AccentColor or Color3.fromRGB(60, 60, 75)
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = holder
	corner(switch, 10)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = switch
	corner(knob, 8)

	local state = default or false
	switch.MouseButton1Click:Connect(function()
		state = not state
		tween(switch, {BackgroundColor3 = state and self.Library.AccentColor or Color3.fromRGB(60, 60, 75)}, 0.15)
		tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.15)
		if callback then callback(state) end
	end)

	return {
		Set = function(_, value)
			state = value
			switch.BackgroundColor3 = value and self.Library.AccentColor or Color3.fromRGB(60, 60, 75)
			knob.Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		end,
		Get = function() return state end,
	}
end

-- Thanh trượt (slider)
function Tab:AddSlider(text, min, max, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 46)
	holder.BackgroundTransparency = 1
	holder.Parent = self.Page

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -40, 0, 18)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = self.Library.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Size = UDim2.new(0, 40, 0, 18)
	valueLabel.Position = UDim2.new(1, -40, 0, 0)
	valueLabel.Text = tostring(default)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 13
	valueLabel.TextColor3 = self.Library.TextColor
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = holder

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 28)
	track.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
	track.Parent = holder
	corner(track, 3)

	local fill = Instance.new("Frame")
	local pct = (default - min) / (max - min)
	fill.Size = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = self.Library.AccentColor
	fill.Parent = track
	corner(fill, 3)

	local dragging = false
	local function updateFromInput(inputPos)
		local relX = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * relX)
		fill.Size = UDim2.new(relX, 0, 1, 0)
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

-- Dropdown chọn 1 trong nhiều lựa chọn
function Tab:AddDropdown(text, options, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 34)
	holder.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	holder.ClipsDescendants = true
	holder.Parent = self.Page
	corner(holder, 6)

	local main = Instance.new("TextButton")
	main.Size = UDim2.new(1, 0, 0, 34)
	main.BackgroundTransparency = 1
	main.Text = text .. "  ▾"
	main.Font = Enum.Font.Gotham
	main.TextSize = 13
	main.TextColor3 = self.Library.TextColor
	main.Parent = holder

	local listHolder = Instance.new("Frame")
	listHolder.Size = UDim2.new(1, 0, 0, #options * 26)
	listHolder.Position = UDim2.new(0, 0, 0, 34)
	listHolder.BackgroundTransparency = 1
	listHolder.Parent = holder

	local layout = Instance.new("UIListLayout")
	layout.Parent = listHolder

	local expanded = false
	for _, option in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 26)
		optBtn.BackgroundTransparency = 1
		optBtn.Text = option
		optBtn.Font = Enum.Font.Gotham
		optBtn.TextSize = 12
		optBtn.TextColor3 = self.Library.TextColor
		optBtn.Parent = listHolder

		optBtn.MouseButton1Click:Connect(function()
			main.Text = option .. "  ▾"
			expanded = false
			tween(holder, {Size = UDim2.new(1, 0, 0, 34)}, 0.15)
			if callback then callback(option) end
		end)
	end

	main.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			tween(holder, {Size = UDim2.new(1, 0, 0, 34 + #options * 26)}, 0.15)
		else
			tween(holder, {Size = UDim2.new(1, 0, 0, 34)}, 0.15)
		end
	end)

	return holder
end

-- Ô nhập chữ
function Tab:AddTextbox(text, placeholder, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 50)
	holder.BackgroundTransparency = 1
	holder.Parent = self.Page

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 16)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = self.Library.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 30)
	box.Position = UDim2.new(0, 0, 0, 18)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	box.PlaceholderText = placeholder or ""
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.TextColor3 = self.Library.TextColor
	box.ClearTextOnFocus = false
	box.Parent = holder
	corner(box, 6)

	box.FocusLost:Connect(function(enterPressed)
		if callback then callback(box.Text, enterPressed) end
	end)

	return box
end

-- Nhãn chữ đơn thuần
function Tab:AddLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = self.Library.TextColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = self.Page
	return label
end

-- Đường kẻ phân cách / tiêu đề nhóm
function Tab:AddSection(text)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 24)
	holder.BackgroundTransparency = 1
	holder.Parent = self.Page

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextColor3 = self.Library.AccentColor
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -2)
	line.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
	line.BorderSizePixel = 0
	line.Parent = holder

	return holder
end

return GUILib