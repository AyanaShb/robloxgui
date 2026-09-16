-- ==========================================
-- LITE HACK + ULTIMATE MODS (IMGUI EDITION)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT
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
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("handshake") or name:find("validate") or name:find("verify") or name:find("integrity") or name:find("anti") then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then remote.FireServer = function(...) return true end
                        elseif remote:IsA("RemoteFunction") then remote.InvokeServer = function(...) return true end
                        end
                    end)
                end
            end
        end
    end)
end)

-- ==========================================
-- STATE VARIABEL UTAMA
-- ==========================================
local Config = {
    -- Visual / ESP
    ESPEnemy = false,
    ESPTeam = false,
    ESPColor = Color3.fromRGB(0, 255, 128),
    ESPBox = true,
    ESPName = true,
    ESPLine = true,
    ESPHealth = true,
    ESPSkeleton = false,
    ESPDistance = true,
    ESPPicture = true,

    -- Aimbot
    AimbotAktif = false,
    TeamCheck = true,
    WallCheck = true,
    AimbotMode = "FOV", -- "360°", "FOV"
    TriggerMode = "Camera", -- "Fire (Snap)", "Camera"
    ShowFOV = false,
    FOVRadius = 150,
    AimLine = false,
    AimTargetMode = "Head", -- "Head", "Neck", "Chest"
    AimDistance = 500,

    -- Player
    SpeedAktif = false,
    CustomSpeed = 50,
    MultiJump = false,
    FlyAktif = false,
    RapidFire = false,
    UnlimitedAmmo = false,
    CustomFireRate = 800,

    -- World
    ClockTimeMode = "Siang",
    NoGravity = false,
    SelectedTeleportPlayer = "",

    -- Config
    Theme = "Dark"
}

-- ==========================================
-- CUSTOM IMGUI-STYLE UI LIBRARY GENERATOR
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_UniversalCheat"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Floating Icon (Skull Glow-up)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingSkull"
FloatingBtn.Parent = ScreenGui
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 30, 0, 150)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FloatingBtn.BackgroundTransparency = 0.2
FloatingBtn.Text = "💀"
FloatingBtn.TextSize = 26
FloatingBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
FloatingBtn.AutoButtonColor = false

local SkullCorner = Instance.new("UICorner", FloatingBtn)
SkullCorner.CornerRadius = UDim.new(1, 0)
local SkullStroke = Instance.new("UIStroke", FloatingBtn)
SkullStroke.Color = Color3.fromRGB(0, 255, 128)
SkullStroke.Thickness = 2

-- Main Window Frame
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWindow.Size = UDim2.new(0, 540, 0, 380)
MainWindow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainWindow.BackgroundTransparency = 0.15
MainWindow.Visible = true

local MainCorner = Instance.new("UICorner", MainWindow)
MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainWindow)
MainStroke.Color = Color3.fromRGB(0, 255, 128)
MainStroke.Thickness = 1.5

-- Top Bar / Dragging
local TopBar = Instance.new("Frame", MainWindow)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
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

FloatingBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = not MainWindow.Visible
end)

-- Tab Header (Horizontal Scrolling)
local TabHeaderFrame = Instance.new("ScrollingFrame", MainWindow)
TabHeaderFrame.Position = UDim2.new(0, 10, 0, 40)
TabHeaderFrame.Size = UDim2.new(1, -20, 0, 35)
TabHeaderFrame.BackgroundTransparency = 1
TabHeaderFrame.CanvasSize = UDim2.new(0, 450, 0, 0)
TabHeaderFrame.ScrollBarThickness = 2
TabHeaderFrame.ScrollingDirection = Enum.ScrollingDirection.X

local TabListLayout = Instance.new("UIListLayout", TabHeaderFrame)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)

-- Content Container
local ContentContainer = Instance.new("Frame", MainWindow)
ContentContainer.Position = UDim2.new(0, 10, 0, 80)
ContentContainer.Size = UDim2.new(1, -20, 1, -90)
ContentContainer.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}
local activeTabName = nil

local function CreateTab(name)
    local TabScroll = Instance.new("ScrollingFrame", ContentContainer)
    TabScroll.Name = name .. "_Tab"
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.ScrollBarThickness = 4
    TabScroll.Visible = false

    local Layout = Instance.new("UIListLayout", TabScroll)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton", TabHeaderFrame)
    TabBtn.Size = UDim2.new(0, 95, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        TabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
    end)

    if not activeTabName then
        activeTabName = name
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        TabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
    end

    Tabs[name] = TabScroll
    table.insert(TabButtons, TabBtn)
    return TabScroll
end

-- UI Element Builders
local function AddToggle(parent, text, default, callback)
    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 32)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = "   " .. text .. ": " .. (default and "[ON]" or "[OFF]")
    ToggleBtn.TextColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
    ToggleBtn.TextSize = 12
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = "   " .. text .. ": " .. (state and "[ON]" or "[OFF]")
        ToggleBtn.TextColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
    return ToggleBtn
end

local function AddSlider(parent, text, min, max, default, suffix, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 8, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = text .. ": " .. default .. suffix
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("Frame", Frame)
    SliderBar.Size = UDim2.new(1, -16, 0, 6)
    SliderBar.Position = UDim2.new(0, 8, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", SliderBar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. val .. suffix
        callback(val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
end

local function AddDropdown(parent, text, options, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local currentIdx = 1
    for i, opt in ipairs(options) do if opt == default then currentIdx = i end end

    local ValBtn = Instance.new("TextButton", Frame)
    ValBtn.Size = UDim2.new(0.4, -8, 0, 25)
    ValBtn.Position = UDim2.new(0.6, 0, 0.5, -12.5)
    ValBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    ValBtn.Font = Enum.Font.GothamBold
    ValBtn.Text = tostring(default)
    ValBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
    ValBtn.TextSize = 11
    Instance.new("UICorner", ValBtn).CornerRadius = UDim.new(0, 4)

    ValBtn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        local selected = options[currentIdx]
        ValBtn.Text = tostring(selected)
        callback(selected)
    end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ==========================================
-- MEMBUAT TAB HEADER & FITUR
-- ==========================================
local VisualTab = CreateTab("Visual")
local AimbotTab = CreateTab("Aimbot")
local PlayerTab = CreateTab("Player")
local WorldTab = CreateTab("World")
local ConfigTab = CreateTab("Config")

-- ------------------------------------------
-- TAB VISUAL
-- ------------------------------------------
AddToggle(VisualTab, "ESP Enemy", Config.ESPEnemy, function(v) Config.ESPEnemy = v end)
AddToggle(VisualTab, "ESP Team", Config.ESPTeam, function(v) Config.ESPTeam = v end)

-- Widget Panel Pemilihan Warna RGB ESP
local ColorPanel = Instance.new("Frame", VisualTab)
ColorPanel.Size = UDim2.new(1, 0, 0, 95)
ColorPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Instance.new("UICorner", ColorPanel).CornerRadius = UDim.new(0, 6)

local ColorTitle = Instance.new("TextLabel", ColorPanel)
ColorTitle.Size = UDim2.new(1, -10, 0, 20)
ColorTitle.Position = UDim2.new(0, 8, 0, 4)
ColorTitle.BackgroundTransparency = 1
ColorTitle.Font = Enum.Font.GothamBold
ColorTitle.Text = "🎨 ESP RGB Color Uniform"
ColorTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ColorTitle.TextSize = 11
ColorTitle.TextXAlignment = Enum.TextXAlignment.Left

local rVal, gVal, bVal = 0, 255, 128
AddSlider(ColorPanel, "Red", 0, 255, 0, "", function(v) rVal = v; Config.ESPColor = Color3.fromRGB(rVal, gVal, bVal) end)
AddSlider(ColorPanel, "Green", 0, 255, 255, "", function(v) gVal = v; Config.ESPColor = Color3.fromRGB(rVal, gVal, bVal) end)
AddSlider(ColorPanel, "Blue", 0, 255, 128, "", function(v) bVal = v; Config.ESPColor = Color3.fromRGB(rVal, gVal, bVal) end)

-- Checkbox Komponen ESP
AddToggle(VisualTab, "ESP Box", Config.ESPBox, function(v) Config.ESPBox = v end)
AddToggle(VisualTab, "ESP Name", Config.ESPName, function(v) Config.ESPName = v end)
AddToggle(VisualTab, "ESP Line", Config.ESPLine, function(v) Config.ESPLine = v end)
AddToggle(VisualTab, "ESP Health", Config.ESPHealth, function(v) Config.ESPHealth = v end)
AddToggle(VisualTab, "ESP Skeleton", Config.ESPSkeleton, function(v) Config.ESPSkeleton = v end)
AddToggle(VisualTab, "ESP Distance", Config.ESPDistance, function(v) Config.ESPDistance = v end)
AddToggle(VisualTab, "ESP Picture (Avatar)", Config.ESPPicture, function(v) Config.ESPPicture = v end)

-- ------------------------------------------
-- TAB AIMBOT
-- ------------------------------------------
AddToggle(AimbotTab, "Aimbot", Config.AimbotAktif, function(v) Config.AimbotAktif = v end)
AddToggle(AimbotTab, "Team Check", Config.TeamCheck, function(v) Config.TeamCheck = v end)
AddToggle(AimbotTab, "Wall Check", Config.WallCheck, function(v) Config.WallCheck = v end)
AddDropdown(AimbotTab, "Mode Aimbot", {"360°", "FOV"}, Config.AimbotMode, function(v) Config.AimbotMode = v end)
AddDropdown(AimbotTab, "Mode Trigger", {"Fire (Snap)", "Camera"}, Config.TriggerMode, function(v) Config.TriggerMode = v end)
AddToggle(AimbotTab, "Aim FOV Circle", Config.ShowFOV, function(v) Config.ShowFOV = v end)
AddSlider(AimbotTab, "Size FOV", 10, 500, Config.FOVRadius, " Px", function(v) Config.FOVRadius = v end)
AddToggle(AimbotTab, "Aim Line", Config.AimLine, function(v) Config.AimLine = v end)
AddDropdown(AimbotTab, "Aim Target", {"Head", "Neck", "Chest"}, Config.AimTargetMode, function(v) Config.AimTargetMode = v end)
AddSlider(AimbotTab, "Aim Distance", 50, 5000, Config.AimDistance, " M", function(v) Config.AimDistance = v end)

-- ------------------------------------------
-- TAB PLAYER
-- ------------------------------------------
AddToggle(PlayerTab, "Speed Run", Config.SpeedAktif, function(v) Config.SpeedAktif = v end)
AddSlider(PlayerTab, "Speed % / Value", 16, 250, Config.CustomSpeed, " Spd", function(v) Config.CustomSpeed = v end)
AddToggle(PlayerTab, "Multi Jump", Config.MultiJump, function(v) Config.MultiJump = v end)
AddToggle(PlayerTab, "Fly Hack (Hold Jump)", Config.FlyAktif, function(v) Config.FlyAktif = v end)
AddToggle(PlayerTab, "Rapid Fire (RPM)", Config.RapidFire, function(v) Config.RapidFire = v end)
AddToggle(PlayerTab, "Unlimited Ammo", Config.UnlimitedAmmo, function(v) Config.UnlimitedAmmo = v end)

-- ------------------------------------------
-- TAB WORLD
-- ------------------------------------------
AddDropdown(WorldTab, "Clock Time", {"Pagi (06:00)", "Siang (12:00)", "Sore (15:00)", "Malam (00:00)"}, "Siang (12:00)", function(v)
    if v:find("Pagi") then Lighting.ClockTime = 6
    elseif v:find("Siang") then Lighting.ClockTime = 12
    elseif v:find("Sore") then Lighting.ClockTime = 15
    elseif v:find("Malam") then Lighting.ClockTime = 0
    end
end)
AddToggle(WorldTab, "No Gravity", Config.NoGravity, function(v)
    Config.NoGravity = v
    workspace.Gravity = v and 0 or 196.2
end)

-- Teleport List Box Dropdown
local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(playerNames, p.Name) end end
Players.PlayerAdded:Connect(function(p) table.insert(playerNames, p.Name) end)
AddDropdown(WorldTab, "Teleport ke Player", #playerNames > 0 and playerNames or {"Tidak ada player"}, "Pilih Player", function(v)
    Config.SelectedTeleportPlayer = v
end)
AddButton(WorldTab, "🚀 Eksekusi Teleport", function()
    local target = Players:FindFirstChild(Config.SelectedTeleportPlayer)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- ------------------------------------------
-- TAB CONFIG
-- ------------------------------------------
AddDropdown(ConfigTab, "Theme UI", {"Dark", "Light"}, Config.Theme, function(v)
    Config.Theme = v
    if v == "Light" then
        MainWindow.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 80)
    else
        MainWindow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    end
end)

local ConfigFileName = "LiteHack_Config_ImGui.json"
AddButton(ConfigTab, "💾 Save Konfigurasi (JSON)", function()
    pcall(function()
        local data = HttpService:JSONEncode(Config)
        if writefile then writefile(ConfigFileName, data) end
    end)
end)
AddButton(ConfigTab, "📂 Load Konfigurasi (JSON)", function()
    pcall(function()
        if isfile and readfile and isfile(ConfigFileName) then
            local data = readfile(ConfigFileName)
            local decoded = HttpService:JSONDecode(data)
            for k, v in pairs(decoded) do Config[k] = v end
        end
    end)
end)

-- ==========================================
-- 🎯 LOGIKA ESP (BOX, NAME, LINE, HEALTH, SKELETON, DISTANCE, PICTURE)
-- ==========================================
local ESP_Folder = CoreGui:FindFirstChild("ImGui_ESP_System") or Instance.new("Folder")
ESP_Folder.Name = "ImGui_ESP_System"
ESP_Folder.Parent = CoreGui
local Active_ESP = {}

RunService.RenderStepped:Connect(function()
    local isESPActive = Config.ESPEnemy or Config.ESPTeam
    if not isESPActive then
        for _, d in pairs(Active_ESP) do
            if d.Box then d.Box.Visible = false end
            if d.Gui then d.Gui.Enabled = false end
            if d.Line then d.Line.Visible = false end
            if d.SkeletonLines then for _, l in pairs(d.SkeletonLines) do l.Visible = false end end
        end
        return
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            local head = char:FindFirstChild("Head")
            
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)
            local shouldRender = (isTeam and Config.ESPTeam) or (not isTeam and Config.ESPEnemy)

            if hum and hum.Health > 0 and hrp and head and shouldRender then
                if not Active_ESP[p] then
                    local ed = {}
                    -- Drawing Box / UI Tag
                    local bgui = Instance.new("BillboardGui", ESP_Folder)
                    bgui.Size = UDim2.new(0, 200, 0, 80)
                    bgui.AlwaysOnTop = true
                    bgui.ExtentsOffset = Vector3.new(0, 3.5, 0)
                    
                    local txt = Instance.new("TextLabel", bgui)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Font = Enum.Font.Code
                    txt.TextSize = 13
                    txt.TextStrokeTransparency = 0
                    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txt.TextYAlignment = Enum.TextYAlignment.Top

                    -- Profile Picture ImageLabel
                    local img = Instance.new("ImageLabel", bgui)
                    img.Size = UDim2.new(0, 32, 0, 32)
                    img.Position = UDim2.new(0.5, -16, 0, -38)
                    img.BackgroundTransparency = 1
                    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

                    ed.Gui = bgui
                    ed.Text = txt
                    ed.Image = img
                    Active_ESP[p] = ed
                end

                local data = Active_ESP[p]
                data.Gui.Enabled = true
                
                -- Dynamic Health Color Calculation
                local hpPct = hum.Health / hum.MaxHealth
                local hpColor = Color3.fromRGB(0, 255, 0)
                if hpPct <= 0.7 and hpPct > 0.4 then hpColor = Color3.fromRGB(255, 165, 0)
                elseif hpPct <= 0.4 then hpColor = Color3.fromRGB(139, 0, 0) end

                -- Text Info Construction
                local infoText = ""
                if Config.ESPName then infoText = infoText .. p.Name .. "\n" end
                if Config.ESPHealth then infoText = infoText .. "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "\n" end
                if Config.ESPDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    infoText = infoText .. "[" .. dist .. "m]"
                end
                data.Text.Text = infoText
                data.Text.TextColor3 = Config.ESPColor

                -- Profile Thumbnail Fetch
                if Config.ESPPicture then
                    pcall(function()
                        local thumb = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                        data.Image.Image = thumb
                        data.Image.Visible = true
                    end)
                else
                    data.Image.Visible = false
                end
            else
                if Active_ESP[p] and Active_ESP[p].Gui then Active_ESP[p].Gui.Enabled = false end
            end
        end
    end
end)

-- ==========================================
-- 🎯 LOGIKA AIMBOT & TRIGGER
-- ==========================================
RunService.RenderStepped:Connect(function()
    if not Config.AimbotAktif then return end

    local closestTarget = nil
    local shortestDist = Config.AimbotMode == "FOV" and Config.FOVRadius or math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(Config.AimTargetMode) or char:FindFirstChild("HumanoidRootPart")
            
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)
            if hum and hum.Health > 0 and part then
                if not (Config.TeamCheck and isTeam) then
                    local dist3D = (Camera.CFrame.Position - part.Position).Magnitude
                    if dist3D <= Config.AimDistance then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist2D = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                            if dist2D < shortestDist then
                                shortestDist = dist2D
                                closestTarget = part
                            end
                        end
                    end
                end
            end
        end
    end

    if closestTarget then
        if Config.AimbotMode == "360°" or Config.AimbotMode == "FOV" then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closestTarget.Position)
        end
    end
end)

-- ==========================================
-- 🏃 LOGIKA PLAYER HACKS (SPEED, MULTI JUMP, FLY, GUN MODS)
-- ==========================================
UserInputService.JumpRequest:Connect(function()
    if Config.MultiJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and Config.SpeedAktif then
            hum.WalkSpeed = Config.CustomSpeed
        end
        if hrp and Config.FlyAktif and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end
end)

-- Gun Mods (Unlimited Ammo & Rapid Fire)
RunService.RenderStepped:Connect(function()
    if (Config.UnlimitedAmmo or Config.RapidFire) and LocalPlayer.Character then
        pcall(function()
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                            local name = obj.Name:lower()
                            if Config.UnlimitedAmmo and (name:find("ammo") or name:find("clip") or name:find("mag")) then
                                obj.Value = 99999
                            end
                            if Config.RapidFire and (name:find("firerate") or name:find("rpm") or name:find("rate")) then
                                obj.Value = Config.CustomFireRate
                            end
                        end
                    end
                end
            end
        end)
    end
end)

Rayfield = nil -- Clear reference
print("🎯 Lite Hack ImGui Loaded Successfully!")
