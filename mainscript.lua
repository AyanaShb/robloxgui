Berikut adalah script ESP custom murni buatan saya sendiri dari nol tanpa menggunakan modul pihak ketiga mana pun. Script ini dirancang khusus untuk Delta Executor agar memiliki elemen visual yang menyerupai gambar referensi Anda: Garis tracer dari atas tengah layar menuju kepala, kotak merah (box), lingkaran foto profil kepala, health bar vertikal di kanan, serta teks jarak [xxm].
Salin dan jalankan script ini langsung di executor Anda:
-- Custom VVIP ESP By Gemini (Tanpa Modul Lain)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Bersihkan ESP lama jika ada agar tidak menumpuk
if CoreGui:FindFirstChild("GeminiVVIP_ESP") then
    CoreGui.GeminiVVIP_ESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiVVIP_ESP"
ScreenGui.Parent = CoreGui

local espRegistry = {}

local function createVisuals(player)
    if player == LocalPlayer then return end

    -- BillboardGui untuk wadah elemen 3D ke 2D (Foto, Kotak, Nama, Darah, Jarak)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_VVIP"
    billboard.Size = UDim2.new(0, 160, 0, 200)
    billboard.StudsOffset = Vector3.new(0, 0.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    -- 1. Lingkaran Foto Kepala di atas Box
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 34, 0, 34)
    avatarFrame.Position = UDim2.new(0.5, -17, 0, -52)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = billboard

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Image = "rbxassetid://6034293636"
    avatarImage.Parent = avatarFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarImage

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Thickness = 1.5
    avatarStroke.Color = Color3.fromRGB(255, 30, 30)
    avatarStroke.Parent = avatarFrame

    -- 2. Teks Nama Pemain
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 140, 0, 15)
    nameLabel.Position = UDim2.new(0.5, -70, 0, -15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard

    -- 3. Kotak Merah Utama (Box ESP)
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(0, 56, 0, 100)
    boxFrame.Position = UDim2.new(0.5, -28, 0, 4)
    boxFrame.BackgroundTransparency = 1
    boxFrame.Parent = billboard

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Color3.fromRGB(255, 30, 30)
    boxStroke.Parent = boxFrame

    -- 4. Health Bar Vertikal di Sisi Kanan Box
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 5, 1, 0)
    healthBg.Position = UDim2.new(1, 3, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = boxFrame

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    -- 5. Teks Jarak [xxm] di Bawah Box
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 140, 0, 15)
    distLabel.Position = UDim2.new(0.5, -70, 0, 106)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.Text = "[0m]"
    distLabel.Parent = billboard

    -- Memuat Thumbnail Kepala Roblox secara asynchronous
    task.spawn(function()
        pcall(function()
            local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            if isReady and content then
                avatarImage.Image = content
            end
        end)
    end)

    -- 6. Garis Tracer dari Atas Tengah Layar menggunakan Drawing API
    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false
    tracerLine.Color = Color3.fromRGB(255, 30, 30)
    tracerLine.Thickness = 1.5

    espRegistry[player] = {
        Billboard = billboard,
        HealthFill = healthFill,
        DistLabel = distLabel,
        Tracer = tracerLine
    }
end

local function removeVisuals(player)
    if espRegistry[player] then
        espRegistry[player].Billboard:Destroy()
        espRegistry[player].Tracer:Remove()
        espRegistry[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createVisuals(p)
end

Players.PlayerAdded:Connect(createVisuals)
Players.PlayerRemoving:Connect(removeVisuals)

-- Loop Utama untuk update posisi dan status secara real-time
RunService.RenderStepped:Connect(function()
    for player, data in pairs(espRegistry) do
        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if character and head and rootPart and humanoid and humanoid.Health > 0 then
            data.Billboard.Adornee = head
            data.Billboard.Enabled = true

            -- Update posisi garis tracer agar terhubung rapi dari atas tengah layar
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                data.Tracer.Visible = true
                data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                data.Tracer.To = Vector2.new(headPos.X, headPos.Y - 22)
            else
                data.Tracer.Visible = false
            end

            -- Update hitungan jarak dalam meter ([xxm])
            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
            data.DistLabel.Text = string.format("[%dm]", math.floor(distance))

            -- Update ukuran dan warna Health Bar vertikal
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            data.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
            data.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)

            if healthPercent > 0.6 then
                data.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)     -- Hijau (Darah Aman)
            elseif healthPercent > 0.3 then
                data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)  -- Kuning (Darah Sekarat)
            else
                data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)    -- Merah (Darah Kritis)
            end
        else
            data.Billboard.Adornee = nil
            data.Billboard.Enabled = false
            data.Tracer.Visible = false
        end
    end
end)

