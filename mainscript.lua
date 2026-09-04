-- v1.0.25 - FIXED GUI VISIBILITY & ENHANCED SILENT AIM
local Players = game:GetService("Players") 
local UserInputService = game:GetService("UserInputService") 
local Lighting = game:GetService("Lighting") 
local Workspace = game:GetService("Workspace") 
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera 
local LocalPlayer = Players.LocalPlayer 

local ScreenGui = Instance.new("ScreenGui") 
ScreenGui.Name = "D3D_Ultimate_Android_Fix" 
ScreenGui.ResetOnSpawn = false 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- PERBAIKAN UTAMA: Safe Parent Routing untuk Android Executor
pcall(function()
    if syn and syn.protect_gui then 
        syn.protect_gui(ScreenGui) 
        ScreenGui.Parent = CoreGui 
    elseif gethui then 
        ScreenGui.Parent = gethui() 
    else
        ScreenGui.Parent = CoreGui
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- CONFIG & STORAGE
local VisualsConfig = {
    ESP_Line = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Gender = false,
    ESP_Item = false,
    ItemRadius = 50,
    ChamsGlow = false,
    ChamsColor = Color3.fromRGB(255, 0, 128)
}

local PlayerConfig = {
    SpeedHack = false,
    SpeedValue = 16,
    Fly = false,
    MultiJump = false,
    WallHack = false
}

local WorldConfig = {
    NightMode = false,
    DaylightMode = false,
    TeleportButton = false
}

local SilentAimConfig = {
    Enabled = false,
    FOVSize = 120,
    NoReload = false,
    InfiniteAmmo = false,
    Prediction = true,
    PredictionFactor = 0.16, -- Ditingkatkan sedikit agar lebih pas saat musuh lari
    NoRecoil = true,        -- Default aktif sesuai permintaan
    FastFire = true         -- Default aktif agar fire speed bertambah
}

local ESPCache = {}
local isFiring = false

-- SAFE DRAWING WRAPPER (Mencegah Crash jika Executor tidak support Drawing)
local function SafeDraw(drawType)
    local success, obj = pcall(function()
        return Drawing.new(drawType)
    end)
    if success and obj then
        return obj
    else
        -- Dummy object pengaman jika Drawing API tidak ada
        return { Visible = false, Remove = function() end }
    end
end

-- SILENT AIM DRAWINGS
local FOVCircle = SafeDraw("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.NumSides = 64

local TargetLine = SafeDraw("Line")
TargetLine.Visible = false
TargetLine.Thickness = 1.5
TargetLine.Color = Color3.fromRGB(255, 0, 0)

-- FLOATING BUTTON UI (MAIN MENU)
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

-- FLOATING BUTTON TELEPORT KHUSUS
local TeleportFloatBtn = Instance.new("TextButton")
TeleportFloatBtn.Size = UDim2.new(0, 52, 0, 52)
TeleportFloatBtn.Position = UDim2.new(0, 20, 0, 170)
TeleportFloatBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
TeleportFloatBtn.Text = "TP"
TeleportFloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportFloatBtn.TextSize = 14
TeleportFloatBtn.Font = Enum.Font.GothamBold
TeleportFloatBtn.Active = true
TeleportFloatBtn.Draggable = true
TeleportFloatBtn.Visible = false
TeleportFloatBtn.Parent = ScreenGui

Instance.new("UICorner", TeleportFloatBtn).CornerRadius = UDim.new(1, 0)
local TpStroke = Instance.new("UIStroke", TeleportFloatBtn)
TpStroke.Thickness = 2
TpStroke.Color = Color3.fromRGB(255, 255, 255)

local function DoTeleport()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local otherPlayers = Players:GetPlayers()
    local validTargets = {}
    for _, p in ipairs(otherPlayers) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validTargets, p.Character.HumanoidRootPart)
        end
    end
    
    if #validTargets > 0 then
        local targetHRP = validTargets[math.random(1, #validTargets)]
        hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    end
end

TeleportFloatBtn.MouseButton1Click:Connect(DoTeleport)

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

local menuVisible = true 
FloatButton.MouseButton1Click:Connect(function() 
    menuVisible = not menuVisible 
    MainFrame.Visible = menuVisible 
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
            if b:IsA("TextButton") then 
                b.TextColor3 = Color3.fromRGB(110, 110, 140) 
            end 
        end 
        btn.TextColor3 = Color3.fromRGB(255, 255, 255) 
    end) 
end 

-- UI BUILDERS
local function CreateToggle(parent, text, defaultState, callback) 
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
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36) 
    toggleBtn.Text = "" 
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0) 

    local circle = Instance.new("Frame", toggleBtn) 
    circle.Size = UDim2.new(0, 16, 0, 16) 
    circle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0) 

    local active = defaultState
    toggleBtn.MouseButton1Click:Connect(function() 
        active = not active 
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36) 
        circle:TweenPosition(active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true) 
        if callback then callback(active) end
    end) 
    frame.Parent = parent 
end 

local function CreateSlider(parent, text, minVal, maxVal, defaultVal, callback) 
    local frame = Instance.new("Frame") 
    frame.Size = UDim2.new(1, 0, 0, 44) 
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18) 
    frame.BorderSizePixel = 0 
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8) 

    local label = Instance.new("TextLabel", frame) 
    label.Size = UDim2.new(1, -24, 0, 18) 
    label.Position = UDim2.new(0, 12, 0, 4) 
    label.BackgroundTransparency = 1 
    label.Text = text .. ": " .. tostring(defaultVal) 
    label.TextColor3 = Color3.fromRGB(220, 220, 235) 
    label.TextSize = 10.5 
    label.Font = Enum.Font.GothamMedium 
    label.TextXAlignment = Enum.TextXAlignment.Left 

    local sliderBg = Instance.new("TextButton", frame) 
    sliderBg.Size = UDim2.new(1, -24, 0, 6) 
    sliderBg.Position = UDim2.new(0, 12, 0, 28) 
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 36) 
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0) 

    local sliderFill = Instance.new("Frame", sliderBg) 
    sliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0) 
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255) 
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0) 

    local dragging = false
    local function updateInput(input)
        local absolutePosition = sliderBg.AbsolutePosition.X
        local absoluteSize = sliderBg.AbsoluteSize.X
        if absoluteSize <= 0 then return end
        local pos = math.clamp((input.Position.X - absolutePosition) / absoluteSize, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        label.Text = text .. ": " .. tostring(val)
        if callback then callback(val) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    frame.Parent = parent 
end 

-- POPULATE TABS
CreateToggle(TabContentFrames["Visual"], "ESP Line (Top Center)", false, function(v) VisualsConfig.ESP_Line = v end) 
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) VisualsConfig.ESP_Name = v end) 
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) VisualsConfig.ESP_Distance = v end) 
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", false, function(v) VisualsConfig.ESP_Gender = v end) 

CreateToggle(TabContentFrames["Player"], "Speed Run", false, function(v) 
    PlayerConfig.SpeedHack = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end) 
CreateSlider(TabContentFrames["Player"], "Speed Value", 16, 200, 16, function(val) PlayerConfig.SpeedValue = val end) 
CreateToggle(TabContentFrames["Player"], "Fly (Hold Jump)", false, function(v) PlayerConfig.Fly = v end) 
CreateToggle(TabContentFrames["Player"], "Multi Jump", false, function(v) PlayerConfig.MultiJump = v end) 
CreateToggle(TabContentFrames["Player"], "Wall Hack", false, function(v) PlayerConfig.WallHack = v end) 

CreateToggle(TabContentFrames["world"], "Night Mode", false, function(v) WorldConfig.NightMode = v end) 
CreateToggle(TabContentFrames["world"], "Daylight Mode", false, function(v) WorldConfig.DaylightMode = v end) 
CreateToggle(TabContentFrames["world"], "Floating Teleport Button", false, function(v)
    WorldConfig.TeleportButton = v
    TeleportFloatBtn.Visible = v
end)

CreateToggle(TabContentFrames["skill"], "Silent Aim", false, function(v)
    SilentAimConfig.Enabled = v
    FOVCircle.Visible = v
    TargetLine.Visible = v
end)

CreateSlider(TabContentFrames["skill"], "Silent Aim FOV Size", 50, 300, 120, function(val)
    SilentAimConfig.FOVSize = val
end)

CreateToggle(TabContentFrames["skill"], "Prediction Movement", true, function(v)
    SilentAimConfig.Prediction = v
end)

CreateToggle(TabContentFrames["skill"], "No Recoil", true, function(v)
    SilentAimConfig.NoRecoil = v
end)

CreateToggle(TabContentFrames["skill"], "Fast Fire / Rapid Speed", true, function(v)
    SilentAimConfig.FastFire = v
end)

CreateToggle(TabContentFrames["skill"], "No Reload", false, function(v)
    SilentAimConfig.NoReload = v
end)

CreateToggle(TabContentFrames["skill"], "Unlimited Ammo", false, function(v)
    SilentAimConfig.InfiniteAmmo = v
end)

-- MULTI JUMP
UserInputService.JumpRequest:Connect(function()
    if not PlayerConfig.MultiJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local function IsVisible(targetPart)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local origin = hrp.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if not result then return true end
    if result.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

-- LOGIKA PREDIKSI & AUTO NO RECOIL / FIRE SPEED
local function GetPredictedTargetPosition(head, hrp)
    if not head then return nil end
    local targetPos = head.Position
    if SilentAimConfig.Prediction and hrp then
        local velocity = hrp.AssemblyLinearVelocity or hrp.Velocity
        if velocity then
            targetPos = targetPos + (velocity * SilentAimConfig.PredictionFactor)
        end
    end
    return targetPos
end

local function GetBestSilentAimTarget()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestScore = math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and (not player.Team or player.Team ~= LocalPlayer.Team) then
            local pChar = player.Character
            local head = pChar and pChar:FindFirstChild("Head")
            local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local hum = pChar and pChar:FindFirstChildOfClass("Humanoid")

            if head and pHrp and hum and hum.Health > 0 then
                if IsVisible(head) then
                    local predictedPos = GetPredictedTargetPosition(head, pHrp)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                    if onScreen then
                        local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local distToCrosshair = (screenPos2D - screenCenter).Magnitude
                        
                        if distToCrosshair <= SilentAimConfig.FOVSize then
                            local distToPlayer = (hrp.Position - head.Position).Magnitude
                            local score = distToCrosshair + (distToPlayer * 0.2)
                            
                            if score < bestScore then
                                bestScore = score
                                bestTarget = {Head = head, PredictedPos = predictedPos}
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

UserInputService.InputBegan:Connect(function(input)
    if not SilentAimConfig.Enabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local n = obj.Name:lower()
                        if SilentAimConfig.InfiniteAmmo and (n:find("ammo") or n:find("clip") or n:find("mag")) then
                            obj.Value = 9999
                        end
                        if SilentAimConfig.NoReload and (n:find("reload") or n:find("cooldown")) then
                            obj.Value = 0
                        end
                        if SilentAimConfig.NoRecoil and (n:find("recoil") or n:find("spread") or n:find("kick")) then
                            obj.Value = 0
                        end
                        if SilentAimConfig.FastFire and (n:find("firerate") or n:find("delay") or n:find("rate")) then
                            obj.Value = 0.01
                        end
                    end
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if SilentAimConfig.Enabled then
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = SilentAimConfig.FOVSize
        FOVCircle.Visible = true

        local targetData = GetBestSilentAimTarget()
        if targetData and targetData.Head then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetData.PredictedPos)
            if onScreen then
                TargetLine.From = screenCenter
                TargetLine.To = Vector2.new(screenPos.X, screenPos.Y)
                TargetLine.Visible = true
                
                if isFiring then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetData.PredictedPos)
                end
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
end)
