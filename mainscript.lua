-- Roblox Mobile Custom GUI with Feature Status Indicator (Red/Green)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Hapus GUI lama jika script dijalankan ulang
if CoreGui:FindFirstChild("CustomD3DMenu") then
    CoreGui.CustomD3DMenu:Destroy()
end

-- State Configuration
local State = {
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
-- MAIN SCREEN GUI (CONTAINER)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomD3DMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- FLOATING TOGGLE BUTTON (UNTUK HIDE / UNHIDE)
-- ==========================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatingButton"
FloatBtn.Parent = ScreenGui
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 15, 0.4, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
FloatBtn.Text = "⚡"
FloatBtn.TextSize = 24
FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
FloatBtn.Active = true
FloatBtn.Draggable = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2
FloatStroke.Color = Color3.fromRGB(130, 50, 200)
FloatStroke.Parent = FloatBtn

-- ==========================================
-- MAIN WINDOW FRAME (MENU UTAMA)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(130, 50, 200)
MainStroke.Parent = MainFrame

-- Topbar (Header)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ CHEAT ROBLOX D3D MENU ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close / Minimize Button di Header
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Logika Tombol Floating & Close
local menuVisible = true
FloatBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

CloseBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
end)

-- ==========================================
-- TOAST NOTIFICATION SYSTEM
-- ==========================================
local ToastLabel = Instance.new("TextLabel")
ToastLabel.Name = "Toast"
ToastLabel.Parent = ScreenGui
ToastLabel.Size = UDim2.new(0, 260, 0, 35)
ToastLabel.Position = UDim2.new(0.5, -130, 0, -40)
ToastLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToastLabel.BackgroundTransparency = 0.2
ToastLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
ToastLabel.TextSize = 13
ToastLabel.Font = Enum.Font.GothamBold
ToastLabel.Text = "Status: Ready"
ToastLabel.Visible = false

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 6)
ToastCorner.Parent = ToastLabel

local function ShowToast(message)
    ToastLabel.Text = message
    ToastLabel.Visible = true
    ToastLabel.Position = UDim2.new(0.5, -130, 0, -40)
    
    local tweenService = game:GetService("TweenService")
    local tweenIn = tweenService:Create(ToastLabel, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -130, 0, 15)})
    tweenIn:Play()
    
    task.spawn(function()
        task.wait(1.5)
        local tweenOut = tweenService:Create(ToastLabel, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -130, 0, -40)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        ToastLabel.Visible = false
    end)
end

-- ==========================================
-- CONTENT CONTAINER
-- ==========================================
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 2.5, 0)
ContentFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Fungsi Pembuat Tombol Toggle dengan Label Indikator Status Kecil (Hijau/Merah)
local function CreateToggleUI(parent, text, checkSupportFunc, callback)
    -- Container untuk wrapper tombol dan indikator
    local container = Instance.new("Frame")
    container.Parent = parent
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1

    -- Teks Indikator Status Kecil di Atas
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = container
    statusLabel.Size = UDim2.new(1, 0, 0, 15)
    statusLabel.Position = UDim2.new(0, 5, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Update status support secara berkala
    task.spawn(function()
        while task.wait(1) do
            if container and container.Parent then
                local isSupported = checkSupportFunc()
                if isSupported then
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100) -- Hijau
                    statusLabel.Text = "● Status: Support / Ready"
                else
                    statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- Merah
                    statusLabel.Text = "● Status: Not Support / Unstable in this Map"
                end
            else
                break
            end
        end
    end)

    -- Tombol Toggle Utama
    local btn = Instance.new("TextButton")
    btn.Parent = container
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, 16)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    btn.Text = "  " .. text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
            btn.TextColor3 = Color3.fromRGB(0, 255, 200)
            btn.Text = "  " .. text .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = "  " .. text .. ": OFF"
        end
        callback(active)
    end)
end

-- ==========================================
-- PENGISIAN FITUR DENGAN PENGECEKAN SUPPORT
-- ==========================================

-- ESP & Chams (Support hampir di semua map berkat Roblox Core API)
CreateToggleUI(ContentFrame, "Name ESP", function() return true end, function(val) State.Name = val ShowToast("Name ESP: " .. tostring(val)) end)
CreateToggleUI(ContentFrame, "Chams ESP (Wallhack)", function() return true end, function(val) State.Chams = val ShowToast("Chams ESP: " .. tostring(val)) end)

-- Speed & Size (Cek apakah karakter memiliki Humanoid & Scale)
CreateToggleUI(ContentFrame, "Speed Hack", function()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid") ~= nil
end, function(val) State.SpeedHack = val ShowToast("Speed Hack: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Character Size Hack", function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum:FindFirstChild("HeadScale") ~= nil
end, function(val) State.SizeHack = val ShowToast("Size Hack: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Multi-Jump (Jump Button)", function()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil
end, function(val) State.JumpHack = val ShowToast("Multi-Jump: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Wallhack (Noclip)", function()
    return LocalPlayer.Character ~= nil
end, function(val) State.Wallhack = val ShowToast("Wallhack: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Ghost Mode (Anti Hitbox)", function()
    return LocalPlayer.Character ~= nil
end, function(val) State.GhostMode = val ShowToast("Ghost Mode: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Anti-AFK", function()
    return true
end, function(val) State.AntiAFK = val ShowToast("Anti-AFK: " .. tostring(val)) end)

-- Silent Aim & Ammo (Cek apakah player sedang memegang senjata/Tool)
CreateToggleUI(ContentFrame, "Bullet Track (Silent Aim)", function()
    return #Players:GetPlayers() > 1
end, function(val) State.SilentAim = val ShowToast("Silent Aim: " .. tostring(val)) end)

CreateToggleUI(ContentFrame, "Unlimited Ammo", function()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        for _, child in pairs(tool:GetDescendants()) do
            if child:IsA("IntValue") or child:IsA("NumberValue") then
                return true
            end
        end
    end
    return false -- Merah jika player belum memegang senjata atau senjata tidak pakai sistem Value ammo standar
end, function(val) State.UnlimitedAmmo = val ShowToast("Unlimited Ammo: " .. tostring(val)) end)


-- ==========================================
-- SYSTEM LOGIC (ESP, SPEED, MULTI-JUMP, DLL)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.NumSides = 32
FOVCircle.Filled = false
FOVCircle.Visible = false

local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = State.FOVRange
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(State.AimTarget) or player.Character:FindFirstChild("Head")
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
                    if string.find(string.lower(child.Name), "ammo") or string.find(string.lower(child.Name), "clip") then
                        child.Value = 999
                    end
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
        if target then return target.CFrame end
    end
    return oldIndex(self, idx)
end)

-- Multi-Jump Logic
UserInputService.InputBegan:Connect(function(input, gpe)
    if State.JumpHack and input.KeyCode == Enum.KeyCode.Space and not gpe then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, State.JumpPowerVal, char.HumanoidRootPart.Velocity.Z)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Jumping:Connect(function(isActive)
        if State.JumpHack and isActive and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, State.JumpPowerVal, char.HumanoidRootPart.Velocity.Z)
        end
    end)
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.Jumping:Connect(function(isActive)
        if State.JumpHack and isActive and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, State.JumpPowerVal, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
        end
    end)
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

-- ESP & Chams Loop
local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")

            if head then
                local tag = head:FindFirstChild("CustomNameTag")
                if State.Name then
                    if not tag then
                        tag = Instance.new("BillboardGui")
                        tag.Name = "CustomNameTag"
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

            local highlight = char:FindFirstChild("CustomChams")
            if State.Chams then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "CustomChams"
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

-- Stepped Loop (Speed, Size, Noclip, Ghost)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = State.SpeedHack and State.SpeedVal or 16

            if State.SizeHack then
                for _, scaleName in ipairs({"HeadScale", "BodyDepthScale", "BodyHeightScale", "BodyWidthScale"}) do
                    local scale = hum:FindFirstChild(scaleName)
                    if scale then scale.Value = State.SizeVal end
                end
            else
                for _, scaleName in ipairs({"HeadScale", "BodyDepthScale", "BodyHeightScale", "BodyWidthScale"}) do
                    local scale = hum:FindFirstChild(scaleName)
                    if scale then scale.Value = 1.0 end
                end
            end
        end

        if State.Wallhack then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanTouch = not State.GhostMode
            end
        end
    end
end)

ShowToast("Menu & Status Checker Loaded!")
