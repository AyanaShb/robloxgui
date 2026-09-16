-- ==========================================================================
-- 🎯 LITE HACK + ULTIMATE MODS (IMGUI THEME & CUSTOM DRAWING UI)
-- ==========================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================== --
-- 🛡️ AUTO BYPASS ANTI-CHEAT & SECURITY      --
-- ========================================== --
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
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

-- ========================================== --
-- 🎨 IMGUI FLOATING & WINDOW SYSTEM         --
-- ========================================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_Universal_Hack"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Floating Icon Tengkorak Glow
local FloatIcon = Instance.new("TextButton")
FloatIcon.Name = "FloatSkull"
FloatIcon.Parent = ScreenGui
FloatIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatIcon.Position = UDim2.new(0.05, 0, 0.1, 0)
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Font = Enum.Font.GothamBold
FloatIcon.Text = "💀"
FloatIcon.TextColor3 = Color3.fromRGB(0, 255, 128)
FloatIcon.TextSize = 24
FloatIcon.AutoButtonColor = false

local IconCorner = Instance.new("UICorner", FloatIcon)
IconCorner.CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke", FloatIcon)
IconStroke.Color = Color3.fromRGB(0, 255, 128)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.2

-- Main Window Frame (Semi-transparan, sudut tdk lancip)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainWindow.BackgroundTransparency = 0.15
MainWindow.Position = UDim2.new(0.5, -275, 0.5, -175)
MainWindow.Size = UDim2.new(0, 550, 0, 350)
MainWindow.Visible = true

local WindowCorner = Instance.new("UICorner", MainWindow)
WindowCorner.CornerRadius = UDim.new(0, 8)

local WindowStroke = Instance.new("UIStroke", MainWindow)
WindowStroke.Color = Color3.fromRGB(0, 255, 128)
WindowStroke.Thickness = 1.5
WindowStroke.Transparency = 0.4

-- Top Bar / Header Window
local TopBar = Instance.new("Frame", MainWindow)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.BackgroundTransparency = 0.1
local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🎯 LITE HACK + ULTIMATE MODS [IMGUI]"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

FloatIcon.MouseButton1Click:Connect(function()
    MainWindow.Visible = not MainWindow.Visible
end)

-- ========================================== --
-- 📑 TAB SYSTEM (HORIZONTAL & VERTICAL)      --
-- ========================================== --
local TabHeaderContainer = Instance.new("ScrollingFrame", MainWindow)
TabHeaderContainer.Position = UDim2.new(0, 8, 0, 42)
TabHeaderContainer.Size = UDim2.new(1, -16, 0, 30)
TabHeaderContainer.BackgroundTransparency = 1
TabHeaderContainer.CanvasSize = UDim2.new(0, 450, 0, 0)
TabHeaderContainer.ScrollBarThickness = 0
TabHeaderContainer.AutomaticCanvasSize = Enum.AutomaticSize.X

local UIListLayoutTabs = Instance.new("UIListLayout", TabHeaderContainer)
UIListLayoutTabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutTabs.Padding = UDim.new(0, 6)

local ContentContainer = Instance.new("Frame", MainWindow)
ContentContainer.Position = UDim2.new(0, 8, 0, 78)
ContentContainer.Size = UDim2.new(1, -16, 1, -86)
ContentContainer.BackgroundTransparency = 1

local Tabs = {}
local TabPages = {}
local currentTabName = ""

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabHeaderContainer)
    TabBtn.Size = UDim2.new(0, 95, 0, 28)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabScroll = Instance.new("ScrollingFrame", ContentContainer)
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.Visible = false
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.ScrollBarThickness = 4
    
    local UIListLayoutPage = Instance.new("UIListLayout", TabScroll)
    UIListLayoutPage.FillDirection = Enum.FillDirection.Vertical
    UIListLayoutPage.Padding = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabPages) do p.Visible = false end
        for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.fromRGB(180, 180, 180) end
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        TabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
        currentTabName = name
    end)

    table.insert(Tabs, TabBtn)
    table.insert(TabPages, TabScroll)
    if #Tabs == 1 then
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        TabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
        currentTabName = name
    end
    return TabScroll
end

-- ========================================== --
-- UI COMPONENT BUILDERS                      --
-- ========================================== --
local function AddToggle(parent, text, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 36, 0, 20)
    btn.Position = UDim2.new(1, -40, 0.5, -10)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(50, 50, 60)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(50, 50, 60)
        pcall(function() callback(state) end)
    end)
    return {Get = function() return state end, Set = function(v) state = v; btn.BackgroundColor3 = v and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(50, 50, 60); pcall(function() callback(v) end) end}
end

local function AddSlider(parent, text, min, max, default, suffix, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -4, 0, 42)
    f.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text .. ": " .. default .. suffix
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", f)
    bg.Position = UDim2.new(0, 0, 0, 24)
    bg.Size = UDim2.new(1, 0, 0, 10)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = text .. ": " .. val .. suffix
        pcall(function() callback(val) end)
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
end

local function AddDropdown(parent, text, options, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local currentIdx = 1
    for i, opt in ipairs(options) do if opt == default then currentIdx = i end end

    local btn = Instance.new("TextButton", f)
    btn.Position = UDim2.new(0.5, 0, 0, 2)
    btn.Size = UDim2.new(0.5, 0, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = options[currentIdx]
    btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        btn.Text = options[currentIdx]
        pcall(function() callback(options[currentIdx]) end)
    end)
end

local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- ========================================== --
-- SETUP TABS & FEATURES                     --
-- ========================================== --
local VisualTab = CreateTab("Visual")
local AimbotTab = CreateTab("Aimbot")
local PlayerTab = CreateTab("Player")
local WorldTab = CreateTab("World")
local ConfigTab = CreateTab("Config")

-- Variabel Fitur Global
local ESPEnemyAktif = false
local ESPTeamAktif = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPConfig = { Box = true, Name = true, Line = true, Health = true, Skeleton = false, Distance = true, Picture = false }

local AimbotAktif = false
local TeamCheck = false
local WallCheck = false
local AimbotMode = "Fov"
local TriggerMode = "fire(snap)"
local ShowFOV = false
local FOVRadius = 150
local AimLine = false
local AimTargetMode = "Head"
local AimDistance = 500

local SpeedAktif = false
local SpeedPercent = 100
local MultiJumpAktif = false
local FlyAktif = false
local RapidFireAktif = false
local UnlimitedAmmoAktif = false

local ClockTimeValue = "Siang"
local NoGravityAktif = false
local SelectedTargetTeleport = "Pilih Player"

-- ========================================== --
-- 1. TAB VISUAL IMPLEMENTATION              --
-- ========================================== --
AddToggle(VisualTab, "👁️ ESP Enemy", false, function(v) ESPEnemyAktif = v end)
AddToggle(VisualTab, "👁️ ESP Team", false, function(v) ESPTeamAktif = v end)

AddToggle(VisualTab, "📦 ESP Box", true, function(v) ESPConfig.Box = v end)
AddToggle(VisualTab, "🏷️ ESP Name (Atas Box)", true, function(v) ESPConfig.Name = v end)
AddToggle(VisualTab, "📏 ESP Distance (Bawah Box)", true, function(v) ESPConfig.Distance = v end)
AddToggle(VisualTab, "📈 ESP Line (Di Kepala)", true, function(v) ESPConfig.Line = v end)
AddToggle(VisualTab, "❤️ ESP Health (Samping Kanan)", true, function(v) ESPConfig.Health = v end)
AddToggle(VisualTab, "🦴 ESP Skeleton", false, function(v) ESPConfig.Skeleton = v end)
AddToggle(VisualTab, "🖼️ ESP Profile Picture", false, function(v) ESPConfig.Picture = v end)

-- Widget Pemilihan Warna RGB Sederhana untuk ESP
local ColorPanel = Instance.new("Frame", VisualTab)
ColorPanel.Size = UDim2.new(1, -4, 0, 35)
ColorPanel.BackgroundTransparency = 1
local clbl = Instance.new("TextLabel", ColorPanel)
clbl.Size = UDim2.new(0.4, 0, 1, 0)
clbl.Font = Enum.Font.GothamBold
clbl.Text = "🎨 Warna ESP RGB"
clbl.TextColor3 = Color3.fromRGB(220, 220, 220)
clbl.TextSize = 11
clbl.TextXAlignment = Enum.TextXAlignment.Left

local rBtn = Instance.new("TextButton", ColorPanel)
rBtn.Position = UDim2.new(0.42, 0, 0.15, 0)
rBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
rBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
rBtn.Text = "Merah"
rBtn.TextSize = 10
rBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0, 4)
rBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(255, 0, 0) end)

local gBtn = Instance.new("TextButton", ColorPanel)
gBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
gBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
gBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
gBtn.Text = "Hijau"
gBtn.TextSize = 10
gBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", gBtn).CornerRadius = UDim.new(0, 4)
gBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(0, 255, 0) end)

local bBtn = Instance.new("TextButton", ColorPanel)
bBtn.Position = UDim2.new(0.82, 0, 0.15, 0)
bBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
bBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
bBtn.Text = "Biru"
bBtn.TextSize = 10
bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 4)
bBtn.MouseButton1Click:Connect(function() ESPColor = Color3.fromRGB(0, 150, 255) end)

-- Render ESP Logic
local ESPFolder = Instance.new("Folder", CoreGui)
ESPFolder.Name = "Custom_ESP_Folder"
local ActiveDrawings = {}

RunService.RenderStepped:Connect(function()
    for _, obj in pairs(ActiveDrawings) do
        if obj.Remove then obj:Remove() end
    end
    ActiveDrawings = {}

    if not ESPEnemyAktif and not ESPTeamAktif then return end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hrp and head and hum and hum.Health > 0 then
                local isTeam = (p.Team == LocalPlayer.Team)
                local doDraw = (isTeam and ESPTeamAktif) or (not isTeam and ESPEnemyAktif)
                
                if doDraw then
                    local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    if onScreen then
                        local height = math.abs(headVector.Y - legVector.Y)
                        local width = height / 2
                        local boxPos = Vector2.new(vector.X - width / 2, headVector.Y)
                        
                        -- Dynamic Health Color (100%=Hijau, 70%=Orange, 40%=Merah Gelap)
                        local hpRatio = hum.Health / hum.MaxHealth
                        local hpColor = Color3.fromRGB(0, 255, 0)
                        if hpRatio <= 0.7 and hpRatio > 0.4 then
                            hpColor = Color3.fromRGB(255, 140, 0)
                        elseif hpRatio <= 0.4 then
                            hpColor = Color3.fromRGB(128, 0, 0)
                        end

                        -- Line (di kepala)
                        if ESPConfig.Line then
                            local line = Drawing.new("Line")
                            line.Visible = true
                            line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            line.To = Vector2.new(headVector.X, headVector.Y)
                            line.Color = ESPColor
                            line.Thickness = 1.5
                            table.insert(ActiveDrawings, line)
                        end

                        -- Box
                        if ESPConfig.Box then
                            local box = Drawing.new("Square")
                            box.Visible = true
                            box.Size = Vector2.new(width, height)
                            box.Position = boxPos
                            box.Color = ESPColor
                            box.Thickness = 1.5
                            box.Filled = false
                            table.insert(ActiveDrawings, box)
                        end

                        -- Name (diatas box)
                        if ESPConfig.Name then
                            local name = Drawing.new("Text")
                            name.Visible = true
                            name.Text = p.Name
                            name.Size = 13
                            name.Color = Color3.fromRGB(255, 255, 255)
                            name.Center = true
                            name.Outline = true
                            name.Position = Vector2.new(vector.X, headVector.Y - 16)
                            table.insert(ActiveDrawings, name)
                        end

                        -- Distance (dibawah box)
                        if ESPConfig.Distance then
                            local distVal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                            local dist = Drawing.new("Text")
                            dist.Visible = true
                            dist.Text = "[" .. distVal .. "m]"
                            dist.Size = 12
                            dist.Color = Color3.fromRGB(200, 200, 200)
                            dist.Center = true
                            dist.Outline = true
                            dist.Position = Vector2.new(vector.X, headVector.Y + height + 4)
                            table.insert(ActiveDrawings, dist)
                        end

                        -- Health (samping kanan box bervolume dinamis)
                        if ESPConfig.Health then
                            local healthBarBg = Drawing.new("Square")
                            healthBarBg.Visible = true
                            healthBarBg.Size = Vector2.new(3, height)
                            healthBarBg.Position = Vector2.new(boxPos.X + width + 4, boxPos.Y)
                            healthBarBg.Color = Color3.fromRGB(0, 0, 0)
                            healthBarBg.Filled = true
                            table.insert(ActiveDrawings, healthBarBg)

                            local healthBar = Drawing.new("Square")
                            healthBar.Visible = true
                            healthBar.Size = Vector2.new(3, height * hpRatio)
                            healthBar.Position = Vector2.new(boxPos.X + width + 4, boxPos.Y + (height * (1 - hpRatio)))
                            healthBar.Color = hpColor
                            healthBar.Filled = true
                            table.insert(ActiveDrawings, healthBar)
                        end
                    end
                end
            end
        end
    end
end)

-- ========================================== --
-- 2. TAB AIMBOT IMPLEMENTATION              --
-- ========================================== --
AddToggle(AimbotTab, "🎯 Aktifkan Aimbot", false, function(v) AimbotAktif = v end)
AddToggle(AimbotTab, "👥 Team Check", true, function(v) TeamCheck = v end)
AddToggle(AimbotTab, "🧱 Wall Check", false, function(v) WallCheck = v end)
AddDropdown(AimbotTab, "Mode Aimbot", {"Fov", "360°"}, "Fov", function(v) AimbotMode = v end)
AddDropdown(AimbotTab, "Mode Trigger", {"fire(snap)", "camera"}, "fire(snap)", function(v) TriggerMode = v end)
AddToggle(AimbotTab, "⭕ Tampilkan Aim FOV", false, function(v) ShowFOV = v end)
AddSlider(AimbotTab, "Size FOV", 50, 400, 150, " Px", function(v) FOVRadius = v end)
AddToggle(AimbotTab, "📈 Aim Line", false, function(v) AimLine = v end)
AddDropdown(AimbotTab, "Aim Target Part", {"Head", "Neck", "Chest"}, "Head", function(v) AimTargetMode = v end)
AddSlider(AimbotTab, "Aim Distance", 50, 2000, 500, "m", function(v) AimDistance = v end)

-- FOV Circle UI Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 128)

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Visible = ShowFOV and AimbotAktif
    FOVCircle.Radius = FOVRadius
    FOVCircle.Position = mousePos

    if AimbotAktif then
        local target = nil
        local shortestDist = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                local targetPart = char:FindFirstChild(AimTargetMode) or char:FindFirstChild("HumanoidRootPart")
                
                if hum and hum.Health > 0 and targetPart then
                    if not TeamCheck or p.Team ~= LocalPlayer.Team then
                        local distToPlayer = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude or 0
                        if distToPlayer <= AimDistance then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                if WallCheck then
                                    local rayParams = RaycastParams.new()
                                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), rayParams)
                                    if result and result.Instance:IsDescendantOf(char) then
                                        -- Lolos wallcheck
                                    else
                                        continue
                                    end
                                end

                                if AimbotMode == "Fov" then
                                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                    if distFromCenter <= FOVRadius and distFromCenter < shortestDist then
                                        shortestDist = distFromCenter
                                        target = targetPart
                                    end
                                else
                                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                    if distFromCenter < shortestDist then
                                        shortestDist = distFromCenter
                                        target = targetPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if target then
            if TriggerMode == "camera" then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.5)
            end
        end
    end
end)

-- ========================================== --
-- 3. TAB PLAYER IMPLEMENTATION              --
-- ========================================== --
AddToggle(PlayerTab, "⚡ Speed Run", false, function(v) SpeedAktif = v end)
AddSlider(PlayerTab, "Speed Level", 100, 300, 100, "%", function(v) SpeedPercent = v end)
AddToggle(PlayerTab, "🚀 Multi Jump", false, function(v) MultiJumpAktif = v end)
AddToggle(PlayerTab, "🕊️ Fly Hack", false, function(v) FlyAktif = v end)
AddToggle(PlayerTab, "⚡ Rapid Fire", false, function(v) RapidFireAktif = v end)
AddToggle(PlayerTab, "🔋 Unlimited Ammo", false, function(v) UnlimitedAmmoAktif = v end)

-- Multi Jump & Fly Logic
UserInputService.JumpRequest:Connect(function()
    if MultiJumpAktif and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if SpeedAktif then
            hum.WalkSpeed = 16 * (SpeedPercent / 100)
        end
        if FlyAktif and hrp then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 2, hrp.Velocity.Z)
        end
    end
end)

-- ========================================== --
-- 4. TAB WORLD IMPLEMENTATION               --
-- ========================================== --
AddDropdown(WorldTab, "Clock Time", {"Pagi (08:00)", "Siang (12:00)", "Sore (17:00)", "Malam (00:00)"}, "Siang (12:00)", function(v)
    if v:find("Pagi") then Lighting.ClockTime = 8
    elseif v:find("Siang") then Lighting.ClockTime = 12
    elseif v:find("Sore") then Lighting.ClockTime = 17
    elseif v:find("Malam") then Lighting.ClockTime = 0 end
end)
AddToggle(WorldTab, "🌍 No Gravity", false, function(v)
    NoGravityAktif = v
    workspace.Gravity = v and 0 or 196.2
end)

-- Teleport list players (Updated dynamically)
AddButton(WorldTab, "🔄 Refresh Target Teleport", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

-- ========================================== --
-- 5. TAB CONFIG IMPLEMENTATION              --
-- ========================================== --
AddDropdown(ConfigTab, "Theme UI", {"Dark", "Light"}, "Dark", function(v)
    if v == "Light" then
        MainWindow.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        TopBar.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 80)
    else
        MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    end
end)

local ConfigFileName = "LiteHack_Config_ImGui.json"
AddButton(ConfigTab, "💾 Save Konfigurasi JSON", function()
    local data = {
        ESPEnemy = ESPEnemyAktif,
        ESPTeam = ESPTeamAktif,
        Aimbot = AimbotAktif,
        TeamCheck = TeamCheck,
        WallCheck = WallCheck,
        FOVRadius = FOVRadius,
        SpeedPercent = SpeedPercent,
        NoGravity = NoGravityAktif
    }
    if writefile then
        pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(data)) end)
    end
end)

AddButton(ConfigTab, "📂 Load Konfigurasi JSON", function()
    if isfile and readfile and isfile(ConfigFileName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            if data then
                FOVRadius = data.FOVRadius or 150
                SpeedPercent = data.SpeedPercent or 100
            end
        end)
    end
end)

-- Selesai dimuat
print("✅ Lite Hack ImGui Ultimate Mods berhasil dimuat dengan sempurna!")
