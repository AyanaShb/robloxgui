local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 200, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Universal Test: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Universal Test: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        ToggleBtn.Text = "Universal Test: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Menangkap semua bentuk pemanggilan fungsi game (Universal Namecall Hook)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Enabled then
        -- Jika game mengirim data koordinat Vector3 lewat RemoteEvent / FireServer
        if method == "FireServer" then
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = v + Vector3.new(50, 0, 0) -- Paksa geser kanan
                    return oldNamecall(self, unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
