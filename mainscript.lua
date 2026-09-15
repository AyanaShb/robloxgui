-- Delta Executor ESP - Corner Box Lebih Lebar, Tebal, & Health Bar di Atas Kepala
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
    
    -- 2. Corner Box (16 garis untuk 4 sudut dengan ketebalan ditingkatkan)
    esp.Lines = {}
    for i = 1, 16 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 30, 30)
        line.Thickness = 2.0 -- Dipertebal agar lebih jelas
        table.insert(esp.Lines, line)
    end

    -- 3. Health Bar di Atas Kepala (Background Hitam)
    esp.HealthBg = Drawing.new("Line")
    esp.HealthBg.Visible = false
    esp.HealthBg.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBg.Thickness = 3.5

    -- 4. Health Bar di Atas Kepala (Bar Utama yang Dinamis)
    esp.HealthFill = Drawing.new("Line")
    esp.HealthFill.Visible = false
    esp.HealthFill.Thickness = 2.5

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
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
            local legPos, legOnScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3.2, 0))
            
            if headOnScreen or legOnScreen then
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                -- Ukuran kotak diperlebar sedikit agar tidak terlalu rapat ke body
                local height = math.abs(headPos.Y - legPos.Y)
                local width = (height / 1.8) + 6 
                local pos = Vector2.new(headPos.X - width / 2, headPos.Y)
                
                -- A. Tracer Line dari atas tengah layar
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                esp.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                
                -- B. Corner Box (Sudut Terputus-putus)
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

                -- C. Health Bar Horizontal di Atas Kepala (Dinamis & Berubah Warna)
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barY = pos.Y - 6
                local barStartX = pos.X
                local barEndX = pos.X + width
                
                esp.HealthBg.Visible = true
                esp.HealthBg.From = Vector2.new(barStartX, barY)
                esp.HealthBg.To = Vector2.new(barEndX, barY)
                
                esp.HealthFill.Visible = true
                esp.HealthFill.From = Vector2.new(barStartX, barY)
                esp.HealthFill.To = Vector2.new(barStartX + (width * healthPercent), barY)
                
                -- Warna Health Bar Dinamis (Hijau -> Kuning -> Merah)
                if healthPercent > 0.5 then
                    esp.HealthFill.Color = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.25 then
                    esp.HealthFill.Color = Color3.fromRGB(255, 255, 0)
                else
                    esp.HealthFill.Color = Color3.fromRGB(255, 0, 0)
                end

                -- D. Teks Nama & Jarak (Nama di atas health bar, Jarak di bawah box)
                esp.Text.Visible = true
                esp.Text.Text = string.format("%s\n[%dm]", player.Name, math.floor(distance))
                esp.Text.Position = Vector2.new(headPos.X, pos.Y - 24)
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

print("ESP Corner Box Tebal & Top HealthBar Berhasil Dijalankan!")
