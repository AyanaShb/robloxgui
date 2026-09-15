-- ==========================================
-- FIX HEAD ESP THUMBNAIL (BULAT & PAS DI KEPALA)
-- Tempatkan di: StarterPlayer > StarterCharacterScripts (LocalScript)
-- ==========================================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent

-- Tunggu bagian kepala (Head) karakter termuat
local head = character:WaitForChild("Head", 5)
if not head then return end

-- 1. Buat BillboardGui (Ukuran menggunakan skala Studs dunia 3D agar konsisten)
local billboard = Instance.new("BillboardGui")
billboard.Name = "HeadCircleESP"
billboard.Adornee = head
-- Ukuran 1.8 x 1.8 Studs (Ukuran pas untuk menutupi kepala karakter Roblox)
billboard.Size = UDim2.new(1.8, 0, 1.8, 0) 
-- Geser sedikit ke atas/tengah agar tepat di atas kepala
billboard.StudsOffset = Vector3.new(0, 0.2, 0)
billboard.AlwaysOnTop = true
billboard.Parent = head

-- 2. Buat ImageLabel (Wadah Gambar)
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "ThumbnailImage"
imageLabel.Size = UDim2.new(1, 0, 1, 0) -- Mengisi penuh BillboardGui
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = billboard

-- 3. Potong gambar menjadi lingkaran sempurna (Bulat)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0) -- 1 = Lingkaran penuh
uiCorner.Parent = imageLabel

-- 4. Ambil Thumbnail Player secara aman (Async)
task.spawn(function()
    local success, content = pcall(function()
        return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    if success and content and imageLabel and imageLabel.Parent then
        imageLabel.Image = content
    end
end)
