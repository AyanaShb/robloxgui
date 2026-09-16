-- ==========================================
-- LITE HACK + ULTIMATE MODS (IMGUI EDITION)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT (COPY PASTE)
-- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function()
                setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false)
            end)
        end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
        if detour_function then detour_function = function(...) return true end end
        if getconnections then
            pcall(function()
                for _, connection in ipairs(getconnections(ScriptContext.Error)) do
                    connection:Disable()
                end
            end)
        end
        if getcallingscript then getcallingscript = function() return nil end end
        for _, tableName in ipairs({"_G", "shared"}) do
            pcall(function()
                local target = getgenv()[tableName]
                if target and type(target) == "table" then
                    for key, _ in pairs(target) do
                        local strKey = tostring(key):lower()
                        if strKey:find("signature") or strKey:find("checksum") or strKey:find("hash") then
                            target[key] = nil
                        end
                    end
                end
            end)
        end
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("handshake") or name:find("validate") or name:find("verify") or name:find("integrity") or name:find("anti") then
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote.FireServer = function(...) return true end
                        elseif remote:IsA("RemoteFunction") then
                            remote.InvokeServer = function(...) return true end
                        end
                    end)
                end
            end
        end
    end)
end)

-- Landscape Force
local Camera = workspace.CurrentCamera
if Camera.ViewportSize.Y > Camera.ViewportSize.X then
    repeat task.wait(0.5) until Camera.ViewportSize.X > Camera.ViewportSize.Y
    task.wait(1)
end

-- ==========================================
-- LOAD IMGUI
-- ==========================================
local ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/rcw666/IMGUI/main/ImGui.lua"))()

local Gui = ImGui.new({
    Title = "Lite Hack + Ultimate Mods",
    Size = UDim2.new(0, 620, 0, 420),
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
    FloatingIcon = false, -- pakai icon custom di bawah
})

Gui:SetFont(Enum.Font.GothamBold, 14)

-- ==========================================
-- FLOATING SKULL ICON
-- ==========================================
local TargetParent = (gethui and gethui()) or game:GetService("CoreGui")

local IconGui = Instance.new("ScreenGui")
IconGui.Name = "LH_SkullIcon"
IconGui.ResetOnSpawn = false
IconGui.IgnoreGuiInset = true
IconGui.Parent = TargetParent

local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(0, 58, 0, 58)
IconBtn.Position = UDim2.new(0, 30, 0.5, -29)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IconBtn.Text = "☠"
IconBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
IconBtn.TextSize = 34
IconBtn.Font = Enum.Font.GothamBlack
IconBtn.AutoButtonColor = false
IconBtn.BorderSizePixel = 0
IconBtn.Active = true
IconBtn.Draggable = true
IconBtn.Parent = IconGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconBtn

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 40, 40)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.2
IconStroke.Parent = IconBtn

local IconGlow = Instance.new("ImageLabel")
IconGlow.Size = UDim2.new(1, 30, 1, 30)
IconGlow.Position = UDim2.new(0, -15, 0, -15)
IconGlow.BackgroundTransparency = 1
IconGlow.Image = "rbxassetid://5028857084"
IconGlow.ImageColor3 = Color3.fromRGB(255, 40, 40)
IconGlow.ImageTransparency = 0.55
IconGlow.ZIndex = 0
IconGlow.Parent = IconBtn

-- Pulse animation
task.spawn(function()
    while IconBtn.Parent do
        TweenService:Create(IconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
        TweenService:Create(IconGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.85}):Play()
        task.wait(1.2)
        TweenService:Create(IconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.1}):Play()
        TweenService:Create(IconGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.4}):Play()
        task.wait(1.2)
    end
end)

-- Toggle menu lewat icon (ImGui has built-in toggle, kita sync)
IconBtn.MouseButton1Click:Connect(function()
    if Gui.Toggle then Gui:Toggle()
    elseif Gui.ToggleVisibility then Gui:ToggleVisibility()
    end
end)
-- ==========================================
-- STATE VARIABLES
-- ==========================================
local State = {
    -- Visual
    ESPEnemy = false,
    ESPTeam = false,
    ESPColor = Color3.fromRGB(255, 60, 60),
    ESPBox = true,
    ESPName = true,
    ESPLine = true,
    ESPHealth = true,
    ESPSkeleton = false,
    ESPDistance = true,
    ESPPicture = false,

    -- Aimbot
    Aimbot = false,
    TeamCheck = true,
    WallCheck = true,
    AimbotMode = "FOV",
    TriggerMode = "Camera",
    ShowFOV = true,
    FOVSize = 150,
    AimLine = false,
    AimTarget = "Head",
    AimDistance = 500,

    -- Player
    SpeedRun = false,
    SpeedPercent = 150,
    MultiJump = false,
    FlyHack = false,
    RapidFire = false,
    UnlimitedAmmo = false,

    -- World
    ClockTime = "Default",
    NoGravity = false,

    -- Config
    Theme = "Dark",
}

local LockedTarget = nil
local FOVRadius = State.FOVSize

-- ==========================================
-- TAB CREATION (5 tabs: Visual, Player, Aimbot, World, Config)
-- ==========================================
local Tabs = {
    Visual  = Gui:Tab("Visual"),
    Player  = Gui:Tab("Player"),
    Aimbot  = Gui:Tab("Aimbot"),
    World   = Gui:Tab("World"),
    Config  = Gui:Tab("Config"),
}

-- ==========================================
-- VISUAL TAB
-- ==========================================
Tabs.Visual:Section("ESP Filters")
Tabs.Visual:Toggle("ESP Enemy", State.ESPEnemy, function(v) State.ESPEnemy = v end)
Tabs.Visual:Toggle("ESP Team", State.ESPTeam, function(v) State.ESPTeam = v end)

Tabs.Visual:Section("ESP Elements")
Tabs.Visual:Toggle("Box", State.ESPBox, function(v) State.ESPBox = v end)
Tabs.Visual:Toggle("Name", State.ESPName, function(v) State.ESPName = v end)
Tabs.Visual:Toggle("Line", State.ESPLine, function(v) State.ESPLine = v end)
Tabs.Visual:Toggle("Health", State.ESPHealth, function(v) State.ESPHealth = v end)
Tabs.Visual:Toggle("Skeleton", State.ESPSkeleton, function(v) State.ESPSkeleton = v end)
Tabs.Visual:Toggle("Distance", State.ESPDistance, function(v) State.ESPDistance = v end)
Tabs.Visual:Toggle("Picture", State.ESPPicture, function(v) State.ESPPicture = v end)

Tabs.Visual:Section("ESP Color (RGB)")
Tabs.Visual:ColorPicker("ESP Color", State.ESPColor, function(c)
    State.ESPColor = c
end)
-- ==========================================
-- AIMBOT TAB
-- ==========================================
Tabs.Aimbot:Section("Aimbot Core")
Tabs.Aimbot:Toggle("Aimbot", State.Aimbot, function(v) State.Aimbot = v; if not v then LockedTarget = nil end end)
Tabs.Aimbot:Toggle("Team Check", State.TeamCheck, function(v) State.TeamCheck = v end)
Tabs.Aimbot:Toggle("Wall Check", State.WallCheck, function(v) State.WallCheck = v end)

Tabs.Aimbot:Section("Aimbot Mode")
Tabs.Aimbot:Combo("Mode Aimbot", {"360°", "FOV"}, State.AimbotMode, function(v) State.AimbotMode = v end)
Tabs.Aimbot:Combo("Mode Trigger", {"Fire (Snap)", "Camera"}, State.TriggerMode, function(v) State.TriggerMode = v end)
Tabs.Aimbot:Combo("Aim Target", {"Head", "Neck", "Chest"}, State.AimTarget, function(v) State.AimTarget = v end)

Tabs.Aimbot:Section("FOV Settings")
Tabs.Aimbot:Toggle("Aim FOV", State.ShowFOV, function(v) State.ShowFOV = v end)
Tabs.Aimbot:Slider("Size FOV", 10, 600, State.FOVSize, function(v) State.FOVSize = v; FOVRadius = v end)
Tabs.Aimbot:Toggle("Aim Line", State.AimLine, function(v) State.AimLine = v end)
Tabs.Aimbot:Slider("Aim Distance (m)", 50, 2000, State.AimDistance, function(v) State.AimDistance = v end)

-- ==========================================
-- PLAYER TAB
-- ==========================================
Tabs.Player:Section("Movement")
Tabs.Player:Toggle("Speed Run", State.SpeedRun, function(v) State.SpeedRun = v end)
Tabs.Player:Slider("Speed %", 100, 500, State.SpeedPercent, function(v) State.SpeedPercent = v end)
Tabs.Player:Toggle("Multi Jump", State.MultiJump, function(v) State.MultiJump = v end)
Tabs.Player:Toggle("Fly Hack (Hold Jump)", State.FlyHack, function(v) State.FlyHack = v end)

Tabs.Player:Section("Combat")
Tabs.Player:Toggle("Rapid Fire", State.RapidFire, function(v) State.RapidFire = v end)
Tabs.Player:Toggle("Unlimited Ammo", State.UnlimitedAmmo, function(v) State.UnlimitedAmmo = v end)

-- ==========================================
-- WORLD TAB
-- ==========================================
Tabs.World:Section("Environment")
Tabs.World:Combo("Clock Time", {"Default", "Pagi", "Siang", "Sore", "Malam"}, State.ClockTime, function(v)
    State.ClockTime = v
    local map = {
        ["Default"] = {t = 14, b = 2, amb = Color3.fromRGB(128,128,128), out = Color3.fromRGB(128,128,128)},
        ["Pagi"]    = {t = 6,  b = 1, amb = Color3.fromRGB(180,180,200), out = Color3.fromRGB(200,200,220)},
        ["Siang"]   = {t = 12, b = 2, amb = Color3.fromRGB(150,150,150), out = Color3.fromRGB(140,140,140)},
        ["Sore"]    = {t = 17, b = 2, amb = Color3.fromRGB(220,150,100), out = Color3.fromRGB(240,170,110)},
        ["Malam"]   = {t = 0,  b = 0, amb = Color3.fromRGB(20,20,40),    out = Color3.fromRGB(10,10,30)},
    }
    local cfg = map[v]
    if cfg then
        Lighting.ClockTime = cfg.t
        Lighting.Brightness = cfg.b
        Lighting.Ambient = cfg.amb
        Lighting.OutdoorAmbient = cfg.out
    end
end)
Tabs.World:Toggle("No Gravity", State.NoGravity, function(v)
    State.NoGravity = v
    workspace.Gravity = v and 0 or 196.2
end)

Tabs.World:Section("Teleport")
local playerNames = {}
local function refreshPlayers()
    playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playerNames, p.Name) end
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function() task.wait(0.2) refreshPlayers() end)

Tabs.World:List("Teleport To", playerNames, function(sel)
    if not sel then return end
    local target = Players:FindFirstChild(sel)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)
-- ==========================================
-- CONFIG TAB
-- ==========================================
local ConfigFile = "LiteHack_Ultimate.json"

Tabs.Config:Section("Appearance")
Tabs.Config:Combo("Theme", {"Dark", "Light"}, State.Theme, function(v)
    State.Theme = v
    if Gui.SetTheme then Gui:SetTheme(v) end
end)

Tabs.Config:Section("Save / Load")
Tabs.Config:Button("Save Config", function()
    if not writefile then return end
    local ok, enc = pcall(function() return HttpService:JSONEncode(State) end)
    if ok then
        pcall(function() writefile(ConfigFile, enc) end)
        Gui:Notify("Config saved!", 2)
    end
end)

Tabs.Config:Button("Load Config", function()
    if not (isfile and readfile and isfile(ConfigFile)) then
        Gui:Notify("No config file found.", 2)
        return
    end
    local ok, dec = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
    if ok and type(dec) == "table" then
        for k, v in pairs(dec) do
            if State[k] ~= nil then
                if typeof(v) == "Color3" then
                    State[k] = Color3.new(v.R, v.G, v.B)
                else
                    State[k] = v
                end
            end
        end
        FOVRadius = State.FOVSize
        workspace.Gravity = State.NoGravity and 0 or 196.2
        Gui:Notify("Config loaded!", 2)
    end
end)

-- ==========================================
-- FOV CIRCLE GUI
-- ==========================================
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "LH_FOV"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, FOVRadius*2, 0, FOVRadius*2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.4
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

local AimLineGui = Instance.new("Frame")
AimLineGui.AnchorPoint = Vector2.new(0, 0.5)
AimLineGui.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
AimLineGui.BorderSizePixel = 0
AimLineGui.Size = UDim2.new(0, 0, 0, 2)
AimLineGui.Visible = false
AimLineGui.ZIndex = 5
AimLineGui.Parent = FOVGui

-- ==========================================
-- ESP SYSTEM
-- ==========================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "LH_ESP"
ESPFolder.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local ActiveESP = {}

local function isEnemy(model)
    local plr = Players:GetPlayerFromCharacter(model)
    if not plr then return true end
    if plr.TeamColor and LocalPlayer.TeamColor and plr.TeamColor == LocalPlayer.TeamColor then
        return false
    end
    return true
end

local function getEntityList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local enemy = isEnemy(p.Character)
            if (enemy and State.ESPEnemy) or (not enemy and State.ESPTeam) then
                table.insert(list, p.Character)
            end
        end
    end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
            if obj:FindFirstChildOfClass("Humanoid") then table.insert(list, obj) end
        end
    end
    return list
end

local function createESP(model)
    local data = {}
    local col = State.ESPColor

    -- BOX
    local box = Instance.new("Highlight", ESPFolder)
    box.FillTransparency = 1
    box.OutlineTransparency = 0.3
    box.OutlineColor = col
    box.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    box.Adornee = model
    data.Highlight = box

    -- Billboard for name/distance/picture
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
    local bb = Instance.new("BillboardGui", ESPFolder)
    bb.Adornee = hrp
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 60)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
    bb.Enabled = true
    data.Billboard = bb

    -- Picture (round)
    local picFrame = Instance.new("ImageLabel", bb)
    picFrame.Size = UDim2.new(0, 40, 0, 40)
    picFrame.Position = UDim2.new(0.5, -20, 0, -55)
    picFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    picFrame.Image = "rbxassetid://0"
    picFrame.Visible = false
    picFrame.Name = "Pic"
    local pc = Instance.new("UICorner", picFrame); pc.CornerRadius = UDim.new(1, 0)
    local ps = Instance.new("UIStroke", picFrame); ps.Color = col; ps.Thickness = 2
    data.Picture = picFrame

    -- Name
    local nameL = Instance.new("TextLabel", bb)
    nameL.Size = UDim2.new(1, 0, 0, 18)
    nameL.Position = UDim2.new(0, 0, 0, -18)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3 = col
    nameL.TextStrokeTransparency = 0
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13
    nameL.Text = model.Name
    data.Name = nameL

    -- Distance
    local distL = Instance.new("TextLabel", bb)
    distL.Size = UDim2.new(1, 0, 0, 16)
    distL.Position = UDim2.new(0, 0, 1, 0)
    distL.BackgroundTransparency = 1
    distL.TextColor3 = col
    distL.TextStrokeTransparency = 0
    distL.Font = Enum.Font.Code
    distL.TextSize = 13
    distL.Text = "0m"
    data.Distance = distL

    -- Health bar
    local healthBg = Instance.new("Frame", bb)
    healthBg.Size = UDim2.new(0, 4, 0.6, 0)
    healthBg.Position = UDim2.new(1, 4, 0.2, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    healthBg.BorderSizePixel = 0
    healthBg.Name = "HealthBG"
    local hc = Instance.new("UICorner", healthBg); hc.CornerRadius = UDim.new(1, 0)
    local healthFill = Instance.new("Frame", healthBg)
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 1, 0)
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Name = "HealthFill"
    local hfc = Instance.new("UICorner", healthFill); hfc.CornerRadius = UDim.new(1, 0)
    data.HealthBG = healthBg
    data.HealthFill = healthFill

    -- Line (head top)
    local line = Instance.new("Frame", FOVGui)
    line.BackgroundColor3 = col
    line.BorderSizePixel = 0
    line.Size = UDim2.new(0, 1, 0, 1)
    line.ZIndex = 4
    line.Name = "ESPLine"
    data.Line = line

    return data
end

local function updateESPData(model, data)
    local hum = model:FindFirstChildOfClass("Humanoid")
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
    if not hum or not hrp then return end

    local col = State.ESPColor
    data.Highlight.OutlineColor = col
    data.Name.TextColor3 = col
    data.Distance.TextColor3 = col
    data.Line.BackgroundColor3 = col
    data.Picture.UIStroke.Color = col

    -- Box visibility
    data.Highlight.Enabled = State.ESPBox

    -- Name
    data.Name.Visible = State.ESPName
    data.Name.Text = model.Name

    -- Distance
    data.Distance.Visible = State.ESPDistance
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        local d = math.floor((myChar.HumanoidRootPart.Position - hrp.Position).Magnitude)
        data.Distance.Text = d .. "m"
    end

    -- Health
    if State.ESPHealth then
        data.HealthBG.Visible = true
        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        data.HealthFill.Size = UDim2.new(1, 0, hp, 0)
        local c
        if hp >= 0.7 then c = Color3.fromRGB(0, 255, 0)
        elseif hp >= 0.4 then c = Color3.fromRGB(255, 165, 0)
        else c = Color3.fromRGB(180, 0, 0) end
        data.HealthFill.BackgroundColor3 = c
    else
        data.HealthBG.Visible = false
    end

    -- Picture
    if State.ESPPicture then
        data.Picture.Visible = true
        local plr = Players:GetPlayerFromCharacter(model)
        if plr then
            pcall(function()
                local thumb = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                data.Picture.Image = thumb
            end)
        end
    else
        data.Picture.Visible = false
    end

    -- Line (from head to top screen)
    if State.ESPLine then
        local head = model:FindFirstChild("Head") or hrp
        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if onScreen then
            data.Line.Visible = true
            data.Line.Position = UDim2.new(0, pos.X, 0, pos.Y)
            data.Line.Size = UDim2.new(0, 1, 0, pos.Y - 20)
        else
            data.Line.Visible = false
        end
    else
        data.Line.Visible = false
    end

    data.Billboard.Enabled = State.ESPName or State.ESPDistance or State.ESPPicture or State.ESPHealth
end

RunService.RenderStepped:Connect(function()
    local entities = getEntityList()
    local seen = {}

    for _, model in pairs(entities) do
        local hum = model:FindFirstChildOfClass("Humanoid")
        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
        if model.Parent and hum and hum.Health > 0 and hrp then
            seen[model] = true
            if not ActiveESP[model] then
                ActiveESP[model] = createESP(model)
            end
            updateESPData(model, ActiveESP[model])
        end
    end

    for model, data in pairs(ActiveESP) do
        if not seen[model] or not model.Parent then
            if data.Highlight then data.Highlight:Destroy() end
            if data.Billboard then data.Billboard:Destroy() end
            if data.Line then data.Line:Destroy() end
            ActiveESP[model] = nil
        end
    end
end)

-- ==========================================
-- AIMBOT LOGIC
-- ==========================================
local function getTargetPart(char)
    if not char then return nil end
    if State.AimTarget == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif State.AimTarget == "Neck" then
        return char:FindFirstChild("Neck") or char:FindFirstChild("Head")
    elseif State.AimTarget == "Chest" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HumanoidRootPart")
end

local function isVisible(targetPart)
    if not targetPart then return false end
    if not State.WallCheck then return true end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local dir = (targetPart.Position - Camera.CFrame.Position).Unit * 5000
    local hit = workspace:Raycast(Camera.CFrame.Position, dir, rp)
    return hit and hit.Instance:IsDescendantOf(targetPart.Parent)
end

local function isEnemyChar(char)
    if not State.TeamCheck then return true end
    local p = Players:GetPlayerFromCharacter(char)
    if not p then return true end
    if p.TeamColor and LocalPlayer.TeamColor and p.TeamColor == LocalPlayer.TeamColor then
        return false
    end
    return true
end

local function getTarget()
    local closest, bestScore = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and isEnemyChar(char) then
                local tp = getTargetPart(char)
                if tp and isVisible(tp) then
                    local dist3D = (myPos - tp.Position).Magnitude
                    if dist3D <= State.AimDistance then
                        if State.AimbotMode == "FOV" then
                            local pos, onScreen = Camera:WorldToViewportPoint(tp.Position)
                            if onScreen then
                                local d2 = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                                if d2 <= FOVRadius and d2 < bestScore then
                                    bestScore = d2
                                    closest = char
                                end
                            end
                        else
                            if dist3D < bestScore then
                                bestScore = dist3D
                                closest = char
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- FOV circle
    if FOVFrame then
        FOVFrame.Size = UDim2.new(0, FOVRadius*2, 0, FOVRadius*2)
        FOVFrame.Visible = State.Aimbot and State.ShowFOV and State.AimbotMode == "FOV"
        FOVStroke.Color = State.ESPColor
    end

    if State.Aimbot then
        -- validate locked
        local valid = false
        if LockedTarget and LockedTarget.Parent then
            local hum = LockedTarget:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and isEnemyChar(LockedTarget) then
                local tp = getTargetPart(LockedTarget)
                if tp and isVisible(tp) then valid = true end
            end
        end
        if not valid then LockedTarget = getTarget() end

        if LockedTarget then
            local tp = getTargetPart(LockedTarget)
            if tp then
                if State.TriggerMode == "Fire (Snap)" then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tp.Position)
                else
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, tp.Position), 0.25)
                end

                -- Aim Line from center of FOV to target on screen
                if State.AimLine then
                    local pos, onScreen = Camera:WorldToViewportPoint(tp.Position)
                    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    if onScreen then
                        AimLineGui.Visible = true
                        local dx = pos.X - center.X
                        local dy = pos.Y - center.Y
                        local len = math.sqrt(dx*dx + dy*dy)
                        local ang = math.atan2(dy, dx)
                        AimLineGui.Position = UDim2.new(0, center.X, 0, center.Y)
                        AimLineGui.Size = UDim2.new(0, len, 0, 2)
                        AimLineGui.Rotation = math.deg(ang)
                        AimLineGui.BackgroundColor3 = State.ESPColor
                    else
                        AimLineGui.Visible = false
                    end
                else
                    AimLineGui.Visible = false
                end
            end
        else
            AimLineGui.Visible = false
        end
    else
        AimLineGui.Visible = false
    end
end)

-- ==========================================
-- PLAYER LOGIC
-- ==========================================
local jumpsLeft = 0

RunService.Stepped:Connect(function(_, dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Speed run
    if State.SpeedRun then
        hum.WalkSpeed = 16 * (State.SpeedPercent / 100)
    else
        if hum.WalkSpeed > 16 and hum.WalkSpeed ~= 0 and not State.SpeedRun then
            -- don't force unless feature was toggled off; handled in toggle
        end
    end

    -- Multi jump
    if State.MultiJump and hum:GetState() == Enum.HumanoidStateType.Freefall then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- Fly hack
    if State.FlyHack and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
    end
end)

-- Rapid Fire & Unlimited Ammo
local function applyGunMods(tool)
    if not tool then return end
    pcall(function()
        if State.UnlimitedAmmo then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                    local n = obj.Name:lower()
                    if n:find("ammo") or n:find("clip") or n:find("mag") then
                        obj.Value = 999999
                    end
                end
            end
            if tool:GetAttribute("Ammo") ~= nil then tool:SetAttribute("Ammo", 999999) end
            if tool:GetAttribute("TotalAmmo") ~= nil then tool:SetAttribute("TotalAmmo", 999999) end
        end
        if State.RapidFire then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                    local n = obj.Name:lower()
                    if n:find("fire") or n:find("rpm") or n:find("rate") then
                        obj.Value = 1000
                    end
                end
            end
            if tool:GetAttribute("FireRate") ~= nil then tool:SetAttribute("FireRate", 1000) end
            if tool:GetAttribute("RPM") ~= nil then tool:SetAttribute("RPM", 1000) end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if State.RapidFire or State.UnlimitedAmmo then
        local char = LocalPlayer.Character
        if char then
            for _, t in pairs(char:GetChildren()) do
                if t:IsA("Tool") then applyGunMods(t) end
            end
        end
        for _, v in pairs(Camera:GetChildren()) do
            if v:IsA("Model") then
                for _, t in pairs(v:GetChildren()) do
                    if t:IsA("Tool") then applyGunMods(t) end
                end
            end
        end
    end
end)

-- ==========================================
-- CLEANUP + STARTUP NOTIFY
-- ==========================================
Gui:Notify("Lite Hack Ultimate Loaded!", 4)

-- Support: multi jump reset
LocalPlayer.CharacterAdded:Connect(function()
    jumpsLeft = 0
end)
