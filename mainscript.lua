local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 200, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Belok Kanan (IgnoreList): OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Belok Kanan (IgnoreList): ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        ToggleBtn.Text = "Belok Kanan (IgnoreList): OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Enabled and method == "FindPartOnRayWithIgnoreList" then
        local ray = args[1] -- Mengambil data Ray (Origin & Direction)
        if typeof(ray) == "Ray" then
            local rightOffset = Workspace.CurrentCamera.CFrame.RightVector * 100
            local newRay = Ray.new(ray.Origin, ray.Direction + rightOffset)
            args[1] = newRay
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)
