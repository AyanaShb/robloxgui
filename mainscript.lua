-- Delta Executor VVIP ESP - 100% Drawing API Style
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end

    -- 1. Garis Tracer dari Atas Tengah Layar
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 30, 30)
    tracer.Thickness = 1.5
    tracer.Transparency = 1

    -- 2. Lingkaran Foto Kepala / Indikator Atas
    local headCircle = Drawing.new("Circle")
    headCircle.Visible = false
    headCircle.Radius = 14
    headCircle.Color = Color3.fromRGB(255, 30, 30)
    headCircle.Thickness = 2
    headCircle.Filled = false

    -- 3. Nama Player
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 13
    nameTag.Center = true
    nameTag.Outline = true

    -- 4. Kotak Utama (Box ESP)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 30, 30)
    box.Thickness = 1.5
    box.Filled = false

    -- 5. Health Bar Background (Hitam di Kanan Box)
    local healthBg = Drawing.new("Square")
    healthBg.Visible = false
    healthBg.Color = Color3.fromRGB(0, 0, 0)
    healthBg.Thickness = 1
    healthBg.Filled = true

    -- 6. Health Bar Isi (Hijau/Kuning/Merah di Kanan Box)
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Thickness = 1
    healthBar.Filled = true

    -- 7. Teks Jarak [xxm] di Bawah Box
    local distTag = Drawing.new("Text")
    distTag.Visible = false
    distTag.Color = Color3.fromRGB(255, 255, 255)
    distTag.Size = 12
    distTag.Center = true
    distTag.Outline = true

    espCache[player] = {
        Tracer = tracer,
        HeadCircle = headCircle,
        NameTag = nameTag,
        Box = box,
        HealthBg = healthBg,
        HealthBar = healthBar,
        DistTag = distTag
    }
end

local function removeESP(player)
    if espCache[player] then
        for _, obj in pairs(espCache[player]) do
            obj:Remove()
        end
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and head and root and hum and hum.Health > 0 then
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local rootPos = Camera:WorldToViewportPoint(root.Position)
            local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

            if onScreen then
                local boxHeight = math.abs(headPos.Y - legPos.Y) * 1.2
                local boxWidth = boxHeight * 0.55
                local boxX = headPos.X - (boxWidth / 2)
                local boxY = headPos.Y - (boxHeight / 6)

                -- Update Tracer (Dari atas tengah layar ke kepala)
                cache.Tracer.Visible = true
                cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                cache.Tracer.To = Vector2.new(headPos.X, headPos.Y - 25)

                -- Update Lingkaran Kepala / Avatar di atas box
                cache.HeadCircle.Visible = true
                cache.HeadCircle.Position = Vector2.new(headPos.X, headPos.Y - 25)

                -- Update Nama Player (Di atas kotak)
                cache.NameTag.Visible = true
                cache.NameTag.Text = player.Name
                cache.NameTag.Position = Vector2.new(headPos.X, boxY - 18)

                -- Update Kotak Utama
                cache.Box.Visible = true
                cache.Box.Size = Vector2.new(boxWidth, boxHeight)
                cache.Box.Position = Vector2.new(boxX, boxY)

                -- Update Health Bar Vertikal di Sisi Kanan Box
                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barHeight = boxHeight * healthPercent

                cache.HealthBg.Visible = true
                cache.HealthBg.Size = Vector2.new(4, boxHeight)
                cache.HealthBg.Position = Vector2.new(boxX + boxWidth + 4, boxY)

                cache.HealthBar.Visible = true
                cache.HealthBar.Size = Vector2.new(2, barHeight)
                cache.HealthBar.Position = Vector2.new(boxX + boxWidth + 5, boxY + (boxHeight - barHeight))

                if healthPercent > 0.6 then
                    cache.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.3 then
                    cache.HealthBar.Color = Color3.fromRGB(255, 255, 0)
                else
                    cache.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                end

                -- Update Teks Jarak (Di bawah kotak)
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                cache.DistTag.Visible = true
                cache.DistTag.Text = string.format("[%dm]", math.floor(dist))
                cache.DistTag.Position = Vector2.new(headPos.X, boxY + boxHeight + 4)
            else
                for _, obj in pairs(cache) do
                    obj.Visible = false
                end
            end
        else
            for _, obj in pairs(cache) do
                obj.Visible = false
            end
        end
    end
end)
