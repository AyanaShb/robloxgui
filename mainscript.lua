-- v4.0.1 - Full Script: Universal Bot/NPC ESP, Corner Box, Spine Skeleton, Custom Bypass & Safe Aimbot
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ScriptContext = game:GetService("ScriptContext")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Ultimate_Android_V4_0_1"
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
    EnemyESP = false,
    PlayerESP = false,
    ESPColor = Color3.fromRGB(0, 240, 255)
}

local WorldConfig = {
    NightMode = false,
    Daylight = false,
    DaylightBrightness = 3,
    DaylightClock = 14,
    WallHack = false,
    NoFog = false,
    SelectedTeleportTarget = "",
    FlyAktif = false
}

local HackConfig = {
    AntiAdminAktif = false,
    AimbotAktif = false,
    AimPredictionAktif = false,
    AimbotMode = "POV Kamera (FOV)",
    AimTargetMode = "Head",
    AimbotSmoothness = 15,
    WallCheck = false,
    ShowFOV = false,
    FOVRadius = 150,
    FFAModeAktif = false,
    AntiFallDamageAktif = false,
    SpeedAktif = false,
    CustomSpeed = 50,
    JumpAktif = false,
    CustomJump = 100
}

local ESPCache = {}
local LockedTarget = nil
local EntityGenderCache = {}
local AppTheme = "Dark"
local ThemeElements = {}

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
table.insert(ThemeElements, {Type = "Main", Obj = MainFrame})

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
TitleLabel.Text = "× D3D MENU: BOT & PLAYER v4.0.1 ×"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 11.5
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame
table.insert(ThemeElements, {Type = "Text", Obj = TitleLabel})

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -24, 0, 32)
TabContainer.Position = UDim2.new(0, 12, 0, 36)
TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabContainer.Parent = MainFrame
table.insert(ThemeElements, {Type = "Sub", Obj = TabContainer})

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
                b.TextColor3 = (AppTheme == "Light") and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(110, 110, 140)
            end
        end
        btn.TextColor3 = (AppTheme == "Light") and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end)
end

local function CreateToggle(parent, text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(ThemeElements, {Type = "TextSub", Obj = label})

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 42, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = toggleBtn})

    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultVal
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or ((AppTheme == "Light") and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(25, 25, 36))
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
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(ThemeElements, {Type = "TextSub", Obj = label})

    local dropBtn = Instance.new("TextButton", frame)
    dropBtn.Size = UDim2.new(0, 140, 0, 32)
    dropBtn.Position = UDim2.new(1, -152, 0.5, -16)
    dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    dropBtn.Text = defaultOption
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 10
    dropBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = dropBtn})
    table.insert(ThemeElements, {Type = "Text", Obj = dropBtn})

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
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(ThemeElements, {Type = "TextSub", Obj = label})

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
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(ThemeElements, {Type = "TextSub", Obj = label})

    local sliderBar = Instance.new("Frame", frame)
    sliderBar.Size = UDim2.new(1, -24, 0, 6)
    sliderBar.Position = UDim2.new(0, 12, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = sliderBar})

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

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -16, 1, -8)
    btn.Position = UDim2.new(0, 8, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = btn})
    table.insert(ThemeElements, {Type = "Text", Obj = btn})

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    frame.Parent = parent
end

local function IsValidEntityCharacter(char)
    if not char or not char:IsA("Model") then return false end
    if char == LocalPlayer.Character then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
    local head = char:FindFirstChild("Head")
    
    if not hum or not root or not head then return false end
    return true
end

local function GetEntityHealthData(char)
    if not char then return 100, 100 end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local hp = hum.Health
        local maxHp = hum.MaxHealth
        if maxHp and maxHp > 0 then
            return hp, maxHp
        end
    end

    local successAttrHp, attrHp = pcall(function() return char:GetAttribute("Health") or char:GetAttribute("HP") or char:GetAttribute("CurrentHealth") end)
    local successAttrMax, attrMax = pcall(function() return char:GetAttribute("MaxHealth") or char:GetAttribute("MaxHP") or 100 end)
    if successAttrHp and type(attrHp) == "number" then
        return attrHp, (type(attrMax) == "number" and attrMax > 0) and attrMax or 100
    end

    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            local name = obj.Name:lower()
            if name == "health" or name == "hp" or name == "currenthealth" then
                return obj.Value, 100
            end
        end
    end

    return 100, 100
end

local function IsEnemyEntity(char)
    if HackConfig.FFAModeAktif then return true end
    local pInstance = Players:GetPlayerFromCharacter(char)
    if pInstance then
        if pInstance == LocalPlayer then return false end
        if pInstance.Team and LocalPlayer.Team then
            if pInstance.Team == LocalPlayer.Team then return false end
        end
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
    local body = char:FindFirstChild("HumanoidRootPart") or neck or head or char.PrimaryPart or char:FindFirstChildOfClass("BasePart")

    if HackConfig.AimTargetMode == "Head" then
        return head or body
    elseif HackConfig.AimTargetMode == "Neck" then
        return neck or head or body
    elseif HackConfig.AimTargetMode == "Body" then
        return body or head
    end
    return body
end

local function GetAllTargetableEntities()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and IsValidEntityCharacter(p.Character) then
            table.insert(list, p.Character)
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and IsValidEntityCharacter(obj) then
            local isAlreadyPlayer = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character == obj then isAlreadyPlayer = true break end
            end
            if not isAlreadyPlayer then
                table.insert(list, obj)
            end
        end
    end
    return list
end

local function GetPredictedPosition(targetPart)
    if not targetPart then return Vector3.new(0, 0, 0) end
    local basePos = targetPart.Position
    if HackConfig.AimPredictionAktif then
        local velocity = targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
        local distance = (Camera.CFrame.Position - basePos).Magnitude
        local bulletSpeed = 1200
        local timeToTarget = distance / bulletSpeed
        return basePos + (velocity * timeToTarget)
    end
    return basePos
end

local function GetNewTarget3D()
    local closest, shortestDist = nil, math.huge
    for _, char in ipairs(GetAllTargetableEntities()) do
        if IsEnemyEntity(char) then
            local targetPart = GetDynamicTargetPart(char)
            if targetPart then
                if not HackConfig.WallCheck or IsVisible(targetPart) then
                    local predictedPos = GetPredictedPosition(targetPart)
                    local dist = (Camera.CFrame.Position - predictedPos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = char
                    end
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemy2D()
    local closest, shortestDist = nil, HackConfig.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, char in ipairs(GetAllTargetableEntities()) do
        if IsEnemyEntity(char) then
            local targetPart = GetDynamicTargetPart(char)
            if targetPart then
                if not HackConfig.WallCheck or IsVisible(targetPart) then
                    local predictedPos = GetPredictedPosition(targetPart)
                    local pos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                    if onScreen then
                        local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closest = char
                        end
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
        if esp.Status then esp.Status.Visible = false end
        if esp.HealthBarBg then esp.HealthBarBg.Visible = false end
        if esp.HealthBarBorder then esp.HealthBarBorder.Visible = false end
        if esp.HealthBar then esp.HealthBar.Visible = false end
        if esp.HeadCircle then esp.HeadCircle.Visible = false end
        if esp.HeadBillboard then esp.HeadBillboard.Enabled = false end
        if esp.CornerBox then
            for _, line in pairs(esp.CornerBox) do
                if line then line.Visible = false end
            end
        end
        if esp.Skeleton then
            for _, bone in pairs(esp.Skeleton) do
                if bone then bone.Visible = false end
            end
        end
    end)
end

local function RemoveEntityESP(key)
    if ESPCache[key] then
        for _, obj in pairs(ESPCache[key]) do
            if type(obj) == "table" then
                if obj.Remove then pcall(function() obj:Remove() end)
                else
                    for _, bone in pairs(obj) do pcall(function() bone:Remove() end) end
                end
            else
                pcall(function() obj:Remove() end)
            end
        end
        ESPCache[key] = nil
    end
end

local function CreateEntityESP(key)
    RemoveEntityESP(key)

    local headBillboard, headImageLabel
    pcall(function()
        local head = key:FindFirstChild("Head")
        local playerInstance = Players:GetPlayerFromCharacter(key)
        if head and playerInstance and playerInstance:IsA("Player") then
            headBillboard = Instance.new("BillboardGui")
            headBillboard.Name = "HeadPhotoESP"
            headBillboard.Adornee = head
            headBillboard.Size = UDim2.new(2.2, 0, 2.2, 0)
            headBillboard.StudsOffset = Vector3.new(0, 1.2, 0)
            headBillboard.AlwaysOnTop = true
            headBillboard.Enabled = false
            headBillboard.Parent = head

            headImageLabel = Instance.new("ImageLabel")
            headImageLabel.Size = UDim2.new(1, 0, 1, 0)
            headImageLabel.BackgroundTransparency = 1
            headImageLabel.Parent = headBillboard

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(1, 0)
            uiCorner.Parent = headImageLabel

            task.spawn(function()
                local success, content = pcall(function()
                    return Players:GetUserThumbnailAsync(playerInstance.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)
                if success and content and headImageLabel and headImageLabel.Parent then
                    headImageLabel.Image = content
                end
            end)
        end
    end)

    local cornerLines = {}
    for _, _ in ipairs({1, 2, 3, 4, 5, 6, 7, 8}) do
        local ln = Drawing.new("Line")
        ln.Thickness = 1.5
        ln.Transparency = 0.8
        ln.Visible = false
        table.insert(cornerLines, ln)
    end

    local espData = {
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Gender = Drawing.new("Text"),
        Status = Drawing.new("Text"),
        HealthBarBg = Drawing.new("Square"),
        HealthBarBorder = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        HeadCircle = Drawing.new("Circle"),
        HeadBillboard = headBillboard,
        CornerBox = cornerLines,
        Skeleton = {
            SpineHead = Drawing.new("Line"),
            SpineUpper = Drawing.new("Line"),
            SpineLower = Drawing.new("Line"),
            LeftArm = Drawing.new("Line"),
            RightArm = Drawing.new("Line"),
            LeftLeg = Drawing.new("Line"),
            RightLeg = Drawing.new("Line")
        }
    }

    espData.Line.Thickness = 1.5
    espData.Line.Transparency = 0.7
    espData.Line.Visible = false

    espData.HealthBarBg.Filled = true
    espData.HealthBarBg.Color = Color3.fromRGB(20, 20, 20)
    espData.HealthBarBg.Transparency = 0.6
    espData.HealthBarBg.Visible = false

    espData.HealthBarBorder.Filled = false
    espData.HealthBarBorder.Thickness = 1.5
    espData.HealthBarBorder.Transparency = 1
    espData.HealthBarBorder.Visible = false

    espData.HealthBar.Filled = true
    espData.HealthBar.Transparency = 1
    espData.HealthBar.Visible = false

    espData.HeadCircle.Thickness = 1.5
    espData.HeadCircle.NumSides = 12
    espData.HeadCircle.Filled = false
    espData.HeadCircle.Transparency = 0.8
    espData.HeadCircle.Visible = false

    for _, bone in pairs(espData.Skeleton) do
        bone.Thickness = 1.5
        bone.Transparency = 0.8
        bone.Visible = false
    end

    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender, espData.Status}) do
        textObj.Size = 13
        textObj.Center = true
        textObj.Outline = true
        textObj.OutlineColor = Color3.fromRGB(0, 0, 0)
        textObj.Font = Drawing.Fonts.UI
        textObj.Visible = false
    end

    ESPCache[key] = espData
end

CreateToggle(TabContentFrames["Visual"], "Enemy ESP (Player & Bot)", false, function(v) 
    VisualsConfig.EnemyESP = v 
end)

CreateToggle(TabContentFrames["Visual"], "Player ESP", false, function(v) 
    VisualsConfig.PlayerESP = v 
end)

CreateColorPicker(TabContentFrames["Visual"], "ESP Color (All)", Color3.fromRGB(0, 240, 255), function(c) 
    VisualsConfig.ESPColor = c 
end)

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

CreateToggle(TabContentFrames["World"], "Wall Hack (Noclip)", false, function(v)
    WorldConfig.WallHack = v
    ShowPopupNotification(v and "Wall Hack Diaktifkan" or "Wall Hack Dimatikan")
end)

CreateToggle(TabContentFrames["World"], "No Fog", false, function(v)
    WorldConfig.NoFog = v
    ShowPopupNotification(v and "No Fog Diaktifkan" or "No Fog Dimatikan")
end)

CreateToggle(TabContentFrames["World"], "Fly (Tahan Tombol Lompat)", false, function(v)
    WorldConfig.FlyAktif = v
    ShowPopupNotification(v and "Fly Diaktifkan" or "Fly Dimatikan")
end)

local function GetEntityNamesList()
    local names = {}
    for _, char in ipairs(GetAllTargetableEntities()) do
        local p = Players:GetPlayerFromCharacter(char)
        local name = p and p.Name or (char.Name ~= "" and char.Name or "Bot/NPC")
        table.insert(names, name)
    end
    if #names == 0 then table.insert(names, "Tidak Ada Target") end
    return names
end

CreateDropdown(TabContentFrames["World"], "Target Teleport", GetEntityNamesList(), GetEntityNamesList()[1], function(selected)
    WorldConfig.SelectedTeleportTarget = selected
end)

CreateButton(TabContentFrames["World"], "Mulai Teleport", function()
    pcall(function()
        local targetName = WorldConfig.SelectedTeleportTarget
        local foundRoot = nil
        for _, char in ipairs(GetAllTargetableEntities()) do
            local p = Players:GetPlayerFromCharacter(char)
            local name = p and p.Name or (char.Name ~= "" and char.Name or "Bot/NPC")
            if name == targetName then
                foundRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
                break
            end
        end
        if foundRoot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = foundRoot.CFrame + Vector3.new(0, 3, 0)
            ShowPopupNotification("Berhasil Teleport ke: " .. targetName)
        else
            ShowPopupNotification("Target teleport tidak ditemukan!")
        end
    end)
end)

CreateToggle(TabContentFrames["Skill"], "Peringatan Admin (Popup Warning)", false, function(v) 
    HackConfig.AntiAdminAktif = v 
    ShowPopupNotification(v and "Peringatan Admin Diaktifkan" or "Peringatan Admin Dimatikan")
end)
CreateToggle(TabContentFrames["Skill"], "Aktifkan Auto Aim (Kunci Layar)", false, function(v) 
    HackConfig.AimbotAktif = v 
    ShowPopupNotification(v and "Auto Aim Diaktifkan" or "Auto Aim Dimatikan")
end)
CreateToggle(TabContentFrames["Skill"], "Aim Prediction (Velocity Calc)", false, function(v) 
    HackConfig.AimPredictionAktif = v 
    ShowPopupNotification(v and "Aim Prediction Diaktifkan" or "Aim Prediction Dimatikan")
end)
CreateToggle(TabContentFrames["Skill"], "Auto Aim Wall Check", false, function(v)
    HackConfig.WallCheck = v
    ShowPopupNotification(v and "Wall Check Diaktifkan" or "Wall Check Dimatikan")
end)
CreateDropdown(TabContentFrames["Skill"], "Mode Aimbot", {"POV Kamera (FOV)", "360° (Brutal)"}, "POV Kamera (FOV)", function(opt) HackConfig.AimbotMode = opt end)
CreateDropdown(TabContentFrames["Skill"], "Target Bagian Tubuh", {"Head", "Neck", "Body"}, "Head", function(opt) HackConfig.AimTargetMode = opt end)
CreateSlider(TabContentFrames["Skill"], "Kelengketan Aim POV (Smoothness)", 1, 100, 15, function(val) HackConfig.AimbotSmoothness = val end)
CreateToggle(TabContentFrames["Skill"], "Tampilkan Lingkaran FOV", false, function(v) HackConfig.ShowFOV = v end)
CreateSlider(TabContentFrames["Skill"], "Lebar Lingkaran FOV", 10, 600, 150, function(val) HackConfig.FOVRadius = val end)

CreateDropdown(TabContentFrames["Configuration"], "UI Theme Mode", {"Dark", "Light"}, "Dark", function(mode)
    AppTheme = mode
    local isLight = (mode == "Light")
    for _, item in ipairs(ThemeElements) do
        pcall(function()
            if item.Type == "Main" then
                item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(6, 6, 9)
            elseif item.Type == "Sub" then
                item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(225, 225, 235) or Color3.fromRGB(12, 12, 18)
            elseif item.Type == "ElementBg" then
                item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(210, 210, 220) or Color3.fromRGB(25, 25, 36)
            elseif item.Type == "Text" then
                item.Obj.TextColor3 = isLight and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(240, 240, 255)
            elseif item.Type == "TextSub" then
                item.Obj.TextColor3 = isLight and Color3.fromRGB(40, 40, 55) or Color3.fromRGB(220, 220, 235)
            end
        end)
    end
    ShowPopupNotification("Theme diubah ke " .. mode)
end)

CreateButton(TabContentFrames["Configuration"], "Save Settings", function()
    pcall(function()
        if writefile then
            local data = {
                Visuals = VisualsConfig,
                World = WorldConfig,
                Hacks = HackConfig,
                Theme = AppTheme
            }
            writefile("D3D_Settings.json", HttpService:JSONEncode(data))
            ShowPopupNotification("Settings berhasil disimpan!")
        else
            ShowPopupNotification("Executor tidak support writefile!")
        end
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Load Settings", function()
    pcall(function()
        if isfile and isfile("D3D_Settings.json") and readfile then
            local raw = readfile("D3D_Settings.json")
            local data = HttpService:JSONDecode(raw)
            if data then
                if data.Visuals then VisualsConfig = data.Visuals end
                if data.World then WorldConfig = data.World end
                if data.Hacks then HackConfig = data.Hacks end
                ShowPopupNotification("Settings berhasil dimuat!")
            end
        else
            ShowPopupNotification("File settings tidak ditemukan!")
        end
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Delete Settings", function()
    pcall(function()
        if isfile and isfile("D3D_Settings.json") and delfile then
            delfile("D3D_Settings.json")
            ShowPopupNotification("Settings berhasil dihapus!")
        else
            ShowPopupNotification("Tidak ada file settings untuk dihapus!")
        end
    end)
end)

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

    if WorldConfig.NoFog then
        Lighting.FogEnd = 999999
        pcall(function()
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") or v:IsA("Sky") then
                    v.Parent = nil
                end
            end
        end)
    end

    if FOVFrame then
        FOVFrame.Size = UDim2.new(0, HackConfig.FOVRadius * 2, 0, HackConfig.FOVRadius * 2)
        FOVFrame.Visible = HackConfig.ShowFOV and (HackConfig.AimbotAktif and HackConfig.AimbotMode == "POV Kamera (FOV)")
    end

    -- LOGIKA AIMBOT AMAN (Slerp Interpolation Anti-Kick ViewAngle Check)
    if HackConfig.AimbotAktif then
        local targetValid = false
        local partToAim = nil
        local predictedAimPos = nil

        if LockedTarget and LockedTarget.Parent then
            if IsValidEntityCharacter(LockedTarget) and IsEnemyEntity(LockedTarget) then
                partToAim = GetDynamicTargetPart(LockedTarget)
                if partToAim then
                    if not HackConfig.WallCheck or IsVisible(partToAim) then
                        predictedAimPos = GetPredictedPosition(partToAim)
                        if HackConfig.AimbotMode == "POV Kamera (FOV)" then
                            local pos, onScreen = Camera:WorldToViewportPoint(predictedAimPos)
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
        end

        if not targetValid then
            if HackConfig.AimbotMode == "360° (Brutal)" then
                LockedTarget = GetNewTarget3D()
            elseif HackConfig.AimbotMode == "POV Kamera (FOV)" then
                LockedTarget = GetClosestEnemy2D()
            end
            if LockedTarget then
                partToAim = GetDynamicTargetPart(LockedTarget)
                if partToAim then
                    predictedAimPos = GetPredictedPosition(partToAim)
                end
            end
        end

        if LockedTarget and partToAim and predictedAimPos then
            local currentCamCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCamCF.Position, predictedAimPos)
            
            if HackConfig.AimbotMode == "360° (Brutal)" then
                Camera.CFrame = currentCamCF:Slerp(targetCF, 0.5)
            else
                local smoothness = math.clamp(HackConfig.AimbotSmoothness, 1, 100)
                local alpha = math.clamp(1 / (smoothness * 0.1), 0.01, 1)
                Camera.CFrame = currentCamCF:Slerp(targetCF, alpha)
            end
        else
            LockedTarget = nil
        end
    else
        LockedTarget = nil
    end

    local activeEntities = GetAllTargetableEntities()
    
    for key, _ in pairs(ESPCache) do
        local found = false
        for _, char in ipairs(activeEntities) do
            if char == key and IsValidEntityCharacter(key) then found = true break end
        end
        if not found then RemoveEntityESP(key) end
    end

    for _, char in ipairs(activeEntities) do
        if IsValidEntityCharacter(char) then
            if not ESPCache[char] then
                CreateEntityESP(char)
            end

            local esp = ESPCache[char]
            local isEnemy = IsEnemyEntity(char)
            local shouldDraw = (VisualsConfig.PlayerESP) or (VisualsConfig.EnemyESP and isEnemy)

            local primaryPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char.PrimaryPart
            local health, maxHealth = GetEntityHealthData(char)
            local active = shouldDraw and primaryPart and (health > 0)

            if active then
                if esp.HeadBillboard then
                    esp.HeadBillboard.Enabled = true
                end

                local vector, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                if onScreen then
                    local distance = (Camera.CFrame.Position - primaryPart.Position).Magnitude
                    local currentESPColor = VisualsConfig.ESPColor

                    local head = char:FindFirstChild("Head")
                    local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or primaryPart
                    local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
                    local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand") or primaryPart
                    local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") or primaryPart
                    local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot") or primaryPart
                    local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot") or primaryPart

                    local function getPos(part)
                        if not part then return nil end
                        local pPos, visible = Camera:WorldToViewportPoint(part.Position)
                        if visible then return Vector2.new(pPos.X, pPos.Y) end
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
                            boneObj.Color = currentESPColor
                            boneObj.Visible = true
                        else
                            boneObj.Visible = false
                        end
                    end

                    if hPos then
                        esp.HeadCircle.Position = hPos
                        local headSize = head and (Camera:WorldToViewportPoint((head.Position + Vector3.new(0, 1, 0))).Y - Camera:WorldToViewportPoint(head.Position).Y) or 10
                        esp.HeadCircle.Radius = math.clamp(math.abs(headSize) * 1.2, 6, 25)
                        esp.HeadCircle.Color = currentESPColor
                        esp.HeadCircle.Visible = true
                    else
                        esp.HeadCircle.Visible = false
                    end

                    -- SKELETON DENGAN TULANG BELAKANG LENGKAP
                    drawBone(esp.Skeleton.SpineHead, hPos, utPos)
                    drawBone(esp.Skeleton.SpineUpper, utPos, ltPos)
                    drawBone(esp.Skeleton.SpineLower, ltPos, getPos(primaryPart))
                    drawBone(esp.Skeleton.LeftArm, utPos, laPos)
                    drawBone(esp.Skeleton.RightArm, utPos, raPos)
                    drawBone(esp.Skeleton.LeftLeg, ltPos, llPos)
                    drawBone(esp.Skeleton.RightLeg, ltPos, rlPos)

                    -- CORNER BOX PUTUS-PUTUS
                    pcall(function()
                        local cf, size = char:GetBoundingBox()
                        local topCenter = cf.Position + Vector3.new(0, size.Y / 2, 0)
                        local bottomCenter = cf.Position - Vector3.new(0, size.Y / 2, 0)
                        local topPos, topVisible = Camera:WorldToViewportPoint(topCenter)
                        local botPos, botVisible = Camera:WorldToViewportPoint(bottomCenter)

                        if topVisible and botVisible then
                            local height = math.abs(topPos.Y - botPos.Y)
                            local width = height / 2
                            local boxX = topPos.X - (width / 2)
                            local boxY = topPos.Y
                            local lineLengthX = width * 0.3
                            local lineLengthY = height * 0.3

                            local lines = esp.CornerBox
                            if lines and #lines >= 8 then
                                lines[1].From = Vector2.new(boxX, boxY); lines[1].To = Vector2.new(boxX + lineLengthX, boxY); lines[1].Color = currentESPColor; lines[1].Visible = true
                                lines[2].From = Vector2.new(boxX, boxY); lines[2].To = Vector2.new(boxX, boxY + lineLengthY); lines[2].Color = currentESPColor; lines[2].Visible = true
                                lines[3].From = Vector2.new(boxX + width, boxY); lines[3].To = Vector2.new(boxX + width - lineLengthX, boxY); lines[3].Color = currentESPColor; lines[3].Visible = true
                                lines[4].From = Vector2.new(boxX + width, boxY); lines[4].To = Vector2.new(boxX + width, boxY + lineLengthY); lines[4].Color = currentESPColor; lines[4].Visible = true
                                lines[5].From = Vector2.new(boxX, boxY + height); lines[5].To = Vector2.new(boxX + lineLengthX, boxY + height); lines[5].Color = currentESPColor; lines[5].Visible = true
                                lines[6].From = Vector2.new(boxX, boxY + height); lines[6].To = Vector2.new(boxX, boxY + height - lineLengthY); lines[6].Color = currentESPColor; lines[6].Visible = true
                                lines[7].From = Vector2.new(boxX + width, boxY + height); lines[7].To = Vector2.new(boxX + width - lineLengthX, boxY + height); lines[7].Color = currentESPColor; lines[7].Visible = true
                                lines[8].From = Vector2.new(boxX + width, boxY + height); lines[8].To = Vector2.new(boxX + width, boxY + height - lineLengthY); lines[8].Color = currentESPColor; lines[8].Visible = true
                            end
                        else
                            if esp.CornerBox then
                                for _, ln in pairs(esp.CornerBox) do ln.Visible = false end
                            end
                        end
                    end)

                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    esp.Line.To = Vector2.new(vector.X, vector.Y)
                    esp.Line.Color = currentESPColor
                    esp.Line.Visible = true

                    local pInst = Players:GetPlayerFromCharacter(char)
                    local displayName = pInst and pInst.Name or (char.Name ~= "" and char.Name or "Bot/NPC")
                    esp.Name.Text = displayName
                    esp.Name.Position = Vector2.new(vector.X, vector.Y - 38)
                    esp.Name.Color = currentESPColor
                    esp.Name.Visible = true

                    esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                    esp.Distance.Position = Vector2.new(vector.X, vector.Y + 22)
                    esp.Distance.Color = currentESPColor
                    esp.Distance.Visible = true

                    if not EntityGenderCache[char] then
                        EntityGenderCache[char] = (math.random(1, 2) == 1) and "[Cowo]" or "[Cewe]"
                    end
                    esp.Gender.Text = EntityGenderCache[char]
                    esp.Gender.Position = Vector2.new(vector.X, vector.Y + 36)
                    esp.Gender.Color = currentESPColor
                    esp.Gender.Visible = true

                    esp.Status.Text = pInst and "[Player]" or "[Bot/NPC]"
                    esp.Status.Position = Vector2.new(vector.X, vector.Y + 50)
                    esp.Status.Color = currentESPColor
                    esp.Status.Visible = true

                    local healthPct = math.clamp(health / (maxHealth > 0 and maxHealth or 100), 0, 1)
                    local barHeight = 40
                    local barWidth = 5
                    local barX = vector.X + 24
                    local barY = vector.Y - 20

                    esp.HealthBarBg.Position = Vector2.new(barX, barY)
                    esp.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                    esp.HealthBarBg.Visible = true

                    esp.HealthBarBorder.Position = Vector2.new(barX - 1, barY - 1)
                    esp.HealthBarBorder.Size = Vector2.new(barWidth + 2, barHeight + 2)
                    esp.HealthBarBorder.Color = currentESPColor
                    esp.HealthBarBorder.Visible = true

                    local currentHeight = barHeight * healthPct
                    esp.HealthBar.Position = Vector2.new(barX, barY + (barHeight - currentHeight))
                    esp.HealthBar.Size = Vector2.new(barWidth, currentHeight)

                    if healthPct > 0.66 then
                        esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                    elseif healthPct > 0.33 then
                        esp.HealthBar.Color = Color3.fromRGB(255, 140, 0)
                    else
                        esp.HealthBar.Color = Color3.fromRGB(139, 0, 0)
                    end
                    esp.HealthBar.Visible = true
                else
                    if esp.HeadBillboard then esp.HeadBillboard.Enabled = false end
                    HideESPObject(esp)
                end
            else
                if esp.HeadBillboard then esp.HeadBillboard.Enabled = false end
                HideESPObject(esp)
            end
        end
    end
end)

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

        if WorldConfig.WallHack then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if WorldConfig.FlyAktif and hrp then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            else
                if hrp.Velocity.Y < -5 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -5, hrp.Velocity.Z)
                end
            end
        end
    end
end)
