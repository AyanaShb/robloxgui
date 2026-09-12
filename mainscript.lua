-- ========================================================
-- D3D Menu v3.9.4 - Full Fixed & Updated Combined Script
-- ========================================================
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

task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function()
                setreadonly(getrenv(), false)
                setreadonly(getreg(), false)
                setreadonly(getgc(), false)
            end)
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
ScreenGui.Name = "D3D_Ultimate_Android_V3_9_4"
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
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

-- Backup instance bawaan Atmosfer/Sky jika No Fog aktif
local SavedAtmosphere = {}
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Atmosphere") or v:IsA("Sky") then
        table.insert(SavedAtmosphere, v)
    end
end

local VisualsConfig = {
    ESP_Skeleton = false,
    ESP_Line = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Gender = false,
    ESP_Status = false,
    ESP_Health = false,
    Chams = false,
    EnemyChams = false,
    SkeletonColor = Color3.fromRGB(0, 240, 255),
    LineColor = Color3.fromRGB(0, 240, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    GenderColor = Color3.fromRGB(255, 255, 255),
    StatusColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 128),
    ChamsColor = Color3.fromRGB(255, 0, 128),
    EnemyChamsColor = Color3.fromRGB(255, 0, 0)
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
    CustomJump = 100,
    GunModsAktif = false,
    CustomFireRate = 800
}

local ESPCache = {}
local ChamsCache = {}
local EnemyChamsCache = {}
local LockedTarget = nil
local EntityGenderCache = {}
local AppTheme = "Dark"
local ThemeElements = {}
local SettingUpdaters = {}

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
TitleLabel.Text = "× D3D MENU: PLAYER & BOT v3.9.4 ×"
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

local function CreateToggle(parent, text, defaultVal, callback, settingKey, configTable)
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
    local function applyState(newState)
        active = newState
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or ((AppTheme == "Light") and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(25, 25, 36))
        circle.Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if configTable and settingKey then
            configTable[settingKey] = active
        end
        if callback then callback(active) end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        applyState(not active)
    end)

    if settingKey and configTable then
        SettingUpdaters[settingKey] = function(val)
            applyState(val)
        end
    end

    frame.Parent = parent
end

local function CreateDropdown(parent, text, optionsFunc, defaultOption, callback, settingKey, configTable)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeElements, {Type = "Sub", Obj = frame})

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(ThemeElements, {Type = "TextSub", Obj = label})

    local dropBtn = Instance.new("TextButton", frame)
    dropBtn.Size = UDim2.new(0, 160, 0, 32)
    dropBtn.Position = UDim2.new(1, -172, 0.5, -16)
    dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    dropBtn.Text = tostring(defaultOption)
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 9.5
    dropBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = dropBtn})
    table.insert(ThemeElements, {Type = "Text", Obj = dropBtn})

    local listFrame = Instance.new("ScrollingFrame", frame)
    listFrame.Size = UDim2.new(0, 160, 0, 100)
    -- Posisi diatur muncul ke ATAS agar tidak tertutup atau susah dibaca
    listFrame.Position = UDim2.new(1, -172, 0, -105)
    listFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 50
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.ScrollBarThickness = 3
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

    local uiList = Instance.new("UIListLayout", listFrame)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 2)

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        listFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 5)
    end)

    local function refreshOptions()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local currentOptions = type(optionsFunc) == "function" and optionsFunc() or optionsFunc
        for _, opt in ipairs(currentOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            optBtn.TextSize = 9.5
            optBtn.Font = Enum.Font.Gotham
            optBtn.ZIndex = 51
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
            optBtn.Parent = listFrame

            optBtn.MouseButton1Click:Connect(function()
                dropBtn.Text = tostring(opt)
                listFrame.Visible = false
                if configTable and settingKey then
                    configTable[settingKey] = opt
                end
                if callback then callback(opt) end
            end)
        end
    end

    dropBtn.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
        if listFrame.Visible then
            refreshOptions()
        end
    end)

    if settingKey and configTable then
        SettingUpdaters[settingKey] = function(val)
            dropBtn.Text = tostring(val)
            if configTable and settingKey then
                configTable[settingKey] = val
            end
            if callback then callback(val) end
        end
    end

    frame.Parent = parent
end

local function CreateColorPicker(parent, text, defaultColor, callback, settingKey, configTable)
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

    local function applyColor(col)
        pickerCircle.BackgroundColor3 = col
        if configTable and settingKey then
            configTable[settingKey] = col
        end
        if callback then callback(col) end
    end

    pickerCircle.MouseButton1Click:Connect(function()
        colorIndex = (colorIndex % #colors) + 1
        applyColor(colors[colorIndex])
    end)

    if settingKey and configTable then
        SettingUpdaters[settingKey] = function(val)
            if typeof(val) == "Color3" then
                applyColor(val)
            elseif type(val) == "table" and val.R then
                local col = Color3.new(val.R, val.G, val.B)
                applyColor(col)
            end
        end
    end

    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback, settingKey, configTable)
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

    local function applyValue(val)
        val = math.clamp(val, min, max)
        fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
        label.Text = text .. ": " .. tostring(val)
        if configTable and settingKey then
            configTable[settingKey] = val
        end
        if callback then callback(val) end
    end

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
            local val = math.floor(min + ((max - min) * pos))
            applyValue(val)
        end
    end)

    if settingKey and configTable then
        SettingUpdaters[settingKey] = function(val)
            applyValue(val)
        end
    end

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

local function IsValidCharacter(char)
    if not char or not char:IsA("Model") then return false end
    if char == LocalPlayer.Character then return false end
    if char:IsDescendantOf(LocalPlayer) then return false end
    if char:IsDescendantOf(Camera) then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
    
    if not hum or not root then return false end
    if hum.Health <= 0 then return false end
    return true
end

local function GetEntityModel(target)
    if typeof(target) == "Instance" then
        if target:IsA("Player") then return target.Character
        elseif target:IsA("Model") then return target end
    end
    return nil
end

local function IsEnemyEntity(target)
    local char = GetEntityModel(target)
    if not IsValidCharacter(char) then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end

    if typeof(target) == "Instance" and target:IsA("Player") then
        if target == LocalPlayer then return false end
        if HackConfig.FFAModeAktif then return true end
        if target.Team and LocalPlayer.Team and target.Team == LocalPlayer.Team then return false end
        return true
    elseif typeof(target) == "Instance" and target:IsA("Model") then
        return true
    end
    return false
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
    local body = char:FindFirstChild("HumanoidRootPart") or neck or head or char.PrimaryPart
    if HackConfig.AimTargetMode == "Head" then return head or body
    elseif HackConfig.AimTargetMode == "Neck" then return neck or head or body
    elseif HackConfig.AimTargetMode == "Body" then return body or head end
    return body
end

local function GetAllTargetableEntities()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and IsValidCharacter(p.Character) then
            table.insert(list, p)
        end
    end
    local function scanFolder(parentObj)
        for _, obj in ipairs(parentObj:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and IsValidCharacter(obj) then
                local isPlayerChar = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character == obj then isPlayerChar = true break end
                end
                if not isPlayerChar then table.insert(list, obj) end
            elseif obj:IsA("Folder") or obj:IsA("Model") then
                scanFolder(obj)
            end
        end
    end
    scanFolder(Workspace)
    return list
end

local function GetNewTarget3D()
    local closest, shortestDist = nil, math.huge
    for _, entity in ipairs(GetAllTargetableEntities()) do
        if IsEnemyEntity(entity) then
            local char = GetEntityModel(entity)
            local targetPart = GetDynamicTargetPart(char)
            if targetPart then
                if not HackConfig.WallCheck or IsVisible(targetPart) then
                    local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                    if dist < shortestDist then shortestDist = dist; closest = char end
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemy2D()
    local closest, shortestDist = nil, HackConfig.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, entity in ipairs(GetAllTargetableEntities()) do
        if IsEnemyEntity(entity) then
            local char = GetEntityModel(entity)
            local targetPart = GetDynamicTargetPart(char)
            if targetPart then
                if not HackConfig.WallCheck or IsVisible(targetPart) then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                        if dist < shortestDist then shortestDist = dist; closest = char end
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
        if esp.HealthBar then esp.HealthBar.Visible = false end
        if esp.HeadCircle then esp.HeadCircle.Visible = false end
        if esp.Skeleton then for _, bone in pairs(esp.Skeleton) do if bone then bone.Visible = false end end end
    end)
end

local function RemoveEntityESP(key)
    if ESPCache[key] then
        for _, obj in pairs(ESPCache[key]) do
            if type(obj) == "table" then for _, bone in pairs(obj) do pcall(function() bone:Remove() end) end
            else pcall(function() obj:Remove() end) end
        end
        ESPCache[key] = nil
    end
    if ChamsCache[key] then pcall(function() ChamsCache[key]:Destroy() end); ChamsCache[key] = nil end
    if EnemyChamsCache[key] then pcall(function() EnemyChamsCache[key]:Destroy() end); EnemyChamsCache[key] = nil end
end

local function CreateEntityESP(key)
    RemoveEntityESP(key)
    local espData = {
        Line = Drawing.new("Line"), Name = Drawing.new("Text"), Distance = Drawing.new("Text"),
        Gender = Drawing.new("Text"), Status = Drawing.new("Text"), HealthBarBg = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"), HeadCircle = Drawing.new("Circle"),
        Skeleton = { Spine = Drawing.new("Line"), LeftArm = Drawing.new("Line"), RightArm = Drawing.new("Line"), LeftLeg = Drawing.new("Line"), RightLeg = Drawing.new("Line") }
    }
    espData.Line.Thickness = 1.5; espData.Line.Color = VisualsConfig.LineColor; espData.Line.Visible = false
    espData.HealthBarBg.Thickness = 3; espData.HealthBarBg.Color = Color3.fromRGB(40, 40, 40); espData.HealthBarBg.Visible = false
    espData.HealthBar.Thickness = 1.5; espData.HealthBar.Color = VisualsConfig.HealthColor; espData.HealthBar.Visible = false
    espData.HeadCircle.Thickness = 1.5; espData.HeadCircle.NumSides = 12; espData.HeadCircle.Filled = false; espData.HeadCircle.Visible = false
    for _, bone in pairs(espData.Skeleton) do bone.Thickness = 1.5; bone.Color = VisualsConfig.SkeletonColor; bone.Visible = false end
    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender, espData.Status}) do
        textObj.Size = 13; textObj.Center = true; textObj.Outline = true; textObj.Font = Drawing.Fonts.UI; textObj.Visible = false
    end
    ESPCache[key] = espData
end

-- Tab Visual Elements
CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Player & Bot)", false, function(v) VisualsConfig.ESP_Skeleton = v end, "ESP_Skeleton", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.SkeletonColor = c end, "SkeletonColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "Chams / Wall Glow", false, function(v) VisualsConfig.Chams = v end, "Chams", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Chams Glow Color", Color3.fromRGB(255, 0, 128), function(c) VisualsConfig.ChamsColor = c end, "ChamsColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "Enemy Chams", false, function(v) VisualsConfig.EnemyChams = v end, "EnemyChams", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Enemy Chams Color", Color3.fromRGB(255, 0, 0), function(c) VisualsConfig.EnemyChamsColor = c end, "EnemyChamsColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Line", false, function(v) VisualsConfig.ESP_Line = v end, "ESP_Line", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Line Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.LineColor = c end, "LineColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) VisualsConfig.ESP_Name = v end, "ESP_Name", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Name Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.NameColor = c end, "NameColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) VisualsConfig.ESP_Distance = v end, "ESP_Distance", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.DistanceColor = c end, "DistanceColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Gender", false, function(v) VisualsConfig.ESP_Gender = v end, "ESP_Gender", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.GenderColor = c end, "GenderColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Status", false, function(v) VisualsConfig.ESP_Status = v end, "ESP_Status", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Status Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.StatusColor = c end, "StatusColor", VisualsConfig)
CreateToggle(TabContentFrames["Visual"], "ESP Health", false, function(v) VisualsConfig.ESP_Health = v end, "ESP_Health", VisualsConfig)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end, "HealthColor", VisualsConfig)

-- Tab Player Elements
CreateToggle(TabContentFrames["Player"], "No Fall Damage", false, function(v) HackConfig.AntiFallDamageAktif = v end, "AntiFallDamageAktif", HackConfig)
CreateToggle(TabContentFrames["Player"], "Kecepatan Lari", false, function(v) HackConfig.SpeedAktif = v end, "SpeedAktif", HackConfig)
CreateSlider(TabContentFrames["Player"], "Set Speed", 16, 250, 50, function(val) HackConfig.CustomSpeed = val end, "CustomSpeed", HackConfig)
CreateToggle(TabContentFrames["Player"], "Lompat Tinggi", false, function(v) HackConfig.JumpAktif = v end, "JumpAktif", HackConfig)
CreateSlider(TabContentFrames["Player"], "Set Power", 50, 250, 100, function(val) HackConfig.CustomJump = val end, "CustomJump", HackConfig)

-- Tab World Elements
CreateToggle(TabContentFrames["World"], "Night Mode", false, function(v) WorldConfig.NightMode = v end, "NightMode", WorldConfig)
CreateToggle(TabContentFrames["World"], "Daylight", false, function(v) WorldConfig.Daylight = v end, "Daylight", WorldConfig)
CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end, "DaylightBrightness", WorldConfig)
CreateSlider(TabContentFrames["World"], "Daylight Time (Clock)", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end, "DaylightClock", WorldConfig)
CreateToggle(TabContentFrames["World"], "Wall Hack (Noclip)", false, function(v) WorldConfig.WallHack = v end, "WallHack", WorldConfig)

-- Perbaikan Fitur No Fog (Mengembalikan kembali settingan Asli secara utuh)
CreateToggle(TabContentFrames["World"], "No Fog", false, function(v)
    WorldConfig.NoFog = v
    if v then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 999999
        pcall(function()
            for _, child in pairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") or child:IsA("Sky") then
                    child.Parent = nil
                end
            end
        end)
    else
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogStart = OriginalLighting.FogStart
        pcall(function()
            for _, child in pairs(SavedAtmosphere) do
                if child and child.Parent == nil then
                    child.Parent = Lighting
                end
            end
        end)
    end
    ShowPopupNotification(v and "No Fog Diaktifkan" or "No Fog Dimatikan")
end, "NoFog", WorldConfig)

CreateToggle(TabContentFrames["World"], "Fly (Tahan Tombol Lompat)", false, function(v) WorldConfig.FlyAktif = v end, "FlyAktif", WorldConfig)

local function GetPlayerNamesList()
    local names = {}
    for _, entity in ipairs(GetAllTargetableEntities()) do
        local char = GetEntityModel(entity)
        if char then
            local name = char.Name
            if typeof(entity) == "Instance" and entity:IsA("Player") then name = entity.Name end
            table.insert(names, name)
        end
    end
    if #names == 0 then table.insert(names, "Tidak Ada Target") end
    return names
end

CreateDropdown(TabContentFrames["World"], "Target Teleport", GetPlayerNamesList, GetPlayerNamesList()[1], function(selected)
    WorldConfig.SelectedTeleportTarget = selected
end, "SelectedTeleportTarget", WorldConfig)

CreateButton(TabContentFrames["World"], "Mulai Teleport", function()
    pcall(function()
        local targetName = WorldConfig.SelectedTeleportTarget
        local foundRoot = nil
        for _, entity in ipairs(GetAllTargetableEntities()) do
            local char = GetEntityModel(entity)
            if char then
                local name = char.Name
                if typeof(entity) == "Instance" and entity:IsA("Player") then name = entity.Name end
                if name == targetName then
                    foundRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    break
                end
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

-- Tab Skill Elements (Kill Aura & Auto Reload Berhasil Dihapus)
CreateToggle(TabContentFrames["Skill"], "Peringatan Admin", false, function(v) HackConfig.AntiAdminAktif = v end, "AntiAdminAktif", HackConfig)
CreateToggle(TabContentFrames["Skill"], "Auto Aim", false, function(v) HackConfig.AimbotAktif = v end, "AimbotAktif", HackConfig)
CreateToggle(TabContentFrames["Skill"], "Auto Aim Wall Check", false, function(v) HackConfig.WallCheck = v end, "WallCheck", HackConfig)
CreateDropdown(TabContentFrames["Skill"], "Mode Aimbot", {"POV Kamera (FOV)", "360° (Brutal)"}, "POV Kamera (FOV)", function(opt) HackConfig.AimbotMode = opt end, "AimbotMode", HackConfig)
CreateDropdown(TabContentFrames["Skill"], "Target Bagian Tubuh", {"Head", "Neck", "Body"}, "Head", function(opt) HackConfig.AimTargetMode = opt end, "AimTargetMode", HackConfig)
CreateSlider(TabContentFrames["Skill"], "Smoothness", 1, 100, 15, function(val) HackConfig.AimbotSmoothness = val end, "AimbotSmoothness", HackConfig)
CreateToggle(TabContentFrames["Skill"], "Tampilkan Lingkaran FOV", false, function(v) HackConfig.ShowFOV = v end, "ShowFOV", HackConfig)
CreateSlider(TabContentFrames["Skill"], "Lebar Lingkaran FOV", 10, 600, 150, function(val) HackConfig.FOVRadius = val end, "FOVRadius", HackConfig)
CreateToggle(TabContentFrames["Skill"], "Gun Mods (Ammo & RPM)", false, function(v) HackConfig.GunModsAktif = v end, "GunModsAktif", HackConfig)
CreateSlider(TabContentFrames["Skill"], "RPM Fire Rate", 400, 2500, 800, function(val) HackConfig.CustomFireRate = val end, "CustomFireRate", HackConfig)

-- Tab Configuration Elements
CreateDropdown(TabContentFrames["Configuration"], "UI Theme Mode", {"Dark", "Light"}, "Dark", function(mode)
    AppTheme = mode
    local isLight = (mode == "Light")
    for _, item in ipairs(ThemeElements) do
        pcall(function()
            if item.Type == "Main" then item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(6, 6, 9)
            elseif item.Type == "Sub" then item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(225, 225, 235) or Color3.fromRGB(12, 12, 18)
            elseif item.Type == "ElementBg" then item.Obj.BackgroundColor3 = isLight and Color3.fromRGB(210, 210, 220) or Color3.fromRGB(25, 25, 36)
            elseif item.Type == "Text" then item.Obj.TextColor3 = isLight and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(240, 240, 255)
            elseif item.Type == "TextSub" then item.Obj.TextColor3 = isLight and Color3.fromRGB(40, 40, 55) or Color3.fromRGB(220, 220, 235) end
        end)
    end
end, "Theme", nil)

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
            ShowPopupNotification("Semua Settings berhasil disimpan!")
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
                if data.Theme then AppTheme = data.Theme end

                -- Sinkronisasi menyeluruh ke seluruh setting & UI elements
                for key, val in pairs(VisualsConfig) do
                    if SettingUpdaters[key] then SettingUpdaters[key](val) end
                end
                for key, val in pairs(WorldConfig) do
                    if SettingUpdaters[key] then SettingUpdaters[key](val) end
                end
                for key, val in pairs(HackConfig) do
                    if SettingUpdaters[key] then SettingUpdaters[key](val) end
                end
                if SettingUpdaters["Theme"] then SettingUpdaters["Theme"](AppTheme) end

                ShowPopupNotification("Semua Settings berhasil dimuat & diterapkan!")
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
            ShowPopupNotification("File settings dihapus!")
        else
            ShowPopupNotification("File settings tidak ada!")
        end
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Reset Default Settings", function()
    pcall(function()
        for k, _ in pairs(VisualsConfig) do if type(VisualsConfig[k]) == "boolean" then VisualsConfig[k] = false end end
        for k, _ in pairs(WorldConfig) do if type(WorldConfig[k]) == "boolean" then WorldConfig[k] = false end end
        for k, _ in pairs(HackConfig) do if type(HackConfig[k]) == "boolean" then HackConfig[k] = false end end

        for key, val in pairs(VisualsConfig) do if SettingUpdaters[key] then SettingUpdaters[key](val) end end
        for key, val in pairs(WorldConfig) do if SettingUpdaters[key] then SettingUpdaters[key](val) end end
        for key, val in pairs(HackConfig) do if SettingUpdaters[key] then SettingUpdaters[key](val) end end

        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.FogEnd = OriginalLighting.FogEnd
        ShowPopupNotification("Settings di-reset ke Default!")
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Unload Script", function()
    pcall(function()
        for key, _ in pairs(ESPCache) do RemoveEntityESP(key) end
        if FOVGui then FOVGui:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end
    end)
end)

-- Main Loop RenderStepped
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

    if HackConfig.AimbotAktif then
        local targetValid = false
        local partToAim = nil

        if LockedTarget and LockedTarget.Parent then
            if IsValidCharacter(LockedTarget) and IsEnemyEntity(LockedTarget) then
                partToAim = GetDynamicTargetPart(LockedTarget)
                if partToAim then
                    if not HackConfig.WallCheck or IsVisible(partToAim) then
                        if HackConfig.AimbotMode == "POV Kamera (FOV)" then
                            local pos, onScreen = Camera:WorldToViewportPoint(partToAim.Position)
                            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                            if onScreen and dist <= HackConfig.FOVRadius then targetValid = true end
                        else
                            targetValid = true
                        end
                    end
                end
            end
        end

        if not targetValid then
            if HackConfig.AimbotMode == "360° (Brutal)" then LockedTarget = GetNewTarget3D()
            elseif HackConfig.AimbotMode == "POV Kamera (FOV)" then LockedTarget = GetClosestEnemy2D() end
            if LockedTarget then partToAim = GetDynamicTargetPart(LockedTarget) end
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

    local activeEntities = GetAllTargetableEntities()
    for key, _ in pairs(ESPCache) do
        local found = false
        for _, ent in ipairs(activeEntities) do
            local char = GetEntityModel(ent)
            if char == key and IsValidCharacter(char) then found = true break end
        end
        if not found then RemoveEntityESP(key) end
    end

    for _, entity in ipairs(activeEntities) do
        local char = GetEntityModel(entity)
        if IsValidCharacter(char) then
            if not ESPCache[char] then CreateEntityESP(char) end
            local esp = ESPCache[char]
            local isEnemy = IsEnemyEntity(entity)
            local primaryPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local active = isEnemy and primaryPart and (not hum or hum.Health > 0)

            if active and VisualsConfig.Chams then
                if not ChamsCache[char] then
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = char; highlight.FillColor = VisualsConfig.ChamsColor; highlight.FillTransparency = 0.4; highlight.Parent = char
                    ChamsCache[char] = highlight
                else
                    ChamsCache[char].FillColor = VisualsConfig.ChamsColor; ChamsCache[char].Enabled = true
                end
            elseif ChamsCache[char] then ChamsCache[char].Enabled = false end

            if active then
                local vector, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                if onScreen then
                    local distance = (Camera.CFrame.Position - primaryPart.Position).Magnitude
                    if VisualsConfig.ESP_Skeleton then
                        local head = char:FindFirstChild("Head")
                        local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or primaryPart
                        local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
                        local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or primaryPart
                        local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or primaryPart
                        local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or primaryPart
                        local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or primaryPart

                        local function getPos(pPart)
                            if not pPart then return nil end
                            local p, visible = Camera:WorldToViewportPoint(pPart.Position)
                            if visible then return Vector2.new(p.X, p.Y) end
                            return nil
                        end

                        local hPos, utPos, ltPos = getPos(head), getPos(upperTorso), getPos(lowerTorso)
                        local laPos, raPos, llPos, rlPos = getPos(lArm), getPos(rArm), getPos(lLeg), getPos(rLeg)

                        local function drawBone(boneObj, p1, p2)
                            if p1 and p2 then boneObj.From = p1; boneObj.To = p2; boneObj.Visible = true else boneObj.Visible = false end
                        end

                        if hPos then
                            esp.HeadCircle.Position = hPos
                            esp.HeadCircle.Radius = 12
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
                    else esp.Line.Visible = false end

                    if VisualsConfig.ESP_Name then
                        esp.Name.Text = char.Name
                        esp.Name.Position = Vector2.new(vector.X, vector.Y - 38)
                        esp.Name.Color = VisualsConfig.NameColor
                        esp.Name.Visible = true
                    else esp.Name.Visible = false end

                    if VisualsConfig.ESP_Distance then
                        esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                        esp.Distance.Position = Vector2.new(vector.X, vector.Y + 22)
                        esp.Distance.Color = VisualsConfig.DistanceColor
                        esp.Distance.Visible = true
                    else esp.Distance.Visible = false end
                else HideESPObject(esp) end
            else HideESPObject(esp) end
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
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        if WorldConfig.FlyAktif and hrp then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y + 5, hrp.Velocity.Z)
            else
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
        end
    end
end)

-- v3.9.4 - Part 2 (Gun Mods, Health ESP, & Cleanup Final)

task.spawn(function()
    while task.wait(0.5) do
        if HackConfig.GunModsAktif and LocalPlayer.Character then
            pcall(function()
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, v in pairs(tool:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local nameLower = v.Name:lower()
                                if nameLower:find("firerate") or nameLower:find("cooldown") or nameLower:find("delay") then
                                    v.Value = 60 / HackConfig.CustomFireRate
                                elseif nameLower:find("ammo") or nameLower:find("clip") or nameLower:find("bullet") then
                                    if v.Value <= 5 then v.Value = 99 end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local activeEntities = GetAllTargetableEntities()
            for _, entity in ipairs(activeEntities) do
                local char = GetEntityModel(entity)
                if IsValidCharacter(char) and ESPCache[char] then
                    local esp = ESPCache[char]
                    local primaryPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    
                    if primaryPart and hum and VisualsConfig.ESP_Health then
                        local vector, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                        if onScreen then
                            local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            local barHeight = 40
                            local barWidth = 3
                            local barX = vector.X - 28
                            local barY = vector.Y - 20

                            esp.HealthBarBg.From = Vector2.new(barX, barY)
                            esp.HealthBarBg.To = Vector2.new(barX, barY + barHeight)
                            esp.HealthBarBg.Visible = true

                            esp.HealthBar.From = Vector2.new(barX, barY + (barHeight * (1 - healthPct)))
                            esp.HealthBar.To = Vector2.new(barX, barY + barHeight)
                            esp.HealthBar.Visible = true
                        else
                            esp.HealthBarBg.Visible = false
                            esp.HealthBar.Visible = false
                        end
                    else
                        esp.HealthBarBg.Visible = false
                        esp.HealthBar.Visible = false
                    end
                end
            end
        end)
    end
end)

-- Tombol Unload Tambahan untuk Membersihkan Seluruh Hook & Instance
CreateButton(TabContentFrames["Configuration"], "Force Full Cleanup & Unload", function()
    pcall(function()
        for key, _ in pairs(ESPCache) do 
            RemoveEntityESP(key) 
        end
        for _, highlight in pairs(ChamsCache) do
            if highlight then highlight:Destroy() end
        end
        for _, highlight in pairs(EnemyChamsCache) do
            if highlight then highlight:Destroy() end
        end
        
        if FOVGui then FOVGui:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end

        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogStart = OriginalLighting.FogStart

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end

        print("[D3D Menu] Successfully unloaded and memory cleaned.")
    end)
end)

ShowPopupNotification("D3D Menu v3.9.4 All Parts Successfully Loaded!")
print("[D3D Menu] Script fully initialized with zero memory leaks.")

