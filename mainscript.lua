-- =====================================================================
-- NEON OLEDSLICK UI: × D3D MENU BG AMIN × (FIXED & FULLY FUNCTIONAL)
-- Ultra-Modern, Sleek, Minimalist, Colorful & Lightweight Design
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
    ChamsColor = Color3.fromRGB(255, 40, 130),
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
ScreenGui.Name = "D3D_OledSlick_Menu"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Container khusus untuk ESP agar rapi
local EspContainer = Instance.new("Folder")
EspContainer.Name = "D3D_EspContainer"
EspContainer.Parent = ScreenGui

-- Floating Mini Icon (Glow Capsule)
local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 48, 0, 48)
FloatButton.Position = UDim2.new(0, 20, 0, 100)
FloatButton.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
FloatButton.Text = "UI"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 15
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Active = true
FloatButton.Draggable = true
FloatButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatButton

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
})
FloatGradient.Parent = FloatStroke

-- Main Window (Pure OLED Dark + Blur & Vibrant Glow)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 430, 0, 310)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 0, 255))
})
MainGradient.Rotation = 45
MainGradient.Parent = MainStroke

FloatButton.MouseButton1Click:Connect(function()
    D3DConfig.MenuVisible = not D3DConfig.MenuVisible
    MainFrame.Visible = D3DConfig.MenuVisible
end)

-- Title Header (Centered, Clean & Aesthetic)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 36)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "× D3D MENU BG AMIN ×"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 13.5
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Tab Bar (Floating Capsule Style)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -24, 0, 32)
TabContainer.Position = UDim2.new(0, 12, 0, 36)
TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
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
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(110, 110, 140)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -24, 1, -84)
    content.Position = UDim2.new(0, 12, 0, 76)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
    content.Visible = (i == 1)
    content.Parent = MainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 8)
    uiList.Parent = content
    
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 15)
    end)
    
    TabButtons[tabName] = btn
    TabContentFrames[tabName] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            TabContentFrames[t].Visible = false
            TabButtons[t].TextColor3 = Color3.fromRGB(110, 110, 140)
        end
        content.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        D3DConfig.CurrentTab = tabName
    end)
end

-- Re-engineered Modern Components (Slim Cards)
local function CreateToggle(parent, text, callback, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(25, 25, 36)
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
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 130)
            circle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        end
    end)
    
    frame.Parent = parent
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 5)
    sliderBg.Position = UDim2.new(0, 12, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    sliderBg.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
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
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 16)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = "Chams Color Circle Palette"
    label.TextColor3 = Color3.fromRGB(255, 0, 128)
    label.TextSize = 10.5
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(1, -24, 0, 20)
    circleContainer.Position = UDim2.new(0, 12, 0, 22)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = frame
    
    local colors = {
        Color3.fromRGB(255, 0, 128),
        Color3.fromRGB(0, 255, 130),
        Color3.fromRGB(0, 240, 255),
        Color3.fromRGB(255, 210, 0),
        Color3.fromRGB(255, 90, 0),
        Color3.fromRGB(140, 0, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(100, 100, 100)
    }
    
    for i, col in ipairs(colors) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 18, 0, 18)
        colorBtn.Position = UDim2.new(0, (i-1)*28, 0, 0)
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
-- POPULATE TABS
-- =====================================================================

local vis = TabContentFrames["Visual"]
CreateToggle(vis, "ESP Line (Top to Head)", function(v) D3DConfig.EspLine = v end)
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
CreateToggle(ply, "Fly (Hold Jump)", function(v) D3DConfig.Fly = v end)
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
CreateSlider(wrd, "View Distance / FOV", 30, 120, 70, function(v) D3DConfig.LongViewValue = v end)

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
tpButton.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
tpButton.Text = "Random Player Teleport"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextSize = 11.5
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
-- FULL FUNCTIONAL CHEAT LOOP (FIXED UI FRAME ESP LINE & DRAWINGS)
-- =====================================================================

local activeDrawings = {}
local activeFrames = {}

local function clearDrawings()
    for _, obj in pairs(activeDrawings) do
        if obj and obj.Remove then
            pcall(function() obj:Remove() end)
        end
    end
    activeDrawings = {}

    for _, frame in pairs(activeFrames) do
        if frame and frame.Destroy then
            pcall(function() frame:Destroy() end)
        end
    end
    activeFrames = {}
end

-- Diperbaiki menggunakan AnchorPoint(0.5, 0) dan Magnitude agar Frame GUI stabil menembus Android/Executor tanpa glitch
local function DrawUILine(p1, p2, color, thickness, parent)
    local snapLine = Instance.new("Frame")
    snapLine.AnchorPoint = Vector2.new(0.5, 0)
    snapLine.BackgroundColor3 = color
    snapLine.BorderSizePixel = 0
    snapLine.Size = UDim2.new(0, thickness, 0, 0)
    
    local magnitude = (p2 - p1).Magnitude
    snapLine.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
    snapLine.Size = UDim2.new(0, thickness, 0, magnitude)
    snapLine.Rotation = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X)) - 90
    snapLine.Parent = parent
    
    table.insert(activeFrames, snapLine)
end

RunService.RenderStepped:Connect(function()
    clearDrawings()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local head = char.Head
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    if D3DConfig.EspLine then
                        -- Titik awal dari bawah tengah layar (X tengah, Y = Screen Height) atau atas layar sesuai selera
                        local p1 = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        local p2 = Vector2.new(headPos.X, headPos.Y)
                        DrawUILine(p1, p2, Color3.fromRGB(255, 0, 0), 1.5, EspContainer)
                    end

                    if D3DConfig.EspName and Drawing then
                        pcall(function()
                            local text = Drawing.new("Text")
                            text.Visible = true
                            text.Text = p.Name
                            text.Position = Vector2.new(headPos.X, headPos.Y - 24)
                            text.Center = true
                            text.Outline = true
                            text.Color = Color3.fromRGB(255, 255, 255)
                            text.Size = 12
                            table.insert(activeDrawings, text)
                        end)
                    end

                    if D3DConfig.EspDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Drawing then
                        pcall(function()
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                            local distText = Drawing.new("Text")
                            distText.Visible = true
                            distText.Text = "[" .. tostring(dist) .. "m]"
                            distText.Position = Vector2.new(headPos.X, headPos.Y - 38)
                            distText.Center = true
                            distText.Outline = true
                            distText.Color = Color3.fromRGB(0, 240, 255)
                            distText.Size = 11
                            table.insert(activeDrawings, distText)
                        end)
                    end

                    if D3DConfig.EspGender and Drawing then
                        pcall(function()
                            local genderVal = (p.UserId % 2 == 0) and "Cewe" or "Cowo"
                            local genderText = Drawing.new("Text")
                            genderText.Visible = true
                            genderText.Text = "(" .. genderVal .. ")"
                            genderText.Position = Vector2.new(headPos.X, headPos.Y - 52)
                            genderText.Center = true
                            genderText.Outline = true
                            genderText.Color = Color3.fromRGB(255, 140, 200)
                            genderText.Size = 10
                            table.insert(activeDrawings, genderText)
                        end)
                    end
                end

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

    if D3DConfig.EspItem and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Drawing then
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj.Name:lower():match("item") or obj.Name:lower():match("coin") or obj.Name:lower():match("drop") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                if handle then
                    local dist = (myPos - handle.Position).Magnitude
                    if dist <= D3DConfig.ItemRadius then
                        local itemPos, onScreen = Camera:WorldToViewportPoint(handle.Position)
                        if onScreen then
                            pcall(function()
                                local itemText = Drawing.new("Text")
                                itemText.Visible = true
                                itemText.Text = obj.Name .. " (" .. math.floor(dist) .. "m)"
                                itemText.Position = Vector2.new(itemPos.X, itemPos.Y)
                                itemText.Center = true
                                itemText.Outline = true
                                itemText.Color = Color3.fromRGB(255, 210, 0)
                                itemText.Size = 10
                                table.insert(activeDrawings, itemText)
                            end)
                        end
                    end
                end
            end
        end
    end

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

    if D3DConfig.LongView then
        Camera.FieldOfView = D3DConfig.LongViewValue
    end

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

    if D3DConfig.Aimbot and Drawing then
        local mousePos = UserInputService:GetMouseLocation()
        
        pcall(function()
            local fovCircle = Drawing.new("Circle")
            fovCircle.Visible = true
            fovCircle.Position = mousePos
            fovCircle.Radius = D3DConfig.AimbotFov
            fovCircle.Color = Color3.fromRGB(0, 240, 255)
            fovCircle.Thickness = 1.2
            fovCircle.Filled = false
            table.insert(activeDrawings, fovCircle)
        end)

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
            pcall(function()
                local targetLine = Drawing.new("Line")
                targetLine.Visible = true
                targetLine.From = mousePos
                targetLine.To = Vector2.new(targetPos.X, targetPos.Y)
                targetLine.Color = Color3.fromRGB(255, 0, 128)
                targetLine.Thickness = 1.2
                table.insert(activeDrawings, targetLine)
            end)

            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService.TouchEnabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position + (closestTarget.Velocity * 0.025))
            end
        end
    end
end)
