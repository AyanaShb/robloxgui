print("=== SCRIPT STARTED ===")

local success, err = pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TestMenuUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local TextButton = Instance.new("TextButton")
    TextButton.Name = "TestBtn"
    TextButton.Parent = ScreenGui
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TextButton.Position = UDim2.new(0.3, 0, 0.3, 0)
    TextButton.Size = UDim2.new(0, 200, 0, 80)
    TextButton.Text = "KLIK AKU (TEST)"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 18

    TextButton.MouseButton1Click:Connect(function()
        print("BUTTON BERHASIL DIKLIK!")
        TextButton.Text = "BERHASIL KLIK!"
        TextButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end)
end)

if not success then
    warn("ERROR SCRIPT: " .. tostring(err))
else
    print("=== SCRIPT LOADED SUCCESSFULLY ===")
end
