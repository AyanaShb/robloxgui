-- ========================================== --
-- 🎯 LITE HACK + ULTIMATE MODS (CUSTOM MODERN IMGUI)
-- ========================================== --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== --
-- AUTO BYPASS ANTI-CHEAT (TIDAK DIBUANG)
-- ========================================== --
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
        if detour_function then detour_function = function(...) return true end end
        if getconnections then pcall(function() for _, connection in ipairs(getconnections(ScriptContext.Error)) do connection:Disable() end end) end
        if getcallingscript then pcall(function() getcallingscript = function() return nil end end) end
        for _, tableName in ipairs({"_G", "shared"}) do
            pcall(function()
                local target = getgenv()[tableName]
                if target and type(target) == "table" then
                    for key, _ in pairs(target) do
                        local strKey = tostring(key):lower()
                        if strKey:find("signature") or strKey:find("checksum") or strKey:find("hash") then target[key] = nil end
                    end
                end
            end)
        end
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("handshake") or name:find("validate") or name:find("verify") or name:find("integrity") or name:find("anti") then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then remote.FireServer = function(...) return true end
                        elseif remote:IsA("RemoteFunction") then remote.InvokeServer = function(...) return true end end
                    end)
                end
            end
        end
    end)
end)

-- ========================================== --
-- VARIABEL & CONFIG STATE
-- ========================================== --
local ESPEnemy = false
local ESPTeam = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPConfig = { Box = true, Name = true, Line = true, Health = true, Skeleton = false, Distance = true, Picture = false }

local AimbotAktif = false
local TeamCheck = false
local WallCheck = false
local AimbotMode = "Fov" -- "360°" / "Fov"
local TriggerMode = "camera" -- "fire(snap)" / "camera"
local ShowFOV = false
local AimLineTracer = false
local AimTargetMode = "Head" -- "Head" / "Neck" / "Chest"
local AimDistanceMax = 1000

local SpeedAktif = false
local CustomSpeed = 50
local MultiJumpAktif = false
local FlyAktif = false
local RapidFireAktif = false
local UnlimitedAmmoAktif = false

local WorldTime = 14
local NoGravityAktif = false

local IsDarkTheme = true

-- ========================================== --
-- BUILD CUSTOM IMGUI UI
-- ========================================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomImGui_LiteHack"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Themes = {
    Dark = { Bg = Color3.fromRGB(15, 15, 20), Top = Color3.fromRGB(22, 22, 30), Sidebar = Color3.fromRGB(18, 18, 25), Element = Color3.fromRGB(28, 28, 38), Accent = Color3.fromRGB(88, 101, 242), Text = Color3.fromRGB(240, 240, 245), TextDark = Color3.fromRGB(150, 150, 165) },
    Light = { Bg = Color3.fromRGB(240, 240, 245), Top = Color3.fromRGB(220, 220, 228), Sidebar = Color3.fromRGB(230, 230, 238), Element = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(70, 90, 230), Text = Color3.fromRGB(30, 30, 40), TextDark = Color3.fromRGB(100, 100, 115) }
}
local currentTheme = Themes.Dark

-- Floating Icon (Tengkorak 💀)
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0, 30, 0.4, 0)
FloatBtn.BackgroundColor3 = currentTheme.Top
FloatBtn.TextColor3 = currentTheme.Text
FloatBtn.TextSize = 22
FloatBtn.Text = "💀"
FloatBtn.Draggable = true
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

-- Main Window
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = currentTheme.Bg
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Topbar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = currentTheme.Top
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLbl = Instance.new("TextLabel", TopBar)
TitleLbl.Size = UDim2.new(0, 300, 1, 0)
TitleLbl.Position = UDim2.new(0, 10, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.TextColor3 = currentTheme.Text
TitleLbl.TextSize = 13
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.Text = "🎯 Lite Hack + Ultimate Mods"
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Exit (X) untuk stop seluruh script
local ExitBtn = Instance.new("TextButton", TopBar)
ExitBtn.Size = UDim2.new(0, 28, 0, 28)
ExitBtn.Position = UDim2.new(1, -32, 0.5, -14)
ExitBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.TextSize = 12
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.Text = "X"
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)
ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Header (Horizontal Scrolling Unlimited)
local TabBarScroll = Instance.new("ScrollingFrame", MainFrame)
TabBarScroll.Size = UDim2.new(1, 0, 0, 32)
TabBarScroll.Position = UDim2.new(0, 0, 0, 32)
TabBarScroll.BackgroundColor3 = currentTheme.Sidebar
TabBarScroll.BorderSizePixel = 0
TabBarScroll.CanvasSize = UDim2.new(0, 450, 0, 0)
TabBarScroll.ScrollBarThickness = 2

local TabBarLayout = Instance.new("UIListLayout", TabBarScroll)
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBarLayout.Padding = UDim.new(0, 4)

local tabs = {"visual", "player", "aimbot", "world", "config"}
local tabFrames = {}
local tabButtons = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", TabBarScroll)
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = i == 1 and currentTheme.Accent or currentTheme.TextDark
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    tabButtons[name] = btn

    -- Content Frame (Vertical Scrolling Unlimited)
    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -12, 1, -74)
    page.Position = UDim2.new(0, 6, 0, 68)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 4

    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    
    tabFrames[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabFrames) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.TextColor3 = currentTheme.TextDark end
        page.Visible = true
        btn.TextColor3 = currentTheme.Accent
    end)
end

-- ========================================== --
-- UI ELEMENT HELPERS (DINAMIS)
-- ========================================== --
local function AddToggle(tabName, text, default, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = currentTheme.Element
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 32, 0, 18)
    toggleBtn.Position = UDim2.new(1, -38, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
    return { Set = function(v) state = v; toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70); callback(state) end }
end

local function AddButton(tabName, text, callback)
    local parent = tabFrames[tabName]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = currentTheme.Element
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function AddDropdown(tabName, text, options, current, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = currentTheme.Element
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valBtn = Instance.new("TextButton", frame)
    valBtn.Size = UDim2.new(0.45, 0, 0.8, 0)
    valBtn.Position = UDim2.new(0.53, 0, 0.1, 0)
    valBtn.BackgroundColor3 = currentTheme.Top
    valBtn.TextColor3 = currentTheme.Text
    valBtn.TextSize = 11
    valBtn.Font = Enum.Font.GothamBold
    valBtn.Text = tostring(current)
    Instance.new("UICorner", valBtn).CornerRadius = UDim.new(0, 4)

    local idx = 1
    for i, opt in ipairs(options) do if opt == current then idx = i end end

    valBtn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        local selected = options[idx]
        valBtn.Text = tostring(selected)
        callback(selected)
    end)
end

-- ========================================== --
-- POPULATE TABS SESUAI PERMINTAAN
-- ========================================== --

-- 1. TAB VISUAL
AddToggle("visual", "👁️ ESP Enemy", false, function(v) ESPEnemy = v end)
AddToggle("visual", "👥 ESP Team", false, function(v) ESPTeam = v end)
AddButton("visual", "🎨 Ubah Warna ESP (Cycle)", function()
    if ESPColor == Color3.fromRGB(255, 0, 0) then ESPColor = Color3.fromRGB(0, 255, 0)
    elseif ESPColor == Color3.fromRGB(0, 255, 0) then ESPColor = Color3.fromRGB(0, 0, 255)
    else ESPColor = Color3.fromRGB(255, 0, 0) end
end)
AddToggle("visual", "📦 ESP Box", true, function(v) ESPConfig.Box = v end)
AddToggle("visual", "🏷️ ESP Name", true, function(v) ESPConfig.Name = v end)
AddToggle("visual", "📈 ESP Line (Ke Kepala)", true, function(v) ESPConfig.Line = v end)
AddToggle("visual", "❤️ ESP Health (Dinamis Warna)", true, function(v) ESPConfig.Health = v end)
AddToggle("visual", "🦴 ESP Skeleton", false, function(v) ESPConfig.Skeleton = v end)
AddToggle("visual", "📍 ESP Distance", true, function(v) ESPConfig.Distance = v end)
AddToggle("visual", "🖼️ ESP Picture (Avatar Profile)", false, function(v) ESPConfig.Picture = v end)

-- 2. TAB AIMBOT
AddToggle("aimbot", "🎯 Aktifkan Aimbot", false, function(v) AimbotAktif = v end)
AddToggle("aimbot", "👥 Team Check", false, function(v) TeamCheck = v end)
AddToggle("aimbot", "🧱 Wall Check", false, function(v) WallCheck = v end)
AddDropdown("aimbot", "⚙️ Mode Aimbot", {"360°", "Fov"}, "Fov", function(v) AimbotMode = v end)
AddDropdown("aimbot", "⚡ Mode Trigger", {"fire(snap)", "camera"}, "camera", function(v) TriggerMode = v end)
AddToggle("aimbot", "⭕ Tampilkan Aim FOV", false, function(v) ShowFOV = v end)
AddToggle("aimbot", "📏 Aim Line Tracer (Dalam FOV)", false, function(v) AimLineTracer = v end)
AddDropdown("aimbot", "🎯 Target Tubuh", {"Head", "Neck", "Chest"}, "Head", function(v) AimTargetMode = v end)

-- 3. TAB PLAYER
local SpeedToggleRef
SpeedToggleRef = AddToggle("player", "⚡ Speed Run", false, function(v) SpeedAktif = v end)
AddToggle("player", "🚀 Multi Jump Hack", false, function(v) MultiJumpAktif = v end)
AddToggle("player", "🛸 Fly Hack", false, function(v) FlyAktif = v end)
AddToggle("player", "🔫 Rapid Fire (RPM Mods)", false, function(v) RapidFireAktif = v end)
AddToggle("player", "♾️ Unlimited Ammo", false, function(v) UnlimitedAmmoAktif = v end)

-- 4. TAB WORLD
AddDropdown("world", "🌍 Time World", {6, 12, 18, 24}, 14, function(v) WorldTime = tonumber(v) or 14 end)
AddToggle("world", "🪶 No Gravity (Gravitasi Rendah)", false, function(v) NoGravityAktif = v end)

-- 5. TAB CONFIG
AddButton("config", "🎨 Ubah Tema UI (Light / Dark)", function()
    IsDarkTheme = not IsDarkTheme
    currentTheme = IsDarkTheme and Themes.Dark or Themes.Light
    MainFrame.BackgroundColor3 = currentTheme.Bg
    TopBar.BackgroundColor3 = currentTheme.Top
    TabBarScroll.BackgroundColor3 = currentTheme.Sidebar
end)

local ConfigFileName = "LiteHack_Config_Ultimate.json"
AddButton("config", "💾 Save Konfigurasi", function()
    local data = {
        ESPEnemy = ESPEnemy, ESPTeam = ESPTeam, AimbotAktif = AimbotAktif,
        SpeedAktif = SpeedAktif, MultiJumpAktif = MultiJumpAktif, FlyAktif = FlyAktif,
        RapidFireAktif = RapidFireAktif, UnlimitedAmmoAktif = UnlimitedAmmoAktif, NoGravityAktif = NoGravityAktif
    }
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(data)) end
    end)
end)

AddButton("config", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            if decoded.ESPEnemy ~= nil then ESPEnemy = decoded.ESPEnemy end
            if decoded.AimbotAktif ~= nil then AimbotAktif = decoded.AimbotAktif end
        end
    end)
end)

-- ========================================== --
-- LOGIKA FITUR UTAMA & RENDER LOOP
-- ========================================== --
local ValidEntities = {}
task.spawn(function()
    while task.wait(0.5) do
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then table.insert(list, p.Character) end
        end
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) and obj:FindFirstChildOfClass("Humanoid") then
                table.insert(list, obj)
            end
        end
        ValidEntities = list
    end
end)

-- Physics & World Loop
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            if SpeedAktif then hum.WalkSpeed = CustomSpeed end
            if NoGravityAktif then workspace.Gravity = 30 else workspace.Gravity = 196.2 end
        end
    end
end)

-- Multi Jump Handler
UserInputService.JumpRequest:Connect(function()
    if MultiJumpAktif and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Time World Handler
RunService.RenderStepped:Connect(function()
    pcall(function()
        game.Lighting.ClockTime = WorldTime
    end)
end)

-- Gun Mods (Rapid Fire & Unlimited Ammo Integration)
task.spawn(function()
    while task.wait(1) do
        if RapidFireAktif or UnlimitedAmmoAktif then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if UnlimitedAmmoAktif then
                            if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                            if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                        end
                        if RapidFireAktif then
                            if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = 2500 end
                            if rawget(v, "FireRate") and type(v.FireRate) == "number" then v.FireRate = 0.01 end
                        end
                    end
                end
            end)
        end
    end
end)
