-- [[ Open Source Code !!! ]]

-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: 3.01 - Authenticated Interface Edition ]]
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
local esp3D = false
local esp3DTeamCheck = false
local killAll = false 
local hitbox = false
local hitboxSize = 0 
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

local currentLockPartIndex = 1
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 1.5
local TELEPORT_VERTICAL_OFFSET = 0 

local AIMBOT_SWITCH_DISTANCE = 10 

local correctKey = "dyumra-k3b7-wp9d-a2n8"
local maxAttempts = 3
local currentAttempts = 0
-- time lifetime (random values, not truly functional for a real lifetime system)
local lifetimeWeeks = math.random(10000, 12222)
local lifetimeDays = math.random(1, 31)
local lifetimeHour = math.random(1, 60)
local lifetimeSec = math.random(1, 60)

-- Function to detect a suitable lock part on a character
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

-- Function to show in-game notifications
local function showNotify(message)
	game.StarterGui:SetCore("SendNotification", {
		Title = "System Notification";
		Text = message;
		Duration = 3;
	})
end

-- Function to kick the player with a reason
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

-- Initial Key Authentication GUI (Remains largely the same)
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

-------------------------------------------------------------------------------------
-- New GUI Elements: DYHUB Main Interface
-------------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DYHUBGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 600, 0, 450) -- Adjusted size for the new layout
mainFrame.Position = UDim2.new(0.5, -(mainFrame.Size.X.Offset / 2), 0.5, -(mainFrame.Size.Y.Offset / 2))
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the frame
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false -- Hidden until authenticated

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(40, 40, 40)
mainStroke.Thickness = 2

local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
mainGradient.Transparency = NumberSequence.new(0.1, 0.1)
mainGradient.Rotation = 90

-- Header Bar (DYHUB | V3.01 - Dyumra's Innovations - X)
local headerBar = Instance.new("Frame")
headerBar.Parent = mainFrame
headerBar.Size = UDim2.new(1, 0, 0, 30)
headerBar.Position = UDim2.new(0, 0, 0, 0)
headerBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
headerBar.BorderSizePixel = 0

local headerTitle = Instance.new("TextLabel")
headerTitle.Parent = headerBar
headerTitle.Size = UDim2.new(1, -70, 1, 0)
headerTitle.Position = UDim2.new(0, 10, 0, 0)
headerTitle.Text = "DYHUB | V3.01 - Dyumra's Innovations"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 16
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.BackgroundTransparency = 1

local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = headerBar
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Navigation Panel (Left Side)
local navPanel = Instance.new("Frame")
navPanel.Parent = mainFrame
navPanel.Size = UDim2.new(0, 180, 1, -90) -- Height: mainFrame height - header - footer
navPanel.Position = UDim2.new(0, 0, 0, 30)
navPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
navPanel.BorderSizePixel = 0

local categories = {"Combat Settings", "Visual Enhancements", "Misc Enhancements", "Hitbox Modifiers"}
local categoryButtons = {}
local navY = 10 -- Starting Y position for buttons

local function createCategoryButton(name, yPos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = name
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1

	return btn
end

for i, categoryName in ipairs(categories) do
    local catBtn = createCategoryButton(categoryName, navY, navPanel)
    categoryButtons[categoryName] = catBtn
    navY = navY + catBtn.Size.Y.Offset + 10
end

-- Content Panel (Right Side)
local contentPanel = Instance.new("Frame")
contentPanel.Parent = mainFrame
contentPanel.Size = UDim2.new(1, -180, 1, -90) -- Remaining width and height
contentPanel.Position = UDim2.new(0, 180, 0, 30)
contentPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentPanel.BorderSizePixel = 0
contentPanel.ClipsDescendants = true

local contentCorner = Instance.new("UICorner", contentPanel)
contentCorner.CornerRadius = UDim.new(0, 12)

local contentStroke = Instance.new("UIStroke", contentPanel)
contentStroke.Color = Color3.fromRGB(40, 40, 40)
contentStroke.Thickness = 2


-- Initial message for content panel
local initialMessage = Instance.new("TextLabel")
initialMessage.Parent = contentPanel
initialMessage.Size = UDim2.new(1, 0, 1, 0)
initialMessage.Position = UDim2.new(0, 0, 0, 0)
initialMessage.Text = "Choose Function\nby dyumra"
initialMessage.TextColor3 = Color3.fromRGB(150, 150, 150)
initialMessage.Font = Enum.Font.GothamBold
initialMessage.TextSize = 24
initialMessage.BackgroundTransparency = 1
initialMessage.TextWrapped = true
initialMessage.TextYAlignment = Enum.TextYAlignment.Center

-- Individual content frames for each category
local combatFrame = Instance.new("Frame")
combatFrame.Name = "CombatFrame"
combatFrame.Parent = contentPanel
combatFrame.Size = UDim2.new(1, -20, 1, -20)
combatFrame.Position = UDim2.new(0, 10, 0, 10)
combatFrame.BackgroundTransparency = 1
combatFrame.Visible = false
combatFrame.ClipsDescendants = true

local visualFrame = Instance.new("Frame")
visualFrame.Name = "VisualFrame"
visualFrame.Parent = contentPanel
visualFrame.Size = UDim2.new(1, -20, 1, -20)
visualFrame.Position = UDim2.new(0, 10, 0, 10)
visualFrame.BackgroundTransparency = 1
visualFrame.Visible = false
visualFrame.ClipsDescendants = true

local miscFrame = Instance.new("Frame")
miscFrame.Name = "MiscFrame"
miscFrame.Parent = contentPanel
miscFrame.Size = UDim2.new(1, -20, 1, -20)
miscFrame.Position = UDim2.new(0, 10, 0, 10)
miscFrame.BackgroundTransparency = 1
miscFrame.Visible = false
miscFrame.ClipsDescendants = true
-- MiscFrame will hold potential future features or a simple "Coming Soon"

local hitboxFrame = Instance.new("Frame")
hitboxFrame.Name = "HitboxFrame"
hitboxFrame.Parent = contentPanel
hitboxFrame.Size = UDim2.new(1, -20, 1, -20)
hitboxFrame.Position = UDim2.new(0, 10, 0, 10)
hitboxFrame.BackgroundTransparency = 1
hitboxFrame.Visible = false
hitboxFrame.ClipsDescendants = true

local currentActivePanel = initialMessage -- Track which panel is currently visible

local function showPanel(panelToShow)
    if currentActivePanel == panelToShow then return end -- Don't switch if already active

    -- Hide current panel
    if currentActivePanel then
        currentActivePanel.Visible = false
    end

    -- Show new panel
    panelToShow.Visible = true
    currentActivePanel = panelToShow
end

-- Connect category buttons to panel visibility
categoryButtons["Combat Settings"].MouseButton1Click:Connect(function()
    showPanel(combatFrame)
end)
categoryButtons["Visual Enhancements"].MouseButton1Click:Connect(function()
    showPanel(visualFrame)
end)
categoryButtons["Misc Enhancements"].MouseButton1Click:Connect(function()
    showPanel(miscFrame)
    -- Add a "Coming Soon" label if Misc Enhancements has no specific features yet
    if #miscFrame:GetChildren() == 0 then
        local comingSoon = Instance.new("TextLabel")
        comingSoon.Parent = miscFrame
        comingSoon.Size = UDim2.new(1, 0, 1, 0)
        comingSoon.Text = "Features Coming Soon!"
        comingSoon.TextColor3 = Color3.fromRGB(120, 120, 120)
        comingSoon.Font = Enum.Font.GothamBold
        comingSoon.TextSize = 20
        comingSoon.BackgroundTransparency = 1
        comingSoon.TextWrapped = true
        comingSoon.TextYAlignment = Enum.TextYAlignment.Center
    end
end)
categoryButtons["Hitbox Modifiers"].MouseButton1Click:Connect(function()
    showPanel(hitboxFrame)
end)

-- Footer Panel
local footerPanel = Instance.new("Frame")
footerPanel.Parent = mainFrame
footerPanel.Size = UDim2.new(1, 0, 0, 60)
footerPanel.Position = UDim2.new(0, 0, 1, -60)
footerPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
footerPanel.BorderSizePixel = 0

local footerCorner = Instance.new("UICorner", footerPanel)
footerCorner.CornerRadius = UDim.new(0, 12) -- Match mainFrame corner

local footerStroke = Instance.new("UIStroke", footerPanel)
footerStroke.Color = Color3.fromRGB(50, 50, 50)
footerStroke.Thickness = 2

-- User Profile Icon Placeholder (O and [ ])
local profileFrame = Instance.new("Frame")
profileFrame.Parent = footerPanel
profileFrame.Size = UDim2.new(0, 40, 0, 40)
profileFrame.Position = UDim2.new(0, 15, 0.5, 0)
profileFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
profileFrame.AnchorPoint = Vector2.new(0, 0.5)

local profileCorner = Instance.new("UICorner", profileFrame)
profileCorner.CornerRadius = UDim.new(0, 5)

local profileStroke = Instance.new("UIStroke", profileFrame)
profileStroke.Color = Color3.fromRGB(80, 80, 80)
profileStroke.Thickness = 1

local profileCircle = Instance.new("Frame")
profileCircle.Parent = profileFrame
profileCircle.Size = UDim2.new(0, 20, 0, 20)
profileCircle.Position = UDim2.new(0.5, 0, 0.35, 0)
profileCircle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
profileCircle.AnchorPoint = Vector2.new(0.5, 0.5)

local circleCorner = Instance.new("UICorner", profileCircle)
circleCorner.CornerRadius = UDim.new(0.5, 0) -- Makes it a perfect circle

local profileBody = Instance.new("Frame")
profileBody.Parent = profileFrame
profileBody.Size = UDim2.new(0, 25, 0, 10)
profileBody.Position = UDim2.new(0.5, 0, 0.8, 0)
profileBody.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
profileBody.AnchorPoint = Vector2.new(0.5, 0.5)

local bodyCorner = Instance.new("UICorner", profileBody)
bodyCorner.CornerRadius = UDim.new(0, 5)

-- User Info Labels
local userInfoContainer = Instance.new("Frame")
userInfoContainer.Parent = footerPanel
userInfoContainer.Size = UDim2.new(0, 200, 1, 0)
userInfoContainer.Position = UDim2.new(0, 70, 0, 0) -- Offset from profileFrame
userInfoContainer.BackgroundTransparency = 1

local userLabel = Instance.new("TextLabel")
userLabel.Parent = userInfoContainer
userLabel.Size = UDim2.new(1, 0, 0.5, 0)
userLabel.Position = UDim2.new(0, 0, 0, 0)
userLabel.Text = "USER: " .. player.Name
userLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 14
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.BackgroundTransparency = 1

local idLabel = Instance.new("TextLabel")
idLabel.Parent = userInfoContainer
idLabel.Size = UDim2.new(1, 0, 0.5, 0)
idLabel.Position = UDim2.new(0, 0, 0.5, 0)
idLabel.Text = "ID: " .. player.UserId
idLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
idLabel.Font = Enum.Font.GothamBold
idLabel.TextSize = 14
idLabel.TextXAlignment = Enum.TextXAlignment.Left
idLabel.BackgroundTransparency = 1

-- Bypass Label
local bypassLabel = Instance.new("TextLabel")
bypassLabel.Parent = footerPanel
bypassLabel.Size = UDim2.new(0, 120, 1, 0)
bypassLabel.Position = UDim2.new(1, -130, 0, 0) -- Aligned right
bypassLabel.Text = "Bypass: b1.02"
bypassLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextSize = 14
bypassLabel.TextXAlignment = Enum.TextXAlignment.Right
bypassLabel.BackgroundTransparency = 1

-------------------------------------------------------------------------------------
-- Common GUI Creation Functions (adapted to new structure)
-------------------------------------------------------------------------------------

local function createButton(name, yPos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -20, 0, 35) -- Adjusted for inner frames
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
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

local function createTextBox(name, yPos, parent, placeholder, initialValue)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(1, -20, 0, 30) -- Adjusted for inner frames
	box.Position = UDim2.new(0, 10, 0, yPos)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18
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

-------------------------------------------------------------------------------------
-- Populate Content Frames with Controls
-------------------------------------------------------------------------------------

-- Combat Settings Controls
local combatY = 10
local aimbotBtn = createButton("Aimbot", combatY, combatFrame)
combatY = combatY + aimbotBtn.Size.Y.Offset + 10

local lockBtn = createButton("Target Lock", combatY, combatFrame)
combatY = combatY + lockBtn.Size.Y.Offset + 10

local teleportLoopBtn = createButton("Teleport Loop", combatY, combatFrame) 
combatY = combatY + teleportLoopBtn.Size.Y.Offset + 10

-- Visual Enhancements Controls
local visualY = 10
local espBtn = createButton("Player ESP", visualY, visualFrame)
visualY = visualY + espBtn.Size.Y.Offset + 10

local espTeamBtn = createButton("Player ESP: Team Filter", visualY, visualFrame) 
visualY = visualY + espTeamBtn.Size.Y.Offset + 10

local esp3DBtn = createButton("ESP 3D", visualY, visualFrame)
visualY = visualY + esp3DBtn.Size.Y.Offset + 10

local esp3DTeamBtn = createButton("ESP 3D: Team Filter", visualY, visualFrame)
visualY = visualY + esp3DTeamBtn.Size.Y.Offset + 10

-- Hitbox Modifiers Controls
local hitboxY = 10
local hitboxBtn = createButton("Hitbox Enhancement", hitboxY, hitboxFrame)
hitboxY = hitboxY + hitboxBtn.Size.Y.Offset + 10

local hitboxInput = createTextBox("HitboxSizeInput", hitboxY, hitboxFrame, "Hitbox Size (0-300)", hitboxSize) 
hitboxY = hitboxY + hitboxInput.Size.Y.Offset + 10

local hitboxTransparencyInput = createTextBox("HitboxTransparencyInput", hitboxY, hitboxFrame, "Transparency (0.0-1.0)", hitboxTransparency) 
hitboxY = hitboxY + hitboxTransparencyInput.Size.Y.Offset + 10

local teamCheckHitboxBtn = createButton("Hitbox Team Filter", hitboxY, hitboxFrame) 
hitboxY = hitboxY + teamCheckHitboxBtn.Size.Y.Offset + 10


local highlights = {}

-- Function to update player highlights for ESP
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

-- Function to apply ESP 3D box to a player
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
        if rootPart then
            if not appliedESP3DBoxes[p] then
                local box = Instance.new("Part")
                box.Name = "ESP3DBox"
                box.Size = Vector3.new(3, 7, 1) -- A reasonable size for a player box
                box.Transparency = 0.6
                box.BrickColor = BrickColor.new("Really red")
                box.CanCollide = false
                box.Anchored = true
                box.Parent = workspace.CurrentCamera -- Parent to camera to always be visible (client-side)
                
                -- Create a Weld to keep the box attached to the player's HumanoidRootPart
                local weld = Instance.new("WeldConstraint")
                weld.Parent = box
                weld.Part0 = box
                weld.Part1 = rootPart
                
                box.CFrame = rootPart.CFrame -- Initial position

                appliedESP3DBoxes[p] = box

            else
                -- If box exists, just update its properties in case transparency/color changed
                appliedESP3DBoxes[p].Transparency = 0.6
                appliedESP3DBoxes[p].BrickColor = BrickColor.new("Really red")
            end
        end
    end
end

-- Function to remove ESP 3D box from a player
local function removeESP3DBox(p)
    if appliedESP3DBoxes[p] then
        appliedESP3DBoxes[p]:Destroy()
        appliedESP3DBoxes[p] = nil
    end
end

-- Function to update all ESP 3D boxes
local function updateESP3DBoxes()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            if esp3D and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                applyESP3DBox(p)
            else
                removeESP3DBox(p)
            end
        else
            removeESP3DBox(p) -- Ensure local player's box is removed
        end
    end
end

-- Checks if target is visible to the camera
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

-- Gets the closest visible target for Aimbot
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

-- Gets a random living target for Teleport Loop
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

-- Applies hitbox enhancement to a player
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
                -- To prevent issues with game anti-cheat, it's generally not recommended to
                -- set other players' walkspeed to 0 on the client. Removing this line.
                appliedHitboxes[p] = true
            end
        end
    end
end

-- Updates hitboxes for all players
local function updateHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        applyHitboxToPlayer(p)
    end
end

-- Resets hitbox modifications for a specific player
local function resetHitboxesForPlayer(p)
    if p ~= player and p.Character then
        local part = p.Character:FindFirstChild("HumanoidRootPart")
        if part then
            part.Size = Vector3.new(2,2,1) -- Default Roblox HumanoidRootPart size
            part.Transparency = 1 
            part.Material = Enum.Material.Plastic 
            part.BrickColor = BrickColor.new("Medium stone grey") 
            part.CanCollide = false 
        end
    end
    if originalWalkSpeeds[p] then
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            -- Revert walkspeed if it was changed (though it's no longer changed in applyHitboxToPlayer)
            -- p.Character.Humanoid.WalkSpeed = originalWalkSpeeds[p]
        end
        originalWalkSpeeds[p] = nil
        appliedHitboxes[p] = nil
    end
end

-- Resets all hitbox modifications
local function resetAllHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        resetHitboxesForPlayer(p)
    end
end

-- Performs teleportation to a target player
local function performTeleport(plr)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart

    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local targetHRP = plr.Character.HumanoidRootPart
    local targetPos = targetHRP.Position

    hrp.CFrame = CFrame.new(targetPos) 
end

-- Handles the teleport loop logic
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

-- Updates the text of the Target Lock button
local function updateLockBtn()
	lockBtn.Text = "Target Lock: " .. (lockset or "None")
end

-------------------------------------------------------------------------------------
-- Event Connections for New GUI Elements
-------------------------------------------------------------------------------------

-- Aimbot Button
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

-- Player ESP Button
espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "Player ESP: " .. (esp and "On" or "Off")
	updateHighlights()
	showNotify(esp and "Player ESP Display Enabled." or "Player ESP Display Disabled.")
end)

-- Player ESP Team Filter Button
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

-- ESP 3D Button
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

-- ESP 3D Team Filter Button
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

-- Target Lock Button
lockBtn.MouseButton1Click:Connect(function()
	currentLockPartIndex = currentLockPartIndex + 1
	if currentLockPartIndex > #lockParts then
		currentLockPartIndex = 1
	end
	lockset = lockParts[currentLockPartIndex]
	updateLockBtn()
	showNotify("Target Lockpoint set to: " .. lockset)
end)

-- Teleport Loop Button
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

-- Hitbox Enhancement Button
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

-- Hitbox Size Input
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

-- Hitbox Transparency Input
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

-- Hitbox Team Filter Button
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

-- Function to set initial GUI states after authentication
local function setupGUIAndDefaults()
    updateLockBtn()
    aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
    espBtn.Text = "Player ESP: " .. (esp and "On" or "Off")
    espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off") 
    esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off")
    esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
    hitboxBtn.Text = "Hitbox Enhancement: " .. (hitbox and "On" or "Off")
    teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
    teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off") 
end

-- Player Added/Removed Listeners
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if hitbox then
            applyHitboxToPlayer(newPlayer)
        end
        if esp3D then
            applyESP3DBox(newPlayer)
        end
    end)
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
    removeESP3DBox(leavingPlayer)
	if currentAimbotTarget == leavingPlayer then
		currentAimbotTarget = nil
	end
	if teleportTarget == leavingPlayer then 
		teleportTarget = nil 
	end
    updateHighlights() 
end)

-- Key authentication logic
local function checkKey()
    local enteredKey = keyInputBox.Text:lower()
    if enteredKey == correctKey then
        keyInputGui:Destroy() -- Destroy authentication GUI
        mainFrame.Visible = true -- Show new main GUI
        setupGUIAndDefaults() -- Set initial button texts
	showNotify("Access Granted. Key lifetime: " .. lifetimeWeeks .. " attempt(Weeks), (Days: " .. lifetimeDays .. "), (Hour: " .. lifetimeHour .. "), (Sec: " .. lifetimeSec .. ") remaining.")
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

-- Main game loop for updates (Aimbot, Teleport, ESP)
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

	-- Update ESP and ESP 3D visuals only if their respective frames are visible
    if esp then
		updateHighlights()
	end
    if esp3D then
        updateESP3DBoxes()
    end
end)

-- Initial focus for the key input box and notification
keyInputBox:CaptureFocus() 
showNotify("Please authenticate your access key to proceed.")

-- Continuous loop for updating ESP elements (if mainFrame is visible)
while true do
	wait(1)
	-- The RenderStepped already handles updates, this loop can be for less frequent checks if needed.
	-- For now, it mainly ensures the script stays active.
end
