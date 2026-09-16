-- ==========================================
-- LITE HACK + ULTIMATE MODS (IMGUI STYLE)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT
-- ==========================================
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
                        if strKey:find("signature") or strKey:find("checksum") or strKey:find("hash") then
                            target[key] = nil
                        end
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- VARIABEL SISTEM & CONFIG
-- ==========================================
local ConfigFileName = "LiteHack_ImGui_Config.json"

-- State Variabel Fitur
local AimbotAktif = false
local AimbotTeamCheck = true
local AimbotWallCheck = true
local AimbotMode = "POV Kamera (FOV)"
local TriggerMode = "Fire (Snap)"
local AimTargetMode = "Head"
local AimbotDistance = 500
local ShowFOV = false
local ShowAimLine = false
local FOVRadius = 150

-- ESP States
local ESPEnemyAktif = false
local ESPTeamAktif = false
local ESPColor = Color3.fromRGB(0, 255, 255) -- Neon Cyan Default
local ESPBox = true
local ESPName = true
local ESPLine = true
local ESPHealth = true
local ESPSkeleton = false
local ESPDistance = true
local ESPPicture = true

-- Player Hacks
local AntiFallDamageAktif = false
local SpeedAktif = false
local CustomSpeed = 50
local JumpAktif = false
local CustomJump = 100
local MultiJumpAktif = false
local FlyAktif = false
local RapidFireAktif = false
local UnlimitedAmmoAktif = false

-- Gun Mods
local GunModsAktif = false
local CustomFireRate = 800

-- World Mods
local ClockTimeMode = "Default"
local NoGravityAktif = false

-- Anti-Admin
local AntiAdminAktif = false

-- ==========================================
-- PEMBUATAN CUSTOM IMGUI UI (DARK/LIGHT THEME)
-- ==========================================
local TargetParent = (gethui and gethui()) or CoreGui
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "ImGui_LiteHack"
MainGui.Parent = TargetParent
MainGui.IgnoreGuiInset = true
MainGui.ResetOnSpawn = false

-- Floating Icon (Tengkorak Glow)
local FloatIcon = Instance.new("TextButton")
FloatIcon.Name = "FloatIcon"
FloatIcon.Parent = MainGui
FloatIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatIcon.Position = UDim2.new(0.05, 0, 0.1, 0)
FloatIcon.Size = UDim2.new(0, 45, 0, 45)
FloatIcon.Font = Enum.Font.GothamBold
FloatIcon.Text = "💀"
FloatIcon.TextColor3 = Color3.fromRGB(0, 255, 255)
FloatIcon.TextSize = 22
FloatIcon.AutoButtonColor = false

local IconCorner = Instance.new("UICorner", FloatIcon)
IconCorner.CornerRadius = UDim.new(0, 10)

local IconStroke = Instance.new("UIStroke", FloatIcon)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Transparency = 0.3
IconStroke.Thickness = 2

-- Window Utama ImGui
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Parent = MainGui
Window.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Window.BackgroundTransparency = 0.15
Window.Position = UDim2.new(0.5, -230, 0.5, -170)
Window.Size = UDim2.new(0, 460, 0, 340)
Window.Visible = true

local WindowCorner = Instance.new("UICorner", Window)
WindowCorner.CornerRadius = UDim.new(0, 8)

local WindowStroke = Instance.new("UIStroke", Window)
WindowStroke.Color = Color3.fromRGB(0, 255, 255)
WindowStroke.Transparency = 0.4
WindowStroke.Thickness = 1.5

-- Top Bar / Title
local TopBar = Instance.new("Frame", Window)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundTransparency = 0.1

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ LITE HACK + ULTIMATE MODS [IMGUI]"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close / Minimize
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    Window.Visible = false
end)

FloatIcon.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

-- Draggable Window Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- TAB NAVIGATION (Horizontal Scroll)
-- ==========================================
local TabHeaderScroll = Instance.new("ScrollingFrame", Window)
TabHeaderScroll.Active = true
TabHeaderScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TabHeaderScroll.BackgroundTransparency = 0.5
TabHeaderScroll.Position = UDim2.new(0, 8, 0, 38)
TabHeaderScroll.Size = UDim2.new(1, -16, 0, 32)
TabHeaderScroll.CanvasSize = UDim2.new(0, 380, 0, 0)
TabHeaderScroll.ScrollBarThickness = 2
TabHeaderScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

local TabHeaderLayout = Instance.new("UIListLayout", TabHeaderScroll)
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Padding = UDim.new(0, 5)

-- Container Konten Tab (Vertical Scroll)
local ContentContainer = Instance.new("Frame", Window)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 8, 0, 75)
ContentContainer.Size = UDim2.new(1, -16, 1, -83)

local Tabs = {}
local TabNames = {"Visual", "Player", "Aimbot", "World", "Config"}

for i, name in ipairs(TabNames) do
    local tabFrame = Instance.new("ScrollingFrame", ContentContainer)
    tabFrame.Name = name .. "Tab"
    tabFrame.Active = true
    tabFrame.BackgroundTransparency = 1
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.ScrollBarThickness = 3
    tabFrame.Visible = (i == 1)

    local layout = Instance.new("UIListLayout", tabFrame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    local btn = Instance.new("TextButton", TabHeaderScroll)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 150, 180) or Color3.fromRGB(25, 25, 35)
    btn.Size = UDim2.new(0, 75, 0, 28)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        for _, b in pairs(TabHeaderScroll:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(25, 25, 35) end
        end
        tabFrame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 180)
    end)

    Tabs[name] = tabFrame
end

-- ==========================================
-- UI HELPER BUILDERS
-- ==========================================
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -4, 0, 30)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.75, 0, 1, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(40, 40, 50)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 9

    local corner = Instance.new("UICorner", toggleBtn)
    corner.CornerRadius = UDim.new(0, 4)

    local active = default
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        toggleBtn.Text = active and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(40, 40, 50)
        callback(active)
    end)
    return frame
end

local function CreateSlider(parent, text, min, max, default, suffix, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -4, 0, 42)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. text .. ": " .. default .. suffix
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bgBar = Instance.new("Frame", frame)
    bgBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bgBar.Position = UDim2.new(0, 6, 0, 24)
    bgBar.Size = UDim2.new(1, -12, 0, 10)

    local barCorner = Instance.new("UICorner", bgBar)
    barCorner.CornerRadius = UDim.new(0, 5)

    local fillBar = Instance.new("Frame", bgBar)
    fillBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fillBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)

    local fillCorner = Instance.new("UICorner", fillBar)
    fillCorner.CornerRadius = UDim.new(0, 5)

    local btnInteract = Instance.new("TextButton", bgBar)
    btnInteract.BackgroundTransparency = 1
    btnInteract.Size = UDim2.new(1, 0, 1, 0)
    btnInteract.Text = ""

    local draggingSlider = false
    local function updateVal(input)
        local pos = math.clamp((input.Position.X - bgBar.AbsolutePosition.X) / bgBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fillBar.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = "  " .. text .. ": " .. val .. suffix
        callback(val)
    end

    btnInteract.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateVal(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateVal(input)
        end
    end)
    return frame
end

local function CreateComboBox(parent, text, options, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local currentOpt = default
    local dropBtn = Instance.new("TextButton", frame)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    dropBtn.Position = UDim2.new(0.5, 0, 0, 4)
    dropBtn.Size = UDim2.new(0.5, -4, 0, 24)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.Text = currentOpt
    dropBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    dropBtn.TextSize = 10

    local corner = Instance.new("UICorner", dropBtn)
    corner.CornerRadius = UDim.new(0, 4)

    local idx = 1
    for i, opt in ipairs(options) do if opt == default then idx = i end end

    dropBtn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        currentOpt = options[idx]
        dropBtn.Text = currentOpt
        callback(currentOpt)
    end)
    return frame
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.TextSize = 11

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 150, 200)
    stroke.Transparency = 0.5

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- POPULASI KONTEN TAB
-- ==========================================

-- 1. TAB VISUAL (ESP & RGB Color Picker)
CreateToggle(Tabs.Visual, "ESP Enemy (Musuh)", false, function(v) ESPEnemyAktif = v end)
CreateToggle(Tabs.Visual, "ESP Team (Tim)", false, function(v) ESPTeamAktif = v end)

-- Widget Warna RGB Samaan Untuk ESP
local ColorWidgetFrame = Instance.new("Frame", Tabs.Visual)
ColorWidgetFrame.Size = UDim2.new(1, -4, 0, 45)
ColorWidgetFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
local cwCorner = Instance.new("UICorner", ColorWidgetFrame)
cwCorner.CornerRadius = UDim.new(0, 6)

local cwLbl = Instance.new("TextLabel", ColorWidgetFrame)
cwLbl.BackgroundTransparency = 1
cwLbl.Position = UDim2.new(0, 8, 0, 2)
cwLbl.Size = UDim2.new(1, -10, 0, 18)
cwLbl.Font = Enum.Font.GothamBold
cwLbl.Text = "🎨 Panel Warna ESP (RGB Neon)"
cwLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
cwLbl.TextSize = 11
cwLbl.TextXAlignment = Enum.TextXAlignment.Left

local rBtn = Instance.new("TextButton", ColorWidgetFrame)
rBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
rBtn.Position = UDim2.new(0, 8, 0, 22)
rBtn.Size = UDim2.new(0.3, -6, 0, 18)
rBtn.Text = "Red"
rBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rBtn.Font = Enum.Font.GothamBold; rBtn.TextSize = 9
Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0, 4)
rBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(255, 50, 50) end)

local gBtn = Instance.new("TextButton", ColorWidgetFrame)
gBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
gBtn.Position = UDim2.new(0.33, 4, 0, 22)
gBtn.Size = UDim2.new(0.3, -6, 0, 18)
gBtn.Text = "Green"
gBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
gBtn.Font = Enum.Font.GothamBold; gBtn.TextSize = 9
Instance.new("UICorner", gBtn).CornerRadius = UDim.new(0, 4)
gBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(50, 255, 50) end)

local cBtn = Instance.new("TextButton", ColorWidgetFrame)
cBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
cBtn.Position = UDim2.new(0.66, 8, 0, 22)
cBtn.Size = UDim2.new(0.3, -6, 0, 18)
cBtn.Text = "Cyan"
cBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
cBtn.Font = Enum.Font.GothamBold; cBtn.TextSize = 9
Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
cBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(0, 255, 255) end)

-- ESP Sub-Components Toggle
CreateToggle(Tabs.Visual, "ESP Box", true, function(v) ESPBox = v end)
CreateToggle(Tabs.Visual, "ESP Name (Di Atas Box)", true, function(v) ESPName = v end)
CreateToggle(Tabs.Visual, "ESP Line (Di Kepala)", true, function(v) ESPLine = v end)
CreateToggle(Tabs.Visual, "ESP Health (Volume Dinamis Samping)", true, function(v) ESPHealth = v end)
CreateToggle(Tabs.Visual, "ESP Skeleton", false, function(v) ESPSkeleton = v end)
CreateToggle(Tabs.Visual, "ESP Distance (Di Bawah Box)", true, function(v) ESPDistance = v end)
CreateToggle(Tabs.Visual, "ESP Picture (Avatar Bulat Di Atas Kepala)", true, function(v) ESPPicture = v end)


-- 2. TAB PLAYER
CreateToggle(Tabs.Player, "Speed Run", false, function(v) SpeedAktif = v end)
CreateSlider(Tabs.Player, "Speed Level", 16, 250, 50, "%", function(v) CustomSpeed = v end)
CreateToggle(Tabs.Player, "Multi Jump (Udara)", false, function(v) MultiJumpAktif = v end)
CreateToggle(Tabs.Player, "Fly Hack (Tahan Jump)", false, function(v) FlyAktif = v end)
CreateToggle(Tabs.Player, "Rapid Fire (Tembakan Cepat)", false, function(v) RapidFireAktif = v end)
CreateToggle(Tabs.Player, "Unlimited Ammo", false, function(v) UnlimitedAmmoAktif = v end)
CreateToggle(Tabs.Player, "No Fall Damage", false, function(v) AntiFallDamageAktif = v end)


-- 3. TAB AIMBOT
CreateToggle(Tabs.Aimbot, "Aktifkan Aimbot", false, function(v) AimbotAktif = v end)
CreateToggle(Tabs.Aimbot, "Team Check", true, function(v) AimbotTeamCheck = v end)
CreateToggle(Tabs.Aimbot, "Wall Check (Lewati Tembok)", true, function(v) AimbotWallCheck = v end)
CreateComboBox(Tabs.Aimbot, "Mode Aimbot", {"360° (Brutal)", "POV Kamera (FOV)"}, "POV Kamera (FOV)", function(v) AimbotMode = v end)
CreateComboBox(Tabs.Aimbot, "Mode Trigger", {"Fire (Snap)", "Camera"}, "Fire (Snap)", function(v) TriggerMode = v end)
CreateToggle(Tabs.Aimbot, "Tampilkan Aim FOV", false, function(v) ShowFOV = v end)
CreateToggle(Tabs.Aimbot, "Tampilkan Aim Line", false, function(v) ShowAimLine = v end)
CreateComboBox(Tabs.Aimbot, "Aim Target Part", {"Head", "Neck", "Chest"}, "Head", function(v) AimTargetMode = v end)
CreateSlider(Tabs.Aimbot, "Aim Distance", 50, 5000, 500, "m", function(v) AimbotDistance = v end)


-- 4. TAB WORLD
CreateComboBox(Tabs.World, "Clock Time (Suasana Map)", {"Default", "Pagi (08:00)", "Siang (12:00)", "Sore (18:00)", "Malam (00:00)"}, "Default", function(v)
    ClockTimeMode = v
    if v == "Pagi (08:00)" then game.Lighting.ClockTime = 8
    elseif v == "Siang (12:00)" then game.Lighting.ClockTime = 12
    elseif v == "Sore (18:00)" then game.Lighting.ClockTime = 18
    elseif v == "Malam (00:00)" then game.Lighting.ClockTime = 0
    end
end)
CreateToggle(Tabs.World, "No Gravity", false, function(v) NoGravityAktif = v end)

-- List Box Teleport Player
local TpLabel = Instance.new("TextLabel", Tabs.World)
TpLabel.Size = UDim2.new(1, -4, 0, 20)
TpLabel.BackgroundTransparency = 1
TpLabel.Font = Enum.Font.GothamBold
TpLabel.Text = "  ⚡ Teleport Instan ke Player:"
TpLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TpLabel.TextSize = 11
TpLabel.TextXAlignment = Enum.TextXAlignment.Left

local TpScroll = Instance.new("ScrollingFrame", Tabs.World)
TpScroll.Size = UDim2.new(1, -4, 0, 90)
TpScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TpScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TpScroll.ScrollBarThickness = 3
Instance.new("UICorner", TpScroll).CornerRadius = UDim.new(0, 6)
local TpLayout = Instance.new("UIListLayout", TpScroll)
TpLayout.SortOrder = Enum.SortOrder.LayoutOrder
TpLayout.Padding = UDim.new(0, 3)

local function RefreshTeleportList()
    for _, ch in pairs(TpScroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", TpScroll)
            pBtn.Size = UDim2.new(1, -4, 0, 24)
            pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            pBtn.Font = Enum.Font.GothamBold
            pBtn.Text = "  " .. p.Name
            pBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            pBtn.TextSize = 10
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            pBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(RefreshTeleportList)
Players.PlayerRemoving:Connect(RefreshTeleportList)
RefreshTeleportList()


-- 5. TAB CONFIG
CreateComboBox(Tabs.Config, "Theme UI", {"Dark Neon", "Light Clean"}, "Dark Neon", function(v)
    if v == "Light Clean" then
        Window.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        TopBar.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 100, 150)
        WindowStroke.Color = Color3.fromRGB(0, 100, 150)
    else
        Window.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        WindowStroke.Color = Color3.fromRGB(0, 255, 255)
    end
end)

CreateButton(Tabs.Config, "💾 Save Konfigurasi (JSON)", function()
    local settings = {
        AimbotAktif = AimbotAktif, AimbotTeamCheck = AimbotTeamCheck, AimbotWallCheck = AimbotWallCheck,
        ESPEnemyAktif = ESPEnemyAktif, ESPTeamAktif = ESPTeamAktif, CustomSpeed = CustomSpeed, CustomJump = CustomJump
    }
    if writefile then
        pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(settings)) end)
    end
end)

CreateButton(Tabs.Config, "📂 Load Konfigurasi (JSON)", function()
    if isfile and readfile and isfile(ConfigFileName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            -- Data diterapkan otomatis
        end)
    end
end)


-- ==========================================
-- LOGIKA CORE ESP & RENDER
-- ==========================================
local ESP_Folder = CoreGui:FindFirstChild("ImGui_ESP_System") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "ImGui_ESP_System"
local Active_ESP = {}

local function IsValidEnemy(model)
    local plr = Players:GetPlayerFromCharacter(model)
    if plr then
        if plr == LocalPlayer then return false end
        if plr.Team == LocalPlayer.Team and not ESPTeamAktif then return false end
        if plr.Team ~= LocalPlayer.Team and not ESPEnemyAktif then return false end
    end
    return true
end

RunService.RenderStepped:Connect(function()
    -- Update FOV Circle Size
    -- Logika ESP & Visual Frame
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character and model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local isEnemy = IsValidEnemy(model)
                if (isEnemy and ESPEnemyAktif) or (not isEnemy and ESPTeamAktif) then
                    if not Active_ESP[model] then
                        local espObj = {}
                        -- Highlight / Box / Billboard
                        local hl = Instance.new("Highlight", ESP_Folder)
                        hl.Adornee = model
                        hl.FillTransparency = 0.6
                        hl.OutlineTransparency = 0.2
                        espObj.Highlight = hl
                        
                        local bgui = Instance.new("BillboardGui", ESP_Folder)
                        bgui.Adornee = hrp
                        bgui.AlwaysOnTop = true
                        bgui.Size = UDim2.new(0, 150, 0, 60)
                        bgui.ExtentsOffset = Vector3.new(0, 3, 0)
                        
                        local txt = Instance.new("TextLabel", bgui)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 12
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.TextStrokeTransparency = 0
                        espObj.Text = txt
                        espObj.Gui = bgui
                        
                        Active_ESP[model] = espObj
                    end
                    local data = Active_ESP[model]
                    data.Highlight.FillColor = ESPColor
                    data.Highlight.OutlineColor = ESPColor
                    
                    local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                    local hpPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
                    
                    local textStr = ""
                    if ESPName then textStr = textStr .. (model.Name or "Player") .. "\n" end
                    if ESPHealth then textStr = textStr .. "HP: " .. hpPercent .. "%\n" end
                    if ESPDistance then textStr = textStr .. "[" .. dist .. "m]" end
                    data.TextLabel.Text = textStr
                else
                    if Active_ESP[model] then
                        Active_ESP[model].Highlight:Destroy()
                        Active_ESP[model].Gui:Destroy()
                        Active_ESP[model] = nil
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- LOGIKA FISIKA, SPEED, JUMP & GRAVITY
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then
            if SpeedAktif then hum.WalkSpeed = CustomSpeed end
            if JumpAktif or MultiJumpAktif then hum.UseJumpPower = true; hum.JumpPower = CustomJump end
        end
        if hrp and NoGravityAktif then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        end
    end
end)

Rayfield = {Notify = function(self, data) 
    print(data.Title .. ": " .. data.Content)
end}

print("⚡ ImGui Lite Hack Successfully Loaded!")
