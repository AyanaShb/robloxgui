-- VVIP ESP Fixed for Delta Executor (No Crash & Working)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ambil PlayerGui agar aman dari proteksi CoreGui game
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FixedVVIP_ESP") then
    PlayerGui.FixedVVIP_ESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixedVVIP_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end

    -- Buat BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.Size = UDim2.new(0, 160, 0, 200)
    billboard.StudsOffset = Vector3.new(0, 0.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    -- Frame Foto Kepala
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 34, 0, 34)
    avatarFrame.Position = UDim2.new(0.5, -17, 0, -52)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = billboard

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(1, 0, 1, 0)
    avatar.BackgroundTransparency = 1
    -- Pakai asset default rbxasset langsung agar aman
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    avatar.Parent = avatarFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = avatar

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 30, 30)
    stroke.Parent = avatarFrame

    -- Nama Player
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 140, 0, 15)
    nameLabel.Position = UDim2.new(0.5, -70, 0, -15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard

    -- Kotak Utama (Box)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 56, 0, 100)
    box.Position = UDim2.new(0.5, -28, 0, 4)
    box.BackgroundTransparency = 1
    box.Parent = billboard

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Color3.fromRGB(255, 30, 30)
    boxStroke.Parent = box

    -- Health Bar Vertikal di Kanan Box
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 5, 1, 0)
    healthBg.Position = UDim2.new(1, 3, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- Teks Jarak [xxm]
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 140, 0, 15)
    distLabel.Position = UDim2.new(0.5, -70, 0, 106)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.Text = "[0m]"
    distLabel.Parent = billboard

    -- Ambil Foto Kepala Roblox secara aman dengan pcall terpisah
    task.spawn(function()
        local success, result = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if success and result then
            avatar.Image = result
        end
    end)

    -- Garis Tracer aman (menggunakan Drawing jika didukung executor)
    local tracer = nil
    pcall(function()
        tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 30, 30)
        tracer.Thickness = 1.5
    end)

    espCache[player] = {
        Billboard = billboard,
        HealthFill = healthFill,
        DistLabel = distLabel,
        Tracer = tracer
    }
end

local function removeESP(player)
    if espCache[player] then
        if espCache[player].Billboard then
            espCache[player].Billboard:Destroy()
        end
        if espCache[player].Tracer then
            pcall(function() espCache[player].Tracer:Remove() end)
        end
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Loop Utama Render
RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and head and root and hum and hum.Health > 0 then
            cache.Billboard.Adornee = head
            cache.Billboard.Enabled = true

            -- Garis Tracer dari atas tengah layar
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if cache.Tracer then
                if onScreen then
                    cache.Tracer.Visible = true
                    cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    cache.Tracer.To = Vector2.new(headPos.X, headPos.Y - 22)
                else
                    cache.Tracer.Visible = false
                end
            end

            -- Kalkulasi Jarak Meter
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            cache.DistLabel.Text = string.format("[%dm]", math.floor(dist))

            -- Update Health Bar
            local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            cache.HealthFill.Size = UDim2.new(1, 0, hpPercent, 0)
            cache.HealthFill.Position = UDim2.new(0, 0, 1 - hpPercent, 0)

            if hpPercent > 0.6 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hpPercent > 0.3 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            cache.Billboard.Adornee = nil
            cache.Billboard.Enabled = false
            if cache.Tracer then
                cache.Tracer.Visible = false
            end
        end
    end
end)
