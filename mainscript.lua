-- v3.9.4 - Part 1
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
        if make_writeable then
            pcall(function() make_writeable(getreg()) end)
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
    FogEnd = Lighting.FogEnd
}

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
local UIStateCallbacks = {}

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

local function CreateToggle(parent, text, defaultVal, callback, saveKey)
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
    local function updateState(newState)
        active = newState
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or ((AppTheme == "Light") and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(25, 25, 36))
        circle.Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if callback then callback(active) end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        updateState(not active)
    end)

    if saveKey then
        UIStateCallbacks[saveKey] = updateState
    end

    frame.Parent = parent
end

local function CreateDropdown(parent, text, optionsFunc, defaultOption, callback, dropdownRefOut)
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
    dropBtn.Text = defaultOption
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 9.5
    dropBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
    table.insert(ThemeElements, {Type = "ElementBg", Obj = dropBtn})
    table.insert(ThemeElements, {Type = "Text", Obj = dropBtn})

    local listFrame = Instance.new("ScrollingFrame", ScreenGui)
    listFrame.Size = UDim2.new(0, 160, 0, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 2000
    listFrame.ScrollBarThickness = 2
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
    local strokeList = Instance.new("UIStroke", listFrame)
    strokeList.Color = Color3.fromRGB(0, 240, 255)
    strokeList.Thickness = 1

    local uiList = Instance.new("UIListLayout", listFrame)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder

    local isOpen = false
    local function closeList()
        isOpen = false
        listFrame.Visible = false
    end

    local function refreshOptions()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local opts = type(optionsFunc) == "function" and optionsFunc() or optionsFunc
        if #opts == 0 then opts = {"Tidak Ada Target"} end

        for _, opt in ipairs(opts) do
            local optBtn = Instance.new("TextButton", listFrame)
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            optBtn.TextSize = 9.5
            optBtn.Font = Enum.Font.Gotham
            optBtn.Text = tostring(opt)
            optBtn.ZIndex = 2001

            optBtn.MouseButton1Click:Connect(function()
                dropBtn.Text = tostring(opt)
                closeList()
                if callback then callback(tostring(opt)) end
            end)
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, #opts * 28)
    end

    dropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            refreshOptions()
            local absPos = dropBtn.AbsolutePosition
            listFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + dropBtn.AbsoluteSize.Y + 4)
            local opts = type(optionsFunc) == "function" and optionsFunc() or optionsFunc
            listFrame.Size = UDim2.new(0, 160, 0, math.clamp(#opts * 28, 28, 140))
            listFrame.Visible = true
        else
            listFrame.Visible = false
        end
    end)

    if dropdownRefOut then
        dropdownRefOut.SetText = function(txt)
            dropBtn.Text = txt
        end
    end

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

local function IsValidCharacter(char)
    if not char or not char:IsA("Model") then return false end
    if char == LocalPlayer.Character then return false end
    if char:IsDescendantOf(LocalPlayer) then return false end
    if char:IsDescendantOf(Camera) then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
    
    if not hum or not root then return false end
    if hum.Health <= 0 then return false end
    if char:IsA("Tool") or char:FindFirstChildOfClass("Tool") then return false end

    return true
end

local function GetEntityModel(target)
    if typeof(target) == "Instance" then
        if target:IsA("Player") then
            return target.Character
        elseif target:IsA("Model") then
            return target
        end
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
        if target.Team and LocalPlayer.Team then
            if target.Team == LocalPlayer.Team then return false end
        end
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
    for _, entity in ipairs(GetAllTargetableEntities()) do
        if IsEnemyEntity(entity) then
            local char = GetEntityModel(entity)
            local targetPart = GetDynamicTargetPart(char)
            if targetPart then
                if not HackConfig.WallCheck or IsVisible(targetPart) then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
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
        if esp.HealthBar then esp.HealthBar.Visible = false end
        if esp.HeadCircle then esp.HeadCircle.Visible = false end
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
                for _, bone in pairs(obj) do pcall(function() bone:Remove() end) end
            else
                pcall(function() obj:Remove() end)
            end
        end
        ESPCache[key] = nil
    end
    if ChamsCache[key] then
        pcall(function() ChamsCache[key]:Destroy() end)
        ChamsCache[key] = nil
    end
    if EnemyChamsCache[key] then
        pcall(function() EnemyChamsCache[key]:Destroy() end)
        EnemyChamsCache[key] = nil
    end
end

local function CreateEntityESP(key)
    RemoveEntityESP(key)
    local espData = {
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Gender = Drawing.new("Text"),
        Status = Drawing.new("Text"),
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

CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Player & Bot)", false, function(v) 
    VisualsConfig.ESP_Skeleton = v 
    if not v then
        for _, esp in pairs(ESPCache) do
            if esp.HeadCircle then esp.HeadCircle.Visible = false end
            if esp.Skeleton then for _, b in pairs(esp.Skeleton) do b.Visible = false end end
        end
    end
end, "ESP_Skeleton")
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.SkeletonColor = c end)
CreateToggle(TabContentFrames["Visual"], "Chams / Wall Glow", false, function(v) VisualsConfig.Chams = v end, "Chams")
CreateColorPicker(TabContentFrames["Visual"], "Chams Glow Color", Color3.fromRGB(255, 0, 128), function(c) VisualsConfig.ChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "Enemy Chams", false, function(v) VisualsConfig.EnemyChams = v end, "EnemyChams")
CreateColorPicker(TabContentFrames["Visual"], "Enemy Chams Color", Color3.fromRGB(255, 0, 0), function(c) VisualsConfig.EnemyChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", false, function(v) 
    VisualsConfig.ESP_Line = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Line then esp.Line.Visible = false end end end
end, "ESP_Line")
CreateColorPicker(TabContentFrames["Visual"], "Line Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.LineColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) 
    VisualsConfig.ESP_Name = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Name then esp.Name.Visible = false end end end
end, "ESP_Name")
CreateColorPicker(TabContentFrames["Visual"], "Name Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.NameColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) 
    VisualsConfig.ESP_Distance = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Distance then esp.Distance.Visible = false end end end
end, "ESP_Distance")
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.DistanceColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender (Cowo/Cewe/Gay)", false, function(v) 
    VisualsConfig.ESP_Gender = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Gender then esp.Gender.Visible = false end end end
end, "ESP_Gender")
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.GenderColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Status (Bot/Player)", false, function(v) 
    VisualsConfig.ESP_Status = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.Status then esp.Status.Visible = false end end end
end, "ESP_Status")
CreateColorPicker(TabContentFrames["Visual"], "Status Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.StatusColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Health (Vertical Bar)", false, function(v) 
    VisualsConfig.ESP_Health = v 
    if not v then for _, esp in pairs(ESPCache) do if esp.HealthBarBg then esp.HealthBarBg.Visible = false end if esp.HealthBar then esp.HealthBar.Visible = false end end end
end, "ESP_Health")
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end)

CreateToggle(TabContentFrames["Player"], "No Fall Damage", false, function(v) 
    HackConfig.AntiFallDamageAktif = v 
    ShowPopupNotification(v and "No Fall Damage Diaktifkan" or "No Fall Damage Dimatikan")
end, "AntiFallDamageAktif")
CreateToggle(TabContentFrames["Player"], "Kecepatan Lari", false, function(v) 
    HackConfig.SpeedAktif = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    ShowPopupNotification(v and "Kecepatan Lari Diaktifkan" or "Kecepatan Lari Dimatikan")
end, "SpeedAktif")
CreateSlider(TabContentFrames["Player"], "Set Speed", 16, 250, 50, function(val) HackConfig.CustomSpeed = val end)
CreateToggle(TabContentFrames["Player"], "Lompat Tinggi", false, function(v) 
    HackConfig.JumpAktif = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    ShowPopupNotification(v and "Lompat Tinggi Diaktifkan" or "Lompat Tinggi Dimatikan")
end, "JumpAktif")
CreateSlider(TabContentFrames["Player"], "Set Power", 50, 250, 100, function(val) HackConfig.CustomJump = val end)
-- v3.9.4 - Part 2 (Continuation)
CreateToggle(TabContentFrames["Player"], "Fly (Terbang Terus & Naik jika Jump Ditahan)", false, function(v)
    WorldConfig.FlyAktif = v
    ShowPopupNotification(v and "Fly Diaktifkan" or "Fly Dimatikan")
end, "FlyAktif")

local teleportDropdownRef = {}
CreateDropdown(TabContentFrames["Player"], "Teleport Target", function()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    for _, obj in ipairs(GetAllTargetableEntities()) do
        local char = GetEntityModel(obj)
        if char then
            local isP = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character == char then isP = true break end
            end
            if not isP then
                table.insert(names, char.Name .. " [Bot]")
            end
        end
    end
    if #names == 0 then table.insert(names, "Tidak Ada Target") end
    return names
end, "Pilih Target", function(selected)
    WorldConfig.SelectedTeleportTarget = selected
end, teleportDropdownRef)

CreateButton(TabContentFrames["Player"], "Teleport ke Target Dipilih", function()
    local targetName = WorldConfig.SelectedTeleportTarget
    if not targetName or targetName == "" or targetName == "Pilih Target" or targetName == "Tidak Ada Target" then
        ShowPopupNotification("Pilih target teleport terlebih dahulu!")
        return
    end

    local foundRoot = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == targetName and p.Character then
            foundRoot = p.Character:FindFirstChild("HumanoidRootPart")
            break
        end
    end

    if not foundRoot then
        for _, obj in ipairs(GetAllTargetableEntities()) do
            local char = GetEntityModel(obj)
            if char and (char.Name .. " [Bot]" == targetName or char.Name == targetName) then
                foundRoot = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                break
            end
        end
    end

    if foundRoot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = foundRoot.CFrame + Vector3.new(0, 3, 0)
        ShowPopupNotification("Berhasil teleport ke: " .. targetName)
    else
        ShowPopupNotification("Target tidak ditemukan di dunia!")
    end
end)

CreateToggle(TabContentFrames["Skill"], "Aimbot Aktif", false, function(v) 
    HackConfig.AimbotAktif = v 
    ShowPopupNotification(v and "Aimbot Diaktifkan" or "Aimbot Dimatikan")
end, "AimbotAktif")
CreateDropdown(TabContentFrames["Skill"], "Aimbot Mode", {"POV Kamera (FOV)", "Lock 3D Otomatis"}, "POV Kamera (FOV)", function(v) HackConfig.AimbotMode = v end)
CreateDropdown(TabContentFrames["Skill"], "Target Bagian", {"Head", "Neck", "Body"}, "Head", function(v) HackConfig.AimTargetMode = v end)
CreateSlider(TabContentFrames["Skill"], "Aimbot Smoothness", 1, 50, 15, function(val) HackConfig.AimbotSmoothness = val end)
CreateToggle(TabContentFrames["Skill"], "Wall Check", false, function(v) HackConfig.WallCheck = v end, "WallCheck")
CreateToggle(TabContentFrames["Skill"], "Tampilkan Lingkaran FOV", false, function(v) 
    HackConfig.ShowFOV = v 
    if FOVFrame then FOVFrame.Visible = v end
end, "ShowFOV")
CreateSlider(TabContentFrames["Skill"], "Radius FOV", 50, 500, 150, function(val) 
    HackConfig.FOVRadius = val 
    if FOVFrame then FOVFrame.Size = UDim2.new(0, val * 2, 0, val * 2) end
end)
CreateToggle(TabContentFrames["Skill"], "FFA Mode (Semua Musuh)", false, function(v) HackConfig.FFAModeAktif = v end, "FFAModeAktif")
CreateToggle(TabContentFrames["Skill"], "Gun Mods (Rapid Fire)", false, function(v) HackConfig.GunModsAktif = v end, "GunModsAktif")
CreateSlider(TabContentFrames["Skill"], "Custom Fire Rate", 100, 2000, 800, function(val) HackConfig.CustomFireRate = val end)

CreateToggle(TabContentFrames["World"], "Mode Malam (Night Mode)", false, function(v)
    WorldConfig.NightMode = v
    if v then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.fromRGB(10, 10, 20)
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
    end
end, "NightMode")

CreateToggle(TabContentFrames["World"], "Cahaya Terang (Daylight)", false, function(v)
    WorldConfig.Daylight = v
    if v then
        Lighting.ClockTime = WorldConfig.DaylightClock
        Lighting.Brightness = WorldConfig.DaylightBrightness
        Lighting.GlobalShadows = false
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end, "Daylight")

CreateSlider(TabContentFrames["World"], "Kecerahan Daylight", 1, 10, 3, function(val)
    WorldConfig.DaylightBrightness = val
    if WorldConfig.Daylight then Lighting.Brightness = val end
end)

CreateToggle(TabContentFrames["World"], "Anti Kabut (No Fog)", false, function(v)
    WorldConfig.NoFog = v
    if v then
        Lighting.FogEnd = 999999
    else
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
end, "NoFog")

CreateToggle(TabContentFrames["World"], "WallHack Visual", false, function(v)
    WorldConfig.WallHack = v
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            part.LocalTransparencyModifier = v and 0.5 or 0
        end
    end
end, "WallHack")

local CONFIG_FILE_NAME = "D3D_Ultimate_Config.json"

local function SaveCurrentSettings()
    local saveData = {
        Visuals = VisualsConfig,
        World = WorldConfig,
        Hacks = HackConfig
    }
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(saveData))
            ShowPopupNotification("Pengaturan berhasil disimpan!")
        else
            ShowPopupNotification("Executor tidak support savefile!")
        end
    end)
end

local function LoadCurrentSettings()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE_NAME) then
            local rawData = readfile(CONFIG_FILE_NAME)
            local decoded = HttpService:JSONDecode(rawData)
            if decoded then
                if decoded.Visuals then
                    for k, v in pairs(decoded.Visuals) do
                        if type(v) ~= "table" then VisualsConfig[k] = v end
                    end
                end
                if decoded.World then
                    for k, v in pairs(decoded.World) do
                        if type(v) ~= "table" then WorldConfig[k] = v end
                    end
                end
                if decoded.Hacks then
                    for k, v in pairs(decoded.Hacks) do
                        if type(v) ~= "table" then HackConfig[k] = v end
                    end
                end

                for key, updateFunc in pairs(UIStateCallbacks) do
                    local val = nil
                    if VisualsConfig[key] ~= nil then val = VisualsConfig[key]
                    elseif WorldConfig[key] ~= nil then val = WorldConfig[key]
                    elseif HackConfig[key] ~= nil then val = HackConfig[key] end
                    if val ~= nil then
                        pcall(function() updateFunc(val) end)
                    end
                end

                if FOVFrame then
                    FOVFrame.Visible = HackConfig.ShowFOV
                    FOVFrame.Size = UDim2.new(0, HackConfig.FOVRadius * 2, 0, HackConfig.FOVRadius * 2)
                end

                if teleportDropdownRef and teleportDropdownRef.SetText then
                    teleportDropdownRef.SetText(WorldConfig.SelectedTeleportTarget ~= "" and WorldConfig.SelectedTeleportTarget or "Pilih Target")
                end

                ShowPopupNotification("Pengaturan berhasil dimuat & UI terupdate!")
            end
        else
            ShowPopupNotification("File pengaturan tidak ditemukan!")
        end
    end)
end

local function DeleteCurrentSettings()
    pcall(function()
        if delfile and isfile and isfile(CONFIG_FILE_NAME) then
            delfile(CONFIG_FILE_NAME)
            ShowPopupNotification("File pengaturan dihapus!")
        else
            ShowPopupNotification("Tidak ada file untuk dihapus!")
        end
    end)
end

CreateButton(TabContentFrames["Configuration"], "Simpan Pengaturan (Save)", SaveCurrentSettings)
CreateButton(TabContentFrames["Configuration"], "Muat Pengaturan (Load)", LoadCurrentSettings)
CreateButton(TabContentFrames["Configuration"], "Hapus Pengaturan (Delete)", DeleteCurrentSettings)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if hum and root then
            if HackConfig.SpeedAktif then
                hum.WalkSpeed = HackConfig.CustomSpeed
            end
            if HackConfig.JumpAktif then
                hum.UseJumpPower = true
                hum.JumpPower = HackConfig.CustomJump
            end

            if WorldConfig.FlyAktif then
                local bv = root:FindFirstChild("D3DFlyVelocity")
                local bg = root:FindFirstChild("D3DFlyGyro")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "D3DFlyVelocity"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = root
                end
                if not bg then
                    bg = Instance.new("BodyGyro")
                    bg.Name = "D3DFlyGyro"
                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bg.CFrame = Camera.CFrame
                    bg.Parent = root
                end

                bg.CFrame = Camera.CFrame
                local moveDir = Vector3.new(0, 0, 0)
                local camCF = Camera.CFrame

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end

                local baseFlySpeed = 50
                local isJumpHeld = UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
                if isJumpHeld then
                    baseFlySpeed = baseFlySpeed + 35
                end

                bv.Velocity = moveDir.Unit.Magnitude > 0 and (moveDir.Unit * baseFlySpeed) or Vector3.new(0, isJumpHeld and 35 or 0, 0)
            else
                local bv = root:FindFirstChild("D3DFlyVelocity")
                local bg = root:FindFirstChild("D3DFlyGyro")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local cKey = tostring(p.UserId)
            if not ESPCache[cKey] then CreateEntityESP(cKey) end
            local esp = ESPCache[cKey]
            local char = p.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if root and head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    if VisualsConfig.ESP_Line then
                        esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Line.To = Vector2.new(pos.X, pos.Y)
                        esp.Line.Color = VisualsConfig.LineColor
                        esp.Line.Visible = true
                    else
                        esp.Line.Visible = false
                    end

                    if VisualsConfig.ESP_Name then
                        esp.Name.Text = p.Name
                        esp.Name.Position = Vector2.new(pos.X, pos.Y - 45)
                        esp.Name.Color = VisualsConfig.NameColor
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end

                    if VisualsConfig.ESP_Distance then
                        local dist = (Camera.CFrame.Position - root.Position).Magnitude
                        esp.Distance.Text = math.floor(dist) .. "m"
                        esp.Distance.Position = Vector2.new(pos.X, pos.Y + 25)
                        esp.Distance.Color = VisualsConfig.DistanceColor
                        esp.Distance.Visible = true
                    else
                        esp.Distance.Visible = false
                    end

                    if VisualsConfig.ESP_Gender then
                        esp.Gender.Text = "[Cowo]"
                        esp.Gender.Position = Vector2.new(pos.X, pos.Y - 30)
                        esp.Gender.Color = VisualsConfig.GenderColor
                        esp.Gender.Visible = true
                    else
                        esp.Gender.Visible = false
                    end

                    if VisualsConfig.ESP_Status then
                        esp.Status.Text = "[Player]"
                        esp.Status.Position = Vector2.new(pos.X, pos.Y - 15)
                        esp.Status.Color = VisualsConfig.StatusColor
                        esp.Status.Visible = true
                    else
                        esp.Status.Visible = false
                    end

                    if VisualsConfig.ESP_Health then
                        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                        local hHeight = math.abs(headPos.Y - legPos.Y)
                        local hWidth = hHeight / 2
                        
                        esp.HealthBarBg.From = Vector2.new(pos.X - hWidth/2 - 6, headPos.Y)
                        esp.HealthBarBg.To = Vector2.new(pos.X - hWidth/2 - 6, legPos.Y)
                        esp.HealthBarBg.Visible = true

                        local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barTopY = legPos.Y + (headPos.Y - legPos.Y) * healthPercent
                        esp.HealthBar.From = Vector2.new(pos.X - hWidth/2 - 6, legPos.Y)
                        esp.HealthBar.To = Vector2.new(pos.X - hWidth/2 - 6, barTopY)
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBarBg.Visible = false
                        esp.HealthBar.Visible = false
                    end

                    if VisualsConfig.ESP_Skeleton then
                        local headP = Camera:WorldToViewportPoint(head.Position)
                        esp.HeadCircle.Position = Vector2.new(headP.X, headP.Y)
                        esp.HeadCircle.Radius = math.clamp(1500 / (Camera.CFrame.Position - head.Position).Magnitude, 4, 18)
                        esp.HeadCircle.Color = VisualsConfig.SkeletonColor
                        esp.HeadCircle.Visible = true
                    else
                        esp.HeadCircle.Visible = false
                    end
                else
                    HideESPObject(esp)
                end
            else
                HideESPObject(esp)
            end
        end
    end

    if HackConfig.AimbotAktif then
        local targetChar = (HackConfig.AimbotMode == "Lock 3D Otomatis") and GetNewTarget3D() or GetClosestEnemy2D()
        if targetChar then
            LockedTarget = targetChar
            local targetPart = GetDynamicTargetPart(targetChar)
            if targetPart then
                local currentCF = Camera.CFrame
                local targetCF = CFrame.new(currentCF.Position, targetPart.Position)
                Camera.CFrame = currentCF:Lerp(targetCF, 1 / math.clamp(HackConfig.AimbotSmoothness, 1, 50))
            end
        else
            LockedTarget = nil
        end
    end
end)
