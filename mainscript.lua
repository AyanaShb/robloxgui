-- Universal Rapid Fire Script for Roblox Android
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Konfigurasi Pengaturan
getgenv().Config = {
    RapidFireEnabled = true,
    FireDelay = 0.05 -- Jeda waktu antar tembakan (semakin kecil semakin cepat)
}

local function getEquippedWeapon()
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

-- Loop utama untuk mengeksekusi rapid fire saat tool aktif
task.spawn(function()
    while true do
        task.wait(getgenv().Config.FireDelay)
        if getgenv().Config.RapidFireEnabled then
            local weapon = getEquippedWeapon()
            if weapon then
                pcall(function()
                    -- Memaksa tool untuk aktif secara terus-menerus
                    weapon:Activate()
                end)
            end
        end
    end
end)
