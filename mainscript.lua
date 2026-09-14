-- Roblox Android RemoteEvent Rapid Fire Script
local player = game.Players.LocalPlayer

getgenv().RapidFire = true
getgenv().Delay = 0.05 -- Sesuaikan kecepatan (jangan terlalu kecil agar tidak terdeteksi)

local function getWeaponRemote()
    if player.Character then
        for _, v in ipairs(player.Character:GetDescendants()) do
            -- Mencari RemoteEvent di dalam senjata yang sedang dipegang
            if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("gun")) then
                return v
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(getgenv().Delay) do
        if getgenv().RapidFire then
            local remote = getWeaponRemote()
            if remote then
                pcall(function()
                    -- Parameter tembakan biasanya membutuhkan posisi atau arah (bisa disesuaikan dengan game)
                    remote:FireServer()
                end)
            end
        end
    end
end)
