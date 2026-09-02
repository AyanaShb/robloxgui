-- Letakkan di ServerScriptService (Server Script)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Daftarkan username yang diizinkan mengeksekusi kill all
local ALLOWED_ADMIN = "USERNAME_KAMU" -- Ganti dengan username Roblox kamu

local killEvent = ReplicatedStorage:FindFirstChild("KillAllEvent")
if not killEvent then
    killEvent = Instance.new("RemoteEvent")
    killEvent.Name = "KillAllEvent"
    killEvent.Parent = ReplicatedStorage
end

killEvent.OnServerEvent:Connect(function(player)
    -- Validasi apakah yang memanggil adalah admin yang sah
    if player.Name == ALLOWED_ADMIN then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                p.Character:FindFirstChildOfClass("Humanoid").Health = 0
            end
        end
    end
end)

-- Sistem Anti-Cheat Proteksi Health
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local maxHealth = humanoid.MaxHealth
        
        humanoid.HealthChanged:Connect(function(health)
            if health > maxHealth then
                humanoid.Health = maxHealth
            end
        end)
    end)
end)
