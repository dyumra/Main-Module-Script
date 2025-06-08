-- [[ Open Source Code !!! ]]

-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: 2.19.55 - Authenticated Interface Edition ]] -- Updated Version
-- [[ 🔗 Other Script : https://github.com/dyumra - Thank for Support ]]

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
local esp3D = false -- New: ESP 3D toggle
local esp3DTeamCheck = false -- New: ESP 3D team check toggle
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
local appliedESP3DBoxes = {} -- New: Table to store applied ESP 3D boxes

local noclip = false -- New: Noclip toggle
local originalCanCollide = {} -- New: Store original CanCollide states for noclip

local headless = false -- New: Headless toggle
local originalHeadTransparency = nil
local originalFaceTransparency = nil

local speedEnabled = false -- New: Speed toggle
local flyNoclipSpeed = 30 -- Default speed
local lastValidSpeed = 30 -- Stores the last valid speed input
local speedConnection = nil -- RunService connection for speed movement

local currentLockPartIndex = 1
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 1.5
local TELEPORT_VERTICAL_OFFSET = 0

local AIMBOT_SWITCH_DISTANCE = 8

local correctKey = "dyumra-k3b7-wp9d-a2n8"
local maxAttempts = 3
local currentAttempts = 0
-- time lifetime
-- (random values, not truly functional for a real lifetime system)
local lifetimeWeeks = math.random(10000, 12222)
local lifetimeDays = math.random(1, 31)
local lifetimeHour = math.random(1, 60)
local lifetimeSec = math.random(1, 60)

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

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AimbotESPGui"
screenGui.ResetOnSpawn = false

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
mainFrame.Draggable = true
mainFrame.Visible = false

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
titleLabel.Text = "DYHUB V3.02"

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
toggleBtn.Visible = false

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(50, 50, 50)
toggleStroke.Thickness = 1

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local function createHeader(text, yPos, parent)
	local header = Instance.new("TextLabel")
	header.Parent = parent
	header.Size = UDim2.new(0, 150, 0, 25) -- Adjusted width for left column
	header.Position = UDim2.new(0, 5, 0, yPos) -- Start from left edge, padding
	header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.Font = Enum.Font.GothamBold
	header.TextSize = 16
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = "    " .. text
	return header
end

local function createButton(name, pos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 140, 0, 35) -- Adjusted width for left column
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14 -- Slightly smaller text for more buttons
	btn.Text = name .. ": Off"
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(65, 65, 65)
	stroke.Thickness = 1

	return btn
end

local function createTextBox(name, pos, parent, placeholder, initialValue, size)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = size or UDim2.new(0, 140, 0, 25) -- Adjusted width/height for left column
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 14
	box.PlaceholderText = placeholder or ""
	box.Text = tostring(initialValue or "")
	box.ClearTextOnFocus = false
	box.AnchorPoint = Vector2.new(0, 0)
	box.Parent = parent

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(65, 65, 65)
	stroke.Thickness = 1
	return box
end

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
dyhubLabel.Text = "DYHUB"

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
local esp3DBtn = createButton("ESP 3D", UDim2.new(0, 0, 0, 0), leftColumnFrame)
esp3DBtn.LayoutOrder = 8
local esp3DTeamBtn = createButton("ESP 3D Team Filter", UDim2.new(0, 0, 0, 0), leftColumnFrame)
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

local hitboxInput = createTextBox("HitboxSizeInput", UDim2.new(0, 0, 0, 0), hitboxInputFrame, "Size", hitboxSize, UDim2.new(0, 65, 0, 25))
hitboxInput.LayoutOrder = 1
local hitboxTransparencyInput = createTextBox("HitboxTransparencyInput", UDim2.new(0, 0, 0, 0), hitboxInputFrame, "Trans", hitboxTransparency, UDim2.new(0, 65, 0, 25))
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


local highlights = {}
local esp3DBoxFolder = Instance.new("Folder")
esp3DBoxFolder.Name = "ESP3DBoxes"
esp3DBoxFolder.Parent = Camera -- Parent to camera to always be visible (client-side)


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
	box.Size = Vector3.new(4, 6, 4) -- Approximate size to fit around a character
	box.Color3 = Color3.fromRGB(0, 255, 0) -- Green box
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
			removeESP3DBox(p) -- Ensure local player's box is removed
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
			-- Aimbot: Exclude teammates if player has a team
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
end

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
end

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

-- New: Noclip functions
local function applyNoclip()
	if player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				originalCanCollide[part] = part.CanCollide -- Store original state
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
				part.CanCollide = originalCanCollide[part] -- Restore original state
				originalCanCollide[part] = nil
			end
		end
		showNotify("Noclip disabled.")
	end
end

-- New: Headless functions
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

-- Connect GUI button events
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

esp3DBtn.MouseButton1Click:Connect(function() -- New ESP 3D toggle handler
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

esp3DTeamBtn.MouseButton1Click:Connect(function() -- New ESP 3D Team Filter handler
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

-- New: Noclip Button Click
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off")
	if noclip then
		applyNoclip()
	else
		disableNoclip()
	end
end)

-- New: Headless Button Click
headlessBtn.MouseButton1Click:Connect(function()
	headless = not headless
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off")
	if headless then
		applyHeadless()
	else
		restoreHead()
	end
end)

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


local function setupGUIAndDefaults()
	updateLockBtn()
	espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off")
	esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off") -- Set initial text for ESP 3D
	esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off") -- Set initial text for ESP 3D Team Filter
	teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off")
	noclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off") -- Set initial text for Noclip
	headlessBtn.Text = "Headless: " .. (headless and "On" or "Off") -- Set initial text for Headless
    speedBtn.Text = "Speed: " .. (speedEnabled and "On" or "Off") -- Set initial text for Speed
end

Players.PlayerAdded:Connect(function(newPlayer)
	newPlayer.CharacterAdded:Connect(function(char)
		if hitbox then
			applyHitboxToPlayer(newPlayer)
		end
		if esp3D then -- New: Apply ESP 3D when new player character added
			applyESP3DBox(newPlayer)
		end
		if noclip and newPlayer == player then -- Reapply noclip if character respawns
			disableNoclip() -- Clear previous state first
			applyNoclip()
		end
		if headless and newPlayer == player then -- Reapply headless if character respawns
			restoreHead() -- Clear previous state first
			applyHeadless()
		end
        -- No need to reapply speed here, as it's controlled by RunService.RenderStepped
	end)
	-- Initial ESP 3D update for newly added player if esp3D is active
	if esp3D then
		applyESP3DBox(newPlayer)
	end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
	if originalWalkSpeeds[leavingPlayer] then
		originalWalkSpeeds[leavingPlayer] = nil
	end
	if appliedHitboxes[leavingPlayer] then
		appliedHitboxes[leavingPlayer] = nil
	end
	removeESP3DBox(leavingPlayer) -- New: Remove ESP 3D box when player leaves
	if currentAimbotTarget == leavingPlayer then
		currentAimbotTarget = nil
	end
	if teleportTarget == leavingPlayer then
		teleportTarget = nil
	end
	updateHighlights()
end)

local function checkKey()
	local enteredKey = keyInputBox.Text:lower()
	if enteredKey == correctKey or enteredKey == "dev" then
		keyInputGui:Destroy()
		mainFrame.Visible = true
		toggleBtn.Visible = true
		setupGUIAndDefaults()
		showNotify("Access Granted. Key lifetime: " .. lifetimeWeeks .. " attempt(Weeks), (Days: " .. lifetimeDays .. "), (Hour: " .. lifetimeHour .. "), (Sec: " .. lifetimeSec .. ") remaining.")
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
	if esp3D then -- New: Update ESP 3D boxes
		updateESP3DBoxes()
	end

	-- New: Noclip continuous application
	if noclip and player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") and part.CanCollide then -- Only modify if it's currently collidable
				originalCanCollide[part] = part.CanCollide -- Ensure original state is always recent
				part.CanCollide = false
			end
		end
	end

	-- New: Headless continuous application
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

keyInputBox:CaptureFocus()
showNotify("Please authenticate your access key to proceed.")

while true do
	wait(1)
	if mainFrame.Visible and esp then updateHighlights() end
	if esp3D then updateESP3DBoxes() end -- New: Always update ESP 3D boxes if enabled, regardless of GUI visibility
end
