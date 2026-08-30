-- =====================================================================
-- FIXED UI LAYOUT SCRIPT: × D3D MENU BG AMIN ×
-- Clean Vertical Padding, Fixed Font Clashing & High Contrast Readability
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
    ChamsColor = Color3.fromRGB(255, 0, 0),
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
    LongViewValue = 1000,
    Aimbot = false,
    AimbotFov = 100,
    UnlimitedAmmo = false,
    FastVehicle = false,
    VehicleSpeedValue = 150
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "D3D_Menu_Fixed"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Floating UI Button
local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 30, 0, 120)
FloatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FloatButton.Text = "UI"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 18
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Active = true
FloatButton.Draggable = true
FloatButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 0, 150)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatButton

-- Main Menu Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 320)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 15, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 35, 30))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(140, 70, 220)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

FloatButton.MouseButton1Click:Connect(function()
    D3DConfig.MenuVisible = not D3DConfig.MenuVisible
    MainFrame.Visible = D3DConfig.MenuVisible
end)

-- Title Header
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = " × D3D MENU BG AMIN ×"
TitleLabel.TextColor3 = Color3.fromRGB(255, 140, 230)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Tab Navigation Bar
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 32)
TabContainer.Position = UDim2.new(0, 10, 0, 38)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabContainer

local tabs = {"Visual", "Player", "world", "skill"}
local TabButtons = {}
local TabContentFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName:gsub("^%l", string.upper)
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -85)
    content.Position = UDim2.new(0, 10, 0, 78)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(180, 60, 220)
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
            TabButtons[t].TextColor3 = Color3.fromRGB(160, 160, 180)
        end
        content.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        D3DConfig.CurrentTab = tabName
    end)
end

-- Component Builders with Strict Vertical Sizing
local function CreateToggle(parent, text, callback, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(50, 50, 65)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
            circle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        end
    end)
    
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = "Chams Colour Palette Circle"
    label.TextColor3 = Color3.fromRGB(255, 140, 220)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(1, -20, 0, 24)
    circleContainer.Position = UDim2.new(0, 10, 0, 24)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = frame
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 140, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 120, 0),
        Color3.fromRGB(180, 0, 255),
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

-- Populate Tab Content
local vis = TabContentFrames["Visual"]
CreateToggle(vis, "ESP Line", function(v) D3DConfig.EspLine = v end)
CreateToggle(vis, "ESP Name", function(v) D3DConfig.EspName = v end)
CreateToggle(vis, "ESP Distance", function(v) D3DConfig.EspDistance = v end)
CreateToggle(vis, "ESP Gender [Cowo/Cewe]", function(v) D3DConfig.EspGender = v end)
CreateToggle(vis, "ESP Item Name", function(v) D3DConfig.EspItem = v end)
CreateSlider(vis, "ESP Item Radius", 10, 200, 50, function(v) D3DConfig.ItemRadius = v end)
CreateToggle(vis, "Chams Body Colour", function(v) D3DConfig.Chams = v end)
CreateColorCirclePicker(vis, function(col) D3DConfig.ChamsColor = col end)

local ply = TabContentFrames["Player"]
CreateToggle(ply, "Speed Run", function(v) D3DConfig.SpeedRun = v end)
CreateSlider(ply, "Speed Value", 16, 100, 24, function(v) D3DConfig.SpeedValue = v end)
CreateToggle(ply, "Fly Mode", function(v) D3DConfig.Fly = v end)
CreateToggle(ply, "Long Jump", function(v) D3DConfig.LongJump = v end)
CreateToggle(ply, "Wall Hack", function(v) D3DConfig.WallHack = v end)
CreateToggle(ply, "Size Hack", function(v) D3DConfig.SizeHack = v end)
CreateSlider(ply, "Size Value", 0.5, 3, 1, function(v) D3DConfig.SizeValue = v end)
CreateToggle(ply, "God Mode", function(v) D3DConfig.GodMode = v end)

local wrd = TabContentFrames["world"]
CreateToggle(wrd, "Night Mode", function(v) 
    D3DConfig.NightMode = v
    if v then Lighting.ClockTime = 0 else Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Daylight Mode", function(v) 
    D3DConfig.DaylightMode = v
    if v then Lighting.ClockTime = 14 end
end)
CreateToggle(wrd, "Long View Distance", function(v) D3DConfig.LongView = v end)
CreateSlider(wrd, "View Distance Value", 100, 5000, 1000, function(v) D3DConfig.LongViewValue = v end)

local skl = TabContentFrames["skill"]
CreateToggle(skl, "Aimbot + FOV + Head Lock", function(v) D3DConfig.Aimbot = v end)
CreateSlider(skl, "Aimbot FOV Size", 20, 300, 100, function(v) D3DConfig.AimbotFov = v end)
CreateToggle(skl, "Unlimited Ammo (999/999)", function(v) D3DConfig.UnlimitedAmmo = v end)
CreateToggle(skl, "Fast Vehicle", function(v) D3DConfig.FastVehicle = v end)
CreateSlider(skl, "Vehicle Speed", 50, 400, 150, function(v) D3DConfig.VehicleSpeedValue = v end)

local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(1, 0, 0, 36)
tpFrame.BackgroundTransparency = 1
tpFrame.Parent = skl

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, 0, 1, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(140, 40, 180)
tpButton.Text = "Random Player Teleport"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextSize = 12
tpButton.Font = Enum.Font.GothamBold
tpButton.Parent = tpFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
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

-- Background Runtime Execution Loop
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
    if D3DConfig.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if D3DConfig.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)
