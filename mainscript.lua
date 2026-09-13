local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 180, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Bongkok Kanan: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Bongkok Kanan: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        ToggleBtn.Text = "Bongkok Kanan: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local oldRaycast
oldRaycast = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Enabled and self == Workspace and method:lower() == "raycast" then
        local origin = args[1]
        local direction = args[2]
        if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
            -- Menambahkan offset ke arah kanan (sumbu X / RightVector) secara paksa
            local rightOffset = Workspace.CurrentCamera.CFrame.RightVector * 50
            args[2] = (direction + rightOffset)
            return oldRaycast(self, unpack(args))
        end
    end
    
    return oldRaycast(self, ...)
end)
