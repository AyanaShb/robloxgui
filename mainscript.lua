local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent
local head = character:WaitForChild("Head", 5)

if not head then return end

-- 1. Buat BillboardGui yang menempel pada Head
local billboard = Instance.new("BillboardGui")
billboard.Name = "HeadCircleESP"
billboard.Adornee = head
-- Ukuran dalam Studs: Lebar 2, Tinggi 2 (Ukuran standar kepala Roblox rata-rata berukuran ~2x2x1 atau 2x1x1)
billboard.Size = UDim2.new(2, 0, 2, 0) 
-- Geser sedikit jika kurang pas (X, Y, Z). Y=0 artinya pas di tengah-tengah pusat kepala.
billboard.StudsOffset = Vector3.new(0, 0, 0) 
billboard.AlwaysOnTop = true
billboard.Parent = head

-- 2. Buat ImageLabel (Wadah Gambar)
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "ThumbnailImage"
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = billboard

-- 3. Potong gambar menjadi lingkaran menggunakan UICorner
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0) -- 1 berarti lingkaran penuh (persentase)
uiCorner.Parent = imageLabel

-- 4. Ambil Thumbnail Player
local userId = localPlayer.UserId
local success, content = pcall(function()
    return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

if success then
    imageLabel.Image = content
end
