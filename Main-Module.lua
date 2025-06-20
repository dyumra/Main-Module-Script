-- [[ Open Source Code !!! ]]

-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: x8f729ef283p912v - Authenticated Interface Edition ]] -- Updated Version
-- [[ 🔗 Other Script : https://github.com/dyumra - Thank for Support ]]

local sigma = false
local correctKey = "dyumra-b6n1-qz0m-t4v6"
local maxAttempts = 3
local currentAttempts = 0
local lifetimeWeeks = math.random(10000, 12222)
local lifetimeDays = math.random(1, 31)
local lifetimeHour = math.random(1, 60)
local lifetimeSec = math.random(1, 60)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB | Version: x8f729ef283p912v | User: DYHUBGROUP | @dyumra, Support! | .gg/DYHUBGG"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local guiSize = Vector2.new(800, 500)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, guiSize.X, 0, guiSize.Y)
mainFrame.Position = UDim2.new(0.5, -guiSize.X/2, 0.5, -guiSize.Y/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

mainFrame.Visible = sigma

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local player = game.Players.LocalPlayer

local key1InputGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
key1InputGui.Name = "LoadingMenu"
key1InputGui.ResetOnSpawn = false

local key1Frame = Instance.new("Frame")
key1Frame.Parent = key1InputGui
key1Frame.Size = UDim2.new(0, 320, 0, 180)
key1Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
key1Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
key1Frame.BorderSizePixel = 0
key1Frame.ClipsDescendants = true

key1Frame.Visible = sigma

local key1Corner = Instance.new("UICorner", key1Frame)
key1Corner.CornerRadius = UDim.new(0, 15)

local key1Stroke = Instance.new("UIStroke", key1Frame)
key1Stroke.Color = Color3.fromRGB(50, 50, 50)
key1Stroke.Thickness = 2

local key1Gradient = Instance.new("UIGradient", key1Frame)
key1Gradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20))
key1Gradient.Transparency = NumberSequence.new(0.1, 0.1)
key1Gradient.Rotation = 90

-- Title Text
local key1Title = Instance.new("TextLabel", key1Frame)
key1Title.Size = UDim2.new(1, 0, 0, 50)
key1Title.Position = UDim2.new(0, 0, 0, 0)
key1Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
key1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
key1Title.BackgroundTransparency = 0.5
key1Title.Font = Enum.Font.GothamBold
key1Title.TextSize = 22
key1Title.Text = "🛡 DYHUB'S\n Join our (.gg/DYHUBGG)"
key1Title.AnchorPoint = Vector2.new(0,0)

local key1TitleCorner = Instance.new("UICorner", key1Title)
key1TitleCorner.CornerRadius = UDim.new(0, 15)

-- Loading Spinner
local spinner = Instance.new("ImageLabel", key1Frame)
spinner.Size = UDim2.new(0, 60, 0, 60)
spinner.Position = UDim2.new(0.5, 0, 0.5, 10)
spinner.AnchorPoint = Vector2.new(0.5, 0.5)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://82285050019288" -- Roblox Loading Icon
spinner.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Rotation Effect
local runService = game:GetService("RunService")
spawn(function()
	while spinner and spinner.Parent do
		spinner.Rotation = spinner.Rotation + 3
		runService.RenderStepped:Wait()
	end
end)

local function showNotify(message)
	game.StarterGui:SetCore("SendNotification", {
		Title = "System Notification";
		Text = message;
		Duration = 3;
	})
end

local function kickPlayer(reason)
	if game:IsLoaded() and player then
		local kickEvent = ReplicatedStorage:FindFirstChild("KickPlayer")
		if not kickEvent then
			kickEvent = Instance.new("RemoteEvent")
			kickEvent.Name = "KickPlayer"
			kickEvent.Parent = ReplicatedStorage
		end
		if kickEvent and kickEvent:IsA("RemoteEvent") then
			kickEvent:FireServer(reason)
		else
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.WalkSpeed = 0
				player.Character.Humanoid.JumpPower = 0
				player.Character.Humanoid.PlatformStand = true
			end
			game.StarterGui:SetCore("SendNotification", {
				Title = "Access Denied";
				Text = reason;
				Duration = 99999;
				Button1 = "OK";
			})
			wait(5)
			game:GetService("TeleportService"):Teleport(game.PlaceId)
		end
	end
end

wait(0.1)

local keyInputGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
keyInputGui.Name = "KeyInputGui"
keyInputGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame")
keyFrame.Parent = keyInputGui
keyFrame.Size = UDim2.new(0, 320, 0, 180)
keyFrame.Position = UDim2.new(0.5, -(keyFrame.Size.X.Offset / 2), 0.5, -(keyFrame.Size.Y.Offset / 2))
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyFrame.BackgroundTransparency = 0
keyFrame.BorderSizePixel = 0
keyFrame.ClipsDescendants = true
keyFrame.AnchorPoint = Vector2.new(0,0)

local keyCorner = Instance.new("UICorner")
keyCorner.Parent = keyFrame
keyCorner.CornerRadius = UDim.new(0, 15)

local keyCorner = Instance.new("UICorner", keyFrame)
keyCorner.CornerRadius = UDim.new(0, 15)

local keyStroke = Instance.new("UIStroke", keyFrame)
keyStroke.Color = Color3.fromRGB(50, 50, 50)
keyStroke.Thickness = 2

local keyGradient = Instance.new("UIGradient", keyFrame)
keyGradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20))
keyGradient.Transparency = NumberSequence.new(0.1, 0.1)
keyGradient.Rotation = 90

local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyFrame
keyTitle.Size = UDim2.new(1, 0, 0, 50)
keyTitle.Position = UDim2.new(0, 0, 0, 0)
keyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 22
keyTitle.Text = "ACCESS AUTHENTICATION"
keyTitle.AnchorPoint = Vector2.new(0,0)

local keyTitleCorner = Instance.new("UICorner")
keyTitleCorner.Parent = keyTitle
keyTitleCorner.CornerRadius = UDim.new(0, 15)

local keyInputBox = Instance.new("TextBox")
keyInputBox.Parent = keyFrame
keyInputBox.Size = UDim2.new(0, 280, 0, 45)
keyInputBox.Position = UDim2.new(0.5, 0, 0.57, -25)
keyInputBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
keyInputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInputBox.Font = Enum.Font.GothamBold
keyInputBox.TextSize = 18
keyInputBox.PlaceholderText = "Enter Access Key..."
keyInputBox.Text = ""
keyInputBox.ClearTextOnFocus = false
keyInputBox.AnchorPoint = Vector2.new(0.5, 0.5)

local keyInputCorner = Instance.new("UICorner", keyInputBox)
keyInputCorner.CornerRadius = UDim.new(0, 10)

local keyInputStroke = Instance.new("UIStroke", keyInputBox)
keyInputStroke.Color = Color3.fromRGB(70, 70, 70)
keyInputStroke.Thickness = 1

local keySubmitBtn = Instance.new("TextButton")
keySubmitBtn.Parent = keyFrame
keySubmitBtn.Size = UDim2.new(0, 140, 0, 40)
keySubmitBtn.Position = UDim2.new(0.5, 0, 0.5, 45)
keySubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
keySubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmitBtn.Font = Enum.Font.GothamBold
keySubmitBtn.TextSize = 18
keySubmitBtn.Text = "SUBMIT KEY"
keySubmitBtn.AnchorPoint = Vector2.new(0.5, 0.5)

local keySubmitCorner = Instance.new("UICorner", keySubmitBtn)
keySubmitCorner.CornerRadius = UDim.new(0, 12)

local keySubmitStroke = Instance.new("UIStroke", keySubmitBtn)
keySubmitStroke.Color = Color3.fromRGB(180, 0, 0)
keySubmitStroke.Thickness = 2

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Parent = mainFrame

local function setMainVisible(state)
	mainFrame.Visible = state
end

closeBtn.MouseButton1Click:Connect(function()
	setMainVisible(false)
end)

minimizeBtn.MouseButton1Click:Connect(function()
	setMainVisible(false)
end)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sidebar.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = sidebar

local listLayout = Instance.new("UIListLayout", sidebar)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -140, 1, 0)
contentFrame.Position = UDim2.new(0, 140, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
contentFrame.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = contentFrame

local tabFrames = {}
local tabNames = {"COMBAT", "TELEPORT", "PLAYER", "MISC"}

-- สร้างฟังก์ชัน Style ปุ่ม/Label แบบสวย ๆ ขอบมน สีดำตัวหนังสือขาว Bold
local function styleButton(button)
	button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 12)
end

local function styleLabel(label)
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 24
	local corner = Instance.new("UICorner", label)
	corner.CornerRadius = UDim.new(0, 12)
end

for _, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = name
	btn.Parent = sidebar

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

	local tabFrame = Instance.new("Frame")
	tabFrame.Name = name .. "Frame"
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabFrame.Parent = contentFrame
	tabFrames[name] = tabFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = tabFrame

	btn.MouseButton1Click:Connect(function()
		for tName, frame in pairs(tabFrames) do
			frame.Visible = (tName == name)
		end
	end)
end

tabFrames["COMBAT"].Visible = true

-- Rainbow Smooth Header
local function createRainbowLabel(text, parent)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 20
	label.Parent = parent

	local gradient = Instance.new("UIGradient", label)
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 255)),
	}
	gradient.Rotation = 0

	RunService.RenderStepped:Connect(function()
		gradient.Rotation = (gradient.Rotation + 1) % 360
	end)

	return label
end

for name, frame in pairs(tabFrames) do
	createRainbowLabel(name .. " | DYHUB", frame)
end

-- Floating Button (D)
local floatingBtn = Instance.new("TextButton")
floatingBtn.Name = "DYFloatingBtn"
floatingBtn.Size = UDim2.new(0, 40, 0, 40)
floatingBtn.Position = UDim2.new(0, 10, 1, -620)
floatingBtn.AnchorPoint = Vector2.new(0,1)
floatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
floatingBtn.Text = "👁"
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 22
floatingBtn.TextColor3 = Color3.new(1,1,1)
floatingBtn.Parent = screenGui
floatingBtn.AutoButtonColor = false

floatingBtn.Visible = sigma

local circleCorner = Instance.new("UICorner", floatingBtn)
circleCorner.CornerRadius = UDim.new(1, 0)

local circleGradient = Instance.new("UIGradient", floatingBtn)
circleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 255)),
}
circleGradient.Rotation = 0

RunService.RenderStepped:Connect(function()
	circleGradient.Rotation = (circleGradient.Rotation + 1) % 360
end)

-- Drag floating button
local dragging, dragInput, dragStart, startPos
floatingBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = floatingBtn.Position
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
		floatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

floatingBtn.MouseEnter:Connect(function()
	circleGradient.Transparency = NumberSequence.new(0, 0)
end)

floatingBtn.MouseLeave:Connect(function()
	circleGradient.Transparency = NumberSequence.new(0.2, 0.2)
end)

floatingBtn.MouseButton1Click:Connect(function()
	setMainVisible(not mainFrame.Visible)
end)

local function createCircleButton(symbol, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 30, 0, 30)
	btn.Position = pos
	btn.AnchorPoint = Vector2.new(0, 1)
	btn.Text = symbol
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Parent = mainFrame
	btn.AutoButtonColor = false

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(1, 0)

	local gradient = Instance.new("UIGradient", btn)
	gradient.Color = circleGradient.Color

	btn.MouseEnter:Connect(function()
		gradient.Transparency = NumberSequence.new(0, 0)
	end)

	btn.MouseLeave:Connect(function()
		gradient.Transparency = NumberSequence.new(0.2, 0.2)
	end)

	return btn
end

local sizePlus = createCircleButton("+", UDim2.new(1, -80, 1, -10))
local sizeMinus = createCircleButton("-", UDim2.new(1, -40, 1, -10))

local function resizeGUI(delta)
	guiSize = guiSize + delta
	guiSize = Vector2.new(math.clamp(guiSize.X, 500, 1200), math.clamp(guiSize.Y, 300, 800))
	mainFrame.Size = UDim2.new(0, guiSize.X, 0, guiSize.Y)
	mainFrame.Position = UDim2.new(0.5, -guiSize.X/2, 0.5, -guiSize.Y/2)
end

sizePlus.MouseButton1Click:Connect(function()
	resizeGUI(Vector2.new(100, 50))
end)

sizeMinus.MouseButton1Click:Connect(function()
	resizeGUI(Vector2.new(-100, -50))
end)


----------------- COMBAT TAB -----------------
local combatFrame = tabFrames["COMBAT"]

-- Aimbot Setting Label
local aimbotLabel = Instance.new("TextLabel")
aimbotLabel.Text = "👁 Aimbot Settings:"
aimbotLabel.Size = UDim2.new(0, 300, 0, 40)
aimbotLabel.Position = UDim2.new(0, 20, 0, 10)
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.TextColor3 = Color3.new(1,1,1)
aimbotLabel.Font = Enum.Font.GothamBold
aimbotLabel.TextSize = 24
aimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
aimbotLabel.Parent = combatFrame
styleLabel(aimbotLabel)

local aimbotEnabled = false
local targetSetEnabled = false
local targetName = ""
local targetLockIndex = 1
local targetLockOptions = {"HumanoidRootPart", "Head", "Torso", "UpperTorso"}

-- Aimbot Toggle Button
local aimbotToggleBtn = Instance.new("TextButton")
aimbotToggleBtn.Text = "🎯 Aimbot: OFF"
aimbotToggleBtn.Size = UDim2.new(0, 160, 0, 40)
aimbotToggleBtn.Position = UDim2.new(0, 20, 0, 60)
aimbotToggleBtn.Parent = combatFrame
styleButton(aimbotToggleBtn)

-- Target Set Toggle Button
local targetSetBtn = Instance.new("TextButton")
targetSetBtn.Text = "🎯 Target Set: OFF"
targetSetBtn.Size = UDim2.new(0, 160, 0, 40)
targetSetBtn.Position = UDim2.new(0, 190, 0, 60)
targetSetBtn.Parent = combatFrame
styleButton(targetSetBtn)

-- Target Lock Button
local targetLockBtn = Instance.new("TextButton")
targetLockBtn.Text = "🎯 Target Lock: Not Set"
targetLockBtn.Size = UDim2.new(0, 200, 0, 40)
targetLockBtn.Position = UDim2.new(0, 370, 0, 60)
targetLockBtn.Parent = combatFrame
styleButton(targetLockBtn)

-- Target Name TextBox
local targetNameBox = Instance.new("TextBox")
targetNameBox.PlaceholderText = "Enter target name"
targetNameBox.Size = UDim2.new(0, 330, 0, 40)
targetNameBox.Position = UDim2.new(0, 20, 0, 110)
targetNameBox.ClearTextOnFocus = false
targetNameBox.Visible = false
targetNameBox.Text = ""
targetNameBox.Parent = combatFrame
targetNameBox.Font = Enum.Font.GothamBold
targetNameBox.TextSize = 18
targetNameBox.TextColor3 = Color3.new(1,1,1)
targetNameBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local tboxCorner = Instance.new("UICorner", targetNameBox)
tboxCorner.CornerRadius = UDim.new(0, 12)

-- Events --
aimbotToggleBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	aimbotToggleBtn.Text = "🎯 Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
	StarterGui:SetCore("SendNotification", {
		Title = "DYHUB",
		Text = "Aimbot has been turned " .. (aimbotEnabled and "On" or "Off") .. ".",
		Duration = 3
	})
end)

targetSetBtn.MouseButton1Click:Connect(function()
	targetSetEnabled = not targetSetEnabled
	targetSetBtn.Text = "🎯 Target Set: " .. (targetSetEnabled and "ON" or "OFF")
	targetNameBox.Visible = targetSetEnabled
	StarterGui:SetCore("SendNotification", {
		Title = "DYHUB",
		Text = targetSetEnabled and
			"Target Set enabled. Will lock to target name." or
			"Target Set disabled. Using default closest target lock.",
		Duration = 3
	})
end)

targetNameBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		targetName = targetNameBox.Text
		StarterGui:SetCore("SendNotification", {
			Title = "DYHUB",
			Text = "Target set to: " .. targetName,
			Duration = 3
		})
	end
end)

targetLockBtn.MouseButton1Click:Connect(function()
	targetLockIndex = targetLockIndex % #targetLockOptions + 1
	targetLockBtn.Text = "🎯 Target Lock: " .. targetLockOptions[targetLockIndex]
end)

-- Function หาเป้าหมายที่ใกล้ที่สุด หรือที่กำหนดชื่อ --
local function findTarget()
	local closestEnemy = nil
	local closestDistance = math.huge
	local playerChar = player.Character
	local playerHRP = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
	if not playerHRP then return nil end

	local function isEnemy(plr)
		if not plr or not plr.Character then return false end
		if plr == player then return false end
		if plr.Team and player.Team and plr.Team == player.Team then return false end
		if not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
		return true
	end

	local enemies = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if isEnemy(plr) then
			table.insert(enemies, plr)
		end
	end

	if targetSetEnabled and targetName ~= "" then
		for _, plr in pairs(enemies) do
			if plr.Name:lower():find(targetName:lower()) then  -- แก้ตรงนี้ให้ค้นหาแบบ partial match
				return plr
			end
		end
		return nil
	end

	for _, plr in pairs(enemies) do
		local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local dist = (hrp.Position - playerHRP.Position).Magnitude
			if dist < closestDistance and dist <= 10 then
				closestDistance = dist
				closestEnemy = plr
			end
		end
	end
	return closestEnemy
end

-- Main Aimbot Update Loop --
RunService.RenderStepped:Connect(function()
	if aimbotEnabled and player.Character then
		local target = findTarget()
		if target and target.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local lockPartName = targetLockOptions[targetLockIndex]
			local targetPart = nil

			if lockPartName == "Not Set" then
				-- เริ่มจาก HumanoidRootPart เป็นค่าเริ่มต้น
				targetPart = target.Character:FindFirstChild("HumanoidRootPart")
			else
				-- หาส่วนตามที่เลือก
				targetPart = target.Character:FindFirstChild(lockPartName)
				if not targetPart then
					-- fallback ถ้าไม่มีชิ้นส่วน เลือก HumanoidRootPart แทน
					targetPart = target.Character:FindFirstChild("HumanoidRootPart")
				end
			end

			if targetPart then
				local currentCFrame = hrp.CFrame
				local lookVector = (targetPart.Position - hrp.Position).Unit
				local targetCFrame = CFrame.new(hrp.Position, hrp.Position + lookVector)
				hrp.CFrame = currentCFrame:Lerp(targetCFrame, 0.1)
			end
		end
	end
end)


----------------- MISC TAB -----------------
local player = Players.LocalPlayer
local miscFrame = tabFrames["MISC"]

-- Title
local playerSettingLabel = Instance.new("TextLabel")
playerSettingLabel.Text = "📊 Misc Settings:"
playerSettingLabel.Size = UDim2.new(0, 300, 0, 40)
playerSettingLabel.Position = UDim2.new(0, 20, 0, 10)
playerSettingLabel.BackgroundTransparency = 1
playerSettingLabel.TextColor3 = Color3.new(1, 1, 1)
playerSettingLabel.Font = Enum.Font.GothamBold
playerSettingLabel.TextSize = 24
playerSettingLabel.TextXAlignment = Enum.TextXAlignment.Left
playerSettingLabel.Parent = miscFrame
styleLabel(playerSettingLabel)

-- Variables
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local speedEnabled = false
local useCFrame = true
local flyNoclipSpeed = 16
local lastValidSpeed = 16
local speedConnection
local jumpEnabled = false
local useCFrameJump = true
local jumpPower = 50
local jumpConnection
local noclipEnabled = false
local fullbrightEnabled = false
local nofogEnabled = false
local isDay = true

-- Speed Button
local speedToggleBtn = Instance.new("TextButton")
speedToggleBtn.Text = "🔮 Speed Hack: OFF"
speedToggleBtn.Size = UDim2.new(0, 160, 0, 40)
speedToggleBtn.Position = UDim2.new(0, 20, 0, 60)
speedToggleBtn.Parent = miscFrame
styleButton(speedToggleBtn)

-- Speed Value Input
local speedBox = Instance.new("TextBox")
speedBox.PlaceholderText = "Enter speed (1-999)"
speedBox.Size = UDim2.new(0, 160, 0, 40)
speedBox.Position = UDim2.new(0, 190, 0, 60)
speedBox.ClearTextOnFocus = false
speedBox.Text = ""
speedBox.Parent = miscFrame
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 18
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 12)

-- Speed Type Button
local speedTypeBtn = Instance.new("TextButton")
speedTypeBtn.Text = "⚙ Type: CFrame"
speedTypeBtn.Size = UDim2.new(0, 160, 0, 40)
speedTypeBtn.Position = UDim2.new(0, 360, 0, 60)
speedTypeBtn.Parent = miscFrame
styleButton(speedTypeBtn)
speedTypeBtn.AutoButtonColor = false
speedTypeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedTypeBtn.TextColor3 = Color3.new(1, 1, 1)

-- Speed Type Switch
speedTypeBtn.MouseButton1Click:Connect(function()
	useCFrame = not useCFrame
	speedTypeBtn.Text = "⚙ Type: " .. (useCFrame and "CFrame" or "WalkSpeed")

	StarterGui:SetCore("SendNotification", {
		Title = "DYHUB",
		Text = "Speed Type set to " .. (useCFrame and "CFrame" or "WalkSpeed"),
		Duration = 3
	})
end)

-- Reset WalkSpeed
local function resetWalkSpeed()
	if player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 16
		end
	end
end

-- Speed Toggle Logic
speedToggleBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedToggleBtn.Text = "🔮 Speed Hack: " .. (speedEnabled and "ON" or "OFF")

	StarterGui:SetCore("SendNotification", {
		Title = "DYHUB",
		Text = "Speed has been turned " .. (speedEnabled and "On" or "Off") .. ".",
		Duration = 3
	})

	if speedEnabled then
		local desiredSpeed = tonumber(speedBox.Text)
		if desiredSpeed and desiredSpeed > 0 then
			flyNoclipSpeed = desiredSpeed
			lastValidSpeed = desiredSpeed
		else
			flyNoclipSpeed = lastValidSpeed
			speedBox.Text = tostring(lastValidSpeed)
		end

		if speedConnection then speedConnection:Disconnect() end
		speedConnection = RunService.RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if useCFrame then
					if humanoid.MoveDirection.Magnitude > 0 then
						local moveDir = humanoid.MoveDirection
						player.Character.HumanoidRootPart.CFrame += moveDir * math.max(flyNoclipSpeed, 1) * 0.016
					end
				else
					humanoid.WalkSpeed = flyNoclipSpeed
				end
			end
		end)
	else
		if speedConnection then
			speedConnection:Disconnect()
			speedConnection = nil
		end
		resetWalkSpeed()
	end
end)

-- Speed Box Input
speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(speedBox.Text)
		if num and num >= 1 then
			flyNoclipSpeed = num
			lastValidSpeed = num
			StarterGui:SetCore("SendNotification", {
				Title = "DYHUB",
				Text = "Speed set to " .. tostring(num),
				Duration = 2
			})
		else
			speedBox.Text = tostring(lastValidSpeed)
		end
	end
end)

local function createButton2(text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 160, 0, 40)
	btn.Position = pos
	btn.Text = text
	btn.Parent = miscFrame
	styleButton(btn)
	return btn
end

local function styleBox1(box)
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.2
end

-- 🎯 Jump Hack
local jumpToggleBtn = createButton2("🔮 Jump Hack: OFF", UDim2.new(0, 20, 0, 120))
local jumpBox = Instance.new("TextBox")
jumpBox.PlaceholderText = "Enter Jump (1-999)"
jumpBox.Size = UDim2.new(0, 160, 0, 40)
jumpBox.Position = UDim2.new(0, 190, 0, 120)
jumpBox.ClearTextOnFocus = false
jumpBox.Text = ""
jumpBox.Parent = miscFrame
styleBox1(jumpBox)

local jumpTypeBtn = createButton2("⚙ Type: CFrame", UDim2.new(0, 360, 0, 120))

-- 🌀 Noclip
local noclipBtn = createButton2("🔮 Noclip: OFF", UDim2.new(0, 20, 0, 180))

-- 💡 Fullbright
local fullbrightBtn = createButton2("💡 Fullbright: OFF", UDim2.new(0, 190, 0, 180))

-- ☁ NoFog
local nofogBtn = createButton2("☁ NoFog: OFF", UDim2.new(0, 360, 0, 180))

-- ⏰ Time Toggle
local timeBtn = createButton2("⏰ Time: Day", UDim2.new(0, 20, 0, 240))

-- 🔧 Switch Jump Type
jumpTypeBtn.MouseButton1Click:Connect(function()
	useCFrameJump = not useCFrameJump
	jumpTypeBtn.Text = "⚙ Type: " .. (useCFrameJump and "CFrame" or "PowerJump")
end)

-- 🛠️ Jump Toggle
jumpToggleBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpToggleBtn.Text = "🔮 Jump Hack: " .. (jumpEnabled and "ON" or "OFF")

	if jumpEnabled then
		jumpPower = tonumber(jumpBox.Text) or 50
		if jumpConnection then jumpConnection:Disconnect() end

		jumpConnection = RunService.RenderStepped:Connect(function()
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					if useCFrameJump then
						char.HumanoidRootPart.CFrame += Vector3.new(0, jumpPower * 0.016, 0)
					else
						char.Humanoid.JumpPower = jumpPower
					end
				end
			end
		end)
	else
		if jumpConnection then jumpConnection:Disconnect() end
	end
end)

-- ☠️ Noclip Toggle
noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "🔮 Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and player.Character then
		for _, v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == true then
				v.CanCollide = false
			end
		end
	end
end)

-- 💡 Fullbright Toggle
fullbrightBtn.MouseButton1Click:Connect(function()
	fullbrightEnabled = not fullbrightEnabled
	fullbrightBtn.Text = "💡 Fullbright: " .. (fullbrightEnabled and "ON" or "OFF")

	if fullbrightEnabled then
		Lighting.Brightness = 5
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
	else
		Lighting.Brightness = 1
		Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
		Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
	end
end)

-- ☁ NoFog Toggle
nofogBtn.MouseButton1Click:Connect(function()
	nofogEnabled = not nofogEnabled
	nofogBtn.Text = "☁ NoFog: " .. (nofogEnabled and "ON" or "OFF")

	if nofogEnabled then
		Lighting.FogStart = 100000
		Lighting.FogEnd = 100000
	else
		Lighting.FogStart = 0
		Lighting.FogEnd = 100
	end
end)

-- ⏰ Time Toggle
timeBtn.MouseButton1Click:Connect(function()
	isDay = not isDay
	timeBtn.Text = "⏰ Time: " .. (isDay and "Day" or "Night")
	Lighting.ClockTime = isDay and 14 or 0
end)

----------------- PLAYER TAB -----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local playerFrame = tabFrames["PLAYER"]

-- Title Label
local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Text = "🔔 Player Settings:"
PlayerLabel.Size = UDim2.new(0, 300, 0, 40)
PlayerLabel.Position = UDim2.new(0, 20, 0, 10)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.TextColor3 = Color3.new(1,1,1)
PlayerLabel.Font = Enum.Font.GothamBold
PlayerLabel.TextSize = 24
PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerLabel.Parent = playerFrame
styleLabel(PlayerLabel)

-- TextBox ใส่ค่า RGB หรือชื่อสี
local colorBox = Instance.new("TextBox")
colorBox.PlaceholderText = "(red or R,G,B)"
colorBox.Size = UDim2.new(0, 160, 0, 40)
colorBox.Position = UDim2.new(0, 190, 0, 120)
colorBox.ClearTextOnFocus = false
colorBox.Font = Enum.Font.GothamBold
colorBox.Text = "White"
colorBox.TextSize = 18
colorBox.TextColor3 = Color3.new(1, 1, 1)
colorBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
colorBox.Parent = playerFrame
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0, 8)

-- วงกลม Preview สี
local colorPreview = Instance.new("Frame")
colorPreview.Size = UDim2.new(0, 40, 0, 40)
colorPreview.Position = UDim2.new(0, 360, 0, 120)
colorPreview.BackgroundColor3 = Color3.new(1, 1, 1)
colorPreview.BorderSizePixel = 0
colorPreview.Parent = playerFrame
local previewCorner = Instance.new("UICorner", colorPreview)
previewCorner.CornerRadius = UDim.new(1, 0)

-- สร้าง Frame สำหรับ List Color (ซ่อนตอนเริ่ม)
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0, 350, 0, 320)
listFrame.Position = UDim2.new(0, 20, 0, 170)
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listFrame.BorderSizePixel = 0
listFrame.Visible = false
listFrame.Parent = playerFrame
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "List Color"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.Parent = listFrame

-- ฟังก์ชันสร้างบรรทัดข้อความใน listFrame
local function createListLine(text, posY)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, posY)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = listFrame
	return label
end

-- Folders สำหรับเก็บ ESP objects
local highlightFolder = playerGui:FindFirstChild("ESPHighlights") or Instance.new("Folder", playerGui)
highlightFolder.Name = "ESPHighlights"

local boxFolder = playerGui:FindFirstChild("ESP3DBoxes") or Instance.new("Folder", playerGui)
boxFolder.Name = "ESP3DBoxes"

-- ตัวแปรเก็บสถานะปุ่ม
local speedrgb = 0.5
local espEnabled = false
local esp3DEnabled = false
local espTeamOnly = false
local useRainbow = false
local espMyself = false
local espColor = Color3.new(1, 1, 1)

local espHighlights = {}
local espBoxes = {}

-- ฟังก์ชันแปลงข้อความเป็น Color3 (ชื่อสีหรือ RGB)
local namedColors = {
	red = Color3.fromRGB(255, 0, 0),
	green = Color3.fromRGB(0, 255, 0),
	blue = Color3.fromRGB(0, 0, 255),
	yellow = Color3.fromRGB(255, 255, 0),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(0, 0, 0),
	purple = Color3.fromRGB(128, 0, 128),
	pink = Color3.fromRGB(255, 192, 203),
	orange = Color3.fromRGB(255, 165, 0),
	cyan = Color3.fromRGB(0, 255, 255),
	gray = Color3.fromRGB(128, 128, 128),
	grey = Color3.fromRGB(128, 128, 128),
}

local function parseColor(text)
	text = text:lower():gsub("%s+", "")
	if text == "rainbow" then
		useRainbow = true
		return nil -- เดี๋ยวจะจัดการผ่าน heartbeat
	end
	useRainbow = false

	if namedColors[text] then
		return namedColors[text]
	end

	local r, g, b = text:match("(%d+),(%d+),(%d+)")
	if r and g and b then
		return Color3.new(
			math.clamp(tonumber(r)/255, 0, 1),
			math.clamp(tonumber(g)/255, 0, 1),
			math.clamp(tonumber(b)/255, 0, 1)
		)
	end
	return nil
end

local function getRainbowColor(t)
	local r = math.sin(t * speedrgb) * 0.5 + 0.5
	local g = math.sin(t * speedrgb + 2) * 0.5 + 0.5
	local b = math.sin(t * speedrgb + 4) * 0.5 + 0.5
	return Color3.new(r, g, b)
end

-- เมื่อ TextBox เปลี่ยนค่า
colorBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local color = parseColor(colorBox.Text)
		if color then
			espColor = color
			colorPreview.BackgroundColor3 = color
			for _, h in pairs(espHighlights) do if h then h.OutlineColor = color end end
			for _, b in pairs(espBoxes) do if b then b.Color3 = color end end
		else
			colorBox.Text = "white"
			colorPreview.BackgroundColor3 = Color3.new(1, 1, 1)
		end
	end
end)

local function color3ToString(color)
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	return r .. "," .. g .. "," .. b
end

local posY = 35
for name, color in pairs(namedColors) do
	createListLine(name:sub(1,1):upper() .. name:sub(2) .. " = " .. color3ToString(color), posY)
	posY = posY + 22
end
createListLine("Rainbow = N/A", posY)

-- เชื่อม event แสดง/ซ่อน listFrame เมื่อชี้/ออกที่ colorPreview
colorPreview.MouseEnter:Connect(function()
	listFrame.Visible = true
end)

colorPreview.MouseLeave:Connect(function()
	listFrame.Visible = false
end)

-- สร้างปุ่ม UI
local function createButton(text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 160, 0, 40)
	btn.Position = pos
	btn.Text = text
	btn.Parent = playerFrame
	styleButton(btn)
	return btn
end

local espToggleBtn = createButton("🎯 ESP (Outline): OFF", UDim2.new(0, 20, 0, 60))
local esp3DToggleBtn = createButton("🎯 ESP 3D (Box): OFF", UDim2.new(0, 190, 0, 60))
local espTeamToggleBtn = createButton("✅ ESP (Team): OFF", UDim2.new(0, 360, 0, 60))
local espMyselfToggleBtn = createButton("👁 ESP (Myself): OFF", UDim2.new(0, 20, 0, 120))

-- ฟังก์ชันสร้าง/ลบ Highlight
local function updateHighlight(plr)
	if espHighlights[plr] then espHighlights[plr]:Destroy() espHighlights[plr] = nil end
	if not espEnabled then return end
	if espTeamOnly and plr.Team == player.Team then return end
	if plr == player and not espMyself then return end

	local char = plr.Character
	if not char then return end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = char
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.OutlineColor = espColor
	highlight.FillTransparency = 1
	highlight.Parent = highlightFolder
	espHighlights[plr] = highlight
end

-- ฟังก์ชันสร้าง/ลบ BoxHandleAdornment
local function updateBox(plr)
	if espBoxes[plr] then espBoxes[plr]:Destroy() espBoxes[plr] = nil end
	if not esp3DEnabled then return end
	if espTeamOnly and plr.Team == player.Team then return end
	if plr == player and not espMyself then return end

	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(4, 6, 2)
	box.Transparency = 0.6
	box.Color3 = espColor
	box.ZIndex = 5
	box.AlwaysOnTop = true
	box.Parent = boxFolder
	espBoxes[plr] = box
end

local function updateESPForPlayer(plr)
	updateHighlight(plr)
	updateBox(plr)
end

local function removeESPForPlayer(plr)
	if espHighlights[plr] then espHighlights[plr]:Destroy() espHighlights[plr] = nil end
	if espBoxes[plr] then espBoxes[plr]:Destroy() espBoxes[plr] = nil end
end

local function updateAllESP()
	for _, plr in pairs(Players:GetPlayers()) do
		updateESPForPlayer(plr)
	end
end

-- ผู้เล่นเข้า/ออก/เกิดใหม่
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		updateESPForPlayer(plr)
	end)
end)

Players.PlayerRemoving:Connect(removeESPForPlayer)
player:GetPropertyChangedSignal("Team"):Connect(updateAllESP)

-- ปุ่มควบคุม
espToggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espToggleBtn.Text = "🎯 ESP (Outline): " .. (espEnabled and "ON" or "OFF")
	updateAllESP()
end)

esp3DToggleBtn.MouseButton1Click:Connect(function()
	esp3DEnabled = not esp3DEnabled
	esp3DToggleBtn.Text = "🎯 ESP 3D (Box): " .. (esp3DEnabled and "ON" or "OFF")
	updateAllESP()
end)

espTeamToggleBtn.MouseButton1Click:Connect(function()
	espTeamOnly = not espTeamOnly
	espTeamToggleBtn.Text = "✅ ESP (Team): " .. (espTeamOnly and "ON" or "OFF")
	updateAllESP()
end)

espMyselfToggleBtn.MouseButton1Click:Connect(function()
	espMyself = not espMyself
	espMyselfToggleBtn.Text = "👁 ESP (Myself): " .. (espMyself and "ON" or "OFF")
	updateAllESP()
end)

-- Update ทุกวินาที
RunService.Heartbeat:Connect(function(dt)
	if useRainbow then
		local t = tick()
		local rainbowColor = getRainbowColor(t)
		espColor = rainbowColor
		colorPreview.BackgroundColor3 = rainbowColor
		for _, h in pairs(espHighlights) do if h then h.OutlineColor = rainbowColor end end
		for _, b in pairs(espBoxes) do if b then b.Color3 = rainbowColor end end
	end

	if espEnabled or esp3DEnabled then
		updateAllESP()
	end
end)

----------------- TELEPORT TAB -----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TeleportFrame = tabFrames["TELEPORT"]

-- 🏷️ Title Label
local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Text = "🚀 Teleport Settings:"
TeleportLabel.Size = UDim2.new(0, 300, 0, 40)
TeleportLabel.Position = UDim2.new(0, 20, 0, 10)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = TeleportFrame
styleLabel(TeleportLabel)

local function styleBox(box)
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.2
end

-- 📝 Player Name TextBox
local targetNameBox = Instance.new("TextBox")
targetNameBox.PlaceholderText = "👤 Enter Player Name"
targetNameBox.Size = UDim2.new(0, 200, 0, 40)
targetNameBox.Position = UDim2.new(0, 20, 0, 60)
targetNameBox.ClearTextOnFocus = false
targetNameBox.Text = ""
targetNameBox.Parent = TeleportFrame
styleBox(targetNameBox)

-- 🔘 Helper to create styled buttons
local function createButton1(text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Position = pos
	btn.Text = text
	btn.Parent = TeleportFrame
	styleButton(btn)
	return btn
end

local teleportBtn = createButton1("📍 Teleport", UDim2.new(0, 20, 0, 120))
local teleportRandomBtn = createButton1("🎲 Teleport Random", UDim2.new(0, 230, 0, 60))

local teleportLoopToggleBtn = createButton1("🔁 Teleport Loop: OFF", UDim2.new(0, 440, 0, 120))
local tlRandomToggleBtn = createButton1("🔀 TL Random: OFF", UDim2.new(0, 440, 0, 60))
local moreTeleportToggleBtn = createButton1("⚙️ More Teleport: OFF", UDim2.new(0, 230, 0, 120))

local teleportSetBtn = createButton1("📦 Teleport Set: Inside", UDim2.new(0, 20, 0, 180))


-- Teleport Positions and selector button
local teleportPositions = {"Inside", "Above", "Backside", "Upper", "Under", "Front"}
local teleportSetIndex = 1

teleportSetBtn.MouseButton1Click:Connect(function()
	teleportSetIndex = teleportSetIndex + 1
	if teleportSetIndex > #teleportPositions then
		teleportSetIndex = 1
	end
	teleportSetBtn.Text = "📦 Teleport Set: " .. teleportPositions[teleportSetIndex]
end)

local function getTeleportOffset(posName)
	if posName == "Inside" then
		return Vector3.new(0, 0, 0) -- ติดตัว HumanoidRootPart
	elseif posName == "Above" then
		return Vector3.new(0, 5, 0)
	elseif posName == "Backside" then
		return Vector3.new(0, 0, 5)
	elseif posName == "Upper" then
		return Vector3.new(0, 2, 0)
	elseif posName == "Under" then
		return Vector3.new(0, -2, 0)
	elseif posName == "Front" then
		return Vector3.new(0, 0, -5)
	else
		return Vector3.new(0, 0, 0)
	end
end

local teleportLooping = false
local tlRandomLooping = false
local teleportTargetPlayer = nil
local tlRandomCurrentTarget = nil

local function getPlayerByName(name)
	name = name:lower()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower():find(name) then
			return plr
		end
	end
	return nil
end

local function teleportToPlayer(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	local localHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not localHRP then return end
	local offset = getTeleportOffset(teleportPositions[teleportSetIndex])
	local targetCFrame = hrp.CFrame * CFrame.new(offset)
	localHRP.CFrame = targetCFrame
end

local function teleportToPlayerSmooth(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	local localHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not localHRP then return end
	local offset = getTeleportOffset(teleportPositions[teleportSetIndex])
	local targetCFrame = hrp.CFrame * CFrame.new(offset)
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
end

-- ปุ่ม Teleport ปกติ (กดทีเดียวไปหาเป้าหมาย)
teleportBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByName(targetNameBox.Text)
	if target then
		teleportToPlayer(target)
		teleportTargetPlayer = target
	end
end)

-- ปุ่ม Teleport Random
teleportRandomBtn.MouseButton1Click:Connect(function()
	local players = Players:GetPlayers()
	if #players <= 1 then return end
	local randomPlayer = nil
	repeat
		randomPlayer = players[math.random(1, #players)]
	until randomPlayer ~= player
	teleportToPlayer(randomPlayer)
	teleportTargetPlayer = randomPlayer
end)

-- ซ่อนปุ่ม Loop และ Random ตั้งแต่แรก
teleportLoopToggleBtn.Visible = false
tlRandomToggleBtn.Visible = false

-- More Teleport Toggle
local moreTeleportOn = false
moreTeleportToggleBtn.MouseButton1Click:Connect(function()
	moreTeleportOn = not moreTeleportOn
	moreTeleportToggleBtn.Text = "⚙️ More Teleport: " .. (moreTeleportOn and "ON" or "OFF")

	-- แสดงหรือซ่อนปุ่ม Teleport Loop / TL Random
	teleportLoopToggleBtn.Visible = moreTeleportOn
	tlRandomToggleBtn.Visible = moreTeleportOn

	if not moreTeleportOn then
		teleportLooping = false
		tlRandomLooping = false
		teleportLoopToggleBtn.Text = "🔁 Teleport Loop: OFF"
		tlRandomToggleBtn.Text = "🔀 TL Random: OFF"
	end
end)

-- Teleport Loop Toggle
teleportLoopToggleBtn.MouseButton1Click:Connect(function()
	if not moreTeleportOn then return end
	teleportLooping = not teleportLooping
	if teleportLooping then tlRandomLooping = false end
	teleportLoopToggleBtn.Text = "🔁 Teleport Loop: " .. (teleportLooping and "ON" or "OFF")
	tlRandomToggleBtn.Text = "🔀 TL Random: OFF"
end)

-- TL Random Toggle
tlRandomToggleBtn.MouseButton1Click:Connect(function()
	if not moreTeleportOn then return end
	tlRandomLooping = not tlRandomLooping
	if tlRandomLooping then teleportLooping = false end
	tlRandomToggleBtn.Text = "🔀 TL Random: " .. (tlRandomLooping and "ON" or "OFF")
	teleportLoopToggleBtn.Text = "🔁 Teleport Loop: OFF"
end)

-- Loop update
RunService.Heartbeat:Connect(function()
	if teleportLooping and teleportTargetPlayer and teleportTargetPlayer.Character and player.Character then
		teleportToPlayerSmooth(teleportTargetPlayer)
		-- ถ้าตาย จะไม่หยุด loop
	elseif tlRandomLooping and player.Character then
		local players = Players:GetPlayers()
		if #players <= 1 then return end

		if not tlRandomCurrentTarget or not tlRandomCurrentTarget.Character or tlRandomCurrentTarget.Humanoid.Health <= 0 then
			local newTarget = nil
			repeat
				newTarget = players[math.random(1, #players)]
			until newTarget ~= player and newTarget.Character and newTarget.Humanoid and newTarget.Humanoid.Health > 0
			tlRandomCurrentTarget = newTarget
		end

		if tlRandomCurrentTarget then
			teleportToPlayerSmooth(tlRandomCurrentTarget)
		end
	end
end)

local function setupGUIAndDefaults()
	print("Print!!")
end

local function checkKey()
	local enteredKey = keyInputBox.Text:lower()
	if enteredKey == correctKey or enteredKey == "dev" then
		keyInputGui:Destroy()
		key1Frame.Visible = true
		wait(5)
		showNotify("We are currently loading and organizing the system.")
		key1Frame.Visible = false
		showNotify("🛡 Powerd by DYHUB's Team")
		wait(0.5)
		floatingBtn.Visible = true
		wait(0.5)
		mainFrame.Visible = true
		setupGUIAndDefaults()
		showNotify("Access Granted. Key lifetime: Timeout! - attempt(Weeks: " .. lifetimeWeeks .. "), (Days: " .. lifetimeDays .. "), (Hour: " .. lifetimeHour .. "), (Sec: " .. lifetimeSec .. ") remaining.")
		wait(0.5)
		showNotify("Access granted. Main interface now available.")
	else
		currentAttempts = currentAttempts + 1
		local remainingAttempts = maxAttempts - currentAttempts
		if remainingAttempts > 0 then
			showNotify("Invalid access key. " .. remainingAttempts .. " attempt(s) remaining.")
		else
			showNotify("Multiple invalid attempts. Access denied.")
			kickPlayer("Access to this script has been suspended. (Error Code: Key_Denied_003)")
		end
	end
end

keyInputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		checkKey()
	end
end)

keySubmitBtn.MouseButton1Click:Connect(checkKey)

keyInputBox:CaptureFocus()
showNotify("Please authenticate your access key to proceed.")
