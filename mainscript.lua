-- Delta Executor: Full Custom ESP (100% Sesuai Gambar Referensi)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("ExactMatch_ESP") then
    CoreGui.ExactMatch_ESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExactMatch_ESP"
ScreenGui.Parent = CoreGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.Size = UDim2.new(0, 180, 0, 220)
    billboard.StudsOffset = Vector3.new(0, 0.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    -- Lingkaran Foto Kepala di atas garis tracer
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 36, 0, 36)
    avatarFrame.Position = UDim2.new(0.5, -18, 0, -60)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = billboard

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(1, 0, 1, 0)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxassetid://6034293636"
    avatar.Parent = avatarFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Thickness = 2
    avatarStroke.Color = Color3.fromRGB(255, 30, 30)
    avatarStroke.Parent = avatarFrame

    -- Nama Player (Tepat di atas kotak merah)
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0, 160, 0, 16)
    nameText.Position = UDim2.new(0.5, -80, 0, -18)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeTransparency = 0
    nameText.TextSize = 12
    nameText.Font = Enum.Font.SourceSansBold
    nameText.Text = player.Name
    nameText.Parent = billboard

    -- Kotak Merah Utama (Box)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 60, 0, 110)
    box.Position = UDim2.new(0.5, -30, 0, 5)
    box.BackgroundTransparency = 1
    box.Parent = billboard

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.8
    boxStroke.Color = Color3.fromRGB(255, 30, 30)
    boxStroke.Parent = box

    -- Health Bar Vertikal di Sebelah Kanan Kotak
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 6, 1, 0)
    healthBg.Position = UDim2.new(1, 4, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- Teks Jarak [xxm] di Bawah Kotak
    local distText = Instance.new("TextLabel")
    distText.Size = UDim2.new(0, 160, 0, 16)
    distText.Position = UDim2.new(0.5, -80, 0, 115)
    distText.BackgroundTransparency = 1
    distText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distText.TextStrokeTransparency = 0
    distText.TextSize = 12
    distText.Font = Enum.Font.SourceSansBold
    distText.Text = "[0m]"
    distText.Parent = billboard

    -- Ambil Foto Profil Asli Roblox
    task.spawn(function()
        pcall(function()
            local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            if isReady and content then
                avatar.Image = content
            end
        end)
    end)

    -- Garis Tracer dari Atas Layar Menuju ke Kepala Target
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 30, 30)
    tracer.Thickness = 1.8

    espCache[player] = {
        Billboard = billboard,
        HealthFill = healthFill,
        DistText = distText,
        Tracer = tracer
    }
end

local function removeESP(player)
    if espCache[player] then
        espCache[player].Billboard:Destroy()
        espCache[player].Tracer:Remove()
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if char and head and root and hum and hum.Health > 0 then
            cache.Billboard.Adornee = head
            cache.Billboard.Enabled = true
            
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                cache.Tracer.Visible = true
                cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                cache.Tracer.To = Vector2.new(headPos.X, headPos.Y - 25)
            else
                cache.Tracer.Visible = false
            end
            
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            cache.DistText.Text = string.format("[%dm]", math.floor(dist))
            
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            cache.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
            cache.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
            
            if healthPercent > 0.6 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.3 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            cache.Billboard.Adornee = nil
            cache.Billboard.Enabled = false
            cache.Tracer.Visible = false
        end
    end
end)
