-- Delta Executor ESP - Presisi Sesuai Referensi Gambar
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espCache = {}

local function createESP(player)
    local esp = {}
    
    -- 1. Garis Tracer (Merah dari atas tengah layar ke musuh)
    esp.Tracer = Drawing.new("Line")
    esp.Tracer.Visible = false
    esp.Tracer.Color = Color3.fromRGB(255, 30, 30)
    esp.Tracer.Thickness = 1.2
    
    -- 2. Corner Box (4 Garis Sudut Atas-Kiri, Atas-Kanan, Bawah-Kiri, Bawah-Kanan)
    esp.Lines = {}
    for i = 1, 16 do -- 4 garis per sudut (Total 16 garis untuk 4 sudut box)
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 30, 30)
        line.Thickness = 1.5
        table.insert(esp.Lines, line)
    end

    -- 3. Health Bar Background (Hitam di kiri box)
    esp.HealthBg = Drawing.new("Line")
    esp.HealthBg.Visible = false
    esp.HealthBg.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBg.Thickness = 3

    -- 4. Health Bar Fill (Hijau/Kuning/Merah dinamis)
    esp.HealthFill = Drawing.new("Line")
    esp.HealthFill.Visible = false
    esp.HealthFill.Thickness = 1.5

    -- 5. Teks Nama & Jarak
    esp.Text = Drawing.new("Text")
    esp.Text.Visible = false
    esp.Text.Color = Color3.fromRGB(255, 255, 255)
    esp.Text.Size = 13
    esp.Text.Center = true
    esp.Text.Outline = true

    espCache[player] = esp
end

local function removeESP(player)
    if espCache[player] then
        for _, obj in pairs(espCache[player]) do
            if type(obj) == "table" then
                for _, line in ipairs(obj) do line:Remove() end
            else
                obj:Remove()
            end
        end
        espCache[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then createESP(player) end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(espCache) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if character and rootPart and head and humanoid and humanoid.Health > 0 and player ~= LocalPlayer then
            -- Ambil posisi kepala dan kaki agar ukuran box pas (tidak kebesaran/kekecilan)
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos, legOnScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
            
            if headOnScreen or legOnScreen then
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                -- Hitung tinggi dan lebar box secara proporsional
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                local pos = Vector2.new(headPos.X - width / 2, headPos.Y)
                
                -- A. Tracer (Line dari atas tengah layar)
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                esp.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                
                -- B. Corner Box (Membuat kotak putus-putus di setiap sudut)
                local l = esp.Lines
                local sw, sh = width / 4, height / 4
                
                -- Sudut Kiri Atas
                l[1].From = pos; l[1].To = Vector2.new(pos.X + sw, pos.Y)
                l[2].From = pos; l[2].To = Vector2.new(pos.X, pos.Y + sh)
                -- Sudut Kanan Atas
                l[3].From = Vector2.new(pos.X + width, pos.Y); l[3].To = Vector2.new(pos.X + width - sw, pos.Y)
                l[4].From = Vector2.new(pos.X + width, pos.Y); l[4].To = Vector2.new(pos.X + width, pos.Y + sh)
                -- Sudut Kiri Bawah
                l[5].From = Vector2.new(pos.X, pos.Y + height); l[5].To = Vector2.new(pos.X + sw, pos.Y + height)
                l[6].From = Vector2.new(pos.X, pos.Y + height); l[6].To = Vector2.new(pos.X, pos.Y + height - sh)
                -- Sudut Kanan Bawah
                l[7].From = Vector2.new(pos.X + width, pos.Y + height); l[7].To = Vector2.new(pos.X + width - sw, pos.Y + height)
                l[8].From = Vector2.new(pos.X + width, pos.Y + height); l[8].To = Vector2.new(pos.X + width, pos.Y + height - sh)
                
                for i = 1, 8 do l[i].Visible = true end

                -- C. Health Bar Vertikal Realtime di Samping Kiri Box
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barHeight = height * healthPercent
                local barX = pos.X - 6
                
                esp.HealthBg.Visible = true
                esp.HealthBg.From = Vector2.new(barX, pos.Y)
                esp.HealthBg.To = Vector2.new(barX, pos.Y + height)
                
                esp.HealthFill.Visible = true
                esp.HealthFill.From = Vector2.new(barX, pos.Y + (height - barHeight))
                esp.HealthFill.To = Vector2.new(barX, pos.Y + height)
                
                -- Warna Health Bar Berubah Dinamis (Hijau -> Kuning -> Merah)
                if healthPercent > 0.5 then
                    esp.HealthFill.Color = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.25 then
                    esp.HealthFill.Color = Color3.fromRGB(255, 255, 0)
                else
                    esp.HealthFill.Color = Color3.fromRGB(255, 0, 0)
                end

                -- D. Teks Nama & Jarak
                esp.Text.Visible = true
                esp.Text.Text = string.format("%s [%dm]", player.Name, math.floor(distance))
                esp.Text.Position = Vector2.new(headPos.X, pos.Y - 18)
            else
                esp.Tracer.Visible = false
                for _, line in ipairs(esp.Lines) do line.Visible = false end
                esp.HealthBg.Visible = false
                esp.HealthFill.Visible = false
                esp.Text.Visible = false
            end
        else
            esp.Tracer.Visible = false
            for _, line in ipairs(esp.Lines) do line.Visible = false end
            esp.HealthBg.Visible = false
            esp.HealthFill.Visible = false
            esp.Text.Visible = false
        end
    end
end)

print("ESP Corner Box & Dynamic Health Berhasil Dijalankan!")
