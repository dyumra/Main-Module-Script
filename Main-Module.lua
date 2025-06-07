-- [[ Open Source Code !!! ]]
-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: 3.00.5 - Authenticated Interface Edition ]]
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
local killAll = false 
local hitbox = false
local hitboxSize = 0 
local hitboxTransparency = 0.7 
local teamCheckHitbox = false 
local currentAimbotTarget = nil
local teleportTarget = nil 
local teleportInterval = 0.15 
local teleportTimer = 0 
local lockParts = {"Not Set!", "Head", "Torso", "UpperTorso", "HumanoidRootPart"}
local originalWalkSpeeds = {}
local appliedHitboxes = {} 

local currentLockPartIndex = 1
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 1.5
local TELEPORT_VERTICAL_OFFSET = 0 

local AIMBOT_SWITCH_DISTANCE = 10 

local correctKey = "test" -- key test not working
local maxAttempts = 3
local currentAttempts = 0

-- New ESP 3D variables
local esp3D = false
local esp3DTeamCheck = false
local esp3DBoxes = {} -- Stores the part boxes for ESP 3D

local function detectLockSet(character)
	if character:FindFirstChild("Torso") then
		return "Torso"
	elseif character:FindFirstChild("UpperTorso") then
		return "UpperTorso"
	elseif character:FindFirstChild("HumanoidRootPart") then
		return "HumanoidRootPart"
	elseif character:FindFirstChild("Head") then
		return "Head"
	elseif character:FindFirstChild("Not Set!") then
		return "Not Set!"
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

-- Key Input GUI (ไม่เปลี่ยนแปลง)
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

-- Enhanced Main GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EnhancedAimbotESPGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 490) -- ปรับขนาดให้ใหญ่ขึ้นเพื่อรองรับปุ่มใหม่
mainFrame.Position = UDim2.new(0, 20, 0, 50) 
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true
mainFrame.Draggable = true -- ทำให้ลากได้
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

-- Title Bar for Main GUI
local titleBar = Instance.new("TextLabel")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 18
titleBar.Text = "Dyumra's Execution Module"
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.TextWrapped = true
titleBar.Parent = mainFrame

local titlePadding = Instance.new("UIPadding", titleBar)
titlePadding.PaddingLeft = UDim.new(0, 10)

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

-- Function to create stylish buttons
local function createStyledButton(name, pos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 230, 0, 35)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Darker gray
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16 -- Slightly smaller text for more buttons
	btn.Text = name .. ": Off"
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(70, 70, 70) -- Slightly lighter gray for stroke
    stroke.Thickness = 1

	return btn
end

-- Function to create stylish text boxes
local function createStyledTextBox(name, pos, parent, placeholder, initialValue)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 230, 0, 30)
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(55, 55, 55) -- Slightly lighter gray for input
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 16
	box.PlaceholderText = placeholder or ""
	box.Text = tostring(initialValue or "")
	box.ClearTextOnFocus = false
	box.AnchorPoint = Vector2.new(0, 0)
	box.Parent = parent

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(80, 80, 80) -- Slightly lighter gray for stroke
    stroke.Thickness = 1
	return box
end

-- Section Title Helper Function
local function createSectionTitle(text, yPos, parent)
    local title = Instance.new("TextLabel")
    title.Parent = parent
    title.Size = UDim2.new(1, -30, 0, 25)
    title.Position = UDim2.new(0, 15, 0, yPos)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    title.TextColor3 = Color3.fromRGB(150, 200, 255) -- Light blue for titles
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text
    title.Parent = parent
    return title
end

-- --- GUI Elements ---
local currentYPos = 50 -- Start position after title bar

-- Aimbot Section
createSectionTitle("Aimbot Settings:", currentYPos, mainFrame)
currentYPos = currentYPos + 30
local aimbotBtn = createStyledButton("Aimbot", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45
local lockBtn = createStyledButton("Target Lock", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45

-- ESP Section
createSectionTitle("ESP Options:", currentYPos, mainFrame)
currentYPos = currentYPos + 30
local espBtn = createStyledButton("ESP (Outline)", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45
local espTeamBtn = createStyledButton("ESP (Outline) Team Filter", UDim2.new(0, 15, 0, currentYPos), mainFrame) 
currentYPos = currentYPos + 45
local esp3DBtn = createStyledButton("ESP 3D (Box)", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45
local esp3DTeamBtn = createStyledButton("ESP 3D (Box) Team Filter", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45

-- Hitbox Section
createSectionTitle("Hitbox Enhancements:", currentYPos, mainFrame)
currentYPos = currentYPos + 30
local hitboxBtn = createStyledButton("Hitbox Enhancement", UDim2.new(0, 15, 0, currentYPos), mainFrame)
currentYPos = currentYPos + 45
local hitboxInput = createStyledTextBox("HitboxSizeInput", UDim2.new(0, 15, 0, currentYPos), mainFrame, "ขนาด Hitbox (0-300)", hitboxSize) 
currentYPos = currentYPos + 40
local hitboxTransparencyInput = createStyledTextBox("HitboxTransparencyInput", UDim2.new(0, 15, 0, currentYPos), mainFrame, "ความโปร่งใส (0.0-1.0)", hitboxTransparency) 
currentYPos = currentYPos + 40
local teamCheckHitboxBtn = createStyledButton("Hitbox Team Filter", UDim2.new(0, 15, 0, currentYPos), mainFrame) 
currentYPos = currentYPos + 45

-- Teleport Section
createSectionTitle("Teleport Features:", currentYPos, mainFrame)
currentYPos = currentYPos + 30
local teleportLoopBtn = createStyledButton("Teleport Loop (Kill All)", UDim2.new(0, 15, 0, currentYPos), mainFrame) 
currentYPos = currentYPos + 45

-- --- End GUI Elements ---

local highlights = {} -- For original ESP (outline)

-- --- ESP 3D Functions ---
local function createESP3DBox(targetCharacter)
    local box = Instance.new("Part")
    box.Name = "ESP3DBox_" .. targetCharacter.Name
    box.Parent = workspace
    box.Transparency = 0.7 -- Adjust as needed
    box.BrickColor = BrickColor.new("Really red") -- Red color for non-team players
    box.CanCollide = false
    box.Anchored = true
    box.Material = Enum.Material.Neon
    box.FormFactor = Enum.FormFactor.Symmetric
    box.Size = Vector3.new(3, 6, 1.5) -- Default size for a humanoid box

    -- Weld the box to the HumanoidRootPart for movement
    local weld = Instance.new("WeldConstraint")
    weld.Parent = box
    weld.Part0 = box
    weld.Part1 = targetCharacter:WaitForChild("HumanoidRootPart")

    -- Add a BillboardGui for player name (optional)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 100, 0, 20)
    billboardGui.ExtentsOffset = Vector3.new(0, 3, 0) -- Above the box
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboardGui
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.8
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.TextWrapped = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = targetCharacter.Name
    
    return box
end

local function updateESP3DBoxes()
    -- Clean up removed players
    for plr, box in pairs(esp3DBoxes) do
        if not Players:FindFirstChild(plr.Name) or not plr.Character or not plr.Character.Parent or not box.Parent then
            if box.Parent then box:Destroy() end
            esp3DBoxes[plr] = nil
        end
    end

    -- Create or update boxes for current players
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == player then continue end -- ไม่ต้อง ESP ตัวเอง

        local shouldHighlight = esp3D and (not esp3DTeamCheck or (player.Team and plr.Team and plr.Team ~= player.Team) or (not player.Team or not plr.Team))

        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not esp3DBoxes[plr] and shouldHighlight then
                local box = createESP3DBox(plr.Character)
                esp3DBoxes[plr] = box
            elseif esp3DBoxes[plr] and not shouldHighlight then
                esp3DBoxes[plr]:Destroy()
                esp3DBoxes[plr] = nil
            elseif esp3DBoxes[plr] and shouldHighlight then
                -- Update box properties (e.g., color for team check)
                local box = esp3DBoxes[plr]
                local isTeamMate = player.Team and plr.Team and player.Team == plr.Team
                if isTeamMate then
                    box.BrickColor = BrickColor.new("Institutional white") -- White for teammates
                else
                    box.BrickColor = BrickColor.new("Really red") -- Red for enemies
                end
                -- Update position if not using WeldConstraint (but WeldConstraint is better)
                -- box.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0.5,0)
            end
        else -- Player character not found or died
            if esp3DBoxes[plr] then
                esp3DBoxes[plr]:Destroy()
                esp3DBoxes[plr] = nil
            end
        end
    end
end

local function clearAllESP3DBoxes()
    for plr, box in pairs(esp3DBoxes) do
        if box.Parent then
            box:Destroy()
        end
        esp3DBoxes[plr] = nil
    end
end

-- --- Original ESP (Outline) Functions ---
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
				highlight.Parent = player.PlayerGui -- highlight should be in PlayerGui
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

-- Adjusted getClosestVisibleTarget for Aimbot team check
local function getClosestVisibleTarget()
	local closestDist = math.huge
	local closestPlayer = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset) and plr.Character:FindFirstChild("Humanoid") then
			local humanoid = plr.Character.Humanoid
			if humanoid.Health > 0 then
                -- Aimbot Team Check: Aim at everyone if no team, or at non-team players if on a team
                if (not player.Team) or (player.Team and plr.Team and plr.Team ~= player.Team) or (player.Team and not plr.Team) then
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

-- --- Button Click Event Handlers ---
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
	if aimbot then
		showNotify("Aimbot functionality enabled.")
		currentAimbotTarget = getClosestVisibleTarget() 
		if not currentAimbotTarget then
			showNotify("Aimbot: No immediate targets detected.")
		end
	else
		showNotify("Aimbot functionality disabled.")
		currentAimbotTarget = nil
	end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP (Outline): " .. (esp and "On" or "Off")
	updateHighlights()
	showNotify(esp and "ESP Display Enabled." or "ESP Display Disabled.")
end)

espTeamBtn.MouseButton1Click:Connect(function() 
    espTeamCheck = not espTeamCheck
    espTeamBtn.Text = "ESP (Outline) Team Filter: " .. (espTeamCheck and "On" or "Off")
    if espTeamCheck then
        showNotify("ESP (Outline) Team Filter: Only non-team players highlighted.")
    else
        showNotify("ESP (Outline) Team Filter: All players highlighted (excluding self).")
    end
    updateHighlights() 
end)

esp3DBtn.MouseButton1Click:Connect(function()
    esp3D = not esp3D
    esp3DBtn.Text = "ESP 3D (Box): " .. (esp3D and "On" or "Off")
    if esp3D then
        showNotify("ESP 3D (Box) enabled for external players.")
        updateESP3DBoxes()
    else
        showNotify("ESP 3D (Box) disabled. Removing all boxes.")
        clearAllESP3DBoxes()
    end
end)

esp3DTeamBtn.MouseButton1Click:Connect(function()
    esp3DTeamCheck = not esp3DTeamCheck
    esp3DTeamBtn.Text = "ESP 3D (Box) Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
    if esp3DTeamCheck then
        showNotify("ESP 3D (Box) Team Filter enabled: Affects non-team players only.")
    else
        showNotify("ESP 3D (Box) Team Filter disabled: Affects all players.")
    end
    updateESP3DBoxes() -- Update immediately to reflect filter change
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
	teleportLoopBtn.Text = "Teleport Loop (Kill All): " .. (killAll and "On" or "Off") 

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

local function setupGUIAndDefaults()
    updateLockBtn()
    espTeamBtn.Text = "ESP (Outline) Team Filter: " .. (espTeamCheck and "On" or "Off") 
    esp3DBtn.Text = "ESP 3D (Box): " .. (esp3D and "On" or "Off")
    esp3DTeamBtn.Text = "ESP 3D (Box) Team Filter: " .. (esp3DTeamCheck and "On" or "Off")
    teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
    teleportLoopBtn.Text = "Teleport Loop (Kill All): " .. (killAll and "On" or "Off") 
end

-- Player Added/Removing Handlers
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if hitbox then
            applyHitboxToPlayer(newPlayer)
        end
        -- Auto-ESP for new players if enabled
        if esp then updateHighlights() end
        if esp3D then updateESP3DBoxes() end
    end)
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if originalWalkSpeeds[leavingPlayer] then
        originalWalkSpeeds[leavingPlayer] = nil
    end
    if appliedHitboxes[leavingPlayer] then
        appliedHitboxes[leavingPlayer] = nil
    end
	if currentAimbotTarget == leavingPlayer then
		currentAimbotTarget = nil
	end
	if teleportTarget == leavingPlayer then 
		teleportTarget = nil 
	end
    updateHighlights() 
    if esp3DBoxes[leavingPlayer] then -- Clean up ESP 3D box
        esp3DBoxes[leavingPlayer]:Destroy()
        esp3DBoxes[leavingPlayer] = nil
    end
end)

-- Player character removed (died) handler for ESP 3D
Players.LocalPlayer.CharacterRemoving:Connect(function(char)
    -- If the local player's character is removed (e.g., died), ensure ESP boxes are cleared
    -- This handles cases where you might want to re-enable ESP on respawn
    -- clearAllESP3DBoxes() -- No, we want it to persist for other players
end)

-- CharacterAdded for player respawn
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    -- On respawn, re-apply hitboxes if enabled for other players
    if hitbox then updateHitboxes() end
    -- On respawn, re-enable ESP for other players if enabled
    if esp then updateHighlights() end
    if esp3D then updateESP3DBoxes() end
end)


-- Key authentication logic
local function checkKey()
    local enteredKey = keyInputBox.Text:lower()
    if enteredKey == "dyumra-k3b7-wp9d-a2n8" or enteredKey == "dev" then
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

-- Main game loop (RenderStepped)
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

	-- Update both ESP types if enabled
	if esp then
		updateHighlights()
	end
    if esp3D then
        updateESP3DBoxes()
    end
end)

keyInputBox:CaptureFocus() 
showNotify("Please authenticate your access key to proceed.") [cite: 34]

-- Continuous update loop (for less frequent updates like highlight check)
while true do
	wait(1)
	if mainFrame.Visible and esp then updateHighlights() end
    if mainFrame.Visible and esp3D then updateESP3DBoxes() end -- Update ESP 3D also
end
