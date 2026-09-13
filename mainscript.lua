local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local SilentAim = {
    Enabled = false,
    TeamCheck = true,
    HitPart = "HumanoidRootPart"
}

-- UI Menu Mobile Sederhana
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "StableSilentAim"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 210, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Mobile Raycast Silent Aim"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Status: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.TextSize = 14

ToggleBtn.MouseButton1Click:Connect(function()
    SilentAim.Enabled = not SilentAim.Enabled
    if SilentAim.Enabled then
        ToggleBtn.Text = "Status: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        ToggleBtn.Text = "Status: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

local function GetClosestTarget()
    local target = nil
    local shortestDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not SilentAim.TeamCheck or p.Team ~= LocalPlayer.Team then
                local char = p.Character
                if char and char:FindFirstChild(SilentAim.HitPart) then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local pos, onScreen = Camera:WorldToViewportPoint(char[SilentAim.HitPart].Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                target = char[SilentAim.HitPart]
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Hook Metamethod yang kompatibel untuk mencegat Raycast game
local oldRaycast
oldRaycast = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if SilentAim.Enabled and self == Workspace and method:lower() == "raycast" then
        local targetPart = GetClosestTarget()
        if targetPart then
            local origin = args[1]
            if typeof(origin) == "Vector3" then
                -- Mengarahkan ulang vektor arah peluru ke target musuh terdekat
                args[2] = (targetPart.Position - origin).Unit * args[2].Magnitude
                return oldRaycast(self, unpack(args))
            end
        end
    end
    
    return oldRaycast(self, ...)
end)
