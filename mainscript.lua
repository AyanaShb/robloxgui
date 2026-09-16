-- ========================================== -- 🎯 LITE HACK + ULTIMATE MODS (CUSTOM IMGUI MODERN v2) -- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== -- AUTO BYPASS ANTI-CHEAT -- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
    end)
end)

-- ========================================== -- VARIABEL SISTEM & STATE -- ==========================================
local ConfigState = {
    -- Visual
    ESPEnemy = false,
    ESPTeam = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    OptBox = true,
    OptName = true,
    OptLine = true,
    OptHealth = true,
    OptSkeleton = false,
    OptDistance = true,
    OptPicture = true,
    
    -- Aimbot
    AimbotAktif = false,
    TeamCheck = false,
    WallCheck = false,
    AimbotMode = "Fov", -- {360°/Fov}
    TriggerMode = "Fov", -- fire(snap)/camera
    ShowFOV = false,
    FOVRadius = 150,
    AimLine = false,
    AimTarget = "Head", -- Head/Neck/Chest
    AimDistance = 1000,
    
    -- Player
    CustomSpeed = 50,
    SpeedAktif = false,
    MultiJump = false,
    FlyAktif = false,
    RapidFire = false,
    InfiniteAmmo = false,
    
    -- World
    WorldTime = 14,
    TimeAktif = false,
    NoGravity = false,
    
    -- Config
    IsDarkTheme = true
}

-- ========================================== -- CUSTOM IMGUI MODERN UI BUILDER -- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernImGui_Advanced"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Themes = {
    Dark = {
        Bg = Color3.fromRGB(18, 18, 22),
        TopBar = Color3.fromRGB(25, 25, 32),
        Sidebar = Color3.fromRGB(22, 22, 28),
        ElementBg = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(160, 160, 175)
    },
    Light = {
        Bg = Color3.fromRGB(245, 245, 250),
        TopBar = Color3.fromRGB(230, 230, 235),
        Sidebar = Color3.fromRGB(238, 238, 242),
        ElementBg = Color3.fromRGB(220, 220, 228),
        Accent = Color3.fromRGB(70, 90, 230),
        Text = Color3.fromRGB(30, 30, 40),
        TextDark = Color3.fromRGB(100, 100, 115)
    }
}
local currentTheme = Themes.Dark

-- Main Window
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
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
TitleLabel.Text = "🎯 Lite Hack + Ultimate Mods (Dynamic UI)"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize & Exit Button
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
        if child ~= TopBar and child ~= MainFrame:FindFirstChildOfClass("UICorner") then
            child.Visible = not isMinimized
        end
    end
    MainFrame.Size = isMinimized and UDim2.new(0, 520, 0, 32) or UDim2.new(0, 520, 0, 360)
end)
ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Horizontal Scrollable Tab Header (Visual, Player, Aimbot, World, Config)
local TabHeaderScroll = Instance.new("ScrollingFrame", MainFrame)
TabHeaderScroll.Size = UDim2.new(1, 0, 0, 32)
TabHeaderScroll.Position = UDim2.new(0, 0, 0, 32)
TabHeaderScroll.BackgroundColor3 = currentTheme.Sidebar
TabHeaderScroll.BorderSizePixel = 0
TabHeaderScroll.CanvasSize = UDim2.new(0, 450, 0, 0)
TabHeaderScroll.ScrollBarThickness = 2

local TabHeaderLayout = Instance.new("UIListLayout", TabHeaderScroll)
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Padding = UDim.new(0, 4)

local tabs = {"Visual", "Player", "Aimbot", "World", "Config"}
local tabFrames = {}
local tabButtons = {}

for _, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", TabHeaderScroll)
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = currentTheme.TextDark
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    tabButtons[name] = btn

    -- Vertical Scrollable Content Page
    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -12, 1, -74)
    page.Position = UDim2.new(0, 6, 0, 68)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 4
    
    local list = Instance.new("UIListLayout", page)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    
    tabFrames[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabFrames) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.TextColor3 = currentTheme.TextDark end
        page.Visible = true
        btn.TextColor3 = currentTheme.Accent
    end)
end
tabFrames["Visual"].Visible = true
tabButtons["Visual"].TextColor3 = currentTheme.Accent

-- Helper UI Elements
local function AddToggle(tabName, text, defaultVal, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 32)
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
    toggleBtn.BackgroundColor3 = defaultVal and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
    return { Set = function(v) state = v; toggleBtn.BackgroundColor3 = v and currentTheme.Accent or Color3.fromRGB(60,60,70); callback(v) end }
end

local function AddButton(tabName, text, callback)
    local parent = tabFrames[tabName]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = currentTheme.ElementBg
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========================================== -- PENGISIAN KONTEN TAB -- ==========================================

-- 1. TAB VISUAL
AddToggle("Visual", "👁️ ESP Enemy", ConfigState.ESPEnemy, function(v) ConfigState.ESPEnemy = v end)
AddToggle("Visual", "👥 ESP Team", ConfigState.ESPTeam, function(v) ConfigState.ESPTeam = v end)

-- Checklist Box ESP Elements
AddToggle("Visual", "📦 ESP Box", ConfigState.OptBox, function(v) ConfigState.OptBox = v end)
AddToggle("Visual", "🏷️ ESP Name (Di atas Box)", ConfigState.OptName, function(v) ConfigState.OptName = v end)
AddToggle("Visual", "📈 ESP Line (Ke Kepala)", ConfigState.OptLine, function(v) ConfigState.OptLine = v end)
AddToggle("Visual", "❤️ ESP Health (Volume Dinamis Samping)", ConfigState.OptHealth, function(v) ConfigState.OptHealth = v end)
AddToggle("Visual", "🦴 ESP Skeleton", ConfigState.OptSkeleton, function(v) ConfigState.OptSkeleton = v end)
AddToggle("Visual", "📏 ESP Distance (Di bawah Box)", ConfigState.OptDistance, function(v) ConfigState.OptDistance = v end)
AddToggle("Visual", "🖼️ ESP Picture (Thumbnail Profil Bulat)", ConfigState.OptPicture, function(v) ConfigState.OptPicture = v end)

-- 2. TAB AIMBOT
AddToggle("Aimbot", "🎯 Aktifkan Aimbot", ConfigState.AimbotAktif, function(v) ConfigState.AimbotAktif = v end)
AddToggle("Aimbot", "👥 Team Check", ConfigState.TeamCheck, function(v) ConfigState.TeamCheck = v end)
AddToggle("Aimbot", "🧱 Wall Check", ConfigState.WallCheck, function(v) ConfigState.WallCheck = v end)
AddToggle("Aimbot", "⭕ Tampilkan Lingkaran FOV", ConfigState.ShowFOV, function(v) ConfigState.ShowFOV = v end)
AddToggle("Aimbot", "📉 Aim Line Tracer (Dalam FOV)", ConfigState.AimLine, function(v) ConfigState.AimLine = v end)

AddButton("Aimbot", "⚙️ Mode Aimbot: " .. ConfigState.AimbotMode, function(btn)
    ConfigState.AimbotMode = ConfigState.AimbotMode == "Fov" and "360°" or "Fov"
    btn.Text = "⚙️ Mode Aimbot: " .. ConfigState.AimbotMode
end)

AddButton("Aimbot", "⚡ Trigger Mode: " .. ConfigState.TriggerMode, function(btn)
    ConfigState.TriggerMode = ConfigState.TriggerMode == "Fov" and "Camera" or "Fov"
    btn.Text = "⚡ Trigger Mode: " .. ConfigState.TriggerMode
end)

AddButton("Aimbot", "🎯 Aim Target: " .. ConfigState.AimTarget, function(btn)
    if ConfigState.AimTarget == "Head" then ConfigState.AimTarget = "Neck"
    elseif ConfigState.AimTarget == "Neck" then ConfigState.AimTarget = "Chest"
    else ConfigState.AimTarget = "Head" end
    btn.Text = "🎯 Aim Target: " .. ConfigState.AimTarget
end)

-- 3. TAB PLAYER
AddToggle("Player", "⚡ Custom Speed Run", ConfigState.SpeedAktif, function(v) ConfigState.SpeedAktif = v end)
AddToggle("Player", "🚀 Multi Jump Hack", ConfigState.MultiJump, function(v) ConfigState.MultiJump = v end)
AddToggle("Player", "🦅 Fly Hack", ConfigState.FlyAktif, function(v) ConfigState.FlyAktif = v end)
AddToggle("Player", "🔥 Rapid Fire", ConfigState.RapidFire, function(v) ConfigState.RapidFire = v end)
AddToggle("Player", "♾️ Unlimited Ammo", ConfigState.InfiniteAmmo, function(v) ConfigState.InfiniteAmmo = v end)

-- 4. TAB WORLD
AddToggle("World", "⏰ Custom World Time", ConfigState.TimeAktif, function(v) ConfigState.TimeAktif = v end)
AddToggle("World", "🪶 No Gravity (Gravitasi Rendah)", ConfigState.NoGravity, function(v) ConfigState.NoGravity = v end)

-- 5. TAB CONFIG
AddButton("Config", "🎨 Ubah Tema UI (Light / Dark)", function()
    ConfigState.IsDarkTheme = not ConfigState.IsDarkTheme
    currentTheme = ConfigState.IsDarkTheme and Themes.Dark or Themes.Light
    MainFrame.BackgroundColor3 = currentTheme.Bg
    TopBar.BackgroundColor3 = currentTheme.TopBar
    TabHeaderScroll.BackgroundColor3 = currentTheme.Sidebar
    TitleLabel.TextColor3 = currentTheme.Text
end)

local SaveFileName = "LiteHack_Advanced_Config.json"
AddButton("Config", "💾 Save Konfigurasi & Status", function()
    pcall(function()
        if writefile then
            writefile(SaveFileName, HttpService:JSONEncode(ConfigState))
        end
    end)
end)

AddButton("Config", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(SaveFileName) then
            local data = HttpService:JSONDecode(readfile(SaveFileName))
            for k, v in pairs(data) do ConfigState[k] = v end
        end
    end)
end)

-- ========================================== -- LOGIKA CORE EKSEKUSI (ESP & MODS) -- ==========================================
local ESP_Container = CoreGui:FindFirstChild("Advanced_ESP_Folder") or Instance.new("Folder", CoreGui)
ESP_Container.Name = "Advanced_ESP_Folder"
local ActiveDrawings = {}

RunService.RenderStepped:Connect(function()
    -- World Time & Gravity Logic
    if ConfigState.TimeAktif then
        pcall(function() game.Lighting.ClockTime = ConfigState.WorldTime end)
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        workspace.Gravity = ConfigState.NoGravity and 30 or 196.2
        if ConfigState.SpeedAktif and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = ConfigState.CustomSpeed
        end
    end

    -- ESP Rendering Loop
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild_OfClass("Humanoid")
            
            local isTeam = (plr.TeamColor == LocalPlayer.TeamColor)
            local shouldShow = (isTeam and ConfigState.ESPTeam) or (not isTeam and ConfigState.ESPEnemy)

            if char and hrp and head and hum and hum.Health > 0 and shouldShow then
                if not ActiveDrawings[plr] then
                    ActiveDrawings[plr] = {
                        Box = Drawing.new("Square"),
                        Name = Drawing.new("Text"),
                        Line = Drawing.new("Line"),
                        HealthBack = Drawing.new("Square"),
                        HealthBar = Drawing.new("Square"),
                        Distance = Drawing.new("Text"),
                        Picture = Drawing.new("Image") or nil
                    }
                    ActiveDrawings[plr].Box.Visible = false
                    ActiveDrawings[plr].Name.Visible = false
                    ActiveDrawings[plr].Line.Visible = false
                    ActiveDrawings[plr].HealthBack.Visible = false
                    ActiveDrawings[plr].HealthBar.Visible = false
                    ActiveDrawings[plr].Distance.Visible = false
                end

                local d = ActiveDrawings[plr]
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                if onScreen then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2

                    -- Box ESP
                    if ConfigState.OptBox then
                        d.Box.Size = Vector2.new(width, height)
                        d.Box.Position = Vector2.new(headPos.X - width / 2, headPos.Y)
                        d.Box.Color = ConfigState.ESPColor
                        d.Box.Thickness = 2
                        d.Box.Visible = true
                    else d.Box.Visible = false end

                    -- Name (Di atas Box)
                    if ConfigState.OptName then
                        d.Name.Text = plr.Name
                        d.Name.Size = 13
                        d.Name.Center = true
                        d.Name.Position = Vector2.new(headPos.X, headPos.Y - 18)
                        d.Name.Color = Color3.fromRGB(255, 255, 255)
                        d.Name.Visible = true
                    else d.Name.Visible = false end

                    -- Line (Ke Kepala)
                    if ConfigState.OptLine then
                        d.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        d.Line.To = Vector2.new(headPos.X, headPos.Y)
                        d.Line.Color = ConfigState.ESPColor
                        d.Line.Thickness = 1.5
                        d.Line.Visible = true
                    else d.Line.Visible = false end

                    -- Health Bar Dinamis (Samping Kanan Box)
                    if ConfigState.OptHealth then
                        local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barHeight = height * healthPercent
                        d.HealthBack.Size = Vector2.new(3, height)
                        d.HealthBack.Position = Vector2.new(headPos.X + width / 2 + 4, headPos.Y)
                        d.HealthBack.Color = Color3.fromRGB(0, 0, 0)
                        d.HealthBack.Filled = true
                        d.HealthBack.Visible = true

                        d.HealthBar.Size = Vector2.new(2, barHeight)
                        d.HealthBar.Position = Vector2.new(headPos.X + width / 2 + 4.5, headPos.Y + (height - barHeight))
                        d.HealthBar.Filled = true
                        d.HealthBar.Visible = true
                        
                        -- Warna Volume Dinamis: 100% Hijau | 70% Orange | 40% Merah Gelap
                        if healthPercent > 0.7 then
                            d.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.4 then
                            d.HealthBar.Color = Color3.fromRGB(255, 165, 0)
                        else
                            d.HealthBar.Color = Color3.fromRGB(139, 0, 0)
                        end
                    else
                        d.HealthBack.Visible = false
                        d.HealthBar.Visible = false
                    end

                    -- Distance (Di bawah Box)
                    if ConfigState.OptDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        d.Distance.Text = "[" .. dist .. "m]"
                        d.Distance.Size = 12
                        d.Distance.Center = true
                        d.Distance.Position = Vector2.new(headPos.X, headPos.Y + height + 4)
                        d.Distance.Color = Color3.fromRGB(255, 255, 255)
                        d.Distance.Visible = true
                    else d.Distance.Visible = false end
                else
                    for _, drawing in pairs(d) do
                        if typeof(drawing) == "table" and drawing.Visible then drawing.Visible = false end
                    end
                end
            elseif ActiveDrawings[plr] then
                for _, drawing in pairs(ActiveDrawings[plr]) do
                    if typeof(drawing) == "table" then drawing.Visible = false end
                end
            end
        end
    end
end)

-- Multi Jump Handler
UserInputService.JumpRequest:Connect(function()
    if ConfigState.MultiJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
