-- Delta Executor ESP - 100% Sesuai Gambar Referensi VVIP Mods
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Hapus instance lama jika dijalankan ulang
if CoreGui:FindFirstChild("VVIP_ExactESP") then
    CoreGui.VVIP_ExactESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VVIP_ExactESP"
ScreenGui.Parent = CoreGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    -- Wadah Utama Menempel di Kepala Musuh
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.Size = UDim2.new(0, 140, 0, 160)
    billboard.StudsOffset = Vector3.new(0, 0.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui
    
    -- 1. FOTO PROFIL BULAT KECIL (Di bagian atas, lengkap dengan border putih)
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 32, 0, 32)
    avatarFrame.Position = UDim2.new(0.5, -16, 0, -45)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = billboard

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(1, 0, 1, 0)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxassetid://6034293636" -- Default placeholder
    avatar.Parent = avatarFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Thickness = 1.5
    avatarStroke.Color = Color3.fromRGB(255, 255, 255)
    avatarStroke.Parent = avatarFrame

    -- 2. TEKS NAMA (Di bawah foto profil / di atas box)
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0, 140, 0, 16)
    nameText.Position = UDim2.new(0.5, -70, 0, -10)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeTransparency = 0 -- Outline hitam khas cheat
    nameText.TextSize = 12
    nameText.Font = Enum.Font.SourceSansBold
    nameText.Text = player.Name
    nameText.Parent = billboard

    -- 3. KOTAK UTAMA (Container Corner Box)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 50, 0, 80)
    box.Position = UDim2.new(0.5, -25, 0, 12)
    box.BackgroundTransparency = 1
    box.Parent = billboard

    -- Border Kotak Merah Menyala
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.8
    boxStroke.Color = Color3.fromRGB(255, 30, 30)
    boxStroke.Parent = box

    -- 4. HEALTH BAR VERTIKAL (Di dalam/samping box, hijau dinamis)
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 4, 0, 80)
    healthBg.Position = UDim2.new(1, 4, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 0, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- 5. TEKS JARAK (Di bawah box, contoh: [18m])
    local distText = Instance.new("TextLabel")
    distText.Size = UDim2.new(0, 140, 0, 16)
    distText.Position = UDim2.new(0.5, -70, 0, 96)
    distText.BackgroundTransparency = 1
    distText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distText.TextStrokeTransparency = 0
    distText.TextSize = 12
    distText.Font = Enum.Font.SourceSansBold
    distText.Text = "[0m]"
    distText.Parent = billboard

    -- Ambil Foto Kepala Pemain Asli
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

-- LOOP UTAMA UPDATE POSISI & REALTIME DATA
RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if char and head and root and hum and hum.Health > 0 then
            cache.Billboard.Adornee = head
            cache.Billboard.Enabled = true
            
            -- Hitung Jarak Realtime
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            cache.DistText.Text = string.format("[%dm]", math.floor(dist))
            
            -- Update Ukuran & Warna Health Bar Sesuai Sisa Darah
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            cache.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
            cache.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
            
            if healthPercent > 0.5 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.25 then
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                cache.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            cache.Billboard.Adornee = nil
            cache.Billboard.Enabled = false
        end
    end
end)

print("ESP VVIP Style 100% Mirip Gambar Berhasil Dijalankan!")
