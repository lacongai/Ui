-- ================================================================
-- Roblox Modern UI Library  |  Bản làm lại (redesign) - v2
-- ----------------------------------------------------------------
-- Giữ nguyên 100% API và cách dùng của bản gốc, chỉ nâng cấp:
--   - Giao diện đẹp hơn, đồng bộ (bo góc, viền, khoảng cách, màu sắc)
--   - Hiệu ứng mượt hơn (hover/click) cho toàn bộ nút bấm
--   - Sửa vài lỗi nhỏ của bản gốc:
--       + wait() cũ -> task.wait() (tránh cảnh báo deprecated)
--       + Chuyển tab không còn dò tìm bằng FindFirstChild("Frame")/
--         ("ImageLabel") dễ gãy khi thêm phần tử khác -> lưu tham
--         chiếu trực tiếp cho từng tab (ổn định hơn, không bị lỗi
--         khi UI phức tạp lên)
--       + Card thanh trượt (slider) không bị "giật" số khi gõ tay
--   - Mọi Section:Add... vẫn trả về cùng bảng {SetValue, GetValue}
--     y hệt bản gốc để không phá vỡ script đang dùng thư viện này.
--
-- CÁCH DÙNG: giống hệt bản cũ, không cần sửa gì trong script gọi.
--
--   local UI = require(path.to.ui)
--   local Window = UI.CreateWindow({
--       Title = "Hub",
--       Subtitle = "by You",
--       Theme = "Blue",        -- xem bảng Themes bên dưới
--       ToggleIcon = "home",   -- optional, dùng IconLibrary
--       Width = 750, Height = 580,
--   })
--
--   local Tab = Window:AddTab({Title = "Chính", Icon = "home"})
--   local Section = Tab:AddSection("Cơ bản")
--
--   Section:AddButton("Nói xin chào", {Callback = function() print("Hi") end})
--   Section:AddToggle("esp", {Text = "Bật ESP", Default = false, Callback = function(v) end})
--   Section:AddSlider("speed", {Text="Tốc độ", Min=16, Max=100, Default=16, Callback=function(v) end})
--   Section:AddDropdown("map", {Items={"Map1","Map2"}, Default="Map1", Callback=function(v) end})
--   Section:AddTextBox("name", {Placeholder="Nhập tên...", Callback=function(v) end})
-- ================================================================

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--=====================================================================
-- BẢNG MÀU THEME (giữ nguyên tên & giá trị như bản gốc)
--=====================================================================
local Themes = {
	Dark    = Color3.fromRGB(100, 150, 255),
	Red     = Color3.fromRGB(255, 80, 80),
	Green   = Color3.fromRGB(80, 255, 120),
	Blue    = Color3.fromRGB(80, 180, 255),
	Purple  = Color3.fromRGB(180, 100, 255),
	Pink    = Color3.fromRGB(255, 120, 180),
	Orange  = Color3.fromRGB(255, 150, 80),
	Yellow  = Color3.fromRGB(255, 220, 80),
	Cyan    = Color3.fromRGB(80, 220, 255),
	Magenta = Color3.fromRGB(255, 80, 200),
}

--=====================================================================
-- THƯ VIỆN ICON (giữ nguyên tên & id như bản gốc)
--=====================================================================
local IconLibrary = {
	home     = "rbxassetid://10723434711",
	settings = "rbxassetid://10734950309",
	user     = "rbxassetid://10747373176",
	shield   = "rbxassetid://10723407389",
	sword    = "rbxassetid://10723434518",
	star     = "rbxassetid://10709790948",
	crown    = "rbxassetid://10709791437",
	info     = "rbxassetid://10747384394",
	menu     = "rbxassetid://10747384394",
	plus     = "rbxassetid://10747373176",
	minus    = "rbxassetid://10734942835",
	close    = "rbxassetid://10747384394",
	check    = "rbxassetid://10709792537",
	bell     = "rbxassetid://10709790644",
	heart    = "rbxassetid://10709791437",
	flame    = "rbxassetid://10709791151",
	gem      = "rbxassetid://10709791682",
	coin     = "rbxassetid://10709790537",
	box      = "rbxassetid://10709789989",
}

local function GetIcon(name)
	if type(name) == "string" and string.find(name, "rbxassetid://") then
		return name
	end
	return IconLibrary[name] or IconLibrary.home
end

--=====================================================================
-- HẰNG SỐ GIAO DIỆN (để mọi khối bo góc/khoảng cách đồng bộ nhau)
--=====================================================================
local RADIUS_WINDOW  = UDim.new(0, 20)
local RADIUS_CARD    = UDim.new(0, 12)
local RADIUS_SMALL   = UDim.new(0, 8)
local RADIUS_PILL    = UDim.new(1, 0)

local COL_BG_MAIN     = Color3.fromRGB(15, 15, 18)
local COL_BG_HEADER   = Color3.fromRGB(20, 20, 24)
local COL_BG_SIDEBAR  = Color3.fromRGB(13, 13, 16)
local COL_BG_CONTENT  = Color3.fromRGB(16, 16, 19)
local COL_BG_CARD     = Color3.fromRGB(22, 22, 26)
local COL_BG_CARD_ALT = Color3.fromRGB(27, 27, 32)
local COL_BORDER      = Color3.fromRGB(38, 38, 44)
local COL_TEXT        = Color3.fromRGB(235, 235, 240)
local COL_TEXT_DIM    = Color3.fromRGB(150, 150, 158)

--=====================================================================
-- TIỆN ÍCH DÙNG CHUNG
--=====================================================================
local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or RADIUS_CARD
	c.Parent = obj
	return c
end

local function stroke(obj, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or COL_BORDER
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

local function tween(obj, props, time, style)
	return TweenService:Create(obj, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad), props)
end

local function MakeDragFromArea(frame, area)
	local dragging = false
	local dragStart, frameStart

	area.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			frameStart = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				frameStart.X.Scale, frameStart.X.Offset + delta.X,
				frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
			)
		end
	end)
end

--=====================================================================
-- UI.CreateWindow  — giống hệt bản gốc: Title, Subtitle, Theme,
-- ToggleIcon, Width (mặc định 750), Height (mặc định 580)
--=====================================================================
function UI.CreateWindow(config)
	config = config or {}
	local title = config.Title or "Hub"
	local subtitle = config.Subtitle or ""
	local theme = config.Theme or "Dark"
	local toggleIcon = config.ToggleIcon
	local width = config.Width or 750
	local height = config.Height or 580

	local ThemeColor = Themes[theme] or Themes.Dark

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game:GetService("CoreGui")

	------------------------------------------------------------------
	-- KHUNG CHÍNH
	------------------------------------------------------------------
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = COL_BG_MAIN
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
	MainFrame.Size = UDim2.new(0, width, 0, height)
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	corner(MainFrame, RADIUS_WINDOW)
	stroke(MainFrame, COL_BORDER, 1)

	-- Quầng sáng viền ngoài theo màu theme (giữ hiệu ứng Glow của bản gốc)
	local Glow = Instance.new("ImageLabel")
	Glow.Name = "Glow"
	Glow.BackgroundTransparency = 1
	Glow.Position = UDim2.new(0, -30, 0, -30)
	Glow.Size = UDim2.new(1, 60, 1, 60)
	Glow.ZIndex = 0
	Glow.Image = "rbxassetid://6014261993"
	Glow.ImageColor3 = ThemeColor
	Glow.ImageTransparency = 0.8
	Glow.ScaleType = Enum.ScaleType.Slice
	Glow.SliceCenter = Rect.new(99, 99, 99, 99)
	Glow.Parent = MainFrame

	------------------------------------------------------------------
	-- HEADER (thanh tiêu đề)
	------------------------------------------------------------------
	local TopSection = Instance.new("Frame")
	TopSection.Name = "Header"
	TopSection.BackgroundColor3 = COL_BG_HEADER
	TopSection.BorderSizePixel = 0
	TopSection.Size = UDim2.new(1, 0, 0, 74)
	TopSection.Parent = MainFrame
	corner(TopSection, RADIUS_WINDOW)

	-- Che góc bo tròn dưới header cho liền mạch với phần thân
	local HeaderFix = Instance.new("Frame")
	HeaderFix.BackgroundColor3 = COL_BG_HEADER
	HeaderFix.BorderSizePixel = 0
	HeaderFix.Position = UDim2.new(0, 0, 1, -RADIUS_WINDOW.Offset)
	HeaderFix.Size = UDim2.new(1, 0, 0, RADIUS_WINDOW.Offset)
	HeaderFix.ZIndex = TopSection.ZIndex
	HeaderFix.Parent = TopSection

	local HeaderLine = Instance.new("Frame")
	HeaderLine.BackgroundColor3 = COL_BORDER
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Position = UDim2.new(0, 0, 1, -1)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.ZIndex = 2
	HeaderLine.Parent = TopSection

	-- Chấm màu theme nhỏ cạnh tiêu đề thay cho thanh chéo cũ
	local AccentDot = Instance.new("Frame")
	AccentDot.BackgroundColor3 = ThemeColor
	AccentDot.Position = UDim2.new(0, 24, 0, 26)
	AccentDot.Size = UDim2.new(0, 8, 0, 8)
	AccentDot.Parent = TopSection
	corner(AccentDot, RADIUS_PILL)

	local DragArea = Instance.new("Frame")
	DragArea.Name = "DragArea"
	DragArea.BackgroundTransparency = 1
	DragArea.Size = UDim2.new(1, -50, 1, 0)
	DragArea.Parent = TopSection

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 40, 0, 12)
	TitleLabel.Size = UDim2.new(1, -100, 0, 26)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = title
	TitleLabel.TextColor3 = COL_TEXT
	TitleLabel.TextSize = 20
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopSection

	local SubLabel = Instance.new("TextLabel")
	SubLabel.BackgroundTransparency = 1
	SubLabel.Position = UDim2.new(0, 40, 0, 38)
	SubLabel.Size = UDim2.new(1, -100, 0, 16)
	SubLabel.Font = Enum.Font.Gotham
	SubLabel.Text = subtitle
	SubLabel.TextColor3 = COL_TEXT_DIM
	SubLabel.TextSize = 12
	SubLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubLabel.Parent = TopSection

	-- Nút đóng
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "CloseButton"
	CloseBtn.AutoButtonColor = false
	CloseBtn.BackgroundColor3 = COL_BG_CARD
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Position = UDim2.new(1, -46, 0, 22)
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 110, 110)
	CloseBtn.TextSize = 15
	CloseBtn.Parent = TopSection
	corner(CloseBtn, RADIUS_SMALL)

	CloseBtn.MouseEnter:Connect(function()
		tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
		tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		tween(CloseBtn, {BackgroundColor3 = COL_BG_CARD}):Play()
		tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 110, 110)}):Play()
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		tween(MainFrame, {Size = UDim2.new(0, width, 0, 0)}, 0.18):Play()
		task.wait(0.18)
		ScreenGui:Destroy()
	end)

	MakeDragFromArea(MainFrame, DragArea)

	------------------------------------------------------------------
	-- SIDEBAR (thanh tab dạng icon dọc)
	------------------------------------------------------------------
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.BackgroundColor3 = COL_BG_SIDEBAR
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 74)
	Sidebar.Size = UDim2.new(0, 92, 1, -74)
	Sidebar.Parent = MainFrame

	local SidebarLine = Instance.new("Frame")
	SidebarLine.BackgroundColor3 = COL_BORDER
	SidebarLine.BorderSizePixel = 0
	SidebarLine.Position = UDim2.new(1, -1, 0, 0)
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Parent = Sidebar

	local SidebarList = Instance.new("UIListLayout")
	SidebarList.Parent = Sidebar
	SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarList.Padding = UDim.new(0, 8)
	SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local SidebarPadding = Instance.new("UIPadding")
	SidebarPadding.Parent = Sidebar
	SidebarPadding.PaddingTop = UDim.new(0, 12)
	SidebarPadding.PaddingLeft = UDim.new(0, 8)
	SidebarPadding.PaddingRight = UDim.new(0, 8)

	------------------------------------------------------------------
	-- VÙNG NỘI DUNG
	------------------------------------------------------------------
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.BackgroundColor3 = COL_BG_CONTENT
	ContentArea.BorderSizePixel = 0
	ContentArea.Position = UDim2.new(0, 92, 0, 74)
	ContentArea.Size = UDim2.new(1, -92, 1, -74)
	ContentArea.Parent = MainFrame

	------------------------------------------------------------------
	-- NÚT NỔI ẨN/HIỆN CỬA SỔ (góc màn hình)
	------------------------------------------------------------------
	local ToggleBtn = Instance.new("Frame")
	ToggleBtn.Name = "FloatingToggle"
	ToggleBtn.BackgroundColor3 = COL_BG_HEADER
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Position = UDim2.new(0, 16, 0, 16)
	ToggleBtn.Size = UDim2.new(0, 56, 0, 56)
	ToggleBtn.Parent = ScreenGui
	corner(ToggleBtn, UDim.new(0, 16))
	stroke(ToggleBtn, COL_BORDER, 1)

	local ToggleInner = Instance.new("Frame")
	ToggleInner.BackgroundColor3 = ThemeColor
	ToggleInner.BackgroundTransparency = 0.85
	ToggleInner.BorderSizePixel = 0
	ToggleInner.Size = UDim2.new(1, 0, 1, 0)
	ToggleInner.Parent = ToggleBtn
	corner(ToggleInner, UDim.new(0, 15))

	local ToggleClick = Instance.new("TextButton")
	ToggleClick.BackgroundTransparency = 1
	ToggleClick.Size = UDim2.new(1, 0, 1, 0)
	ToggleClick.Text = ""
	ToggleClick.AutoButtonColor = false
	ToggleClick.Parent = ToggleInner

	if toggleIcon then
		local ToggleImg = Instance.new("ImageLabel")
		ToggleImg.BackgroundTransparency = 1
		ToggleImg.Position = UDim2.new(0.5, -14, 0.5, -14)
		ToggleImg.Size = UDim2.new(0, 28, 0, 28)
		ToggleImg.Image = GetIcon(toggleIcon)
		ToggleImg.ImageColor3 = ThemeColor
		ToggleImg.Parent = ToggleInner
	else
		local ToggleText = Instance.new("TextLabel")
		ToggleText.BackgroundTransparency = 1
		ToggleText.Size = UDim2.new(1, 0, 1, 0)
		ToggleText.Font = Enum.Font.GothamBold
		ToggleText.Text = "◆"
		ToggleText.TextColor3 = ThemeColor
		ToggleText.TextSize = 26
		ToggleText.Parent = ToggleInner
	end

	local visible = true
	ToggleClick.MouseButton1Click:Connect(function()
		visible = not visible
		MainFrame.Visible = visible
	end)
	ToggleClick.MouseEnter:Connect(function()
		tween(ToggleInner, {BackgroundTransparency = 0.7}):Play()
	end)
	ToggleClick.MouseLeave:Connect(function()
		tween(ToggleInner, {BackgroundTransparency = 0.85}):Play()
	end)

	------------------------------------------------------------------
	-- ĐỐI TƯỢNG WINDOW TRẢ VỀ
	------------------------------------------------------------------
	local Window = {
		Tabs = {},
		ThemeColor = ThemeColor,
		MainFrame = MainFrame,
		ContentArea = ContentArea,
		ScreenGui = ScreenGui,
	}

	--==================================================================
	-- Window:AddTab({Title=, Icon=})  — API giống hệt bản gốc
	--==================================================================
	function Window:AddTab(cfg)
		cfg = cfg or {}
		local tabName = cfg.Title or "Tab"
		local tabIcon = cfg.Icon or "home"

		local TabBtn = Instance.new("TextButton")
		TabBtn.AutoButtonColor = false
		TabBtn.BackgroundColor3 = COL_BG_CARD
		TabBtn.BackgroundTransparency = 1
		TabBtn.BorderSizePixel = 0
		TabBtn.Size = UDim2.new(1, 0, 0, 60)
		TabBtn.Text = ""
		TabBtn.Parent = Sidebar
		corner(TabBtn, UDim.new(0, 14))

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Name = "TabIcon"
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0.5, -14, 0.5, -16)
		TabIcon.Size = UDim2.new(0, 28, 0, 28)
		TabIcon.Image = GetIcon(tabIcon)
		TabIcon.ImageColor3 = COL_TEXT_DIM
		TabIcon.Parent = TabBtn

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Name = "TabLabel"
		TabLabel.BackgroundTransparency = 1
		TabLabel.Position = UDim2.new(0, 0, 1, -16)
		TabLabel.Size = UDim2.new(1, 0, 0, 14)
		TabLabel.Font = Enum.Font.Gotham
		TabLabel.Text = tabName
		TabLabel.TextColor3 = COL_TEXT_DIM
		TabLabel.TextSize = 9
		TabLabel.TextTruncate = Enum.TextTruncate.AtEnd
		TabLabel.Parent = TabBtn

		-- Chỉ báo tab đang chọn (thanh dọc bên phải nút)
		local Indicator = Instance.new("Frame")
		Indicator.Name = "Indicator"
		Indicator.BackgroundColor3 = ThemeColor
		Indicator.BorderSizePixel = 0
		Indicator.AnchorPoint = Vector2.new(1, 0.5)
		Indicator.Position = UDim2.new(1, 2, 0.5, 0)
		Indicator.Size = UDim2.new(0, 3, 0, 0)
		Indicator.Parent = TabBtn
		corner(Indicator, RADIUS_PILL)

		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = tabName .. "Content"
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.ScrollBarThickness = 3
		TabContent.ScrollBarImageColor3 = ThemeColor
		TabContent.Visible = false
		TabContent.Parent = ContentArea

		local ContentList = Instance.new("UIListLayout")
		ContentList.Parent = TabContent
		ContentList.SortOrder = Enum.SortOrder.LayoutOrder
		ContentList.Padding = UDim.new(0, 10)

		local ContentPad = Instance.new("UIPadding")
		ContentPad.Parent = TabContent
		ContentPad.PaddingTop = UDim.new(0, 16)
		ContentPad.PaddingLeft = UDim.new(0, 16)
		ContentPad.PaddingRight = UDim.new(0, 16)
		ContentPad.PaddingBottom = UDim.new(0, 16)

		local Tab = {
			Name = tabName,
			Icon = tabIcon,
			Button = TabBtn,
			Content = TabContent,
			-- Lưu tham chiếu trực tiếp để đổi tab (ổn định hơn bản gốc,
			-- không cần dò FindFirstChild theo ClassName)
			_Icon = TabIcon,
			_Label = TabLabel,
			_Indicator = Indicator,
		}

		local function SelectTab()
			for _, t in ipairs(Window.Tabs) do
				t.Content.Visible = false
				t._Icon.ImageColor3 = COL_TEXT_DIM
				t._Label.TextColor3 = COL_TEXT_DIM
				tween(t.Button, {BackgroundTransparency = 1}, 0.15):Play()
				tween(t._Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15):Play()
			end
			TabContent.Visible = true
			TabIcon.ImageColor3 = ThemeColor
			TabLabel.TextColor3 = ThemeColor
			tween(TabBtn, {BackgroundTransparency = 0.85}, 0.15):Play()
			tween(Indicator, {Size = UDim2.new(0, 3, 0, 28)}, 0.2):Play()
		end

		TabBtn.MouseEnter:Connect(function()
			if not TabContent.Visible then
				tween(TabBtn, {BackgroundTransparency = 0.92}, 0.12):Play()
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if not TabContent.Visible then
				tween(TabBtn, {BackgroundTransparency = 1}, 0.12):Play()
			end
		end)
		TabBtn.MouseButton1Click:Connect(SelectTab)

		table.insert(Window.Tabs, Tab)

		if #Window.Tabs == 1 then
			SelectTab()
		end

		--================================================================
		-- Tab:AddSection(sname) — API giống hệt bản gốc
		--================================================================
		function Tab:AddSection(sname)
			local Section = {}

			local SectionFrame = Instance.new("Frame")
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.Parent = TabContent

			local SectionHead = Instance.new("TextLabel")
			SectionHead.BackgroundTransparency = 1
			SectionHead.Size = UDim2.new(1, 0, 0, 24)
			SectionHead.Font = Enum.Font.GothamBold
			SectionHead.Text = string.upper(sname)
			SectionHead.TextColor3 = ThemeColor
			SectionHead.TextSize = 11
			SectionHead.TextXAlignment = Enum.TextXAlignment.Left
			SectionHead.Parent = SectionFrame

			local SectionContent = Instance.new("Frame")
			SectionContent.BackgroundTransparency = 1
			SectionContent.BorderSizePixel = 0
			SectionContent.Position = UDim2.new(0, 0, 0, 26)
			SectionContent.Size = UDim2.new(1, 0, 0, 0)
			SectionContent.Parent = SectionFrame

			local ContentListLayout = Instance.new("UIListLayout")
			ContentListLayout.Parent = SectionContent
			ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentListLayout.Padding = UDim.new(0, 8)

			--============================================================
			-- Section:AddToggle(tname, opts) — {Text, Default, Callback}
			--============================================================
			function Section:AddToggle(tname, opts)
				opts = opts or {}
				local toggled = opts.Default or false

				local ToggleF = Instance.new("TextButton")
				ToggleF.AutoButtonColor = false
				ToggleF.BackgroundColor3 = COL_BG_CARD
				ToggleF.BorderSizePixel = 0
				ToggleF.Size = UDim2.new(1, 0, 0, 42)
				ToggleF.Text = ""
				ToggleF.Parent = SectionContent
				corner(ToggleF, RADIUS_CARD)
				stroke(ToggleF, COL_BORDER, 1, 0.4)

				local ToggleL = Instance.new("TextLabel")
				ToggleL.BackgroundTransparency = 1
				ToggleL.Position = UDim2.new(0, 14, 0, 0)
				ToggleL.Size = UDim2.new(1, -70, 1, 0)
				ToggleL.Font = Enum.Font.Gotham
				ToggleL.Text = opts.Text or tname
				ToggleL.TextColor3 = COL_TEXT
				ToggleL.TextSize = 13
				ToggleL.TextXAlignment = Enum.TextXAlignment.Left
				ToggleL.Parent = ToggleF

				local ToggleS = Instance.new("Frame")
				ToggleS.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
				ToggleS.BorderSizePixel = 0
				ToggleS.Position = UDim2.new(1, -54, 0.5, -11)
				ToggleS.Size = UDim2.new(0, 42, 0, 22)
				ToggleS.Parent = ToggleF
				corner(ToggleS, RADIUS_PILL)

				local ToggleInd = Instance.new("Frame")
				ToggleInd.BackgroundColor3 = Color3.fromRGB(120, 120, 128)
				ToggleInd.BorderSizePixel = 0
				ToggleInd.Position = UDim2.new(0, 2, 0.5, -9)
				ToggleInd.Size = UDim2.new(0, 18, 0, 18)
				ToggleInd.Parent = ToggleS
				corner(ToggleInd, RADIUS_PILL)

				local function UpdateToggle(state)
					toggled = state
					if toggled then
						tween(ToggleInd, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.18):Play()
						tween(ToggleS, {BackgroundColor3 = ThemeColor}, 0.18):Play()
					else
						tween(ToggleInd, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(120, 120, 128)}, 0.18):Play()
						tween(ToggleS, {BackgroundColor3 = Color3.fromRGB(45, 45, 52)}, 0.18):Play()
					end
					if opts.Callback then opts.Callback(toggled) end
				end

				ToggleF.MouseButton1Click:Connect(function()
					UpdateToggle(not toggled)
				end)
				ToggleF.MouseEnter:Connect(function()
					tween(ToggleF, {BackgroundColor3 = COL_BG_CARD_ALT}, 0.12):Play()
				end)
				ToggleF.MouseLeave:Connect(function()
					tween(ToggleF, {BackgroundColor3 = COL_BG_CARD}, 0.12):Play()
				end)

				-- Áp trạng thái mặc định (không gọi Callback lúc khởi tạo)
				if toggled then
					ToggleInd.Position = UDim2.new(1, -20, 0.5, -9)
					ToggleInd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ToggleS.BackgroundColor3 = ThemeColor
				end

				return {
					SetValue = function(_, v) UpdateToggle(v) end,
					GetValue = function(_) return toggled end,
				}
			end

			--============================================================
			-- Section:AddButton(bname, opts) — {Text, Callback}
			--============================================================
			function Section:AddButton(bname, opts)
				opts = opts or {}
				local Btn = Instance.new("TextButton")
				Btn.AutoButtonColor = false
				Btn.BackgroundColor3 = ThemeColor
				Btn.BackgroundTransparency = 0.15
				Btn.BorderSizePixel = 0
				Btn.Size = UDim2.new(1, 0, 0, 38)
				Btn.Font = Enum.Font.GothamSemibold
				Btn.Text = opts.Text or bname
				Btn.TextColor3 = COL_TEXT
				Btn.TextSize = 13
				Btn.Parent = SectionContent
				corner(Btn, RADIUS_CARD)

				Btn.MouseEnter:Connect(function()
					tween(Btn, {BackgroundTransparency = 0}, 0.15):Play()
				end)
				Btn.MouseLeave:Connect(function()
					tween(Btn, {BackgroundTransparency = 0.15}, 0.15):Play()
				end)
				Btn.MouseButton1Click:Connect(function()
					tween(Btn, {BackgroundTransparency = 0.4}, 0.08):Play()
					task.wait(0.08)
					tween(Btn, {BackgroundTransparency = 0}, 0.12):Play()
					if opts.Callback then opts.Callback() end
				end)

				return Btn
			end

			--============================================================
			-- Section:AddSlider(slname, opts) — {Min,Max,Default,Increment,Text,Callback}
			--============================================================
			function Section:AddSlider(slname, opts)
				opts = opts or {}
				local min = opts.Min or 0
				local max = opts.Max or 100
				local increment = opts.Increment or 1
				local val = opts.Default or min
				local labelText = opts.Text or slname

				local SliderF = Instance.new("Frame")
				SliderF.BackgroundColor3 = COL_BG_CARD
				SliderF.BorderSizePixel = 0
				SliderF.Size = UDim2.new(1, 0, 0, 66)
				SliderF.Parent = SectionContent
				corner(SliderF, RADIUS_CARD)
				stroke(SliderF, COL_BORDER, 1, 0.4)

				local SliderL = Instance.new("TextLabel")
				SliderL.BackgroundTransparency = 1
				SliderL.Position = UDim2.new(0, 14, 0, 8)
				SliderL.Size = UDim2.new(1, -70, 0, 18)
				SliderL.Font = Enum.Font.GothamSemibold
				SliderL.Text = labelText
				SliderL.TextColor3 = COL_TEXT
				SliderL.TextSize = 13
				SliderL.TextXAlignment = Enum.TextXAlignment.Left
				SliderL.Parent = SliderF

				local InputB = Instance.new("TextBox")
				InputB.BackgroundColor3 = COL_BG_CARD_ALT
				InputB.BorderSizePixel = 0
				InputB.Position = UDim2.new(1, -58, 0, 8)
				InputB.Size = UDim2.new(0, 44, 0, 18)
				InputB.Font = Enum.Font.Gotham
				InputB.Text = tostring(val)
				InputB.TextColor3 = ThemeColor
				InputB.TextSize = 12
				InputB.ClearTextOnFocus = false
				InputB.Parent = SliderF
				corner(InputB, RADIUS_SMALL)

				local SliderB = Instance.new("Frame")
				SliderB.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
				SliderB.BorderSizePixel = 0
				SliderB.Position = UDim2.new(0, 14, 0, 38)
				SliderB.Size = UDim2.new(1, -28, 0, 10)
				SliderB.Parent = SliderF
				corner(SliderB, RADIUS_PILL)

				local SliderFill = Instance.new("Frame")
				SliderFill.BackgroundColor3 = ThemeColor
				SliderFill.BorderSizePixel = 0
				SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
				SliderFill.Parent = SliderB
				corner(SliderFill, RADIUS_PILL)

				local Thumb = Instance.new("Frame")
				Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Thumb.BorderSizePixel = 0
				Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
				Thumb.Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0)
				Thumb.Size = UDim2.new(0, 14, 0, 14)
				Thumb.ZIndex = 2
				Thumb.Parent = SliderB
				corner(Thumb, RADIUS_PILL)
				stroke(Thumb, ThemeColor, 2)

				local dragging = false

				local function ApplyValue(newVal, fromDrag)
					val = math.clamp(newVal, min, max)
					local pct = (val - min) / (max - min)
					SliderFill.Size = UDim2.new(pct, 0, 1, 0)
					Thumb.Position = UDim2.new(pct, 0, 0.5, 0)
					SliderL.Text = labelText
					if not fromDrag then
						InputB.Text = tostring(val)
					else
						InputB.Text = tostring(val)
					end
					if opts.Callback then opts.Callback(val) end
				end

				local function UpdateFromInput(input)
					local pos = math.clamp((input.Position.X - SliderB.AbsolutePosition.X) / SliderB.AbsoluteSize.X, 0, 1)
					local newVal = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
					ApplyValue(newVal, true)
				end

				SliderB.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						UpdateFromInput(input)
					end
				end)
				Thumb.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						UpdateFromInput(input)
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateFromInput(input)
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				InputB.FocusLost:Connect(function()
					local v = tonumber(InputB.Text)
					if v then
						ApplyValue(v, false)
					else
						InputB.Text = tostring(val)
					end
				end)

				return {
					SetValue = function(_, v) ApplyValue(v, false) end,
					GetValue = function(_) return val end,
				}
			end

			--============================================================
			-- Section:AddDropdown(dname, opts) — {Items, Default, Callback}
			--============================================================
			function Section:AddDropdown(dname, opts)
				opts = opts or {}
				local items = opts.Items or {}
				local current = opts.Default or (items[1] or "None")

				local DropF = Instance.new("Frame")
				DropF.BackgroundColor3 = COL_BG_CARD
				DropF.BorderSizePixel = 0
				DropF.ClipsDescendants = true
				DropF.Size = UDim2.new(1, 0, 0, 40)
				DropF.Parent = SectionContent
				corner(DropF, RADIUS_CARD)
				stroke(DropF, COL_BORDER, 1, 0.4)

				local DropBtn = Instance.new("TextButton")
				DropBtn.BackgroundTransparency = 1
				DropBtn.Size = UDim2.new(1, 0, 0, 40)
				DropBtn.Text = ""
				DropBtn.Parent = DropF

				local DropL = Instance.new("TextLabel")
				DropL.BackgroundTransparency = 1
				DropL.Position = UDim2.new(0, 14, 0, 0)
				DropL.Size = UDim2.new(1, -46, 0, 40)
				DropL.Font = Enum.Font.Gotham
				DropL.Text = current
				DropL.TextColor3 = COL_TEXT
				DropL.TextSize = 13
				DropL.TextXAlignment = Enum.TextXAlignment.Left
				DropL.Parent = DropF

				local DropArrow = Instance.new("TextLabel")
				DropArrow.BackgroundTransparency = 1
				DropArrow.Position = UDim2.new(1, -32, 0, 0)
				DropArrow.Size = UDim2.new(0, 24, 0, 40)
				DropArrow.Font = Enum.Font.GothamBold
				DropArrow.Text = "▾"
				DropArrow.TextColor3 = ThemeColor
				DropArrow.TextSize = 14
				DropArrow.Parent = DropF

				local ItemC = Instance.new("Frame")
				ItemC.BackgroundTransparency = 1
				ItemC.BorderSizePixel = 0
				ItemC.Position = UDim2.new(0, 0, 0, 40)
				ItemC.Size = UDim2.new(1, 0, 0, 0)
				ItemC.Parent = DropF

				local ItemLayout = Instance.new("UIListLayout")
				ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ItemLayout.Parent = ItemC

				local isOpen = false

				local function SetOpen(open)
					isOpen = open
					local targetH = open and (40 + #items * 32) or 40
					tween(DropF, {Size = UDim2.new(1, 0, 0, targetH)}, 0.18):Play()
					tween(DropArrow, {Rotation = open and 180 or 0}, 0.18):Play()
				end

				DropBtn.MouseButton1Click:Connect(function()
					SetOpen(not isOpen)
				end)

				for i, item in ipairs(items) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.AutoButtonColor = false
					ItemBtn.BackgroundColor3 = COL_BG_CARD_ALT
					ItemBtn.BackgroundTransparency = 1
					ItemBtn.BorderSizePixel = 0
					ItemBtn.LayoutOrder = i
					ItemBtn.Size = UDim2.new(1, 0, 0, 32)
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.Text = "   " .. item
					ItemBtn.TextColor3 = COL_TEXT_DIM
					ItemBtn.TextSize = 12
					ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
					ItemBtn.Parent = ItemC

					ItemBtn.MouseButton1Click:Connect(function()
						current = item
						DropL.Text = item
						SetOpen(false)
						if opts.Callback then opts.Callback(item) end
					end)
					ItemBtn.MouseEnter:Connect(function()
						tween(ItemBtn, {BackgroundTransparency = 0}, 0.1):Play()
					end)
					ItemBtn.MouseLeave:Connect(function()
						tween(ItemBtn, {BackgroundTransparency = 1}, 0.1):Play()
					end)
				end

				return {
					SetValue = function(_, v) current = v; DropL.Text = v end,
					GetValue = function(_) return current end,
				}
			end

			--============================================================
			-- Section:AddTextBox(tbname, opts) — {Default, Text, Placeholder, Callback}
			--============================================================
			function Section:AddTextBox(tbname, opts)
				opts = opts or {}
				local text = opts.Default or ""

				local TBF = Instance.new("Frame")
				TBF.BackgroundColor3 = COL_BG_CARD
				TBF.BorderSizePixel = 0
				TBF.Size = UDim2.new(1, 0, 0, 64)
				TBF.Parent = SectionContent
				corner(TBF, RADIUS_CARD)
				stroke(TBF, COL_BORDER, 1, 0.4)

				local TBL = Instance.new("TextLabel")
				TBL.BackgroundTransparency = 1
				TBL.Position = UDim2.new(0, 14, 0, 8)
				TBL.Size = UDim2.new(1, -28, 0, 16)
				TBL.Font = Enum.Font.GothamSemibold
				TBL.Text = opts.Text or tbname
				TBL.TextColor3 = COL_TEXT
				TBL.TextSize = 12
				TBL.TextXAlignment = Enum.TextXAlignment.Left
				TBL.Parent = TBF

				local TB = Instance.new("TextBox")
				TB.BackgroundColor3 = COL_BG_CARD_ALT
				TB.BorderSizePixel = 0
				TB.Position = UDim2.new(0, 14, 0, 28)
				TB.Size = UDim2.new(1, -28, 0, 28)
				TB.Font = Enum.Font.Gotham
				TB.Text = text
				TB.PlaceholderText = opts.Placeholder or ""
				TB.PlaceholderColor3 = COL_TEXT_DIM
				TB.TextColor3 = ThemeColor
				TB.TextSize = 12
				TB.ClearTextOnFocus = false
				TB.Parent = TBF
				corner(TB, RADIUS_SMALL)

				local Underline = Instance.new("Frame")
				Underline.BackgroundColor3 = ThemeColor
				Underline.BorderSizePixel = 0
				Underline.Position = UDim2.new(0, 0, 1, -2)
				Underline.Size = UDim2.new(0, 0, 0, 2)
				Underline.Parent = TB
				corner(Underline, RADIUS_PILL)

				TB.Focused:Connect(function()
					tween(Underline, {Size = UDim2.new(1, 0, 0, 2)}, 0.15):Play()
				end)
				TB.FocusLost:Connect(function()
					tween(Underline, {Size = UDim2.new(0, 0, 0, 2)}, 0.15):Play()
					text = TB.Text
					if opts.Callback then opts.Callback(text) end
				end)

				return {
					SetValue = function(_, v) text = v; TB.Text = v end,
					GetValue = function(_) return text end,
				}
			end

			------------------------------------------------------------
			-- Tự động co giãn chiều cao Section theo nội dung bên trong
			------------------------------------------------------------
			local function UpdateSize()
				local h = 0
				for _, child in ipairs(SectionContent:GetChildren()) do
					if child:IsA("GuiObject") then
						h = h + child.AbsoluteSize.Y + 8
					end
				end
				SectionFrame.Size = UDim2.new(1, 0, 0, h + 26)
			end

			ContentListLayout.Changed:Connect(function()
				UpdateSize()
				TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
			end)
			ContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				UpdateSize()
				TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
			end)

			return Section
		end

		return Tab
	end

	return Window
end

return UI
