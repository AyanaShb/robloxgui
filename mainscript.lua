-- ========================================== --
-- 🎯 LITE HACK + ULTIMATE MODS (FULL CUSTOM IMGUI)
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
-- AUTO BYPASS ANTI-CHEAT
-- ========================================== --
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
        if detour_function then detour_function = function(...) return true end end
        if getconnections then
            pcall(function()
                for _, connection in ipairs(getconnections(ScriptContext.Error)) do
                    connection:Disable()
                end
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

-- ========================================== --
-- STATE VARIABEL UTAMA
-- ========================================== --
local ESPEnemy = false
local ESPTeam = false
local ESPColorIndex = 1
local ESPColors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 150, 255), Color3.fromRGB(255, 255, 0)}
local ESPColor = ESPColors[1]
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
local AimbotMode = "Fov" -- "Fov" / "360°"
local TriggerMode = "camera" -- "camera" / "fire(snap)"
local AimFOVToggle = false
local AimLineTracer = false
local AimTargetPart = "head" -- "head" / "neck" / "chest"
local AimDistanceMax = 1000
local FOVRadius = 150

local SpeedRun = false
local CustomSpeed = 50
local MultiJump = false
local FlyHack = false
local RapidFire = false
local UnlimitedAmmo = false

local TimeWorldCustom = false
local WorldTimeValue = 14
local NoGravity = false

local IsDarkTheme = true
local ConfigFileName = "LiteHack_Ultimate_Config.json"

-- ========================================== --
-- CUSTOM IMGUI MODERN UI BUILDER
-- ========================================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiteHack_ModernImgui"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Themes = {
    Dark = {
        Bg = Color3.fromRGB(15, 15, 20),
        TopBar = Color3.fromRGB(22, 22, 30),
        Sidebar = Color3.fromRGB(20, 20, 26),
        Element = Color3.fromRGB(28, 28, 38),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(240, 240, 255),
        TextDark = Color3.fromRGB(150, 150, 170)
    },
    Light = {
        Bg = Color3.fromRGB(240, 240, 245),
        TopBar = Color3.fromRGB(220, 220, 230),
        Sidebar = Color3.fromRGB(230, 230, 238),
        Element = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(20, 20, 30),
        TextDark = Color3.fromRGB(100, 100, 120)
    }
}
local currentTheme = Themes.Dark

-- Floating Icon (Tengkorak)
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Name = "FloatSkull"
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0, 30, 0.4, 0)
FloatBtn.BackgroundColor3 = currentTheme.TopBar
FloatBtn.TextColor3 = currentTheme.Accent
FloatBtn.TextSize = 22
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Text = "💀"
FloatBtn.Active = true
FloatBtn.Draggable = true
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = currentTheme.Accent
FloatStroke.Thickness = 1.5

-- Main Menu Window (Ukuran proporsional, tidak terlalu besar)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = currentTheme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Topbar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = currentTheme.TopBar
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = currentTheme.Text
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.Text = "🎯 Lite Hack + Ultimate Mods"
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol X (Exit Script Total) di Sudut Kanan Atas
local ExitBtn = Instance.new("TextButton", TopBar)
ExitBtn.Size = UDim2.new(0, 26, 0, 26)
ExitBtn.Position = UDim2.new(1, -30, 0.5, -13)
ExitBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.TextSize = 11
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.Text = "X"
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)
ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Header Horizontal (Bisa di-scroll unlimited secara horizontal)
local TabHeaderOuter = Instance.new("ScrollingFrame", MainFrame)
TabHeaderOuter.Size = UDim2.new(1, 0, 0, 30)
TabHeaderOuter.Position = UDim2.new(0, 0, 0, 32)
TabHeaderOuter.BackgroundColor3 = currentTheme.Sidebar
TabHeaderOuter.BorderSizePixel = 0
TabHeaderOuter.CanvasSize = UDim2.new(0, 500, 0, 0)
TabHeaderOuter.ScrollBarThickness = 0

local TabHeaderLayout = Instance.new("UIListLayout", TabHeaderOuter)
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Padding = UDim.new(0, 4)

local tabNames = {"visual", "player", "aimbot", "world", "config"}
local tabFrames = {}
local tabButtons = {}

-- Content Container (Masing-masing tab punya ScrollingFrame vertical unlimited ke bawah)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -12, 1, -74)
ContentContainer.Position = UDim2.new(0, 6, 0, 68)
ContentContainer.BackgroundTransparency = 1

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", TabHeaderOuter)
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = i == 1 and currentTheme.Accent or currentTheme.TextDark
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
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

-- Helper Komponen UI
local function CreateToggle(tabKey, titleText, callback)
    local parent = tabFrames[tabKey]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = currentTheme.Element
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = titleText
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 32, 0, 16)
    toggleBtn.Position = UDim2.new(1, -40, 0.5, -8)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
end

local function CreateCheckbox(tabKey, titleText, callback)
    local parent = tabFrames[tabKey]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 28)
    frame.BackgroundColor3 = currentTheme.Element
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -35, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = titleText
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local boxBtn = Instance.new("TextButton", frame)
    boxBtn.Size = UDim2.new(0, 16, 0, 16)
    boxBtn.Position = UDim2.new(1, -24, 0.5, -8)
    boxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    boxBtn.Text = ""
    Instance.new("UICorner", boxBtn).CornerRadius = UDim.new(0, 4)

    local state = false
    boxBtn.MouseButton1Click:Connect(function()
        state = not state
        boxBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
        boxBtn.Text = state and "✓" or ""
        callback(state)
    end)
end

local function CreateButton(tabKey, titleText, callback)
    local parent = tabFrames[tabKey]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = currentTheme.Element
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = titleText
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- ========================================== --
-- PENGISIAN MENU FITUR DI MASING-MASING TAB
-- ========================================== --

-- 1. TAB VISUAL
CreateToggle("visual", "👁️ ESP Enemy", function(v) ESPEnemy = v end)
CreateToggle("visual", "👥 ESP Team", function(v) ESPTeam = v end)
CreateButton("visual", "🎨 Colour Picker (Ganti Warna ESP)", function()
    ESPColorIndex = ESPColorIndex + 1
    if ESPColorIndex > #ESPColors then ESPColorIndex = 1 end
    ESPColor = ESPColors[ESPColorIndex]
end)
CreateCheckbox("visual", "Box (Kotak ESP)", function(v) ESPBox = v end)
CreateCheckbox("visual", "Name (Nama Player)", function(v) ESPName = v end)
CreateCheckbox("visual", "Line (Garis dari Kepala)", function(v) ESPLine = v end)
CreateCheckbox("visual", "Health (Dinamis Warna HP)", function(v) ESPHealth = v end)
CreateCheckbox("visual", "Skeleton (Kerangka Tulang)", function(v) ESPSkeleton = v end)
CreateCheckbox("visual", "Distance (Jarak Meter)", function(v) ESPDistance = v end)
CreateCheckbox("visual", "Picture (Thumbnail Profil Bulat)", function(v) ESPPicture = v end)

-- 2. TAB AIMBOT
CreateToggle("aimbot", "🎯 Aktifkan Aimbot", function(v) AimbotAktif = v end)
CreateToggle("aimbot", "👥 Team Check", function(v) TeamCheck = v end)
CreateToggle("aimbot", "🧱 Wall Check", function(v) WallCheck = v end)
CreateButton("aimbot", "⚙️ Mode Aimbot: Fov / 360°", function()
    AimbotMode = (AimbotMode == "Fov") and "360°" or "Fov"
end)
CreateButton("aimbot", "⚡ Mode Trigger: Camera / Fire(Snap)", function()
    TriggerMode = (TriggerMode == "camera") and "fire(snap)" or "camera"
end)
CreateToggle("aimbot", "⭕ Aim FOV Circle", function(v) AimFOVToggle = v end)
CreateToggle("aimbot", "📈 Aim Line Tracer (Dalam FOV)", function(v) AimLineTracer = v end)
CreateButton("aimbot", "🎯 Aim Target: Head / Neck / Chest", function()
    if AimTargetPart == "head" then AimTargetPart = "neck"
    elseif AimTargetPart == "neck" then AimTargetPart = "chest"
    else AimTargetPart = "head" end
end)

-- 3. TAB PLAYER
CreateToggle("player", "⚡ Speed Run", function(v) SpeedRun = v end)
CreateToggle("player", "🚀 Multi Jump Hack", function(v) MultiJump = v end)
CreateToggle("player", "🕊️ Fly Hack", function(v) FlyHack = v end)
CreateToggle("player", "🔥 Rapid Fire", function(v) RapidFire = v end)
CreateToggle("player", "📦 Unlimited Ammo", function(v) UnlimitedAmmo = v end)

-- 4. TAB WORLD
CreateToggle("world", "🌍 Custom Time World", function(v) TimeWorldCustom = v end)
CreateToggle("world", "🪶 No Gravity", function(v) NoGravity = v end)

-- 5. TAB CONFIG
CreateButton("config", "🎨 Ubah Theme UI (Light / Dark)", function()
    IsDarkTheme = not IsDarkTheme
    currentTheme = IsDarkTheme and Themes.Dark or Themes.Light
    MainFrame.BackgroundColor3 = currentTheme.Bg
    TopBar.BackgroundColor3 = currentTheme.TopBar
    TabHeaderOuter.BackgroundColor3 = currentTheme.Sidebar
    FloatBtn.BackgroundColor3 = currentTheme.TopBar
    FloatBtn.TextColor3 = currentTheme.Accent
end)
CreateButton("config", "💾 Save Konfigurasi", function()
    local data = {
        ESPEnemy = ESPEnemy, ESPTeam = ESPTeam, ESPBox = ESPBox,
        ESPName = ESPName, ESPLine = ESPLine, ESPHealth = ESPHealth,
        ESPSkeleton = ESPSkeleton, ESPDistance = ESPDistance, ESPPicture = ESPPicture,
        AimbotAktif = AimbotAktif, TeamCheck = TeamCheck, WallCheck = WallCheck,
        SpeedRun = SpeedRun, MultiJump = MultiJump, FlyHack = FlyHack,
        RapidFire = RapidFire, UnlimitedAmmo = UnlimitedAmmo, NoGravity = NoGravity
    }
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(data)) end
    end)
end)
CreateButton("config", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            if decoded then
                ESPEnemy = decoded.ESPEnemy or false
                ESPTeam = decoded.ESPTeam or false
            end
        end
    end)
end)

-- ========================================== --
-- LOGIKA ESP LENGKAP & DINAMIS
-- ========================================== --
local ESP_Folder = CoreGui:FindFirstChild("Universal_ESP_System") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "Universal_ESP_System"
local Active_ESP = {}

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)
            local shouldShow = (isTeam and ESPTeam) or (not isTeam and ESPEnemy)

            if char and hrp and head and hum and hum.Health > 0 and shouldShow then
                if not Active_ESP[p] then
                    local data = {}
                    local bgui = Instance.new("BillboardGui", ESP_Folder)
                    bgui.AlwaysOnTop = true
                    bgui.Size = UDim2.new(0, 160, 0, 70)
                    bgui.ExtentsOffset = Vector3.new(0, 3.8, 0)
                    bgui.Adornee = head

                    local txt = Instance.new("TextLabel", bgui)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextSize = 11
                    txt.Font = Enum.Font.Code
                    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txt.TextStrokeTransparency = 0
                    data.TextLabel = txt
                    data.Gui = bgui

                    Active_ESP[p] = data
                end

                local data = Active_ESP[p]
                data.Gui.Enabled = true
                local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                local hpPercent = math.floor((hum.Health / hum.MaxHealth) * 100)

                -- Volume Dinamis HP: 100% Hijau | 70% Orange | 40% Merah Gelap
                local hpColorStr = "🟢"
                if hpPercent <= 70 and hpPercent > 40 then
                    hpColorStr = "🟠"
                elseif hpPercent <= 40 then
                    hpColorStr = "🔴"
                end

                local infoStr = ""
                if ESPName then infoStr = infoStr .. (p.Name or "Player") .. "\n" end
                if ESPDistance then infoStr = infoStr .. "[" .. dist .. "m]\n" end
                if ESPHealth then infoStr = infoStr .. "HP: " .. hpPercent .. "% " .. hpColorStr .. "\n" end
                data.TextLabel.Text = infoStr
                data.TextLabel.TextColor3 = ESPColor
            else
                if Active_ESP[p] then
                    Active_ESP[p].Gui.Enabled = false
                end
            end
        end
    end
end)

-- ========================================== --
-- LOGIKA AIMBOT & TRIGGER
-- ========================================== --
RunService.RenderStepped:Connect(function()
    if AimbotAktif then
        local closestTarget = nil
        local shortestDist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                local targetPart = char:FindFirstChild(AimTargetPart == "head" and "Head" or "HumanoidRootPart")
                if hum and hum.Health > 0 and targetPart then
                    if not TeamCheck or (p.TeamColor ~= LocalPlayer.TeamColor) then
                        local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
        if closestTarget then
            if TriggerMode == "fire(snap)" then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closestTarget.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, closestTarget.Position), 0.2)
            end
        end
    end
end)

-- ========================================== --
-- LOGIKA PLAYER & WORLD HACKS
-- ========================================== --
UserInputService.JumpRequest:Connect(function()
    if MultiJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and SpeedRun then hum.WalkSpeed = CustomSpeed end
        if hrp and NoGravity then hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z) end
    end
end)

RunService.Heartbeat:Connect(function()
    if TimeWorldCustom then game.Lighting.ClockTime = WorldTimeValue end
end)

-- ========================================== --
-- DEEP MEMORY SCAN GUN MODS
-- ========================================== --
task.spawn(function()
    while task.wait(1) do
        if UnlimitedAmmo or RapidFire then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "ClipSize") or rawget(v, "RPM") then
                            if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                            if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                            if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = 2500 end
                        end
                    end
                end
            end)
        end
    end
end)
