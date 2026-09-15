-- ==========================================
-- FULL ESP HEAD THUMBNAIL (SEMUA PLAYER) - STABLE SIZE
-- Tempatkan di: StarterPlayer > StarterPlayerScripts (LocalScript)
-- ==========================================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function createHeadESP(character, player)
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    -- Cek agar tidak duplikat ESP di kepala yang sama
    if head:FindFirstChild("HeadCircleESP") then return end

    -- 1. Buat BillboardGui menggunakan skala Studs (Agar ukurannya tidak membesar saat menjauh)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HeadCircleESP"
    billboard.Adornee = head
    -- Ukuran 1.5 x 1.5 Studs (Proporsional mengikuti jarak kamera 3D)
    billboard.Size = UDim2.new(1.5, 0, 1.5, 0) 
    -- Posisi sedikit di atas kepala
    billboard.StudsOffset = Vector3.new(0, 0.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    -- 2. Buat ImageLabel (Wadah Foto)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "ThumbnailImage"
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Parent = billboard

    -- 3. Potong jadi lingkaran sempurna (Bulat)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = imageLabel

    -- 4. Ambil Thumbnail Player secara Async
    task.spawn(function()
        local success, content = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)

        if success and content and imageLabel and imageLabel.Parent then
            imageLabel.Image = content
        end
    end)
end

-- Fungsi untuk memantau player baru atau respawn
local function setupPlayer(player)
    if player == localPlayer then return end -- Ubah jika ingin foto karakter kamu sendiri ikut muncul

    if player.Character then
        task.spawn(function()
            createHeadESP(player.Character, player)
        end)
    end

    player.CharacterAdded:Connect(function(character)
        task.spawn(function()
            createHeadESP(character, player)
        end)
    end)
end

-- Terapkan ke player yang sudah ada di dalam game
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- Terapkan ke player yang baru join
Players.PlayerAdded:Connect(setupPlayer)
