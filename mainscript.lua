-- ============================================================
-- ULTIMATE MODS - IMGUI EDITION
-- Visual / Player / Aimbot / World / Config
-- ============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera
local CoreGui           = (gethui and gethui()) or game:GetService("CoreGui")

-- ============================================================
-- ANTI-CHEAT BYPASS (soft)
-- ============================================================
task.spawn(function()
    pcall(function()
        if setreadonly and getrenv then pcall(function() setreadonly(getrenv(), false) end) end
        if getconnections then
            pcall(function()
                for _, c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
            end)
        end
    end)
end)

-- ============================================================
-- LOAD IMGUI
-- ============================================================
local ImGui
local ok, err = pcall(function()
    ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImGui-Roblox/ImGui/main/ImGui.lua"))()
end)

if not ok or not ImGui then
    -- Fallback: alternative ImGui source
    pcall(function()
        ImGui = loadstring(game:HttpGet("https://lua-libraries.vercel.app/imgui.lua"))()
    end)
end

if not ImGui then
    warn("[Ultimate Mods] Gagal load ImGui, coba executor lain.")
    return
end

-- ============================================================
-- KONFIGURASI VARIABEL
-- ============================================================
local Config = {
    -- Visual
    ESPEnemy        = false,
    ESPTeam         = false,
    ESPColor        = Color3.fromRGB(255, 0, 0),
    ESPBox          = true,
    ESPName         = true,
    ESPLine         = false,
    ESPHealth       = true,
    ESPSkeleton     = false,
    ESPDistance     = true,
    ESPPicture      = false,

    -- Aimbot
    Aimbot          = false,
    TeamCheck       = true,
    WallCheck       = true,
    AimbotMode      = "FOV",           -- FOV / 360
    TriggerMode     = "Camera",        -- Camera / Fire(snap)
    ShowFOV         = true,
    FOVSize         = 150,
    AimLine         = false,
    AimTarget       = "Head",          -- Head / Neck / Chest
    AimDistance     = 500,             -- meter

    -- Player
    SpeedRun        = false,
    SpeedPercent    = 100,             -- %
    MultiJump       = false,
    FlyHack         = false,
    RapidFire       = false,
    UnlimitedAmmo   = false,

    -- World
    ClockTime       = "Day",           -- Morning / Day / Evening / Night
    NoGravity       = false,

    -- Config
    Theme           = "Dark"
}

-- ============================================================
-- HELPER: TIMEOFDAY
-- ============================================================
local function ApplyClockTime(opt)
    local times = {
        Morning = 6,
        Day     = 14,
        Evening = 18,
        Night   = 0
    }
    Lighting.ClockTime = times[opt] or 14
end

-- ============================================================
-- HELPER: IS ENEMY / TEAM
-- ============================================================
local function IsPlayerEnemy(plr)
    if plr == LocalPlayer then return false end
    if Config.TeamCheck and plr.Team and LocalPlayer.Team then
        return plr.Team ~= LocalPlayer.Team
    end
    return true
end

local function IsPlayerTeam(plr)
    if plr == LocalPlayer then return false end
    if plr.Team and LocalPlayer.Team then
        return plr.Team == LocalPlayer.Team
    end
    return false
end

-- ============================================================
-- HELPER: WALL CHECK
-- ============================================================
local function IsVisible(part)
    if not part then return false end
    if not Config.WallCheck then return true end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local dir = (part.Position - Camera.CFrame.Position)
    local result = workspace:Raycast(Camera.CFrame.Position, dir, rp)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

-- ============================================================
-- HELPER: GET TARGET PART
-- ============================================================
local function GetTargetPart(char)
    if not char then return nil end
    if Config.AimTarget == "Head" then
        return char:FindFirstChild("Head")
    elseif Config.AimTarget == "Neck" then
        return char:FindFirstChild("Neck") or char:FindFirstChild("Head")
    else
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    end
end

-- ============================================================
-- ESP SYSTEM (DRAWING BASED - tebal & lengkap)
-- ============================================================
local ESPCache = {}       -- [player] = { ... }

local function GetOrCreateDrawing()
    return {
        Box       = Drawing.new("Square"),
        Name      = Drawing.new("Text"),
        Distance  = Drawing.new("Text"),
        Line      = Drawing.new("Line"),
        HealthBg  = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Picture   = Drawing.new("Image"),
        HeadDot   = Drawing.new("Circle"),
    }
end

local function ApplyDrawingDefaults(d)
    -- Box
    d.Box.Thickness = 2
    d.Box.Filled    = false
    d.Box.Transparency = 1
    d.Box.Visible   = false

    -- Name (di atas box)
    d.Name.Size     = 14
    d.Name.Center   = true
    d.Name.Outline  = true
    d.Name.Font     = 2
    d.Name.Visible  = false

    -- Distance (di bawah box)
    d.Distance.Size    = 13
    d.Distance.Center  = true
    d.Distance.Outline = true
    d.Distance.Font    = 2
    d.Distance.Visible = false

    -- Line (dari kepala ke bawah layar / titik pusat)
    d.Line.Thickness    = 2
    d.Line.Visible      = false
    d.Line.Transparency = 1

    -- Health
    d.HealthBg.Filled   = true
    d.HealthBg.Visible  = false
    d.HealthBg.Color    = Color3.fromRGB(30, 30, 30)
    d.HealthBar.Filled  = true
    d.HealthBar.Visible = false

    -- Picture
    d.Picture.Visible = false
    d.Picture.Transparency = 1
    d.Picture.Size    = Vector2.new(40, 40)
    d.Picture.Rounding = 100  -- bulat

    -- Head dot
    d.HeadDot.Radius    = 3
    d.HeadDot.Filled    = true
    d.HeadDot.Thickness = 2
    d.HeadDot.Visible   = false
end

-- Ambil thumbnail player (bulat)
local ThumbCache = {}
local function GetThumb(plr)
    if ThumbCache[plr.UserId] then return ThumbCache[plr.UserId] end
    local url = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(plr.UserId)
    ThumbCache[plr.UserId] = url
    return url
end

-- Health color
local function HealthColor(pct)
    if pct >= 0.7 then
        return Color3.fromRGB(0, 255, 0)
    elseif pct >= 0.4 then
        return Color3.fromRGB(255, 165, 0)
    else
        return Color3.fromRGB(180, 0, 0)
    end
end

-- Skeleton (garis antar joint sederhana)
local SkeletonParts = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"}
}

local function UpdateESPForPlayer(plr)
    local cache = ESPCache[plr]
    local char = plr.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local head = char and char:FindFirstChild("Head")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    if not (char and hrp and head and hum and hum.Health > 0) then
        if cache then
            for _, obj in pairs(cache) do
                if typeof(obj) == "table" then
                    for _, d in pairs(obj) do if d and d.Visible ~= nil then d.Visible = false end end
                elseif obj and obj.Visible ~= nil then
                    obj.Visible = false
                end
            end
        end
        return
    end

    -- Filter aktif
    local isEnemy = IsPlayerEnemy(plr)
    local isTeam  = IsPlayerTeam(plr)
    local active  = (Config.ESPEnemy and isEnemy) or (Config.ESPTeam and isTeam)
    if not active then
        if cache then
            for _, obj in pairs(cache) do
                if typeof(obj) == "table" then
                    for _, d in pairs(obj) do if d and d.Visible ~= nil then d.Visible = false end end
                elseif obj and obj.Visible ~= nil then
                    obj.Visible = false
                end
            end
        end
        return
    end

    -- Get viewport positions
    local headPos, headVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
    local rootPos, rootVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
    local topPos, topVis   = Camera:WorldToViewportPoint((head.Position + Vector3.new(0, 3, 0)))
    local botPos, botVis   = Camera:WorldToViewportPoint((hrp.Position - Vector3.new(0, 3.2, 0)))

    -- Kalau offscreen, matikan
    if not (headVis and rootVis) then
        if cache then
            for _, obj in pairs(cache) do
                if typeof(obj) == "table" then
                    for _, d in pairs(obj) do if d and d.Visible ~= nil then d.Visible = false end end
                elseif obj and obj.Visible ~= nil then
                    obj.Visible = false
                end
            end
        end
        return
    end

    -- Setup drawing kalau belum ada
    if not cache then
        cache = GetOrCreateDrawing()
        ApplyDrawingDefaults(cache)
        ESPCache[plr] = cache
    end

    -- Hitung box
    local boxTop    = Vector2.new(topPos.X, topPos.Y)
    local boxBottom = Vector2.new(botPos.X, botPos.Y)
    local boxHeight = math.abs(boxBottom.Y - boxTop.Y)
    local boxWidth  = boxHeight * 0.55
    local boxX      = boxTop.X - boxWidth / 2
    local boxY      = boxTop.Y
    local boxPos    = Vector2.new(boxX, boxY)
    local boxSize   = Vector2.new(boxWidth, boxHeight)

    local color = Config.ESPColor

    -- BOX
    if Config.ESPBox then
        cache.Box.Visible = true
        cache.Box.Color   = color
        cache.Box.Position = boxPos
        cache.Box.Size     = boxSize
        cache.Box.Thickness = 2
    else
        cache.Box.Visible = false
    end

    -- NAME (di atas box)
    if Config.ESPName then
        cache.Name.Visible = true
        cache.Name.Color   = color
        cache.Name.Text    = plr.Name
        cache.Name.Position = Vector2.new(boxPos.X + boxWidth / 2, boxPos.Y - 18)
    else
        cache.Name.Visible = false
    end

    -- DISTANCE (di bawah box)
    if Config.ESPDistance then
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
        cache.Distance.Visible = true
        cache.Distance.Color   = color
        cache.Distance.Text    = dist .. "m"
        cache.Distance.Position = Vector2.new(boxPos.X + boxWidth / 2, boxPos.Y + boxHeight + 2)
    else
        cache.Distance.Visible = false
    end

    -- LINE (dari kepala ke bawah layar, sesuai request "di kepala")
    if Config.ESPLine then
        cache.Line.Visible = true
        cache.Line.Color   = color
        cache.Line.From    = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        cache.Line.To      = Vector2.new(headPos.X, headPos.Y)
    else
        cache.Line.Visible = false
    end

    -- HEALTH BAR (kanan box)
    if Config.ESPHealth then
        local pct = hum.Health / hum.MaxHealth
        local hbW = 4
        local hbX = boxPos.X + boxWidth + 4
        cache.HealthBg.Visible = true
        cache.HealthBg.Color   = Color3.fromRGB(20, 20, 20)
        cache.HealthBg.Position = Vector2.new(hbX, boxPos.Y)
        cache.HealthBg.Size     = Vector2.new(hbW, boxHeight)

        cache.HealthBar.Visible = true
        cache.HealthBar.Color   = HealthColor(pct)
        local fillH = boxHeight * pct
        cache.HealthBar.Position = Vector2.new(hbX, boxPos.Y + (boxHeight - fillH))
        cache.HealthBar.Size     = Vector2.new(hbW, fillH)
    else
        cache.HealthBg.Visible  = false
        cache.HealthBar.Visible = false
    end

    -- SKELETON
    if Config.ESPSkeleton then
        if not cache.Skeleton then
            cache.Skeleton = {}
            for i = 1, #SkeletonParts do
                cache.Skeleton[i] = Drawing.new("Line")
                cache.Skeleton[i].Thickness = 1.5
            end
        end
        for i, pair in ipairs(SkeletonParts) do
            local a = char:FindFirstChild(pair[1])
            local b = char:FindFirstChild(pair[2])
            local ln = cache.Skeleton[i]
            if a and b then
                local pa, va = Camera:WorldToViewportPoint(a.Position)
                local pb, vb = Camera:WorldToViewportPoint(b.Position)
                if va and vb then
                    ln.Visible = true
                    ln.Color   = color
                    ln.From    = Vector2.new(pa.X, pa.Y)
                    ln.To      = Vector2.new(pb.X, pb.Y)
                else
                    ln.Visible = false
                end
            else
                ln.Visible = false
            end
        end
    elseif cache.Skeleton then
        for _, ln in ipairs(cache.Skeleton) do ln.Visible = false end
    end

    -- PICTURE (di atas kepala, bulat, ada spasi)
    if Config.ESPPicture then
        cache.Picture.Visible = true
        local url = GetThumb(plr)
        pcall(function()
            if cache.Picture.Image ~= url then
                cache.Picture.Image = url
            end
        end)
        cache.Picture.Size     = Vector2.new(36, 36)
        cache.Picture.Position = Vector2.new(headPos.X - 18, headPos.Y - 60)
    else
        cache.Picture.Visible = false
    end
end

-- Bersihkan cache kalau player keluar
Players.PlayerRemoving:Connect(function(plr)
    local c = ESPCache[plr]
    if c then
        for _, obj in pairs(c) do
            if typeof(obj) == "table" then
                for _, d in pairs(obj) do pcall(function() d:Remove() end) end
            elseif obj and obj.Remove then
                pcall(function() obj:Remove() end)
            end
        end
        ESPCache[plr] = nil
    end
end)

-- Render loop ESP
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            pcall(UpdateESPForPlayer, plr)
        end
    end
end)

-- ============================================================
-- AIMBOT SYSTEM
-- ============================================================
local LockedTarget = nil
local FOVCircle, AimLine

-- FOV circle & aim line drawings
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides  = 60
FOVCircle.Filled    = false
FOVCircle.Color     = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Visible   = false

AimLine = Drawing.new("Line")
AimLine.Thickness = 1.5
AimLine.Color     = Color3.fromRGB(255, 100, 100)
AimLine.Visible   = false

local function GetClosestTarget()
    local closest, shortestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local okTeam = (not Config.TeamCheck) or IsPlayerEnemy(plr)
            if okTeam then
                local char = plr.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                local part = GetTargetPart(char)
                if hum and hum.Health > 0 and part then
                    local dist3D = (myHrp.Position - part.Position).Magnitude
                    if dist3D <= Config.AimDistance then
                        if IsVisible(part) then
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen or Config.AimbotMode == "360" then
                                local dist2D = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                                if Config.AimbotMode == "360" or dist2D <= Config.FOVSize then
                                    if dist3D < shortestDist then
                                        shortestDist = dist3D
                                        closest = plr
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- FOV & aim line rendering
RunService.RenderStepped:Connect(function()
    -- FOV circle
    if Config.Aimbot and Config.ShowFOV then
        FOVCircle.Visible  = true
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius   = Config.FOVSize
    else
        FOVCircle.Visible = false
    end

    -- Aim line
    if Config.Aimbot and Config.AimLine and LockedTarget and LockedTarget.Character then
        local part = GetTargetPart(LockedTarget.Character)
        if part then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                AimLine.Visible = true
                AimLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                AimLine.To   = Vector2.new(pos.X, pos.Y)
            else
                AimLine.Visible = false
            end
        else
            AimLine.Visible = false
        end
    else
        AimLine.Visible = false
    end

    -- Aimbot main logic
    if Config.Aimbot then
        local target = GetClosestTarget()
        LockedTarget = target

        if target and target.Character then
            local part = GetTargetPart(target.Character)
            if part and part.Parent then
                if Config.TriggerMode == "Camera" then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                else -- Fire (snap)
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                end
            end
        end
    end
end)

-- Trigger mode "Fire" — klik untuk snap
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Config.Aimbot and Config.TriggerMode == "Fire" and LockedTarget and LockedTarget.Character then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local part = GetTargetPart(LockedTarget.Character)
            if part then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

-- ============================================================
-- PLAYER HACKS
-- ============================================================
-- Base WalkSpeed = 16
local MultiJumpCount = 0
local FLY_BV

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Speed
    if Config.SpeedRun then
        hum.WalkSpeed = 16 * (Config.SpeedPercent / 100)
    else
        -- biarkan default (jangan paksa)
    end

    -- Multi Jump
    if Config.MultiJump then
        hum.UseJumpPower = true
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) and MultiJumpCount < 3 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                MultiJumpCount = MultiJumpCount + 1
            end
        end
    end
    if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        MultiJumpCount = 0
    end

    -- Fly Hack
    if Config.FlyHack then
        if not FLY_BV or FLY_BV.Parent ~= hrp then
            if FLY_BV then FLY_BV:Destroy() end
            FLY_BV = Instance.new("BodyVelocity")
            FLY_BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            FLY_BV.Velocity = Vector3.zero
            FLY_BV.Parent = hrp
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            FLY_BV.Velocity = Vector3.new(0, 50, 0)
        else
            FLY_BV.Velocity = Vector3.zero
        end
    else
        if FLY_BV then FLY_BV:Destroy(); FLY_BV = nil end
    end

    -- No Gravity
    if Config.NoGravity and hrp then
        workspace.Gravity = 0
    end
end)

-- Rapid Fire & Unlimited Ammo (loop scan tool)
task.spawn(function()
    while task.wait(0.2) do
        if Config.RapidFire or Config.UnlimitedAmmo then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        if Config.UnlimitedAmmo then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                                    local n = obj.Name:lower()
                                    if n:find("ammo") or n:find("clip") or n:find("mag") then
                                        obj.Value = 9999
                                    end
                                end
                            end
                        end
                        if Config.RapidFire then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("NumberValue") then
                                    local n = obj.Name:lower()
                                    if n:find("firerate") or n:find("cooldown") then
                                        obj.Value = 0.01
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- WORLD: TELEPORT LIST
-- ============================================================
local function TeleportTo(plr)
    if not plr or not plr.Character then return end
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if myHrp and targetHrp then
        myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
    end
end

-- ============================================================
-- THEME & FLOATING ICON (SKULL GLOW)
-- ============================================================
local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "UltimateMods_Floating"
FloatingGui.ResetOnSpawn = false
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FloatingGui.Parent = CoreGui

local SkullBtn = Instance.new("TextButton")
SkullBtn.Size = UDim2.new(0, 56, 0, 56)
SkullBtn.Position = UDim2.new(0, 20, 0.5, -28)
SkullBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SkullBtn.BackgroundTransparency = 0.15
SkullBtn.Text = "💀"
SkullBtn.TextSize = 30
SkullBtn.Font = Enum.Font.GothamBlack
SkullBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
SkullBtn.AutoButtonColor = false
SkullBtn.Draggable = true
SkullBtn.Parent = FloatingGui

local SkullCorner = Instance.new("UICorner")
SkullCorner.CornerRadius = UDim.new(0.5, 0)
SkullCorner.Parent = SkullBtn

local SkullStroke = Instance.new("UIStroke")
SkullStroke.Thickness = 2
SkullStroke.Color = Color3.fromRGB(255, 60, 60)
SkullStroke.Transparency = 0.2
SkullStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SkullStroke.Parent = SkullBtn

-- Glow effect
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 20, 1, 20)
Glow.Position = UDim2.new(0, -10, 0, -10)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
Glow.ImageTransparency = 0.4
Glow.ZIndex = 0
Glow.Parent = SkullBtn

-- Pulsing glow
task.spawn(function()
    while task.wait(0.05) do
        local t = tick()
        local a = 0.4 + math.sin(t * 3) * 0.3
        Glow.ImageTransparency = a
        SkullStroke.Transparency = 0.2 + math.sin(t * 3) * 0.3
    end
end)

-- ============================================================
-- IMGUI WINDOW SETUP
-- ============================================================
ImGui.Style:SetTheme(Config.Theme)   -- Dark / Light

local Window = ImGui:CreateWindow({
    Title = "💀 Ultimate Mods",
    Size = UDim2.new(0, 520, 0, 340),  -- compact
    Position = UDim2.new(0.5, -260, 0.5, -170),
    Theme = Config.Theme,
    ToggleKey = Enum.KeyCode.LeftControl,
    FloatingIcon = SkullBtn
})

-- Sembunyikan/tampilkan window via skull
local windowVisible = true
SkullBtn.MouseButton1Click:Connect(function()
    windowVisible = not windowVisible
    if Window.SetVisible then
        Window:SetVisible(windowVisible)
    elseif Window.Toggle then
        Window:Toggle()
    end
end)

-- ============================================================
-- TAB 1: VISUAL
-- ============================================================
local TabVisual = Window:AddTab("Visual")

TabVisual:AddToggle("ESP Enemy", Config.ESPEnemy, function(v) Config.ESPEnemy = v end)
TabVisual:AddToggle("ESP Team",  Config.ESPTeam,  function(v) Config.ESPTeam  = v end)

-- Widget warna RGB
local colorSet = {R = 255, G = 0, B = 0}
TabVisual:AddColorPicker("Warna ESP (RGB)", Config.ESPColor, function(c)
    Config.ESPColor = c
end)

TabVisual:AddCheckbox("Box",      Config.ESPBox,      function(v) Config.ESPBox      = v end)
TabVisual:AddCheckbox("Name",     Config.ESPName,     function(v) Config.ESPName     = v end)
TabVisual:AddCheckbox("Line",     Config.ESPLine,     function(v) Config.ESPLine     = v end)
TabVisual:AddCheckbox("Health",   Config.ESPHealth,   function(v) Config.ESPHealth   = v end)
TabVisual:AddCheckbox("Skeleton", Config.ESPSkeleton, function(v) Config.ESPSkeleton = v end)
TabVisual:AddCheckbox("Distance", Config.ESPDistance, function(v) Config.ESPDistance = v end)
TabVisual:AddCheckbox("Picture",  Config.ESPPicture,  function(v) Config.ESPPicture  = v end)

-- ============================================================
-- TAB 2: AIMBOT
-- ============================================================
local TabAimbot = Window:AddTab("Aimbot")

TabAimbot:AddToggle("Aimbot",     Config.Aimbot,     function(v) Config.Aimbot     = v end)
TabAimbot:AddToggle("Team Check", Config.TeamCheck,  function(v) Config.TeamCheck  = v end)
TabAimbot:AddToggle("Wall Check", Config.WallCheck,  function(v) Config.WallCheck  = v end)

TabAimbot:AddDropdown("Mode Aimbot", {"FOV", "360"}, Config.AimbotMode, function(v)
    Config.AimbotMode = v
end)
TabAimbot:AddDropdown("Mode Trigger", {"Camera", "Fire(snap)"}, Config.TriggerMode, function(v)
    Config.TriggerMode = v
end)

TabAimbot:AddToggle("Aim FOV (tampilkan lingkaran)", Config.ShowFOV, function(v) Config.ShowFOV = v end)
TabAimbot:AddSlider("Size FOV", 10, 600, Config.FOVSize, function(v) Config.FOVSize = v end)
TabAimbot:AddToggle("Aim Line",  Config.AimLine, function(v) Config.AimLine = v end)

TabAimbot:AddDropdown("Aim Target", {"Head", "Neck", "Chest"}, Config.AimTarget, function(v)
    Config.AimTarget = v
end)

TabAimbot:AddSlider("Aim Distance (m)", 50, 2000, Config.AimDistance, function(v)
    Config.AimDistance = v
end)

-- ============================================================
-- TAB 3: PLAYER
-- ============================================================
local TabPlayer = Window:AddTab("Player")

TabPlayer:AddToggle("Speed Run", Config.SpeedRun, function(v) Config.SpeedRun = v end)
TabPlayer:AddSlider("Speed (%)", 50, 500, Config.SpeedPercent, function(v)
    Config.SpeedPercent = v
end)

TabPlayer:AddToggle("Multi Jump",     Config.MultiJump,     function(v) Config.MultiJump     = v end)
TabPlayer:AddToggle("Fly Hack",       Config.FlyHack,       function(v) Config.FlyHack       = v end)
TabPlayer:AddToggle("Rapid Fire",     Config.RapidFire,     function(v) Config.RapidFire     = v end)
TabPlayer:AddToggle("Unlimited Ammo", Config.UnlimitedAmmo, function(v) Config.UnlimitedAmmo = v end)

-- ============================================================
-- TAB 4: WORLD
-- ============================================================
local TabWorld = Window:AddTab("World")

TabWorld:AddDropdown("Clock Time", {"Morning", "Day", "Evening", "Night"}, Config.ClockTime, function(v)
    Config.ClockTime = v
    ApplyClockTime(v)
end)

TabWorld:AddToggle("No Gravity", Config.NoGravity, function(v)
    Config.NoGravity = v
    workspace.Gravity = v and 0 or 196.2
end)

-- List box teleport — pakai dropdown nama player
local playerNames = {}
local function RefreshPlayerList()
    playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
end
RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)

local teleportSel = nil
TabWorld:AddDropdown("Teleport To Player", playerNames, nil, function(v)
    teleportSel = v
end)
TabWorld:AddButton("Teleport", function()
    if teleportSel then
        local plr = Players:FindFirstChild(teleportSel)
        if plr then TeleportTo(plr) end
    end
end)

-- ============================================================
-- TAB 5: CONFIG
-- ============================================================
local TabConfig = Window:AddTab("Config")

TabConfig:AddDropdown("Theme", {"Dark", "Light"}, Config.Theme, function(v)
    Config.Theme = v
    ImGui.Style:SetTheme(v)
end)

local ConfigFile = "UltimateMods_Config.json"

TabConfig:AddButton("💾 Save Config", function()
    local data = HttpService:JSONEncode(Config)
    if writefile then
        pcall(function() writefile(ConfigFile, data) end)
        ImGui:Notify("Config", "Berhasil disimpan ke " .. ConfigFile)
    else
        ImGui:Notify("Config", "Executor tidak support writefile")
    end
end)

TabConfig:AddButton("📂 Load Config", function()
    if isfile and isfile(ConfigFile) then
        local ok, content = pcall(readfile, ConfigFile)
        if ok and content then
            local decoded = HttpService:JSONDecode(content)
            for k, v in pairs(decoded) do
                Config[k] = v
            end
            -- Re-apply world
            ApplyClockTime(Config.ClockTime)
            workspace.Gravity = Config.NoGravity and 0 or 196.2
            ImGui.Style:SetTheme(Config.Theme)
            ImGui:Notify("Config", "Config dimuat!")
        end
    else
        ImGui:Notify("Config", "File config tidak ditemukan")
    end
end)

-- ============================================================
-- CLEANUP
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
    if FLY_BV then FLY_BV:Destroy(); FLY_BV = nil end
    MultiJumpCount = 0
end)

-- ============================================================
-- NOTIFIKASI START
-- ============================================================
pcall(function()
    ImGui:Notify("💀 Ultimate Mods", "Script loaded successfully!")
end)

print("[Ultimate Mods] Loaded.")
