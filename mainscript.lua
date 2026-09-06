-- v1.0.38-ultimate-fix --
-- =====================================================================
-- ULTIMATE ANDROID D3D MENU: REALTIME DYNAMIC TARGET & NO-RELOAD --
-- =====================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Ultimate_Android"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

local VisualsConfig = {
    ESP_Skeleton = false,
    ESP_Line = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Gender = false,
    SkeletonColor = Color3.fromRGB(0, 240, 255)
}

local PlayerConfig = {
    MultiJump = false,
    InstantFire = false,
    OneHitDamage = false,
    NoReload = false,
}

local WorldConfig = {
    NightMode = false,
}

local SilentAimConfig = {
    Enabled = false,
    FOVSize = 140,
    WallCheck = false,
}

local ESPCache = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.NumSides = 64

local TargetLine = Drawing.new("Line")
TargetLine.Visible = false
TargetLine.Thickness = 1.5
TargetLine.Color = Color3.fromRGB(0, 255, 128) -- Hijau terang untuk menandai target aktif yang sedang dikunci

local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 52, 0, 52)
FloatButton.Position = UDim2.new(0, 20, 0, 100)
FloatButton.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
FloatButton.Text = "UI"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 16
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Active = true
FloatButton.Draggable = true
FloatButton.Parent = ScreenGui

Instance.new("UICorner", FloatButton).CornerRadius = UDim.new(1, 0)
local FloatStroke = Instance.new("UIStroke", FloatButton)
FloatStroke.Thickness = 2
local FloatGradient = Instance.new("UIGradient", FloatStroke)
FloatGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
})

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 330)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
local MainGradient = Instance.new("UIGradient", MainStroke)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 0, 255))
})
MainGradient.Rotation = 45

local menuVisible = true
FloatButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 36)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "× D3D MENU: DYNAMIC TARGET & NO-RELOAD ×"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 11.5
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -24, 0, 32)
TabContainer.Position = UDim2.new(0, 12, 0, 36)
TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabContainer.Parent = MainFrame

Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 10)

local tabs = {"Visual", "Player", "world", "skill"}
local TabContentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(110, 110, 140)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -24, 1, -84)
    content.Position = UDim2.new(0, 12, 0, 76)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
    content.Visible = (i == 1)
    content.Parent = MainFrame

    local uiList = Instance.new("UIListLayout", content)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 8)

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 15)
    end)

    TabContentFrames[tabName] = content

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            TabContentFrames[t].Visible = false
        end
        content.Visible = true
        for _, b in ipairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                b.TextColor3 = Color3.fromRGB(110, 110, 140)
            end
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

local function RemovePlayerESP(player)
    if ESPCache[player] then
        for _, obj in pairs(ESPCache[player]) do
            if type(obj) == "table" then
                for _, bone in pairs(obj) do pcall(function() bone:Remove() end) end
            else
                pcall(function() obj:Remove() end)
            end
        end
        ESPCache[player] = nil
    end
end

local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    RemovePlayerESP(player)

    local espData = {
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Gender = Drawing.new("Text"),
        Skeleton = {
            Head_Neck = Drawing.new("Line"),
            Neck_UpperTorso = Drawing.new("Line"),
            UpperTorso_LowerTorso = Drawing.new("Line"),
            LeftUpperArm_LeftLowerArm = Drawing.new("Line"),
            LeftLowerArm_LeftHand = Drawing.new("Line"),
            RightUpperArm_RightLowerArm = Drawing.new("Line"),
            RightLowerArm_RightHand = Drawing.new("Line"),
            UpperTorso_LeftUpperArm = Drawing.new("Line"),
            UpperTorso_RightUpperArm = Drawing.new("Line"),
            LowerTorso_LeftUpperLeg = Drawing.new("Line"),
            LeftUpperLeg_LeftLowerLeg = Drawing.new("Line"),
            LeftLowerLeg_LeftFoot = Drawing.new("Line"),
            LowerTorso_RightUpperLeg = Drawing.new("Line"),
            RightUpperLeg_RightLowerLeg = Drawing.new("Line"),
            RightLowerLeg_RightFoot = Drawing.new("Line")
        }
    }

    espData.Line.Thickness = 1.5
    espData.Line.Color = Color3.fromRGB(0, 240, 255)
    espData.Line.Transparency = 0.7

    for _, bone in pairs(espData.Skeleton) do
        bone.Thickness = 1.5
        bone.Color = VisualsConfig.SkeletonColor
        bone.Transparency = 0.8
    end

    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender}) do
        textObj.Size = 13
        textObj.Center = true
        textObj.Outline = true
        textObj.OutlineColor = Color3.fromRGB(0, 0, 0)
        textObj.Color = Color3.fromRGB(255, 255, 255)
        textObj.Font = Drawing.Fonts.UI
    end

    ESPCache[player] = espData
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end
    CreatePlayerESP(player)
end

for _, p in ipairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(RemovePlayerESP)

local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 42, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
        circle:TweenPosition(active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        if callback then callback(active) end
    end)

    frame.Parent = parent
end

local function CreateColorPicker(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local pickerCircle = Instance.new("TextButton", frame)
    pickerCircle.Size = UDim2.new(0, 32, 0, 32)
    pickerCircle.Position = UDim2.new(1, -44, 0.5, -16)
    pickerCircle.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
    pickerCircle.Text = ""
    Instance.new("UICorner", pickerCircle).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", pickerCircle)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)

    local colors = {Color3.fromRGB(0, 240, 255), Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 230, 130), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255)}
    local colorIndex = 1

    pickerCircle.MouseButton1Click:Connect(function()
        colorIndex = (colorIndex % #colors) + 1
        pickerCircle.BackgroundColor3 = colors[colorIndex]
        if callback then callback(colors[colorIndex]) end
    end)

    frame.Parent = parent
end

CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (All Targets)", function(v) VisualsConfig.ESP_Skeleton = v end)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color Custom", function(c) 
    VisualsConfig.SkeletonColor = c 
    for _, esp in pairs(ESPCache) do
        for _, bone in pairs(esp.Skeleton) do
            bone.Color = c
        end
    end
end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", function(v) VisualsConfig.ESP_Line = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", function(v) VisualsConfig.ESP_Name = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", function(v) VisualsConfig.ESP_Distance = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", function(v) VisualsConfig.ESP_Gender = v end)

CreateToggle(TabContentFrames["Player"], "Multi-Jump", function(v) PlayerConfig.MultiJump = v end)
CreateToggle(TabContentFrames["Player"], "Instant Fire Speed (Max)", function(v) PlayerConfig.InstantFire = v end)
CreateToggle(TabContentFrames["Player"], "1-Hit Instant Kill Damage", function(v) PlayerConfig.OneHitDamage = v end)
CreateToggle(TabContentFrames["Player"], "Real No-Reload", function(v) PlayerConfig.NoReload = v end)

CreateToggle(TabContentFrames["world"], "Night Mode", function(v)
    WorldConfig.NightMode = v
    if not v then
        Lighting.ClockTime = 14.5
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(120, 120, 120)
    end
end)

CreateToggle(TabContentFrames["skill"], "Dynamic Aimbot (Realtime)", function(v)
    SilentAimConfig.Enabled = v
    FOVCircle.Visible = v
    TargetLine.Visible = v
end)
CreateToggle(TabContentFrames["skill"], "Wall Check (Abaikan Tembok)", function(v)
    SilentAimConfig.WallCheck = v
end)

UserInputService.JumpRequest:Connect(function()
    if not PlayerConfig.MultiJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 35, hrp.Velocity.Z)
    end
end)

-- ABSOLUTE WEAPON HACK (INSTANT FIRE, 1-HIT DAMAGE, NO RELOAD)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, descendant in ipairs(tool:GetDescendants()) do
                if descendant:IsA("NumberValue") or descendant:IsA("IntValue") then
                    local name = string.lower(descendant.Name)
                    if PlayerConfig.InstantFire and (string.find(name, "cooldown") or string.find(name, "firerate") or string.find(name, "delay") or string.find(name, "fire") or string.find(name, "speed") or string.find(name, "rate")) then
                        descendant.Value = 0
                    end
                    if PlayerConfig.OneHitDamage and (string.find(name, "damage") or string.find(name, "dmg") or string.find(name, "power") or string.find(name, "hit")) then
                        descendant.Value = 999999
                    end
                    if PlayerConfig.NoReload and (string.find(name, "ammo") or string.find(name, "clip") or string.find(name, "mag") or string.find(name, "reload") or string.find(name, "capacity")) then
                        if string.find(name, "reload") then
                            descendant.Value = 0
                        else
                            descendant.Value = 999
                        end
                    end
                end
            end
        end
    end
end)

-- WALL CHECK FUNCTION DENGAN RAYCAST AMAN
local function IsVisible(targetPart)
    if not SilentAimConfig.WallCheck then return true end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.IgnoreWater = true

    local result = Workspace:Raycast(origin, direction, raycastParams)
    if not result then
        return true
    else
        local hitInstance = result.Instance
        if hitInstance:IsDescendantOf(targetPart.Parent) then
            return true
        end
    end
    return false
end

-- REALTIME DYNAMIC TARGET SELECTION (BERUBAH OTOMATIS MENGIKUTI ARAH CROSSHAIR/GERAKAN)
local function GetDynamicTarget()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget, bestDist = nil, math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            local head = pChar and pChar:FindFirstChild("Head")
            local hum = pChar and pChar:FindFirstChildOfClass("Humanoid")

            if head and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screenPos2D - screenCenter).Magnitude
                    
                    -- WAJIB DALAM FOV, LOLOS WALL CHECK (JIKA AKTIF), DAN PALING DEKAT DENGAN PUSAT LAYAR SECARA REALTIME
                    if dist <= SilentAimConfig.FOVSize and dist < bestDist then
                        if IsVisible(head) then
                            bestDist = dist
                            bestTarget = head
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- REALTIME FRAME-BY-FRAME CAMERA LOCK SAAT AIMBOT AKTIF
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if SilentAimConfig.Enabled then
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = SilentAimConfig.FOVSize
        FOVCircle.Visible = true

        local targetHead = GetDynamicTarget()
        if targetHead then
            -- Realtime tracking: Kamera mengunci target terdekat di dalam FOV secara mulus mengikuti pergerakan
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)

            local screenPos, onScreen = Camera:WorldToViewportPoint(targetHead.Position)
            if onScreen then
                TargetLine.From = screenCenter
                TargetLine.To = Vector2.new(screenPos.X, screenPos.Y)
                TargetLine.Visible = true
            else
                TargetLine.Visible = false
            end
        else
            TargetLine.Visible = false
        end
    else
        FOVCircle.Visible = false
        TargetLine.Visible = false
    end

    if WorldConfig.NightMode then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.2
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end

    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local active = (player ~= LocalPlayer) and char and hrp and hum and hum.Health > 0

        if active then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                
                if VisualsConfig.ESP_Skeleton then
                    local parts = {
                        Head = char:FindFirstChild("Head"),
                        UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
                        LowerTorso = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso"),
                        LeftUpperArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
                        LeftLowerArm = char:FindFirstChild("LeftLowerArm") or char:FindFirstChild("Left Arm"),
                        LeftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm"),
                        RightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
                        RightLowerArm = char:FindFirstChild("RightLowerArm") or char:FindFirstChild("Right Arm"),
                        RightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"),
                        LeftUpperLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
                        LeftLowerLeg = char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg"),
                        LeftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg"),
                        RightUpperLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"),
                        RightLowerLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg"),
                        RightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
                    }

                    local function getPos(part)
                        if not part then return nil end
                        local p, visible = Camera:WorldToViewportPoint(part.Position)
                        if visible then return Vector2.new(p.X, p.Y) end
                        return nil
                    end

                    local headPos = getPos(parts.Head)
                    local upperTorsoPos = getPos(parts.UpperTorso)
                    local lowerTorsoPos = getPos(parts.LowerTorso)
                    local lUpperArm = getPos(parts.LeftUpperArm)
                    local lLowerArm = getPos(parts.LeftLowerArm)
                    local lHand = getPos(parts.LeftHand)
                    local rUpperArm = getPos(parts.RightUpperArm)
                    local rLowerArm = getPos(parts.RightLowerArm)
                    local rHand = getPos(parts.RightHand)
                    local lUpperLeg = getPos(parts.LeftUpperLeg)
                    local lLowerLeg = getPos(parts.LeftLowerLeg)
                    local lFoot = getPos(parts.LeftFoot)
                    local rUpperLeg = getPos(parts.RightUpperLeg)
                    local rLowerLeg = getPos(parts.RightLowerLeg)
                    local rFoot = getPos(parts.RightFoot)

                    local function drawBone(boneObj, p1, p2)
                        if p1 and p2 then
                            boneObj.From = p1
                            boneObj.To = p2
                            boneObj.Visible = true
                        else
                            boneObj.Visible = false
                        end
                    end

                    drawBone(esp.Skeleton.Head_Neck, headPos, upperTorsoPos)
                    drawBone(esp.Skeleton.Neck_UpperTorso, upperTorsoPos, lowerTorsoPos)
                    drawBone(esp.Skeleton.UpperTorso_LeftUpperArm, upperTorsoPos, lUpperArm)
                    drawBone(esp.Skeleton.LeftUpperArm_LeftLowerArm, lUpperArm, lLowerArm)
                    drawBone(esp.Skeleton.LeftLowerArm_LeftHand, lLowerArm, lHand)
                    drawBone(esp.Skeleton.UpperTorso_RightUpperArm, upperTorsoPos, rUpperArm)
                    drawBone(esp.Skeleton.RightUpperArm_RightLowerArm, rUpperArm, rLowerArm)
                    drawBone(esp.Skeleton.RightLowerArm_RightHand, rLowerArm, rHand)
                    drawBone(esp.Skeleton.LowerTorso_LeftUpperLeg, lowerTorsoPos, lUpperLeg)
                    drawBone(esp.Skeleton.LeftUpperLeg_LeftLowerLeg, lUpperLeg, lLowerLeg)
                    drawBone(esp.Skeleton.LeftLowerLeg_LeftFoot, lLowerLeg, lFoot)
                    drawBone(esp.Skeleton.LowerTorso_RightUpperLeg, lowerTorsoPos, rUpperLeg)
                    drawBone(esp.Skeleton.RightUpperLeg_RightLowerLeg, rUpperLeg, rLowerLeg)
                    drawBone(esp.Skeleton.RightLowerLeg_RightFoot, rLowerLeg, rFoot)
                else
                    for _, bone in pairs(esp.Skeleton) do bone.Visible = false end
                end

                if VisualsConfig.ESP_Line then
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    esp.Line.To = Vector2.new(vector.X, vector.Y)
                    esp.Line.Visible = true
                else
                    esp.Line.Visible = false
                end

                if VisualsConfig.ESP_Name then
                    esp.Name.Text = player.Name
                    esp.Name.Position = Vector2.new(vector.X, vector.Y - 35)
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end

                if VisualsConfig.ESP_Distance then
                    esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                    esp.Distance.Position = Vector2.new(vector.X, vector.Y + 20)
                    esp.Distance.Visible = true
                else
                    esp.Distance.Visible = false
                end

                if VisualsConfig.ESP_Gender then
                    esp.Gender.Text = (player.UserId % 2 == 0) and "[Cewe]" or "[Cowo]"
                    esp.Gender.Position = Vector2.new(vector.X, vector.Y + 35)
                    esp.Gender.Visible = true
                else
                    esp.Gender.Visible = false
                end
            else
                for _, obj in pairs(esp) do
                    if type(obj) == "table" then
                        for _, bone in pairs(obj) do bone.Visible = false end
                    else
                        obj.Visible = false
                    end
                end
            end
        else
            for _, obj in pairs(esp) do
                if type(obj) == "table" then
                    for _, bone in pairs(obj) do bone.Visible = false end
                else
                    obj.Visible = false
                end
            end
        end
    end
end)
