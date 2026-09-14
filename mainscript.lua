-- Script No Recoil Direct Hook untuk Modul 3021
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Mencari path spesifik tempat modul konfigurasi disimpan di ReplicatedStorage
local success, recoilModule = pcall(function()
    return ReplicatedStorage.Scripts.Config.BlasterConfig.RecoilTemplate["3021"]
end)

if success and recoilModule and recoilModule:IsA("ModuleScript") then
    local data = require(recoilModule)
    if type(data) == "table" then
        -- Ubah semua nilai recoil menjadi nol secara langsung di memori
        data.isApplyRecoil = false
        data.AimMultiplier = 0
        data.Backward_KickAmount = 0
        data.Backward_Recover1_Percent = 0
        data.Backward_Pause_Frames = 0
        data.Backward_Recover_Frames = 0
        data.Lateral_Kick_Duration = 0
        data.Lateral_Kick_Amount_Min = 0
        data.Lateral_Kick_Amount_Max = 0
        data.Lateral_Recover_Duration = 0
        data.Pitch_Kick_Amount_Min_Deg = 0
        data.Pitch_Kick_Amount_Max_Deg = 0
        data.Pitch_Kick_Duration = 0
        data.Pitch_Recover_Duration = 0
        data.Yaw_Kick_Duration = 0
        data.Yaw_Kick_Amount_Min_Deg = 0
        data.Yaw_Kick_Amount_Max_Deg = 0
        data.Yaw_Shake_Duration = 0
        data.Yaw_Shake_Frequency = 0
        data.Yaw_Shake_Amplitude_Mod = 0
        data.HipLift_Kick_Amount_Min_Deg = 0
        data.HipLift_Kick_Amount_Max_Deg = 0
        data.HipLift_Kick_Duration = 0
        data.HipLift_Recover_Duration = 0
        data.HipLift_Aim_Cancel_Duration = 0
        
        print("Berhasil menonaktifkan recoil pada Modul 3021 (Runtime Hook)!")
    end
else
    -- Metode pencarian alternatif jika path sedikit berbeda
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "3021" and v:IsA("ModuleScript") then
            local data = require(v)
            if type(data) == "table" then
                data.isApplyRecoil = false
                data.AimMultiplier = 0
                data.Pitch_Kick_Amount_Min_Deg = 0
                data.Pitch_Kick_Amount_Max_Deg = 0
                data.Yaw_Kick_Amount_Min_Deg = 0
                data.Yaw_Kick_Amount_Max_Deg = 0
                print("Modul 3021 ditemukan via pencarian global dan recoil dinonaktifkan!")
            end
        end
    end
end
