local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("MultiMethodAimMenu") then
    CoreGui.MultiMethodAimMenu:Destroy()
end

local Settings = {
    Method1 = false, -- Metamethod Hooking
    Method2 = false, -- Raycast / Vector Overwriting
    Method3 = false, -- Character Property / Camera ViewDirection Hook
    TeamCheck = true
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiMethodAimMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 280, 0, 260)
Window.Position = UDim2.new(0.5, -140, 0.35, -130)
Window.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 6)
WindowCorner.Parent = Window

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 6)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "3-Method Aim [Android ImGui]"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize, Title.Font = 12, Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 30, 0, 20)
HideBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize, HideBtn.Font = 14, Enum.Font.GothamBold
HideBtn.Parent = TopBar

local HideBtnCorner = Instance.new("UICorner")
HideBtnCorner.CornerRadius = UDim.new(0, 4)
HideBtnCorner.Parent = HideBtn

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Text = "UI"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
OpenBtn.TextSize, OpenBtn.Font = 14, Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 8)
OpenBtnCorner.Parent = OpenBtn

HideBtn.MouseButton1Click:Connect(function()
    Window.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Window.Visible = true
    OpenBtn.Visible = false
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -45)
Content.Position = UDim2.new(0, 8, 0, 38)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 220)
Content.ScrollBarThickness = 3
Content.Parent = Window

local function CreateToggleButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "  " .. name .. ": [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize, btn.Font = 11, Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = "  " .. name .. ": [ ON ]"
            btn.BackgroundColor3 = Color3.fromRGB(0, 110, 50)
        else
            btn.Text = "  " .. name .. ": [ OFF ]"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        callback(state)
    end)
    return btn
end

CreateToggleButton("1. Namecall Hook", 10, function(v) Settings.Method1 = v end)
CreateToggleButton("2. Vector Intercept", 55, function(v) Settings.Method2 = v end)
CreateToggleButton("3. Camera/CFrame Redirect", 100, function(v) Settings.Method3 = v end)
CreateToggleButton("Team Check", 145, function(v) Settings.TeamCheck = v end)

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

-- Metode 1: Hook Metamethod Namecall (__namecall)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Settings.Method1 and (method == "FireServer" or method == "InvokeServer") then
        local target = GetClosestEnemy()
        if target then
            for i, arg in ipairs(args) do
                if typeof(arg) == "Vector3" then
                    args[i] = target.Position
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Metode 2: Vector Intercept / Raycast parameter manipulation
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, k)
    if Settings.Method2 and k == "Hit" then
        local target = GetClosestEnemy()
        if target then
            return target.CFrame
        end
    end
    return oldIndex(self, k)
end)

-- Metode 3: Camera / ViewDirection CFrame Redirection
RunService.RenderStepped:Connect(function()
    if Settings.Method3 then
        local target = GetClosestEnemy()
        local camera = workspace.CurrentCamera
        if target and camera then
            local direction = (target.Position - camera.CFrame.Position).Unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
        end
    end
end)
