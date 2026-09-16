-- ========================================== -- 🎯 LITE HACK + ULTIMATE MODS (IMGUI VERSION) -- (UPDATED WITH DEEP MEMORY SCAN, IMGUI UI, FULL ESP, FLY, & WORLD TIME) -- ========================================== 

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
                        if strKey:find("signature") or strKey:find("checksum") or strKey:find("hash") then
                            target[key] = nil
                        end
                    end
                end
            end)
        end
    end)
end)

-- ========================================== -- VARIABEL UTAMA & CONFIG -- ========================================== 
local ScriptActive = true
local ConfigFileName = "LiteHack_ImGui_Config.json"

-- Status Fitur
local ESP_Enemy = false
local ESP_Team = false
local ESP_Box = false
local ESP_Name = false
local ESP_Line = false
local ESP_Health = false
local ESP_Skeleton = false
local ESP_Distance = false
local ESP_Picture = false
local ESP_Color = Color3.fromRGB(255, 0, 0)

local AimbotAktif = false
local TeamCheck = false
local WallCheck = false
local AimbotMode = "FOV" -- "360°" atau "FOV"
local TriggerMode = "Camera" -- "Camera" atau "Fire (Snap)"
local ShowFOV = false
local AimLineTracer = false
local AimTarget = "Head" -- "Head", "Neck", "Chest"
local AimDistance = 500

local SpeedAktif = false
local CustomSpeed = 50
local JumpAktif = false
local FlyAktif = false
local RapidFireAktif = false
local AmmoAktif = false
local CustomFireRate = 800

local WorldTime = 14
local NoGravity = false

local UITheme = "Dark" -- "Dark" atau "Light"

-- ========================================== -- IMGUI CUSTOM IMPLEMENTATION (LUAU) -- ========================================== 
-- Membuat sistem ImGui kustom yang ringan, responsif, dinamis, support scroll horizontal & vertical.
local TargetGuiParent = (gethui and gethui()) or CoreGui
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "ImGui_LiteHack"
MainScreenGui.Parent = TargetGuiParent
MainScreenGui.IgnoreGuiInset = true
MainScreenGui.DisplayOrder = 999999

-- Floating Icon (Tengkorak)
local FloatIcon = Instance.new("TextButton")
FloatIcon.Name = "FloatIcon"
FloatIcon.Parent = MainScreenGui
FloatIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatIcon.Position = UDim2.new(0, 50, 0, 50)
FloatIcon.Size = UDim2.new(0, 45, 0, 45)
FloatIcon.Font = Enum.Font.SourceSansBold
FloatIcon.Text = "💀"
FloatIcon.TextSize = 24
FloatIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatIcon.Active = true
FloatIcon.Draggable = true
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(0, 10)

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Parent = MainScreenGui
Window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Window.Position = UDim2.new(0.5, -225, 0.5, -175)
Window.Size = UDim2.new(0, 450, 0, 350)
Window.Active = true
Window.Draggable = true
Window.Visible = true
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 8)
local WindowStroke = Instance.new("UIStroke", Window)
WindowStroke.Color = Color3.fromRGB(60, 60, 60)
WindowStroke.Thickness = 1.5

FloatIcon.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

-- Top Bar
local TopBar = Instance.new("Frame", Window)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🎯 Lite Hack ImGui"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol X (Stop Script)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScriptActive = false
    MainScreenGui:Destroy()
end)

-- Tab Header Container (Scroll Horizontal)
local TabHeaderScroll = Instance.new("ScrollingFrame", Window)
TabHeaderScroll.Position = UDim2.new(0, 5, 0, 40)
TabHeaderScroll.Size = UDim2.new(1, -10, 0, 35)
TabHeaderScroll.BackgroundTransparency = 1
TabHeaderScroll.CanvasSize = UDim2.new(2, 0, 0, 0)
TabHeaderScroll.ScrollBarThickness = 2

local TabHeaderLayout = Instance.new("UIListLayout", TabHeaderScroll)
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Padding = UDim.new(0, 5)

-- Content Container (Scroll Vertical)
local ContentContainer = Instance.new("Frame", Window)
ContentContainer.Position = UDim2.new(0, 5, 0, 80)
ContentContainer.Size = UDim2.new(1, -10, 1, -85)
ContentContainer.BackgroundTransparency = 1

local TabsData = {}
local CurrentActiveTab = nil

local function CreateTab(name)
    local TabScroll = Instance.new("ScrollingFrame", ContentContainer)
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    TabScroll.ScrollBarThickness = 4
    TabScroll.Visible = false

    local Layout = Instance.new("UIListLayout", TabScroll)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    
    -- Auto adjust canvas size
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
    end)

    -- Tab Button
    local TabBtn = Instance.new("TextButton", TabHeaderScroll)
    TabBtn.Size = UDim2.new(0, 85, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(TabsData) do
            t.Scroll.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentActiveTab = name
    end)

    if not CurrentActiveTab then
        CurrentActiveTab = name
        TabScroll.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(TabsData, {Name = name, Scroll = TabScroll, Button = TabBtn})
    return TabScroll
end

-- ========================================== -- UI ELEMENTS BUILDERS -- ========================================== 
local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 35, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -42, 0.5, -10)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
        callback(state)
    end)
    return Frame
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 0, 22)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("TextButton", Frame)
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.new(0, 10, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Text = ""
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", SliderBar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
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
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = text .. ": " .. val
            callback(val)
        end
    end)
    return Frame
end

local function AddDropdown(parent, text, options, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local currentIdx = 1
    for i, opt in ipairs(options) do if opt == default then currentIdx = i end end

    local DropBtn = Instance.new("TextButton", Frame)
    DropBtn.Size = UDim2.new(0, 130, 0, 26)
    DropBtn.Position = UDim2.new(1, -135, 0.5, -13)
    DropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.Text = options[currentIdx]
    DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.TextSize = 11
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)

    DropBtn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        DropBtn.Text = options[currentIdx]
        callback(options[currentIdx])
    end)
    return Frame
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -5, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ========================================== -- BUILD TABS -- ========================================== 
local VisualTab = CreateTab("visual")
local PlayerTab = CreateTab("player")
local AimbotTab = CreateTab("aimbot")
local WorldTab = CreateTab("world")
local ConfigTab = CreateTab("config")

-- --- TAB VISUAL ---
AddToggle(VisualTab, "ESP Enemy", false, function(v) ESP_Enemy = v end)
AddToggle(VisualTab, "ESP Team", false, function(v) ESP_Team = v end)
AddToggle(VisualTab, "ESP Box", false, function(v) ESP_Box = v end)
AddToggle(VisualTab, "ESP Name", false, function(v) ESP_Name = v end)
AddToggle(VisualTab, "ESP Line", false, function(v) ESP_Line = v end)
AddToggle(VisualTab, "ESP Health", false, function(v) ESP_Health = v end)
AddToggle(VisualTab, "ESP Skeleton", false, function(v) ESP_Skeleton = v end)
AddToggle(VisualTab, "ESP Distance", false, function(v) ESP_Distance = v end)
AddToggle(VisualTab, "ESP Picture (Avatar)", false, function(v) ESP_Picture = v end)

-- --- TAB AIMBOT ---
AddToggle(AimbotTab, "Aktifkan Aimbot", false, function(v) AimbotAktif = v end)
AddToggle(AimbotTab, "Team Check", false, function(v) TeamCheck = v end)
AddToggle(AimbotTab, "Wall Check", false, function(v) WallCheck = v end)
AddDropdown(AimbotTab, "Mode Aimbot", {"FOV", "360°"}, "FOV", function(v) AimbotMode = v end)
AddDropdown(AimbotTab, "Mode Trigger", {"Camera", "Fire (Snap)"}, "Camera", function(v) TriggerMode = v end)
AddToggle(AimbotTab, "Tampilkan Lingkaran FOV", false, function(v) ShowFOV = v end)
AddToggle(AimbotTab, "Aim Line Tracer", false, function(v) AimLineTracer = v end)
AddDropdown(AimbotTab, "Target Bagian", {"Head", "Neck", "Chest"}, "Head", function(v) AimTarget = v end)
AddSlider(AimbotTab, "Aim Distance", 50, 5000, 500, function(v) AimDistance = v end)

-- --- TAB PLAYER ---
AddToggle(PlayerTab, "Speed Run", false, function(v) SpeedAktif = v end)
AddSlider(PlayerTab, "Custom Speed", 16, 250, 50, function(v) CustomSpeed = v end)
AddToggle(PlayerTab, "Multi Jump Hack", false, function(v) JumpAktif = v end)
AddToggle(PlayerTab, "Fly Hack", false, function(v) FlyAktif = v end)
AddToggle(PlayerTab, "Rapid Fire (RPM)", false, function(v) RapidFireAktif = v end)
AddToggle(PlayerTab, "Unlimited Ammo", false, function(v) AmmoAktif = v end)

-- --- TAB WORLD ---
AddSlider(WorldTab, "World Time (Jam)", 0, 24, 14, function(v) WorldTime = v end)
AddToggle(WorldTab, "No Gravity (Gravitasi Rendah)", false, function(v) NoGravity = v end)

-- --- TAB CONFIG ---
AddButton(ConfigTab, "Ubah Theme UI (Dark/Light)", function()
    if UITheme == "Dark" then
        UITheme = "Light"
        Window.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        TopBar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        TitleLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
    else
        UITheme = "Dark"
        Window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    end
end)

AddButton(ConfigTab, "💾 Save Konfigurasi", function()
    local data = {
        ESP_Enemy = ESP_Enemy, ESP_Team = ESP_Team, ESP_Box = ESP_Box, ESP_Name = ESP_Name,
        ESP_Line = ESP_Line, ESP_Health = ESP_Health, ESP_Skeleton = ESP_Skeleton, ESP_Distance = ESP_Distance, ESP_Picture = ESP_Picture,
        AimbotAktif = AimbotAktif, TeamCheck = TeamCheck, WallCheck = WallCheck, SpeedAktif = SpeedAktif,
        CustomSpeed = CustomSpeed, JumpAktif = JumpAktif, FlyAktif = FlyAktif, RapidFireAktif = RapidFireAktif, AmmoAktif = AmmoAktif
    }
    if writefile then
        pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(data)) end)
    end
end)

AddButton(ConfigTab, "📂 Load Konfigurasi", function()
    if isfile and readfile and isfile(ConfigFileName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            ESP_Enemy = data.ESP_Enemy or false
            ESP_Team = data.ESP_Team or false
            -- Dst...
        end)
    end
end)

-- ========================================== -- FITUR ESP SYSTEM LENGKAP -- ========================================== 
local ESP_Folder = Instance.new("Folder", CoreGui)
ESP_Folder.Name = "ImGui_ESP_Holder"
local ActiveESPCache = {}

RunService.RenderStepped:Connect(function()
    if not ScriptActive then return end
    
    -- Update World Time & Gravity
    pcall(function()
        game:GetService("Lighting").ClockTime = WorldTime
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            workspace.Gravity = NoGravity and 30 or 196.2
        end
    end)

    -- ESP Rendering Loop
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            local isTeam = (p.TeamColor == LocalPlayer.TeamColor)
            local shouldDraw = (isTeam and ESP_Team) or (not isTeam and ESP_Enemy)
            
            if shouldDraw and hrp and head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local cache = ActiveESPCache[p]
                    if not cache then
                        cache = {}
                        cache.Box = Drawing.new("Square")
                        cache.Box.Thickness = 2
                        cache.Box.Filled = false
                        
                        cache.Name = Drawing.new("Text")
                        cache.Name.Size = 13
                        cache.Name.Center = true
                        cache.Name.Outline = true
                        cache.Name.Color = Color3.fromRGB(255, 255, 255)
                        
                        cache.Distance = Drawing.new("Text")
                        cache.Distance.Size = 12
                        cache.Distance.Center = true
                        cache.Distance.Outline = true
                        cache.Distance.Color = Color3.fromRGB(200, 200, 200)
                        
                        cache.Line = Drawing.new("Line")
                        cache.Line.Thickness = 1.5
                        cache.Line.Color = Color3.fromRGB(255, 255, 255)
                        
                        cache.HealthBarBg = Drawing.new("Square")
                        cache.HealthBarBg.Filled = true
                        cache.HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
                        
                        cache.HealthBar = Drawing.new("Square")
                        cache.HealthBar.Filled = true
                        
                        ActiveESPCache[p] = cache
                    end
                    
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    local scale = 2500 / pos.Z
                    local w, h = 1.5 * scale, 2.5 * scale
                    local topPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    
                    -- Box
                    if ESP_Box then
                        cache.Box.Visible = true
                        cache.Box.Size = Vector2.new(w, h)
                        cache.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                        cache.Box.Color = isTeam and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    else
                        cache.Box.Visible = false
                    end
                    
                    -- Name (Di atas Box)
                    if ESP_Name then
                        cache.Name.Visible = true
                        cache.Name.Text = p.Name
                        cache.Name.Position = Vector2.new(pos.X, (pos.Y - h/2) - 18)
                    else
                        cache.Name.Visible = false
                    end
                    
                    -- Distance (Di bawah Box)
                    if ESP_Distance then
                        cache.Distance.Visible = true
                        cache.Distance.Text = math.floor(dist) .. "m"
                        cache.Distance.Position = Vector2.new(pos.X, (pos.Y + h/2) + 4)
                    else
                        cache.Distance.Visible = false
                    end
                    
                    -- Line (Dari atas layar ke kepala)
                    if ESP_Line then
                        cache.Line.Visible = true
                        cache.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        cache.Line.To = Vector2.new(topPos.X, topPos.Y)
                    else
                        cache.Line.Visible = false
                    end
                    
                    -- Health Bar (Di samping kanan box, warna dinamis hijau -> orange -> merah tua)
                    if ESP_Health then
                        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        cache.HealthBarBg.Visible = true
                        cache.HealthBarBg.Size = Vector2.new(3, h)
                        cache.HealthBarBg.Position = Vector2.new((pos.X + w/2) + 4, pos.Y - h/2)
                        
                        cache.HealthBar.Visible = true
                        cache.HealthBar.Size = Vector2.new(3, h * hpRatio)
                        cache.HealthBar.Position = Vector2.new((pos.X + w/2) + 4, (pos.Y + h/2) - (h * hpRatio))
                        
                        if hpRatio > 0.7 then
                            cache.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                        elseif hpRatio > 0.4 then
                            cache.HealthBar.Color = Color3.fromRGB(255, 140, 0)
                        else
                            cache.HealthBar.Color = Color3.fromRGB(139, 0, 0)
                        end
                    else
                        cache.HealthBarBg.Visible = false
                        cache.HealthBar.Visible = false
                    end
                else
                    if ActiveESPCache[p] then
                        ActiveESPCache[p].Box.Visible = false
                        ActiveESPCache[p].Name.Visible = false
                        ActiveESPCache[p].Distance.Visible = false
                        ActiveESPCache[p].Line.Visible = false
                        ActiveESPCache[p].HealthBarBg.Visible = false
                        ActiveESPCache[p].HealthBar.Visible = false
                    end
                end
            else
                if ActiveESPCache[p] then
                    ActiveESPCache[p].Box.Visible = false
                    ActiveESPCache[p].Name.Visible = false
                    ActiveESPCache[p].Distance.Visible = false
                    ActiveESPCache[p].Line.Visible = false
                    ActiveESPCache[p].HealthBarBg.Visible = false
                    ActiveESPCache[p].HealthBar.Visible = false
                end
            end
        end
    end
end)

-- ========================================== -- PLAYER & AIMBOT LOGIC -- ========================================== 
RunService.Stepped:Connect(function()
    if not ScriptActive then return end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            if SpeedAktif then hum.WalkSpeed = CustomSpeed end
            if JumpAktif then hum.UseJumpPower = true; hum.JumpPower = 150 end
            if FlyAktif and hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 1, hrp.Velocity.Z)
            end
        end
    end
end)

-- Deep Memory Scan Gun Mods (Rapid Fire & Ammo)
task.spawn(function()
    while task.wait(1) do
        if ScriptActive and (RapidFireAktif or AmmoAktif) then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if AmmoAktif then
                            if rawget(v, "Ammo") then v.Ammo = 999999 end
                            if rawget(v, "MaxAmmo") then v.MaxAmmo = 999999 end
                            if rawget(v, "ClipSize") then v.ClipSize = 999999 end
                        end
                        if RapidFireAktif then
                            if rawget(v, "RPM") then v.RPM = 2500 end
                            if rawget(v, "FireRate") then v.FireRate = 0.02 end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield = { Notify = function(self, data) print(data.Title .. ": " .. data.Content) end }
Rayfield:Notify({Title = "🎯 Sukses", Content = "ImGui Lite Hack Berhasil Dimuat!", Duration = 3})
