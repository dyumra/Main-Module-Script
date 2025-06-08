-- [[ Open Source Code !!! ]]

-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]\
-- [[ 📊 Version: 2.19.0 - Authenticated Interface Edition ]] -- Updated Version
-- [[ 🔗 Other Script : https://github.com/dyumra - Thank for Support ]]

print("Script started: Initializing variables.")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local aimbot = false
local esp = false
local espTeamCheck = false
local esp3D = false
local esp3DTeamCheck = false
local killAll = false
local hitbox = false
local hitboxSize = 15
local hitboxTransparency = 0.7
local teamCheckHitbox = false
local currentAimbotTarget = nil
local teleportTarget = nil
local teleportInterval = 0.15
local teleportTimer = 0
local lockParts = {"None", "Head", "Torso", "UpperTorso", "HumanoidRootPart"}
local originalWalkSpeeds = {}
local appliedHitboxes = {}
local appliedESP3DBoxes = {}

local noclip = false
local originalCanCollide = {}

local headless = false
local originalHeadTransparency = nil
local originalFaceTransparency = nil

local speedEnabled = false
local flyNoclipSpeed = 30
local lastValidSpeed = 30
local speedConnection = nil

local currentLockPartIndex = 1
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 1.5
local TELEPORT_VERTICAL_OFFSET = 0

local AIMBOT_SWITCH_DISTANCE = 8

local correctKey = "dyumra-k3b7-wp9d-a2n8"
local maxAttempts = 3
local currentAttempts = 0
-- time lifetime
local lifetimeWeeks = math.random(10000, 12222)
local lifetimeDays = math.random(1, 31)
local lifetimeHour = math.random(1, 60)
local lifetimeSec = math.random(1, 60)

print("Variables initialized. Defining helper functions.")

local function detectLockSet(character)
	if character:FindFirstChild("Torso") then
		return "Torso"
	elseif character:FindFirstChild("UpperTorso") then
		return "UpperTorso"
	elseif character:FindFirstChild("HumanoidRootPart") then
		return "HumanoidRootPart"
	elseif character:FindFirstChild("Head") then
		return "Head"
	else
		return nil
	end
end

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

print("Helper functions defined. Waiting for PlayerGui.")
-- It's crucial to wait for PlayerGui as the script runs on the client.
local playerGui = player:WaitForChild("PlayerGui")
print("PlayerGui found. Creating KeyInputGui.")

local keyInputGui = Instance.new("ScreenGui")
keyInputGui.Name = "KeyInputGui"
keyInputGui.ResetOnSpawn = false
keyInputGui.Parent = playerGui -- Parent directly to PlayerGui
print("KeyInputGui created and parented.")

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

print("KeyInputGui components created. Creating main AimbotESPGui.")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui -- Parent directly to PlayerGui
print("AimbotESPGui created and parented. It is currently invisible.")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 600, 0, 400) -- Wider and shorter for the new UI
mainFrame.Position = UDim2.new(0.5, -(mainFrame.Size.X.Offset / 2), 0.5, -(mainFrame.Size.Y.Offset / 2)) -- Center the frame
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5,0.5) -- Set AnchorPoint to center for easier positioning
mainFrame.Active = true
mainFrame.Draggable = false -- Set to false
mainFrame.Visible = false -- Start as invisible

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(40, 40, 40)
mainStroke.Thickness = 2

local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
mainGradient.Transparency = NumberSequence.new(0.1, 0.1)
mainGradient.Rotation = 90

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Active = true
titleBar.Draggable = false -- Set to false

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0, 250, 1, 0) -- Wider to accommodate text
titleLabel.Position = UDim2.new(0.02, 0, 0, 0) -- Slightly from left edge
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "DYHUB'S - Version 1.19.5" -- Updated Title

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
closeBtn.Text = "X"
closeBtn.ZIndex = 3

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    print("Main Frame Visibility set to false.")
end)


local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Text = "MENU"
toggleBtn.AnchorPoint = Vector2.new(0,0)
toggleBtn.Visible = false -- Starts invisible, only visible after authentication

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(50, 50, 50)
toggleStroke.Thickness = 1

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
    print("Toggle button clicked. Main Frame Visible: " .. tostring(mainFrame.Visible))
end)

local function createHeader(text, parent)
	local header = Instance.new("TextLabel")
	header.Parent = parent
	header.Size = UDim2.new(1, -10, 0, 25)
	header.Position = UDim2.new(0, 5, 0, 0)
	header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.Font = Enum.Font.GothamBold
	header.TextSize = 16
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = "    " .. text
	return header
end

local function createButton(name, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name .. ": Off"
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(65, 65, 65)
	stroke.Thickness = 1

	return btn
end

local function createTextBox(name, parent, placeholder, initialValue, size)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = size or UDim2.new(1, -10, 0, 25)
	box.Position = UDim2.new(0, 5, 0, 0)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 14
	box.PlaceholderText = placeholder or ""
	box.Text = tostring(initialValue or "")
	box.ClearTextOnFocus = false
	box.Parent = parent

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(65, 65, 65)
	stroke.Thickness = 1
	return box
end

print("Core UI creation functions defined. Starting main layout creation.")

-- DYHUB text at the bottom left
local dyhubLabel = Instance.new("TextLabel")
dyhubLabel.Parent = mainFrame
dyhubLabel.Size = UDim2.new(0, 100, 0, 20)
dyhubLabel.Position = UDim2.new(0, 5, 1, -25)
dyhubLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dyhubLabel.BackgroundTransparency = 1
dyhubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
dyhubLabel.Font = Enum.Font.GothamBold
dyhubLabel.TextSize = 12
dyhubLabel.TextXAlignment = Enum.TextXAlignment.Left
dyhubLabel.Text = "DYHUB"

-- Left Column for Category Buttons
local leftColumnFrame = Instance.new("Frame")
leftColumnFrame.Parent = mainFrame
leftColumnFrame.Size = UDim2.new(0, 150, 1, -40)
leftColumnFrame.Position = UDim2.new(0, 0, 0, 30)
leftColumnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftColumnFrame.BackgroundTransparency = 1
leftColumnFrame.ClipsDescendants = true

local leftColumnLayout = Instance.new("UIListLayout", leftColumnFrame)
leftColumnLayout.Padding = UDim.new(0, 5)
leftColumnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
leftColumnLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftColumnLayout.FillDirection = Enum.FillDirection.Vertical
leftColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Right Panel for Function Lists
local rightPanel = Instance.new("Frame")
rightPanel.Parent = mainFrame
rightPanel.Size = UDim2.new(1, -160, 1, -40)
rightPanel.Position = UDim2.new(0, 155, 0, 30)
rightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rightPanel.BackgroundTransparency = 0
rightPanel.BorderSizePixel = 0
rightPanel.ClipsDescendants = true

local rightPanelCorner = Instance.new("UICorner", rightPanel)
rightPanelCorner.CornerRadius = UDim.new(0, 8)

local rightPanelLayout = Instance.new("UIPageLayout", rightPanel)
rightPanelLayout.Padding = UDim.new(0, 10)
rightPanelLayout.FillDirection = Enum.FillDirection.Vertical
rightPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

print("Category buttons and panels creation initiated.")

-- Category Buttons
local combatCategoryBtn = createButton("Combat", leftColumnFrame)
combatCategoryBtn.LayoutOrder = 1
local visualsCategoryBtn = createButton("Visuals", leftColumnFrame)
visualsCategoryBtn.LayoutOrder = 2
local hitboxCategoryBtn = createButton("Hitbox", leftColumnFrame)
hitboxCategoryBtn.LayoutOrder = 3
local miscCategoryBtn = createButton("Misc", leftColumnFrame)
miscCategoryBtn.LayoutOrder = 4

-- Combat Panel
local combatPanel = Instance.new("Frame", rightPanel)
combatPanel.Name = "CombatPanel"
combatPanel.Size = UDim2.new(1, 0, 1, 0)
combatPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
combatPanel.BackgroundTransparency = 1
combatPanel.Visible = true

local combatPanelLayout = Instance.new("UIListLayout", combatPanel)
combatPanelLayout.Padding = UDim.new(0, 5)
combatPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
combatPanelLayout.VerticalAlignment = Enum.VerticalAlignment.Top
combatPanelLayout.FillDirection = Enum.FillDirection.Vertical
combatPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder

local combatHeader = createHeader("Combat Settings", combatPanel)
combatHeader.LayoutOrder = 1
local aimbotBtn = createButton("Aimbot", combatPanel)
aimbotBtn.LayoutOrder = 2
local lockBtn = createButton("Target Lock", combatPanel)
lockBtn.LayoutOrder = 3
local teleportLoopBtn = createButton("Teleport Loop", combatPanel)
teleportLoopBtn.LayoutOrder = 4

-- Visuals Panel
local visualsPanel = Instance.new("Frame", rightPanel)
visualsPanel.Name = "VisualsPanel"
visualsPanel.Size = UDim2.new(1, 0, 1, 0)
visualsPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
visualsPanel.BackgroundTransparency = 1
visualsPanel.Visible = false

local visualsPanelLayout = Instance.new("UIListLayout", visualsPanel)
visualsPanelLayout.Padding = UDim.new(0, 5)
visualsPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
visualsPanelLayout.VerticalAlignment = Enum.VerticalAlignment.Top
visualsPanelLayout.FillDirection = Enum.FillDirection.Vertical
visualsPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder

local visualHeader = createHeader("Visual Enhancements", visualsPanel)
visualHeader.LayoutOrder = 1
local espBtn = createButton("Player ESP", visualsPanel)
espBtn.LayoutOrder = 2
local espTeamBtn = createButton("ESP Team Filter", visualsPanel)
espTeamBtn.LayoutOrder = 3
local esp3DBtn = createButton("ESP 3D", visualsPanel)
esp3DBtn.LayoutOrder = 4
local esp3DTeamBtn = createButton("ESP 3D Team Filter", visualsPanel)
esp3DTeamBtn.LayoutOrder = 5

-- Hitbox Panel
local hitboxPanel = Instance.new("Frame", rightPanel)
hitboxPanel.Name = "HitboxPanel"
hitboxPanel.Size = UDim2.new(1, 0, 1, 0)
hitboxPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hitboxPanel.BackgroundTransparency = 1
hitboxPanel.Visible = false

local hitboxPanelLayout = Instance.new("UIListLayout", hitboxPanel)
hitboxPanelLayout.Padding = UDim.new(0, 5)
hitboxPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hitboxPanelLayout.VerticalAlignment = Enum.VerticalAlignment.Top
hitboxPanelLayout.FillDirection = Enum.FillDirection.Vertical
hitboxPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder

local hitboxHeader = createHeader("Hitbox Modifiers", hitboxPanel)
hitboxHeader.LayoutOrder = 1
local hitboxBtn = createButton("Hitbox Enhance", hitboxPanel)
hitboxBtn.LayoutOrder = 2

-- Input Frame for Hitbox (horizontal layout within hitboxPanel)
local hitboxInputFrame = Instance.new("Frame")
hitboxInputFrame.Parent = hitboxPanel
hitboxInputFrame.Size = UDim2.new(1, -10, 0, 30)
hitboxInputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hitboxInputFrame.BackgroundTransparency = 1
hitboxInputFrame.LayoutOrder = 3

local hitboxInputLayout = Instance.new("UIListLayout", hitboxInputFrame)
hitboxInputLayout.Padding = UDim.new(0, 5)
hitboxInputLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hitboxInputLayout.FillDirection = Enum.FillDirection.Horizontal
hitboxInputLayout.SortOrder = Enum.SortOrder.LayoutOrder

local hitboxInput = createTextBox("HitboxSizeInput", hitboxInputFrame, "Size", hitboxSize, UDim2.new(0, 100, 0, 25))
hitboxInput.LayoutOrder = 1
local hitboxTransparencyInput = createTextBox("HitboxTransparencyInput", hitboxInputFrame, "Trans", hitboxTransparency, UDim2.new(0, 100, 0, 25))
hitboxTransparencyInput.LayoutOrder = 2

local teamCheckHitboxBtn = createButton("Hitbox Team Filter", hitboxPanel)
teamCheckHitboxBtn.LayoutOrder = 4

-- Misc Panel
local miscPanel = Instance.new("Frame", rightPanel)
miscPanel.Name = "MiscPanel"
miscPanel.Size = UDim2.new(1, 0, 1, 0)
miscPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
miscPanel.BackgroundTransparency = 1
miscPanel.Visible = false

local miscPanelLayout = Instance.new("UIListLayout", miscPanel)
miscPanelLayout.Padding = UDim.new(0, 5)
miscPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
miscPanelLayout.VerticalAlignment = Enum.VerticalAlignment.Top
miscPanelLayout.FillDirection = Enum.FillDirection.Vertical
miscPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder

local MiscHeader = createHeader("Misc Enhancements", miscPanel)
MiscHeader.LayoutOrder = 1
local headlessBtn = createButton("Headless", miscPanel)
headlessBtn.LayoutOrder = 2
local noclipBtn = createButton("Noclip", miscPanel)
noclipBtn.LayoutOrder = 3

local speedBtn = createButton("Speed", miscPanel)
speedBtn.LayoutOrder = 4

local speedInputTextBox = createTextBox("SpeedInput", miscPanel, "Speed (e.g. 50)", flyNoclipSpeed, UDim2.new(1, -10, 0, 25))
speedInputTextBox.LayoutOrder = 5

print("All UI elements created. Initializing highlights and ESP folders.")

local highlights = {}
local esp3DBoxFolder = Instance.new("Folder")
esp3DBoxFolder.Name = "ESP3DBoxes"
esp3DBoxFolder.Parent = Camera


local function updateHighlights()
	for plr, highlight in pairs(highlights) do
		if not Players:FindFirstChild(plr.Name) or not plr.Character or not plr.Character.Parent then
			highlight:Destroy()
			highlights[plr] = nil
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr == player then
			if highlights[plr] then
				highlights[plr].Enabled = false
			end
			continue
		end

		if espTeamCheck and player.Team and plr.Team and plr.Team == player.Team then
			if highlights[plr] then
				highlights[plr].Enabled = false
			end
			continue
		end

		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if not highlights[plr] then
				local highlight = Instance.new("Highlight")
				highlight.Parent = player.PlayerGui
				highlight.Adornee = plr.Character
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Enabled = esp

				local teamColor = plr.TeamColor.Color
				if plr.Team == nil or plr.TeamColor == nil or plr.TeamColor == BrickColor.new("Institutional white") then
					highlight.FillColor = Color3.new(1,1,1)
					highlight.OutlineColor = Color3.new(1,1,1)
				else
					highlight.FillColor = teamColor
					highlight.OutlineColor = teamColor
				end
				highlights[plr] = highlight
			else
				highlights[plr].Enabled = esp
			end
		end
	end
end

local function createESP3DBox(character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoidRootPart or not humanoid then return nil end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESP3DBox"
	box.Adornee = humanoidRootPart
	box.Size = Vector3.new(4, 6, 4)
	box.Color3 = Color3.fromRGB(0, 255, 0)
	box.Transparency = 0.5
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Parent = esp3DBoxFolder
	return box
end

local function applyESP3DBox(p)
	if esp3D and p ~= player and p.Character then
		if esp3DTeamCheck and player.Team and p.Team and p.Team == player.Team then
			if appliedESP3DBoxes[p] then
				appliedESP3DBoxes[p]:Destroy()
				appliedESP3DBoxes[p] = nil
			end
			return
		end

		local rootPart = p.Character:FindFirstChild("HumanoidRootPart")
		if rootPart and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			if not appliedESP3DBoxes[p] then
				appliedESP3DBoxes[p] = createESP3DBox(p.Character)
			end
		else
			removeESP3DBox(p)
		end
	else
		removeESP3DBox(p)
	end
end

local function removeESP3DBox(p)
	if appliedESP3DBoxes[p] then
		appliedESP3DBoxes[p]:Destroy()
		appliedESP3DBoxes[p] = nil
	end
end

local function updateESP3DBoxes()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			applyESP3DBox(p)
		else
			removeESP3DBox(p)
		end
	end
end

local function isTargetVisible(targetPlayer, targetPart)
	if not targetPlayer or not targetPlayer.Character or not targetPart then return false end

	local origin = Camera.CFrame.Position
	local targetPos = targetPart.Position
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local raycastResult = workspace:Raycast(origin, (targetPos - origin).Unit * (origin - targetPos).Magnitude, raycastParams)

	if raycastResult then
		return raycastResult.Instance:IsDescendantOf(targetPlayer.Character)
	end
	return false
end

local function getClosestVisibleTarget()
	local closestDist = math.huge
	local closestPlayer = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset) and plr.Character:FindFirstChild("Humanoid") then
			if player.Team and plr.Team and plr.Team == player.Team then
				continue
			end

			local humanoid = plr.Character.Humanoid
			if humanoid.Health > 0 then
				local targetPart = plr.Character[lockset]
				if isTargetVisible(plr, targetPart) then
					local origin = Camera.CFrame.Position
					local targetPos = targetPart.Position
					local dist = (origin - targetPos).Magnitude

					if dist < closestDist then
						closestDist = dist
						closestPlayer = plr
					end
				end
			end
		end
	end
	return closestPlayer
}

local function getRandomLivingTarget()
	local validTargets = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			table.insert(validTargets, plr)
		end
	end
	if #validTargets > 0 then
		return validTargets[math.random(1, #validTargets)]
	end
	return nil
}

local function applyHitboxToPlayer(p)
	if hitbox and p ~= player and p.Character then
		if teamCheckHitbox and player.Team and p.Team and p.Team == player.Team then
			resetHitboxesForPlayer(p)
			return
		end

		local part = p.Character:FindFirstChild("HumanoidRootPart")
		if part then
			part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
			part.Transparency = hitboxTransparency
			part.Material = Enum.Material.Neon
			part.BrickColor = BrickColor.new("Really black")
			part.CanCollide = false

			if not appliedHitboxes[p] or appliedHitboxes[p] == false then
				originalWalkSpeeds[p] = p.Character.Humanoid.WalkSpeed
				p.Character.Humanoid.WalkSpeed = 0
				appliedHitboxes[p] = true
			end
		end
	end
end

local function updateHitboxes()
	for _, p in pairs(Players:GetPlayers()) do
		applyHitboxToPlayer(p)
	end
end

local function resetHitboxesForPlayer(p)
	if p ~= player and p.Character then
		local part = p.Character:FindFirstChild("HumanoidRootPart")
		if part then
			part.Size = Vector3.new(2,2,1)
			part.Transparency = 1
			part.Material = Enum.Material.Plastic
			part.BrickColor = BrickColor.new("Medium stone grey")
			part.CanCollide = false
		end
	end
	if originalWalkSpeeds[p] then
		if p.Character and p.Character:FindFirstChild("Humanoid") then
			p.Character.Humanoid.WalkSpeed = originalWalkSpeeds[p]
		end
		originalWalkSpeeds[p] = nil
		appliedHitboxes[p] = nil
	end
end

local function resetAllHitboxes()
	for _, p in pairs(Players:GetPlayers()) do
		resetHitboxesForPlayer(p)
	end
end

local function performTeleport(plr)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character.HumanoidRootPart

	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
	local targetHRP = plr.Character.HumanoidRootPart
	local targetPos = targetHRP.Position

	hrp.CFrame = CFrame.new(targetPos)
end

local function handleTeleportLoop(dt)
	if not killAll then return end

	if not teleportTarget or not teleportTarget.Character or not teleportTarget.Character:FindFirstChild("Humanoid") or teleportTarget.Character.Humanoid.Health <= 0 then
		teleportTarget = getRandomLivingTarget()
		if not teleportTarget then
			killAll = false
			teleportLoopBtn.Text = "Teleport Loop: Off"
			showNotify("Teleport Loop: No active targets available.")
			return
		end
	end

	teleportTimer = teleportTimer + dt
	if teleportTimer >= teleportInterval then
		teleportTimer = 0
		if teleportTarget and teleportTarget.Character and teleportTarget.Character:FindFirstChild("Humanoid") then
			local humanoid = teleportTarget.Character.Humanoid
			if humanoid.Health > 0 then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					performTeleport(teleportTarget)
				end
				showNotify("Teleporting to: " .. teleportTarget.Name)
			end
		end
	end
end

local function updateLockBtn()
	lockBtn.Text = "Target Lock: " .. (lockset or "None")
end

local function applyNoclip()
	if player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				originalCanCollide[part] = part.CanCollide
				part.CanCollide = false
			end
		end
		showNotify("Noclip enabled.")
	end
end

local function disableNoclip()
	if player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") and originalCanCollide[part] ~= nil then
				part.CanCollide = originalCanCollide[part]
				originalCanCollide[part] = nil
			end
		end
		showNotify("Noclip disabled.")
	end
end

local function applyHeadless()
	if player.Character then
		local head = player.Character:FindFirstChild("Head")
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh"))
		if head then
			originalHeadTransparency = head.Transparency
			head.Transparency = 1
		end
		if face then
			originalFaceTransparency = face.Transparency
			face.Transparency = 1
		end
		showNotify("Headless enabled.")
	end
end

local function restoreHead()
	if player.Character then
		local head = player.Character:FindFirstChild("Head")
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh"))
		if head and originalHeadTransparency ~= nil then
			head.Transparency = originalHeadTransparency
			originalHeadTransparency = nil
		end
		if face and originalFaceTransparency ~= nil then
			face.Transparency = originalFaceTransparency
			originalFaceTransparency = nil
		end
		showNotify("Headless disabled.")
	end
end

-- Function to switch active panel
local function showPanel(panel)
    print("Switching to panel: " .. panel.Name)
	rightPanelLayout:JumpTo(panel)
end

-- Connect category buttons to panel switching
combatCategoryBtn.MouseButton1Click:Connect(function()
	showPanel(combatPanel)
end)

visualsCategoryBtn.MouseButton1Click:Connect(function()
	showPanel(visualsPanel)
end)

hitboxCategoryBtn.MouseButton1Click:Connect(function()
	showPanel(hitboxPanel)
end)

miscCategoryBtn.MouseButton1Click:Connect(function()
	showPanel(miscPanel)
end)


-- Connect GUI button events for functions
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
	if aimbot then
		showNotify("Aimbot functionality enabled. Targeting non-team players.")
		currentAimbotTarget = getClosestVisibleTarget()
		if not currentAimbotTarget then
			showNotify("Aimbot: No immediate valid targets detected.")
		end
	else
		showNotify("Aimbot functionality disabled.")
		currentAimbotTarget = nil
	end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "Player ESP: " .. (esp and "On" or "Off")
	updateHighlights()
	showNotify(esp and "Player ESP Display Enabled." or "Player ESP Display Disabled.")
end)

espTeamBtn.MouseButton1Click:Connect(function()
	espTeamCheck = not espTeamCheck
	espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off")
	if espTeamCheck then
		showNotify("Player ESP Team Filter: Only non-team players highlighted.")
	else
		showNotify("Player ESP Team Filter: All players highlighted (excluding self).")
	end
	updateHighlights()
end)

esp3DBtn.MouseButton1Click:Connect(function()
	esp3D = not esp3D
	esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off")
	if esp3D then
		showNotify("ESP 3D enabled. Visual boxes around players.")
		updateESP3DBoxes()
	else
		showNotify("ESP 3D disabled. Removing visual boxes.")
		for _, p in pairs(Players:GetPlayers()) do
			removeESP3DBox(p)
		end
	end
end)

esp3DTeamBtn.MouseButton1Click:Connect(function()
	esp3DTeamCheck = not esp3DTeamCheck
	esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
	if esp3DTeamCheck then
		showNotify("ESP 3D Team Filter enabled: Affects non-team players only.")
	else
		showNotify("ESP 3D Team Filter disabled: Affects all players.")
	end
	if esp3D then
		updateESP3DBoxes()
	end
end)

lockBtn.MouseButton1Click:Connect(function()
	currentLockPartIndex = currentLockPartIndex + 1
	if currentLockPartIndex > #lockParts then
		currentLockPartIndex = 1
	end
	lockset = lockParts[currentLockPartIndex]
	updateLockBtn()
	showNotify("Target Lockpoint set to: " .. lockset)
end)

teleportLoopBtn.MouseButton1Click:Connect(function()
	killAll = not killAll
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off")

	if killAll then
		teleportTarget = getRandomLivingTarget()
		if not teleportTarget then
			showNotify("Teleport Loop: No valid targets found.")
			killAll = false
			teleportLoopBtn.Text = "Teleport Loop: Off"
		else
			showNotify("Teleport Loop initiated. Teleporting to: " .. teleportTarget.Name)
		end
	else
		showNotify("Teleport Loop deactivated.")
		teleportTarget = nil
	end
end)

hitboxBtn.MouseButton1Click:Connect(function()
	hitbox = not hitbox
	hitboxBtn.Text = "Hitbox Enhancement: " .. (hitbox and "On" or "Off")

	if hitbox then
		showNotify("Hitbox enhancement enabled for external players. (Size: " .. hitboxSize .. ", Transparency: " .. hitboxTransparency .. ").")
		updateHitboxes()
		showNotify("Note: Client-side modifications may be reverted by game anti-cheat systems.")
	else
		showNotify("Hitbox enhancement disabled. Restoring default hitboxes.")
		resetAllHitboxes()
	end
end)

hitboxInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(hitboxInput.Text)
		if val and val >= 0 and val <= 300 then
			hitboxSize = val
			if hitbox then
				updateHitboxes()
			end
			showNotify("Hitbox Size updated to: " .. hitboxSize)
		else
			showNotify("Invalid Hitbox size. Please enter a value between 0-300.")
			hitboxInput.Text = tostring(hitboxSize)
		end
	end
end)

hitboxTransparencyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(hitboxTransparencyInput.Text)
		if val and val >= 0.0 and val <= 1.0 then
			hitboxTransparency = val
			if hitbox then
				updateHitboxes()
			end
			showNotify("Hitbox Transparency updated to: " .. hitboxTransparency)
		else
			showNotify("Invalid Transparency value. Please enter a value between 0.0-1.0.")
			hitboxTransparencyInput.Text = tostring(hitboxTransparency)
		end
	end
end)

teamCheckHitboxBtn.MouseButton1Click:Connect(function()
	teamCheckHitbox = not teamCheckHitbox
	teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
	if teamCheckHitbox then
		showNotify("Hitbox Team Filter enabled: Affects non-team players only.")
	else
		showNotify("Hitbox Team Filter disabled: Affects all players.")
	end
	if hitbox then
		resetAllHitboxes()
		updateHitboxes()
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off")
	if noclip then
		applyNoclip()
	else
		disableNoclip()
	end
end)

headlessBtn.MouseButton1Click:Connect(function()
	headless = not headless
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off")
	if headless then
		applyHeadless()
	else
		restoreHead()
	end
end)

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

speedInputTextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(speedInputTextBox.Text)
		if val and val > 0 then
			lastValidSpeed = val
			if speedEnabled then
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

print("Connecting player events and setting up GUI defaults.")

local function setupGUIAndDefaults()
	updateLockBtn()
	espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off")
	esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off")
	esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
	teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off")
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off")
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off")
    speedBtn.Text = "Speed: " .. (speedEnabled and "On" or "Off")
	-- Show initial panel (Combat)
	showPanel(combatPanel)
    print("GUI defaults set. Combat panel displayed.")
end

Players.PlayerAdded:Connect(function(newPlayer)
    print("PlayerAdded event triggered for: " .. newPlayer.Name)
	newPlayer.CharacterAdded:Connect(function(char)
        print("CharacterAdded event triggered for: " .. newPlayer.Name)
		if hitbox then
			applyHitboxToPlayer(newPlayer)
		end
		if esp3D then
			applyESP3DBox(newPlayer)
		end
		if noclip and newPlayer == player then
			disableNoclip()
			applyNoclip()
		end
		if headless and newPlayer == player then
			restoreHead()
			applyHeadless()
		end
	end)
	if esp3D then
		applyESP3DBox(newPlayer)
	end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    print("PlayerRemoving event triggered for: " .. leavingPlayer.Name)
	if originalWalkSpeeds[leavingPlayer] then
		originalWalkSpeeds[leavingPlayer] = nil
	end
	if appliedHitboxes[leavingPlayer] then
		appliedHitboxes[leavingPlayer] = nil
	end
	removeESP3DBox(leavingPlayer)
	if currentAimbotTarget == leavingPlayer then
		currentAimbotTarget = nil
	end
	if teleportTarget == leavingPlayer then
		teleportTarget = nil
	end
	updateHighlights()
end)

print("Checking access key.")
local function checkKey()
	local enteredKey = keyInputBox.Text:lower()
    print("Entered key: " .. enteredKey)
	if enteredKey == correctKey or enteredKey == "dev" then
		keyInputGui:Destroy()
        print("KeyInputGui destroyed.")
		mainFrame.Visible = true
		toggleBtn.Visible = true
        print("Main GUI and Toggle button set to visible.")
		setupGUIAndDefaults()
		showNotify("Access Granted. Key lifetime: " .. lifetimeWeeks .. " attempt(Weeks), (Days: " .. lifetimeDays .. "), (Hour: " .. lifetimeHour .. "), (Sec: " .. lifetimeSec .. ") remaining.")
		wait(0.5)
		showNotify("Access granted. Main interface now available.")
	else
		currentAttempts = currentAttempts + 1
		local remainingAttempts = maxAttempts - currentAttempts
        print("Invalid key. Remaining attempts: " .. remainingAttempts)
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
        print("KeyInputBox FocusLost event (Enter pressed).")
		checkKey()
	end
end)

keySubmitBtn.MouseButton1Click:Connect(function()
    print("KeySubmitBtn clicked.")
    checkKey()
end)

keyInputBox:CaptureFocus()
showNotify("Please authenticate your access key to proceed.")
print("Script finished initial setup. Waiting for RunService.RenderStepped and loop.")

RunService.RenderStepped:Connect(function(dt)
	if aimbot and lockset and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then
			local targetHumanoid = currentAimbotTarget.Character:FindFirstChild("Humanoid")
			local targetPart = currentAimbotTarget.Character[lockset]

			if not targetHumanoid or targetHumanoid.Health <= 0 or not isTargetVisible(currentAimbotTarget, targetPart) then
				currentAimbotTarget = nil
			end
		end

		if not currentAimbotTarget then
			currentAimbotTarget = getClosestVisibleTarget()
		end

		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then
			local targetPart = currentAimbotTarget.Character[lockset]
			local cameraPos = Camera.CFrame.Position
			local targetPos = targetPart.Position
			local direction = (targetPos - cameraPos).Unit
			local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
			Camera.CFrame = newCFrame
		end
	else
		currentAimbotTarget = nil
	end

	if killAll then
		handleTeleportLoop(dt)
	end

	if esp then
		updateHighlights()
	end
	if esp3D then
		updateESP3DBoxes()
	end

	if noclip and player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") and part.CanCollide then
				originalCanCollide[part] = part.CanCollide
				part.CanCollide = false
			end
		end
	end

	if headless and player.Character then
		local head = player.Character:FindFirstChild("Head")
		local face = head and (head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("SpecialMesh"))
		if head and head.Transparency < 1 then
			originalHeadTransparency = head.Transparency
			head.Transparency = 1
		end
		if face and face.Transparency < 1 then
			face.Transparency = originalFaceTransparency
			face.Transparency = 1
		end
	end
end)

-- Main loop for continuous updates
while true do
	wait(1)
	-- Only update ESP/ESP3D if the main GUI frame is visible
	-- This helps reduce unnecessary processing when the GUI is hidden
	if mainFrame.Visible then
		if esp then updateHighlights() end
		if esp3D then updateESP3DBoxes() end
	end
end
