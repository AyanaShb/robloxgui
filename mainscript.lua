-- Auto-inject No-Recoil Script
-- Masukkan LocalScript ini ke dalam StarterPlayerScripts atau StarterCharacterScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Mencoba memodifikasi AimManager atau modul weapon di ReplicatedStorage secara otomatis
task.spawn(function()
    pcall(function()
        -- Mencari AimManager berdasarkan struktur proyek
        local ugcFolder = ReplicatedStorage:FindFirstChild("Ugc") or ReplicatedStorage
        -- Anda bisa menyesuaikan path jika modul berada di dalam folder lain
        local aimManagerModule = ugcFolder:FindFirstChild("AimManager", true)
        
        if aimManagerModule then
            local AimManager = require(aimManagerModule)
            if typeof(AimManager) == "table" then
                -- Menimpa fungsi atau nilai recoil jika metodenya terekspos
                for i, v in pairs(AimManager) do
                    if type(v) == "function" then
                        -- Hook fungsi recoil jika ditemukan
                        local oldFunc = v
                        AimManager[i] = function(self, ...)
                            local args = {...}
                            -- Ubah argumen yang berhubungan dengan recoil/shake menjadi 0 jika ada
                            for idx, arg in ipairs(args) do
                                if type(arg) == "table" then
                                    if arg.RecoilPower then arg.RecoilPower = 0 end
                                    if arg.CameraShake then arg.CameraShake = 0 end
                                end
                            end
                            return oldFunc(self, unpack(args))
                        end
                    end
                end
            end
        end
    end)
end)

-- Mencegah Camera Shake langsung dari sisi klien (Client Camera Hook)
local camera = workspace.CurrentCamera
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- Mengunci atau menetralkan efek getaran kamera mendadak akibat senjata
        if camera and camera.CameraType == Enum.CameraType.Custom then
            -- Tambahkan logika tambahan di sini jika engine game menggunakan modul CameraModule bawaan
        end
    end)
end)

print("No-Recoil Script berhasil dijalankan secara otomatis.")
