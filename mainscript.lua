-- Universal Mobile Combat Menu (Lightweight & Responsive)
-- Compatible with Delta, Codex, Arceus X, etc.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration Table (Features Toggle)
getgenv().Config = {
    ESP_Enabled = true,
    BoxESP = true,
    NameESP = true,
    LineESP = false,
    Aimbot = false,
    SilentAim = false,
    Wallbang = false,
    AimPart = "Head",
    FOV = 120
}

-- Create ScreenGui for Mobile Toggle Button
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileCombatMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleMenu"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 128)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 110, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "RIOT: UI"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
ToggleBtn.TextSize = 16
ToggleBtn.Draggable = true

-- Main Frame (Clean & Minimalist Android UI)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 340)
MainFrame.Visible = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "UNIVERSAL COMBAT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- UI Helper Function to Create Toggles
local function CreateToggle(name, yPos, configKey)
    local Btn = Instance.new("TextButton")
    Btn.Parent = MainFrame
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Font = Enum.Font.SourceSans
    Btn.Text = name .. ": [OFF]"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 14

    Btn.MouseButton1Click:Connect(function()
        getgenv().Config[configKey] = not getgenv().Config[configKey]
        if getgenv().Config[configKey] then
            Btn.Text = name .. ": [ON]"
            Btn.TextColor3 = Color3.fromRGB(0, 255, 128)
        else
            Btn.Text = name .. ": [OFF]"
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- Generate Menu Options
CreateToggle("ESP Box", 45, "BoxESP")
CreateToggle("ESP Name", 85, "NameESP")
CreateToggle("Aimbot", 125, "Aimbot")
CreateToggle("Silent Aim", 165, "SilentAim")
CreateToggle("Wallbang Helper", 205, "Wallbang")

-- Universal ESP Engine (Lightweight Drawing)
local espCache = {}

local function RemoveESP(player)
    if espCache[player] then
        if espCache[player].box then espCache[player].box:Remove() end
        if espCache[player].name then espCache[player].name:Remove() end
        espCache[player] = nil
    end
end

local function AddESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 255, 128)
    box.Thickness = 1
    box.Filled = false

    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Size = 14
    name.Center = true
    name.Outline = true

    espCache[player] = {box = box, name = name}
end

Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(RemoveESP)
for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end

-- Main Loop (Optimized for Mobile FPS Stability)
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        local esp = espCache[player]
        local char = player.Character
        if esp and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and getgenv().Config.ESP_Enabled then
                local head = char:FindFirstChild("Head")
                if head and getgenv().Config.BoxESP then
                    local headVec = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legVec = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headVec.Y - legVec.Y)
                    local width = height / 2

                    esp.box.Size = Vector2.new(width, height)
                    esp.box.Position = Vector2.new(vector.X - width / 2, headVec.Y)
                    esp.box.Visible = true
                else
                    esp.box.Visible = false
                end

                if getgenv().Config.NameESP then
                    esp.name.Text = player.Name
                    esp.name.Position = Vector2.new(vector.X, vector.Y - 40)
                    esp.name.Visible = true
                else
                    esp.name.Visible = false
                end
            else
                esp.box.Visible = false
                esp.name.Visible = false
            end
        else
            if esp then
                esp.box.Visible = false
                esp.name.Visible = false
            end
        end
    end

    -- Basic Aimbot Logic Handler
    if getgenv().Config.Aimbot then
        local closestTarget = nil
        local shortestDist = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild(getgenv().Config.AimPart)
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                        if magnitude < shortestDist then
                            shortestDist = magnitude
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end

        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        end
    end
end)
