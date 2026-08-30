-- =====================================================================
-- MENU ASLIMU + LOGIKA ESP LINE MURNI
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Hapus GUI lama biar nggak dobel
if _G.CustomMenuGui then _G.CustomMenuGui:Destroy() end

local function GetSafeParent()
    if gethui then
        local success, parent = pcall(gethui)
        if success and parent then return parent end
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then return playerGui end
    return CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = GetSafeParent()
_G.CustomMenuGui = ScreenGui

-- Status Toggle ESP Line
local ESPLineEnabled = false

-- Tombol Buka/Tutup Menu (Floating Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 12
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 1.5
BtnStroke.Color = Color3.fromRGB(0, 170, 255)
BtnStroke.Parent = ToggleBtn

-- Main Frame Menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Parent = MainFrame

-- Judul Menu
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SIMPLE MENU"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = MainFrame

-- Tombol Toggle ESP Line di dalam Menu
local ESPIsOnBtn = Instance.new("TextButton")
ESPIsOnBtn.Size = UDim2.new(0.9, 0, 0, 40)
ESPIsOnBtn.Position = UDim2.new(0.05, 0, 0, 50)
ESPIsOnBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ESPIsOnBtn.BorderSizePixel = 0
ESPIsOnBtn.Text = "ESP Line: OFF"
ESPIsOnBtn.Font = Enum.Font.SourceSansBold
ESPIsOnBtn.TextSize = 13
ESPIsOnBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ESPIsOnBtn.Parent = MainFrame

local ESPBtnCorner = Instance.new("UICorner")
ESPBtnCorner.CornerRadius = UDim.new(0, 6)
ESPBtnCorner.Parent = ESPIsOnBtn

-- Fungsi Buka Tutup Menu
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Fungsi Tombol ESP Line
ESPIsOnBtn.MouseButton1Click:Connect(function()
    ESPLineEnabled = not ESPLineEnabled
    if ESPLineEnabled then
        ESPIsOnBtn.Text = "ESP Line: ON"
        ESPIsOnBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ESPIsOnBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 50)
    else
        ESPIsOnBtn.Text = "ESP Line: OFF"
        ESPIsOnBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ESPIsOnBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- =====================================================================
-- RENDER LOOP ESP LINE (Sesuai Logika Pilihanmu)
-- =====================================================================
local LineContainer = Instance.new("Folder")
LineContainer.Name = "LineContainer"
LineContainer.Parent = ScreenGui

local ActiveLines = {}

RunService.RenderStepped:Connect(function()
    -- Bersihkan garis frame sebelumnya
    for _, line in pairs(ActiveLines) do
        if line and line.Destroy then
            line:Destroy()
        end
    end
    ActiveLines = {}

    -- Jika fitur dimatikan, lewati
    if not ESPLineEnabled then return end

    local bottomScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            if hum and hum.Health > 0 and head then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)

                if headOnScreen then
                    local snapLine = Instance.new("Frame")
                    snapLine.AnchorPoint = Vector2.new(0.5, 0)
                    snapLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Warna Garis Merah
                    snapLine.BorderSizePixel = 0
                    snapLine.Size = UDim2.new(0, 1, 0, 0)
                    
                    local fromPos = bottomScreenCenter
                    local toPos = Vector2.new(headPos.X, headPos.Y)
                    local magnitude = (toPos - fromPos).Magnitude
                    
                    snapLine.Position = UDim2.new(0, (fromPos.X + toPos.X) / 2, 0, (fromPos.Y + toPos.Y) / 2)
                    snapLine.Size = UDim2.new(0, 1, 0, magnitude)
                    snapLine.Rotation = math.deg(math.atan2(toPos.Y - fromPos.Y, toPos.X - fromPos.X)) - 90
                    snapLine.Parent = LineContainer

                    table.insert(ActiveLines, snapLine)
                end
            end
        end
    end
end)
