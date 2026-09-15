-- Delta Executor ESP - Presisi Badan, Tracer, & Dynamic Vertical Health Bar (100% - 0%)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espCache = {}

local function createESP(player)
    local esp = {}
    
    -- 1. GARIS TRACER (Line dari atas tengah layar menuju kepala musuh)
    esp.Tracer = Drawing.new("Line")
    esp.Tracer.Visible = false
    esp.Tracer.Color = Color3.fromRGB(255, 30, 30)
    esp.Tracer.Thickness = 1.2
    
    -- 2. CORNER BOX (Kotak sudut siku-siku warna merah menyala)
    esp.Lines = {}
    for i = 1, 16 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 30, 30)
        line.Thickness = 1.8
        table.insert(esp.Lines, line)
    end

    -- 3. HEALTH BAR BACKGROUND (Warna hitam di sebelah kiri box)
    esp.HealthBg = Drawing.new("Line")
    esp.HealthBg.Visible = false
    esp.HealthBg.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBg.Thickness = 3.5

    -- 4. HEALTH BAR FILL (Bar utama yang berkurang dari atas ke bawah & berubah warna)
    esp.HealthFill = Drawing.new("Line")
    esp.HealthFill.Visible = false
    esp.HealthFill.Thickness = 1.5

    -- 5. TEKS NAMA & JARAK
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
            -- Kalkulasi batas kepala dan kaki karakter agar ukuran ESP pas
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos, legOnScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2.8, 0))
            
            if headOnScreen or legOnScreen then
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                -- Ukuran proporsional sesuai tinggi dan lebar badan player
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2.2
                local pos = Vector2.new(headPos.X - width / 2, headPos.Y)
                
                -- A. TAMPILKAN TRACER LINE DARI ATAS TENGAH LAYAR
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                esp.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                
                -- B. CORNER BOX (Sudut Siku-siku)
                local l = esp.Lines
                local sw, sh = width / 3.5, height / 3.5
                
                -- Kiri Atas
                l[1].From = pos; l[1].To = Vector2.new(pos.X + sw, pos.Y)
                l[2].From = pos; l[2].To = Vector2.new(pos.X, pos.Y + sh)
                -- Kanan Atas
                l[3].From = Vector2.new(pos.X + width, pos.Y); l[3].To = Vector2.new(pos.X + width - sw, pos.Y)
                l[4].From = Vector2.new(pos.X + width, pos.Y); l[4].To = Vector2.new(pos.X + width, pos.Y + sh)
                -- Kiri Bawah
                l[5].From = Vector2.new(pos.X, pos.Y + height); l[5].To = Vector2.new(pos.X + sw, pos.Y + height)
                l[6].From = Vector2.new(pos.X, pos.Y + height); l[6].To = Vector2.new(pos.X, pos.Y + height - sh)
                -- Kanan Bawah
                l[7].From = Vector2.new(pos.X + width, pos.Y + height); l[7].To = Vector2.new(pos.X + width - sw, pos.Y + height)
                l[8].From = Vector2.new(pos.X + width, pos.Y + height); l[8].To = Vector2.new(pos.X + width, pos.Y + height - sh)
                
                for i = 1, 8 do l[i].Visible = true end

                -- C. HEALTH BAR VERTIKAL DINAMIS (Berkurang dari Atas ke Bawah & Gradasi Warna 100%-0%)
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barHeight = height * healthPercent
                local barX = pos.X - 6
                
                -- Background Hitam Penuh
                esp.HealthBg.Visible = true
                esp.HealthBg.From = Vector2.new(barX, pos.Y)
                esp.HealthBg.To = Vector2.new(barX, pos.Y + height)
                
                -- Isi Bar yang Berkurang dari Atas ke Bawah
                esp.HealthFill.Visible = true
                esp.HealthFill.From = Vector2.new(barX, pos.Y + (height - barHeight))
                esp.HealthFill.To = Vector2.new(barX, pos.Y + height)
                
                -- Gradasi Warna Realtime Berdasarkan Sisa Darah (100% sampai 0%)
                -- Hijau (Darah Sehat) -> Kuning (Waspada/Setengah) -> Merah (Sekarat)
                if healthPercent > 0.6 then
                    esp.HealthFill.Color = Color3.fromRGB(0, 255, 0)     -- Hijau
                elseif healthPercent > 0.3 then
                    esp.HealthFill.Color = Color3.fromRGB(255, 255, 0)  -- Kuning
                else
                    esp.HealthFill.Color = Color3.fromRGB(255, 0, 0)    -- Merah
                end

                -- D. TEKS NAMA & JARAK
                esp.Text.Visible = true
                esp.Text.Text = string.format("%s\n[%dm]", player.Name, math.floor(distance))
                esp.Text.Position = Vector2.new(headPos.X, pos.Y - 26)
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

print("ESP Sempurna: Ukuran Pas, Tracer Aktif, & Health Bar Berkurang dari Atas ke Bawah!")
