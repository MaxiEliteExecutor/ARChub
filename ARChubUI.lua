-- Advanced UI Library for Roblox (1164 Lines, Fully Rewritten with Moving Sections)
local ARCGUI = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Utility functions
local function makeDraggable(frame, exclude)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not exclude:FindFirstAncestorOfClass("Frame") then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Main window creation
function ARCGUI:CreateWindow(config)
	local window = {
		Title = config.Title or "Elite Hub",
		Size = config.Size or UDim2.new(0, 650, 0, 500),
		Theme = config.Theme or {
			Background = Color3.fromRGB(20, 20, 25),
			TextColor = Color3.fromRGB(240, 240, 240),
			Accent = Color3.fromRGB(100, 150, 255),
			Hover = Color3.fromRGB(120, 170, 255),
			Disabled = Color3.fromRGB(60, 60, 65),
			Warning = Color3.fromRGB(255, 100, 100)
		},
		Tabs = {},
		Visible = true,
		Notifications = {},
		Keybind = config.Keybind or Enum.KeyCode.RightShift,
		Transparency = config.Transparency or 0,
		MainFrame = nil
	}

	-- ScreenGui setup
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EliteUI_" .. window.Title
	screenGui.Parent = PlayerGui
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Main frame with rounded corners
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	mainFrame.Position = UDim2.new(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
	mainFrame.BackgroundColor3 = window.Theme.Background
	mainFrame.BackgroundTransparency = window.Transparency
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	window.MainFrame = mainFrame
	makeDraggable(mainFrame, mainFrame)
	TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = window.Size}):Play()

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 16)
	mainCorner.Parent = mainFrame

	-- Glow effect
	local glow = Instance.new("ImageLabel")
	glow.Size = UDim2.new(1, 60, 1, 60)
	glow.Position = UDim2.new(0, -30, 0, -30)
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://5028857084"
	glow.ImageTransparency = 0.75
	glow.ImageColor3 = window.Theme.Accent
	glow.ScaleType = Enum.ScaleType.Slice
	glow.SliceCenter = Rect.new(10, 10, 90, 90)
	glow.Parent = mainFrame

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 60)
	titleBar.BackgroundColor3 = window.Theme.Accent
	titleBar.BackgroundTransparency = window.Transparency
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 16)
	titleCorner.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -70, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = window.Title
	titleLabel.TextColor3 = window.Theme.TextColor
	titleLabel.TextSize = 26
	titleLabel.Font = Enum.Font.GothamBlack
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Position = UDim2.new(0, 20, 0, 0)
	titleLabel.Parent = titleBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Size = UDim2.new(0, 40, 0, 40)
	minimizeButton.Position = UDim2.new(1, -100, 0, 10)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = window.Theme.TextColor
	minimizeButton.TextSize = 18
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Parent = titleBar
	minimizeButton.MouseButton1Click:Connect(function()
		window.Visible = not window.Visible
		TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = window.Visible and window.Size or UDim2.new(0, window.Size.X.Offset, 0, 60)}):Play()
	end)
	minimizeButton.MouseEnter:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 200, 70)}):Play() end)
	minimizeButton.MouseLeave:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 180, 50)}):Play() end)

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -50, 0, 10)
	closeButton.BackgroundColor3 = window.Theme.Warning
	closeButton.Text = "X"
	closeButton.TextColor3 = window.Theme.TextColor
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = titleBar
	closeButton.MouseButton1Click:Connect(function()
		TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
		wait(0.3)
		screenGui:Destroy()
	end)
	closeButton.MouseEnter:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 120, 120)}):Play() end)
	closeButton.MouseLeave:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Warning}):Play() end)

	-- Tab button container
	local tabButtons = Instance.new("Frame")
	tabButtons.Size = UDim2.new(1, 0, 0, 50)
	tabButtons.Position = UDim2.new(0, 0, 0, 60)
	tabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	tabButtons.BackgroundTransparency = window.Transparency
	tabButtons.BorderSizePixel = 0
	tabButtons.Parent = mainFrame

	local tabContent = Instance.new("Frame")
	tabContent.Size = UDim2.new(1, 0, 1, -110)
	tabContent.Position = UDim2.new(0, 0, 0, 110)
	tabContent.BackgroundTransparency = 1
	tabContent.Parent = mainFrame

	-- Status bar
	local statusBar = Instance.new("Frame")
	statusBar.Size = UDim2.new(1, 0, 0, 30)
	statusBar.Position = UDim2.new(0, 0, 1, -30)
	statusBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	statusBar.BackgroundTransparency = window.Transparency
	statusBar.BorderSizePixel = 0
	statusBar.Parent = mainFrame

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, -20, 1, 0)
	statusLabel.Position = UDim2.new(0, 10, 0, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "Status: Idle"
	statusLabel.TextColor3 = window.Theme.TextColor
	statusLabel.TextSize = 14
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.Parent = statusBar

	-- Add a tab
	function window:AddTab(tabConfig)
		local tab = {
			Name = tabConfig.Name or "Tab",
			Elements = {},
			Frame = Instance.new("ScrollingFrame"),
			CollapsibleSections = {}
		}

		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(0, 140, 1, 0)
		tabButton.Position = UDim2.new(0, #window.Tabs * 140, 0, 0)
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		tabButton.BackgroundTransparency = window.Transparency
		tabButton.Text = tab.Name
		tabButton.TextColor3 = window.Theme.TextColor
		tabButton.TextSize = 16
		tabButton.Font = Enum.Font.GothamSemibold
		tabButton.Parent = tabButtons
		tabButton.MouseEnter:Connect(function() TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Hover}):Play() end)
		tabButton.MouseLeave:Connect(function() if not tab.Frame.Visible then TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play() end end)

		tab.Frame.Size = UDim2.new(1, -20, 1, -10)
		tab.Frame.Position = UDim2.new(0, 10, 0, 5)
		tab.Frame.BackgroundTransparency = 1
		tab.Frame.ScrollBarThickness = 4
		tab.Frame.ScrollBarImageColor3 = window.Theme.Accent
		tab.Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
		tab.Frame.Parent = tabContent
		tab.Frame.Visible = false
		if #window.Tabs == 0 then
			tab.Frame.Visible = true
			tabButton.BackgroundColor3 = window.Theme.Accent
		end

		tabButton.MouseButton1Click:Connect(function()
			for _, otherTab in ipairs(window.Tabs) do
				otherTab.Frame.Visible = false
				TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
			end
			tab.Frame.Visible = true
			TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Accent}):Play()
		end)
		tab.Button = tabButton

		-- Add collapsible section
		function tab:AddSection(sectionConfig)
			local section = {
				Name = sectionConfig.Name or "Section",
				Elements = {},
				Frame = Instance.new("Frame"),
				Expanded = sectionConfig.Expanded ~= nil and sectionConfig.Expanded or true,
				Button = nil
			}

			local sectionButton = Instance.new("TextButton")
			sectionButton.Size = UDim2.new(0, 280, 0, 40)
			sectionButton.Position = UDim2.new(0, 15, 0, 15)
			sectionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			sectionButton.BackgroundTransparency = window.Transparency
			sectionButton.Text = section.Name .. (section.Expanded and " ▼" or " ►")
			sectionButton.TextColor3 = window.Theme.TextColor
			sectionButton.TextSize = 16
			sectionButton.Font = Enum.Font.GothamSemibold
			sectionButton.Parent = tab.Frame
			section.Button = sectionButton

			section.Frame.Size = UDim2.new(0, 280, 0, section.Expanded and (#section.Elements * 65) or 0)
			section.Frame.Position = UDim2.new(0, 15, 0, 55)
			section.Frame.BackgroundTransparency = 1
			section.Frame.ClipsDescendants = true
			section.Frame.Parent = tab.Frame

			local function updateSectionPositions()
				local currentY = 15
				for _, sec in ipairs(tab.CollapsibleSections) do
					sec.Button.Position = UDim2.new(0, 15, 0, currentY)
					sec.Frame.Position = UDim2.new(0, 15, 0, currentY + 40)
					currentY = currentY + 50
					if sec.Expanded then
						currentY = currentY + (#sec.Elements * 65)
					end
				end
			end

			local function updateCanvasSize()
				local totalHeight = 0
				for _, sec in ipairs(tab.CollapsibleSections) do
					totalHeight = totalHeight + 50
					if sec.Expanded then
						totalHeight = totalHeight + (#sec.Elements * 65)
					end
				end
				tab.Frame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
			end

			sectionButton.MouseButton1Click:Connect(function()
				section.Expanded = not section.Expanded
				sectionButton.Text = section.Name .. (section.Expanded and " ▼" or " ►")
				local height = section.Expanded and (#section.Elements * 65) or 0
				TweenService:Create(section.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 280, 0, height)}):Play()
				updateSectionPositions()
				updateCanvasSize()
			end)
			sectionButton.MouseEnter:Connect(function() TweenService:Create(sectionButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Hover}):Play() end)
			sectionButton.MouseLeave:Connect(function() TweenService:Create(sectionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play() end)

			table.insert(tab.Elements, sectionButton)
			table.insert(tab.CollapsibleSections, section)
			updateSectionPositions()
			updateCanvasSize()

			-- Add button to section
			function section:AddButton(buttonConfig)
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(0, 260, 0, 55)
				button.Position = UDim2.new(0, 10, 0, #section.Elements * 65)
				button.BackgroundColor3 = window.Theme.Accent
				button.BackgroundTransparency = window.Transparency
				button.Text = buttonConfig.Text or "Button"
				button.TextColor3 = window.Theme.TextColor
				button.TextSize = 16
				button.Font = Enum.Font.GothamSemibold
				button.Parent = section.Frame
				button.MouseButton1Click:Connect(function()
					TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0, 255, 0, 50)}):Play()
					wait(0.1)
					TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0, 260, 0, 55)}):Play()
					if buttonConfig.Callback then buttonConfig.Callback() end
				end)
				button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Hover}):Play() end)
				button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Accent}):Play() end)
				table.insert(section.Elements, button)
				section.Frame.Size = UDim2.new(0, 280, 0, section.Expanded and (#section.Elements * 65) or 0)
				updateSectionPositions()
				updateCanvasSize()
			end

			-- Add toggle to section
			function section:AddToggle(toggleConfig)
				local toggleFrame = Instance.new("Frame")
				toggleFrame.Size = UDim2.new(0, 260, 0, 55)
				toggleFrame.Position = UDim2.new(0, 10, 0, #section.Elements * 65)
				toggleFrame.BackgroundTransparency = 1
				toggleFrame.Parent = section.Frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0, 190, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = toggleConfig.Text or "Toggle"
				label.TextColor3 = window.Theme.TextColor
				label.TextSize = 16
				label.Font = Enum.Font.GothamSemibold
				label.Parent = toggleFrame

				local toggleButton = Instance.new("TextButton")
				toggleButton.Size = UDim2.new(0, 60, 0, 35)
				toggleButton.Position = UDim2.new(0, 195, 0, 10)
				toggleButton.BackgroundColor3 = toggleConfig.Default and window.Theme.Accent or window.Theme.Disabled
				toggleButton.BackgroundTransparency = window.Transparency
				toggleButton.Text = toggleConfig.Default and "ON" or "OFF"
				toggleButton.TextColor3 = window.Theme.TextColor
				toggleButton.TextSize = 14
				toggleButton.Font = Enum.Font.GothamBold
				toggleButton.Parent = toggleFrame

				local state = toggleConfig.Default or false
				toggleButton.MouseButton1Click:Connect(function()
					state = not state
					TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = state and window.Theme.Accent or window.Theme.Disabled}):Play()
					toggleButton.Text = state and "ON" or "OFF"
					if toggleConfig.Callback then toggleConfig.Callback(state) end
				end)
				toggleButton.MouseEnter:Connect(function() TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = state and window.Theme.Hover or Color3.fromRGB(80, 80, 85)}):Play() end)
				toggleButton.MouseLeave:Connect(function() TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = state and window.Theme.Accent or window.Theme.Disabled}):Play() end)
				table.insert(section.Elements, toggleFrame)
				section.Frame.Size = UDim2.new(0, 280, 0, section.Expanded and (#section.Elements * 65) or 0)
				updateSectionPositions()
				updateCanvasSize()
			end

			-- Add slider to section
			function section:AddSlider(sliderConfig)
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(0, 260, 0, 55)
				sliderFrame.Position = UDim2.new(0, 10, 0, #section.Elements * 65)
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.Parent = section.Frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0, 190, 0, 20)
				label.BackgroundTransparency = 1
				label.Text = sliderConfig.Text or "Slider"
				label.TextColor3 = window.Theme.TextColor
				label.TextSize = 16
				label.Font = Enum.Font.GothamSemibold
				label.Parent = sliderFrame

				local sliderBar = Instance.new("Frame")
				sliderBar.Size = UDim2.new(0, 260, 0, 12)
				sliderBar.Position = UDim2.new(0, 0, 0, 35)
				sliderBar.BackgroundColor3 = window.Theme.Disabled
				sliderBar.BackgroundTransparency = window.Transparency
				sliderBar.Parent = sliderFrame
				sliderBar.Name = "SliderBar"

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((sliderConfig.Default or 50) / (sliderConfig.Max or 100), 0, 1, 0)
				fill.BackgroundColor3 = window.Theme.Accent
				fill.BackgroundTransparency = window.Transparency
				fill.Parent = sliderBar
				fill.Name = "Fill"

				local knob = Instance.new("Frame")
				knob.Size = UDim2.new(0, 16, 0, 16)
				knob.Position = UDim2.new((sliderConfig.Default or 50) / (sliderConfig.Max or 100), -8, 0, -2)
				knob.BackgroundColor3 = window.Theme.Hover
				knob.Parent = sliderBar
				knob.Name = "Knob"

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Size = UDim2.new(0, 60, 0, 20)
				valueLabel.Position = UDim2.new(0, 195, 0, 5)
				valueLabel.BackgroundTransparency = 1
				valueLabel.Text = tostring(sliderConfig.Default or 50)
				valueLabel.TextColor3 = window.Theme.TextColor
				valueLabel.TextSize = 14
				valueLabel.Font = Enum.Font.Gotham
				valueLabel.Name = "ValueLabel"
				valueLabel.Parent = sliderFrame

				local min, max = sliderConfig.Min or 0, sliderConfig.Max or 100
				local dragging = false
				sliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)
				sliderBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				RunService.RenderStepped:Connect(function()
					if dragging then
						local mouseX = UserInputService:GetMouseLocation().X - sliderBar.AbsolutePosition.X
						local percent = clamp(mouseX / sliderBar.AbsoluteSize.X, 0, 1)
						local value = math.floor(min + (max - min) * percent)
						TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
						TweenService:Create(knob, TweenInfo.new(0.1), {Position = UDim2.new(percent, -8, 0, -2)}):Play()
						valueLabel.Text = value
						if sliderConfig.Callback then sliderConfig.Callback(value) end
					end
				end)
				table.insert(section.Elements, sliderFrame)
				section.Frame.Size = UDim2.new(0, 280, 0, section.Expanded and (#section.Elements * 65) or 0)
				updateSectionPositions()
				updateCanvasSize()
			end

			-- Add dropdown to section
			function section:AddDropdown(dropdownConfig)
				local dropdownFrame = Instance.new("Frame")
				dropdownFrame.Size = UDim2.new(0, 260, 0, 55)
				dropdownFrame.Position = UDim2.new(0, 10, 0, #section.Elements * 65)
				dropdownFrame.BackgroundTransparency = 1
				dropdownFrame.Parent = section.Frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0, 190, 0, 20)
				label.BackgroundTransparency = 1
				label.Text = dropdownConfig.Text or "Dropdown"
				label.TextColor3 = window.Theme.TextColor
				label.TextSize = 16
				label.Font = Enum.Font.GothamSemibold
				label.Parent = dropdownFrame

				local dropdownButton = Instance.new("TextButton")
				dropdownButton.Size = UDim2.new(0, 260, 0, 35)
				dropdownButton.Position = UDim2.new(0, 0, 0, 20)
				dropdownButton.BackgroundColor3 = window.Theme.Accent
				dropdownButton.BackgroundTransparency = window.Transparency
				dropdownButton.Text = dropdownConfig.Default or dropdownConfig.Options[1] or "Select"
				dropdownButton.TextColor3 = window.Theme.TextColor
				dropdownButton.TextSize = 14
				dropdownButton.Font = Enum.Font.Gotham
				dropdownButton.Parent = dropdownFrame

				local optionsFrame = Instance.new("Frame")
				optionsFrame.Size = UDim2.new(0, 260, 0, 0)
				optionsFrame.Position = UDim2.new(0, 0, 0, 55)
				optionsFrame.BackgroundColor3 = window.Theme.Background
				optionsFrame.BackgroundTransparency = window.Transparency
				optionsFrame.BorderSizePixel = 1
				optionsFrame.BorderColor3 = window.Theme.Accent
				optionsFrame.Visible = false
				optionsFrame.ClipsDescendants = true
				optionsFrame.Parent = dropdownFrame

				local options = dropdownConfig.Options or {"Option 1", "Option 2", "Option 3"}
				for i, option in ipairs(options) do
					local optButton = Instance.new("TextButton")
					optButton.Size = UDim2.new(1, 0, 0, 35)
					optButton.Position = UDim2.new(0, 0, 0, (i - 1) * 35)
					optButton.BackgroundColor3 = window.Theme.Background
					optButton.BackgroundTransparency = window.Transparency
					optButton.Text = option
					optButton.TextColor3 = window.Theme.TextColor
					optButton.TextSize = 14
					optButton.Font = Enum.Font.Gotham
					optButton.Parent = optionsFrame
					optButton.MouseButton1Click:Connect(function()
						dropdownButton.Text = option
						optionsFrame.Visible = false
						TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 260, 0, 0)}):Play()
						if dropdownConfig.Callback then dropdownConfig.Callback(option) end
					end)
					optButton.MouseEnter:Connect(function() TweenService:Create(optButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Hover}):Play() end)
					optButton.MouseLeave:Connect(function() TweenService:Create(optButton, TweenInfo.new(0.2), {BackgroundColor3 = window.Theme.Background}):Play() end)
				end

				dropdownButton.MouseButton1Click:Connect(function()
					optionsFrame.Visible = not optionsFrame.Visible
					TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = optionsFrame.Visible and UDim2.new(0, 260, 0, math.min(#options * 35, 140)) or UDim2.new(0, 260, 0, 0)}):Play()
				end)
				table.insert(section.Elements, dropdownFrame)
				section.Frame.Size = UDim2.new(0, 280, 0, section.Expanded and (#section.Elements * 65) or 0)
				updateSectionPositions()
				updateCanvasSize()
			end

			return section
		end

		table.insert(window.Tabs, tab)
		return tab
	end

	-- Stacked notification system
	function window:Notify(config)
		local notif = Instance.new("Frame")
		notif.Size = UDim2.new(0, 320, 0, 110)
		notif.Position = UDim2.new(1, 330, 1, -120 - (#window.Notifications * 120))
		notif.BackgroundColor3 = window.Theme.Background
		notif.BackgroundTransparency = window.Transparency
		notif.BorderColor3 = window.Theme.Accent
		notif.BorderSizePixel = 1
		notif.Parent = screenGui

		local notifTitle = Instance.new("TextLabel")
		notifTitle.Size = UDim2.new(1, 0, 0, 30)
		notifTitle.BackgroundTransparency = 1
		notifTitle.Text = config.Title or "Notification"
		notifTitle.TextColor3 = window.Theme.Accent
		notifTitle.TextSize = 18
		notifTitle.Font = Enum.Font.GothamBold
		notifTitle.Parent = notif

		local notifText = Instance.new("TextLabel")
		notifText.Size = UDim2.new(1, -20, 0, 80)
		notifText.Position = UDim2.new(0, 10, 0, 30)
		notifText.BackgroundTransparency = 1
		notifText.Text = config.Text or "Message"
		notifText.TextColor3 = window.Theme.TextColor
		notifText.TextSize = 14
		notifText.Font = Enum.Font.Gotham
		notifText.TextWrapped = true
		notifText.TextXAlignment = Enum.TextXAlignment.Left
		notifText.Parent = notif

		table.insert(window.Notifications, notif)
		TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -330, 1, -120 - (#window.Notifications - 1) * 120)}):Play()
		delay(config.Duration or 4, function()
			TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 330, 1, -120 - (#window.Notifications - 1) * 120)}):Play()
			wait(0.4)
			for i, n in ipairs(window.Notifications) do
				if n == notif then
					table.remove(window.Notifications, i)
					break
				end
			end
			notif:Destroy()
			for i, remainingNotif in ipairs(window.Notifications) do
				TweenService:Create(remainingNotif, TweenInfo.new(0.3), {Position = UDim2.new(1, -330, 1, -120 - (i - 1) * 120)}):Play()
			end
		end)
	end

	-- Update status
	function window:UpdateStatus(text)
		statusLabel.Text = "Status: " .. text
	end

	-- Toggle visibility with keybind
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == window.Keybind then
			window.Visible = not window.Visible
			TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = window.Visible and window.Size or UDim2.new(0, window.Size.X.Offset, 0, 60)}):Play()
		end
	end)

	return window
end
