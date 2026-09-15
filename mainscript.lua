local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk membuat ESP foto profil di kepala player
local function setupPlayerHeadESP(player)
    if player == localPlayer then return end

    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end

        -- Cek apakah BillboardGui sudah ada agar tidak duplikat
        if head:FindFirstChild("HeadThumbnailESP") then return end

        -- Buat BillboardGui di atas kepala
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HeadThumbnailESP"
        billboard.Size = UDim2.new(0, 100, 0, 100) -- Ukuran dasar (diperbesar 2x dari standar kecil)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0) -- Posisi sedikit di atas kepala
        billboard.AlwaysOnTop = true
        billboard.Adornee = head

        -- Buat ImageLabel untuk menampilkan foto profil
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "ThumbnailImage"
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = ""
        imageLabel.Parent = billboard

        -- Ambil Thumbnail HeadShot Player (Ukuran 420x420 agar tetap jernih saat diperbesar)
        task.spawn(function()
            local success, content = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)

            if success and imageLabel and imageLabel.Parent then
                imageLabel.Image = content
            end
        end)

        billboard.Parent = head
    end

    -- Jika karakter sudah ada (bergabung lebih dulu)
    if player.Character then
        task.spawn(function()
            onCharacterAdded(player.Character)
        end)
    end

    -- Event saat player respawn
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Terapkan ke semua player yang ada di game
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayerHeadESP(player)
end

-- Terapkan ke player baru yang masuk
Players.PlayerAdded:Connect(setupPlayerHeadESP)
