-- Roblox Mobile UI Script (Android Executable)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Points - D3D Touch UI",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "Android Support",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ==========================================
-- TABS
-- ==========================================
local ESPTab = Window:CreateTab("ESP", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local SilentAimTab = Window:CreateTab("Silent Aim", 4483362458)

-- State Features
local State = {
    Skeleton = false,
    Name = false,
    Chams = false,
    JumpHack = false,
    JumpPowerVal = 50, -- Power dorongan tiap kali tap
    SpeedHack = false,
    Wallhack = false,
    SilentAim = false,
    Smooth = 5,
    SpeedAim = 10,
    FOVRange = 100
}

-- ==========================================
-- 1. ESP TAB
-- ==========================================
ESPTab:CreateToggle({
   Name = "Skeleton ESP",
   CurrentValue = false,
   Callback = function(Value) State.Skeleton = Value end,
})

ESPTab:CreateToggle({
   Name = "Name ESP",
   CurrentValue = false,
   Callback = function(Value) State.Name = Value end,
})

ESPTab:CreateToggle({
   Name = "Chams ESP (Tembus Tembok)",
   CurrentValue = false,
   Callback = function(Value) State.Chams = Value end,
})

-- ==========================================
-- 2. MISC TAB
-- ==========================================
MiscTab:CreateToggle({
   Name = "Multi-Jump (Tap-Tap Naik)",
   CurrentValue = false,
   Callback = function(Value) State.JumpHack = Value end,
})

MiscTab:CreateSlider({
   Name = "Tinggi Dorongan Jump",
   Range = {20, 150},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) State.JumpPowerVal = Value end,
})

MiscTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Callback = function(Value) State.SpeedHack = Value end,
})

MiscTab:CreateToggle({
   Name = "Wallhack (Noclip)",
   CurrentValue = false,
   Callback = function(Value) State.Wallhack = Value end,
})

-- ==========================================
-- 3. SILENT AIM TAB
-- ==========================================
SilentAimTab:CreateToggle({
   Name = "Bullet Track (Silent Aim)",
   CurrentValue = false,
   Callback = function(Value) State.SilentAim = Value end,
})

SilentAimTab:CreateSlider({
   Name = "Aim Smooth",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 5,
   Callback = function(Value) State.Smooth = Value end,
})

SilentAimTab:CreateSlider({
   Name = "Aim Speed",
   Range = {1, 20},
   Increment = 1,
   CurrentValue = 10,
   Callback = function(Value) State.SpeedAim = Value end,
})

SilentAimTab:CreateSlider({
   Name = "FOV Range",
   Range = {30, 300},
   Increment = 5,
   CurrentValue = 100,
   Callback = function(Value) State.FOVRange = Value end,
})

-- ==========================================
-- LOGIC FITUR (ANDROID COMPATIBLE)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Logic Multi-Jump (Setiap kali tombol jump di-tap)
UserInputService.JumpRequest:Connect(function()
    if State.JumpHack then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            -- Memberikan vektor dorongan ke atas tanpa menghilangkan momentum jalan
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, State.JumpPowerVal, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)

-- Logic Loop untuk Speed & Noclip
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = State.SpeedHack and 32 or 16
        end

        if State.Wallhack then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Logic Chams ESP (Highlight Native Roblox)
local function UpdateChams(player)
    RunService.RenderStepped:Connect(function()
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("MobileChams")
            if State.Chams then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "MobileChams"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do UpdateChams(p) end
Players.PlayerAdded:Connect(UpdateChams)
