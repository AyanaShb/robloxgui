-- =====================================================================
-- PREMIUM MODIFIED LUA SCRIPT: × D3D MENU BG AMIN ×
-- Modern UI ImGui Style with Vertical Scrolling Lists & Aesthetic Design
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Global Configuration Table
getgenv().D3DConfig = {
    MenuVisible = true,
    CurrentTab = "Visual",
    
    -- Visual Features
    EspLine = false,
    EspName = false,
    EspDistance = false,
    EspGender = false,
    EspItem = false,
    ItemRadius = 50,
    Chams = false,
    ChamsColor = Color3.fromRGB(255, 0, 0),
    
    -- Player Features
    SpeedRun = false,
    SpeedValue = 24,
    Fly = false,
    LongJump = false,
    WallHack = false,
    SizeHack = false,
    SizeValue = 1,
    GodMode = false,
    
    -- World Features
    NightMode = false,
    DaylightMode = false,
    LongView = false,
    LongViewValue = 1000,
    
    -- Skill Features
    Aimbot = false,
    AimbotFov = 100,
    UnlimitedAmmo = false,
    FastVehicle = false,
    VehicleSpeedValue = 150
}

-- Safe GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Menu_BG_AMIN_Pro"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Floating Mini Icon "UI" for Hide/Show Menu
local FloatButton = Instance.new("TextButton")
FloatButton.Name = "FloatUI"
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 30, 0, 30)
FloatButton.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
FloatButton.BorderColor3 = Color3.fromRGB(255, 0, 150)
FloatButton.BorderSizePixel = 2
FloatButton.Text = "UI"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 18
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Active = true
FloatButton.Draggable = true
FloatButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = FloatButton

-- Drop Shadow for Floating Button Style
local FloatShadow = Instance.new("UIStroke")
FloatShadow.Color = Color3.fromRGB(255, 0, 150)
FloatShadow.Thickness = 2
FloatShadow.Parent = FloatButton

-- Main Window Frame (Aesthetic Size & Padding)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Gradient background styling (Warna cerah gradient mewah)
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 15, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 25, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 40, 35))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Outline Stroke for Main Window
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 60, 200)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title Header: " × D3D MENU BG AMIN ×"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = " × D3D MENU BG AMIN ×"
TitleLabel.TextColor3 = Color3.fromRGB(255, 130, 220)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Toggle Menu Visibility via Floating Icon
FloatButton.MouseButton1Click:Connect(function()
    D3DConfig.MenuVisible = not D3DConfig.MenuVisible
    MainFrame.Visible = D3DConfig.MenuVisible
end)

-- Tab Headers Container ("Visual", "Player", "world", "skill")
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 35)
TabContainer.Position = UDim2.new(0, 10, 0, 42)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
TabContainer.Parent = MainFrame

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 8)
TabContainerCorner.Parent = TabContainer

local tabs = {"Visual", "Player", "world", "skill"}
local TabButtons = {}
local TabContentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName:gsub("^%l", string.upper)
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer
    
    -- Content Scrolling Frame (Vertical Layout Engine)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -95)
    content.Position = UDim2.new(0, 10, 0, 85)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 200)
    content.Visible = (i == 1)
    content.Parent = MainFrame
    
    -- UIListLayout for strict vertical arrangement
    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 8)
    uiList.Parent = content
    
    -- Auto scale CanvasSize based on elements
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 15)
    end)
    
    TabButtons[tabName] = btn
    TabContentFrames[tabName] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            TabContentFrames[t].Visible = false
            TabButtons[t].TextColor3 = Color3.fromRGB(150, 150, 170)
        end
        content.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        D3DConfig.CurrentTab = tabName
    end)
end

-- =====================================================================
-- PROFESSIONAL COMPONENT CREATORS (Clean Vertical Rows)
-- =====================================================================

local function CreateToggle(parent, text, callback, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 235, 235)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(50, 50, 65)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultVal and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local active = defaultVal or false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 110)
            circle:TweenPosition(UDim2.new(1, -20, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        end
    end)
    
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 25)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(235, 235, 235)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    sliderBg.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(200, 50, 180)
    sliderFill.Parent = sliderBg
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = sliderFill
    
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
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
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + ((max - min) * pos))
            label.Text = text .. ": " .. tostring(val)
            callback(val)
        end
    end)
    
    frame.Parent = parent
end

local function CreateColorCirclePicker(parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = "Chams Colour Circle Palette (Tap to Pick)"
    label.TextColor3 = Color3.fromRGB(255, 140, 220)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(1, -24, 0, 26)
    circleContainer.Position = UDim2.new(0, 12, 0, 28)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = frame
    
    local colors = {
        Color3.fromRGB(255, 0, 0),     -- Red
        Color3.fromRGB(0, 255, 0),     -- Green
        Color3.fromRGB(0, 140, 255),   -- Blue
        Color3.fromRGB(255, 255, 0),   -- Yellow
        Color3.fromRGB(255, 120, 0),   -- Orange
        Color3.fromRGB(180, 0, 255),   -- Purple
        Color3.fromRGB(0, 255, 255),   -- Cyan
        Color3.fromRGB(255, 255, 255)  -- White
    }
    
    for i, col in ipairs(colors) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 26, 0, 26)
        colorBtn.Position = UDim2.new(0, (i-1)*34, 0, 0)
        colorBtn.BackgroundColor3 = col
        colorBtn.Text = ""
        colorBtn.Parent = circleContainer
        
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(1, 0)
        cCorner.Parent = colorBtn
        
        colorBtn.MouseButton1Click:Connect(function()
            callback(col)
        end)
    end
    
    frame.Parent = parent
end

-- =====================================================================
-- POPULATING TABS VERTICALLY
-- =====================================================================

-- 1. VISUAL TAB
local vis = TabContentFrames["Visual"]
CreateToggle(vis, "ESP Line (Top-Center to Head)", function(v) D3DConfig.EspLine = v end)
CreateToggle(vis, "ESP Name (Above Head)", function(v) D3DConfig.EspName = v end)
CreateToggle(vis, "ESP Distance (e.g. 120m)", function(v) D3DConfig.EspDistance = v end)
CreateToggle(vis, "ESP Gender [Cowo/Cewe]", function(v) D3DConfig.EspGender = v end)
CreateToggle(vis, "ESP Item Name (Nearby)", function(v) D3DConfig.EspItem = v end)
CreateSlider(vis, "ESP Item Radius", 10, 200, 50, function(v) D3DConfig.ItemRadius = v end)
CreateToggle(vis, "Chams Body Colour & Wallhack", function(v) D3DConfig.Chams = v end)
CreateColorCirclePicker(vis, function(col) D3DConfig.ChamsColor = col end)

-- 2. PLAYER TAB
local ply = TabContentFrames["Player"]
CreateToggle(ply, "Speed Run Customiser", function(v) D3DConfig.SpeedRun = v end)
CreateSlider(ply, "Speed Value", 16, 100, 24, function(v) D3DConfig.SpeedValue = v end)
CreateToggle(ply, "Fly (Hold Jump Button)", function(v) D3DConfig.Fly = v end)
CreateToggle(ply, "Long Jump", function(v) D3DConfig.LongJump = v end)
CreateToggle(ply, "Wall Hack (No-clip)", function(v) D3DConfig.WallHack = v end)
CreateToggle(ply, "Size Hack Customiser", function(v) D3DConfig.SizeHack = v end)
CreateSlider(ply, "Size Value", 0.5, 3, 1, function(v) D3DConfig.SizeValue = v end)
CreateToggle(ply, "God Mode (Anti Elements/Fall/Damage)", function(v) D3DConfig.GodMode = v end)

-- 3. WORLD TAB
local wrd = TabContentFrames["world"]
CreateToggle(wrd, "Night Mode (Indoor/Outdoor)", function(v) 
    D3DConfig.NightMode = v
    if v then Lighting.ClockTime = 0 else Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Daylight Mode (Indoor/Outdoor)", function(v) 
    D3DConfig.DaylightMode = v
    if v then Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Long View Distance", function(v) D3DConfig.LongView = v end)
CreateSlider(wrd, "View Distance Value", 100, 5000, 1000, function(v) 
    D3DConfig.LongViewValue = v 
end)

-- 4. SKILL TAB
local skl = TabContentFrames["skill"]
CreateToggle(skl, "Aimbot + FOV Circle + Head Lock", function(v) D3DConfig.Aimbot = v end)
CreateSlider(skl, "Aimbot FOV Size", 20, 300, 100, function(v) D3DConfig.AimbotFov = v end)
CreateToggle(skl, "Unlimited Ammo (999/999)", function(v) D3DConfig.UnlimitedAmmo = v end)
CreateToggle(skl, "Fast Vehicle Customiser", function(v) D3DConfig.FastVehicle = v end)
CreateSlider(skl, "Vehicle Speed Value", 50, 400, 150, function(v) D3DConfig.VehicleSpeedValue = v end)

-- Teleport Push Button Vertical Row
local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(1, 0, 0, 42)
tpFrame.BackgroundTransparency = 1
tpFrame.Parent = skl

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, 0, 1, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(140, 40, 180)
tpButton.Text = "Instant Random Player Teleport"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextSize = 13
tpButton.Font = Enum.Font.GothamBold
tpButton.Parent = tpFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpButton

tpButton.MouseButton1Click:Connect(function()
    local allPlayers = Players:GetPlayers()
    local randomTarget = allPlayers[math.random(1, #allPlayers)]
    if randomTarget and randomTarget ~= LocalPlayer and randomTarget.Character and randomTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- =====================================================================
-- CHEAT EXECUTION LOOPS
-- =====================================================================

RunService.RenderStepped:Connect(function()
    if D3DConfig.SpeedRun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = D3DConfig.SpeedValue
    end
    
    if D3DConfig.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService.TouchEnabled then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end
    
    if D3DConfig.LongJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            LocalPlayer.Character.HumanoidRootPart.Velocity = LocalPlayer.Character.HumanoidRootPart.Velocity + (LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 50) + Vector3.new(0, 60, 0)
        end
    end
    
    if D3DConfig.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    if D3DConfig.SizeHack and LocalPlayer.Character then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.BodyHeightScale.Value = D3DConfig.SizeValue
                humanoid.BodyWidthScale.Value = D3DConfig.SizeValue
                humanoid.BodyHeadScale.Value = D3DConfig.SizeValue
            end
        end)
    end
    
    if D3DConfig.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
    
    if D3DConfig.Chams then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = D3DConfig.ChamsColor
                        part.Material = Enum.Material.ForceField
                    end
                end
            end
        end
    end
    
    if D3DConfig.UnlimitedAmmo and LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if (v:IsA("IntValue") or v:IsA("NumberValue")) and (v.Name:lower():match("ammo") or v.Name:lower():match("clip")) then
                        v.Value = 999
                    end
                end
            end
        end
    end
    
    if D3DConfig.FastVehicle and LocalPlayer.Character and LocalPlayer.Character.SeatPart then
        local vehicle = LocalPlayer.Character.SeatPart.Parent
        if vehicle:IsA("Model") and vehicle:FindFirstChild("DriveSeat") then
            vehicle.DriveSeat.AssemblyLinearVelocity = vehicle.DriveSeat.CFrame.LookVector * D3DConfig.VehicleSpeedValue
        end
    end
    
    if D3DConfig.Aimbot then
        local closestTarget = nil
        local shortestDistance = D3DConfig.AimbotFov
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local magnitude = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if magnitude < shortestDistance then
                        shortestDistance = magnitude
                        closestTarget = head
                    end
                end
            end
        end
        
        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position + (closestTarget.Velocity * 0.025))
        end
    end
end)
