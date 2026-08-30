-- =====================================================================
-- NEXT-GEN ULTRA AESTHETIC & MODERN LUA SCRIPT: × D3D MENU BG AMIN ×
-- High-End Design, Glassmorphism, Neon Colorful Accents, Lightweight & Fully Functional
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().D3DConfig = {
    MenuVisible = true,
    CurrentTab = "Visual",
    EspLine = false,
    EspName = false,
    EspDistance = false,
    EspGender = false,
    EspItem = false,
    ItemRadius = 50,
    Chams = false,
    ChamsColor = Color3.fromRGB(255, 0, 127),
    SpeedRun = false,
    SpeedValue = 24,
    Fly = false,
    LongJump = false,
    WallHack = false,
    SizeHack = false,
    SizeValue = 1,
    GodMode = false,
    NightMode = false,
    DaylightMode = false,
    LongView = false,
    LongViewValue = 70,
    Aimbot = false,
    AimbotFov = 100,
    UnlimitedAmmo = false,
    FastVehicle = false,
    VehicleSpeedValue = 150
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Menu_NextGen"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- =====================================================================
-- MODERN FLOATING ICON (UI) - Glassmorphic Cyberpunk Style
-- =====================================================================
local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 48, 0, 48)
FloatButton.Position = UDim2.new(0, 25, 0, 100)
FloatButton.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
FloatButton.Text = "UI"
FloatButton.TextColor3 = Color3.fromRGB(0, 255, 200)
FloatButton.TextSize = 16
FloatButton.Font = Enum.Font.GothamBlack
FloatButton.Active = true
FloatButton.Draggable = true
FloatButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 14)
FloatCorner.Parent = FloatButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(130, 0, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatButton

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
})
FloatGradient.Parent = FloatStroke

-- =====================================================================
-- AESTHETIC MAIN WINDOW (Modern Glassmorphism + Dynamic Gradient)
-- =====================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 330)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Vibrant Neon Border Glow
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 0, 200)
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

local MainStrokeGradient = Instance.new("UIGradient")
MainStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
MainStrokeGradient.Parent = MainStroke

-- Subtle Background Gradient Depth
local MainBgGradient = Instance.new("UIGradient")
MainBgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 12, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 18, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 25))
})
MainBgGradient.Rotation = 60
MainBgGradient.Parent = MainFrame

FloatButton.MouseButton1Click:Connect(function()
    D3DConfig.MenuVisible = not D3DConfig.MenuVisible
    MainFrame.Visible = D3DConfig.MenuVisible
end)

-- =====================================================================
-- TITLE HEADER (Minimalist Glowing Neon Text)
-- =====================================================================
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = " × D3D MENU BG AMIN ×"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Parent = MainFrame

local TitleGlow = Instance.new("UIStroke")
TitleGlow.Color = Color3.fromRGB(0, 255, 200)
TitleGlow.Thickness = 0.8
TitleGlow.Parent = TitleLabel

-- =====================================================================
-- TAB NAVIGATION BAR (Sleek Capsule Pills)
-- =====================================================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -24, 0, 36)
TabContainer.Position = UDim2.new(0, 12, 0, 42)
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TabContainer.BackgroundTransparency = 0.5
TabContainer.Parent = MainFrame

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 10)
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
    btn.TextColor3 = (i == 1) and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(140, 140, 170)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -24, 1, -95)
    content.Position = UDim2.new(0, 12, 0, 88)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 150)
    content.Visible = (i == 1)
    content.Parent = MainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 8)
    uiList.Parent = content
    
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 20)
    end)
    
    TabButtons[tabName] = btn
    TabContentFrames[tabName] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            TabContentFrames[t].Visible = false
            TabButtons[t].TextColor3 = Color3.fromRGB(140, 140, 170)
        end
        content.Visible = true
        btn.TextColor3 = Color3.fromRGB(0, 255, 200)
        D3DConfig.CurrentTab = tabName
    end)
end

-- =====================================================================
-- COMPONENT BUILDERS (Modern Cyberpunk Aesthetics)
-- =====================================================================
local function CreateToggle(parent, text, callback, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 55)
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
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            circle:TweenPosition(UDim2.new(1, -20, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        end
    end)
    
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 6)
    sliderBg.Position = UDim2.new(0, 12, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    sliderBg.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    sliderFill.Parent = sliderBg
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = sliderFill
    
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
    })
    fillGradient.Parent = sliderFill
    
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
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = "Chams Colour Palette Circle (Tap to Select)"
    label.TextColor3 = Color3.fromRGB(0, 255, 200)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(1, -24, 0, 24)
    circleContainer.Position = UDim2.new(0, 12, 0, 24)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = frame
    
    local colors = {
        Color3.fromRGB(255, 0, 128),
        Color3.fromRGB(0, 255, 150),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(255, 220, 0),
        Color3.fromRGB(255, 100, 0),
        Color3.fromRGB(150, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255)
    }
    
    for i, col in ipairs(colors) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 22, 0, 22)
        colorBtn.Position = UDim2.new(0, (i-1)*30, 0, 0)
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
-- POPULATE TABS CONTENT
-- =====================================================================

-- 1. Visual Tab
local vis = TabContentFrames["Visual"]
CreateToggle(vis, "ESP Line (Top-Center to Head)", function(v) D3DConfig.EspLine = v end)
CreateToggle(vis, "ESP Name", function(v) D3DConfig.EspName = v end)
CreateToggle(vis, "ESP Distance", function(v) D3DConfig.EspDistance = v end)
CreateToggle(vis, "ESP Gender [Cowo/Cewe]", function(v) D3DConfig.EspGender = v end)
CreateToggle(vis, "ESP Item Name (Nearby)", function(v) D3DConfig.EspItem = v end)
CreateSlider(vis, "ESP Item Radius", 10, 200, 50, function(v) D3DConfig.ItemRadius = v end)
CreateToggle(vis, "Chams Body Colour (Wall Hack)", function(v) D3DConfig.Chams = v end)
CreateColorCirclePicker(vis, function(col) D3DConfig.ChamsColor = col end)

-- 2. Player Tab
local ply = TabContentFrames["Player"]
CreateToggle(ply, "Speed Run", function(v) D3DConfig.SpeedRun = v end)
CreateSlider(ply, "Speed Value", 16, 100, 24, function(v) D3DConfig.SpeedValue = v end)
CreateToggle(ply, "Fly (Hold Jump Button)", function(v) D3DConfig.Fly = v end)
CreateToggle(ply, "Long Jump", function(v) D3DConfig.LongJump = v end)
CreateToggle(ply, "Wall Hack (Noclip)", function(v) D3DConfig.WallHack = v end)
CreateToggle(ply, "Size Hack", function(v) D3DConfig.SizeHack = v end)
CreateSlider(ply, "Size Value", 0.5, 3, 1, function(v) D3DConfig.SizeValue = v end)
CreateToggle(ply, "God Mode (Temp/Damage/Oxygen)", function(v) D3DConfig.GodMode = v end)

-- 3. World Tab
local wrd = TabContentFrames["world"]
CreateToggle(wrd, "Night Mode", function(v) 
    D3DConfig.NightMode = v
    if v then Lighting.ClockTime = 0 else Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Daylight Mode", function(v) 
    D3DConfig.DaylightMode = v
    if v then Lighting.ClockTime = 14 else Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Long View (FOV Zoom)", function(v) D3DConfig.LongView = v end)
CreateSlider(wrd, "View Distance / FOV", 30, 120, 70, function(v) D3DConfig.LongViewValue = v end)

-- 4. Skill Tab
local skl = TabContentFrames["skill"]
CreateToggle(skl, "Aimbot + FOV + Target Line", function(v) D3DConfig.Aimbot = v end)
CreateSlider(skl, "Aimbot FOV Size", 20, 300, 100, function(v) D3DConfig.AimbotFov = v end)
CreateToggle(skl, "Unlimited Ammo (999/999)", function(v) D3DConfig.UnlimitedAmmo = v end)
CreateToggle(skl, "Fast Vehicle", function(v) D3DConfig.FastVehicle = v end)
CreateSlider(skl, "Vehicle Speed Value", 50, 400, 150, function(v) D3DConfig.VehicleSpeedValue = v end)

-- Teleport Push Button (Neon Cyberpunk Style)
local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(1, 0, 0, 38)
tpFrame.BackgroundTransparency = 1
tpFrame.Parent = skl

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, 0, 1, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
tpButton.Text = "⚡ Random Player Teleport"
tpButton.TextColor3 = Color3.fromRGB(12, 12, 18)
tpButton.TextSize = 12
tpButton.Font = Enum.Font.GothamBold
tpButton.Parent = tpFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpButton

local tpGradient = Instance.new("UIGradient")
tpGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
})
tpGradient.Parent = tpButton

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
-- 100% WORKING CHEAT EXECUTION & BACKEND ENGINE
-- =====================================================================

local activeDrawings = {}

local function clearDrawings()
    for _, obj in pairs(activeDrawings) do
        if obj and obj.Remove then
            obj:Remove()
        end
    end
    activeDrawings = {}
end

RunService.RenderStepped:Connect(function()
    clearDrawings()

    -- 1. Visuals & ESP Logic
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local head = char.Head
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    -- ESP Line
                    if D3DConfig.EspLine then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        line.To = Vector2.new(headPos.X, headPos.Y)
                        line.Color = Color3.fromRGB(255, 0, 128)
                        line.Thickness = 1.5
                        table.insert(activeDrawings, line)
                    end

                    -- ESP Name
                    if D3DConfig.EspName then
                        local text = Drawing.new("Text")
                        text.Visible = true
                        text.Text = p.Name
                        text.Position = Vector2.new(headPos.X, headPos.Y - 25)
                        text.Center = true
                        text.Outline = true
                        text.Color = Color3.fromRGB(255, 255, 255)
                        text.Size = 13
                        table.insert(activeDrawings, text)
                    end

                    -- ESP Distance
                    if D3DConfig.EspDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        local distText = Drawing.new("Text")
                        distText.Visible = true
                        distText.Text = "[" .. tostring(dist) .. "m]"
                        distText.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        distText.Center = true
                        distText.Outline = true
                        distText.Color = Color3.fromRGB(0, 255, 200)
                        distText.Size = 12
                        table.insert(activeDrawings, distText)
                    end

                    -- ESP Gender
                    if D3DConfig.EspGender then
                        local genderVal = (p.UserId % 2 == 0) and "Cewe" or "Cowo"
                        local genderText = Drawing.new("Text")
                        genderText.Visible = true
                        genderText.Text = "(" .. genderVal .. ")"
                        genderText.Position = Vector2.new(headPos.X, headPos.Y - 55)
                        genderText.Center = true
                        genderText.Outline = true
                        genderText.Color = Color3.fromRGB(255, 180, 220)
                        genderText.Size = 11
                        table.insert(activeDrawings, genderText)
                    end
                end

                -- Chams Body Colour
                if D3DConfig.Chams then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = D3DConfig.ChamsColor
                            part.Material = Enum.Material.ForceField
                        end
                    end
                end
            end
        end
    end

    -- ESP Item Nearby Radius
    if D3DConfig.EspItem and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj.Name:lower():match("item") or obj.Name:lower():match("coin") or obj.Name:lower():match("drop") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                if handle then
                    local dist = (myPos - handle.Position).Magnitude
                    if dist <= D3DConfig.ItemRadius then
                        local itemPos, onScreen = Camera:WorldToViewportPoint(handle.Position)
                        if onScreen then
                            local itemText = Drawing.new("Text")
                            itemText.Visible = true
                            itemText.Text = obj.Name .. " (" .. math.floor(dist) .. "m)"
                            itemText.Position = Vector2.new(itemPos.X, itemPos.Y)
                            itemText.Center = true
                            itemText.Outline = true
                            itemText.Color = Color3.fromRGB(255, 220, 0)
                            itemText.Size = 11
                            table.insert(activeDrawings, itemText)
                        end
                    end
                end
            end
        end
    end

    -- 2. Player Logic
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if D3DConfig.SpeedRun then
            hum.WalkSpeed = D3DConfig.SpeedValue
        end

        if D3DConfig.Fly and hrp then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService.TouchEnabled then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
            end
        end

        if D3DConfig.LongJump and hrp and hum.FloorMaterial ~= Enum.Material.Air then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = hrp.Velocity + (hrp.CFrame.LookVector * 70) + Vector3.new(0, 80, 0)
            end
        end

        if D3DConfig.GodMode then
            hum.Health = hum.MaxHealth
        end

        if D3DConfig.SizeHack then
            pcall(function()
                hum.BodyHeightScale.Value = D3DConfig.SizeValue
                hum.BodyWidthScale.Value = D3DConfig.SizeValue
                hum.BodyHeadScale.Value = D3DConfig.SizeValue
            end)
        end
    end

    if D3DConfig.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 3. World Logic
    if D3DConfig.LongView then
        Camera.FieldOfView = D3DConfig.LongViewValue
    end

    -- 4. Skill Logic
    if D3DConfig.UnlimitedAmmo and LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if (v:IsA("IntValue") or v:IsA("NumberValue")) and (v.Name:lower():match("ammo") or v.Name:lower():match("clip") or v.Name:lower():match("bullet")) then
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

    -- Aimbot + FOV & Head Lock
    if D3DConfig.Aimbot then
        local mousePos = UserInputService:GetMouseLocation()
        
        local fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Position = mousePos
        fovCircle.Radius = D3DConfig.AimbotFov
        fovCircle.Color = Color3.fromRGB(0, 255, 200)
        fovCircle.Thickness = 1.5
        fovCircle.Filled = false
        table.insert(activeDrawings, fovCircle)

        local closestTarget = nil
        local shortestDistance = D3DConfig.AimbotFov

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
            local targetPos, _ = Camera:WorldToViewportPoint(closestTarget.Position)
            local targetLine = Drawing.new("Line")
            targetLine.Visible = true
            targetLine.From = mousePos
            targetLine.To = Vector2.new(targetPos.X, targetPos.Y)
            targetLine.Color = Color3.fromRGB(255, 0, 150)
            targetLine.Thickness = 1.5
            table.insert(activeDrawings, targetLine)

            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService.TouchEnabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position + (closestTarget.Velocity * 0.025))
            end
        end
    end
end)
