-- Roblox Mobile UI Script (Android Version - Floating Button, Speed Slider, Ghost Mode, & Character Size Hack)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CHEAT ROBLOX D3D MENU AMIN",
   LoadingTitle = "⚡ LOADING MENU... ⚡",
   LoadingSubtitle = "Created for Blox Points & Mobile Roblox",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
   Theme = "Amethyst"
})

-- State Configuration
local State = {
    Skeleton = false,
    Name = false,
    Chams = false,
    JumpHack = false,
    JumpPowerVal = 60,
    SpeedHack = false,
    SpeedVal = 32,
    SizeHack = false,
    SizeVal = 1.0,
    Wallhack = false,
    AntiAFK = false,
    GhostMode = false,
    SilentAim = false,
    UnlimitedAmmo = false,
    AimTarget = "Head",
    FOVRange = 100
}

-- ==========================================
-- TOAST NOTIFICATION SYSTEM (POP-UP DI LAYAR)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local ToastGui = Instance.new("ScreenGui")
ToastGui.Name = "ToastNotificationGui"
ToastGui.Parent = CoreGui
ToastGui.ResetOnSpawn = false

local ToastLabel = Instance.new("TextLabel")
ToastLabel.Name = "Toast"
ToastLabel.Parent = ToastGui
ToastLabel.Size = UDim2.new(0, 260, 0, 40)
ToastLabel.Position = UDim2.new(0.5, -130, 0, -50)
ToastLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToastLabel.BackgroundTransparency = 0.2
ToastLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
ToastLabel.TextSize = 14
ToastLabel.Font = Enum.Font.GothamBold
ToastLabel.Text = ""
ToastLabel.Visible = false

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 8)
ToastCorner.Parent = ToastLabel

local ToastStroke = Instance.new("UIStroke")
ToastStroke.Thickness = 1.5
ToastStroke.Color = Color3.fromRGB(130, 50, 200)
ToastStroke.Parent = ToastLabel

local function ShowToast(message)
    ToastLabel.Text = message
    ToastLabel.Visible = true
    ToastLabel.Position = UDim2.new(0.5, -130, 0, -50)
    ToastLabel.TextTransparency = 1
    ToastLabel.BackgroundTransparency = 1

    local tweenIn = TweenService:Create(ToastLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -130, 0, 20),
        TextTransparency = 0,
        BackgroundTransparency = 0.2
    })
    tweenIn:Play()

    task.spawn(function()
        task.wait(1.5)
        local tweenOut = TweenService:Create(ToastLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -130, 0, -50),
            TextTransparency = 1,
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        ToastLabel.Visible = false
    end)
end

-- TABS
local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)
local MiscTab = Window:CreateTab("⚡ Misc", 4483362458)
local SilentAimTab = Window:CreateTab("🎯 Silent Aim", 4483362458)

-- 1. ESP CONTROLS
ESPTab:CreateToggle({
   Name = "Skeleton ESP",
   CurrentValue = false,
   Callback = function(Value)
      State.Skeleton = Value
      ShowToast("Skeleton ESP: " .. (Value and "Enabled" or "Disabled"))
   end,
})

ESPTab:CreateToggle({
   Name = "Name ESP",
   CurrentValue = false,
   Callback = function(Value)
      State.Name = Value
      ShowToast("Name ESP: " .. (Value and "Enabled" or "Disabled"))
   end,
})

ESPTab:CreateToggle({
   Name = "Chams ESP (Wallhack)",
   CurrentValue = false,
   Callback = function(Value)
      State.Chams = Value
      ShowToast("Chams ESP: " .. (Value and "Enabled" or "Disabled"))
   end,
})

-- 2. MISC CONTROLS
MiscTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Callback = function(Value)
      State.SpeedHack = Value
      ShowToast("Speed Hack: " .. (Value and "Enabled" or "Disabled"))
   end,
})

MiscTab:CreateSlider({
   Name = "Atur Kecepatan Speed",
   Range = {16, 100},
   Increment = 2,
   CurrentValue = 32,
   Callback = function(Value)
      State.SpeedVal = Value
      ShowToast("Speed Hack Updated: " .. Value)
   end,
})

MiscTab:CreateToggle({
   Name = "Character Size Hack (Ubah Ukuran)",
   CurrentValue = false,
   Callback = function(Value)
      State.SizeHack = Value
      ShowToast("Character Size: " .. (Value and "Enabled" or "Disabled"))
   end,
})

MiscTab:CreateSlider({
   Name = "Atur Ukuran Karakter (Scale)",
   Range = {0.5, 3.0},
   Increment = 0.1,
   CurrentValue = 1.0,
   Callback = function(Value)
      State.SizeVal = Value
      ShowToast("Character Size Updated: " .. string.format("%.1f", Value) .. "x")
   end,
})

MiscTab:CreateToggle({
   Name = "Multi-Jump (Tap-Tap Naik)",
   CurrentValue = false,
   Callback = function(Value)
      State.JumpHack = Value
      ShowToast("Multi-Jump: " .. (Value and "Enabled" or "Disabled"))
   end,
})

MiscTab:CreateSlider({
   Name = "Tinggi Jump Power",
   Range = {30, 150},
   Increment = 5,
   CurrentValue = 60,
   Callback = function(Value)
      State.JumpPowerVal = Value
      ShowToast("Jump Power Updated: " .. Value)
   end,
})

MiscTab:CreateToggle({
   Name = "Wallhack (Noclip)",
   CurrentValue = false,
   Callback = function(Value)
      State.Wallhack = Value
      ShowToast("Wallhack (Noclip): " .. (Value and "Enabled" or "Disabled"))
   end,
})

MiscTab:CreateToggle({
   Name = "Ghost Mode (Kebal Tembak / Anti Hitbox)",
   CurrentValue = false,
   Callback = function(Value)
      State.GhostMode = Value
      ShowToast("Ghost Mode: " .. (Value and "Enabled" or "Disabled"))
   end,
})

MiscTab:CreateToggle({
   Name = "Anti-AFK (Anti Kick)",
   CurrentValue = false,
   Callback = function(Value)
      State.AntiAFK = Value
      ShowToast("Anti-AFK: " .. (Value and "Enabled" or "Disabled"))
   end,
})

-- 3. SILENT AIM & AMMO CONTROLS
SilentAimTab:CreateToggle({
   Name = "Bullet Track (Silent Aim)",
   CurrentValue = false,
   Callback = function(Value)
      State.SilentAim = Value
      ShowToast("Silent Aim: " .. (Value and "Enabled" or "Disabled"))
   end,
})

SilentAimTab:CreateToggle({
   Name = "Unlimited Ammo (No Reload)",
   CurrentValue = false,
   Callback = function(Value)
      State.UnlimitedAmmo = Value
      ShowToast("Unlimited Ammo: " .. (Value and "Enabled" or "Disabled"))
   end,
})

SilentAimTab:CreateDropdown({
   Name = "Target Body Part",
   Options = {"Head", "UpperTorso", "LowerTorso"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Callback = function(Option)
      State.AimTarget = type(Option) == "table" and Option[1] or Option
      ShowToast("Aim Target Updated: " .. State.AimTarget)
   end,
})

SilentAimTab:CreateSlider({
   Name = "FOV Range",
   Range = {30, 400},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(Value)
      State.FOVRange = Value
      ShowToast("FOV Range Updated: " .. Value)
   end,
})

-- ==========================================
-- CUSTOM FLOATING BUTTON (HIDE / UNHIDE UI)
-- ==========================================
if CoreGui:FindFirstChild("RayfieldToggle") then
    CoreGui.RayfieldToggle:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomFloatingButtonGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatingButton"
FloatBtn.Parent = ScreenGui
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 15, 0.4, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 200)
FloatBtn.Text = "⚡"
FloatBtn.TextSize = 24
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Active = true
FloatBtn.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = FloatBtn

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Parent = FloatBtn

local menuVisible = true
FloatBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if Rayfield.Flags then
        local mainGui = CoreGui:FindFirstChild("Rayfield")
        if mainGui then
            mainGui.Enabled = menuVisible
        end
    end
end)

-- ==========================================
-- SYSTEM LOGIC
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Visual FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.NumSides = 32
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Function Team Check & Target Search
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = State.FOVRange
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        local isEnemy = true
        if player.Team ~= nil and LocalPlayer.Team ~= nil then
            isEnemy = (player.Team ~= LocalPlayer.Team)
        end

        if player ~= LocalPlayer and isEnemy and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(State.AimTarget) or player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = targetPart
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Render Loop (FOV, Ammo, Ghost Mode)
RunService.RenderStepped:Connect(function()
    if State.SilentAim then
        FOVCircle.Visible = true
        FOVCircle.Radius = State.FOVRange
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOVCircle.Visible = false
    end

    if State.UnlimitedAmmo and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local nameLower = string.lower(child.Name)
                    if string.find(nameLower, "ammo") or string.find(nameLower, "clip") or string.find(nameLower, "bullet") then
                        child.Value = 999
                    end
                end
            end
        end
    end

    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                if State.GhostMode then
                    part.CanTouch = false
                    if part.Name ~= "HumanoidRootPart" then
                        part.CanQuery = false
                    end
                else
                    part.CanTouch = true
                    part.CanQuery = true
                end
            end
        end
    end
end)

-- Silent Aim Redirection
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldIndex = gmt.__index

gmt.__index = newcclosure(function(self, idx)
    if State.SilentAim and tostring(idx) == "Hit" then
        local target = GetClosestTarget()
        if target then
            return target.CFrame
        end
    end
    return oldIndex(self, idx)
end)

-- MULTI-JUMP LOGIC
UserInputService.InputBegan:Connect(function(input, gpe)
    if State.JumpHack and (input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Space) then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.Velocity = Vector3.new(hrp.Velocity.X, State.JumpPowerVal, hrp.Velocity.Z)
        end
    end
end)

-- ANTI-AFK LOGIC
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

-- ESP NAME & CHAMS LOGIC
local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        local isEnemy = true
        if player.Team ~= nil and LocalPlayer.Team ~= nil then
            isEnemy = (player.Team ~= LocalPlayer.Team)
        end

        if player ~= LocalPlayer and isEnemy and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")

            if head then
                local tag = head:FindFirstChild("MobileNameESP")
                if State.Name then
                    if not tag then
                        tag = Instance.new("BillboardGui")
                        tag.Name = "MobileNameESP"
                        tag.Adornee = head
                        tag.Size = UDim2.new(0, 100, 0, 30)
                        tag.StudsOffset = Vector3.new(0, 2, 0)
                        tag.AlwaysOnTop = true

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = player.Name
                        label.TextColor3 = Color3.fromRGB(0, 255, 200)
                        label.TextStrokeTransparency = 0
                        label.Parent = tag
                        tag.Parent = head
                    end
                elseif tag then
                    tag:Destroy()
                end
            end

            local highlight = char:FindFirstChild("MobileChams")
            if State.Chams then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "MobileChams"
                    highlight.FillColor = Color3.fromRGB(255, 0, 128)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                    highlight.Parent = char
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

-- DYNAMIC SPEED, SIZE, & NOCLIP LOOP
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if State.SpeedHack then
                hum.WalkSpeed = State.SpeedVal
            else
                hum.WalkSpeed = 16
            end

            -- Character Size Hack Logic
            if State.SizeHack then
                local scale = State.SizeVal
                local headScale = hum:FindFirstChild("HeadScale")
                local depthScale = hum:FindFirstChild("BodyDepthScale")
                local heightScale = hum:FindFirstChild("BodyHeightScale")
                local widthScale = hum:FindFirstChild("BodyWidthScale")

                if headScale then headScale.Value = scale end
                if depthScale then depthScale.Value = scale end
                if heightScale then heightScale.Value = scale end
                if widthScale then widthScale.Value = scale end
            else
                -- Reset ke ukuran normal (1.0)
                local headScale = hum:FindFirstChild("HeadScale")
                local depthScale = hum:FindFirstChild("BodyDepthScale")
                local heightScale = hum:FindFirstChild("BodyHeightScale")
                local widthScale = hum:FindFirstChild("BodyWidthScale")

                if headScale then headScale.Value = 1.0 end
                if depthScale then depthScale.Value = 1.0 end
                if heightScale then heightScale.Value = 1.0 end
                if widthScale then widthScale.Value = 1.0 end
            end
        end

        if State.Wallhack then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)
