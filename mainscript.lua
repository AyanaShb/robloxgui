local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent
local head = character:WaitForChild("Head")

-- Konfigurasi ESP
local config = {
    -- Ukuran BillboardGui (dalam Studs). Harus cukup besar untuk menutupi kepala.
    Size = UDim2.new(0, 4, 0, 4),
    -- Offset agar pas di tengah kepala. Sesuaikan jika avatar Anda memiliki bentuk kepala/topi yang aneh.
    StudsOffset = Vector3.new(0, 0.5, 0),
    -- Ukuran thumbnail yang diambil (makin besar makin tajam)
    ThumbnailSize = Enum.ThumbnailSize.Size420x420,
    -- Transparency lingkaran (0 = tidak transparan, 1 = transparan)
    ImageTransparency = 0.1
}

-- 1. Buat BillboardGui
local billboard = Instance.new("BillboardGui")
billboard.Name = "HeadCircleESP"
billboard.Adornee = head
billboard.Size = config.Size
billboard.StudsOffset = config.StudsOffset
billboard.AlwaysOnTop = true -- Agar terlihat menembus dinding
billboard.Parent = head

-- 2. Buat ImageLabel (Wadah Gambar)
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "PlayerThumbnail"
imageLabel.Size = UDim2.new(1, 0, 1, 0) -- Mengisi penuh BillboardGui
imageLabel.BackgroundTransparency = 1 -- Latar belakang transparan
imageLabel.ImageTransparency = config.ImageTransparency
imageLabel.Parent = billboard

-- 3. Buat UICorner (Untuk membuat gambar menjadi lingkaran)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0) -- Nilai 1 membuat lingkaran sempurna jika parent kotak
uiCorner.Parent = imageLabel

-- 4. Ambil dan Terapkan Thumbnail
local userId = localPlayer.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbContent = ""

local success, content = pcall(function()
    return Players:GetUserThumbnailAsync(userId, thumbType, config.ThumbnailSize)
end)

if success then
    imageLabel.Image = content
else
    warn("Gagal memuat thumbnail untuk:", localPlayer.Name)
    -- Opsional: Pasang gambar default jika gagal
    -- imageLabel.Image = "rbxassetid://[ID_GAMBAR_DEFAULT_DISINI]"
end

-- Catatan: Karena skrip ini berada di StarterCharacterScripts, 
-- skrip akan otomatis hancur dan dibuat ulang saat player respawn.
-- Tidak perlu menangani event CharacterAdded.
