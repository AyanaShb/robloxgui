-- v3.3 --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ScriptContext = game:GetService("ScriptContext")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT & METATABLE HOOKS
-- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function()
                setreadonly(getrenv(), false)
                setreadonly(getreg(), false)
                setreadonly(getgc(), false)
            end)
        end
        if make_writeable then
            pcall(function() make_writeable(getreg()) end)
        end
        if detour_function then
            detour_function = function(...) return true end
        end
        if getconnections then
            pcall(function()
                for _, connection in ipairs(getconnections(ScriptContext.Error)) do
                    connection:Disable()
                end
            end)
        end
        if getcallingscript then
            pcall(function()
                getcallingscript = function() return nil end
            end)
        end
        for _, tableName in ipairs({"_G", "shared"}) do
            pcall(function()
                local target = getgenv()[tableName]
                if target and type(target) == "table" then
                    for key, _ in pairs(target) do
                        local strKey = tostring(key):lower()
                        if strKey:find("signature") or strKey:find("checksum") or strKey:find("hash") then
                            target[key] = nil
                        end
                    end
                end
            end)
        end
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("handshake") or name:find("validate") or name:find("verify") or name:find("integrity") or name:find("anti") then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote.FireServer = function(...) return true end
                        elseif remote:IsA("RemoteFunction") then
                            remote.InvokeServer = function(...) return true end
                        end
                    end)
                end
            end
        end
    end)
end)

pcall(function()
    local mt = getrawmetatable(game)
    if mt and mt.__index then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() and t:IsA("BasePart") and tostring(k) == "CanCollide" then
                return true
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Ultimate_Android_V3_3"
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

-- Global Notification Popup Function
local function ShowPopupNotification(message)
    pcall(function()
        local existing = ScreenGui:FindFirstChild("PopupNotify")
        if existing then existing:Destroy() end

        local notif = Instance.new("Frame")
        notif.Name = "PopupNotify"
        notif.Size = UDim2.new(0, 260, 0, 42)
        notif.Position = UDim2.new(0.5, -130, 0, 15)
        notif.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.ZIndex = 999
        notif.Parent = ScreenGui

        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", notif)
        stroke.Thickness = 1.5
        local grad = Instance.new("UIGradient", stroke)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
        })

        local lbl = Instance.new("TextLabel", notif)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = message
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBold
        lbl.ZIndex = 1000

        task.spawn(function()
            notif.Position = UDim2.new(0.5, -130, 0, -50)
            notif:TweenPosition(UDim2.new(0.5, -130, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
            task.wait(2)
            notif:TweenPosition(UDim2.new(0.5, -130, 0, -50), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
            task.wait(0.2)
            notif:Destroy()
        end)
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
    EnemyChams = false,
    SkeletonColor = Color3.fromRGB(0, 240, 255),
    LineColor = Color3.fromRGB(0, 240, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    GenderColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 128),
    ChamsColor = Color3.fromRGB(255, 0, 128),
    EnemyChamsColor = Color3.fromRGB(255, 0, 0)
}

local WorldConfig = {
    NightMode = false,
    Daylight = false,
    DaylightBrightness = 3,
    DaylightClock = 14
}

-- Hack & Aimbot Configurations
local HackConfig = {
    AntiAdminAktif = false,
    AimbotAktif = false,
    AimbotMode = "POV Kamera (FOV)",
    AimTargetMode = "Head",
    AimbotSmoothness = 15,
    ShowFOV = false,
    FOVRadius = 150,
    FFAModeAktif = false,
    AntiFallDamageAktif = false,
    SpeedAktif = false,
    CustomSpeed = 50,
    JumpAktif = false,
    CustomJump = 100,
    GunModsAktif = false,
    CustomFireRate = 800
}

local ESPCache = {}
local ChamsCache = {}
local EnemyChamsCache = {}
local LockedTarget = nil

-- FOV Circle GUI
local FOVGui, FOVFrame
pcall(function()
    FOVGui = Instance.new("ScreenGui")
    FOVGui.Name = "Universal_FOV_System"
    FOVGui.Parent = ScreenGui
    FOVGui.IgnoreGuiInset = true
    FOVFrame = Instance.new("Frame")
    FOVFrame.Parent = FOVGui
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVFrame.Size = UDim2.new(0, HackConfig.FOVRadius * 2, 0, HackConfig.FOVRadius * 2)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.Visible = false
    local FOVStroke = Instance.new("UIStroke", FOVFrame)
    FOVStroke.Color = Color3.fromRGB(255, 255, 255)
    FOVStroke.Thickness = 1.5
    FOVStroke.Transparency = 0.5
    local FOVCorner = Instance.new("UICorner", FOVFrame)
    FOVCorner.CornerRadius = UDim.new(1, 0)
end)

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
TitleLabel.Text = "× D3D MENU: ULTRA REBUILD v3.3 ×"
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

local tabs = {"Visual", "Player", "World", "Skill", "Configuration"}
local TabContentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.2, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(110, 110, 140)
    btn.TextSize = 10
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

local function CreateDropdown(parent, text, options, defaultOption, callback)
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

    local dropBtn = Instance.new("TextButton", frame)
    dropBtn.Size = UDim2.new(0, 140, 0, 32)
    dropBtn.Position = UDim2.new(1, -152, 0.5, -16)
    dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    dropBtn.Text = defaultOption
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 10
    dropBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)

    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == defaultOption then currentIndex = i break end
    end

    dropBtn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        local selected = options[currentIndex]
        dropBtn.Text = selected
        if callback then callback(selected) end
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

    local colors = {defaultColor, Color3.fromRGB(0, 240, 255), Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 230, 130), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0)}
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

local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if HackConfig.FFAModeAktif then return true end
    if player.Team and LocalPlayer.Team then
        if player.Team == LocalPlayer.Team then return false end
    end
    return true
end

local function IsVisible(targetPart)
    if not targetPart then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local rayResult = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 5000, rayParams)
    return rayResult and rayResult.Instance:IsDescendantOf(targetPart.Parent) or false
end

local function GetDynamicTargetPart(char)
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    local neck = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local body = char:FindFirstChild("HumanoidRootPart") or neck or head

    if HackConfig.AimTargetMode == "Head" then
        return head or body
    elseif HackConfig.AimTargetMode == "Neck" then
        return neck or head or body
    elseif HackConfig.AimTargetMode == "Body" then
        return body or head
    end
    return body
end

local function GetNewTarget3D()
    local closest, shortestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) and player.Character then
            local targetPart = GetDynamicTargetPart(player.Character)
            if targetPart and not player.Character:FindFirstChildOfClass("ForceField") then
                local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = player.Character
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemy2D()
    local closest, shortestDist = nil, HackConfig.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) and player.Character then
            local targetPart = GetDynamicTargetPart(player.Character)
            if targetPart and not player.Character:FindFirstChildOfClass("ForceField") then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = player.Character
                    end
                end
            end
        end
    end
    return closest
end

local function HideESPObject(esp)
    if not esp then return end
    pcall(function()
        if esp.Line then esp.Line.Visible = false end
        if esp.Name then esp.Name.Visible = false end
        if esp.Distance then esp.Distance.Visible = false end
        if esp.Gender then esp.Gender.Visible = false end
        if esp.HealthBarBg then esp.HealthBarBg.Visible = false end
        if esp.HealthBar then esp.HealthBar.Visible = false end
        if esp.HeadCircle then esp.HeadCircle.Visible = false end
        if esp.Skeleton then
            for _, bone in pairs(esp.Skeleton) do
                if bone then bone.Visible = false end
            end
        end
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
    if ChamsCache[player] then
        pcall(function() ChamsCache[player]:Destroy() end)
        ChamsCache[player] = nil
    end
    if EnemyChamsCache[player] then
        pcall(function() EnemyChamsCache[player]:Destroy() end)
        EnemyChamsCache[player] = nil
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
        HeadCircle = Drawing.new("Circle"),
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
    espData.Line.Visible = false

    espData.HealthBarBg.Thickness = 3
    espData.HealthBarBg.Color = Color3.fromRGB(40, 40, 40)
    espData.HealthBarBg.Transparency = 0.8
    espData.HealthBarBg.Visible = false

    espData.HealthBar.Thickness = 1.5
    espData.HealthBar.Color = VisualsConfig.HealthColor
    espData.HealthBar.Transparency = 1
    espData.HealthBar.Visible = false

    espData.HeadCircle.Thickness = 1.5
    espData.HeadCircle.NumSides = 12
    espData.HeadCircle.Filled = false
    espData.HeadCircle.Color = VisualsConfig.SkeletonColor
    espData.HeadCircle.Transparency = 0.8
    espData.HeadCircle.Visible = false

    for _, bone in pairs(espData.Skeleton) do
        bone.Thickness = 1.5
        bone.Color = VisualsConfig.SkeletonColor
        bone.Transparency = 0.8
        bone.Visible = false
    end

    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender}) do
        textObj.Size = 13
        textObj.Center = true
        textObj.Outline = true
        textObj.OutlineColor = Color3.fromRGB(0, 0, 0)
        textObj.Font = Drawing.Fonts.UI
        textObj.Visible = false
    end

    ESPCache[player] = espData
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end
    CreatePlayerESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        CreatePlayerESP(player)
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(RemovePlayerESP)

-- Visual Tab Populating
CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Universal Rig)", false, function(v) 
    VisualsConfig.ESP_Skeleton = v 
    if not v then
        for _, esp in pairs(ESPCache) do
            if esp.HeadCircle then esp.HeadCircle.Visible = false end
            if esp.Skeleton then for _, b in pairs(esp.Skeleton) do b.Visible = false end end
        end
    end
end)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", Color3.fromRGB(0, 240, 255), function(c) 
    VisualsConfig.SkeletonColor = c 
    for _, esp in pairs(ESPCache) do 
        esp.HeadCircle.Color = c
        for _, bone in pairs(esp.Skeleton) do bone.Color = c end 
    end
end)
CreateToggle(TabContentFrames["Visual"], "Chams / Wall Glow", false, function(v) VisualsConfig.Chams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Chams Glow Color", Color3.fromRGB(255, 0, 128), function(c) VisualsConfig.ChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "Enemy Chams", false, function(v) VisualsConfig.EnemyChams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Enemy Chams Color", Color3.fromRGB(255, 0, 0), function(c) VisualsConfig.EnemyChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", false, function(v) 
    VisualsConfig.ESP_Line = v 
    if not v then
        for _, esp in pairs(ESPCache) do
            if esp.Line then esp.Line.Visible = false end
        end
    end
end)
CreateColorPicker(TabContentFrames["Visual"], "Line Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.LineColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) 
    VisualsConfig.ESP_Name = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Name then esp.Name.Visible = false end end end
end)
CreateColorPicker(TabContentFrames["Visual"], "Name Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.NameColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) 
    VisualsConfig.ESP_Distance = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Distance then esp.Distance.Visible = false end end end
end)
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.DistanceColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender [Cowo/Cewe]", false, function(v) 
    VisualsConfig.ESP_Gender = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Gender then esp.Gender.Visible = false end end end
end)
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.GenderColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Health (Vertical Bar)", false, function(v) 
    VisualsConfig.ESP_Health = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.HealthBarBg then esp.HealthBarBg.Visible = false end if esp.HealthBar then esp.HealthBar.Visible = false end end end
end)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end)

-- Player Tab Populating
CreateToggle(TabContentFrames["Player"], "No Fall Damage", false, function(v) 
    HackConfig.AntiFallDamageAktif = v 
    ShowPopupNotification(v and "No Fall Damage Diaktifkan" or "No Fall Damage Dimatikan")
end)
CreateToggle(TabContentFrames["Player"], "Kecepatan Lari", false, function(v) 
    HackConfig.SpeedAktif = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    ShowPopupNotification(v and "Kecepatan Lari Diaktifkan" or "Kecepatan Lari Dimatikan")
end)
CreateSlider(TabContentFrames["Player"], "Set Speed", 16, 250, 50, function(val) HackConfig.CustomSpeed = val end)
CreateToggle(TabContentFrames["Player"], "Lompat Tinggi", false, function(v) 
    HackConfig.JumpAktif = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    ShowPopupNotification(v and "Lompat Tinggi Diaktifkan" or "Lompat Tinggi Dimatikan")
end)
CreateSlider(TabContentFrames["Player"], "Set Power", 50, 250, 100, function(val) HackConfig.CustomJump = val end)

-- World Tab Populating
CreateToggle(TabContentFrames["World"], "Night Mode", false, function(v)
    WorldConfig.NightMode = v
    if v then WorldConfig.Daylight = false else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
    ShowPopupNotification(v and "Night Mode Diaktifkan" or "Night Mode Dimatikan")
end)

CreateToggle(TabContentFrames["World"], "Daylight (Indoor/Outdoor)", false, function(v)
    WorldConfig.Daylight = v
    if v then WorldConfig.NightMode = false else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
    ShowPopupNotification(v and "Daylight Diaktifkan" or "Daylight Dimatikan")
end)

CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end)
CreateSlider(TabContentFrames["World"], "Daylight Time (Clock)", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end)

-- Skill Tab Populating
CreateToggle(TabContentFrames["Skill"], "Peringatan Admin (Popup Warning)", false, function(v) 
    HackConfig.AntiAdminAktif = v 
    ShowPopupNotification(v and "Peringatan Admin Diaktifkan" or "Peringatan Admin Dimatikan")
end)
CreateToggle(TabContentFrames["Skill"], "Aktifkan Auto Aim (Kunci Layar)", false, function(v) 
    HackConfig.AimbotAktif = v 
    ShowPopupNotification(v and "Auto Aim Diaktifkan" or "Auto Aim Dimatikan")
end)
CreateDropdown(TabContentFrames["Skill"], "Mode Aimbot", {"POV Kamera (FOV)", "360° (Brutal)"}, "POV Kamera (FOV)", function(opt) HackConfig.AimbotMode = opt end)
CreateDropdown(TabContentFrames["Skill"], "Target Bagian Tubuh", {"Head", "Neck", "Body"}, "Head", function(opt) HackConfig.AimTargetMode = opt end)
CreateSlider(TabContentFrames["Skill"], "Kelengketan Aim POV (Smoothness)", 1, 100, 15, function(val) HackConfig.AimbotSmoothness = val end)
CreateToggle(TabContentFrames["Skill"], "Tampilkan Lingkaran FOV", false, function(v) HackConfig.ShowFOV = v end)
CreateSlider(TabContentFrames["Skill"], "Lebar Lingkaran FOV", 10, 600, 150, function(val) HackConfig.FOVRadius = val end)
CreateToggle(TabContentFrames["Skill"], "Gun Mods (Infinite Ammo & RPM)", false, function(v) 
    HackConfig.GunModsAktif = v 
    ShowPopupNotification(v and "Gun Mods Diaktifkan" or "Gun Mods Dimatikan")
end)
CreateSlider(TabContentFrames["Skill"], "RPM Fire Rate", 400, 2500, 800, function(val) HackConfig.CustomFireRate = val end)

-- Configuration Tab Populating
local ConfigFileName = "LiteHack_Config.json"
local function SaveSettings()
    local settings = {
        AntiAdmin = HackConfig.AntiAdminAktif,
        Aimbot = HackConfig.AimbotAktif,
        AimbotMode = HackConfig.AimbotMode,
        AimTargetMode = HackConfig.AimTargetMode,
        ShowFOV = HackConfig.ShowFOV,
        FOVRadius = HackConfig.FOVRadius,
        Smoothness = HackConfig.AimbotSmoothness,
        AntiFall = HackConfig.AntiFallDamageAktif,
        SpeedAktif = HackConfig.SpeedAktif,
        CustomSpeed = HackConfig.CustomSpeed,
        JumpAktif = HackConfig.JumpAktif,
        CustomJump = HackConfig.CustomJump,
        GunModsAktif = HackConfig.GunModsAktif,
        CustomFireRate = HackConfig.CustomFireRate
    }
    if writefile then
        pcall(function()
            writefile(ConfigFileName, HttpService:JSONEncode(settings))
        end)
        return true
    end
    return false
end

local function LoadSettings()
    if isfile and readfile and isfile(ConfigFileName) then
        local success, json = pcall(function() return readfile(ConfigFileName) end)
        if success and json then
            local settings = HttpService:JSONDecode(json)
            if settings.AntiAdmin ~= nil then HackConfig.AntiAdminAktif = settings.AntiAdmin end
            if settings.Aimbot ~= nil then HackConfig.AimbotAktif = settings.Aimbot end
            if settings.AimbotMode ~= nil then HackConfig.AimbotMode = settings.AimbotMode end
            if settings.AimTargetMode ~= nil then HackConfig.AimTargetMode = settings.AimTargetMode end
            if settings.ShowFOV ~= nil then HackConfig.ShowFOV = settings.ShowFOV end
            if settings.FOVRadius ~= nil then HackConfig.FOVRadius = settings.FOVRadius end
            if settings.Smoothness ~= nil then HackConfig.AimbotSmoothness = settings.Smoothness end
            if settings.AntiFall ~= nil then HackConfig.AntiFallDamageAktif = settings.AntiFall end
            if settings.SpeedAktif ~= nil then HackConfig.SpeedAktif = settings.SpeedAktif end
            if settings.CustomSpeed ~= nil then HackConfig.CustomSpeed = settings.CustomSpeed end
            if settings.JumpAktif ~= nil then HackConfig.JumpAktif = settings.JumpAktif end
            if settings.CustomJump ~= nil then HackConfig.CustomJump = settings.CustomJump end
            if settings.GunModsAktif ~= nil then HackConfig.GunModsAktif = settings.GunModsAktif end
            if settings.CustomFireRate ~= nil then HackConfig.CustomFireRate = settings.CustomFireRate end
            return true
        end
    end
    return false
end

CreateToggle(TabContentFrames["Configuration"], "Ubah Tema Neon Ungu/Cyan", true, function(v)
    if v then
        MainGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 0, 255))
        })
        ShowPopupNotification("Tema Diubah ke Neon Ungu/Cyan")
    else
        MainGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 100, 100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
        })
        ShowPopupNotification("Tema Diubah ke Monokrom")
    end
end)

local SaveBtn = Instance.new("TextButton", TabContentFrames["Configuration"])
SaveBtn.Size = UDim2.new(1, 0, 0, 36)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 130)
SaveBtn.Text = "💾 Save Konfigurasi"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 11
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)
SaveBtn.MouseButton1Click:Connect(function()
    SaveSettings()
    ShowPopupNotification("Konfigurasi Berhasil Disimpan!")
end)

local LoadBtn = Instance.new("TextButton", TabContentFrames["Configuration"])
LoadBtn.Size = UDim2.new(1, 0, 0, 36)
LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LoadBtn.Text = "📂 Load Konfigurasi"
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.TextSize = 11
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 8)
LoadBtn.MouseButton1Click:Connect(function()
    LoadSettings()
    ShowPopupNotification("Konfigurasi Berhasil Dimuat!")
end)

-- Admin Check Logic
local function CheckIfAdmin(p)
    if p == LocalPlayer then return false end
    local nameRaw = string.upper(p.Name .. " " .. p.DisplayName)
    if string.find(nameRaw, "%[GM%]") or string.find(nameRaw, "%[MOD%]") or string.find(nameRaw, "GAME MASTER") or string.find(nameRaw, "MODERATOR") then return true end
    return false
end

local function SendAdminWarning(p)
    pcall(function()
        TitleLabel.Text = "⚠️ ADMIN TERDETEKSI: " .. p.Name
        ShowPopupNotification("⚠️ ADMIN TERDETEKSI: " .. p.Name)
        task.delay(5, function() TitleLabel.Text = "× D3D MENU: ULTRA REBUILD v3.3 ×" end)
    end)
end

Players.PlayerAdded:Connect(function(p)
    if HackConfig.AntiAdminAktif and CheckIfAdmin(p) then SendAdminWarning(p) end
end)

-- Render Stepped World, Physics, Chams & Full Aimbot Loop
RunService.RenderStepped:Connect(function()
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

    if FOVFrame then
        FOVFrame.Size = UDim2.new(0, HackConfig.FOVRadius * 2, 0, HackConfig.FOVRadius * 2)
        FOVFrame.Visible = HackConfig.ShowFOV and (HackConfig.AimbotAktif and HackConfig.AimbotMode == "POV Kamera (FOV)")
    end

    -- Aimbot Tracking Loop
    if HackConfig.AimbotAktif then
        local targetValid = false
        local partToAim = nil

        if LockedTarget and LockedTarget.Parent then
            local plr = Players:GetPlayerFromCharacter(LockedTarget)
            if (not plr or IsEnemy(plr)) and not LockedTarget:FindFirstChildOfClass("ForceField") then
                partToAim = GetDynamicTargetPart(LockedTarget)
                if partToAim then
                    if HackConfig.AimbotMode == "POV Kamera (FOV)" then
                        local pos, onScreen = Camera:WorldToViewportPoint(partToAim.Position)
                        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                        if onScreen and dist <= HackConfig.FOVRadius then
                            targetValid = true
                        end
                    else
                        targetValid = true
                    end
                end
            end
        end

        if not targetValid then
            if HackConfig.AimbotMode == "360° (Brutal)" then
                LockedTarget = GetNewTarget3D()
            elseif HackConfig.AimbotMode == "POV Kamera (FOV)" then
                local closestEnemy = GetClosestEnemy2D()
                LockedTarget = closestEnemy
            end
            if LockedTarget then
                partToAim = GetDynamicTargetPart(LockedTarget)
            end
        end

        if LockedTarget and partToAim then
            if HackConfig.AimbotMode == "360° (Brutal)" then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, partToAim.Position)
            else
                local smoothFactor = HackConfig.AimbotSmoothness / 100
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, partToAim.Position), smoothFactor)
            end
        else
            LockedTarget = nil
        end
    else
        LockedTarget = nil
    end

    -- Enemy Chams Loop
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local isEnemy = IsEnemy(player)
            if VisualsConfig.EnemyChams and isEnemy then
                if not EnemyChamsCache[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "D3D_EnemyChams"
                    highlight.Adornee = char
                    highlight.FillColor = VisualsConfig.EnemyChamsColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineTransparency = 0
                    highlight.Parent = char
                    EnemyChamsCache[player] = highlight
                else
                    EnemyChamsCache[player].FillColor = VisualsConfig.EnemyChamsColor
                    EnemyChamsCache[player].Enabled = true
                end
            else
                if EnemyChamsCache[player] then
                    EnemyChamsCache[player].Enabled = false
                end
            end
        end
    end

    -- Universal ESP Loop with Auto-Fallback Parts (R15, R6 & Custom Rig Support)
    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local isEnemy = IsEnemy(player)
        
        -- Fallback detection: Mencari bagian tubuh utama apa pun agar player tidak lolos deteksi rig kustom
        local primaryPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        -- Validasi fleksibel: Tidak wajib ada Humanoid jika char dan part utama valid
        local active = isEnemy and char and primaryPart and (not hum or hum.Health > 0)

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
            local vector, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - primaryPart.Position).Magnitude

                if VisualsConfig.ESP_Skeleton then
                    local head = char:FindFirstChild("Head")
                    local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or primaryPart
                    local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
                    local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand") or primaryPart
                    local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") or primaryPart
                    local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot") or primaryPart
                    local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot") or primaryPart

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

                    if hPos then
                        esp.HeadCircle.Position = hPos
                        local headSize = head and (Camera:WorldToViewportPoint((head.Position + Vector3.new(0, 1, 0))).Y - Camera:WorldToViewportPoint(head.Position).Y) or 10
                        esp.HeadCircle.Radius = math.clamp(math.abs(headSize) * 1.2, 6, 25)
                        esp.HeadCircle.Color = VisualsConfig.SkeletonColor
                        esp.HeadCircle.Visible = true
                    else
                        esp.HeadCircle.Visible = false
                    end

                    drawBone(esp.Skeleton.Spine, hPos or utPos, utPos)
                    drawBone(esp.Skeleton.LeftArm, utPos, laPos)
                    drawBone(esp.Skeleton.RightArm, utPos, raPos)
                    drawBone(esp.Skeleton.LeftLeg, ltPos, llPos)
                    drawBone(esp.Skeleton.RightLeg, ltPos, rlPos)
                else
                    esp.HeadCircle.Visible = false
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

                if VisualsConfig.ESP_Health and hum then
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
                HideESPObject(esp)
            end
        else
            HideESPObject(esp)
        end
    end
end)

-- Physics & Deep Memory Gun Mods Loop
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and HackConfig.AntiFallDamageAktif and hrp.Velocity.Y < -40 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z)
        end
        if hum then
            if HackConfig.SpeedAktif then hum.WalkSpeed = HackConfig.CustomSpeed end
            if HackConfig.JumpAktif then hum.UseJumpPower = true; hum.JumpPower = HackConfig.CustomJump end
        end
    end
end)

local function ScanValueMods(tool)
    pcall(function()
        local function SetSafe(attr, value)
            if tool:GetAttribute(attr) ~= nil then tool:SetAttribute(attr, value) end
        end
        SetSafe("TotalAmmo", 999999)
        SetSafe("NewMax", 999999)
        SetSafe("magazineSize", 999999)
        SetSafe("spread", 0)
        SetSafe("recoilMax", 0)
        SetSafe("reloadTime", 0.05)
        SetSafe("rateOfFire", HackConfig.CustomFireRate)
        for _, obj in pairs(tool:GetDescendants()) do
            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                local name = obj.Name:lower()
                if name:find("ammo") or name:find("clip") or name:find("mag") then
                    obj.Value = 999999
                elseif name:find("firerate") or name:find("rpm") then
                    obj.Value = HackConfig.CustomFireRate
                end
            end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if HackConfig.GunModsAktif then
        if LocalPlayer.Character then
            for _, t in pairs(LocalPlayer.Character:GetChildren()) do
                if t:IsA("Tool") or t:IsA("Model") then ScanValueMods(t) end
            end
        end
        for _, v in pairs(Camera:GetChildren()) do
            if v:IsA("Model") then ScanValueMods(v) end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if HackConfig.GunModsAktif and getgc then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "MaxAmmo") or rawget(v, "RPM") or rawget(v, "FireRate") then
                            if rawget(v, "Ammo") then v.Ammo = 999999 end
                            if rawget(v, "MaxAmmo") then v.MaxAmmo = 999999 end
                            if rawget(v, "RPM") then v.RPM = HackConfig.CustomFireRate end
                            if rawget(v, "FireRate") then v.FireRate = HackConfig.CustomFireRate end
                        end
                    end
                end
            end)
        end
    end
end)
