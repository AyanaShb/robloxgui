local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Cari atau buat RemoteEvent khusus untuk mengubah transparansi
local remoteEvent = ReplicatedStorage:FindFirstChild("GlobalTransparencyEvent")

if not remoteEvent and game:GetService("RunService"):IsStudio() or getgenv then
    -- Jika dijalankan via executor, kita buat RemoteEvent secara runtime di ReplicatedStorage
    remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "GlobalTransparencyEvent"
    remoteEvent.Parent = ReplicatedStorage
end

-- Ambil modul SkillEffect dari skrip sebelumnya (sesuaikan path aslinya jika perlu)
-- Karena ini dijalankan di client executor, kita buat fungsi helper local untuk mengubah transparansi
local function applyTransparencyToCharacter(character, transparencyValue)
    for _, v22 in ipairs(character:GetDescendants()) do
        if v22:IsA("MeshPart") or v22:IsA("Part") then
            v22.Transparency = transparencyValue
        end
    end
end

-- ==========================================
-- EKsekusi ke Server (Agar terlihat orang lain)
-- ==========================================
if remoteEvent then
    -- Jika server mendengarkan event ini (atau jika kita buat handler-nya lewat script sisi server)
    -- Catatan: Executor biasa (client-side) tidak bisa langsung mengeksekusi kode server tanpa server-side executor (SS).
    -- Tapi kita bisa memanfaatkan fungsi bawaan game jika game tersebut memiliki Remote untuk kustomisasi karakter.
end

-- Cara paling aman untuk Executor Client-side murni agar terlihat oleh SEMUA orang 
-- adalah jika game tersebut menggunakan sistem replikasi bawaan. 
-- Jika game menggunakan server-authoritative, client harus mengirim request ke server.

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local transparencyLevel = 0.5 -- 0.5 = Setengah transparan, 1 = Hilang total

-- Menerapkan langsung ke karakter lokal
applyTransparencyToCharacter(character, transparencyLevel)

print("Transparansi berhasil diterapkan!")
