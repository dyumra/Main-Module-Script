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
local StarterGui = game:GetService("StarterGui") -- Added for notifications

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
local lockParts = {"Head", "Torso", "UpperTorso", "HumanoidRootPart"}
local originalWalkSpeeds = {}
local appliedHitboxes = {} 
local appliedESP3DBoxes = {} 

local currentLockPartIndex = 2
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 1.5
local TELEPORT_VERTICAL_OFFSET = 0 

local AIMBOT_SWITCH_DISTANCE = 10 

local correctKey = "dyumra-k3b7-wp9d-a2n8"
local maxAttempts = 3
local currentAttempts = 0

-- Misc variables
local noclipEnabled = false
local noclipConnection = nil

local speedEnabled = false
local speedConnection = nil
local flyNoclipSpeed = 30 -- Default speed
local lastValidSpeed = 30 -- To store last valid speed

-- Folder for ESP3D adornments
local boxFolder = Instance.new("Folder")
boxFolder.Name = "ESP3DBoxes"
boxFolder.Parent = workspace.CurrentCamera -- Parent to camera to avoid replication issues

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
	StarterGui:SetCore("SendNotification", {
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
            StarterGui:SetCore("SendNotification", {
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
keySubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
keySubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmitBtn.Font = Enum.Font.GothamBold
keySubmitBtn.TextSize = 18
keySubmitBtn.Text = "SUBMIT KEY"
keySubmitBtn.AnchorPoint = Vector2.new(0.5, 0.5)

local keySubmitCorner = Instance.new("UICorner", keySubmitBtn)
keySubmitCorner.CornerRadius = UDim.new(0, 12)

local keySubmitStroke = Instance.new("UIStroke", keySubmitBtn)
keySubmitStroke.Color = Color3.fromRGB(0, 100, 200)
keySubmitStroke.Thickness = 2

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DyhubGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 600, 0, 400) -- Increased size for the new layout
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200) -- Center the GUI
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
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
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "DYHUB | V3.01 - Dyumra's Innovations"
titleLabel.ZIndex = 2

local closeButton = Instance.new("TextButton")
closeButton.Parent = titleBar
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Text = "X"
closeButton.ZIndex = 2

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Main content layout
local mainLayoutFrame = Instance.new("Frame")
mainLayoutFrame.Parent = mainFrame
mainLayoutFrame.Size = UDim2.new(1, 0, 1, -30)
mainLayoutFrame.Position = UDim2.new(0, 0, 0, 30)
mainLayoutFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainLayoutFrame.BackgroundTransparency = 0
mainLayoutFrame.BorderSizePixel = 0

local UIGridLayout_Main = Instance.new("UIGridLayout")
UIGridLayout_Main.Parent = mainLayoutFrame
UIGridLayout_Main.FillDirection = Enum.FillDirection.Horizontal
UIGridLayout_Main.CellSize = UDim2.new(0, 150, 1, 0) -- Left menu width
UIGridLayout_Main.StartCorner = Enum.StartCorner.TopLeft
UIGridLayout_Main.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIGridLayout_Main.VerticalAlignment = Enum.VerticalAlignment.Top
UIGridLayout_Main.Padding = UDim.new(0,0)

-- Left Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Parent = mainLayoutFrame
menuFrame.Size = UDim2.new(0, 150, 1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BackgroundTransparency = 0
menuFrame.BorderSizePixel = 0

local menuListLayout = Instance.new("UIListLayout")
menuListLayout.Parent = menuFrame
menuListLayout.FillDirection = Enum.FillDirection.Vertical
menuListLayout.Padding = UDim.new(0, 5)
menuListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
menuListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Right Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainLayoutFrame
contentFrame.Size = UDim2.new(1, -150, 1, 0) -- Fill remaining space
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BackgroundTransparency = 0
contentFrame.BorderSizePixel = 0

local contentPadding = Instance.new("UIPadding")
contentPadding.Parent = contentFrame
contentPadding.PaddingLeft = UDim.new(0, 10)
contentPadding.PaddingRight = UDim.new(0, 10)
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentFrame
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.Padding = UDim.new(0, 5)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder


-- Initial content message
local initialMessage = Instance.new("TextLabel")
initialMessage.Parent = contentFrame
initialMessage.Size = UDim2.new(1, 0, 1, 0)
initialMessage.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
initialMessage.BackgroundTransparency = 1
initialMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
initialMessage.Font = Enum.Font.GothamBold
initialMessage.TextSize = 24
initialMessage.Text = "Choose Function\nby dyumra"
initialMessage.TextWrapped = true
initialMessage.TextXAlignment = Enum.TextXAlignment.Center
initialMessage.TextYAlignment = Enum.TextYAlignment.Center


-- User Info Frame at the bottom left
local userInfoFrame = Instance.new("Frame")
userInfoFrame.Parent = menuFrame
userInfoFrame.Size = UDim2.new(1, -10, 0, 80)
userInfoFrame.Position = UDim2.new(0.5, 0, 1, -85) -- Anchor to bottom of menu frame
userInfoFrame.AnchorPoint = Vector2.new(0.5, 0)
userInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
userInfoFrame.BackgroundTransparency = 0
userInfoFrame.BorderSizePixel = 0
userInfoFrame.ZIndex = 2

local userInfoCorner = Instance.new("UICorner", userInfoFrame)
userInfoCorner.CornerRadius = UDim.new(0, 10)

local userInfoStroke = Instance.new("UIStroke", userInfoFrame)
userInfoStroke.Color = Color3.fromRGB(55, 55, 55)
userInfoStroke.Thickness = 1

local avatarFrame = Instance.new("Frame")
avatarFrame.Parent = userInfoFrame
avatarFrame.Size = UDim2.new(0, 60, 0, 60)
avatarFrame.Position = UDim2.new(0, 10, 0.5, 0)
avatarFrame.AnchorPoint = Vector2.new(0, 0.5)
avatarFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
avatarFrame.BorderSizePixel = 0

local avatarCorner = Instance.new("UICorner", avatarFrame)
avatarCorner.CornerRadius = UDim.new(0.5, 0) -- Makes it a circle

local userLabel = Instance.new("TextLabel")
userLabel.Parent = userInfoFrame
userLabel.Size = UDim2.new(1, -80, 0, 20)
userLabel.Position = UDim2.new(0, 80, 0, 10)
userLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 14
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Text = "USER: " .. player.Name

local idLabel = Instance.new("TextLabel")
idLabel.Parent = userInfoFrame
idLabel.Size = UDim2.new(1, -80, 0, 20)
idLabel.Position = UDim2.new(0, 80, 0, 40)
idLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
idLabel.BackgroundTransparency = 1
idLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
idLabel.Font = Enum.Font.GothamBold
idLabel.TextSize = 14
idLabel.TextXAlignment = Enum.TextXAlignment.Left
idLabel.Text = "ID: " .. player.UserId


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

local function createMenuButton(name, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0.5, 0, 0, 0)
	btn.AnchorPoint = Vector2.new(0.5, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = name
	btn.Parent = menuFrame
    btn.LayoutOrder = layoutOrder

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1

	return btn
end

local function createContentButton(name, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = name .. ": Off"
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1

	return btn
end

local function createContentTextBox(name, parent, placeholder, initialValue)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(1, 0, 0, 30)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18
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

local function clearContentFrame()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child ~= initialMessage then -- Keep the initial message for now
            child:Destroy()
        end
    end
    initialMessage.Visible = false
end

local function setNoClip(enabled)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
 
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function showCombatSettings()
    clearContentFrame()
    local aimbotBtn = createContentButton("Aimbot", contentFrame)
    local lockBtn = createContentButton("Target Lock", contentFrame)
    local teleportLoopBtn = createContentButton("Teleport Loop", contentFrame)

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
    lockBtn.MouseButton1Click:Connect(function()
        currentLockPartIndex = currentLockPartIndex + 1
        if currentLockPartIndex > #lockParts then
            currentLockPartIndex = 1
        end
        lockset = lockParts[currentLockPartIndex]
        lockBtn.Text = "Target Lock: " .. (lockset or "None")
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

    -- Update initial button states
    aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
    lockBtn.Text = "Target Lock: " .. (lockset or "None")
    teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off")
end

local function showVisualEnhancements()
    clearContentFrame()
    local espBtn = createContentButton("Player ESP", contentFrame)
    local espTeamBtn = createContentButton("Player ESP: Team Filter", contentFrame)
    local esp3DBtn = createContentButton("ESP 3D", contentFrame)
    local esp3DTeamBtn = createContentButton("ESP 3D: Team Filter", contentFrame)

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

    -- Update initial button states
    espBtn.Text = "Player ESP: " .. (esp and "On" or "Off")
    espTeamBtn.Text = "Player ESP: Team Filter: " .. (espTeamCheck and "On" or "Off")
    esp3DBtn.Text = "ESP 3D: " .. (esp3D and "On" or "Off")
    esp3DTeamBtn.Text = "ESP 3D: Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
end

local function showMiscEnhancements()
    clearContentFrame()
    local noclipBtn = createContentButton("NoClip", contentFrame)
    local speedBtn = createContentButton("Speed", contentFrame)
    local speedInputTextBox = createContentTextBox("SpeedInput", contentFrame, "Speed Value", flyNoclipSpeed)

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        noclipBtn.Text = "NoClip: " .. (noclipEnabled and "On" or "Off")
        setNoClip(noclipEnabled)
        showNotify(noclipEnabled and "NoClip Enabled." or "NoClip Disabled.")
    end)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedBtn.Text = "Speed: " .. (speedEnabled and "On" or "Off")

        if speedEnabled then
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
                flyNoclipSpeed = val
                lastValidSpeed = val
                showNotify("Speed value updated to: " .. flyNoclipSpeed)
                if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                    -- Re-apply speed if already enabled to use new value
                    showNotify("Speed re-applied with new value: " .. flyNoclipSpeed .. ".")
                end
            else
                showNotify("Invalid Speed value. Please enter a positive number.")
                speedInputTextBox.Text = tostring(lastValidSpeed)
            end
        end
    end)

    -- Update initial button states
    noclipBtn.Text = "NoClip: " .. (noclipEnabled and "On" or "Off")
    speedBtn.Text = "Speed: " .. (speedEnabled and "On" or "Off")
    speedInputTextBox.Text = tostring(flyNoclipSpeed)
end

local function showHitboxModifiers()
    clearContentFrame()
    local hitboxBtn = createContentButton("Hitbox Enhancement", contentFrame)
    local hitboxInput = createContentTextBox("HitboxSizeInput", contentFrame, "Hitbox Size (0-300)", hitboxSize)
    local hitboxTransparencyInput = createContentTextBox("HitboxTransparencyInput", contentFrame, "Transparency (0.0-1.0)", hitboxTransparency)
    local teamCheckHitboxBtn = createContentButton("Hitbox Team Filter", contentFrame)

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

    -- Update initial button states
    hitboxBtn.Text = "Hitbox Enhancement: " .. (hitbox and "On" or "Off")
    teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
end


-- Create Menu Buttons
local combatBtn = createMenuButton("Combat Settings", 1)
local visualBtn = createMenuButton("Visual Enhancements", 2)
local miscBtn = createMenuButton("Misc Enhancements", 3)
local hitboxBtn = createMenuButton("Hitbox Modifiers", 4)


-- Connect Menu Buttons to Content Functions
combatBtn.MouseButton1Click:Connect(showCombatSettings)
visualBtn.MouseButton1Click:Connect(showVisualEnhancements)
miscBtn.MouseButton1Click:Connect(showMiscEnhancements)
hitboxBtn.MouseButton1Click:Connect(showHitboxModifiers)


local highlights = {}

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

local function applyESP3DBox(p)
    if esp3D and p ~= player and p.Character then
        if esp3DTeamCheck and player.Team and p.Team and p.Team == player.Team then
            if appliedESP3DBoxes[p] then
                appliedESP3DBoxes[p]:Destroy()
                appliedESP3DBoxes[p] = nil
            end
            return 
        end

        local humanoidRootPart = p.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            if not appliedESP3DBoxes[p] then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP3DBox"
                box.Adornee = humanoidRootPart
                box.Size = Vector3.new(4, 6, 4) -- Approximate size to fit around a character
                box.Color3 = Color3.fromRGB(0, 255, 0) -- Green box
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = boxFolder -- Parent to the dedicated folder
                
                appliedESP3DBoxes[p] = box

            else
                -- If box exists, just update its properties in case transparency/color changed
                appliedESP3DBoxes[p].Transparency = 0.5
                appliedESP3DBoxes[p].Color3 = Color3.fromRGB(0, 255, 0)
                appliedESP3DBoxes[p].Size = Vector3.new(4, 6, 4)
            end
        end
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
            -- teleportLoopBtn.Text = "Teleport Loop: Off" -- Cannot directly update button from here
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

local function setupGUIAndDefaults()
    -- No direct updates needed here, as buttons update on category selection
end

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

local function checkKey()
    local enteredKey = keyInputBox.Text:lower()
    if enteredKey == correctKey or enteredKey == "dev" then
        keyInputGui:Destroy() 
        mainFrame.Visible = true 
        toggleBtn.Visible = true 
        setupGUIAndDefaults() 
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
    if esp3D then 
        updateESP3DBoxes()
    end
end)

keyInputBox:CaptureFocus() 
showNotify("Please authenticate your access key to proceed.")

-- Initial state: show initial message
initialMessage.Visible = true 

while true do
	wait(1)
	if mainFrame.Visible and esp then updateHighlights() end
    if esp3D then updateESP3DBoxes() end
end
