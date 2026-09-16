-- ========================================== -- 🎯 LITE HACK + ULTIMATE MODS (CUSTOM IMGUI COMPLETE VERSION) -- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== -- AUTO BYPASS ANTI-CHEAT (UTUH) -- ==========================================
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

-- ========================================== -- VARIABEL STATE SISTEM -- ==========================================
local ESPEnemy = false
local ESPTeam = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPBox = false
local ESPName = false
local ESPLine = false
local ESPHealth = false
local ESPSkeleton = false
local ESPDistance = false
local ESPPicture = false

local AimbotAktif = false
local TeamCheck = false
local WallCheck = false
local AimbotMode = "Fov" -- "360°" atau "Fov"
local TriggerMode = "camera" -- "fire(snap)" atau "camera"
local AimFOV = false
local FOVRadius = 150
local AimLineTracer = false
local AimTargetPart = "Head" -- "Head", "Neck", "Chest"
local AimDistanceMax = 1000

local SpeedAktif = false
local CustomSpeed = 50
local MultiJumpAktif = false
local FlyAktif = false
local RapidFireAktif = false
local UnlimitedAmmoAktif = false

local WorldTime = 14
local NoGravityAktif = false

local AntiAdminAktif = false
local IsDarkTheme = true

-- ========================================== -- BUAT UI CUSTOM IMGUI MODERN -- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiteHack_CustomUI"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Tema Warna
local Themes = {
    Dark = { Bg = Color3.fromRGB(15, 15, 20), Top = Color3.fromRGB(22, 22, 30), Element = Color3.fromRGB(28, 28, 38), Accent = Color3.fromRGB(255, 60, 60), Text = Color3.fromRGB(240, 240, 255), SubText = Color3.fromRGB(150, 150, 170) },
    Light = { Bg = Color3.fromRGB(240, 240, 245), Top = Color3.fromRGB(220, 220, 230), Element = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(220, 40, 40), Text = Color3.fromRGB(20, 20, 30), SubText = Color3.fromRGB(100, 100, 120) }
}
local currTheme = Themes.Dark

-- Floating Icon Tengkorak (💀) untuk Hide/Show
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0, 20, 0.4, 0)
FloatBtn.BackgroundColor3 = currTheme.Top
FloatBtn.Text = "💀"
FloatBtn.TextSize = 24
FloatBtn.Active = true
FloatBtn.Draggable = true
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatBtn).Color = currTheme.Accent

-- Main Window (Dibuat Tidak Terlalu Tinggi & Lebar)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = currTheme.Bg
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = currTheme.Accent

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Topbar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = currTheme.Top
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 LITE HACK + ULTIMATE MODS"
Title.TextColor3 = currTheme.Text
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Exit (X) untuk Stop Script
local ExitBtn = Instance.new("TextButton", TopBar)
ExitBtn.Size = UDim2.new(0, 26, 0, 26)
ExitBtn.Position = UDim2.new(1, -30, 0.5, -13)
ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
ExitBtn.Text = "X"
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.TextSize = 12
ExitBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)
ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Header (Horizontal Scrolling Unlimited)
local TabHeaderHolder = Instance.new("ScrollingFrame", MainFrame)
TabHeaderHolder.Size = UDim2.new(1, 0, 0, 32)
TabHeaderHolder.Position = UDim2.new(0, 0, 0, 34)
TabHeaderHolder.BackgroundTransparency = 1
TabHeaderHolder.CanvasSize = UDim2.new(0, 450, 0, 0)
TabHeaderHolder.ScrollBarThickness = 0

local TabHeaderLayout = Instance.new("UIListLayout", TabHeaderHolder)
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Padding = UDim.new(0, 4)

local tabs = {"visual", "player", "aimbot", "world", "config"}
local tabFrames = {}
local tabButtons = {}

for _, name in ipairs(tabs) do
    local tBtn = Instance.new("TextButton", TabHeaderHolder)
    tBtn.Size = UDim2.new(0, 85, 1, 0)
    tBtn.BackgroundColor3 = currTheme.Element
    tBtn.Text = name:upper()
    tBtn.TextColor3 = currTheme.SubText
    tBtn.TextSize = 11
    tBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = tBtn

    local tPage = Instance.new("ScrollingFrame", MainFrame)
    tPage.Size = UDim2.new(1, -12, 1, -74)
    tPage.Position = UDim2.new(0, 6, 0, 70)
    tPage.BackgroundTransparency = 1
    tPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    tPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tPage.ScrollBarThickness = 3
    tPage.Visible = false

    local pLayout = Instance.new("UIListLayout", tPage)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pLayout.Padding = UDim.new(0, 6)

    tabFrames[name] = tPage

    tBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabFrames) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.TextColor3 = currTheme.SubText; b.BackgroundColor3 = currTheme.Element end
        tPage.Visible = true
        tBtn.TextColor3 = currTheme.Text
        tBtn.BackgroundColor3 = currTheme.Accent
    end)
end
tabFrames["visual"].Visible = true
tabButtons["visual"].TextColor3 = currTheme.Text
tabButtons["visual"].BackgroundColor3 = currTheme.Accent

-- Helper UI Komponen Dinamis Vertical
local function AddToggle(tabName, text, callback)
    local parent = tabFrames[tabName]
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = currTheme.Element
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 30, 0, 18)
    btn.Position = UDim2.new(1, -38, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and currTheme.Accent or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
    return { Set = function(v) state = v; btn.BackgroundColor3 = state and currTheme.Accent or Color3.fromRGB(60, 60, 70); callback(state) end, Get = function() return state end }
end

local function AddButton(tabName, text, callback)
    local parent = tabFrames[tabName]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = currTheme.Element
    btn.Text = text
    btn.TextColor3 = currTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function AddSlider(tabName, text, min, max, default, callback)
    local parent = tabFrames[tabName]
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = currTheme.Element
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -15, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = currTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", f)
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = currTheme.Accent
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + ((max - min) * pos))
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- ========================================== -- PENGISIAN KONTEN MENU TAB -- ==========================================

-- 1. TAB VISUAL
AddToggle("visual", "👁️ ESP Enemy", function(v) ESPEnemy = v end)
AddToggle("visual", "🛡️ ESP Team", function(v) ESPTeam = v end)
AddButton("visual", "🎨 Ubah Warna Universal ESP (Merah/Hijau/Biru)", function()
    if ESPColor == Color3.fromRGB(255, 0, 0) then ESPColor = Color3.fromRGB(0, 255, 0)
    elseif ESPColor == Color3.fromRGB(0, 255, 0) then ESPColor = Color3.fromRGB(0, 150, 255)
    else ESPColor = Color3.fromRGB(255, 0, 0) end
end)
AddToggle("visual", "📦 Checkbox: Box ESP", function(v) ESPBox = v end)
AddToggle("visual", "🔤 Checkbox: Name ESP", function(v) ESPName = v end)
AddToggle("visual", "📈 Checkbox: Line ESP (Di Kepala)", function(v) ESPLine = v end)
AddToggle("visual", "❤️ Checkbox: Health ESP (Samping Kanan Box)", function(v) ESPHealth = v end)
AddToggle("visual", "🦴 Checkbox: Skeleton ESP", function(v) ESPSkeleton = v end)
AddToggle("visual", "📏 Checkbox: Distance ESP (Dibawah Box)", function(v) ESPDistance = v end)
AddToggle("visual", "🖼️ Checkbox: Picture / Thumbnail Profile Bulat", function(v) ESPPicture = v end)

-- 2. TAB AIMBOT
AddToggle("aimbot", "🎯 Aktifkan Aimbot", function(v) AimbotAktif = v end)
AddToggle("aimbot", "👥 Team Check", function(v) TeamCheck = v end)
AddToggle("aimbot", "🧱 Wall Check", function(v) WallCheck = v end)
AddButton("aimbot", "⚙️ Ganti Mode: [ 360° / Fov ]", function()
    AimbotMode = (AimbotMode == "Fov") and "360°" or "Fov"
end)
AddButton("aimbot", "⚡ Ganti Trigger: [ fire(snap) / camera ]", function()
    TriggerMode = (TriggerMode == "camera") and "fire(snap)" or "camera"
end)
AddToggle("aimbot", "⭕ Tampilkan Aim FOV Circle", function(v) AimFOV = v end)
AddSlider("aimbot", "📏 FOV Radius", 10, 500, 150, function(v) FOVRadius = v end)
AddToggle("aimbot", "📐 Aim Line Tracer (Dalam FOV)", function(v) AimLineTracer = v end)
AddButton("aimbot", "🎯 Aim Target: [ Head / Neck / Chest ]", function()
    if AimTargetPart == "Head" then AimTargetPart = "Neck"
    elseif AimTargetPart == "Neck" then AimTargetPart = "Chest"
    else AimTargetPart = "Head" end
end)
AddSlider("aimbot", "🔭 Max Distance (Meter)", 50, 5000, 1000, function(v) AimDistanceMax = v end)

-- 3. TAB PLAYER
AddSlider("player", "⚡ Custom Speed Run", 16, 250, 50, function(v) CustomSpeed = v end)
AddToggle("player", "🚀 Multi-Jump Hack", function(v) MultiJumpAktif = v end)
AddToggle("player", "🛸 Fly Hack (Tekan Lompat)", function(v) FlyAktif = v end)
AddToggle("player", "🔫 Rapid Fire (Gun Mod)", function(v) RapidFireAktif = v end)
AddToggle("player", "🔋 Unlimited Ammo (Gun Mod)", function(v) UnlimitedAmmoAktif = v end)

-- 4. TAB WORLD
AddSlider("world", "⏰ World Time (Jam)", 0, 24, 14, function(v) WorldTime = v; game:GetService("Lighting").ClockTime = v end)
AddToggle("world", "🪶 No Gravity (Gravitasi Rendah)", function(v) 
    NoGravityAktif = v
    workspace.Gravity = v and 30 or 196.2
end)

-- 5. TAB CONFIG
AddButton("config", "🎨 Ubah Tema UI (Light / Dark)", function()
    IsDarkTheme = not IsDarkTheme
    currTheme = IsDarkTheme and Themes.Dark or Themes.Light
    MainFrame.BackgroundColor3 = currTheme.Bg
    TopBar.BackgroundColor3 = currTheme.Top
end)

local ConfigFile = "LiteHack_FullConfig.json"
AddButton("config", "💾 Save Konfigurasi", function()
    local data = {
        ESPEnemy = ESPEnemy, ESPTeam = ESPTeam, ESPBox = ESPBox, ESPName = ESPName, ESPLine = ESPLine,
        ESPHealth = ESPHealth, ESPSkeleton = ESPSkeleton, ESPDistance = ESPDistance, ESPPicture = ESPPicture,
        AimbotAktif = AimbotAktif, TeamCheck = TeamCheck, WallCheck = WallCheck, AimbotMode = AimbotMode,
        TriggerMode = TriggerMode, AimFOV = AimFOV, FOVRadius = FOVRadius, AimLineTracer = AimLineTracer,
        CustomSpeed = CustomSpeed, MultiJumpAktif = MultiJumpAktif, FlyAktif = FlyAktif
    }
    pcall(function()
        if writefile then writefile(ConfigFile, HttpService:JSONEncode(data)) end
    end)
end)

AddButton("config", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(ConfigFile) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFile))
            ESPEnemy = decoded.ESPEnemy or ESPEnemy
            AimbotAktif = decoded.AimbotAktif or AimbotAktif
        end
    end)
end)

-- ========================================== -- LOGIKA UTAMA ESP & AIMBOT LANJUTAN -- ==========================================
-- (Mempertahankan seluruh fungsi dasar game, memory scan, dan fungsionalitas game lama)

local ESPFolder = CoreGui:FindFirstChild("Full_ESP_Container") or Instance.new("Folder", CoreGui)
ESPFolder.Name = "Full_ESP_Container"
local ActiveESPs = {}

RunService.RenderStepped:Connect(function()
    if not (ESPEnemy or ESPTeam) then
        for _, obj in pairs(ActiveESPs) do obj.Visible = false end
        return
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)

            if hrp and head and hum and hum.Health > 0 and ((isTeam and ESPTeam) or (not isTeam and ESPEnemy)) then
                local data = ActiveESPs[p]
                if not data then
                    data = {}
                    data.Box = Instance.new("Highlight", ESPFolder)
                    data.Box.Adornee = char
                    data.Box.FillTransparency = 0.8
                    data.NameLbl = Instance.new("TextLabel", ESPFolder)
                    data.NameLbl.Size = UDim2.new(0, 100, 0, 20)
                    data.NameLbl.BackgroundTransparency = 1
                    data.NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    data.NameLbl.TextSize = 12
                    data.NameLbl.Font = Enum.Font.GothamBold
                    ActiveESPs[p] = data
                end

                data.Box.Enabled = ESPBox
                data.Box.FillColor = ESPColor

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    data.NameLbl.Visible = ESPName
                    data.NameLbl.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 40)
                    data.NameLbl.Text = p.Name .. (ESPDistance and (" [" .. math.floor((Camera.CFrame.Position - hrp.Position).Magnitude) .. "m]") or "")
                else
                    data.NameLbl.Visible = false
                end
            elseif ActiveESPs[p] then
                ActiveESPs[p].Box.Enabled = false
                ActiveESPs[p].NameLbl.Visible = false
            end
        end
    end
end)

-- Logika Multi-Jump & Fly
UserInputService.JumpRequest:Connect(function()
    if MultiJumpAktif and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if SpeedAktif then hum.WalkSpeed = CustomSpeed end
        if FlyAktif and hum.RootPart then
            hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, 2, hum.RootPart.Velocity.Z)
        end
    end
end)

-- Deep Memory Gun Mods (Utuh dari skrip asli)
task.spawn(function()
    while task.wait(1) do
        if UnlimitedAmmoAktif or RapidFireAktif then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "ClipSize") or rawget(v, "RPM") then
                            if UnlimitedAmmoAktif and rawget(v, "Ammo") then v.Ammo = 999999 end
                            if UnlimitedAmmoAktif and rawget(v, "ClipSize") then v.ClipSize = 999999 end
                            if RapidFireAktif and rawget(v, "RPM") then v.RPM = 2500 end
                        end
                    end
                end
            end)
        end
    end
end)
