-- =====================================================================
-- D3D MENU: LITE HACK + ULTIMATE MODS (CUSTOM UI INTEGRATION) --
-- =====================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT (DARI SCRIPT KEDUA)
-- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end)
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

if Camera.ViewportSize.Y > Camera.ViewportSize.X then
    repeat task.wait(0.5) until Camera.ViewportSize.X > Camera.ViewportSize.Y
    task.wait(1)
end

-- ==========================================
-- CONFIG & STATE VARIABEL (GABUNGAN KEDUANYA)
-- ==========================================
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
    SpeedValue = 50,
    FlyHack = false,
    MultiJump = false,
    Wallhack = false,
    AntiAim = false,
    AntiFallDamage = false,
    JumpPower = 100
}

local WorldConfig = {
    NightMode = false,
    Daylight = false,
    DaylightBrightness = 3,
    DaylightClock = 14
}

local SkillConfig = {
    Aimbot = false,
    AimbotMode = "POV Kamera (FOV)",
    AimTargetPart = "Head",
    AimDistance = 1000,
    AimFovSize = 150,
    AimbotSmoothness = 15
}

local GunConfig = {
    GunModsAktif = false,
    CustomFireRate = 800
}

local MainConfig = {
    AntiAdminAktif = false,
    FFAModeAktif = false,
    ESPAktif = false,
    ShowFOV = false
}

local OriginalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

local ESPCache = {}
local ChamsCache = {}
local ValidEntities = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.NumSides = 64

local AimbotLine = Drawing.new("Line")
AimbotLine.Visible = false
AimbotLine.Thickness = 1.5
AimbotLine.Color = Color3.fromRGB(0, 255, 128)

-- ==========================================
-- 🛡️ LOGIKA NOTIFIKASI & UI UTAMA (D3D STYLE)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_LiteHack_Ultimate_UI"
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

local function SendNotification(title, content, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 260, 0, 56)
    notif.Position = UDim2.new(1, -270, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    notif.BorderSizePixel = 0
    notif.Parent = ScreenGui

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", notif)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 240, 255)

    local titleLbl = Instance.new("TextLabel", notif)
    titleLbl.Size = UDim2.new(1, -12, 0, 22)
    titleLbl.Position = UDim2.new(0, 12, 0, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(0, 240, 255)
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local descLbl = Instance.new("TextLabel", notif)
    descLbl.Size = UDim2.new(1, -12, 0, 22)
    descLbl.Position = UDim2.new(0, 12, 0, 26)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = content
    descLbl.TextColor3 = Color3.fromRGB(220, 220, 235)
    descLbl.TextSize = 10
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(duration or 3, function()
        pcall(function() notif:Destroy() end)
    end)
end

SendNotification("🛡️ Update Aktif", "Gun Mods menggunakan Deep Memory Scan & Custom UI Aktif.", 4)

-- Floating Menu Button
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

-- Main UI Frame
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
TitleLabel.Text = "× LITE HACK + ULTIMATE MODS ×"
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

local tabs = {"Main", "Player", "Gun", "Visual", "World", "Config"}
local TabContentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * (1 / #tabs), 0, 0, 0)
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

-- ==========================================
-- UI BUILDER HELPERS
-- ==========================================
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
    return {
        Set = function(val)
            active = val
            toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
            circle.Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            if callback then callback(active) end
        end
    }
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
    return {
        Set = function(val)
            local pos = math.clamp((val - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            label.Text = text .. ": " .. tostring(val)
            if callback then callback(val) end
        end
    }
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
    choiceBtn.Size = UDim2.new(0, 130, 0, 28)
    choiceBtn.Position = UDim2.new(1, -142, 0.5, -14)
    choiceBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    choiceBtn.Text = choices[defaultIndex]
    choiceBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
    choiceBtn.TextSize = 10
    choiceBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", choiceBtn).CornerRadius = UDim.new(0, 6)

    local currentIndex = defaultIndex
    choiceBtn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #choices) + 1
        choiceBtn.Text = choices[currentIndex]
        if callback then callback(choices[currentIndex]) end
    end)

    frame.Parent = parent
    return {
        Set = function(choiceStr)
            for idx, val in ipairs(choices) do
                if val == choiceStr then
                    currentIndex = idx
                    choiceBtn.Text = val
                    if callback then callback(val) end
                    break
                end
            end
        end
    }
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

local function CreateButtonUI(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 240, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 240, 255)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ==========================================
-- POPULATE TABS DENGAN FITUR LENGKAP
-- ==========================================

-- 1. Tab Main Features
local ToggleAntiAdmin = CreateToggle(TabContentFrames["Main"], "🚨 Peringatan Admin (Popup Warning)", false, function(v) MainConfig.AntiAdminAktif = v end)
local ToggleAimbot = CreateToggle(TabContentFrames["Main"], "🎯 Aktifkan Auto Aim (Kunci Layar)", false, function(v) SkillConfig.Aimbot = v end)
local DropdownAimbotMode = CreateChoice(TabContentFrames["Main"], "⚙️ Mode Aimbot", {"POV Kamera (FOV)", "360° (Brutal)"}, 1, function(opt) SkillConfig.AimbotMode = opt end)
local DropdownAimTarget = CreateChoice(TabContentFrames["Main"], "🎯 Target Bagian Tubuh", {"Head", "Body"}, 1, function(opt) SkillConfig.AimTargetPart = opt end)
local SliderSmoothness = CreateSlider(TabContentFrames["Main"], "🧲 Kelengketan Aim POV (Smoothness)", 1, 100, 15, function(val) SkillConfig.AimbotSmoothness = val end)
local ToggleFOV = CreateToggle(TabContentFrames["Main"], "⭕ Tampilkan Lingkaran FOV", false, function(v) MainConfig.ShowFOV = v end)
local SliderFOV = CreateSlider(TabContentFrames["Main"], "📏 Lebar Lingkaran FOV", 10, 600, 150, function(val) SkillConfig.AimFovSize = val end)
local ToggleESPMain = CreateToggle(TabContentFrames["Main"], "👁️ Enemy ESP (Melihat Musuh)", false, function(v) MainConfig.ESPAktif = v end)

-- 2. Tab Player Hacks
local ToggleAntiFall = CreateToggle(TabContentFrames["Player"], "🛡️ No Fall Damage", false, function(v) PlayerConfig.AntiFallDamage = v end)
local ToggleSpeed = CreateToggle(TabContentFrames["Player"], "⚡ Kecepatan Lari", false, function(v) PlayerConfig.SpeedRun = v end)
local SliderSpeed = CreateSlider(TabContentFrames["Player"], "⚙️ Set Speed", 16, 250, 50, function(val) PlayerConfig.SpeedValue = val end)
local ToggleJump = CreateToggle(TabContentFrames["Player"], "🚀 Lompat Tinggi", false, function(v) PlayerConfig.MultiJump = v end)
local SliderJump = CreateSlider(TabContentFrames["Player"], "⚙️ Set Power", 50, 250, 100, function(val) PlayerConfig.JumpPower = val end)
CreateToggle(TabContentFrames["Player"], "Wallhack / Noclip (Tembus Objek)", false, function(v) PlayerConfig.Wallhack = v end)

-- 3. Tab Gun Mods
local ToggleGunMods = CreateToggle(TabContentFrames["Gun"], "🔫 Gun Mods (Infinite Ammo & RPM)", false, function(v) GunConfig.GunModsAktif = v end)
local SliderFireRate = CreateSlider(TabContentFrames["Gun"], "⚡ RPM Fire Rate", 400, 2500, 800, function(val) GunConfig.CustomFireRate = val end)

-- 4. Tab Visuals (ESP lengkap + Chams + Skeleton)
CreateToggle(TabContentFrames["Visual"], "Skeleton ESP (Universal Stable)", false, function(v) VisualsConfig.ESP_Skeleton = v end)
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
CreateToggle(TabContentFrames["Visual"], "ESP Health (Vertical Bar)", false, function(v) VisualsConfig.ESP_Health = v end)
CreateColorPicker(TabContentFrames["Visual"], "Health Bar Color", Color3.fromRGB(0, 255, 128), function(c) VisualsConfig.HealthColor = c end)

-- 5. Tab World
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
end)
CreateSlider(TabContentFrames["World"], "Daylight Brightness", 1, 10, 3, function(val) WorldConfig.DaylightBrightness = val end)
CreateSlider(TabContentFrames["World"], "Daylight Time (Clock)", 0, 24, 14, function(val) WorldConfig.DaylightClock = val end)

-- 6. Tab Config & Save
local ConfigFileName = "LiteHack_Config.json"
local function SaveSettings()
    local settings = {
        AntiAdmin = MainConfig.AntiAdminAktif,
        Aimbot = SkillConfig.Aimbot,
        AimbotMode = SkillConfig.AimbotMode,
        AimTargetMode = SkillConfig.AimTargetPart,
        AimbotSmoothness = SkillConfig.AimbotSmoothness,
        ShowFOV = MainConfig.ShowFOV,
        FOVRadius = SkillConfig.AimFovSize,
        ESPAktif = MainConfig.ESPAktif,
        AntiFallDamage = PlayerConfig.AntiFallDamage,
        SpeedAktif = PlayerConfig.SpeedRun,
        CustomSpeed = PlayerConfig.SpeedValue,
        JumpAktif = PlayerConfig.MultiJump,
        CustomJump = PlayerConfig.JumpPower,
        GunModsAktif = GunConfig.GunModsAktif,
        CustomFireRate = GunConfig.CustomFireRate
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
            if settings.AntiAdmin ~= nil then ToggleAntiAdmin:Set(settings.AntiAdmin) end
            if settings.Aimbot ~= nil then ToggleAimbot:Set(settings.Aimbot) end
            if settings.AimbotMode ~= nil then DropdownAimbotMode:Set(settings.AimbotMode) end
            if settings.AimTargetMode ~= nil then DropdownAimTarget:Set(settings.AimTargetMode) end
            if settings.AimbotSmoothness ~= nil then SliderSmoothness:Set(settings.AimbotSmoothness) end
            if settings.ShowFOV ~= nil then ToggleFOV:Set(settings.ShowFOV) end
            if settings.FOVRadius ~= nil then SliderFOV:Set(settings.FOVRadius) end
            if settings.ESPAktif ~= nil then ToggleESPMain:Set(settings.ESPAktif) end
            if settings.AntiFallDamage ~= nil then ToggleAntiFall:Set(settings.AntiFallDamage) end
            if settings.SpeedAktif ~= nil then ToggleSpeed:Set(settings.SpeedAktif) end
            if settings.CustomSpeed ~= nil then SliderSpeed:Set(settings.CustomSpeed) end
            if settings.JumpAktif ~= nil then ToggleJump:Set(settings.JumpAktif) end
            if settings.CustomJump ~= nil then SliderJump:Set(settings.JumpJumpPower or settings.CustomJump) end
            if settings.GunModsAktif ~= nil then ToggleGunMods:Set(settings.GunModsAktif) end
            if settings.CustomFireRate ~= nil then SliderFireRate:Set(settings.CustomFireRate) end
            return true
        end
    end
    return false
end

CreateButtonUI(TabContentFrames["Config"], "💾 Save Konfigurasi", function()
    if SaveSettings() then SendNotification("✅ Tersimpan", "Settingan berhasil disimpan!", 3)
    else SendNotification("❌ Gagal", "Eksekutor tidak mendukung Save.", 3) end
end)
CreateButtonUI(TabContentFrames["Config"], "📂 Load Konfigurasi", function()
    if LoadSettings() then SendNotification("✅ Berhasil", "Settingan dimuat!", 3)
    else SendNotification("⚠️ Info", "Belum ada Save.", 3) end
end)
CreateButtonUI(TabContentFrames["Config"], "🔄 Reset Semua ke Default", function()
    ToggleAntiAdmin:Set(false)
    ToggleAimbot:Set(false)
    DropdownAimbotMode:Set("POV Kamera (FOV)")
    DropdownAimTarget:Set("Head")
    SliderSmoothness:Set(15)
    ToggleFOV:Set(false)
    SliderFOV:Set(150)
    ToggleESPMain:Set(false)
    ToggleAntiFall:Set(false)
    ToggleSpeed:Set(false)
    SliderSpeed:Set(50)
    ToggleJump:Set(false)
    SliderJump:Set(100)
    ToggleGunMods:Set(false)
    SliderFireRate:Set(800)
    SendNotification("🔄 Di-Reset", "Semua fitur dimatikan.", 3)
end)

-- ==========================================
-- BACKEND LOGIC: ANTI-GM / ADMIN DETECTION
-- ==========================================
local function CheckIfAdmin(p)
    if p == LocalPlayer then return false end
    local nameRaw = string.upper(p.Name .. " " .. p.DisplayName)
    if string.find(nameRaw, "%[GM%]") or string.find(nameRaw, "%[MOD%]") or string.find(nameRaw, "GAME MASTER") or string.find(nameRaw, "MODERATOR") then return true end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        for _, stat in pairs(ls:GetChildren()) do
            local statValue = string.upper(tostring(stat.Value))
            if statValue == "GM" or statValue == "MOD" or statValue == "GAME MASTER" or statValue == "MODERATOR" then return true end
        end
    end
    return false
end

local function SendAdminWarning(p)
    SendNotification("⚠️ GM TERDETEKSI!", "Admin/Moderator ["..p.Name.."] ada di room ini!", 8)
end

Players.PlayerAdded:Connect(function(p)
    if MainConfig.AntiAdminAktif then
        task.wait(1)
        if CheckIfAdmin(p) then SendAdminWarning(p) end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if MainConfig.AntiAdminAktif then
            for _, p in pairs(Players:GetPlayers()) do
                if CheckIfAdmin(p) then SendAdminWarning(p) end
            end
        end
    end
end)

-- ==========================================
-- ENTITY CACHE & TEAM LOGIC
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        local currentList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                table.insert(currentList, p.Character)
            end
        end
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) and obj:FindFirstChildOfClass("Humanoid") then
                table.insert(currentList, obj)
            end
        end
        ValidEntities = currentList
    end
end)

local function IsEnemy(model)
    if MainConfig.FFAModeAktif then return true end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end
    return true
end

-- ==========================================
-- PLAYER ESP & SKELETON & CHAMS ENGINE
-- ==========================================
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

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreatePlayerESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    CreatePlayerESP(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        CreatePlayerESP(p)
    end)
end)
Players.PlayerRemoving:Connect(RemovePlayerESP)

-- ==========================================
-- AIMBOT & RAYCAST VISIBILITY
-- ==========================================
local LockedTarget = nil

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
    local body = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if SkillConfig.AimTargetPart == "Head" then
        if head and IsVisible(head) then return head end
        if body and IsVisible(body) then return body end
        return head or body
    else
        if body and IsVisible(body) then return body end
        if head and IsVisible(head) then return head end
        return body or head
    end
end

local function GetNewTarget3D()
    local closest, shortestDist = nil, math.huge
    for _, item in pairs(ValidEntities) do
        local hum = item:FindFirstChildOfClass("Humanoid")
        if item.Parent and hum and hum.Health > 0 and IsEnemy(item) and not item:FindFirstChildOfClass("ForceField") then
            local targetPart = GetDynamicTargetPart(item)
            if targetPart and IsVisible(targetPart) then
                local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = item
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemy2D()
    local closest, shortestDist = nil, SkillConfig.AimFovSize
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, item in pairs(ValidEntities) do
        local hum = item:FindFirstChildOfClass("Humanoid")
        if item.Parent and hum and hum.Health > 0 and IsEnemy(item) and not item:FindFirstChildOfClass("ForceField") then
            local targetPart = GetDynamicTargetPart(item)
            if targetPart and IsVisible(targetPart) then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = item
                    end
                end
            end
        end
    end
    return closest
end

-- ==========================================
-- 🔫 DEEP MEMORY SCAN GUN MODS (DARI SCRIPT KEDUA)
-- ==========================================
local function ScanValueMods(tool)
    pcall(function()
        local function SetSafe(attr, value)
            if tool:GetAttribute(attr) ~= nil and tool:GetAttribute(attr) ~= value then
                tool:SetAttribute(attr, value)
            end
        end
        SetSafe("TotalAmmo", 999999); SetSafe("NewMax", 999999); SetSafe("magazineSize", 999999); SetSafe("_ammo", 999999)
        SetSafe("spread", 0); SetSafe("recoilMax", 0); SetSafe("recoilMin", 0); SetSafe("reloadTime", 0.05); SetSafe("rateOfFire", GunConfig.CustomFireRate)

        for _, obj in pairs(tool:GetDescendants()) do
            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                local name = obj.Name:lower()
                if name:find("ammo") or name:find("clip") or name:find("mag") then
                    obj.Value = 999999
                elseif name:find("firerate") or name:find("rpm") or name:find("rate") then
                    if name:find("rpm") then obj.Value = GunConfig.CustomFireRate else obj.Value = 60 / GunConfig.CustomFireRate end
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        if GunConfig.GunModsAktif then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "MaxAmmo") or rawget(v, "ClipSize") or rawget(v, "RPM") or rawget(v, "FireRate") or rawget(v, "rateOfFire") then
                            if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                            if rawget(v, "CurrentAmmo") and type(v.CurrentAmmo) == "number" then v.CurrentAmmo = 999999 end
                            if rawget(v, "MaxAmmo") and type(v.MaxAmmo) == "number" then v.MaxAmmo = 999999 end
                            if rawget(v, "StoredAmmo") and type(v.StoredAmmo) == "number" then v.StoredAmmo = 999999 end
                            if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                            if rawget(v, "Magazine") and type(v.Magazine) == "number" then v.Magazine = 999999 end
                            if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = GunConfig.CustomFireRate end
                            if rawget(v, "FireRate") and type(v.FireRate) == "number" then v.FireRate = 60 / GunConfig.CustomFireRate end
                            if rawget(v, "rateOfFire") and type(v.rateOfFire) == "number" then v.rateOfFire = GunConfig.CustomFireRate end
                            if rawget(v, "Spread") then v.Spread = 0 end
                            if rawget(v, "MaxSpread") then v.MaxSpread = 0 end
                            if rawget(v, "Recoil") then v.Recoil = 0 end
                            if rawget(v, "Kickback") then v.Kickback = 0 end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- MASTER LOOP (RENDERSTEPPED & STEPPED)
-- ==========================================
UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and PlayerConfig.MultiJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
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

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and PlayerConfig.AntiFallDamage and hrp.Velocity.Y < -40 then
            local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -20, 0), RaycastParams.new())
            if hit then hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z) end
        end
        if hum then
            if PlayerConfig.SpeedRun then hum.WalkSpeed = PlayerConfig.SpeedValue else hum.WalkSpeed = 16 end
            if PlayerConfig.MultiJump then hum.UseJumpPower = true; hum.JumpPower = PlayerConfig.JumpPower end
        end
        if PlayerConfig.Wallhack then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- FOV & Aimbot Render
    if MainConfig.ShowFOV then
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = SkillConfig.AimFovSize
        FOVCircle.Visible = SkillConfig.Aimbot and (SkillConfig.AimbotMode == "POV Kamera (FOV)")
    else
        FOVCircle.Visible = false
    end

    if SkillConfig.Aimbot then
        local targetValid = false
        local partToAim = nil
        if LockedTarget and LockedTarget.Parent then
            local hum = LockedTarget:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and IsEnemy(LockedTarget) and not LockedTarget:FindFirstChildOfClass("ForceField") then
                partToAim = GetDynamicTargetPart(LockedTarget)
                if partToAim and IsVisible(partToAim) then
                    if SkillConfig.AimbotMode == "POV Kamera (FOV)" then
                        local pos, onScreen = Camera:WorldToViewportPoint(partToAim.Position)
                        local dist = (screenCenter - Vector2.new(pos.X, pos.Y)).Magnitude
                        if onScreen and dist <= SkillConfig.AimFovSize then targetValid = true end
                    else
                        targetValid = true
                    end
                end
            end
        end

        if not targetValid then
            if SkillConfig.AimbotMode == "360° (Brutal)" then
                LockedTarget = GetNewTarget3D()
            elseif SkillConfig.AimbotMode == "POV Kamera (FOV)" then
                LockedTarget = GetClosestEnemy2D()
            end
            if LockedTarget then partToAim = GetDynamicTargetPart(LockedTarget) end
        end

        if LockedTarget and partToAim then
            if SkillConfig.AimbotMode == "360° (Brutal)" then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, partToAim.Position)
            else
                local smoothFactor = SkillConfig.AimbotSmoothness / 100
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, partToAim.Position), smoothFactor)
            end
            AimbotLine.From = screenCenter
            local pos, onScreen = Camera:WorldToViewportPoint(partToAim.Position)
            if onScreen then
                AimbotLine.To = Vector2.new(pos.X, pos.Y)
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

    -- World Lighting Mods
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

    -- Gun Mods Value Scan loop
    if GunConfig.GunModsAktif then
        if LocalPlayer.Character then
            for _, t in pairs(LocalPlayer.Character:GetChildren()) do
                if t:IsA("Tool") or t:IsA("Model") then ScanValueMods(t) end
            end
        end
        for _, v in pairs(Camera:GetChildren()) do
            if v:IsA("Model") then ScanValueMods(v) end
        end
    end

    -- ESP & Chams Loop
    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local active = MainConfig.ESPAktif and IsEnemy(char) and char and hrp and hum and hum.Health > 0

        -- Chams Logic
        if char and VisualsConfig.Chams and IsEnemy(char) and hum and hum.Health > 0 then
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
            if ChamsCache[player] then ChamsCache[player].Enabled = false end
        end

        if active then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

                -- Skeleton
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

                -- ESP Health Bar
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

