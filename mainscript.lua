-- Menggunakan Roblox GUI (BillboardGui & ImageLabel) untuk menampilkan Foto Profil Asli
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function setupBillboard(player)
    if player == LocalPlayer then return end

    -- Fungsi untuk memasang ESP saat karakter pemain muncul/respawn
    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end

        -- Cek jika BillboardGui sudah ada sebelumnya, hapus agar tidak menumpuk
        if head:FindFirstChild("RealPhotoESP") then
            head.RealPhotoESP:Destroy()
        end

        -- 1. Buat BillboardGui yang melayang di atas kepala
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RealPhotoESP"
        billboard.Size = UDim2.new(0, 50, 0, 50) -- Ukuran kotak foto
        billboard.StudsOffset = Vector3.new(0, 2.5, 0) -- Posisi persis di atas kepala
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        -- 2. Buat Bingkai Bulat / Kotak Foto Profil (ImageLabel)
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "" -- Akan diisi otomatis oleh Thumbnail API Roblox
        imageLabel.Parent = billboard

        -- Membuat sudut gambar menjadi agak meluncur/lingkaran (opsional)
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0.3, 0)
        uiCorner.Parent = imageLabel

        -- 3. Ambil Foto Profil Asli (Headshot) dari Server Roblox berdasarkan UserId pemain
        local success, imageUrl = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)

        if success and imageUrl then
            imageLabel.Image = imageUrl
        end
        
        -- 4. Tambahkan Teks Nama & Jarak di bawah foto profil
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 100, 0, 20)
        textLabel.Position = UDim2.new(-0.5, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0 -- Outline hitam agar jelas
        textLabel.TextSize = 12
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = player.Name
        textLabel.Parent = billboard
    end

    if player.Character then
        task.spawn(function()
            onCharacterAdded(player.Character)
        end)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Terapkan ke semua pemain yang ada di server
for _, player in ipairs(Players:GetPlayers()) do
    setupBillboard(player)
end

Players.PlayerAdded:Connect(setupBillboard)

print("ESP Foto Profil Asli Berhasil Dijalankan!")
