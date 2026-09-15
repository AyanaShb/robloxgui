-- Pastikan executor mendukung Drawing API
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Pengaturan Lingkaran FOV (Di tengah layar)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = 120 -- Ukuran lingkaran FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255) -- Warna putih
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Tabel untuk menyimpan objek ESP setiap pemain agar tidak menumpuk
local espList = {}

local function createESP(player)
    local esp = {}
    
    -- Garis Tracer (Merah dari atas/tengah layar ke musuh)
    esp.Tracer = Drawing.new("Line")
    esp.Tracer.Visible = false
    esp.Tracer.Color = Color3.fromRGB(255, 0, 0)
    esp.Tracer.Thickness = 1.5
    
    -- Teks Nama dan Jarak
    esp.Text = Drawing.new("Text")
    esp.Text.Visible = false
    esp.Text.Color = Color3.fromRGB(255, 255, 255)
    esp.Text.Size = 14
    esp.Text.Center = true
    esp.Text.Outline = true

    espList[player] = esp
end

local function removeESP(player)
    if espList[player] then
        for _, obj in pairs(espList[player]) do
            obj:Remove()
        end
        espList[player] = nil
    end
end

-- Inisialisasi pemain yang sudah ada
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Loop Utama (RenderStepped) untuk memperbarui posisi ESP secara *real-time*
RunService.RenderStepped:Connect(function()
    -- Update posisi FOV jika ukuran layar berubah
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for player, esp in pairs(espList) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        -- Validasi apakah musuh hidup dan ada karakternya
        if character and rootPart and humanoid and humanoid.Health > 0 and player ~= LocalPlayer then
            -- Ubah posisi 3D dunia game ke 2D layar HP
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                -- Hitung jarak dari Player ke Musuh (dalam meter)
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                -- A. Update Garis Tracer (Merah) dari atas layar (Y: 0) ke posisi musuh
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Asal garis dari atas tengah
                esp.Tracer.To = Vector2.new(vector.X, vector.Y)
                
                -- B. Update Teks Nama & Jarak (Contoh: "ArulAR07 [78m]")
                esp.Text.Visible = true
                esp.Text.Text = string.format("%s [%dm]", player.Name, math.floor(distance))
                esp.Text.Position = Vector2.new(vector.X, vector.Y - 40) -- Posisi teks sedikit di atas kepala/badan musuh
            else
                esp.Tracer.Visible = false
                esp.Text.Visible = false
            end
        else
            esp.Tracer.Visible = false
            esp.Text.Visible = false
        end
    end
end)

print("ESP Mirip Game Berhasil Dijalankan!")
