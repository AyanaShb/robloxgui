local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada agar tidak menumpuk
if PlayerGui:FindFirstChild("MethodScannerGUI") then
    PlayerGui.MethodScannerGUI:Destroy()
end

-- Buat Menu UI Sederhana (Aman untuk Android PlayerGui)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScanBtn = Instance.new("TextButton")
local OutputLabel = Instance.new("TextLabel")

ScreenGui.Name = "MethodScannerGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Game Method Scanner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

ScanBtn.Parent = MainFrame
ScanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ScanBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ScanBtn.Size = UDim2.new(0.8, 0, 0, 35)
ScanBtn.Font = Enum.Font.SourceSansBold
ScanBtn.Text = "SCAN METHOD"
ScanBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
ScanBtn.TextSize = 13

OutputLabel.Parent = MainFrame
OutputLabel.BackgroundTransparency = 1
OutputLabel.Position = UDim2.new(0.05, 0, 0.52, 0)
OutputLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
OutputLabel.Font = Enum.Font.SourceSans
OutputLabel.Text = "Status: Menunggu klik scan..."
OutputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OutputLabel.TextSize = 12
OutputLabel.TextWrapped = true
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
OutputLabel.TextYAlignment = Enum.TextYAlignment.Top

ScanBtn.MouseButton1Click:Connect(function()
    OutputLabel.Text = "Sedang mendeteksi..."
    
    local foundRemotes = 0
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find("shoot") or name:find("fire") or name:find("hit") or name:find("gun") or name:find("weapon") or name:find("damage") or name:find("bullet") then
                foundRemotes = foundRemotes + 1
            end
        end
    end
    
    local hasFastCast = false
    for _, v in ipairs(game:GetDescendants()) do
        if v.Name:lower():find("fastcast") or v.Name:lower():find("raycast") then
            hasFastCast = true
            break
        end
    end
    
    local resultText = string.format("Hasil Scan:\n- Remote Tembakan: %d ditemukan\n- Modul Custom: %s", 
        foundRemotes, 
        hasFastCast and "Ada (FastCast/Ray)" or "Tidak Ada"
    )
    
    OutputLabel.Text = resultText
    print("[SCANNER RESULT] " .. resultText)
end)
