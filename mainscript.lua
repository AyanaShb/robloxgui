-- init
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local SilentAimSettings = {
    Enabled = false,
    TeamCheck = false,
    VisibleCheck = false, 
    TargetPart = "HumanoidRootPart",
    FOVRadius = 150,
    HitChance = 100
}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local WorldToScreen = Camera.WorldToScreenPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild

-- Hapus GUI lama agar tidak duplikat
if CoreGui:FindFirstChild("FixedAndroidSilentAim") then
    CoreGui.FixedAndroidSilentAim:Destroy()
end

-- UI Mobile (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixedAndroidSilentAim"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 210)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Silent Aim [Fixed Mobile]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize, Title.Font = 12, Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = Title

-- Fungsi Tombol Toggle UI
local function CreateButton(name, yPos, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 110, 50) or Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. name .. ": [ " .. (defaultState and "ON" or "OFF") .. " ]"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize, btn.Font = 11, Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. name .. ": [ " .. (state and "ON" or "OFF") .. " ]"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 110, 50) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
    return btn
end

CreateButton("Silent Aim", 45, SilentAimSettings.Enabled, function(v) SilentAimSettings.Enabled = v end)
CreateButton("Team Check", 90, SilentAimSettings.TeamCheck, function(v) SilentAimSettings.TeamCheck = v end)
CreateButton("Visible Check", 135, SilentAimSettings.VisibleCheck, function(v) SilentAimSettings.VisibleCheck = v end)

-- Tombol Minimalkan UI
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 30, 0, 25)
HideBtn.Position = UDim2.new(0.85, 0, 0.08, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize, HideBtn.Font = 14, Enum.Font.GothamBold
HideBtn.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Text = "UI"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
OpenBtn.TextSize, OpenBtn.Font = 14, Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Logika Inti Silent Aim (Dioptimalkan agar tidak freeze karakter)
local function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

local function IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = LocalPlayer.Character
    if not (PlayerCharacter or LocalPlayerCharacter) then return false end 
    local PlayerRoot = FindFirstChild(PlayerCharacter, SilentAimSettings.TargetPart) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    if not PlayerRoot then return false end 
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    return ObscuringObjects == 0
end

local function getClosestPlayer()
    local Closest
    local DistanceToMouse = math.huge
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, Player in next, Players:GetPlayers() do
        if Player == LocalPlayer then continue end
        if SilentAimSettings.TeamCheck and Player.Team == LocalPlayer.Team then continue end

        local Character = Player.Character
        if not Character then continue end
        
        if SilentAimSettings.VisibleCheck and not IsPlayerVisible(Player) then continue end

        local HumanoidRootPart = FindFirstChild(Character, SilentAimSettings.TargetPart) or FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = WorldToScreen(Camera, HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (ScreenCenter - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
        if Distance <= DistanceToMouse and Distance <= SilentAimSettings.FOVRadius then
            Closest = HumanoidRootPart
            DistanceToMouse = Distance
        end
    end
    return Closest
end

-- Hook Metamethod Raycast yang Aman (Tanpa Validasi Kaku)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    
    if SilentAimSettings.Enabled and not checkcaller() then
        if Method == "Raycast" and self == workspace then
            local Origin = Arguments[1]
            local Direction = Arguments[2]
            
            if typeof(Origin) == "Vector3" and typeof(Direction) == "Vector3" then
                if CalculateChance(SilentAimSettings.HitChance) then
                    local HitPart = getClosestPlayer()
                    if HitPart then
                        -- Menyesuaikan arah vektor ke target tanpa merusak jarak asli
                        local mag = Direction.Magnitude
                        Arguments[2] = (HitPart.Position - Origin).Unit * mag
                        return oldNamecall(self, unpack(Arguments))
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end))
