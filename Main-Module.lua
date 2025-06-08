-- [[ Open Source Code !!! ]]

-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: 2.19.5 - Authenticated Interface Edition ]] -- Updated Version
-- [[ 🔗 Other Script : https://github.com/dyumra - Thank for Support ]]

local Players = game:GetService("Players") [cite: 30]
local RunService = game:GetService("RunService") [cite: 30]
local UserInputService = game:GetService("UserInputService") [cite: 30]
local TweenService = game:GetService("TweenService") [cite: 30]
local player = Players.LocalPlayer [cite: 30]
local Camera = workspace.CurrentCamera [cite: 30]
local ReplicatedStorage = game:GetService("ReplicatedStorage") [cite: 30]

local aimbot = false [cite: 30]
local esp = false [cite: 30]
local espTeamCheck = false [cite: 30]
local esp3D = false -- New: ESP 3D toggle 
local esp3DTeamCheck = false -- New: ESP 3D team check toggle 
local killAll = false [cite: 30]
local hitbox = false [cite: 30]
local hitboxSize = 15 [cite: 30]
local hitboxTransparency = 0.7 [cite: 31]
local teamCheckHitbox = false [cite: 31]
local currentAimbotTarget = nil [cite: 31]
local teleportTarget = nil [cite: 31]
local teleportInterval = 0.15 [cite: 31]
local teleportTimer = 0 [cite: 31]
local lockParts = {"None", "Head", "Torso", "UpperTorso", "HumanoidRootPart"} [cite: 31]
local originalWalkSpeeds = {} [cite: 31]
local appliedHitboxes = {} [cite: 31]
local appliedESP3DBoxes = {} -- New: Table to store applied ESP 3D boxes 

local noclip = false -- New: Noclip toggle 
local originalCanCollide = {} -- New: Store original CanCollide states for noclip 

local headless = false -- New: Headless toggle 
local originalHeadTransparency = nil [cite: 31]
local originalFaceTransparency = nil [cite: 31]

local speedEnabled = false -- New: Speed toggle
local flyNoclipSpeed = 30 -- Default speed
local lastValidSpeed = 30 -- Stores the last valid speed input
local speedConnection = nil -- RunService connection for speed movement

local currentLockPartIndex = 1 [cite: 31]
local lockset = lockParts[currentLockPartIndex] [cite: 31]

local TELEPORT_OFFSET_DISTANCE = 1.5 [cite: 31]
local TELEPORT_VERTICAL_OFFSET = 0 [cite: 31]

local AIMBOT_SWITCH_DISTANCE = 8 [cite: 31]

local correctKey = "dyumra-k3b7-wp9d-a2n8" [cite: 31]
local maxAttempts = 3 [cite: 31]
local currentAttempts = 0 [cite: 31]
-- time lifetime 
(random values, not truly functional for a real lifetime system) [cite: 32]
local lifetimeWeeks = math.random(10000, 12222) [cite: 32]
local lifetimeDays = math.random(1, 31) [cite: 32]
local lifetimeHour = math.random(1, 60) [cite: 32]
local lifetimeSec = math.random(1, 60) [cite: 32]

local function detectLockSet(character) [cite: 32]
	if character:FindFirstChild("Torso") then [cite: 32]
		return "Torso" [cite: 32]
	elseif character:FindFirstChild("UpperTorso") then [cite: 32]
		return "UpperTorso" [cite: 32]
	elseif character:FindFirstChild("HumanoidRootPart") then [cite: 32]
		return "HumanoidRootPart" [cite: 32]
	elseif character:FindFirstChild("Head") then [cite: 32]
		return "Head" [cite: 32]
	else [cite: 32]
		return nil [cite: 32]
	end [cite: 32]
end [cite: 32]

local function showNotify(message) [cite: 32]
	game.StarterGui:SetCore("SendNotification", { [cite: 32]
		Title = "System Notification"; [cite: 32]
		Text = message; [cite: 33]
		Duration = 3; [cite: 33]
	}) [cite: 33]
end [cite: 33]

local function kickPlayer(reason) [cite: 33]
	if game:IsLoaded() and player then [cite: 33]
		local kickEvent = ReplicatedStorage:FindFirstChild("KickPlayer") [cite: 33]
		if kickEvent and kickEvent:IsA("RemoteEvent") then [cite: 33]
			kickEvent:FireServer(reason) [cite: 33]
		else [cite: 33]
			if player.Character and player.Character:FindFirstChild("Humanoid") then [cite: 33]
				player.Character.Humanoid.WalkSpeed = 0 [cite: 33]
				player.Character.Humanoid.JumpPower = 0 [cite: 33]
				player.Character.Humanoid.PlatformStand = true [cite: 33]
			end [cite: 33]
			game.StarterGui:SetCore("SendNotification", { [cite: 33]
				Title = "Access Denied"; [cite: 33]
				Text = reason; [cite: 33]
				Duration = 99999; [cite: 33]
				Button1 = "OK"; [cite: 33]
			}) [cite: 33]
			wait(5) [cite: 33]
			game:GetService("TeleportService"):Teleport(game.PlaceId) [cite: 33]
		end [cite: 33]
	end [cite: 33]
end [cite: 33]

wait(0.1) [cite: 33]

local keyInputGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) [cite: 33]
keyInputGui.Name = "KeyInputGui" [cite: 33]
keyInputGui.ResetOnSpawn = false [cite: 33]

local keyFrame = Instance.new("Frame") [cite: 33]
keyFrame.Parent = keyInputGui [cite: 33]
keyFrame.Size = UDim2.new(0, 320, 0, 180) [cite: 33]
keyFrame.Position = UDim2.new(0.5, -(keyFrame.Size.X.Offset / 2), 0.5, -(keyFrame.Size.Y.Offset / 2)) [cite: 33]
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) [cite: 33]
keyFrame.BackgroundTransparency = 0 [cite: 34]
keyFrame.BorderSizePixel = 0 [cite: 34]
keyFrame.ClipsDescendants = true [cite: 34]
keyFrame.AnchorPoint = Vector2.new(0,0) [cite: 34]

local keyCorner = Instance.new("UICorner") [cite: 34]
keyCorner.Parent = keyFrame [cite: 34]
keyCorner.CornerRadius = UDim.new(0, 15) [cite: 34]

local keyCorner = Instance.new("UICorner", keyFrame) [cite: 34]
keyCorner.CornerRadius = UDim.new(0, 15) [cite: 34]

local keyStroke = Instance.new("UIStroke", keyFrame) [cite: 34]
keyStroke.Color = Color3.fromRGB(50, 50, 50) [cite: 34]
keyStroke.Thickness = 2 [cite: 34]

local keyGradient = Instance.new("UIGradient", keyFrame) [cite: 34]
keyGradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20)) [cite: 34]
keyGradient.Transparency = NumberSequence.new(0.1, 0.1) [cite: 34]
keyGradient.Rotation = 90 [cite: 34]

local keyTitle = Instance.new("TextLabel") [cite: 34]
keyTitle.Parent = keyFrame [cite: 34]
keyTitle.Size = UDim2.new(1, 0, 0, 50) [cite: 34]
keyTitle.Position = UDim2.new(0, 0, 0, 0) [cite: 34]
keyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40) [cite: 34]
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 34]
keyTitle.Font = Enum.Font.GothamBold [cite: 34]
keyTitle.TextSize = 22 [cite: 34]
keyTitle.Text = "ACCESS AUTHENTICATION" [cite: 34]
keyTitle.AnchorPoint = Vector2.new(0,0) [cite: 34]

local keyTitleCorner = Instance.new("UICorner") [cite: 34]
keyTitleCorner.Parent = keyTitle [cite: 34]
keyTitleCorner.CornerRadius = UDim.new(0, 15) [cite: 34]

local keyInputBox = Instance.new("TextBox") [cite: 34]
keyInputBox.Parent = keyFrame [cite: 34]
keyInputBox.Size = UDim2.new(0, 280, 0, 45) [cite: 34]
keyInputBox.Position = UDim2.new(0.5, 0, 0.57, -25) [cite: 34]
keyInputBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55) [cite: 34]
keyInputBox.TextColor3 = Color3.fromRGB(200, 200, 200) [cite: 34]
keyInputBox.Font = Enum.Font.GothamBold [cite: 34]
keyInputBox.TextSize = 18 [cite: 34]
keyInputBox.PlaceholderText = "Enter Access Key..." [cite: 34]
keyInputBox.ClearTextOnFocus = false [cite: 34]
keyInputBox.AnchorPoint = Vector2.new(0.5, 0.5) [cite: 34]

local keyInputCorner = Instance.new("UICorner", keyInputBox) [cite: 35]
keyInputCorner.CornerRadius = UDim.new(0, 10) [cite: 35]

local keyInputStroke = Instance.new("UIStroke", keyInputBox) [cite: 35]
keyInputStroke.Color = Color3.fromRGB(70, 70, 70) [cite: 35]
keyInputStroke.Thickness = 1 [cite: 35]

local keySubmitBtn = Instance.new("TextButton") [cite: 35]
keySubmitBtn.Parent = keyFrame [cite: 35]
keySubmitBtn.Size = UDim2.new(0, 140, 0, 40) [cite: 35]
keySubmitBtn.Position = UDim2.new(0.5, 0, 0.5, 45) [cite: 35]
keySubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) [cite: 35]
keySubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 35]
keySubmitBtn.Font = Enum.Font.GothamBold [cite: 35]
keySubmitBtn.TextSize = 18 [cite: 35]
keySubmitBtn.Text = "SUBMIT KEY" [cite: 35]
keySubmitBtn.AnchorPoint = Vector2.new(0.5, 0.5) [cite: 35]

local keySubmitCorner = Instance.new("UICorner", keySubmitBtn) [cite: 35]
keySubmitCorner.CornerRadius = UDim.new(0, 12) [cite: 35]

local keySubmitStroke = Instance.new("UIStroke", keySubmitBtn) [cite: 35]
keySubmitStroke.Color = Color3.fromRGB(180, 0, 0) [cite: 35]
keySubmitStroke.Thickness = 2 [cite: 35]

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) [cite: 35]
screenGui.Name = "AimbotESPGui" [cite: 36]
screenGui.ResetOnSpawn = false [cite: 36]

local mainFrame = Instance.new("Frame") [cite: 36]
mainFrame.Parent = screenGui [cite: 36]
mainFrame.Size = UDim2.new(0, 600, 0, 400) -- Wider and shorter for the new UI 
mainFrame.Position = UDim2.new(0.5, -(mainFrame.Size.X.Offset / 2), 0.5, -(mainFrame.Size.Y.Offset / 2)) -- Center the frame 
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) [cite: 36]
mainFrame.BackgroundTransparency = 0 [cite: 36]
mainFrame.BorderSizePixel = 0 [cite: 36]
mainFrame.ClipsDescendants = true [cite: 36]
mainFrame.AnchorPoint = Vector2.new(0.5,0.5) -- Set AnchorPoint to center for easier positioning
mainFrame.Active = true [cite: 36]
mainFrame.Draggable = true [cite: 36]
mainFrame.Visible = false [cite: 36]

local corner = Instance.new("UICorner", mainFrame) [cite: 36]
corner.CornerRadius = UDim.new(0, 12) [cite: 36]

local mainStroke = Instance.new("UIStroke", mainFrame) [cite: 36]
mainStroke.Color = Color3.fromRGB(40, 40, 40) [cite: 36]
mainStroke.Thickness = 2 [cite: 36]

local mainGradient = Instance.new("UIGradient", mainFrame) [cite: 36]
mainGradient.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15)) [cite: 36]
mainGradient.Transparency = NumberSequence.new(0.1, 0.1) [cite: 36]
mainGradient.Rotation = 90 [cite: 36]

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Active = true
titleBar.Draggable = true -- Make the title bar draggable

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "DYHUB V3.02" [cite: 1]

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = titleBar
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Text = "-"
minimizeBtn.ZIndex = 3

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "X" [cite: 1]
closeBtn.ZIndex = 3

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)


local toggleBtn = Instance.new("TextButton", screenGui) [cite: 36]
toggleBtn.Size = UDim2.new(0, 60, 0, 30) [cite: 36]
toggleBtn.Position = UDim2.new(0, 10, 0, 10) [cite: 36]
toggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35) [cite: 36]
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255) [cite: 36]
toggleBtn.Font = Enum.Font.GothamBold [cite: 36]
toggleBtn.TextSize = 16 [cite: 36]
toggleBtn.Text = "MENU" [cite: 36]
toggleBtn.AnchorPoint = Vector2.new(0,0) [cite: 36]
toggleBtn.Visible = false [cite: 36]

local toggleCorner = Instance.new("UICorner", toggleBtn) [cite: 37]
toggleCorner.CornerRadius = UDim.new(0, 8) [cite: 37]

local toggleStroke = Instance.new("UIStroke", toggleBtn) [cite: 37]
toggleStroke.Color = Color3.fromRGB(50, 50, 50) [cite: 37]
toggleStroke.Thickness = 1 [cite: 37]

toggleBtn.MouseButton1Click:Connect(function() [cite: 37]
	mainFrame.Visible = not mainFrame.Visible [cite: 37]
end) [cite: 37]

local function createHeader(text, yPos, parent) [cite: 37]
	local header = Instance.new("TextLabel") [cite: 37]
	header.Parent = parent [cite: 37]
	header.Size = UDim2.new(0, 150, 0, 25) -- Adjusted width for left column
	header.Position = UDim2.new(0, 5, 0, yPos) -- Start from left edge, padding
	header.BackgroundColor3 = Color3.fromRGB(45, 45, 45) [cite: 37]
	header.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 37]
	header.Font = Enum.Font.GothamBold [cite: 37]
	header.TextSize = 16 [cite: 37]
	header.TextXAlignment = Enum.TextXAlignment.Left [cite: 37]
	header.Text = "    " .. text [cite: 37]
	return header [cite: 37]
end [cite: 37]

local function createButton(name, pos, parent) [cite: 37]
	local btn = Instance.new("TextButton") [cite: 37]
	btn.Name = name [cite: 38]
	btn.Size = UDim2.new(0, 140, 0, 35) -- Adjusted width for left column
	btn.Position = pos [cite: 38]
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) [cite: 38]
	btn.TextColor3 = Color3.fromRGB(255,255,255) [cite: 38]
	btn.Font = Enum.Font.GothamBold [cite: 38]
	btn.TextSize = 14 -- Slightly smaller text for more buttons
	btn.Text = name .. ": Off" [cite: 38]
	btn.AnchorPoint = Vector2.new(0, 0) [cite: 38]
	btn.Parent = parent [cite: 38]

	local corner = Instance.new("UICorner", btn) [cite: 38]
	corner.CornerRadius = UDim.new(0, 10) [cite: 38]

	local stroke = Instance.new("UIStroke", btn) [cite: 38]
	stroke.Color = Color3.fromRGB(65, 65, 65) [cite: 38]
	stroke.Thickness = 1 [cite: 38]

	return btn [cite: 38]
end [cite: 38]

local function createTextBox(name, pos, parent, placeholder, initialValue, size) [cite: 38]
	local box = Instance.new("TextBox") [cite: 38]
	box.Name = name [cite: 38]
	box.Size = size or UDim2.new(0, 140, 0, 25) -- Adjusted width/height for left column
	box.Position = pos [cite: 38]
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50) [cite: 38]
	box.TextColor3 = Color3.fromRGB(200,200,200) [cite: 38]
	box.Font = Enum.Font.GothamBold [cite: 38]
	box.TextSize = 14 [cite: 38]
	box.PlaceholderText = placeholder or "" [cite: 38]
	box.Text = tostring(initialValue or "") [cite: 38]
	box.ClearTextOnFocus = false [cite: 38]
	box.AnchorPoint = Vector2.new(0, 0) [cite: 38]
	box.Parent = parent [cite: 38]

	local corner = Instance.new("UICorner", box) [cite: 39]
	corner.CornerRadius = UDim.new(0, 8) [cite: 39]

	local stroke = Instance.new("UIStroke", box) [cite: 39]
	stroke.Color = Color3.fromRGB(65, 65, 65) [cite: 39]
	stroke.Thickness = 1 [cite: 39]
	return box [cite: 39]
end [cite: 39]

-- GUI Elements Reorganized for Left Column
local currentY = 40 -- Start below the title bar

-- DYHUB text at the bottom left
local dyhubLabel = Instance.new("TextLabel")
dyhubLabel.Parent = mainFrame
dyhubLabel.Size = UDim2.new(0, 100, 0, 20)
dyhubLabel.Position = UDim2.new(0, 5, 1, -25) -- Position at bottom-left 
dyhubLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dyhubLabel.BackgroundTransparency = 1
dyhubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
dyhubLabel.Font = Enum.Font.GothamBold
dyhubLabel.TextSize = 12
dyhubLabel.TextXAlignment = Enum.TextXAlignment.Left
dyhubLabel.Text = "DYHUB" [cite: 1]

local leftColumnFrame = Instance.new("Frame")
leftColumnFrame.Parent = mainFrame
leftColumnFrame.Size = UDim2.new(0, 150, 1, -40) -- Fixed width, takes most of height
leftColumnFrame.Position = UDim2.new(0, 0, 0, 30) -- Below title bar
leftColumnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftColumnFrame.BackgroundTransparency = 1
leftColumnFrame.ClipsDescendants = true

local leftColumnLayout = Instance.new("UIListLayout", leftColumnFrame)
leftColumnLayout.Padding = UDim.new(0, 5)
leftColumnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
leftColumnLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftColumnLayout.FillDirection = Enum.FillDirection.Vertical
leftColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Combat Settings
local combatHeader = createHeader("Combat", 0, leftColumnFrame) -- Layout handles Y
combatHeader.LayoutOrder = 1
local aimbotBtn = createButton("Aimbot", UDim2.new(0, 0, 0, 0), leftColumnFrame)
aimbotBtn.LayoutOrder = 2
local lockBtn = createButton("Target Lock", UDim2.new(0, 0, 0, 0), leftColumnFrame)
lockBtn.LayoutOrder = 3
local teleportLoopBtn = createButton("Teleport Loop", UDim2.new(0, 0, 0, 0), leftColumnFrame)
teleportLoopBtn.LayoutOrder = 4

-- Visual Enhancements
local visualHeader = createHeader("Visuals", 0, leftColumnFrame)
visualHeader.LayoutOrder = 5
local espBtn = createButton("Player ESP", UDim2.new(0, 0, 0, 0), leftColumnFrame)
espBtn.LayoutOrder = 6
local espTeamBtn = createButton("ESP Team Filter", UDim2.new(0, 0, 0, 0), leftColumnFrame)
espTeamBtn.LayoutOrder = 7
local esp3DBtn = createButton("ESP 3D", UDim2.new(0, 0, 0, 0), leftColumnFrame) [cite: 40]
esp3DBtn.LayoutOrder = 8
local esp3DTeamBtn = createButton("ESP 3D Team Filter", UDim2.new(0, 0, 0, 0), leftColumnFrame) [cite: 40]
esp3DTeamBtn.LayoutOrder = 9

-- Hitbox Modifiers
local hitboxHeader = createHeader("Hitbox", 0, leftColumnFrame)
hitboxHeader.LayoutOrder = 10
local hitboxBtn = createButton("Hitbox Enhance", UDim2.new(0, 0, 0, 0), leftColumnFrame)
hitboxBtn.LayoutOrder = 11

-- Input Frame for Hitbox (horizontal layout within left column)
local hitboxInputFrame = Instance.new("Frame")
hitboxInputFrame.Parent = leftColumnFrame
hitboxInputFrame.Size = UDim2.new(0, 140, 0, 30) -- Fixed size
hitboxInputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hitboxInputFrame.BackgroundTransparency = 1
hitboxInputFrame.LayoutOrder = 12

local hitboxInputLayout = Instance.new("UIListLayout", hitboxInputFrame)
hitboxInputLayout.Padding = UDim.new(0, 5)
hitboxInputLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hitboxInputLayout.FillDirection = Enum.FillDirection.Horizontal
hitboxInputLayout.SortOrder = Enum.SortOrder.LayoutOrder

local hitboxInput = createTextBox("HitboxSizeInput", UDim2.new(0, 0, 0, 0), hitboxInputFrame, "Size", hitboxSize, UDim2.new(0, 65, 0, 25)) [cite: 41]
hitboxInput.LayoutOrder = 1
local hitboxTransparencyInput = createTextBox("HitboxTransparencyInput", UDim2.new(0, 0, 0, 0), hitboxInputFrame, "Trans", hitboxTransparency, UDim2.new(0, 65, 0, 25)) [cite: 41]
hitboxTransparencyInput.LayoutOrder = 2

local teamCheckHitboxBtn = createButton("Hitbox Team Filter", UDim2.new(0, 0, 0, 0), leftColumnFrame)
teamCheckHitboxBtn.LayoutOrder = 13

-- Misc Enhancements
local MiscHeader = createHeader("Misc", 0, leftColumnFrame)
MiscHeader.LayoutOrder = 14
local headlessBtn = createButton("Headless", UDim2.new(0, 0, 0, 0), leftColumnFrame)
headlessBtn.LayoutOrder = 15
local noclipBtn = createButton("Noclip", UDim2.new(0, 0, 0, 0), leftColumnFrame)
noclipBtn.LayoutOrder = 16

-- New: Speed Button and Input
local speedBtn = createButton("Speed", UDim2.new(0, 0, 0, 0), leftColumnFrame)
speedBtn.LayoutOrder = 17

local speedInputTextBox = createTextBox("SpeedInput", UDim2.new(0, 0, 0, 0), leftColumnFrame, "Speed (e.g. 50)", flyNoclipSpeed, UDim2.new(0, 140, 0, 25))
speedInputTextBox.LayoutOrder = 18


local highlights = {} [cite: 42]
local esp3DBoxFolder = Instance.new("Folder") [cite: 42]
esp3DBoxFolder.Name = "ESP3DBoxes" [cite: 42]
esp3DBoxFolder.Parent = Camera -- Parent to camera to always be visible (client-side) 


local function updateHighlights() [cite: 42]
	for plr, highlight in pairs(highlights) do [cite: 42]
		if not Players:FindFirstChild(plr.Name) or not plr.Character or not plr.Character.Parent then [cite: 42]
			highlight:Destroy() [cite: 42]
			highlights[plr] = nil [cite: 42]
		end [cite: 42]
	end [cite: 42]

	for _, plr in pairs(Players:GetPlayers()) do [cite: 42]
		if plr == player then [cite: 42]
			if highlights[plr] then [cite: 42]
				highlights[plr].Enabled = false [cite: 42]
			end [cite: 42]
			continue [cite: 42]
		end [cite: 42]

		if espTeamCheck and player.Team and plr.Team and plr.Team == player.Team then [cite: 42]
			if highlights[plr] then [cite: 42]
				highlights[plr].Enabled = false [cite: 42]
			end [cite: 42]
			continue [cite: 42]
		end [cite: 42]

		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then [cite: 42]
			if not highlights[plr] then [cite: 42]
				local highlight = Instance.new("Highlight") [cite: 42]
				highlight.Parent = player.PlayerGui [cite: 42]
				highlight.Adornee = plr.Character [cite: 42]
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop [cite: 42]
				highlight.Enabled = esp [cite: 42]

				local teamColor = plr.TeamColor.Color [cite: 42]
				if plr.Team == nil or plr.TeamColor == nil or plr.TeamColor == BrickColor.new("Institutional white") then [cite: 42]
					highlight.FillColor = Color3.new(1,1,1) [cite: 42]
					highlight.OutlineColor = Color3.new(1,1,1) [cite: 42]
				else [cite: 42]
					highlight.FillColor = teamColor [cite: 42]
					highlight.OutlineColor = teamColor [cite: 42]
				end [cite: 42]
				highlights[plr] = highlight [cite: 42]
			else [cite: 42]
				highlights[plr].Enabled = esp [cite: 42]
			end [cite: 42]
		end [cite: 42]
	end [cite: 42]
end [cite: 42]

local function createESP3DBox(character) [cite: 43]
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") [cite: 43]
	local humanoid = character:FindFirstChildWhichIsA("Humanoid") [cite: 43]
	if not humanoidRootPart or not humanoid then return nil end [cite: 43]

	local box = Instance.new("BoxHandleAdornment") [cite: 43]
	box.Name = "ESP3DBox" [cite: 43]
	box.Adornee = humanoidRootPart [cite: 43]
	box.Size = Vector3.new(4, 6, 4) -- Approximate size to fit around a character 
	box.Color3 = Color3.fromRGB(0, 255, 0) -- Green box 
	box.Transparency = 0.5 [cite: 43]
	box.AlwaysOnTop = true [cite: 43]
	box.ZIndex = 10 [cite: 43]
	box.Parent = esp3DBoxFolder [cite: 43]
	return box [cite: 43]
end [cite: 43]

local function applyESP3DBox(p) [cite: 43]
	if esp3D and p ~= player and p.Character then [cite: 43]
		if esp3DTeamCheck and player.Team and p.Team and p.Team == player.Team then [cite: 43]
			if appliedESP3DBoxes[p] then [cite: 43]
				appliedESP3DBoxes[p]:Destroy() [cite: 43]
				appliedESP3DBoxes[p] = nil [cite: 43]
			end [cite: 43]
			return [cite: 43]
		end [cite: 43]

		local rootPart = p.Character:FindFirstChild("HumanoidRootPart") [cite: 43]
		if rootPart and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then [cite: 43]
			if not appliedESP3DBoxes[p] then [cite: 43]
				appliedESP3DBoxes[p] = createESP3DBox(p.Character) [cite: 43]
			end [cite: 43]
		else [cite: 43]
			removeESP3DBox(p) [cite: 43]
		end [cite: 43]
	else [cite: 43]
		removeESP3DBox(p) [cite: 43]
	end [cite: 43]
end [cite: 43]

local function removeESP3DBox(p) [cite: 43]
	if appliedESP3DBoxes[p] then [cite: 43]
		appliedESP3DBoxes[p]:Destroy() [cite: 43]
		appliedESP3DBoxes[p] = nil [cite: 43]
	end [cite: 43]
end [cite: 43]

local function updateESP3DBoxes() [cite: 43]
	for _, p in pairs(Players:GetPlayers()) do [cite: 44]
		if p ~= player then [cite: 44]
			applyESP3DBox(p) [cite: 44]
		else [cite: 44]
			removeESP3DBox(p) -- Ensure local player's box is removed 
		end [cite: 44]
	end [cite: 44]
end [cite: 44]

local function isTargetVisible(targetPlayer, targetPart) [cite: 44]
	if not targetPlayer or not targetPlayer.Character or not targetPart then return false end [cite: 44]

	local origin = Camera.CFrame.Position [cite: 44]
	local targetPos = targetPart.Position [cite: 44]
	local raycastParams = RaycastParams.new() [cite: 44]
	raycastParams.FilterDescendantsInstances = {player.Character} [cite: 44]
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist [cite: 44]

	local raycastResult = workspace:Raycast(origin, (targetPos - origin).Unit * (origin - targetPos).Magnitude, raycastParams) [cite: 44]

	if raycastResult then [cite: 44]
		return raycastResult.Instance:IsDescendantOf(targetPlayer.Character) [cite: 44]
	end [cite: 44]
	return false [cite: 44]
end [cite: 44]

local function getClosestVisibleTarget() [cite: 44]
	local closestDist = math.huge [cite: 44]
	local closestPlayer = nil [cite: 44]
	for _, plr in pairs(Players:GetPlayers()) do [cite: 44]
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset) and plr.Character:FindFirstChild("Humanoid") then [cite: 44]
			-- Aimbot: Exclude teammates if player has a team 
			if player.Team and plr.Team and plr.Team == player.Team then [cite: 44]
				continue [cite: 44]
			end [cite: 44]

			local humanoid = plr.Character.Humanoid [cite: 45]
			if humanoid.Health > 0 then [cite: 45]
				local targetPart = plr.Character[lockset] [cite: 45]
				if isTargetVisible(plr, targetPart) then [cite: 45]
					local origin = Camera.CFrame.Position [cite: 45]
					local targetPos = targetPart.Position [cite: 45]
					local dist = (origin - targetPos).Magnitude [cite: 45]

					if dist < closestDist then [cite: 45]
						closestDist = dist [cite: 45]
						closestPlayer = plr [cite: 45]
					end [cite: 45]
				end [cite: 45]
			end [cite: 45]
		end [cite: 45]
	end [cite: 45]
	return closestPlayer [cite: 45]
end [cite: 45]

local function getRandomLivingTarget() [cite: 45]
	local validTargets = {} [cite: 45]
	for _, plr in pairs(Players:GetPlayers()) do [cite: 45]
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then [cite: 45]
			table.insert(validTargets, plr) [cite: 45]
		end [cite: 45]
	end [cite: 45]
	if #validTargets > 0 then [cite: 45]
		return validTargets[math.random(1, #validTargets)] [cite: 45]
	end [cite: 45]
	return nil [cite: 45]
end [cite: 45]

local function applyHitboxToPlayer(p) [cite: 45]
	if hitbox and p ~= player and p.Character then [cite: 45]
		if teamCheckHitbox and player.Team and p.Team and p.Team == player.Team then [cite: 45]
			resetHitboxesForPlayer(p) [cite: 45]
			return [cite: 45]
		end [cite: 45]

		local part = p.Character:FindFirstChild("HumanoidRootPart") [cite: 46]
		if part then [cite: 46]
			part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize) [cite: 46]
			part.Transparency = hitboxTransparency [cite: 46]
			part.Material = Enum.Material.Neon [cite: 46]
			part.BrickColor = BrickColor.new("Really black") [cite: 46]
			part.CanCollide = false [cite: 46]

			if not appliedHitboxes[p] or appliedHitboxes[p] == false then [cite: 46]
				originalWalkSpeeds[p] = p.Character.Humanoid.WalkSpeed [cite: 46]
				p.Character.Humanoid.WalkSpeed = 0 [cite: 46]
				appliedHitboxes[p] = true [cite: 46]
			end [cite: 46]
		end [cite: 46]
	end [cite: 46]
end [cite: 46]

local function updateHitboxes() [cite: 46]
	for _, p in pairs(Players:GetPlayers()) do [cite: 46]
		applyHitboxToPlayer(p) [cite: 46]
	end [cite: 46]
end [cite: 46]

local function resetHitboxesForPlayer(p) [cite: 46]
	if p ~= player and p.Character then [cite: 46]
		local part = p.Character:FindFirstChild("HumanoidRootPart") [cite: 46]
		if part then [cite: 46]
			part.Size = Vector3.new(2,2,1) [cite: 46]
			part.Transparency = 1 [cite: 46]
			part.Material = Enum.Material.Plastic [cite: 46]
			part.BrickColor = BrickColor.new("Medium stone grey") [cite: 46]
			part.CanCollide = false [cite: 46]
		end [cite: 46]
	end [cite: 46]
	if originalWalkSpeeds[p] then [cite: 46]
		if p.Character and p.Character:FindFirstChild("Humanoid") then [cite: 47]
			p.Character.Humanoid.WalkSpeed = originalWalkSpeeds[p] [cite: 47]
		end [cite: 47]
		originalWalkSpeeds[p] = nil [cite: 47]
		appliedHitboxes[p] = nil [cite: 47]
	end [cite: 47]
end [cite: 47]

local function resetAllHitboxes() [cite: 47]
	for _, p in pairs(Players:GetPlayers()) do [cite: 47]
		resetHitboxesForPlayer(p) [cite: 47]
	end [cite: 47]
end [cite: 47]

local function performTeleport(plr) [cite: 47]
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end [cite: 47]
	local hrp = player.Character.HumanoidRootPart [cite: 47]

	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end [cite: 47]
	local targetHRP = plr.Character.HumanoidRootPart [cite: 47]
	local targetPos = targetHRP.Position [cite: 47]

	hrp.CFrame = CFrame.new(targetPos) [cite: 47]
end [cite: 47]

local function handleTeleportLoop(dt) [cite: 47]
	if not killAll then return end [cite: 47]

	if not teleportTarget or not teleportTarget.Character or not teleportTarget.Character:FindFirstChild("Humanoid") or teleportTarget.Character.Humanoid.Health <= 0 then [cite: 47]
		teleportTarget = getRandomLivingTarget() [cite: 47]
		if not teleportTarget then [cite: 47]
			killAll = false [cite: 47]
			teleportLoopBtn.Text = "Teleport Loop: Off" [cite: 47]
			showNotify("Teleport Loop: No active targets available.") [cite: 47]
			return [cite: 47]
		end [cite: 47]
	end [cite: 47]

	teleportTimer = teleportTimer + dt [cite: 47]
	if teleportTimer >= teleportInterval then [cite: 47]
		teleportTimer = 0 [cite: 47]
		if teleportTarget and teleportTarget.Character and teleportTarget.Character:FindFirstChild("Humanoid") then [cite: 47]
			local humanoid = teleportTarget.Character.Humanoid [cite: 47]
			if humanoid.Health > 0 then [cite: 47]
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then [cite: 47]
					performTeleport(teleportTarget) [cite: 47]
				end [cite: 47]
				showNotify("Teleporting to: " .. teleportTarget.Name) [cite: 47]
			end [cite: 47]
		end [cite: 47]
	end [cite: 47]
end [cite: 47]

local function updateLockBtn() [cite: 48]
	lockBtn.Text = "Target Lock: " .. (lockset or "None") [cite: 48]
end [cite: 48]

-- New: Noclip functions
local function applyNoclip() [cite: 48]
	if player.Character then [cite: 48]
		for _, part in ipairs(player.Character:GetChildren()) do [cite: 48]
			if part:IsA("BasePart") then [cite: 48]
				originalCanCollide[part] = part.CanCollide -- Store original state 
				part.CanCollide = false [cite: 48]
			end [cite: 48]
		end [cite: 48]
		showNotify("Noclip enabled.") [cite: 48]
	end [cite: 48]
end [cite: 48]

local function disableNoclip() [cite: 48]
	if player.Character then [cite: 48]
		for _, part in ipairs(player.Character:GetChildren()) do [cite: 48]
			if part:IsA("BasePart") and originalCanCollide[part] ~= nil then [cite: 48]
				part.CanCollide = originalCanCollide[part] -- Restore original state 
				originalCanCollide[part] = nil [cite: 48]
			end [cite: 48]
		end [cite: 48]
		showNotify("Noclip disabled.") [cite: 48]
	end [cite: 48]
end [cite: 48]

-- New: Headless functions
local function applyHeadless() [cite: 48]
	if player.Character then [cite: 48]
		local head = player.Character:FindFirstChild("Head") [cite: 48]
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh")) [cite: 48]
		if head then [cite: 48]
			originalHeadTransparency = head.Transparency [cite: 48]
			head.Transparency = 1 [cite: 48]
		end [cite: 48]
		if face then [cite: 48]
			originalFaceTransparency = face.Transparency [cite: 48]
			face.Transparency = 1 [cite: 48]
		end [cite: 48]
		showNotify("Headless enabled.") [cite: 48]
	end [cite: 48]
end [cite: 48]

local function restoreHead() [cite: 49]
	if player.Character then [cite: 49]
		local head = player.Character:FindFirstChild("Head") [cite: 49]
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh")) [cite: 49]
		if head and originalHeadTransparency ~= nil then [cite: 49]
			head.Transparency = originalHeadTransparency [cite: 49]
			originalHeadTransparency = nil [cite: 49]
		end [cite: 49]
		if face and originalFaceTransparency ~= nil then [cite: 49]
			face.Transparency = originalFaceTransparency [cite: 49]
			originalFaceTransparency = nil [cite: 49]
		end [cite: 49]
		showNotify("Headless disabled.") [cite: 49]
	end [cite: 49]
end [cite: 49]

-- Connect GUI button events
aimbotBtn.MouseButton1Click:Connect(function() [cite: 49]
	aimbot = not aimbot [cite: 49]
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off") [cite: 49]
	if aimbot then [cite: 49]
		showNotify("Aimbot functionality enabled. Targeting non-team players.") [cite: 49]
		currentAimbotTarget = getClosestVisibleTarget() [cite: 49]
		if not currentAimbotTarget then [cite: 49]
			showNotify("Aimbot: No immediate valid targets detected.") [cite: 49]
		end [cite: 49]
	else [cite: 49]
		showNotify("Aimbot functionality disabled.") [cite: 49]
		currentAimbotTarget = nil [cite: 49]
	end [cite: 49]
end) [cite: 49]

espBtn.MouseButton1Click:Connect(function() [cite: 49]
	esp = not esp [cite: 49]
	espBtn.Text = "Player ESP: " .. (esp and "On" or "Off") [cite: 49]
	updateHighlights() [cite: 49]
	showNotify(esp and "Player ESP Display Enabled." or "Player ESP Display Disabled.") [cite: 49]
end) [cite: 49]

espTeamBtn.MouseButton1Click:Connect(function() [cite: 49]
	espTeamCheck = not espTeamCheck [cite: 49]
	espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off") [cite: 49]
	if espTeamCheck then [cite: 49]
		showNotify("Player ESP Team Filter: Only non-team players highlighted.") [cite: 49]
	else [cite: 49]
		showNotify("Player ESP Team Filter: All players highlighted (excluding self).") [cite: 49]
	end [cite: 49]
	updateHighlights() [cite: 49]
end) [cite: 49]

esp3DBtn.MouseButton1Click:Connect(function() -- New ESP 3D toggle handler 
	esp3D = not esp3D [cite: 50]
	esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off") [cite: 50]
	if esp3D then [cite: 50]
		showNotify("ESP 3D enabled. Visual boxes around players.") [cite: 50]
		updateESP3DBoxes() [cite: 50]
	else [cite: 50]
		showNotify("ESP 3D disabled. Removing visual boxes.") [cite: 50]
		for _, p in pairs(Players:GetPlayers()) do [cite: 50]
			removeESP3DBox(p) [cite: 50]
		end [cite: 50]
	end [cite: 50]
end) [cite: 50]

esp3DTeamBtn.MouseButton1Click:Connect(function() -- New ESP 3D Team Filter handler 
	esp3DTeamCheck = not esp3DTeamCheck [cite: 50]
	esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off") [cite: 50]
	if esp3DTeamCheck then [cite: 50]
		showNotify("ESP 3D Team Filter enabled: Affects non-team players only.") [cite: 50]
	else [cite: 50]
		showNotify("ESP 3D Team Filter disabled: Affects all players.") [cite: 50]
	end [cite: 50]
	if esp3D then [cite: 50]
		updateESP3DBoxes() [cite: 50]
	end [cite: 50]
end) [cite: 50]

lockBtn.MouseButton1Click:Connect(function() [cite: 50]
	currentLockPartIndex = currentLockPartIndex + 1 [cite: 50]
	if currentLockPartIndex > #lockParts then [cite: 50]
		currentLockPartIndex = 1 [cite: 50]
	end [cite: 50]
	lockset = lockParts[currentLockPartIndex] [cite: 50]
	updateLockBtn() [cite: 50]
	showNotify("Target Lockpoint set to: " .. lockset) [cite: 50]
end) [cite: 50]

teleportLoopBtn.MouseButton1Click:Connect(function() [cite: 50]
	killAll = not killAll [cite: 51]
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off") [cite: 51]

	if killAll then [cite: 51]
		teleportTarget = getRandomLivingTarget() [cite: 51]
		if not teleportTarget then [cite: 51]
			showNotify("Teleport Loop: No valid targets found.") [cite: 51]
			killAll = false [cite: 51]
			teleportLoopBtn.Text = "Teleport Loop: Off" [cite: 51]
		else [cite: 51]
			showNotify("Teleport Loop initiated. Teleporting to: " .. teleportTarget.Name) [cite: 51]
		end [cite: 51]
	else [cite: 51]
		showNotify("Teleport Loop deactivated.") [cite: 51]
		teleportTarget = nil [cite: 51]
	end [cite: 51]
end) [cite: 51]

hitboxBtn.MouseButton1Click:Connect(function() [cite: 51]
	hitbox = not hitbox [cite: 51]
	hitboxBtn.Text = "Hitbox Enhancement: " .. (hitbox and "On" or "Off") [cite: 51]

	if hitbox then [cite: 51]
		showNotify("Hitbox enhancement enabled for external players. (Size: " .. hitboxSize .. ", Transparency: " .. hitboxTransparency .. ").") [cite: 52]
		updateHitboxes() [cite: 52]
		showNotify("Note: Client-side modifications may be reverted by game anti-cheat systems.") [cite: 52]
	else [cite: 52]
		showNotify("Hitbox enhancement disabled. Restoring default hitboxes.") [cite: 52]
		resetAllHitboxes() [cite: 52]
	end [cite: 52]
end) [cite: 52]

hitboxInput.FocusLost:Connect(function(enterPressed) [cite: 52]
	if enterPressed then [cite: 52]
		local val = tonumber(hitboxInput.Text) [cite: 52]
		if val and val >= 0 and val <= 300 then [cite: 52]
			hitboxSize = val [cite: 52]
			if hitbox then [cite: 52]
				updateHitboxes() [cite: 52]
			end [cite: 52]
			showNotify("Hitbox Size updated to: " .. hitboxSize) [cite: 52]
		else [cite: 52]
			showNotify("Invalid Hitbox size. Please enter a value between 0-300.") [cite: 52]
			hitboxInput.Text = tostring(hitboxSize) [cite: 52]
		end [cite: 52]
	end [cite: 52]
end) [cite: 52]

hitboxTransparencyInput.FocusLost:Connect(function(enterPressed) [cite: 52]
	if enterPressed then [cite: 53]
		local val = tonumber(hitboxTransparencyInput.Text) [cite: 53]
		if val and val >= 0.0 and val <= 1.0 then [cite: 53]
			hitboxTransparency = val [cite: 53]
			if hitbox then [cite: 53]
				updateHitboxes() [cite: 53]
			end [cite: 53]
			showNotify("Hitbox Transparency updated to: " .. hitboxTransparency) [cite: 53]
		else [cite: 53]
			showNotify("Invalid Transparency value. Please enter a value between 0.0-1.0.") [cite: 53]
			hitboxTransparencyInput.Text = tostring(hitboxTransparency) [cite: 53]
		end [cite: 53]
	end [cite: 53]
end) [cite: 53]

teamCheckHitboxBtn.MouseButton1Click:Connect(function() [cite: 53]
	teamCheckHitbox = not teamCheckHitbox [cite: 53]
	teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off") [cite: 53]
	if teamCheckHitbox then [cite: 53]
		showNotify("Hitbox Team Filter enabled: Affects non-team players only.") [cite: 53]
	else [cite: 53]
		showNotify("Hitbox Team Filter disabled: Affects all players.") [cite: 53]
	end [cite: 53]
	if hitbox then [cite: 53]
		resetAllHitboxes() [cite: 53]
		updateHitboxes() [cite: 53]
	end [cite: 53]
end) [cite: 53]

-- New: Noclip Button Click
noclipBtn.MouseButton1Click:Connect(function() [cite: 53]
	noclip = not noclip [cite: 53]
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off") [cite: 53]
	if noclip then [cite: 53]
		applyNoclip() [cite: 53]
	else [cite: 53]
		disableNoclip() [cite: 53]
	end [cite: 53]
end) [cite: 53]

-- New: Headless Button Click
headlessBtn.MouseButton1Click:Connect(function() [cite: 53]
	headless = not headless [cite: 53]
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off") [cite: 54]
	if headless then [cite: 54]
		applyHeadless() [cite: 54]
	else [cite: 54]
		restoreHead() [cite: 54]
	end [cite: 54]
end) [cite: 54]

-- New: Speed Button Click
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "Speed: ON"
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
            lastValidSpeed = desiredSpeed
        else
            flyNoclipSpeed = lastValidSpeed
            speedInputTextBox.Text = tostring(lastValidSpeed)
        end
        -- Start Speed movement
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        speedConnection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                local moveDir = player.Character.Humanoid.MoveDirection
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + moveDir * math.max(flyNoclipSpeed, 1) * 0.016
            end
        end)
        showNotify("Speed Enabled: Walk speed set to " .. flyNoclipSpeed .. ".")
    else
        speedBtn.Text = "Speed: OFF"
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        showNotify("Speed Disabled: Speed has been turned off.")
    end
end)

-- New: Speed Input Text Box FocusLost
speedInputTextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(speedInputTextBox.Text)
		if val and val > 0 then
			lastValidSpeed = val
			if speedEnabled then -- Apply new speed immediately if enabled
				flyNoclipSpeed = val
				showNotify("Speed updated to: " .. flyNoclipSpeed)
			else
				showNotify("Speed preference set to: " .. lastValidSpeed .. " (activate speed to apply).")
			end
		else
			showNotify("Invalid Speed. Please enter a value greater than 0.")
			speedInputTextBox.Text = tostring(lastValidSpeed)
		end
	end
end)


local function setupGUIAndDefaults() [cite: 54]
	updateLockBtn() [cite: 54]
	espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off") [cite: 54]
	esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off") -- Set initial text for ESP 3D 
	esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off") -- Set initial text for ESP 3D Team Filter 
	teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off") [cite: 54]
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off") [cite: 54]
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off") -- Set initial text for Noclip 
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off") -- Set initial text for Headless 
    speedBtn.Text = "Speed: " .. (speedEnabled and "On" or "Off") -- Set initial text for Speed
end [cite: 54]

Players.PlayerAdded:Connect(function(newPlayer) [cite: 54]
	newPlayer.CharacterAdded:Connect(function(char) [cite: 54]
		if hitbox then [cite: 55]
			applyHitboxToPlayer(newPlayer) [cite: 55]
		end [cite: 55]
		if esp3D then -- New: Apply ESP 3D when new player character added 
			applyESP3DBox(newPlayer) [cite: 55]
		end [cite: 55]
		if noclip and newPlayer == player then -- Reapply noclip if character respawns 
			disableNoclip() -- Clear previous state first 
			applyNoclip() [cite: 55]
		end [cite: 55]
		if headless and newPlayer == player then -- Reapply headless if character respawns 
			restoreHead() -- Clear previous state first 
			applyHeadless() [cite: 55]
		end [cite: 55]
        -- No need to reapply speed here, as it's controlled by RunService.RenderStepped
	end) [cite: 55]
	-- Initial ESP 3D update for newly added player if esp3D is active 
	if esp3D then [cite: 55]
		applyESP3DBox(newPlayer) [cite: 55]
	end [cite: 55]
end) [cite: 55]

Players.PlayerRemoving:Connect(function(leavingPlayer) [cite: 55]
	if originalWalkSpeeds[leavingPlayer] then [cite: 55]
		originalWalkSpeeds[leavingPlayer] = nil [cite: 55]
	end [cite: 55]
	if appliedHitboxes[leavingPlayer] then [cite: 55]
		appliedHitboxes[leavingPlayer] = nil [cite: 55]
	end [cite: 55]
	removeESP3DBox(leavingPlayer) -- New: Remove ESP 3D box when player leaves 
	if currentAimbotTarget == leavingPlayer then [cite: 55]
		currentAimbotTarget = nil [cite: 55]
	end [cite: 55]
	if teleportTarget == leavingPlayer then [cite: 55]
		teleportTarget = nil [cite: 56]
	end [cite: 56]
	updateHighlights() [cite: 56]
end) [cite: 56]

local function checkKey() [cite: 56]
	local enteredKey = keyInputBox.Text:lower() [cite: 56]
	if enteredKey == correctKey or enteredKey == "dev" then [cite: 56]
		keyInputGui:Destroy() [cite: 56]
		mainFrame.Visible = true [cite: 56]
		toggleBtn.Visible = true [cite: 56]
		setupGUIAndDefaults() [cite: 56]
		showNotify("Access Granted. Key lifetime: " .. lifetimeWeeks .. " attempt(Weeks), (Days: " .. lifetimeDays .. "), (Hour: " .. lifetimeHour .. "), (Sec: " .. lifetimeSec .. ") remaining.") [cite: 56]
		wait(0.5) [cite: 56]
		showNotify("Access granted. Main interface now available.") [cite: 56]
	else [cite: 56]
		currentAttempts = currentAttempts + 1 [cite: 56]
		local remainingAttempts = maxAttempts - currentAttempts [cite: 56]
		if remainingAttempts > 0 then [cite: 56]
			showNotify("Invalid access key. " .. remainingAttempts .. " attempt(s) remaining.") [cite: 56]
		else [cite: 56]
			showNotify("Multiple invalid attempts. Access denied.") [cite: 56]
			kickPlayer("Access to this script has been suspended. (Error Code: Key_Denied_003)") [cite: 56]
		end [cite: 56]
	end [cite: 56]
end [cite: 56]

keyInputBox.FocusLost:Connect(function(enterPressed) [cite: 57]
	if enterPressed then [cite: 57]
		checkKey() [cite: 57]
	end [cite: 57]
end) [cite: 57]

keySubmitBtn.MouseButton1Click:Connect(checkKey) [cite: 57]

RunService.RenderStepped:Connect(function(dt) [cite: 57]
	if aimbot and lockset and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then [cite: 57]
		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then [cite: 57]
			local targetHumanoid = currentAimbotTarget.Character:FindFirstChild("Humanoid") [cite: 57]
			local targetPart = currentAimbotTarget.Character[lockset] [cite: 57]

			if not targetHumanoid or targetHumanoid.Health <= 0 or not isTargetVisible(currentAimbotTarget, targetPart) then [cite: 57]
				currentAimbotTarget = nil [cite: 57]
			end [cite: 57]
		end [cite: 57]

		if not currentAimbotTarget then [cite: 57]
			currentAimbotTarget = getClosestVisibleTarget() [cite: 57]
		end [cite: 57]

		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then [cite: 58]
			local targetPart = currentAimbotTarget.Character[lockset] [cite: 58]
			local cameraPos = Camera.CFrame.Position [cite: 58]
			local targetPos = targetPart.Position [cite: 58]
			local direction = (targetPos - cameraPos).Unit [cite: 58]
			local newCFrame = CFrame.new(cameraPos, cameraPos + direction) [cite: 58]
			Camera.CFrame = newCFrame [cite: 58]
		end [cite: 58]
	else [cite: 58]
		currentAimbotTarget = nil [cite: 58]
	end [cite: 58]

	if killAll then [cite: 58]
		handleTeleportLoop(dt) [cite: 58]
	end [cite: 58]

	if esp then [cite: 58]
		updateHighlights() [cite: 58]
	end [cite: 58]
	if esp3D then -- New: Update ESP 3D boxes 
		updateESP3DBoxes() [cite: 58]
	end [cite: 58]

	-- New: Noclip continuous application
	if noclip and player.Character then [cite: 58]
		for _, part in ipairs(player.Character:GetChildren()) do [cite: 58]
			if part:IsA("BasePart") and part.CanCollide then -- Only modify if it's currently collidable 
				originalCanCollide[part] = part.CanCollide -- Ensure original state is always recent 
				part.CanCollide = false [cite: 58]
			end [cite: 58]
		end [cite: 58]
	end [cite: 58]

	-- New: Headless continuous application
	if headless and player.Character then [cite: 58]
		local head = player.Character:FindFirstChild("Head") [cite: 58]
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh")) [cite: 58]
		if head and head.Transparency < 1 then [cite: 58]
			originalHeadTransparency = head.Transparency [cite: 58]
			head.Transparency = 1 [cite: 58]
		end [cite: 58]
		if face and face.Transparency < 1 then [cite: 58]
			face.Transparency = originalFaceTransparency [cite: 58]
			face.Transparency = 1 [cite: 58]
		end [cite: 58]
	end [cite: 58]
end) [cite: 58]

keyInputBox:CaptureFocus()
showNotify("Please authenticate your access key to proceed.")

while true do
	wait(1)
	if mainFrame.Visible and esp then updateHighlights() end
	if esp3D then updateESP3DBoxes() end -- New: Always update ESP 3D boxes if enabled, regardless of GUI visibility
end
