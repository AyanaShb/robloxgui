-- ==========================================
-- FULL SCRIPT: HEAD CIRCLE ESP THUMBNAIL
-- Tempatkan di: StarterPlayer > StarterCharacterScripts (LocalScript)
-- ==========================================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent

-- Tunggu hingga bagian kepala (Head) karakter benar-benar termuat
local head = character:WaitForChild("Head", 5)
if not head then 
    warn("Head tidak ditemukan pada karakter!")
    return 
end

-- 1. Buat BillboardGui untuk menampung UI di 3D World
local billboard = Instance.new("BillboardGui")
billboard.Name = "HeadCircleESP"
billboard.Adornee = head
-- Ukuran Pixel & Studs (Sesuaikan ukuran angka 80 jika ingin lebih besar/kecil)
billboard.Size = UDim2.new(0, 80, 0, 80) 
billboard.StudsOffset = Vector3.new(0, 0.4, 0) -- Mengatur posisi vertikal agar pas di kepala
billboard.AlwaysOnTop = true -- Agar tetap tembus pandang/terlihat jelas
billboard.Parent = head

-- 2. Buat ImageLabel sebagai wadah foto profil
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "ThumbnailImage"
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.BackgroundTransparency = 1
imageLabel.ImageTransparency = 0
imageLabel.Parent = billboard

-- 3. Tambahkan UICorner agar bentuk gambarnya terpotong jadi lingkaran (Circle)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0) -- 1 berarti membuat lingkaran penuh
uiCorner.Parent = imageLabel

-- 4. Ambil Thumbnail Player secara asynchronous (aman dan tidak nge-lag/freeze game)
task.spawn(function()
    local success, content = pcall(function()
        return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    if success and content and imageLabel and imageLabel.Parent then
        imageLabel.Image = content
    else
        warn("Gagal memuat thumbnail headshot player.")
    end
end)
