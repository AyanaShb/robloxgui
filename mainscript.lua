-- v1.0.43-full-features-updated --
-- =====================================================================
-- ULTIMATE ANDROID D3D MENU: VISUAL, PLAYER, WORLD & SKILL (AIMBOT) TABS --
-- =====================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Ultimate_Android_V2"
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

-- CONFIGURATIONS
local VisualsConfig = {
    ESP_Skeleton = false,
    ESP_Line = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Gender = false,
    ESP_Health = false,
    SkeletonColor = Color3.fromRGB(0, 240, 255),
    LineColor = Color3.fromRGB(0, 240, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    GenderColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 128)
}

local PlayerConfig = {
    SpeedRun = false,
    SpeedValue = 24,
    FlyHack = false,
    MultiJump = false,
    AntiAim = false
}

local WorldConfig = {
    NightMode = false,
    Daylight = false,
    DaylightBrightness = 3,
    DaylightClock = 14
}

local SkillConfig = {
    Aimbot = false,
    AimTargetPart = "Head", -- "Head" or "Chest"
    AimDistance = 500,
    AimFovSize = 140
}

local ESPCache = {}

-- DRAWINGS FOR AIMBOT & FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.NumSides = 64

local AimbotLine = Drawing.new("Line")
AimbotLine.Visible = false
AimbotLine.Thickness = 1.5
AimbotLine.Color = Color3.fromRGB(0, 255, 128)

-- FLOATING BUTTON UI
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

-- MAIN FRAME UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 360)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -180)
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
TitleLabel.Text = "× D3D MENU: FULL FEATURES v2 ×"
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

local tabs = {"Visual", "Player", "World", "Skill"}
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

-- HELPER UI FUNCTIONS
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

    local colors = {Color3.fromRGB(0, 240, 255), Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 230, 130), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 80, 80)}
    local colorIndex = 1

    pickerCircle.MouseButton1Click:Connect(function()
        colorIndex = (colorIndex % #colors) + 1
        pickerCircle.BackgroundColor3 = colors[colorIndex]
        if callback then callback(colors[colorIndex]) end
    end)

    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBar = Instance.new("Frame", frame)
    sliderBar.Size = UDim2.new(1, -24, 0, 6)
    sliderBar.Position = UDim2.new(0, 12, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", sliderBar)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", sliderBar)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local dragging = false
    btn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + ((max - min) * pos))
            label.Text = text .. ": " .. tostring(val)
            if callback then callback(val) end
        end
    end)

    frame.Parent = parent
end

local function CreateChoice(parent, text, choices, defaultIndex, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local choiceBtn = Instance.new("TextButton", frame)
    choiceBtn.Size = UDim2.new(0, 120, 0, 28)
    choiceBtn.Position = UDim2.new(1, -132, 0.5, -14)
    choiceBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    choiceBtn.Text = choices[defaultIndex]
    choiceBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
    choiceBtn.TextSize = 10.5
    choiceBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", choiceBtn).CornerRadius = UDim.new(0, 6)

    local currentIndex = defaultIndex
    choiceBtn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #choices) + 1
        choiceBtn.Text = choices[currentIndex]
        if callback then callback(choices[currentIndex]) end
    end)

    frame.Parent = parent
end

-- ESP SYSTEM WITH TEAMMATE FILTER (DEADMATCH READY)
local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true
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
        HealthBarBg = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
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
    espData.Line.Color = VisualsConfig.LineColor
    espData.Line.Transparency = 0.7

    espData.HealthBarBg.Thickness = 3
    espData.HealthBarBg.Color = Color3.fromRGB(40, 40, 40)
    espData.HealthBarBg.Transparency = 0.8

    espData.HealthBar.Thickness = 1.5
    espData.HealthBar.Color = VisualsConfig.HealthColor
    espData.HealthBar.Transparency = 1

    for _, bone in pairs(espData.Skeleton) do
        bone.Thickness = 1.5
        bone.Color = VisualsConfig.SkeletonColor
        bone.Transparency = 0.8
    end

    espData.Name.Size = 13
    espData.Name.Center = true
    espData.Name.Outline = true
    espData.Name.OutlineColor = Color3.fromRGB(0, 0, 0)
    espData.Name.Color = VisualsConfig.NameColor
    espData.Name.Font = Drawing.Fonts.UI

    espData.Distance.Size = 13
    espData.Distance.Center = true
    espData.Distance.Outline = true
    espData.Distance.OutlineColor = Color3.fromRGB(0, 0, 0)
    espData.Distance.Color = VisualsConfig.DistanceColor
    espData.Distance.Font = Drawing.Fonts.UI

    espData.Gender.Size = 13
    espData.Gender.Center = true
    espData.Gender.Outline = true
    espData.Gender.OutlineColor = Color3.fromRGB(0, 0, 0)
    espData.Gender.Color = VisualsConfig.GenderColor
    espData.Gender.Font = Drawing.Fonts.UI

    ESPCache[player] = espData
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end
    CreatePlayerESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        CreatePlayerESP(player)
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(RemovePlayerESP)

-- POPULATE TABS

-- TAB 1: VISUAL
CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Enemies Only)", function(v) VisualsConfig.ESP_Skeleton = v end)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", function(c) 
    VisualsConfig.SkeletonColor = c 
    for _, esp in pairs(ESPCache) do for _, bone in pairs(esp.Skeleton) do bone.Color = c end end
end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", function(v) VisualsConfig.ESP_Line = v end)
CreateColorPicker(TabContentFrames["Visual"], "Line Color", function(c) VisualsConfig.LineColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", function(v) VisualsConfig.ESP_Name = v end)
CreateColorPicker(TabContentFrames["Visual"], "Name Color", function(c) VisualsConfig.NameColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", function(v) VisualsConfig.ESP_Distance = v end)
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", function(c) VisualsConfig.DistanceColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", function(v) VisualsConfig.ESP_Gender = v end)
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", function(c) VisualsConfig.GenderColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Health (Vertical Bar)", function(v) VisualsConfig.ESP_Health = v end)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", function(c) VisualsConfig.HealthColor = c end)

-- TAB 2: PLAYER
CreateToggle(TabContentFrames["Player"], "Speed Run (Custom WalkAnimation)", function(v) PlayerConfig.SpeedRun = v end)
CreateSlider(TabContentFrames["Player"], "Speed Run Max", 16, 100, 24, function(val) PlayerConfig.SpeedValue = val end)

CreateToggle(TabContentFrames["Player"], "Fly Hack (Hold Jump & Slow Fall)", function(v) PlayerConfig.FlyHack = v end)
CreateToggle(TabContentFrames["Player"], "Multi Jump (Infinite Tap Heights)", function(v) PlayerConfig.MultiJump = v end)
CreateToggle(TabContentFrames["Player"], "Anti Aim (Auto-Evasion / No-Hitbox)", function(v) PlayerConfig.AntiAim = v end)

-- TAB 3: WORLD
CreateToggle(TabContentFrames["World"], "Night Mode", function(v)
    WorldConfig.NightMode = v
    if v then WorldConfig.Daylight = false end
end)
CreateToggle(TabContentFrames["World"], "Daylight (Indoor/Outdoor Custom)", function(v)
    WorldConfig.Daylight = v
    if v then WorldConfig.NightMode = false end
end)
CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end)
CreateSlider(TabContentFrames["World"], "Daylight Time (Clock)", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end)

-- TAB 4: SKILL
CreateToggle(TabContentFrames["Skill"], "Aimbot (Instant Snap 1-Bullet/Shot)", function(v) SkillConfig.Aimbot = v end)
CreateChoice(TabContentFrames["Skill"], "Aim Target Part", {"Head", "Chest"}, 1, function(choice) SkillConfig.AimTargetPart = choice end)
CreateSlider(TabContentFrames["Skill"], "Aim Distance Scan", 100, 2000, 500, function(val) SkillConfig.AimDistance = val end)
CreateSlider(TabContentFrames["Skill"], "Aim FOV Size", 50, 400, 140, function(val) SkillConfig.AimFovSize = val end)


-- PLAYER MOD FEATURES LOGIC (SPEED RUN, FLY, MULTI JUMP, ANTI AIM)
local lastJumpTick = 0
UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and PlayerConfig.MultiJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if char and hrp and hum then
        -- Speed Run + Custom Walk Animation Check
        if PlayerConfig.SpeedRun then
            hum.WalkSpeed = PlayerConfig.SpeedValue
        end

        -- Fly Hack (Hold Jump & Slow Fall Min Gravity)
        if PlayerConfig.FlyHack then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService.TouchEnabled then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 45, hrp.Velocity.Z)
            else
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -2, hrp.Velocity.Z)
            end
        end

        -- Anti Aim: Auto Evasion/Jitter hitbox position slightly when enemies aim
        if PlayerConfig.AntiAim then
            local movingOffset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
            hrp.CFrame = hrp.CFrame + movingOffset
        end
    end

    -- World Illumination Engine
    if WorldConfig.NightMode then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.1
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    elseif WorldConfig.Daylight then
        Lighting.ClockTime = WorldConfig.DaylightClock
        Lighting.Brightness = WorldConfig.DaylightBrightness
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    end
end)


-- SKILL: ADVANCED AIMBOT ENGINE (1-BULLET SNAP, NO OVERSHOOT, STRICT FOV LINE, ENEMY FILTER)
local function GetClosestEnemyInFOV()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTargetPos, bestDist = nil, math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) then
            local pChar = player.Character
            local targetPart = pChar and pChar:FindFirstChild(SkillConfig.AimTargetPart == "Head" and "Head" or (pChar:FindFirstChild("UpperTorso") and "UpperTorso" or "Torso"))
            local hum = pChar and pChar:FindFirstChildOfClass("Humanoid")

            if targetPart and hum and hum.Health > 0 then
                local worldPos = targetPart.Position
                local distance = (hrp.Position - worldPos).Magnitude

                if distance <= SkillConfig.AimDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
                    if onScreen then
                        local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local distToCenter = (screenPos2D - screenCenter).Magnitude

                        if distToCenter <= SkillConfig.AimFovSize and distToCenter < bestDist then
                            bestDist = distToCenter
                            bestTargetPos = worldPos
                        end
                    end
                end
            end
        end
    end
    return bestTargetPos
end

-- 1-Bullet Instant Trigger & Aim Snapping
UserInputService.InputBegan:Connect(function(input)
    if SkillConfig.Aimbot and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local targetPos = GetClosestEnemyInFOV()
        if targetPos then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
end)


-- MAIN RENDER LOOP: ESP RENDERER & AIMBOT GRAPHICS
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Render Aimbot FOV & Precise Edge-Constrained Aim Line
    if SkillConfig.Aimbot then
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = SkillConfig.AimFovSize
        FOVCircle.Visible = true

        local targetPos = GetClosestEnemyInFOV()
        if targetPos then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if onScreen then
                local target2D = Vector2.new(screenPos.X, screenPos.Y)
                local dir = (target2D - screenCenter)
                local dist = dir.Magnitude

                -- Keep line strictly bounded inside FOV circle perimeter
                if dist > SkillConfig.AimFovSize then
                    dir = dir.Unit * SkillConfig.AimFovSize
                    target2D = screenCenter + dir
                end

                AimbotLine.From = screenCenter
                AimbotLine.To = target2D
                AimbotLine.Color = VisualsConfig.HealthColor
                AimbotLine.Visible = true
            else
                AimbotLine.Visible = false
            end
        else
            AimbotLine.Visible = false
        end
    else
        FOVCircle.Visible = false
        AimbotLine.Visible = false
    end

    -- Render Enemies ESP
    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local active = IsEnemy(player) and char and hrp and hum and hum.Health > 0

        if active then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

                -- Skeleton ESP
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

                -- ESP Line
                if VisualsConfig.ESP_Line then
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    esp.Line.To = Vector2.new(vector.X, vector.Y)
                    esp.Line.Color = VisualsConfig.LineColor
                    esp.Line.Visible = true
                else
                    esp.Line.Visible = false
                end

                -- ESP Name
                if VisualsConfig.ESP_Name then
                    esp.Name.Text = player.Name
                    esp.Name.Position = Vector2.new(vector.X, vector.Y - 38)
                    esp.Name.Color = VisualsConfig.NameColor
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end

                -- ESP Distance
                if VisualsConfig.ESP_Distance then
                    esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                    esp.Distance.Position = Vector2.new(vector.X, vector.Y + 22)
                    esp.Distance.Color = VisualsConfig.DistanceColor
                    esp.Distance.Visible = true
                else
                    esp.Distance.Visible = false
                end

                -- ESP Gender
                if VisualsConfig.ESP_Gender then
                    esp.Gender.Text = (player.UserId % 2 == 0) and "[Cewe]" or "[Cowo]"
                    esp.Gender.Position = Vector2.new(vector.X, vector.Y + 36)
                    esp.Gender.Color = VisualsConfig.GenderColor
                    esp.Gender.Visible = true
                else
                    esp.Gender.Visible = false
                end

                -- ESP Health (Vertical Bar nicely positioned right beside user hitbox)
                if VisualsConfig.ESP_Health then
                    local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barHeight = 40
                    local barX = vector.X + 24
                    local barY = vector.Y - 20

                    esp.HealthBarBg.From = Vector2.new(barX, barY)
                    esp.HealthBarBg.To = Vector2.new(barX, barY + barHeight)
                    esp.HealthBarBg.Visible = true

                    local currentHeight = barHeight * healthPct
                    esp.HealthBar.From = Vector2.new(barX, barY + (barHeight - currentHeight))
                    esp.HealthBar.To = Vector2.new(barX, barY + barHeight)
                    esp.HealthBar.Color = VisualsConfig.HealthColor
                    esp.HealthBar.Visible = true
                else
                    esp.HealthBarBg.Visible = false
                    esp.HealthBar.Visible = false
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
