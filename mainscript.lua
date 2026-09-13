local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Enabled = false,
    TeamCheck = true,
    HitPart = "HumanoidRootPart",
    DetectedRemote = nil
}

-- UI Menu Mobile dengan Indikator Scanner
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "AutoScanSilentAim"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 115)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Auto-Scan Silent Aim"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Scanning Game Remotes..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.58, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Status: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.TextSize = 14

-- Fungsi Scan otomatis mendeteksi RemoteEvent senjata di game
local function ScanGameRemotes()
    local keywords = {"shoot", "fire", "hit", "weapon", "gun", "damage", "combat", "bullet", "cast"}
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            local name = descendant.Name:lower()
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    Settings.DetectedRemote = descendant
                    StatusLabel.Text = "Target Found: " .. descendant.Name
                    StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
                    return descendant
                end
            end
        end
    end
    StatusLabel.Text = "Mode: Universal Fallback"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    return nil
end

task.spawn(ScanGameRemotes)

ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        ToggleBtn.Text = "Status: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        ToggleBtn.Text = "Status: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

local function GetTarget()
    local target = nil
    local shortestDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Settings.HitPart) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[Settings.HitPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = p.Character[Settings.HitPart]
                    end
                end
            end
        end
    end
    return target
end

-- Hook otomatis berdasarkan hasil scan (menyesuaikan metode FireServer game)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Settings.Enabled and method == "FireServer" then
        if Settings.DetectedRemote and self == Settings.DetectedRemote then
            local target = GetTarget()
            if target then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = target.Position
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        elseif not Settings.DetectedRemote then
            local target = GetTarget()
            if target then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = target.Position
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
