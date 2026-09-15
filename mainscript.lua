-- ESP Head Avatar & Info for Delta Executor
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("HeadAvatarESP") then
    PlayerGui.HeadAvatarESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HeadAvatarESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end

    -- BillboardGui diletakkan di atas kepala player
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_HeadESP"
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0) -- Posisi persis di atas kepala
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    -- Frame Lingkaran Foto
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 45, 0, 45)
    avatarFrame.Position = UDim2.new(0.5, -22.5, 0, 0)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = billboard

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    imageLabel.Parent = avatarFrame

    -- Membuat bentuk foto jadi bulat (Corner)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = avatarFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Parent = avatarFrame

    -- Teks Nama di bawah foto
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 120, 0, 15)
    nameLabel.Position = UDim2.new(0.5, -60, 0, 48)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard

    -- Ambil Foto Profil menggunakan script yang kamu berikan
    task.spawn(function()
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420

        local success, content = pcall(function()
            return Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        end)

        if success and content then
            imageLabel.Image = content
        end
    end)

    espCache[player] = {
        Billboard = billboard
    }
end

local function removeESP(player)
    if espCache[player] and espCache[player].Billboard then
        espCache[player].Billboard:Destroy()
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Loop untuk menempelkan Billboard ke Kepala Player secara real-time
RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and head and hum and hum.Health > 0 then
            cache.Billboard.Adornee = head
            cache.Billboard.Enabled = true
        else
            cache.Billboard.Adornee = nil
            cache.Billboard.Enabled = false
        end
    end
end)
