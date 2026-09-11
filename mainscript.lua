-- v3.9.2 (Part 1/2)
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
ScreenGui.Name = "D3D_Ultimate_Android_V3_9_2"
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
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
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

local ThemeConfig = {
    IsDarkMode = true
}

local ESPCache = {}
local ChamsCache = {}
local EnemyChamsCache = {}
local LockedTarget = nil
local EntityGenderCache = {}

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
TitleLabel.Text = "× D3D MENU: PLAYER & BOT v3.9.2 ×"
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
                b.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(110, 110, 140) or Color3.fromRGB(100, 100, 120)
            end
        end
        btn.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(10, 10, 20)
    end)
end

local UIElementRegistry = {}

local function RegisterElement(elementType, frame, label, bgObj)
    table.insert(UIElementRegistry, {Type = elementType, Frame = frame, Label = label, BgObj = bgObj})
end

local function ApplyThemeToUI()
    if ThemeConfig.IsDarkMode then
        MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
        TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
        for _, item in ipairs(UIElementRegistry) do
            if item.BgObj then item.BgObj.BackgroundColor3 = Color3.fromRGB(12, 12, 18) end
            if item.Label then item.Label.TextColor3 = Color3.fromRGB(220, 220, 235) end
        end
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        TabContainer.BackgroundColor3 = Color3.fromRGB(215, 215, 225)
        TitleLabel.TextColor3 = Color3.fromRGB(20, 20, 30)
        for _, item in ipairs(UIElementRegistry) do
            if item.BgObj then item.BgObj.BackgroundColor3 = Color3.fromRGB(225, 225, 235) end
            if item.Label then item.Label.TextColor3 = Color3.fromRGB(20, 20, 30) end
        end
    end
end

local function CreateToggle(parent, text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(225, 225, 235)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(20, 20, 30)
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

    RegisterElement("Toggle", frame, label, frame)
    frame.Parent = parent
end

local function CreateDropdown(parent, text, options, defaultOption, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(225, 225, 235)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(20, 20, 30)
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
        if #options == 0 then return end
        currentIndex = (currentIndex % #options) + 1
        local selected = options[currentIndex]
        dropBtn.Text = selected
        if callback then callback(selected) end
    end)

    RegisterElement("Dropdown", frame, label, frame)
    frame.Parent = parent
    return dropBtn
end

local function CreateColorPicker(parent, text, defaultColor, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(225, 225, 235)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(20, 20, 30)
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

    RegisterElement("ColorPicker", frame, label, frame)
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(225, 225, 235)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(20, 20, 30)
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

    RegisterElement("Slider", frame, label, frame)
    frame.Parent = parent
end

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = ThemeConfig.IsDarkMode and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(225, 225, 235)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -16, 1, -8)
    btn.Position = UDim2.new(0, 8, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    RegisterElement("Button", frame, nil, frame)
    frame.Parent = parent
end
-- v3.9.2 (Part 2/2)

-- ==========================================
-- TAB 1: VISUAL
-- ==========================================
CreateToggle(TabContentFrames["Visual"], "ESP Skeleton (Bot & Player)", VisualsConfig.ESP_Skeleton, function(v) VisualsConfig.ESP_Skeleton = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Skeleton", VisualsConfig.SkeletonColor, function(c) VisualsConfig.SkeletonColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Line (Garis)", VisualsConfig.ESP_Line, function(v) VisualsConfig.ESP_Line = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Line", VisualsConfig.LineColor, function(c) VisualsConfig.LineColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Name", VisualsConfig.ESP_Name, function(v) VisualsConfig.ESP_Name = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Name", VisualsConfig.NameColor, function(c) VisualsConfig.NameColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Distance", VisualsConfig.ESP_Distance, function(v) VisualsConfig.ESP_Distance = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Distance", VisualsConfig.DistanceColor, function(c) VisualsConfig.DistanceColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Gender", VisualsConfig.ESP_Gender, function(v) VisualsConfig.ESP_Gender = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Gender", VisualsConfig.GenderColor, function(c) VisualsConfig.GenderColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Status (Alive/Dead)", VisualsConfig.ESP_Status, function(v) VisualsConfig.ESP_Status = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Status", VisualsConfig.StatusColor, function(c) VisualsConfig.StatusColor = c end)

CreateToggle(TabContentFrames["Visual"], "ESP Health Bar", VisualsConfig.ESP_Health, function(v) VisualsConfig.ESP_Health = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Health Bar", VisualsConfig.HealthColor, function(c) VisualsConfig.HealthColor = c end)

CreateToggle(TabContentFrames["Visual"], "Chams (Highlight Team)", VisualsConfig.Chams, function(v) VisualsConfig.Chams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Chams Team", VisualsConfig.ChamsColor, function(c) VisualsConfig.ChamsColor = c end)

CreateToggle(TabContentFrames["Visual"], "Chams (Highlight Enemy/Bot)", VisualsConfig.EnemyChams, function(v) VisualsConfig.EnemyChams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Warna Chams Enemy", VisualsConfig.EnemyChamsColor, function(c) VisualsConfig.EnemyChamsColor = c end)

-- ==========================================
-- TAB 2: PLAYER
-- ==========================================
CreateToggle(TabContentFrames["Player"], "Anti Admin / Kick Protection", HackConfig.AntiAdminAktif, function(v) HackConfig.AntiAdminAktif = v end)
CreateToggle(TabContentFrames["Player"], "Aimbot Sistem", HackConfig.AimbotAktif, function(v) HackConfig.AimbotAktif = v end)
CreateDropdown(TabContentFrames["Player"], "Target Bagian", {"Head", "HumanoidRootPart", "Torso"}, HackConfig.AimTargetMode, function(v) HackConfig.AimTargetMode = v end)
CreateSlider(TabContentFrames["Player"], "Aimbot Smoothness", 1, 50, HackConfig.AimbotSmoothness, function(v) HackConfig.AimbotSmoothness = v end)
CreateToggle(TabContentFrames["Player"], "Wall Check (Aimbot)", HackConfig.WallCheck, function(v) HackConfig.WallCheck = v end)
CreateToggle(TabContentFrames["Player"], "Tampilkan Lingkaran FOV", HackConfig.ShowFOV, function(v) 
    HackConfig.ShowFOV = v 
    if FOVFrame then FOVFrame.Visible = v end
end)
CreateSlider(TabContentFrames["Player"], "Radius FOV", 50, 400, HackConfig.FOVRadius, function(v) 
    HackConfig.FOVRadius = v
    if FOVFrame then FOVFrame.Size = UDim2.new(0, v * 2, 0, v * 2) end
end)
CreateToggle(TabContentFrames["Player"], "Mode FFA (Target Semua Pemain)", HackConfig.FFAModeAktif, function(v) HackConfig.FFAModeAktif = v end)
CreateToggle(TabContentFrames["Player"], "Anti Fall Damage", HackConfig.AntiFallDamageAktif, function(v) HackConfig.AntiFallDamageAktif = v end)
CreateToggle(TabContentFrames["Player"], "Custom Speed", HackConfig.SpeedAktif, function(v) HackConfig.SpeedAktif = v end)
CreateSlider(TabContentFrames["Player"], "Kecepatan (Speed)", 16, 200, HackConfig.CustomSpeed, function(v) HackConfig.CustomSpeed = v end)
CreateToggle(TabContentFrames["Player"], "Custom JumpPower", HackConfig.JumpAktif, function(v) HackConfig.JumpAktif = v end)
CreateSlider(TabContentFrames["Player"], "Kekuatan Lompat", 50, 300, HackConfig.CustomJump, function(v) HackConfig.CustomJump = v end)

-- ==========================================
-- TAB 3: WORLD (TELEPORT & NO FOG)
-- ==========================================
CreateToggle(TabContentFrames["World"], "Mode Malam (Night Mode)", WorldConfig.NightMode, function(v) WorldConfig.NightMode = v end)
CreateToggle(TabContentFrames["World"], "Mode Terang (Daylight)", WorldConfig.Daylight, function(v) WorldConfig.Daylight = v end)
CreateToggle(TabContentFrames["World"], "WallHack Dunia", WorldConfig.WallHack, function(v) WorldConfig.WallHack = v end)

-- Fitur No Fog
CreateToggle(TabContentFrames["World"], "No Fog (Hapus Kabut)", WorldConfig.NoFog, function(v) 
    WorldConfig.NoFog = v
    if v then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 999999
    else
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogStart = OriginalLighting.FogStart
    end
end)

-- Fitur Teleport dengan Dropdown Vertical Player / Bot
local function GetPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    -- Deteksi tambahan entity/bot jika ada di workspace
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
            if not table.find(list, obj.Name) then
                table.insert(list, obj.Name)
            end
        end
    end
    if #list == 0 then table.insert(list, "Tidak Ada Target") end
    return list
end

local tpDropdown = CreateDropdown(TabContentFrames["World"], "Target Teleport", GetPlayerList(), "Tidak Ada Target", function(selected)
    WorldConfig.SelectedTeleportTarget = selected
end)

CreateButton(TabContentFrames["World"], "Mulai Teleport ke Target", function()
    local targetName = WorldConfig.SelectedTeleportTarget
    if not targetName or targetName == "" or targetName == "Tidak Ada Target" then
        ShowPopupNotification("Pilih target teleport yang valid!")
        return
    end

    local targetChar = nil
    local pTarget = Players:FindFirstChild(targetName)
    if pTarget and pTarget.Character then
        targetChar = pTarget.Character
    else
        local wObj = Workspace:FindFirstChild(targetName)
        if wObj and wObj:FindFirstChild("HumanoidRootPart") then
            targetChar = wObj
        end
    end

    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        ShowPopupNotification("Berhasil Teleport ke: " .. targetName)
    else
        ShowPopupNotification("Gagal menemukan posisi target!")
    end
end)

-- Fitur Fly: Tahan tombol lompat bawaan map terus naik, lepas jadi slow / minim gravitasi
CreateToggle(TabContentFrames["World"], "Toggle Fly (Tahan Lompat untuk Naik)", WorldConfig.FlyAktif, function(v) WorldConfig.FlyAktif = v end)

-- ==========================================
-- TAB 4: SKILL & GUNS
-- ==========================================
CreateToggle(TabContentFrames["Skill"], "Gun Mods (Rapid Fire)", HackConfig.GunModsAktif, function(v) HackConfig.GunModsAktif = v end)
CreateSlider(TabContentFrames["Skill"], "Fire Rate Custom", 100, 2000, HackConfig.CustomFireRate, function(v) HackConfig.CustomFireRate = v end)

-- ==========================================
-- TAB 5: CONFIGURATION (FIXED SAVE, LOAD, DELETE & THEME)
-- ==========================================
local ConfigFileName = "D3D_Ultimate_Config_v392.json"

CreateToggle(TabContentFrames["Configuration"], "Mode Light / Dark UI", ThemeConfig.IsDarkMode, function(isDark)
    ThemeConfig.IsDarkMode = isDark
    ApplyThemeToUI()
    ShowPopupNotification(isDark ? "Dark Mode Aktif" : "Light Mode Aktif")
end)

CreateButton(TabContentFrames["Configuration"], "Save Configuration", function()
    pcall(function()
        local data = {
            Visuals = VisualsConfig,
            World = WorldConfig,
            Hacks = HackConfig,
            Theme = ThemeConfig
        }
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(data))
            ShowPopupNotification("Konfigurasi Berhasil Disimpan!")
        else
            ShowPopupNotification("Environment tidak mendukung writefile!")
        end
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Load Configuration", function()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            if decoded.Visuals then VisualsConfig = decoded.Visuals end
            if decoded.World then WorldConfig = decoded.World end
            if decoded.Hacks then HackConfig = decoded.Hacks end
            if decoded.Theme then 
                ThemeConfig = decoded.Theme 
                ApplyThemeToUI()
            end
            ShowPopupNotification("Konfigurasi Berhasil Dimuat!")
        else
            ShowPopupNotification("File konfigurasi tidak ditemukan!")
        end
    end)
end)

CreateButton(TabContentFrames["Configuration"], "Delete Configuration", function()
    pcall(function()
        if delfile and isfile and isfile(ConfigFileName) then
            delfile(ConfigFileName)
            ShowPopupNotification("Konfigurasi Berhasil Dihapus!")
        else
            ShowPopupNotification("Tidak ada file konfigurasi untuk dihapus.")
        end
    end)
end)

-- ==========================================
-- MAIN ENGINE / RENDER STEPPED LOOP
-- ==========================================
RunService.RenderStepped:Connect(function(dt)
    -- 1. Day / Night & Wallhack World
    pcall(function()
        if WorldConfig.NightMode then
            Lighting.ClockTime = 0
            Lighting.Brightness = 0
        elseif WorldConfig.Daylight then
            Lighting.ClockTime = WorldConfig.DaylightClock
            Lighting.Brightness = WorldConfig.DaylightBrightness
        end

        if WorldConfig.NoFog then
            Lighting.FogEnd = 999999
            Lighting.FogStart = 999999
        end

        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if WorldConfig.WallHack then
                    if part.Transparency < 0.3 and not part.Parent:FindFirstChild("Humanoid") then
                        part.LocalTransparencyModifier = 0.5
                    end
                end
            end
        end
    end)

    -- 2. Player Speed & Jump & AntiFall
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if HackConfig.SpeedAktif then hum.WalkSpeed = HackConfig.CustomSpeed end
                if HackConfig.JumpAktif then hum.JumpPower = HackConfig.CustomJump end
            end
            if HackConfig.AntiFallDamageAktif then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Velocity.Y < -80 then
                    root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
                end
            end

            -- Fitur Fly: Tahan tombol lompat bawaan map terus naik, lepas jadi slow / minim gravitasi
            if WorldConfig.FlyAktif then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local isJumping = UserInputService:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump)
                    if isJumping then
                        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) -- Naik ke atas terus saat tombol lompat ditahan
                    else
                        root.Velocity = Vector3.new(root.Velocity.X, -2, root.Velocity.Z) -- Jatuh sangat lambat / minim gravitasi saat dilepas
                    end
                end
            end
        end
    end)
end)

ShowPopupNotification("D3D Menu v3.9.2 Berhasil Dimuat!")
