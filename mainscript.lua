-- =====================================================================
-- D3D SIMPLE MENU + PURE ESP LINE LOGIC
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Hapus UI lama jika ada biar gak numpuk
if _G.SimpleD3D_Gui then _G.SimpleD3D_Gui:Destroy() end

local function GetSafeParent()
    if gethui then
        local success, parent = pcall(gethui)
        if success and parent then return parent end
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then return playerGui end
    return CoreGui
end

-- Setup ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleD3D_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = GetSafeParent()
_G.SimpleD3D_Gui = ScreenGui

-- Konfigurasi Toggle Fitur
local Config = {
    ESPLine = true -- Nyala otomatis buat dites, ubah false kalau mau dimatiin dulu
}

-- Floating Button (Buat Buka/Tutup Menu)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "UI"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.TextColor3 = Color3.fromRGB(0, 235, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 1.5
BtnStroke.Color = Color3.fromRGB(0, 235, 255)
BtnStroke.Parent = ToggleBtn

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(140, 60, 255)
MainStroke.Parent = MainFrame

-- Tombol Buka/Tutup
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Container khusus garis ESP supaya rapi
local LineContainer = Instance.new("Folder")
LineContainer.Name = "ESPLineContainer"
LineContainer.Parent = ScreenGui

local ActiveLines = {}

-- =====================================================================
-- RENDER LOOP (LOGIKA UTAMA ESP LINE)
-- =====================================================================
RunService.RenderStepped:Connect(function()
    -- Bersihkan garis frame sebelumnya
    for _, line in pairs(ActiveLines) do
        if line and line.Destroy then
            line:Destroy()
        end
    end
    ActiveLines = {}

    -- Kalau fitur ESP Line dimatikan di config, hentikan proses di sini
    if not Config.ESPLine then return end

    local bottomScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            if hum and hum.Health > 0 and head then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)

                if headOnScreen then
                    -- Buat garis UI Frame dari contoh script yang kamu mau
                    local snapLine = Instance.new("Frame")
                    snapLine.AnchorPoint = Vector2.new(0.5, 0)
                    snapLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Warna Garis (Merah)
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
