-- v3.0 --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Ultimate_Android_V3"
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

local OriginalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

local VisualsConfig = {
    ESP_Skeleton = false,
    ESP_Line = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Gender = false,
    ESP_Health = false,
    Chams = false,
    SkeletonColor = Color3.fromRGB(0, 240, 255),
    LineColor = Color3.fromRGB(0, 240, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    GenderColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 128),
    ChamsColor = Color3.fromRGB(255, 0, 128)
}

local PlayerConfig = {
    SpeedRun = false,
    SpeedValue = 24,
    FlyHack = false,
    MultiJump = false,
    Wallhack = false,
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
    AimTargetPart = "Head",
    AimDistance = 1000,
    AimFovSize = 140
}

local ESPCache = {}
local ChamsCache = {}

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
MainFrame.Size = UDim2.new(0, 440, 0, 360)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
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
TitleLabel.Text = "× D3D MENU: ULTRA REBUILD v3.0 ×"
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

local function CreateToggle(parent, text, defaultVal, callback)
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
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultVal
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
        circle:TweenPosition(active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        if callback then callback(active) end
    end)

    frame.Parent = parent
end

local function CreateColorPicker(parent, text, defaultColor, callback)
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
    pickerCircle.BackgroundColor3 = defaultColor
    pickerCircle.Text = ""
    Instance.new("UICorner", pickerCircle).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", pickerCircle)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)

    local colors = {defaultColor, Color3.fromRGB(0, 240, 255), Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 230, 130), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255)}
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

local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    if player.Team and LocalPlayer.Team then
        if player.Team == LocalPlayer.Team then return false end
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
    if ChamsCache[player] then
        pcall(function() ChamsCache[player]:Destroy() end)
        ChamsCache[player] = nil
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
            Spine = Drawing.new("Line"),
            LeftArm = Drawing.new("Line"),
            RightArm = Drawing.new("Line"),
            LeftLeg = Drawing.new("Line"),
            RightLeg = Drawing.new("Line")
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

    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender}) do
        textObj.Size = 13
        textObj.Center = true
        textObj.Outline = true
        textObj.OutlineColor = Color3.fromRGB(0, 0, 0)
        textObj.Font = Drawing.Fonts.UI
    end

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

CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Ultra Stable)", false, function(v) VisualsConfig.ESP_Skeleton = v end)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", Color3.fromRGB(0, 240, 255), function(c) 
    VisualsConfig.SkeletonColor = c 
    for _, esp in pairs(ESPCache) do for _, bone in pairs(esp.Skeleton) do bone.Color = c end end
end)
CreateToggle(TabContentFrames["Visual"], "Chams / Wall Glow (Tembus Dinding)", false, function(v) VisualsConfig.Chams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Chams Glow Color", Color3.fromRGB(255, 0, 128), function(c) VisualsConfig.ChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", false, function(v) VisualsConfig.ESP_Line = v end)
CreateColorPicker(TabContentFrames["Visual"], "Line Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.LineColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) VisualsConfig.ESP_Name = v end)
CreateColorPicker(TabContentFrames["Visual"], "Name Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.NameColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) VisualsConfig.ESP_Distance = v end)
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.DistanceColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", false, function(v) VisualsConfig.ESP_Gender = v end)
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.GenderColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Health (Vertical Bar)", false, function(v) VisualsConfig.ESP_Health = v end)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end)

CreateToggle(TabContentFrames["Player"], "Speed Run", false, function(v) PlayerConfig.SpeedRun = v end)
CreateSlider(TabContentFrames["Player"], "Speed Run Max", 16, 100, 24, function(val) PlayerConfig.SpeedValue = val end)
CreateToggle(TabContentFrames["Player"], "Fly Hack (Mobile Optimized)", false, function(v) PlayerConfig.FlyHack = v end)
CreateToggle(TabContentFrames["Player"], "Multi Jump", false, function(v) PlayerConfig.MultiJump = v end)
CreateToggle(TabContentFrames["Player"], "Wallhack / Noclip (Tembus Objek)", false, function(v) PlayerConfig.Wallhack = v end)
CreateToggle(TabContentFrames["Player"], "Anti Aim (Auto-Evasion)", false, function(v) PlayerConfig.AntiAim = v end)

CreateToggle(TabContentFrames["World"], "Night Mode", false, function(v)
    WorldConfig.NightMode = v
    if v then
        WorldConfig.Daylight = false
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
end)

CreateToggle(TabContentFrames["World"], "Daylight (Indoor/Outdoor)", false, function(v)
    WorldConfig.Daylight = v
    if v then
        WorldConfig.NightMode = false
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
end)

CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end)
CreateSlider(TabContentFrames["World"], "Daylight Time (Clock)", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end)

CreateToggle(TabContentFrames["Skill"], "Aimbot (Strict FOV Lock)", false, function(v) SkillConfig.Aimbot = v end)
CreateChoice(TabContentFrames["Skill"], "Aim Target Part", {"Head", "Chest"}, 1, function(choice) SkillConfig.AimTargetPart = choice end)
CreateSlider(TabContentFrames["Skill"], "Aim Distance Scan", 100, 2000, 1000, function(val) SkillConfig.AimDistance = val end)
CreateSlider(TabContentFrames["Skill"], "Aim FOV Size", 50, 400, 140, function(val) SkillConfig.AimFovSize = val end)

UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and PlayerConfig.MultiJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if char and hrp and hum then
        if PlayerConfig.SpeedRun then
            hum.WalkSpeed = PlayerConfig.SpeedValue
        else
            hum.WalkSpeed = 16
        end

        if PlayerConfig.Wallhack then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if PlayerConfig.FlyHack then
            local bv = hrp:FindFirstChild("D3DFlyVelocity")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "D3DFlyVelocity"
                bv.MaxForce = Vector3.new(400000, 400000, 400000)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
            end
            
            local camCF = Camera.CFrame
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService.TouchEnabled then
                moveDir = moveDir + (camCF.LookVector * 50)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 45, 0)
            end
            bv.Velocity = moveDir
        else
            local bv = hrp:FindFirstChild("D3DFlyVelocity")
            if bv then bv:Destroy() end
        end

        if PlayerConfig.AntiAim then
            hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
        end
    end

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

local function GetClosestEnemyInFOV()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTargetPos, bestDist = nil, math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) then
            local pChar = player.Character
            local targetPart = pChar and pChar:FindFirstChild("Head")
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

RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if SkillConfig.Aimbot then
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = SkillConfig.AimFovSize
        FOVCircle.Visible = true

        local targetPos = GetClosestEnemyInFOV()
        if targetPos then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if onScreen then
                local target2D = Vector2.new(screenPos.X, screenPos.Y)
                local dist = (target2D - screenCenter).Magnitude

                if dist <= SkillConfig.AimFovSize then
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
            AimbotLine.Visible = false
        end
    else
        FOVCircle.Visible = false
        AimbotLine.Visible = false
    end

    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local active = IsEnemy(player) and char and hrp and hum and hum.Health > 0

        if active and VisualsConfig.Chams then
            if not ChamsCache[player] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "D3D_Chams"
                highlight.Adornee = char
                highlight.FillColor = VisualsConfig.ChamsColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0
                highlight.Parent = char
                ChamsCache[player] = highlight
            else
                ChamsCache[player].FillColor = VisualsConfig.ChamsColor
                ChamsCache[player].Enabled = true
            end
        else
            if ChamsCache[player] then
                ChamsCache[player].Enabled = false
            end
        end

        if active then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

                if VisualsConfig.ESP_Skeleton then
                    local head = char:FindFirstChild("Head")
                    local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
                    local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
                    local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
                    local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot")
                    local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot")

                    local function getPos(part)
                        if not part then return nil end
                        local p, visible = Camera:WorldToViewportPoint(part.Position)
                        if visible then return Vector2.new(p.X, p.Y) end
                        return nil
                    end

                    local hPos = getPos(head)
                    local utPos = getPos(upperTorso)
                    local ltPos = getPos(lowerTorso)
                    local laPos = getPos(lArm)
                    local raPos = getPos(rArm)
                    local llPos = getPos(lLeg)
                    local rlPos = getPos(rLeg)

                    local function drawBone(boneObj, p1, p2)
                        if p1 and p2 then
                            boneObj.From = p1
                            boneObj.To = p2
                            boneObj.Visible = true
                        else
                            boneObj.Visible = false
                        end
                    end

                    drawBone(esp.Skeleton.Spine, hPos, utPos)
                    drawBone(esp.Skeleton.LeftArm, utPos, laPos)
                    drawBone(esp.Skeleton.RightArm, utPos, raPos)
                    drawBone(esp.Skeleton.LeftLeg, ltPos, llPos)
                    drawBone(esp.Skeleton.RightLeg, ltPos, rlPos)
                else
                    for _, bone in pairs(esp.Skeleton) do bone.Visible = false end
                end

                if VisualsConfig.ESP_Line then
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    esp.Line.To = Vector2.new(vector.X, vector.Y)
                    esp.Line.Color = VisualsConfig.LineColor
                    esp.Line.Visible = true
                else
                    esp.Line.Visible = false
                end

                if VisualsConfig.ESP_Name then
                    esp.Name.Text = player.Name
                    esp.Name.Position = Vector2.new(vector.X, vector.Y - 38)
                    esp.Name.Color = VisualsConfig.NameColor
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end

                if VisualsConfig.ESP_Distance then
                    esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                    esp.Distance.Position = Vector2.new(vector.X, vector.Y + 22)
                    esp.Distance.Color = VisualsConfig.DistanceColor
                    esp.Distance.Visible = true
                else
                    esp.Distance.Visible = false
                end

                if VisualsConfig.ESP_Gender then
                    esp.Gender.Text = (player.UserId % 2 == 0) and "[Cewe]" or "[Cowo]"
                    esp.Gender.Position = Vector2.new(vector.X, vector.Y + 36)
                    esp.Gender.Color = VisualsConfig.GenderColor
                    esp.Gender.Visible = true
                else
                    esp.Gender.Visible = false
                end

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
