-- =====================================================================
-- FIXED D3D MENU: ESP & CHAMS REPAIRED (ANDROID OPTIMIZED)
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().D3DConfig = {
    MenuVisible = true,
    EspLine = false,
    EspName = false,
    EspDistance = false,
    EspGender = false,
    EspItem = false,
    EspItemRadius = 50,
    Chams = false,
    ChamsColor = Color3.fromRGB(255, 0, 128),
    SpeedRun = false,
    SpeedValue = 24,
    Fly = false,
    LongJump = false,
    WallHack = false,
    SizeHack = false,
    SizeValue = 1,
    GodMode = false,
    NightMode = false,
    DaylightMode = false,
    LongView = false,
    LongViewValue = 70,
    Aimbot = false,
    AimbotFov = 100,
    UnlimitedAmmo = false,
    FastVehicle = false,
    FastVehicleSpeed = 50
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Fixed_Android"
ScreenGui.ResetOnSpawn = false
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- FLOATING ICON BUTTON
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

-- MAIN MENU FRAME
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

FloatButton.MouseButton1Click:Connect(function()
    D3DConfig.MenuVisible = not D3DConfig.MenuVisible
    MainFrame.Visible = D3DConfig.MenuVisible
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 36)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "× D3D MENU BG AMIN ×"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 13.5
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
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(110, 110, 140) end
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
        callback(active)
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
        circle:TweenPosition(active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
    end)
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -24, 0, 5)
    sliderBg.Position = UDim2.new(0, 12, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + ((max - min) * pos))
            label.Text = text .. ": " .. tostring(val)
            callback(val)
        end
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
    pickerCircle.BackgroundColor3 = D3DConfig.ChamsColor
    pickerCircle.Text = ""
    Instance.new("UICorner", pickerCircle).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", pickerCircle)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255)
    }
    local colorIndex = 1
    
    pickerCircle.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        local chosenColor = colors[colorIndex]
        pickerCircle.BackgroundColor3 = chosenColor
        callback(chosenColor)
    end)
    frame.Parent = parent
end

-- POPULATE TABS
CreateToggle(TabContentFrames["Visual"], "ESP Line (Top Center)", false, function(v) D3DConfig.EspLine = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) D3DConfig.EspName = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) D3DConfig.EspDistance = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", false, function(v) D3DConfig.EspGender = v end)
CreateToggle(TabContentFrames["Visual"], "ESP Item Nearby", false, function(v) D3DConfig.EspItem = v end)
CreateSlider(TabContentFrames["Visual"], "ESP Item Radius", 10, 200, 50, function(v) D3DConfig.EspItemRadius = v end)
CreateToggle(TabContentFrames["Visual"], "Chams Body Color", false, function(v) D3DConfig.Chams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Chams Circle Color Picker", function(c) D3DConfig.ChamsColor = c end)

CreateToggle(TabContentFrames["Player"], "Speed Run", false, function(v) D3DConfig.SpeedRun = v end)
CreateSlider(TabContentFrames["Player"], "Speed Value", 16, 100, 24, function(v) D3DConfig.SpeedValue = v end)
CreateToggle(TabContentFrames["Player"], "Fly (Hold Jump)", false, function(v) D3DConfig.Fly = v end)
CreateToggle(TabContentFrames["Player"], "Long Jump", false, function(v) D3DConfig.LongJump = v end)
CreateToggle(TabContentFrames["Player"], "Wall Hack", false, function(v) D3DConfig.WallHack = v end)
CreateToggle(TabContentFrames["Player"], "Size Hack", false, function(v) D3DConfig.SizeHack = v end)
CreateSlider(TabContentFrames["Player"], "Size Value", 1, 5, 1, function(v) D3DConfig.SizeValue = v end)
CreateToggle(TabContentFrames["Player"], "God Mode (Anti Hazard)", false, function(v) D3DConfig.GodMode = v end)

CreateToggle(TabContentFrames["world"], "Night Mode", false, function(v)
    if v then Lighting.ClockTime = 0 else Lighting.ClockTime = 14 end
end)
CreateToggle(TabContentFrames["world"], "Daylight Mode", false, function(v)
    if v then Lighting.ClockTime = 14 else Lighting.ClockTime = 14 end
end)
CreateToggle(TabContentFrames["world"], "Long View POV", false, function(v) D3DConfig.LongView = v end)
CreateSlider(TabContentFrames["world"], "Long View Distance", 70, 300, 70, function(v) D3DConfig.LongViewValue = v end)

CreateToggle(TabContentFrames["skill"], "Aimbot + FOV + Predict", false, function(v) D3DConfig.Aimbot = v end)
CreateSlider(TabContentFrames["skill"], "Aimbot FOV Size", 30, 300, 100, function(v) D3DConfig.AimbotFov = v end)
CreateToggle(TabContentFrames["skill"], "Unlimited Ammo (999/999)", false, function(v) D3DConfig.UnlimitedAmmo = v end)
CreateToggle(TabContentFrames["skill"], "Fast Vehicle", false, function(v) D3DConfig.FastVehicle = v end)
CreateSlider(TabContentFrames["skill"], "Vehicle Speed Value", 20, 200, 50, function(v) D3DConfig.FastVehicleSpeed = v end)

local tpButton = Instance.new("TextButton", TabContentFrames["skill"])
tpButton.Size = UDim2.new(1, 0, 0, 36)
tpButton.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
tpButton.Text = "Teleport to Random Player"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextSize = 11.5
tpButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 8)

tpButton.MouseButton1Click:Connect(function()
    local players = Players:GetPlayers()
    local target = players[math.random(1, #players)]
    if target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- DRAWING OBJECTS FOR ROBUST ANDROID ESP
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 240, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8

-- Dynamic cache storage for ESP elements to prevent flickering
local EspCache = {}

local function clearEspCache()
    for _, cache in pairs(EspCache) do
        for _, obj in pairs(cache) do
            if obj and obj.Remove then pcall(function() obj:Remove() end) end
        end
    end
    EspCache = {}
end

-- MAIN ENGINE LOOP
RunService.RenderStepped:Connect(function()
    clearEspCache()

    -- FOV Circle Update
    if D3DConfig.Aimbot then
        FOVCircle.Visible = true
        FOVCircle.Radius = D3DConfig.AimbotFov
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end

    -- ESP & Chams Loop
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local head = char.Head
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hum and hum.Health > 0 then
                local headPos, onHead = Camera:WorldToViewportPoint(head.Position)
                
                if onHead then
                    local playerDrawingList = {}

                    -- ESP Line from Top Center
                    if D3DConfig.EspLine then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        line.To = Vector2.new(headPos.X, headPos.Y)
                        line.Color = Color3.fromRGB(255, 0, 0)
                        line.Thickness = 1.5
                        table.insert(playerDrawingList, line)
                    end

                    -- ESP Name
                    if D3DConfig.EspName then
                        local txt = Drawing.new("Text")
                        txt.Visible = true
                        txt.Text = p.Name
                        txt.Size = 13
                        txt.Center = true
                        txt.Outline = true
                        txt.Color = Color3.fromRGB(255, 255, 255)
                        txt.Position = Vector2.new(headPos.X, headPos.Y - 25)
                        table.insert(playerDrawingList, txt)
                    end

                    -- ESP Distance
                    if D3DConfig.EspDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        local txt = Drawing.new("Text")
                        txt.Visible = true
                        txt.Text = "[" .. dist .. "m]"
                        txt.Size = 12
                        txt.Center = true
                        txt.Outline = true
                        txt.Color = Color3.fromRGB(0, 240, 255)
                        txt.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        table.insert(playerDrawingList, txt)
                    end

                    -- ESP Gender
                    if D3DConfig.EspGender then
                        local genderText = (p.UserId % 2 == 0) and "[Cewe]" / "[Cowo]" or "[Cowo]"
                        local txt = Drawing.new("Text")
                        txt.Visible = true
                        txt.Text = genderText
                        txt.Size = 12
                        txt.Center = true
                        txt.Outline = true
                        txt.Color = (genderText == "[Cewe]") and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(100, 149, 237)
                        txt.Position = Vector2.new(headPos.X, headPos.Y - 55)
                        table.insert(playerDrawingList, txt)
                    end

                    EspCache[p] = playerDrawingList
                end

                -- Chams & Wall Hack Body Color Fix
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        if D3DConfig.Chams then
                            part.Color = D3DConfig.ChamsColor
                            part.Material = Enum.Material.ForceField
                        else
                            part.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end
            end
        end
    end

    -- Local Player Wall Hack Fix
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not D3DConfig.WallHack
            end
        end
    end

    -- Player Character Mods
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if D3DConfig.SpeedRun then hum.WalkSpeed = D3DConfig.SpeedValue end
        if D3DConfig.Fly and hrp and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
        end
        if D3DConfig.SizeHack and hrp then
            local scale = D3DConfig.SizeValue
            pcall(function()
                LocalPlayer.Character.Humanoid.BodyHeightScale.Value = scale
                LocalPlayer.Character.Humanoid.BodyWidthScale.Value = scale
                LocalPlayer.Character.Humanoid.HeadScale.Value = scale
            end)
        end
        if D3DConfig.GodMode then
            hum.Health = hum.MaxHealth
        end
    end

    -- Long View POV
    if D3DConfig.LongView then
        Camera.FieldOfView = D3DConfig.LongViewValue
    end

    -- Fast Vehicle
    if D3DConfig.FastVehicle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local seat = LocalPlayer.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            seat.Throttle = 1
            seat.MaxSpeed = D3DConfig.FastVehicleSpeed
        end
    end

    -- Unlimited Ammo
    if D3DConfig.UnlimitedAmmo and LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        if v.Name:lower():find("ammo") or v.Name:lower():find("clip") then
                            v.Value = 999
                        end
                    end
                end
            end
        end
    end

    -- Aimbot Instant Predict Lock to Head
    if D3DConfig.Aimbot then
        local mousePos = UserInputService:GetMouseLocation()
        local closestTarget, shortestDist = nil, D3DConfig.AimbotFov

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local hrp = p.Character.HumanoidRootPart
                local screenPt, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mag = (Vector2.new(screenPt.X, screenPt.Y) - mousePos).Magnitude
                    if mag < shortestDist then
                        shortestDist = mag
                        closestTarget = head.Position + (hrp.Velocity * 0.05)
                    end
                end
            end
        end

        if closestTarget and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService.TouchEnabled) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget)
        end
    end
end)

-- Long Jump & Infinite Jump Event
UserInputService.JumpRequest:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            if D3DConfig.LongJump and hrp then
                hrp.Velocity = hrp.Velocity + (hrp.CFrame.LookVector * 50) + Vector3.new(0, 40, 0)
            end
        end
    end
end)
