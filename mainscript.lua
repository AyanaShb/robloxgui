-- v3.9.3 Full Complete -- Part 1
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
ScreenGui.Name = "D3D_Ultimate_Android_V3_9_3"
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
    SelectedTeleportTarget = "Pilih Target..."
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
    CustomFireRate = 800,
    FlyHoldJumpAktif = false
}

local UIThemeConfig = {
    IsDark = true
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
TitleLabel.Text = "× D3D MENU: PLAYER & BOT v3.9.3 ×"
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
local ThemeManagedElements = {
    SubBackgrounds = {}
}

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
                b.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(110, 110, 140) or Color3.fromRGB(100, 100, 120)
            end
        end
        btn.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(10, 10, 20)
    end)
end

local function ApplyThemeColors()
    if UIThemeConfig.IsDark then
        MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
        TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
        for _, frame in ipairs(ThemeManagedElements.SubBackgrounds) do
            if frame and frame.Parent then frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18) end
        end
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(240, 242, 245)
        TabContainer.BackgroundColor3 = Color3.fromRGB(220, 222, 230)
        TitleLabel.TextColor3 = Color3.fromRGB(20, 20, 30)
        for _, frame in ipairs(ThemeManagedElements.SubBackgrounds) do
            if frame and frame.Parent then frame.BackgroundColor3 = Color3.fromRGB(230, 232, 240) end
        end
    end
end

local function CreateToggle(parent, text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = UIThemeConfig.IsDark and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(230, 232, 240)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeManagedElements.SubBackgrounds, frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(30, 30, 45)
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
    frame.BackgroundColor3 = UIThemeConfig.IsDark and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(230, 232, 240)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeManagedElements.SubBackgrounds, frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(30, 30, 45)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropBtn = Instance.new("TextButton", frame)
    dropBtn.Size = UDim2.new(0, 180, 0, 32)
    dropBtn.Position = UDim2.new(1, -192, 0.5, -16)
    dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    dropBtn.Text = defaultOption
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 9.5
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

    frame.Parent = parent
    return dropBtn, function(newOptions, newDefault)
        options = newOptions
        if #options > 0 then
            currentIndex = 1
            if newDefault then
                for i, opt in ipairs(options) do
                    if opt == newDefault then currentIndex = i break end
                end
            end
            dropBtn.Text = options[currentIndex]
            if callback then callback(options[currentIndex]) end
        else
            dropBtn.Text = "Kosong"
        end
    end
end

local function CreateColorPicker(parent, text, defaultColor, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = UIThemeConfig.IsDark and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(230, 232, 240)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeManagedElements.SubBackgrounds, frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(30, 30, 45)
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
    frame.BackgroundColor3 = UIThemeConfig.IsDark and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(230, 232, 240)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeManagedElements.SubBackgrounds, frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = UIThemeConfig.IsDark and Color3.fromRGB(220, 220, 235) or Color3.fromRGB(30, 30, 45)
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

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = UIThemeConfig.IsDark and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(230, 232, 240)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    table.insert(ThemeManagedElements.SubBackgrounds, frame)

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

    frame.Parent = parent
end

-- Tab Visual
CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Player & Bot)", false, function(v) VisualsConfig.ESP_Skeleton = v end)
CreateColorPicker(TabContentFrames["Visual"], "Skeleton Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.SkeletonColor = c end)
CreateToggle(TabContentFrames["Visual"], "Chams / Wall Glow", false, function(v) VisualsConfig.Chams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Chams Glow Color", Color3.fromRGB(255, 0, 128), function(c) VisualsConfig.ChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "Enemy Chams", false, function(v) VisualsConfig.EnemyChams = v end)
CreateColorPicker(TabContentFrames["Visual"], "Enemy Chams Color", Color3.fromRGB(255, 0, 0), function(c) VisualsConfig.EnemyChamsColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Line", false, function(v) VisualsConfig.ESP_Line = v end)
CreateColorPicker(TabContentFrames["Visual"], "Line Color", Color3.fromRGB(0, 240, 255), function(c) VisualsConfig.LineColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Name", false, function(v) VisualsConfig.ESP_Name = v end)
CreateColorPicker(TabContentFrames["Visual"], "Name Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.NameColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Distance", false, function(v) VisualsConfig.ESP_Distance = v end)
CreateColorPicker(TabContentFrames["Visual"], "Distance Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.DistanceColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Gender", false, function(v) VisualsConfig.ESP_Gender = v end)
CreateColorPicker(TabContentFrames["Visual"], "Gender Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.GenderColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Status", false, function(v) VisualsConfig.ESP_Status = v end)
CreateColorPicker(TabContentFrames["Visual"], "Status Color", Color3.fromRGB(255, 255, 255), function(c) VisualsConfig.StatusColor = c end)
CreateToggle(TabContentFrames["Visual"], "ESP Health", false, function(v) VisualsConfig.ESP_Health = v end)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end)

-- Tab Player
CreateToggle(TabContentFrames["Player"], "No Fall Damage", false, function(v) HackConfig.AntiFallDamageAktif = v end)
CreateToggle(TabContentFrames["Player"], "Kecepatan Lari", false, function(v) HackConfig.SpeedAktif = v end)
CreateSlider(TabContentFrames["Player"], "Set Speed", 16, 250, 50, function(val) HackConfig.CustomSpeed = val end)
CreateToggle(TabContentFrames["Player"], "Lompat Tinggi", false, function(v) HackConfig.JumpAktif = v end)
CreateSlider(TabContentFrames["Player"], "Set Power", 50, 250, 100, function(val) HackConfig.CustomJump = val end)
CreateToggle(TabContentFrames["Player"], "Fly (Tahan Tombol Lompat Map)", false, function(v) 
    HackConfig.FlyHoldJumpAktif = v
    ShowPopupNotification(v and "Fly (Tahan Lompat) Diaktifkan" or "Fly Dimatikan")
end)
-- v3.9.3 Full Complete -- Part 2
local function GetAvailableEntitiesList()
    local names = {"Pilih Target..."}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then table.insert(names, p.Name) end
    end
    local function scan(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Model") and child ~= LocalPlayer.Character and child:FindFirstChildOfClass("Humanoid") then
                local isP = false
                for _, p in ipairs(Players:GetPlayers()) do if p.Character == child then isP = true end end
                if not isP then table.insert(names, child.Name .. " [Bot]") end
            elseif child:IsA("Folder") or child:IsA("Model") then
                scan(child)
            end
        end
    end
    scan(Workspace)
    return names
end

-- Tab World
CreateToggle(TabContentFrames["World"], "Night Mode", false, function(v) WorldConfig.NightMode = v end)
CreateToggle(TabContentFrames["World"], "Daylight", false, function(v) WorldConfig.Daylight = v end)
CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end)
CreateSlider(TabContentFrames["World"], "Daylight Time", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end)
CreateToggle(TabContentFrames["World"], "Wall Hack (Noclip)", false, function(v) WorldConfig.WallHack = v end)
CreateToggle(TabContentFrames["World"], "No Fog (Hapus Kabut)", false, function(v) 
    WorldConfig.NoFog = v
    ShowPopupNotification(v and "No Fog Diaktifkan" or "No Fog Dimatikan")
end)

local updateTpDropdown
_, updateTpDropdown = CreateDropdown(TabContentFrames["World"], "Target Teleport", GetAvailableEntitiesList(), "Pilih Target...", function(selected)
    WorldConfig.SelectedTeleportTarget = selected
end)

CreateButton(TabContentFrames["World"], "Refresh List Target", function()
    updateTpDropdown(GetAvailableEntitiesList(), "Pilih Target...")
    ShowPopupNotification("List Teleport diperbarui!")
end)

CreateButton(TabContentFrames["World"], "Teleport Sekarang!", function()
    pcall(function()
        local targetName = WorldConfig.SelectedTeleportTarget
        if not targetName or targetName == "Pilih Target..." then
            ShowPopupNotification("Pilih target teleport dulu!")
            return
        end
        
        local targetChar = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == targetName and p.Character then targetChar = p.Character break end
        end
        if not targetChar then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name == targetName or obj.Name .. " [Bot]" == targetName) and obj:FindFirstChild("HumanoidRootPart") then
                    targetChar = obj
                    break
                end
            end
        end
        
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            ShowPopupNotification("Berhasil Teleport ke " .. targetName)
        else
            ShowPopupNotification("Target tidak ditemukan / invalid!")
        end
    end)
end)

-- Tab Skill
CreateToggle(TabContentFrames["Skill"], "Peringatan Admin", false, function(v) HackConfig.AntiAdminAktif = v end)
CreateToggle(TabContentFrames["Skill"], "Auto Aim (Kunci Layar)", false, function(v) HackConfig.AimbotAktif = v end)
CreateToggle(TabContentFrames["Skill"], "Auto Aim Wall Check", false, function(v) HackConfig.WallCheck = v end)
CreateDropdown(TabContentFrames["Skill"], "Mode Aimbot", {"POV Kamera (FOV)", "360° (Brutal)"}, "POV Kamera (FOV)", function(opt) HackConfig.AimbotMode = opt end)
CreateDropdown(TabContentFrames["Skill"], "Target Bagian Tubuh", {"Head", "Neck", "Body"}, "Head", function(opt) HackConfig.AimTargetMode = opt end)
CreateSlider(TabContentFrames["Skill"], "Kelengketan Aim POV", 1, 100, 15, function(val) HackConfig.AimbotSmoothness = val end)
CreateToggle(TabContentFrames["Skill"], "Tampilkan Lingkaran FOV", false, function(v) HackConfig.ShowFOV = v end)
CreateSlider(TabContentFrames["Skill"], "Lebar Lingkaran FOV", 10, 600, 150, function(val) HackConfig.FOVRadius = val end)
CreateToggle(TabContentFrames["Skill"], "Gun Mods (Infinite Ammo & RPM)", false, function(v) HackConfig.GunModsAktif = v end)
CreateSlider(TabContentFrames["Skill"], "RPM Fire Rate", 400, 2500, 800, function(val) HackConfig.CustomFireRate = val end)

-- Tab Configuration (Save, Load, Delete, & Theme Switcher)
CreateToggle(TabContentFrames["Configuration"], "UI Light Mode / Dark Mode", true, function(isDark)
    UIThemeConfig.IsDark = isDark
    ApplyThemeColors()
    ShowPopupNotification(isDark and "Mode Dark UI" or "Mode Light UI")
end)

CreateButton(TabContentFrames["Configuration"], "Save Settings", function()
    pcall(function()
        if writefile then
            local data = {
                Visuals = VisualsConfig,
                World = WorldConfig,
                Hacks = HackConfig,
                Theme = UIThemeConfig
            }
            writefile("D3D_Settings.json", HttpService:JSONEncode(data))
            ShowPopupNotification("Settings berhasil disimpan ke file!")
        else
            ShowPopupNotification("Executor tidak mendukung writefile!")
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
                if data.Theme then 
                    UIThemeConfig = data.Theme 
                    ApplyThemeColors()
                end
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
            ShowPopupNotification("File settings berhasil dihapus!")
        else
            ShowPopupNotification("Tidak ada file settings ditemukan!")
        end
    end)
end)

-- Logic Loops & ESP Rendering
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
    local body = char:FindFirstChild("HumanoidRootPart") or neck or head or char.PrimaryPart or char:FindFirstChildOfClass("BasePart")
    if HackConfig.AimTargetMode == "Head" then return head or body
    elseif HackConfig.AimTargetMode == "Neck" then return neck or head or body
    elseif HackConfig.AimTargetMode == "Body" then return body or head end
    return body
end

local function GetAllTargetableEntities()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and IsValidCharacter(p.Character) then table.insert(list, p) end
    end
    local function scanFolder(parentObj)
        for _, obj in ipairs(parentObj:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and IsValidCharacter(obj) then
                local isPlayerChar = false
                for _, p in ipairs(Players:GetPlayers()) do if p.Character == obj then isPlayerChar = true break end end
                if not isPlayerChar then table.insert(list, obj) end
            elseif obj:IsA("Folder") or obj:IsA("Model") then scanFolder(obj) end
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
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Gender = Drawing.new("Text"),
        Status = Drawing.new("Text"),
        HealthBarBg = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
        HeadCircle = Drawing.new("Circle"),
        Skeleton = { Spine = Drawing.new("Line"), LeftArm = Drawing.new("Line"), RightArm = Drawing.new("Line"), LeftLeg = Drawing.new("Line"), RightLeg = Drawing.new("Line") }
    }
    espData.Line.Thickness = 1.5; espData.Line.Color = VisualsConfig.LineColor; espData.Line.Transparency = 0.7; espData.Line.Visible = false
    espData.HealthBarBg.Thickness = 3; espData.HealthBarBg.Color = Color3.fromRGB(40, 40, 40); espData.HealthBarBg.Transparency = 0.8; espData.HealthBarBg.Visible = false
    espData.HealthBar.Thickness = 1.5; espData.HealthBar.Color = VisualsConfig.HealthColor; espData.HealthBar.Transparency = 1; espData.HealthBar.Visible = false
    espData.HeadCircle.Thickness = 1.5; espData.HeadCircle.NumSides = 12; espData.HeadCircle.Filled = false; espData.HeadCircle.Color = VisualsConfig.SkeletonColor; espData.HeadCircle.Transparency = 0.8; espData.HeadCircle.Visible = false
    for _, bone in pairs(espData.Skeleton) do bone.Thickness = 1.5; bone.Color = VisualsConfig.SkeletonColor; bone.Transparency = 0.8; bone.Visible = false end
    for _, textObj in ipairs({espData.Name, espData.Distance, espData.Gender, espData.Status}) do
        textObj.Size = 13; textObj.Center = true; textObj.Outline = true; textObj.OutlineColor = Color3.fromRGB(0, 0, 0); textObj.Font = Drawing.Fonts.UI; textObj.Visible = false
    end
    ESPCache[key] = espData
end

RunService.RenderStepped:Connect(function()
    if WorldConfig.NightMode then
        Lighting.ClockTime = 0; Lighting.Brightness = 0.1; Lighting.Ambient = Color3.fromRGB(0, 0, 0); Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    elseif WorldConfig.Daylight then
        Lighting.ClockTime = WorldConfig.DaylightClock; Lighting.Brightness = WorldConfig.DaylightBrightness; Lighting.Ambient = Color3.fromRGB(200, 200, 200); Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    end

    if WorldConfig.NoFog then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 999999
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
                if partToAim and (not HackConfig.WallCheck or IsVisible(partToAim)) then
                    targetValid = true
                end
            end
        end
        if not targetValid then
            if HackConfig.AimbotMode == "360° (Brutal)" then LockedTarget = GetNewTarget3D()
            else LockedTarget = GetClosestEnemy2D() end
            if LockedTarget then partToAim = GetDynamicTargetPart(LockedTarget) end
        end
        if LockedTarget and partToAim then
            if HackConfig.AimbotMode == "360° (Brutal)" then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, partToAim.Position)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, partToAim.Position), HackConfig.AimbotSmoothness / 100) end
        else LockedTarget = nil end
    else LockedTarget = nil end

    if HackConfig.FlyHoldJumpAktif and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if hum.Jump then hrp.Velocity = Vector3.new(hrp.Velocity.X, 25, hrp.Velocity.Z)
            elseif hrp.Velocity.Y < -5 then hrp.Velocity = Vector3.new(hrp.Velocity.X, -2, hrp.Velocity.Z) end
        end
    end

    local activeEntities = GetAllTargetableEntities()
    for key, _ in pairs(ESPCache) do
        local found = false
        for _, ent in ipairs(activeEntities) do if GetEntityModel(ent) == key and IsValidCharacter(key) then found = true break end end
        if not found then RemoveEntityESP(key) end
    end

    for _, entity in ipairs(activeEntities) do
        local char = GetEntityModel(entity)
        if IsValidCharacter(char) then
            if not ESPCache[char] then CreateEntityESP(char) end
            local esp = ESPCache[char]
            local isEnemy = IsEnemyEntity(entity)
            local primaryPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            local active = isEnemy and primaryPart and (not hum or hum.Health > 0)

            if active and VisualsConfig.Chams then
                if not ChamsCache[char] then
                    local hl = Instance.new("Highlight", char); hl.Name = "D3D_Chams"; hl.FillColor = VisualsConfig.ChamsColor; hl.FillTransparency = 0.4
                    ChamsCache[char] = hl
                else ChamsCache[char].FillColor = VisualsConfig.ChamsColor; ChamsCache[char].Enabled = true end
            elseif ChamsCache[char] then ChamsCache[char].Enabled = false end

            if active then
                local vector, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                if onScreen then
                    local distance = (Camera.CFrame.Position - primaryPart.Position).Magnitude
                    if VisualsConfig.ESP_Name then
                        esp.Name.Text = (typeof(entity) == "Instance" and entity:IsA("Player")) and entity.Name or char.Name
                        esp.Name.Position = Vector2.new(vector.X, vector.Y - 38)
                        esp.Name.Color = VisualsConfig.NameColor; esp.Name.Visible = true
                    else esp.Name.Visible = false end

                    if VisualsConfig.ESP_Distance then
                        esp.Distance.Text = string.format("[%dM]", math.floor(distance))
                        esp.Distance.Position = Vector2.new(vector.X, vector.Y + 22)
                        esp.Distance.Color = VisualsConfig.DistanceColor; esp.Distance.Visible = true
                    else esp.Distance.Visible = false end

                    if VisualsConfig.ESP_Health and hum then
                        local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        esp.HealthBarBg.From = Vector2.new(vector.X + 24, vector.Y - 20)
                        esp.HealthBarBg.To = Vector2.new(vector.X + 24, vector.Y + 20)
                        esp.HealthBarBg.Visible = true
                        esp.HealthBar.From = Vector2.new(vector.X + 24, vector.Y + 20 - (40 * healthPct))
                        esp.HealthBar.To = Vector2.new(vector.X + 24, vector.Y + 20)
                        esp.HealthBar.Color = VisualsConfig.HealthColor; esp.HealthBar.Visible = true
                    else esp.HealthBarBg.Visible = false; esp.HealthBar.Visible = false end
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
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end
    end
end)
