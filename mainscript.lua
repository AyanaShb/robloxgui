-- Script No Recoil (Menghilangkan Sentakan dan Getaran Senjata)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Mencari modul yang mengatur recoil berdasarkan isinya
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("ModuleScript") and string.match(v.Name:lower(), "recoil") or string.match(v.Name:lower(), "camera") then
        local success, data = pcall(require, v)
        if success and type(data) == "table" and data.isApplyRecoil ~= nil then
            -- Ubah parameter recoil menjadi 0 atau nonaktif
            data.isApplyRecoil = false
            data.AimMultiplier = 0
            data.Backward_KickAmount = 0
            data.Pitch_Kick_Amount_Min_Deg = 0
            data.Pitch_Kick_Amount_Max_Deg = 0
            data.Yaw_Kick_Amount_Min_Deg = 0
            data.Yaw_Kick_Amount_Max_Deg = 0
            data.HipLift_Kick_Amount_Min_Deg = 0
            data.HipLift_Kick_Amount_Max_Deg = 0
            
            print("Berhasil menonaktifkan recoil pada modul: " .. v.Name)
        end
    end
end
