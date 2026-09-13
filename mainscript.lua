-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Konfigurasi Fitur
local Settings = {
    BulletTrack = false,
    TeamCheck = true
}

-- Membuat Tampilan Tombol On/Off (GUI) di Layar
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BulletTrackMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Menu bisa digeser-geser pakai mouse
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Bullet Track 360°"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Tombol On/Off Bullet Track
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah (Off)
ToggleButton.Text = "Bullet Track: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- Tombol On/Off Team Check
local TeamButton = Instance.new("TextButton")
TeamButton.Size = UDim2.new(0.9, 0, 0, 35)
TeamButton.Position = UDim2.new(0.05, 0, 0.62, 0)
TeamButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Hijau (On)
TeamButton.Text = "Team Check: ON"
TeamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamButton.TextSize = 12
TeamButton.Font = Enum.Font.SourceSansBold
TeamButton.Parent = MainFrame

local TeamCorner = Instance.new("UICorner")
TeamCorner.CornerRadius = UDim.new(0, 6)
TeamCorner.Parent = TeamButton

-- Logika Tombol Interaktif
ToggleButton.MouseButton1Click:Connect(function()
    Settings.BulletTrack = not Settings.BulletTrack
    if Settings.BulletTrack then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ToggleButton.Text = "Bullet Track: ON"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        ToggleButton.Text = "Bullet Track: OFF"
    end
end)

TeamButton.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    if Settings.TeamCheck then
        TeamButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        TeamButton.Text = "Team Check: ON"
    else
        TeamButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        TeamButton.Text = "Team Check: OFF"
    end
end)

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
                    if rootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

-- Hooking Peluru / Tembakan Instan (Silent Aim 360°)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.BulletTrack and (method == "FireServer" or method == "InvokeServer") then
        local targetPart = GetClosestEnemy()
        if targetPart then
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    -- Mengarahkan jalur peluru otomatis ke posisi musuh terdekat
                    args[i] = targetPart.Position
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

print("Menu & Bullet Track 360 Berhasil Dijalankan!")
