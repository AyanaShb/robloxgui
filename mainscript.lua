-- init
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local SilentAimSettings = {
    Enabled = false,
    TeamCheck = false,
    TargetPart = "HumanoidRootPart"
}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local WorldToScreen = Camera.WorldToScreenPoint
local FindFirstChild = game.FindFirstChild

-- Hapus GUI lama agar tidak duplikat
if CoreGui:FindFirstChild("UniversalRemoteAim") then
    CoreGui.UniversalRemoteAim:Destroy()
end

-- UI Mobile (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalRemoteAim"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Silent Aim [Remote Hook]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize, Title.Font = 12, Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = Title

-- Fungsi Tombol Toggle UI
local function CreateButton(name, yPos, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 110, 50) or Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. name .. ": [ " .. (defaultState and "ON" or "OFF") .. " ]"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize, btn.Font = 11, Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. name .. ": [ " .. (state and "ON" or "OFF") .. " ]"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 110, 50) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
    return btn
end

CreateButton("Silent Aim", 45, SilentAimSettings.Enabled, function(v) SilentAimSettings.Enabled = v end)
CreateButton("Team Check", 90, SilentAimSettings.TeamCheck, function(v) SilentAimSettings.TeamCheck = v end)

-- Tombol Minimalkan UI
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 30, 0, 25)
HideBtn.Position = UDim2.new(0.85, 0, 0.08, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize, HideBtn.Font = 14, Enum.Font.GothamBold
HideBtn.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Text = "UI"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
OpenBtn.TextSize, OpenBtn.Font = 14, Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Mencari Musuh Terdekat 360°
local function getClosestPlayer()
    local target = nil
    local shortestDist = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if not SilentAimSettings.TeamCheck or v.Team ~= LocalPlayer.Team then
                local char = v.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local rootPart = char:FindFirstChild(SilentAimSettings.TargetPart) or char:FindFirstChild("HumanoidRootPart")
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

-- Hook RemoteEvent FireServer (Metode paling ampuh untuk game menembak)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if SilentAimSettings.Enabled and not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local targetPart = getClosestPlayer()
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
end))
