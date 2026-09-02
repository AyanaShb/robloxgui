-- Inisialisasi Layanan
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Setup RemoteEvent untuk Eksekusi Kill All yang Sah (Bukan Visual Saja)
local killEvent = ReplicatedStorage:FindFirstChild("KillAllEvent")
if not killEvent then
    killEvent = Instance.new("RemoteEvent")
    killEvent.Name = "KillAllEvent"
    killEvent.Parent = ReplicatedStorage
end

-- Fungsi utama untuk mematikan semua player dari server
local function executeKillAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
end

-- Listener ketika event dipanggil
killEvent.OnServerEvent:Connect(function(player)
    -- Tambahkan validasi admin/whitelist di sini jika diperlukan agar tidak sembarang orang bisa memakai
    executeKillAll()
end)

-- 2. Sistem Anti-Cheat Server-Side (Mencegah Eksploitasi & Bypass)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local maxHealth = humanoid.MaxHealth
        
        -- Validasi integritas health secara berkala untuk mencegah modifikasi ilegal dari client
        humanoid.HealthChanged:Connect(function(health)
            if health > maxHealth then
                -- Jika ada indikasi cheat darah tak terbatas (Godmode/Health Hack)
                humanoid.Health = maxHealth
            end
        end)
    end)
end)
