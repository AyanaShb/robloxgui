local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Settings = {
    Enabled = false,
    TeamCheck = true,
    HitPart = "HumanoidRootPart"
}

-- UI Menu Mobile Sederhana
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Pure Silent Aim (Peluru Belok)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Status: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.TextSize = 14

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

-- Mencari musuh terdekat di layar
local function GetClosestTarget()
    local target = nil
    local shortestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not Settings.TeamCheck or player.Team ~= LocalPlayer.Team then
                local char = player.Character
                if char and char:FindFirstChild(Settings.HitPart) and char:FindFirstChildOfClass("Humanoid") then
                    if char.Humanoid.Health > 0 then
                        local pos, onScreen = Camera:WorldToViewportPoint(char[Settings.HitPart].Position)
                        if onScreen then
                            local magnitude = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                            if magnitude < shortestDist then
                                shortestDist = magnitude
                                target = char[Settings.HitPart]
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Hook sistem Raycast game agar arah tembakan/peluru berbelok ke musuh
local oldRaycast
oldRaycast = hookfunction(Workspace.Raycast, function(self, origin, direction, params)
    if Settings.Enabled and self == Workspace then
        local targetPart = GetClosestTarget()
        if targetPart then
            -- Membelokkan arah vektor raycast (peluru) langsung ke badan musuh
            local newDirection = (targetPart.Position - origin).Unit * direction.Magnitude
            return oldRaycast(self, origin, newDirection, params)
        end
    end
    return oldRaycast(self, origin, direction, params)
end)
