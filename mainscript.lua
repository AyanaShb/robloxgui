local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espList = {}

local function createESP(player)
    local esp = {}
    
    -- 1. Kotak Target (Box) - Warna merah menyala dengan ketebalan presisi (1.5)
    esp.Box = Drawing.new("Square")
    esp.Box.Visible = false
    esp.Box.Color = Color3.fromRGB(255, 30, 30)
    esp.Box.Thickness = 1.5
    esp.Box.Filled = false

    -- 2. Garis Tracer - Merah tipis dari atas tengah layar ke musuh
    esp.Tracer = Drawing.new("Line")
    esp.Tracer.Visible = false
    esp.Tracer.Color = Color3.fromRGB(255, 30, 30)
    esp.Tracer.Thickness = 1.2
    
    -- 3. Lingkaran Kepala/Avatar (Simulasi ikon bulat di atas box)
    esp.AvatarCircle = Drawing.new("Circle")
    esp.AvatarCircle.Visible = false
    esp.AvatarCircle.Radius = 11
    esp.AvatarCircle.Color = Color3.fromRGB(255, 255, 255)
    esp.AvatarCircle.Thickness = 1.2
    esp.AvatarCircle.Filled = true

    -- 4. Health Bar (Garis latar belakang hitam di kiri box)
    esp.HealthBg = Drawing.new("Line")
    esp.HealthBg.Visible = false
    esp.HealthBg.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBg.Thickness = 3

    -- Health Bar (Garis isi hijau dinamis)
    esp.HealthBar = Drawing.new("Line")
    esp.HealthBar.Visible = false
    esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.HealthBar.Thickness = 2

    -- 5. Teks Nama & Jarak di bawah kotak
    esp.Text = Drawing.new("Text")
    esp.Text.Visible = false
    esp.Text.Color = Color3.fromRGB(255, 255, 255)
    esp.Text.Size = 13
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

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(espList) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if character and rootPart and humanoid and humanoid.Health > 0 and player ~= LocalPlayer then
            local rootVector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                -- Ukuran kotak proporsional menyesuaikan jarak
                local boxSize = Vector2.new(1900 / distance, 3400 / distance)
                local boxPos = Vector2.new(rootVector.X - boxSize.X / 2, rootVector.Y - boxSize.Y / 2)
                
                -- A. Tampilkan Kotak
                esp.Box.Visible = true
                esp.Box.Size = boxSize
                esp.Box.Position = boxPos
                
                -- B. Tampilkan Garis Tracer dari atas tengah layar
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                esp.Tracer.To = Vector2.new(rootVector.X, rootVector.Y)
                
                -- C. Tampilkan Lingkaran Avatar tepat di atas kotak
                esp.AvatarCircle.Visible = true
                esp.AvatarCircle.Position = Vector2.new(rootVector.X, boxPos.Y - 14)
                
                -- D. Hitung & Tampilkan Health Bar Realtime di sebelah kiri box
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barHeight = boxSize.Y * healthPercent
                local barX = boxPos.X - 6
                
                esp.HealthBg.Visible = true
                esp.HealthBg.From = Vector2.new(barX, boxPos.Y)
                esp.HealthBg.To = Vector2.new(barX, boxPos.Y + boxSize.Y)
                
                esp.HealthBar.Visible = true
                esp.HealthBar.From = Vector2.new(barX, boxPos.Y + (boxSize.Y - barHeight))
                esp.HealthBar.To = Vector2.new(barX, boxPos.Y + boxSize.Y)
                
                -- Warna darah otomatis berubah (Hijau -> Kuning -> Merah)
                if healthPercent > 0.5 then
                    esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.25 then
                    esp.HealthBar.Color = Color3.fromRGB(255, 255, 0)
                else
                    esp.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                end
                
                -- E. Tampilkan Nama & Jarak di bawah kotak
                esp.Text.Visible = true
                esp.Text.Text = string.format("%s [%dm]", player.Name, math.floor(distance))
                esp.Text.Position = Vector2.new(rootVector.X, boxPos.Y + boxSize.Y + 4)
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.AvatarCircle.Visible = false
                esp.HealthBg.Visible = false
                esp.HealthBar.Visible = false
                esp.Text.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.AvatarCircle.Visible = false
            esp.HealthBg.Visible = false
            esp.HealthBar.Visible = false
            esp.Text.Visible = false
        end
    end
end)

print("ESP Presisi Mirip Gambar Berhasil Dijalankan!")
