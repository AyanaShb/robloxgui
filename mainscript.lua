local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Hapus wadah lama jika script dijalankan ulang
if CoreGui:FindFirstChild("ExactMatchESP") then
    CoreGui.ExactMatchESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExactMatchESP"
ScreenGui.Parent = CoreGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    -- Wadah utama yang menempel tepat di atas kepala musuh
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.Size = UDim2.new(0, 120, 0, 140)
    billboard.StudsOffset = Vector3.new(0, 0.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui
    
    -- 1. FOTO PROFIL BULAT KECIL (Di bagian paling atas, persis seperti di gambar)
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 36, 0, 36)
    avatar.Position = UDim2.new(0.5, -18, 0, -42)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxassetid://6034293636" -- Placeholder default jika gagal load
    avatar.Parent = billboard
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar
    
    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Thickness = 1.5
    avatarStroke.Color = Color3.fromRGB(255, 255, 255) -- Border putih melingkar
    avatarStroke.Parent = avatar

    -- 2. TETEKS NAMA (Di atas kotak)
    local nameText = Instance.new("TextLabel")
    nameText.Name = "NameText"
    nameText.Size = UDim2.new(0, 120, 0, 18)
    nameText.Position = UDim2.new(0.5, -60, 0, -4)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeTransparency = 0 -- Outline hitam
    nameText.TextSize = 13
    nameText.Font = Enum.Font.SourceSansBold
    nameText.Text = player.Name
    nameText.Parent = billboard

    -- 3. KOTAK TARGET UTAMA (Container Box)
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(0, 52, 0, 84)
    box.Position = UDim2.new(0.5, -26, 0, 18)
    box.BackgroundTransparency = 1
    box.Parent = billboard
    
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Color3.fromRGB(255, 30, 30) -- Warna merah menyala
    boxStroke.Parent = box

    -- 4. HEALTH BAR (Garis Darah Realtime di Samping Kiri Kotak)
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.Size = UDim2.new(0, 4, 0, 84)
    healthBg.Position = UDim2.new(0, -7, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 0, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Hijau awal
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- 5. TEKS JARAK ([78m] di bagian bawah kotak)
    local distText = Instance.new("TextLabel")
    distText.Name = "DistText"
    distText.Size = UDim2.new(0, 120, 0, 18)
    distText.Position = UDim2.new(0.5, -60, 0, 104)
    distText.BackgroundTransparency = 1
    distText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distText.TextStrokeTransparency = 0
    distText.TextSize = 12
    distText.Font = Enum.Font.SourceSansBold
    distText.Text = "[0m]"
    distText.Parent = billboard

    -- AMBIL FOTO PROFIL ASLI PEMAIN SECARA AMAN
    task.spawn(function()
        pcall(function()
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size150x150
            local content, isReady = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
            if isReady and content then
                avatar.Image = content
            end
        end)
    end)

    espCache[player] = billboard
end

local function removeESP(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- RENDER LOOP UTAMA (Memperbarui Posisi, Jarak, dan Status Darah Realtime)
RunService.RenderStepped:Connect(function()
    for player, billboard in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if char and head and hum and hum.Health > 0 then
            billboard.Adornee = head
            billboard.Enabled = true
            
            -- Hitung Jarak Realtime (dalam meter)
            local dist = (head.Position - Camera.CFrame.Position).Magnitude
            
            -- Update Teks Jarak
            local distLabel = billboard:FindFirstChild("DistText")
            if distLabel then
                distLabel.Text = string.format("[%dm]", math.floor(dist))
            end
            
            -- Update Health Bar Realtime (Berubah warna & ukuran sesuai sisa darah)
            local healthFill = billboard:FindFirstChild("Box", true):FindFirstChild("HealthBg"):FindFirstChild("HealthFill")
            if healthFill then
                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                healthFill.Size = UDim2.new(1, 0, healthPercent, 0)
                healthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                
                -- Dinamis Ganti Warna Darah (Hijau -> Kuning -> Merah)
                if healthPercent > 0.5 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.25 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        else
            billboard.Adornee = nil
            billboard.Enabled = false
        end
    end
end)

print("ESP Sesuai Referensi Gambar Berhasil Dijalankan!")
