-- Memuat UI Library yang Support Android (Orion Library)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    BulletTrack = false,
    TeamCheck = true,
    TargetPart = "HumanoidRootPart"
}

-- Membuat Window Khusus Mobile
local Window = OrionLib:MakeWindow({
    Name = "Bullet Track 360° | Android Menu",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "AndroidBulletTrack"
})

-- Membuat Tab Utama
local Tab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

-- Bagian Section
local Section = Tab:AddSection({
    Name = "Main Features"
})

-- Toggle On/Off Bullet Track 360
Section:AddToggle({
    Name = "Bullet Track 360°",
    Default = false,
    Callback = function(Value)
        Settings.BulletTrack = Value
        OrionLib:MakeNotification({
            Title = "Bullet Track",
            Content = Value and "Status: AKTIF" : "Status: MATI",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end    
})

-- Toggle Team Check
Section:AddToggle({
    Name = "Team Check",
    Default = true,
    Callback = function(Value)
        Settings.TeamCheck = Value
    end    
})

-- Dropdown Pilih Bagian Target (Head / Body)
Section:AddDropdown({
    Name = "Target Bone",
    Default = "HumanoidRootPart",
    Options = {"HumanoidRootPart", "Head"},
    Callback = function(Value)
        Settings.TargetPart = Value
    end    
})

-- Tombol Exit / Tutup Menu
Section:AddButton({
    Name = "Close Menu",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Fungsi Cari Musuh Terdekat 360° (Optimized for Mobile Execution)
local function GetClosestEnemy()
    local target = nil
    local shortestDist = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if not Settings.TeamCheck or v.Team ~= LocalPlayer.Team then
                local char = v.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local rootPart = char:FindFirstChild(Settings.TargetPart) or char:FindFirstChild("HumanoidRootPart")
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

-- Hooking Peluru Khusus Executor Android
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.BulletTrack and (method == "FireServer" or method == "InvokeServer") then
        local targetPart = GetClosestEnemy()
        if targetPart then
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = targetPart.Position
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Inisialisasi UI
OrionLib:Init()
