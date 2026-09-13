-- Pastikan executor Anda mendukung pustaka ImGui dan hookfunction / drawing library
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Konfigurasi Menu & Fitur
local Settings = {
    BulletTrack = false,
    FOV = 360, -- 360 derajat mencakup seluruh area sekitar player
    TeamCheck = true
}

-- Fungsi Mencari Musuh Terdekat 360°
local function GetClosestEnemy()
    local target = nil
    local shortestDist = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if not Settings.TeamCheck or v.Team ~= LocalPlayer.Team then
                local char = v.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                    if rootPart then
                        -- Hitung jarak 3D dari player ke musuh
                        local dist = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = rootPart
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Hooking Fungsi Tembak / Raycast (Contoh Universal Silent Aim)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.BulletTrack and (method == "FireServer" or method == "InvokeServer") then
        -- Deteksi argumen yang menyerupai arah peluru/raycast
        local targetPart = GetClosestEnemy()
        if targetPart and (self.Name:lower():find("gun") or self.Name:lower():find("weapon") or self.Name:lower():find("shoot")) then
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    -- Mengubah arah vektor peluru secara instant ke posisi musuh
                    args[i] = targetPart.Position
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ImGui Menu Setup (Contoh Implementasi Render UI)
-- Catatan: Sesuaikan pemanggilan ImGui dengan pustaka yang disediakan executor Anda (misal: Rayfield, Linoria, atau ImGui Native)
local ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jfdedit3/Roblox-ImGUI/main/ImGui.lua"))()

-- Membuat Window ImGui
local Window = ImGui:CreateWindow({
    Title = "Roblox Menu - Bullet Track 360°",
    Size = UDim2.new(0, 450, 0, 300)
})

local Tab = Window:CreateTab({
    Title = "Combat"
})

Tab:CreateToggle({
    Name = "Bullet Track 360°",
    CurrentValue = false,
    Callback = function(Value)
        Settings.BulletTrack = Value
    end
})

Tab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(Value)
        Settings.TeamCheck = Value
    end
})

print("Menu ImGui & Bullet Track berhasil dimuat!")
