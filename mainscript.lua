-- ========================================== --
-- 🎯 LITE HACK + ULTIMATE MODS (CUSTOM IMGUI) --
-- ========================================== --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== --
-- VARIABEL SISTEM & STATE FITUR             --
-- ========================================== --
local ConfigData = {
    -- Visual
    ESPEnemy = false,
    ESPTeam = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPBox = false,
    ESPName = false,
    ESPLine = false,
    ESPHealth = false,
    ESPSkeleton = false,
    ESPDistance = false,
    ESPPicture = false,

    -- Aimbot
    AimbotAktif = false,
    TeamCheck = false,
    WallCheck = true,
    AimbotMode = "FOV", -- "360°" atau "FOV"
    TriggerMode = "Camera", -- "Fire" atau "Camera"
    AimFOV = false,
    FOVRadius = 150,
    AimLineTracer = false,
    AimTarget = "Head", -- "Head", "Neck", "Chest"
    AimDistance = 500,

    -- Player
    SpeedAktif = false,
    CustomSpeed = 50,
    MultiJumpAktif = false,
    FlyAktif = false,
    RapidFireAktif = false,
    CustomFireRate = 800,
    UnlimitedAmmoAktif = false,

    -- World
    WorldTime = 14,
    NoGravity = false,

    -- Config Theme
    IsDarkTheme = true
}

-- ========================================== --
-- CUSTOM IMGUI MODERN UI BUILDER             --
-- ========================================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernImGui_UltimateHack"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Themes = {
    Dark = {
        Bg = Color3.fromRGB(15, 15, 20),
        TopBar = Color3.fromRGB(22, 22, 28),
        Sidebar = Color3.fromRGB(18, 18, 24),
        ElementBg = Color3.fromRGB(26, 26, 35),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(150, 150, 165)
    },
    Light = {
        Bg = Color3.fromRGB(240, 240, 245),
        TopBar = Color3.fromRGB(225, 225, 230),
        Sidebar = Color3.fromRGB(232, 232, 238),
        ElementBg = Color3.fromRGB(215, 215, 225),
        Accent = Color3.fromRGB(70, 90, 230),
        Text = Color3.fromRGB(30, 30, 40),
        TextDark = Color3.fromRGB(100, 100, 115)
    }
}

local currentTheme = ConfigData.IsDarkTheme and Themes.Dark or Themes.Light

-- Main Window
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = currentTheme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Topbar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = currentTheme.TopBar
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = currentTheme.Text
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🎯 Lite Hack + Ultimate Mods (Pro)"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close & Minimize Button
local ExitBtn = Instance.new("TextButton", TopBar)
ExitBtn.Size = UDim2.new(0, 26, 0, 26)
ExitBtn.Position = UDim2.new(1, -30, 0.5, -13)
ExitBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.TextSize = 11
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.Text = "X"
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 5)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -60, 0.5, -13)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 11
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= TopBar then child.Visible = not isMinimized end
    end
    MainFrame.Size = isMinimized and UDim2.new(0, 520, 0, 32) or UDim2.new(0, 520, 0, 340)
end)

ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Header (Horizontal Scrolling)
local TabScroll = Instance.new("ScrollingFrame", MainFrame)
TabScroll.Size = UDim2.new(1, -12, 0, 30)
TabScroll.Position = UDim2.new(0, 6, 0, 36)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.CanvasSize = UDim2.new(0, 450, 0, 0)
TabScroll.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout", TabScroll)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)

local tabs = {"Visual", "Aimbot", "Player", "World", "Config"}
local tabFrames = {}
local tabButtons = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", TabScroll)
    btn.Size = UDim2.new(0, 85, 1, 0)
    btn.BackgroundColor3 = currentTheme.Sidebar
    btn.TextColor3 = i == 1 and currentTheme.Accent or currentTheme.TextDark
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    tabButtons[name] = btn

    -- Content Scroll Frame (Vertical Unlimited Scroll)
    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -12, 1, -74)
    page.Position = UDim2.new(0, 6, 0, 70)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3

    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)

    tabFrames[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabFrames) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.TextColor3 = currentTheme.TextDark; b.BackgroundColor3 = currentTheme.Sidebar end
        page.Visible = true
        btn.TextColor3 = currentTheme.Accent
        btn.BackgroundColor3 = currentTheme.ElementBg
    end)
end
tabButtons["Visual"].BackgroundColor3 = currentTheme.ElementBg

-- ========================================== --
-- UI ELEMENT GENERATORS                      --
-- ========================================== --
local function AddToggle(tabName, text, defaultVal, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = currentTheme.ElementBg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 32, 0, 18)
    toggleBtn.Position = UDim2.new(1, -38, 0.5, -9)
    toggleBtn.BackgroundColor3 = defaultVal and currentTheme.Accent or Color3.fromRGB(50, 50, 60)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 60)
        callback(state)
    end)
    return {
        Set = function(val)
            state = val
            toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 60)
            callback(state)
        end
    }
end

local function AddButton(tabName, text, callback)
    local parent = tabFrames[tabName]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = currentTheme.ElementBg
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function AddSlider(tabName, text, min, max, defaultVal, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = currentTheme.ElementBg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -15, 0, 20)
    lbl.Position = UDim2.new(0, 8, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text .. ": " .. tostring(defaultVal)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBar = Instance.new("Frame", frame)
    sliderBar.Size = UDim2.new(1, -16, 0, 6)
    sliderBar.Position = UDim2.new(0, 8, 0, 28)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

    local fillBar = Instance.new("Frame", sliderBar)
    fillBar.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
    fillBar.BackgroundColor3 = currentTheme.Accent
    Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)

    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            fillBar.Size = UDim2.new(pos, 0, 1, 0)
            lbl.Text = text .. ": " .. tostring(val)
            callback(val)
        end
    end)
end

local function AddDropdown(tabName, text, options, defaultOpt, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = currentTheme.ElementBg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local currentIdx = 1
    for i, opt in ipairs(options) do if opt == defaultOpt then currentIdx = i end end

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.45, 0, 0, 22)
    btn.Position = UDim2.new(0.55, -8, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Text = defaultOpt
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        local chosen = options[currentIdx]
        btn.Text = chosen
        callback(chosen)
    end)
end

-- ========================================== --
-- POPULASI ISI MENU / TAB                    --
-- ========================================== --

-- 1. TAB VISUAL
AddToggle("Visual", "👁️ ESP Enemy", ConfigData.ESPEnemy, function(v) ConfigData.ESPEnemy = v end)
AddToggle("Visual", "👥 ESP Team", ConfigData.ESPTeam, function(v) ConfigData.ESPTeam = v end)
AddToggle("Visual", "📦 ESP Box", ConfigData.ESPBox, function(v) ConfigData.ESPBox = v end)
AddToggle("Visual", "🏷️ ESP Name", ConfigData.ESPName, function(v) ConfigData.ESPName = v end)
AddToggle("Visual", "📈 ESP Line (Ke Kepala)", ConfigData.ESPLine, function(v) ConfigData.ESPLine = v end)
AddToggle("Visual", "❤️ ESP Health Bar", ConfigData.ESPHealth, function(v) ConfigData.ESPHealth = v end)
AddToggle("Visual", "🦴 ESP Skeleton", ConfigData.ESPSkeleton, function(v) ConfigData.ESPSkeleton = v end)
AddToggle("Visual", "📏 ESP Distance", ConfigData.ESPDistance, function(v) ConfigData.ESPDistance = v end)
AddToggle("Visual", "🖼️ ESP Profile Picture", ConfigData.ESPPicture, function(v) ConfigData.ESPPicture = v end)

-- 2. TAB AIMBOT
AddToggle("Aimbot", "🎯 Aktifkan Aimbot", ConfigData.AimbotAktif, function(v) ConfigData.AimbotAktif = v end)
AddToggle("Aimbot", "🛡️ Team Check", ConfigData.TeamCheck, function(v) ConfigData.TeamCheck = v end)
AddToggle("Aimbot", "🧱 Wall Check", ConfigData.WallCheck, function(v) ConfigData.WallCheck = v end)
AddDropdown("Aimbot", "⚙️ Mode Aimbot", {"FOV", "360°"}, ConfigData.AimbotMode, function(v) ConfigData.AimbotMode = v end)
AddDropdown("Aimbot", "🔥 Mode Trigger", {"Camera", "Fire"}, ConfigData.TriggerMode, function(v) ConfigData.TriggerMode = v end)
AddToggle("Aimbot", "⭕ Tampilkan FOV Circle", ConfigData.AimFOV, function(v) ConfigData.AimFOV = v end)
AddSlider("Aimbot", "📏 Ukuran FOV Radius", 30, 400, ConfigData.FOVRadius, function(v) ConfigData.FOVRadius = v end)
AddToggle("Aimbot", "🔗 Aim Line Tracer (Dalam FOV)", ConfigData.AimLineTracer, function(v) ConfigData.AimLineTracer = v end)
AddDropdown("Aimbot", "🎯 Target Badan", {"Head", "Neck", "Chest"}, ConfigData.AimTarget, function(v) ConfigData.AimTarget = v end)
AddSlider("Aimbot", "🌐 Jarak Maksimum Aimbot (m)", 50, 2000, ConfigData.AimDistance, function(v) ConfigData.AimDistance = v end)

-- 3. TAB PLAYER
AddToggle("Player", "⚡ Custom Speed Run", ConfigData.SpeedAktif, function(v) ConfigData.SpeedAktif = v end)
AddSlider("Player", "🏃 Nilai Speed", 16, 200, ConfigData.CustomSpeed, function(v) ConfigData.CustomSpeed = v end)
AddToggle("Player", "🚀 Multi-Jump Hack", ConfigData.MultiJumpAktif, function(v) ConfigData.MultiJumpAktif = v end)
AddToggle("Player", "✈️ Fly Hack", ConfigData.FlyAktif, function(v) ConfigData.FlyAktif = v end)
AddToggle("Player", "⚡ Rapid Fire (RPM)", ConfigData.RapidFireAktif, function(v) ConfigData.RapidFireAktif = v end)
AddSlider("Player", "⚙️ RPM Fire Rate", 400, 3000, ConfigData.CustomFireRate, function(v) ConfigData.CustomFireRate = v end)
AddToggle("Player", "♾️ Unlimited Ammo", ConfigData.UnlimitedAmmoAktif, function(v) ConfigData.UnlimitedAmmoAktif = v end)

-- 4. TAB WORLD
AddSlider("World", "⏰ Time World (Jam)", 0, 24, 14, function(v) Lighting.ClockTime = v end)
AddToggle("World", "🪶 No Gravity (Low Gravity)", ConfigData.NoGravity, function(v) 
    ConfigData.NoGravity = v 
    workspace.Gravity = v and 30 or 196.2 
end)

-- 5. TAB CONFIG
AddButton("Config", "🎨 Ubah Tema Light / Dark", function()
    ConfigData.IsDarkTheme = not ConfigData.IsDarkTheme
    currentTheme = ConfigData.IsDarkTheme and Themes.Dark or Themes.Light
    MainFrame.BackgroundColor3 = currentTheme.Bg
    TopBar.BackgroundColor3 = currentTheme.TopBar
    TitleLabel.TextColor3 = currentTheme.Text
    for _, b in pairs(tabButtons) do b.BackgroundColor3 = currentTheme.Sidebar; b.TextColor3 = currentTheme.TextDark end
end)

local ConfigFileName = "LiteHack_UltimateConfig.json"
AddButton("Config", "💾 Save Konfigurasi", function()
    pcall(function()
        if writefile then
            local dataToSave = {
                ESPEnemy = ConfigData.ESPEnemy, ESPTeam = ConfigData.ESPTeam, ESPBox = ConfigData.ESPBox,
                ESPName = ConfigData.ESPName, ESPLine = ConfigData.ESPLine, ESPHealth = ConfigData.ESPHealth,
                ESPSkeleton = ConfigData.ESPSkeleton, ESPDistance = ConfigData.ESPDistance, ESPPicture = ConfigData.ESPPicture,
                AimbotAktif = ConfigData.AimbotAktif, TeamCheck = ConfigData.TeamCheck, WallCheck = ConfigData.WallCheck,
                AimbotMode = ConfigData.AimbotMode, TriggerMode = ConfigData.TriggerMode, AimFOV = ConfigData.AimFOV,
                FOVRadius = ConfigData.FOVRadius, AimLineTracer = ConfigData.AimLineTracer, AimTarget = ConfigData.AimTarget,
                AimDistance = ConfigData.AimDistance, SpeedAktif = ConfigData.SpeedAktif, CustomSpeed = ConfigData.CustomSpeed,
                MultiJumpAktif = ConfigData.MultiJumpAktif, FlyAktif = ConfigData.FlyAktif, RapidFireAktif = ConfigData.RapidFireAktif,
                CustomFireRate = ConfigData.CustomFireRate, UnlimitedAmmoAktif = ConfigData.UnlimitedAmmoAktif, NoGravity = ConfigData.NoGravity
            }
            writefile(ConfigFileName, HttpService:JSONEncode(dataToSave))
        end
    end)
end)

AddButton("Config", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local loaded = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(loaded) do ConfigData[k] = v end
        end
    end)
end)

-- ========================================== --
-- LOGIKA UTAMA EKSEKUSI (ESP & AIMBOT DLL)   --
-- ========================================== --

-- FOV Ring Instance
local FOVGui = Instance.new("ScreenGui", CoreGui)
FOVGui.Name = "Universal_FOV_System"
FOVGui.IgnoreGuiInset = true
local FOVFrame = Instance.new("Frame", FOVGui)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

-- ESP & Visual Engine
local ESPFolder = CoreGui:FindFirstChild("Universal_ESP_Folder") or Instance.new("Folder", CoreGui)
ESPFolder.Name = "Universal_ESP_Folder"
local ActiveESPs = {}

local function CreateESPElements(model)
    local data = {}
    local hl = Instance.new("Highlight", ESPFolder)
    hl.Adornee = model
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    data.Highlight = hl

    local bgui = Instance.new("BillboardGui", ESPFolder)
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 150, 0, 80)
    bgui.ExtentsOffset = Vector3.new(0, 3.5, 0)
    data.Gui = bgui

    local nameLbl = Instance.new("TextLabel", bgui)
    nameLbl.Size = UDim2.new(1, 0, 0, 16)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.Code
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextStrokeTransparency = 0
    data.NameLbl = nameLbl

    local distLbl = Instance.new("TextLabel", bgui)
    distLbl.Size = UDim2.new(1, 0, 0, 16)
    distLbl.Position = UDim2.new(0, 0, 0, 36)
    distLbl.BackgroundTransparency = 1
    distLbl.TextSize = 11
    distLbl.Font = Enum.Font.Code
    distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLbl.TextStrokeTransparency = 0
    data.DistLbl = distLbl

    local img = Instance.new("ImageLabel", bgui)
    img.Size = UDim2.new(0, 28, 0, 28)
    img.Position = UDim2.new(0.5, -14, 0, -32)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://0"
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
    data.Img = img

    local healthBarBg = Instance.new("Frame", bgui)
    healthBarBg.Size = UDim2.new(0, 4, 0, 30)
    healthBarBg.Position = UDim2.new(0, -8, 0, 18)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    data.HealthBarBg = healthBarBg

    local healthBar = Instance.new("Frame", healthBarBg)
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    data.HealthBar = healthBar

    return data
end

RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOVFrame.Size = UDim2.new(0, ConfigData.FOVRadius * 2, 0, ConfigData.FOVRadius * 2)
    FOVFrame.Visible = ConfigData.AimbotAktif and ConfigData.AimFOV and ConfigData.AimbotMode == "FOV"

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)
            local shouldShow = (isTeam and ConfigData.ESPTeam) or (not isTeam and ConfigData.ESPEnemy)

            if char and hum and hum.Health > 0 and hrp and head and shouldShow then
                if not ActiveESPs[p] then ActiveESPs[p] = CreateESPElements(char) end
                local esp = ActiveESPs[p]

                esp.Highlight.Enabled = ConfigData.ESPBox
                esp.Gui.Enabled = true

                -- Nama & Jarak
                esp.NameLbl.Visible = ConfigData.ESPName
                esp.NameLbl.Text = p.Name
                
                local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                esp.DistLbl.Visible = ConfigData.ESPDistance
                esp.DistLbl.Text = "[" .. dist .. "m]"

                -- Health Bar Dinamis (Hijau -> Oranye -> Merah Gelap)
                esp.HealthBarBg.Visible = ConfigData.ESPHealth
                local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                esp.HealthBar.Size = UDim2.new(1, 0, healthPct, 0)
                if healthPct > 0.7 then
                    esp.HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPct > 0.4 then
                    esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                else
                    esp.HealthBar.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
                end

                -- Avatar Bulat di Atas Kepala
                esp.Img.Visible = ConfigData.ESPPicture
                if ConfigData.ESPPicture and esp.Img.Image == "rbxassetid://0" then
                    pcall(function()
                        local content = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
                        esp.Img.Image = content
                    end)
                end
            else
                if ActiveESPs[p] then
                    ActiveESPs[p].Highlight:Destroy()
                    ActiveESPs[p].Gui:Destroy()
                    ActiveESPs[p] = nil
                end
            end
        end
    end
end)

-- Player Hacks & Movement Logic
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            if ConfigData.SpeedAktif then hum.WalkSpeed = ConfigData.CustomSpeed end
        end
        if hrp and ConfigData.FlyAktif then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if ConfigData.MultiJumpAktif and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
