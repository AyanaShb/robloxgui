local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Bersihkan GUI lama jika ada
if CoreGui:FindFirstChild("CustomImGuiMenu") then
    CoreGui.CustomImGuiMenu:Destroy()
end

local Settings = {
    BulletTrack = false,
    TeamCheck = true
}

-- ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomImGuiMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Window (Gaya ImGui)
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 260, 0, 190)
Window.Position = UDim2.new(0.5, -130, 0.4, -95)
Window.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 6)
WindowCorner.Parent = Window

-- Top Bar / Header Window
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 6)
TopBarCorner.Parent = TopBar

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Bullet Track 360° [ImGui]"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize, Title.Font = 12, Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tombol Hide (-) di TopBar
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

-- Tombol Floating kecil untuk Unhide (Muncul saat menu di-hide)
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

-- Fungsi Hide & Unhide
HideBtn.MouseButton1Click:Connect(function()
    Window.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Window.Visible = true
    OpenBtn.Visible = false
end)

-- Konten Menu (Container)
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -45)
Content.Position = UDim2.new(0, 8, 0, 38)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 150)
Content.ScrollBarThickness = 3
Content.Parent = Window

-- Toggle 1: Bullet Track 360
local BTBtn = Instance.new("TextButton")
BTBtn.Size = UDim2.new(1, 0, 0, 35)
BTBtn.Position = UDim2.new(0, 0, 0, 10)
BTBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BTBtn.Text = "  Bullet Track 360°: [ OFF ]"
BTBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
BTBtn.TextSize, BTBtn.Font = 11, Enum.Font.Gotham
BTBtn.TextXAlignment = Enum.TextXAlignment.Left
BTBtn.Parent = Content

local BTC = Instance.new("UICorner")
BTC.CornerRadius = UDim.new(0, 4)
BTC.Parent = BTBtn

BTBtn.MouseButton1Click:Connect(function()
    Settings.BulletTrack = not Settings.BulletTrack
    if Settings.BulletTrack then
        BTBtn.Text = "  Bullet Track 360°: [ ON ]"
        BTBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 50)
    else
        BTBtn.Text = "  Bullet Track 360°: [ OFF ]"
        BTBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Toggle 2: Team Check
local TMBtn = Instance.new("TextButton")
TMBtn.Size = UDim2.new(1, 0, 0, 35)
TMBtn.Position = UDim2.new(0, 0, 0, 55)
TMBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 50)
TMBtn.Text = "  Team Check: [ ON ]"
TMBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
TMBtn.TextSize, TMBtn.Font = 11, Enum.Font.Gotham
TMBtn.TextXAlignment = Enum.TextXAlignment.Left
TMBtn.Parent = Content

local TMC = Instance.new("UICorner")
TMC.CornerRadius = UDim.new(0, 4)
TMC.Parent = TMBtn

TMBtn.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    if Settings.TeamCheck then
        TMBtn.Text = "  Team Check: [ ON ]"
        TMBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 50)
    else
        TMBtn.Text = "  Team Check: [ OFF ]"
        TMBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Logika Utama Bullet Track 360°
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
