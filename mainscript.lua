-- Contoh format script Luau untuk eksekutor seperti Delta (berbasis manipulasi instance game)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Fungsi untuk mencari tool/senjata yang sedang dipegang dan memodifikasi properti rate/amunisi
local function applyRapidFire()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        -- Mencari nilai konfigurasi senjata di dalam objek (misal: FireRate / Cooldown)
        for _, v in ipairs(tool:GetDescendants()) do
            if v.Name == "FireRate" or v.Name == "Cooldown" or v.Name == "AtkSpeed" then
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    v.Value = 0.01 -- Mempercepat tembakan
                end
            end
        end
    end
end

applyRapidFire()
