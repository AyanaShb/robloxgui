-- ========================================== -- 🎯 LITE HACK + ULTIMATE MODS (CUSTOM IMGUI MODERN) -- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== -- AUTO BYPASS ANTI-CHEAT -- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
        if detour_function then detour_function = function(...) return true end end
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
    end)
end)

-- ========================================== -- VARIABEL SISTEM & STATE -- ==========================================
local AimbotAktif = false
local AimbotMode = "POV Kamera (FOV)"
local AimTargetMode = "Head"
local AimbotSmoothness = 15
local ESPAktif = false
local FFAModeAktif = false
local SpeedAktif, JumpAktif = false, false
local AntiFallDamageAktif = false
local CustomSpeed, CustomJump = 50, 100
local GunModsAktif = false
local CustomFireRate = 800
local AntiAdminAktif = false
local ShowFOV = false
local FOVRadius = 150
local IsDarkTheme = true

-- ========================================== -- CUSTOM IMGUI MODERN UI BUILDER -- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernImGui_LiteHack"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Warna Tema
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

-- Main Window Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = currentTheme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 8)

-- Topbar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = currentTheme.TopBar
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = currentTheme.Text
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🎯 Lite Hack + Ultimate Mods"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Minimize & Exit di Sudut Kanan Atas
local ExitBtn = Instance.new("TextButton", TopBar)
ExitBtn.Size = UDim2.new(0, 30, 0, 30)
ExitBtn.Position = UDim2.new(1, -35, 0.5, -15)
ExitBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.TextSize = 12
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.Text = "X"
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= TopBar and child ~= MainCorner then
            child.Visible = not isMinimized
        end
    end
    MainFrame.Size = isMinimized and UDim2.new(0, 580, 0, 36) or UDim2.new(0, 580, 0, 380)
end)

ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Header (Visual, Player, Aimbot, World, Settings)
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, 0, 0, 32)
TabHeader.Position = UDim2.new(0, 0, 0, 36)
TabHeader.BackgroundColor3 = currentTheme.Sidebar
TabHeader.BorderSizePixel = 0

local TabContainer = Instance.new("UIListLayout", TabHeader)
TabContainer.FillDirection = Enum.FillDirection.Horizontal
TabContainer.SortOrder = Enum.SortOrder.LayoutOrder

local ContentHolder = Instance.new("Folder", MainFrame)

local tabs = {"Visual", "Player", "Aimbot", "World", "Settings"}
local tabFrames = {}
local tabButtons = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", TabHeader)
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = i == 1 and currentTheme.Accent or currentTheme.TextDark
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -16, 1, -80)
    page.Position = UDim2.new(0, 8, 0, 74)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local list = Instance.new("UIListLayout", page)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    
    tabFrames[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabFrames) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.TextColor3 = currentTheme.TextDark end
        page.Visible = true
        btn.TextColor3 = currentTheme.Accent
    end)
end

-- UI Component Helpers
local function AddToggle(tabName, text, callback)
    local parent = tabFrames[tabName]
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = currentTheme.ElementBg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 36, 0, 20)
    toggleBtn.Position = UDim2.new(1, -44, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
    return {
        Set = function(val)
            state = val
            toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60, 60, 70)
            callback(state)
        end
    }
end

local function AddButton(tabName, text, callback)
    local parent = tabFrames[tabName]
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = currentTheme.ElementBg
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- ========================================== -- PENGISIAN MENU TAB -- ==========================================

-- 1. TAB VISUAL (ESP & FOV)
AddToggle("Visual", "👁️ Enemy ESP (Highlight + Jarak)", function(v) ESPAktif = v end)
AddToggle("Visual", "⭕ Tampilkan Lingkaran FOV", function(v) ShowFOV = v end)

-- 2. TAB PLAYER (Speed, Jump, Anti Fall)
AddToggle("Player", "🛡️ No Fall Damage", function(v) AntiFallDamageAktif = v end)
AddToggle("Player", "⚡ Kecepatan Lari Cepat", function(v) 
    SpeedAktif = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 
    end 
end)
AddToggle("Player", "🚀 Lompat Tinggi", function(v) 
    JumpAktif = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 50 
    end 
end)

-- 3. TAB AIMBOT (Auto Aim & Gun Mods)
AddToggle("Aimbot", "🎯 Aktifkan Auto Aim (Kunci Layar)", function(v) AimbotAktif = v end)
AddToggle("Aimbot", "🔫 Gun Mods (Infinite Ammo & RPM)", function(v) GunModsAktif = v end)
AddToggle("Aimbot", "🚨 Peringatan Admin / GM", function(v) AntiAdminAktif = v end)

-- 4. TAB WORLD (FFA / Environment)
AddToggle("World", "🌐 Mode FFA (All Enemies Target)", function(v) FFAModeAktif = v end)

-- 5. TAB SETTINGS (Theme Switcher & Save/Load)
local ThemeToggleBtn
ThemeToggleBtn = AddButton("Settings", "🎨 Ubah Tema UI (Light / Dark)", function()
    if isDarkTheme then
        currentTheme = Themes.Light
        isDarkTheme = false
    else
        currentTheme = Themes.Dark
        isDarkTheme = true
    end
    -- Update warna background utama secara real-time
    MainFrame.BackgroundColor3 = currentTheme.Bg
    TopBar.BackgroundColor3 = currentTheme.TopBar
    TabHeader.BackgroundColor3 = currentTheme.Sidebar
    TitleLabel.TextColor3 = currentTheme.Text
end)

local ConfigFileName = "LiteHack_Config_Modern.json"
AddButton("Settings", "💾 Save Konfigurasi", function()
    local data = {
        ESPAktif = ESPAktif,
        ShowFOV = ShowFOV,
        AntiFallDamageAktif = AntiFallDamageAktif,
        SpeedAktif = SpeedAktif,
        JumpAktif = JumpAktif,
        AimbotAktif = AimbotAktif,
        GunModsAktif = GunModsAktif,
        AntiAdminAktif = AntiAdminAktif,
        FFAModeAktif = FFAModeAktif
    }
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(data))
        end
    end)
end)

AddButton("Settings", "📂 Load Konfigurasi", function()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            -- Anda dapat menyambungkan nilai ini kembali ke state variabel jika diperlukan
        end
    end)
end)

-- ========================================== -- LOGIKA FITUR UTAMA (ESP, AIMBOT, DLL) -- ==========================================
local ValidEntities = {}
task.spawn(function()
    while task.wait(0.5) do
        local currentList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then table.insert(currentList, p.Character) end
        end
        ValidEntities = currentList
    end
end)

local function IsEnemy(model)
    if FFAModeAktif then return true end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and plr.TeamColor == LocalPlayer.TeamColor then return false end
    return true
end

-- ESP System Loop
local ESP_Folder = CoreGui:FindFirstChild("Universal_ESP_System") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "Universal_ESP_System"
local Active_ESP = {}

RunService.RenderStepped:Connect(function()
    if not ESPAktif then
        for _, data in pairs(Active_ESP) do data.Highlight.Enabled = false; data.Gui.Enabled = false end
        return
    end
    local EntitiesInFrame = {}
    for _, model in pairs(ValidEntities) do
        local hum = model:FindFirstChildOfClass("Humanoid")
        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
        if model.Parent and hum and hum.Health > 0 and hrp and IsEnemy(model) then
            EntitiesInFrame[model] = true
            if not Active_ESP[model] then
                local esp_data = {}
                local hl = Instance.new("Highlight", ESP_Folder)
                hl.Adornee = model
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0.1
                local bgui = Instance.new("BillboardGui", ESP_Folder)
                bgui.Adornee = hrp
                bgui.AlwaysOnTop = true
                bgui.Size = UDim2.new(0, 200, 0, 50)
                bgui.ExtentsOffset = Vector3.new(0, 3, 0)
                local txt = Instance.new("TextLabel", bgui)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextSize = 14
                txt.Font = Enum.Font.Code
                txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_data.Highlight = hl
                esp_data.Gui = bgui
                esp_data.TextLabel = txt
                Active_ESP[model] = esp_data
            end
            local data = Active_ESP[model]
            data.Highlight.Enabled = true
            data.Gui.Enabled = true
            local jarak = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
            data.TextLabel.Text = (model.Name or "Bot") .. " [" .. jarak .. "m]"
        end
    end
    for model, data in pairs(Active_ESP) do
        if not EntitiesInFrame[model] then data.Highlight:Destroy(); data.Gui:Destroy(); Active_ESP[model] = nil end
    end
end)

-- Physics & Gun Mods Loop
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and AntiFallDamageAktif and hrp.Velocity.Y < -40 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z)
        end
        if hum then
            if SpeedAktif then hum.WalkSpeed = CustomSpeed end
            if JumpAktif then hum.UseJumpPower = true; hum.JumpPower = CustomJump end
        end
    end
end)

-- Deep Memory Gun Mods
task.spawn(function()
    while task.wait(1) do
        if GunModsAktif then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "ClipSize") or rawget(v, "RPM") then
                            if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                            if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                            if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = CustomFireRate end
                        end
                    end
                end
            end)
        end
    end
end)
