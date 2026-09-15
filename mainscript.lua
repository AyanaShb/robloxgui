-- Delta Executor ESP - 100% Persis Seperti Referensi Gambar
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Hapus instance lama jika script dijalankan ulang
if CoreGui:FindFirstChild("VVIP_ExactMatchESP") then
    CoreGui.VVIP_ExactMatchESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VVIP_ExactMatchESP"
ScreenGui.Parent = CoreGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    -- Wadah Utama (BillboardGui menempel di atas kepala musuh)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.Size = UDim2.new(0, 160, 0, 180)
    billboard.StudsOffset = Vector3.new(0, 0.4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui
    
    -- 1. IKON FOTO PROFIL KEPALA (Bulat di bagian paling atas dengan bingkai putih)
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 34, 0, 34)
    avatarFrame.Position = UDim2.new(0.5, -17, 0, -42)
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
    avatarStroke.Thickness = 1.5
    avatarStroke.Color = Color3.fromRGB(255, 255, 255)
    avatarStroke.Parent = avatarFrame

    -- 2. NAMA PLAYER (Tepat di bawah foto profil)
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0, 160, 0, 16)
    nameText.Position = UDim2.new(0.5, -80, 0, -6)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeTransparency = 0 -- Outline hitam agar jelas
    nameText.TextSize = 12
    nameText.Font = Enum.Font.SourceSansBold
    nameText.Text = player.Name
    nameText.Parent = billboard

    -- 3. BOX UTAMA (Corner Box / Kotak Merah dengan Padding/Tidak Terlalu Ngepas)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 56, 0, 95) -- Ukuran proporsional tidak terlalu rapat ke badan
    box.Position = UDim2.new(0.5, -28, 0, 14)
    box.BackgroundTransparency = 1
    box.Parent = billboard

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.8
    boxStroke.Color = Color3.fromRGB(255, 30, 30) -- Merah menyala
    boxStroke.Parent = box

    -- 4. HEALTH BAR VERTIKAL DINAMIS (Di sebelah kiri box, berkurang dari atas ke bawah)
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 4, 1, 0)
    healthBg.Position = UDim2.new(0, -7, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 0, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Level 1: Hijau (Darah penuh)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- 5. TEKS JARAK (Posisi persis di bawah kotak, format [xxm])
    local distText = Instance.new("TextLabel")
    distText.Size = UDim2.new(0, 160, 0, 16)
    distText.Position = UDim2.new(0.5, -80, 0, 112)
    distText.BackgroundTransparency = 1
    distText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distText.TextStrokeTransparency = 0
    distText.TextSize = 12
    distText.Font = Enum.Font.SourceSansBold
    distText.Text = "[0m]"
    distText.Parent = billboard

    -- Ambil Thumbnail/Foto Kepala Asli Pemain dari Roblox API
    task.spawn(function()
        pcall(function()
            local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            if isReady and content then
                avatar.Image = content
            end
        end)
    end)

    espCache[player] = {
        Billboard = billboard,
        HealthFill = healthFill,
        DistText = distText
    }
end

local function removeESP(player)
    if espCache[player] then
        espCache[player].Billboard:Destroy()
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- LOOP UTAMA UPDATE REALTIME
RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if char and head and root and hum and hum.Health > 0 then
            cache.Billboard.Adornee = head
            cache.Billboard.Enabled = true
            
            -- Hitung Jarak Meter
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            cache.DistText.Text = string.format("[%dm]", math.floor(dist))
            
            -- Health Bar Dinamis (Berkurang dari atas ke bawah & 3 Level Warna)
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            cache.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
            cache.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
            
            -- 3 Level Warna Sesuai Sisa Persentase Darah
            if healthPercent > 0.6 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)     -- Level 1: Hijau
            elseif healthPercent > 0.3 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)  -- Level 2: Kuning (Setengah)
            else
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)    -- Level 3: Merah (Sekarat)
            end
        else
            cache.Billboard.Adornee = nil
            cache.Billboard.Enabled = false
        end
    end
end)

print("ESP VVIP 100% Sesuai Gambar Berhasil Dijalankan!")
