-- ============================================================
-- LITE HACK + ULTIMATE MODS | WindUI Edition
-- Bubble 1/4 : Services + Bypass + UI Framework
-- ============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local ScriptContext     = game:GetService("ScriptContext")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT (COPY UTUH DARI KODEMU)
-- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then pcall(function() setreadonly(getrenv(), false); setreadonly(getreg(), false); setreadonly(getgc(), false) end) end
        if make_writeable then pcall(function() make_writeable(getreg()) end) end
        if detour_function then detour_function = function(...) return true end end
        if getconnections then
            pcall(function()
                for _, connection in ipairs(getconnections(ScriptContext.Error)) do
                    connection:Disable()
                end
            end)
        end
        if getcallingscript then pcall(function() getcallingscript = function() return nil end end) end
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

local Camera = workspace.CurrentCamera
if Camera.ViewportSize.Y > Camera.ViewportSize.X then
    repeat task.wait(0.5) until Camera.ViewportSize.X > Camera.ViewportSize.Y
    task.wait(1)
end

-- ==========================================
-- LOAD WINDUI
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main.lua"))()
WindUI:SetTheme("Dark")

-- ==========================================
-- FLOATING SKULL (GLOWUP)
-- ==========================================
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

local SkullGui = Instance.new("ScreenGui")
SkullGui.Name = "LH_SkullToggle"
SkullGui.ResetOnSpawn = false
SkullGui.IgnoreGuiInset = true
SkullGui.Parent = CoreGui

local SkullBtn = Instance.new("TextButton")
SkullBtn.Size = UDim2.fromOffset(54, 54)
SkullBtn.Position = UDim2.new(0, 20, 0.5, -27)
SkullBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
SkullBtn.BackgroundTransparency = 0.08
SkullBtn.Text = "💀"
SkullBtn.TextSize = 30
SkullBtn.Font = Enum.Font.GothamBold
SkullBtn.TextColor3 = Color3.fromRGB(200, 0, 255)
SkullBtn.AutoButtonColor = false
SkullBtn.Active = true
SkullBtn.Draggable = true
SkullBtn.Parent = SkullGui

local SkullCorner = Instance.new("UICorner", SkullBtn)
SkullCorner.CornerRadius = UDim.new(1, 0)

local SkullStroke = Instance.new("UIStroke", SkullBtn)
SkullStroke.Color = Color3.fromRGB(200, 0, 255)
SkullStroke.Thickness = 2.5
SkullStroke.Transparency = 0.15

-- glow pulse
task.spawn(function()
    while SkullBtn.Parent do
        TweenService:Create(SkullStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.75, Thickness = 1.5}):Play()
        task.wait(1.3)
        TweenService:Create(SkullStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1, Thickness = 3}):Play()
        task.wait(1.3)
    end
end)

-- ==========================================
-- WINDOW (compact, rounded, semi-transparan)
-- ==========================================
local Window = WindUI:CreateWindow({
    Title = "💀 Lite Hack + Ultimate Mods",
    Icon = "skull",
    Author = "Universal",
    Folder = "LiteHack",
    Size = UDim2.fromOffset(560, 380),
    Transparent = true,
    Theme = "Dark",
    Resizable = false,
    SideBarWidth = 0,
    HideSearchBar = true,
    HasOutline = true,
})

-- hide built-in toggle button, pakai floating skull custom
pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

-- ==========================================
-- 5 TAB HEADER (wrapped scroll horizontal otomatis)
-- ==========================================
local TabVisual = Window:Tab({ Title = "Visual", Icon = "eye" })
local TabPlayer = Window:Tab({ Title = "Player", Icon = "user" })
local TabAim    = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local TabWorld  = Window:Tab({ Title = "World", Icon = "globe" })
local TabConfig = Window:Tab({ Title = "Config", Icon = "settings" })

-- ==========================================
-- GLOBAL STATE (semua variabel dari kodemu + tambahan baru)
-- ==========================================
local State = {
    -- Anti-Admin (dari kodemu)
    AntiAdminAktif = false,
    -- ESP
    EnemyESP = false, TeamESP = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    ESP_Box = true, ESP_Name = true, ESP_Line = true,
    ESP_Health = true, ESP_Skeleton = false,
    ESP_Distance = true, ESP_Picture = false,
    -- Aimbot (dari kodemu + tambahan)
    AimbotAktif = false,
    TeamCheck = true, WallCheck = true,
    AimMode = "FOV",
    TriggerMode = "Camera",
    AimFOV = true, FOVSize = 150, AimLine = true,
    AimTargetMode = "Head", AimDistance = 500,
    AimbotSmoothness = 15,
    -- Player (dari kodemu)
    SpeedAktif = false, SpeedPercent = 100,
    MultiJump = false, FlyHack = false,
    AntiFallDamageAktif = false,
    JumpAktif = false,
    CustomJump = 100,
    -- Gun (dari kodemu)
    GunModsAktif = false,
    CustomFireRate = 800,
    -- World
    ClockTime = "Noon",
    NoGravity = false,
    TeleportTarget = nil,
    -- Config
    Theme = "Dark",
}

-- FOV frame dari kodemu (kita tetap pakai, cuma dipindah ke luar Rayfield)
local FOVGui, FOVFrame
pcall(function()
    local TargetParent = CoreGui
    FOVGui = Instance.new("ScreenGui")
    FOVGui.Name = "Universal_FOV_System"
    FOVGui.Parent = TargetParent
    FOVGui.IgnoreGuiInset = true

    FOVFrame = Instance.new("Frame")
    FOVFrame.Parent = FOVGui
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVFrame.Size = UDim2.new(0, State.FOVSize * 2, 0, State.FOVSize * 2)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.Visible = false

    local FOVStroke = Instance.new("UIStroke")
    FOVStroke.Parent = FOVFrame
    FOVStroke.Color = Color3.fromRGB(255, 255, 255)
    FOVStroke.Thickness = 1.5
    FOVStroke.Transparency = 0.5

    local FOVCorner = Instance.new("UICorner")
    FOVCorner.Parent = FOVFrame
    FOVCorner.CornerRadius = UDim.new(1, 0)
end)

-- ==========================================
-- ANTI-ADMIN (dari kodemu, notifikasi pakai WindUI)
-- ==========================================
local function CheckIfAdmin(p)
    if p == LocalPlayer then return false end
    local nameRaw = string.upper(p.Name .. " " .. p.DisplayName)
    if string.find(nameRaw, "%[GM%]") or string.find(nameRaw, "%[MOD%]")
        or string.find(nameRaw, "GAME MASTER") or string.find(nameRaw, "MODERATOR")
        or string.find(nameRaw, "DEWAKASAPUTRA") or string.find(nameRaw, "DEWA PROJECT") then
        return true
    end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        for _, stat in pairs(ls:GetChildren()) do
            local statValue = string.upper(tostring(stat.Value))
            if statValue == "GM" or statValue == "MOD" or statValue == "GAME MASTER" or statValue == "MODERATOR" then
                return true
            end
        end
    end
    return false
end

local function SendAdminWarning(p)
    pcall(function()
        WindUI:Notify({
            Title = "⚠️ GM TERDETEKSI!",
            Content = "Admin/Moderator ["..p.Name.."] ada di room ini!",
            Duration = 8,
            Icon = "alert-triangle",
        })
    end)
end

Players.PlayerAdded:Connect(function(p)
    if State.AntiAdminAktif then
        task.wait(1)
        if CheckIfAdmin(p) then SendAdminWarning(p) end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if State.AntiAdminAktif then
            for _, p in pairs(Players:GetPlayers()) do
                if CheckIfAdmin(p) then SendAdminWarning(p) end
            end
        end
    end
end)

-- ==========================================
-- FLAG UNTUK BUBBLE BERIKUTNYA
-- (dipakai bubble 2,3,4 biar akses variabel State, Tab, dll)
-- ==========================================
_G.LH_Bubble1 = {
    State = State,
    TabVisual = TabVisual, TabPlayer = TabPlayer, TabAim = TabAim,
    TabWorld = TabWorld, TabConfig = TabConfig,
    SkullBtn = SkullBtn, FOVFrame = FOVFrame,
    Camera = Camera, WindUI = WindUI,
    CoreGui = CoreGui,
    Players = Players, RunService = RunService, LocalPlayer = LocalPlayer,
    UserInputService = UserInputService, Lighting = Lighting,
    HttpService = HttpService,
    CheckIfAdmin = CheckIfAdmin, SendAdminWarning = SendAdminWarning,
}
-- ============================================================
-- LITE HACK + ULTIMATE MODS | WindUI Edition
-- Bubble 2/4 : Tab Visual (ESP)
-- ============================================================

local B1          = _G.LH_Bubble1
local State       = B1.State
local TabVisual   = B1.TabVisual
local WindUI      = B1.WindUI
local Players     = B1.Players
local RunService  = B1.RunService
local LocalPlayer = B1.LocalPlayer
local Camera      = B1.Camera
local CoreGui     = B1.CoreGui

-- ==========================================
-- SECTION: ESP FILTER
-- ==========================================
local VSec1 = TabVisual:Section({ Title = "ESP Filter" })

VSec1:Toggle({
    Title = "Enemy ESP",
    Desc = "Tampilkan ESP untuk semua player yang BUKAN team kamu",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.EnemyESP = v end,
})

VSec1:Toggle({
    Title = "Team ESP",
    Desc = "Tampilkan ESP untuk semua player di TEAM kamu",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.TeamESP = v end,
})

-- ==========================================
-- SECTION: ESP COLOR (RGB PICKER)
-- ==========================================
local VSec2 = TabVisual:Section({ Title = "ESP Color (RGB)" })

VSec2:Colorpicker({
    Title = "ESP Color",
    Desc = "Warna yang sama untuk semua elemen ESP",
    Default = State.ESPColor,
    Transparency = 0,
    Callback = function(color)
        State.ESPColor = color
        if refreshESPColor then refreshESPColor() end
    end,
})

-- ==========================================
-- SECTION: ESP ELEMENTS (7 CHECKBOX)
-- ==========================================
local VSec3 = TabVisual:Section({ Title = "ESP Elements" })

VSec3:Toggle({
    Title = "Box",
    Desc = "Kotak persegi mengelilingi player",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.ESP_Box = v end,
})

VSec3:Toggle({
    Title = "Name",
    Desc = "Nama player di atas box",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.ESP_Name = v end,
})

VSec3:Toggle({
    Title = "Line",
    Desc = "Garis dari atas layar ke kepala target (tebal)",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.ESP_Line = v end,
})

VSec3:Toggle({
    Title = "Health",
    Desc = "Bar HP di samping kanan box (warna dinamis)",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.ESP_Health = v end,
})

VSec3:Toggle({
    Title = "Skeleton",
    Desc = "Garis tulang R15/R6",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.ESP_Skeleton = v end,
})

VSec3:Toggle({
    Title = "Distance",
    Desc = "Jarak dalam meter di bawah box",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.ESP_Distance = v end,
})

VSec3:Toggle({
    Title = "Picture",
    Desc = "Avatar bulat player di atas kepala (ada spasi)",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.ESP_Picture = v end,
})

-- ==========================================
-- ESP RENDER ENGINE (Drawing API + BillboardGui untuk picture)
-- ==========================================
local DrawGui = Instance.new("ScreenGui")
DrawGui.Name = "LH_ESP_Pictures"
DrawGui.ResetOnSpawn = false
DrawGui.IgnoreGuiInset = true
DrawGui.Parent = CoreGui

local espData    = {}   -- [model] = { box, name, dist, line, hbBG, hbFill, skel[], picFrame, picImg, picStroke }
local thumbCache = {}   -- [userId] = url

-- helper
local function worldToScreen(pos)
    local sp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), on
end

local function isEnemyPlayer(plr)
    if not plr.Team then return true end
    return plr.Team ~= LocalPlayer.Team
end

local function shouldDraw(plr)
    if plr == LocalPlayer then return false end
    if isEnemyPlayer(plr) then return State.EnemyESP
    else return State.TeamESP end
end

local function getThumb(plr)
    if thumbCache[plr.UserId] then return thumbCache[plr.UserId] end
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(plr.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100)
    end)
    if ok then thumbCache[plr.UserId] = url end
    return url
end

-- refresh color ke semua ESP aktif
refreshESPColor = function()
    for _, d in pairs(espData) do
        if d.box then d.box.Color = State.ESPColor end
        if d.name then d.name.Color = State.ESPColor end
        if d.dist then d.dist.Color = State.ESPColor end
        if d.line then d.line.Color = State.ESPColor end
        for _, s in ipairs(d.skel or {}) do s.draw.Color = State.ESPColor end
        if d.picStroke then d.picStroke.Color = State.ESPColor end
    end
end
_G.refreshESPColor = refreshESPColor

-- buat data Drawing untuk 1 character
local function createESPData(char)
    local d = {}
    d.box  = Drawing.new("Square"); d.box.Thickness = 2.5; d.box.Filled = false
    d.name = Drawing.new("Text"); d.name.Size = 15; d.name.Center = true
    d.name.Outline = true; d.name.OutlineColor = Color3.new(0, 0, 0)
    d.dist = Drawing.new("Text"); d.dist.Size = 13; d.dist.Center = true
    d.dist.Outline = true; d.dist.OutlineColor = Color3.new(0, 0, 0)
    d.line = Drawing.new("Line"); d.line.Thickness = 2.5
    d.hbBG   = Drawing.new("Square"); d.hbBG.Filled = true; d.hbBG.Thickness = 0; d.hbBG.Color = Color3.new(0, 0, 0)
    d.hbFill = Drawing.new("Square"); d.hbFill.Filled = true; d.hbFill.Thickness = 0

    -- skeleton bones (R15 + R6)
    d.skel = {}
    local conns = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
        -- R6 fallback
        {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    for _, c in ipairs(conns) do
        local dl = Drawing.new("Line"); dl.Thickness = 2
        table.insert(d.skel, { from = c[1], to = c[2], draw = dl })
    end
    return d
end

-- buat UI picture (BillboardGui bulat)
local function createPicture(char, plr)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = "LH_Pic"
    bg.Adornee = hrp
    bg.AlwaysOnTop = true
    bg.Size = UDim2.fromOffset(48, 48)
    bg.StudsOffset = Vector3.new(0, 3.2, 0)
    bg.ClipsDescendants = false
    bg.Parent = DrawGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = bg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromScale(1, 1)
    img.BackgroundTransparency = 1
    img.Parent = frame
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = State.ESPColor
    stroke.Thickness = 2

    local url = getThumb(plr)
    if url then img.Image = url end

    return bg, frame, img, stroke
end

-- destroy
local function destroyESPData(char)
    local d = espData[char]
    if not d then return end
    if d.box then d.box:Remove() end
    if d.name then d.name:Remove() end
    if d.dist then d.dist:Remove() end
    if d.line then d.line:Remove() end
    if d.hbBG then d.hbBG:Remove() end
    if d.hbFill then d.hbFill:Remove() end
    for _, s in ipairs(d.skel) do s.draw:Remove() end
    if d.picFrame then d.picFrame:Destroy() end
    espData[char] = nil
end

-- ==========================================
-- RENDER LOOP ESP
-- ==========================================
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local seen   = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and shouldDraw(plr) and plr.Character then
            local char = plr.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")

            if hum and hum.Health > 0 and hrp and head then
                seen[char] = true
                if not espData[char] then
                    espData[char] = createESPData(char)
                    local bg, frame, img, stroke = createPicture(char, plr)
                    if bg then
                        espData[char].picFrame = bg
                        espData[char].picImg   = img
                        espData[char].picStroke = stroke
                    end
                end

                local d = espData[char]
                local headPos, onH = worldToScreen(head.Position)
                local footPos, onF = worldToScreen(hrp.Position - Vector3.new(0, 3, 0))

                if onH and onF and headPos.Y > -200 and headPos.Y < Camera.ViewportSize.Y + 200 then
                    local boxH = math.abs(footPos.Y - headPos.Y)
                    local boxW = boxH * 0.55
                    local boxX = headPos.X - boxW / 2
                    local boxY = headPos.Y

                    -- BOX
                    d.box.Visible  = State.ESP_Box
                    d.box.Size     = Vector2.new(boxW, boxH)
                    d.box.Position = Vector2.new(boxX, boxY)
                    d.box.Color    = State.ESPColor

                    -- NAME (atas box)
                    d.name.Visible  = State.ESP_Name
                    d.name.Text     = plr.Name
                    d.name.Position = Vector2.new(headPos.X, boxY - 20)
                    d.name.Color    = State.ESPColor

                    -- DISTANCE (bawah box)
                    local meters = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    d.dist.Visible  = State.ESP_Distance
                    d.dist.Text     = meters .. "m"
                    d.dist.Position = Vector2.new(headPos.X, boxY + boxH + 5)
                    d.dist.Color    = State.ESPColor

                    -- LINE (dari atas layar ke kepala, tebal)
                    d.line.Visible = State.ESP_Line
                    d.line.From    = Vector2.new(center.X, 0)
                    d.line.To      = headPos
                    d.line.Color   = State.ESPColor

                    -- SKELETON
                    for _, s in ipairs(d.skel) do
                        local a = char:FindFirstChild(s.from)
                        local b = char:FindFirstChild(s.to)
                        if a and b and State.ESP_Skeleton then
                            local pa, oa = worldToScreen(a.Position)
                            local pb, ob = worldToScreen(b.Position)
                            s.draw.Visible = oa and ob
                            s.draw.From    = pa
                            s.draw.To      = pb
                            s.draw.Color   = State.ESPColor
                        else
                            s.draw.Visible = false
                        end
                    end

                    -- HEALTH BAR (kanan box, warna dinamis 100/70/40)
                    if State.ESP_Health then
                        local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        local col = pct > 0.7 and Color3.fromRGB(0, 255, 0)
                            or pct > 0.4 and Color3.fromRGB(255, 150, 0)
                            or Color3.fromRGB(139, 0, 0)

                        local hbX = boxX + boxW + 5
                        d.hbBG.Visible  = true
                        d.hbBG.Size     = Vector2.new(4, boxH)
                        d.hbBG.Position = Vector2.new(hbX, boxY)

                        d.hbFill.Visible  = true
                        d.hbFill.Size     = Vector2.new(4, boxH * pct)
                        d.hbFill.Position = Vector2.new(hbX, boxY + boxH - (boxH * pct))
                        d.hbFill.Color    = col
                    else
                        d.hbBG.Visible   = false
                        d.hbFill.Visible = false
                    end

                    -- PICTURE
                    if d.picFrame then
                        d.picFrame.Enabled = State.ESP_Picture
                        if State.ESP_Picture and d.picStroke then
                            d.picStroke.Color = State.ESPColor
                        end
                    end
                else
                    -- di luar layar: matikan semua
                    d.box.Visible    = false
                    d.name.Visible   = false
                    d.dist.Visible   = false
                    d.line.Visible   = false
                    d.hbBG.Visible   = false
                    d.hbFill.Visible = false
                    for _, s in ipairs(d.skel) do s.draw.Visible = false end
                    if d.picFrame then d.picFrame.Enabled = false end
                end
            end
        end
    end

    -- cleanup yang tidak ada di frame
    for char, _ in pairs(espData) do
        if not seen[char] then
            destroyESPData(char)
        end
    end
end)

-- update FOV frame size kalau State.FOVSize berubah
task.spawn(function()
    while task.wait(0.25) do
        if B1.FOVFrame then
            B1.FOVFrame.Size = UDim2.new(0, State.FOVSize * 2, 0, State.FOVSize * 2)
        end
    end
end)
-- ============================================================
-- LITE HACK + ULTIMATE MODS | WindUI Edition
-- Bubble 3/4 : Tab Aimbot + Tab Player + Gun Mods
-- ============================================================

local B1          = _G.LH_Bubble1
local State       = B1.State
local TabAim      = B1.TabAim
local TabPlayer   = B1.TabPlayer
local Players     = B1.Players
local RunService  = B1.RunService
local LocalPlayer = B1.LocalPlayer
local Camera      = B1.Camera
local UIS         = B1.UserInputService
local WindUI      = B1.WindUI

-- ==========================================
-- SHARED: IsEnemy (dipakai ESP & aimbot)
-- ==========================================
local function isEnemyPlayer(plr)
    if not plr.Team then return true end
    return plr.Team ~= LocalPlayer.Team
end

-- ==========================================
-- SHARED: raycast wall check
-- ==========================================
local function IsVisible(targetPart)
    if not targetPart then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.FilterType = Enum.RaycastFilterType.Exclude
    local origin = Camera.CFrame.Position
    local dir    = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, dir, params)
    if not result then return true end
    return result.Instance:IsDescendantOf(targetPart.Parent)
end

-- ==========================================
-- AIMBOT TAB UI
-- ==========================================
local ASec1 = TabAim:Section({ Title = "Aimbot" })

ASec1:Toggle({
    Title = "Aimbot",
    Desc = "Aktifkan auto-aim",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.AimbotAktif = v end,
})

ASec1:Toggle({
    Title = "Team Check",
    Desc = "Jangan aim ke team sendiri",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.TeamCheck = v end,
})

ASec1:Toggle({
    Title = "Wall Check",
    Desc = "Hanya aim jika target terlihat (tidak di balik tembok)",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.WallCheck = v end,
})

ASec1:Dropdown({
    Title = "Mode Aimbot",
    Values = { "FOV", "360°" },
    Default = "FOV",
    Callback = function(v) State.AimMode = v end,
})

ASec1:Dropdown({
    Title = "Mode Trigger",
    Values = { "Camera", "Fire" },
    Default = "Camera",
    Callback = function(v) State.TriggerMode = v end,
})

ASec1:Toggle({
    Title = "Aim FOV",
    Desc = "Tampilkan lingkaran FOV",
    Type = "Checkbox",
    Default = true,
    Callback = function(v)
        State.AimFOV = v
        if B1.FOVFrame then B1.FOVFrame.Visible = v end
    end,
})

ASec1:Slider({
    Title = "Size FOV",
    Desc = "Radius lingkaran FOV (pixel)",
    Min = 10, Max = 600, Default = 150,
    Callback = function(v)
        State.FOVSize = v
        if B1.FOVFrame then
            B1.FOVFrame.Size = UDim2.new(0, v * 2, 0, v * 2)
        end
    end,
})

ASec1:Toggle({
    Title = "Aim Line",
    Desc = "Garis dari pusat layar ke target yang di-lock",
    Type = "Checkbox",
    Default = true,
    Callback = function(v) State.AimLine = v end,
})

ASec1:Dropdown({
    Title = "Aim Target",
    Values = { "Head", "Neck", "Chest" },
    Default = "Head",
    Callback = function(v) State.AimTargetMode = v end,
})

ASec1:Slider({
    Title = "Aim Distance",
    Desc = "Jarak maksimum target (meter)",
    Min = 50, Max = 2000, Default = 500,
    Callback = function(v) State.AimDistance = v end,
})

local ASec2 = TabAim:Section({ Title = "Smoothness" })
ASec2:Slider({
    Title = "Aim Smoothness",
    Desc = "Semakin tinggi = semakin lengket (1-100)",
    Min = 1, Max = 100, Default = 15,
    Callback = function(v) State.AimbotSmoothness = v end,
})

-- ==========================================
-- AIM LINE DRAWING
-- ==========================================
local AimLine = Drawing.new("Line")
AimLine.Thickness = 2.5
AimLine.Visible = false

-- ==========================================
-- AIMBOT LOGIC
-- ==========================================
local LockedTarget = nil

local function getTargetPart(char)
    if not char then return nil end
    local head  = char:FindFirstChild("Head")
    local neck  = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local chest = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if State.AimTargetMode == "Head"  then return head or neck or chest end
    if State.AimTargetMode == "Neck"  then return neck or head or chest end
    if State.AimTargetMode == "Chest" then return chest or neck or head end
    return head
end

-- ambil target terdekat (3D)
local function getClosest3D()
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                if State.TeamCheck and not isEnemyPlayer(plr) then continue end
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                if dist <= State.AimDistance then
                    local tp = getTargetPart(char)
                    if tp and (not State.WallCheck or IsVisible(tp)) then
                        if dist < bestDist then bestDist = dist; best = char end
                    end
                end
            end
        end
    end
    return best
end

-- ambil target terdekat di dalam FOV (2D)
local function getClosest2D()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                if State.TeamCheck and not isEnemyPlayer(plr) then continue end
                local dist3 = (Camera.CFrame.Position - hrp.Position).Magnitude
                if dist3 <= State.AimDistance then
                    local tp = getTargetPart(char)
                    if tp and (not State.WallCheck or IsVisible(tp)) then
                        local sp, on = Camera:WorldToViewportPoint(tp.Position)
                        if on then
                            local d2 = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                            if d2 <= State.FOVSize and d2 < bestDist then
                                bestDist = d2
                                best = char
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- loop aimbot
RunService.RenderStepped:Connect(function()
    -- FOV frame visibility
    if B1.FOVFrame then
        B1.FOVFrame.Visible = State.AimFOV and State.AimbotAktif and State.AimMode == "FOV"
        B1.FOVFrame.Size = UDim2.new(0, State.FOVSize * 2, 0, State.FOVSize * 2)
    end

    if not State.AimbotAktif then
        LockedTarget = nil
        AimLine.Visible = false
        return
    end

    -- cek apakah target lock masih valid
    local valid = false
    local tp = nil
    if LockedTarget and LockedTarget.Parent then
        local hum = LockedTarget:FindFirstChildOfClass("Humanoid")
        local hrp = LockedTarget:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then
            tp = getTargetPart(LockedTarget)
            if tp and (not State.WallCheck or IsVisible(tp)) then
                local d3 = (Camera.CFrame.Position - hrp.Position).Magnitude
                if d3 <= State.AimDistance then
                    if State.AimMode == "360°" then
                        valid = true
                    else
                        local sp, on = Camera:WorldToViewportPoint(tp.Position)
                        if on then
                            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local d2 = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                            if d2 <= State.FOVSize then valid = true end
                        end
                    end
                end
            end
        end
    end

    -- cari target baru kalau tidak valid
    if not valid then
        local newTarget = (State.AimMode == "360°") and getClosest3D() or getClosest2D()
        LockedTarget = newTarget
        tp = LockedTarget and getTargetPart(LockedTarget)
    end

    -- eksekusi aim
    if LockedTarget and tp then
        -- Camera mode: rotate camera
        if State.TriggerMode == "Camera" or State.AimMode == "360°" then
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, tp.Position)
            if State.AimMode == "360°" then
                Camera.CFrame = targetCF
            else
                local factor = State.AimbotSmoothness / 100
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, factor)
            end
        end

        -- Aim line
        if State.AimLine then
            local sp, on = Camera:WorldToViewportPoint(tp.Position)
            if on then
                AimLine.Visible = true
                AimLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                AimLine.To   = Vector2.new(sp.X, sp.Y)
                AimLine.Color = State.ESPColor
            else
                AimLine.Visible = false
            end
        else
            AimLine.Visible = false
        end
    else
        AimLine.Visible = false
    end
end)

-- ==========================================
-- TAB PLAYER UI
-- ==========================================
local PSec1 = TabPlayer:Section({ Title = "Movement" })

PSec1:Toggle({
    Title = "Speed Run",
    Desc = "Ubah kecepatan lari (persen dari default 16)",
    Type = "Checkbox",
    Default = false,
    Callback = function(v)
        State.SpeedAktif = v
        if not v then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end,
})

PSec1:Slider({
    Title = "Speed %",
    Desc = "Persentase kecepatan (100 = normal)",
    Min = 50, Max = 500, Default = 100,
    Callback = function(v) State.SpeedPercent = v end,
})

PSec1:Toggle({
    Title = "Multi Jump",
    Desc = "Bisa lompat berkali-kali di udara",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.MultiJump = v end,
})

PSec1:Toggle({
    Title = "Fly Hack",
    Desc = "Tahan tombol Jump untuk terbang",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.FlyHack = v end,
})

PSec1:Toggle({
    Title = "No Fall Damage",
    Desc = "Anti mati karena jatuh",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.AntiFallDamageAktif = v end,
})

local PSec2 = TabPlayer:Section({ Title = "Jump" })

PSec2:Toggle({
    Title = "Lompat Tinggi",
    Desc = "Override JumpPower",
    Type = "Checkbox",
    Default = false,
    Callback = function(v)
        State.JumpAktif = v
        if not v then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.UseJumpPower = true; hum.JumpPower = 50 end
        end
    end,
})

PSec2:Slider({
    Title = "Set Power",
    Desc = "Kekuatan lompat",
    Min = 50, Max = 500, Default = 100,
    Callback = function(v) State.CustomJump = v end,
})

local PSec3 = TabPlayer:Section({ Title = "Gun" })

PSec3:Toggle({
    Title = "Rapid Fire",
    Desc = "Tembakan cepat berturut-turut",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.RapidFire = v end,
})

PSec3:Toggle({
    Title = "Unlimited Ammo",
    Desc = "Peluru tak terbatas",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.UnlimitedAmmo = v end,
})

-- ==========================================
-- PLAYER LOGIC (Stepped loop)
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end

    -- Speed
    if State.SpeedAktif then
        hum.WalkSpeed = 16 * (State.SpeedPercent / 100)
    end

    -- Jump power
    if State.JumpAktif then
        hum.UseJumpPower = true
        hum.JumpPower = State.CustomJump
    end

    -- Fly (hold jump)
    if State.FlyHack and hrp then
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end

    -- Anti-fall (dari kodemu)
    if State.AntiFallDamageAktif and hrp and hrp.Velocity.Y < -40 then
        local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -20, 0), RaycastParams.new())
        if hit then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z)
        end
    end
end)

-- Multi Jump
UIS.JumpRequest:Connect(function()
    if not State.MultiJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==========================================
-- GUN MODS (dari kodemu — ScanValueMods + Deep Memory GC)
-- ==========================================
local function ScanValueMods(tool)
    pcall(function()
        local function SetSafe(attr, value)
            if tool:GetAttribute(attr) ~= nil and tool:GetAttribute(attr) ~= value then
                tool:SetAttribute(attr, value)
            end
        end
        SetSafe("TotalAmmo", 999999)
        SetSafe("NewMax", 999999)
        SetSafe("magazineSize", 999999)
        SetSafe("_ammo", 999999)
        SetSafe("spread", 0)
        SetSafe("recoilMax", 0)
        SetSafe("recoilMin", 0)
        SetSafe("reloadTime", 0.05)
        SetSafe("rateOfFire", State.CustomFireRate)

        for _, obj in pairs(tool:GetDescendants()) do
            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                local name = obj.Name:lower()
                if name:find("ammo") or name:find("clip") or name:find("mag") then
                    obj.Value = 999999
                elseif name:find("firerate") or name:find("rpm") or name:find("rate") then
                    if name:find("rpm") then
                        obj.Value = State.CustomFireRate
                    else
                        obj.Value = 60 / State.CustomFireRate
                    end
                end
            end
        end
    end)
end

-- loop value scan
RunService.RenderStepped:Connect(function()
    if not (State.GunModsAktif or State.RapidFire or State.UnlimitedAmmo) then return end
    if LocalPlayer.Character then
        for _, t in pairs(LocalPlayer.Character:GetChildren()) do
            if t:IsA("Tool") or t:IsA("Model") then
                ScanValueMods(t)
            end
        end
    end
    for _, v in pairs(Camera:GetChildren()) do
        if v:IsA("Model") then
            ScanValueMods(v)
        end
    end
end)

-- Deep memory GC scan
task.spawn(function()
    while task.wait(1) do
        if State.GunModsAktif or State.RapidFire or State.UnlimitedAmmo then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "MaxAmmo") or rawget(v, "ClipSize")
                            or rawget(v, "RPM") or rawget(v, "FireRate") or rawget(v, "rateOfFire") then

                            if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                            if rawget(v, "CurrentAmmo") and type(v.CurrentAmmo) == "number" then v.CurrentAmmo = 999999 end
                            if rawget(v, "MaxAmmo") and type(v.MaxAmmo) == "number" then v.MaxAmmo = 999999 end
                            if rawget(v, "StoredAmmo") and type(v.StoredAmmo) == "number" then v.StoredAmmo = 999999 end
                            if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                            if rawget(v, "Magazine") and type(v.Magazine) == "number" then v.Magazine = 999999 end

                            if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = State.CustomFireRate end
                            if rawget(v, "FireRate") and type(v.FireRate) == "number" then v.FireRate = 60 / State.CustomFireRate end
                            if rawget(v, "rateOfFire") and type(v.rateOfFire) == "number" then v.rateOfFire = State.CustomFireRate end

                            if rawget(v, "Spread") then v.Spread = 0 end
                            if rawget(v, "MaxSpread") then v.MaxSpread = 0 end
                            if rawget(v, "Recoil") then v.Recoil = 0 end
                            if rawget(v, "Kickback") then v.Kickback = 0 end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- GUN MODS TAB UI (dipindah ke Player tab, tapi tetap ada slider RPM)
-- ==========================================
local GS = TabPlayer:Section({ Title = "Gun Mods (Deep Memory Scan)" })

GS:Toggle({
    Title = "Gun Mods",
    Desc = "Infinite Ammo & RPM via deep memory scan",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.GunModsAktif = v end,
})

GS:Slider({
    Title = "RPM Fire Rate",
    Desc = "Fire rate override",
    Min = 400, Max = 2500, Default = 800,
    Callback = function(v) State.CustomFireRate = v end,
})

-- ==========================================
-- LOGIKA FISIKA (CanCollide bypass - copy utuh dari kodemu)
-- ==========================================
pcall(function()
    local mt = getrawmetatable(game)
    if mt and mt.__index then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() and t:IsA("BasePart") and tostring(k) == "CanCollide" then
                return true
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end
end)
-- ============================================================
-- LITE HACK + ULTIMATE MODS | WindUI Edition
-- Bubble 4/4 : Tab World + Tab Config + Skull Toggle
-- ============================================================

local B1          = _G.LH_Bubble1
local State       = B1.State
local TabWorld    = B1.TabWorld
local TabConfig   = B1.TabConfig
local SkullBtn    = B1.SkullBtn
local WindUI      = B1.WindUI
local Players     = B1.Players
local RunService  = B1.RunService
local LocalPlayer = B1.LocalPlayer
local Lighting    = B1.Lighting
local HttpService = B1.HttpService

-- ==========================================
-- TAB WORLD — SECTION: ENVIRONMENT
-- ==========================================
local WSec1 = TabWorld:Section({ Title = "Environment" })

WSec1:Dropdown({
    Title = "Clock Time",
    Desc = "Ubah waktu & suasana map",
    Values = { "Morning", "Noon", "Evening", "Night" },
    Default = "Noon",
    Callback = function(v) State.ClockTime = v end,
})

WSec1:Toggle({
    Title = "No Gravity",
    Desc = "Matikan gravitasi map",
    Type = "Checkbox",
    Default = false,
    Callback = function(v) State.NoGravity = v end,
})

-- ==========================================
-- TAB WORLD — SECTION: TELEPORT
-- ==========================================
local WSec2 = TabWorld:Section({ Title = "Teleport to Player" })

-- Bangun list nama player (exclude LocalPlayer)
local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = WSec2:Dropdown({
    Title = "Select Player",
    Desc = "Pilih player tujuan teleport",
    Values = getPlayerNames(),
    Default = "",
    Callback = function(v) State.TeleportTarget = v end,
})

-- refresh dropdown saat player join/leave
local function refreshPlayerDropdown()
    local list = getPlayerNames()
    pcall(function()
        PlayerDropdown:Refresh(list)   -- WindUI versi baru
    end)
end
Players.PlayerAdded:Connect(function() task.wait(1); refreshPlayerDropdown() end)
Players.PlayerRemoving:Connect(function() task.wait(1); refreshPlayerDropdown() end)

WSec2:Button({
    Title = "⚡ Teleport",
    Callback = function()
        local target = State.TeleportTarget
        if not target or target == "" then
            WindUI:Notify({ Title = "Teleport", Content = "Pilih player dulu!", Duration = 3, Icon = "alert-triangle" })
            return
        end
        local plr = Players:FindFirstChild(target)
        if not plr or not plr.Character then
            WindUI:Notify({ Title = "Teleport", Content = "Target tidak valid.", Duration = 3, Icon = "alert-triangle" })
            return
        end
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        local myHrp  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if hrp and myHrp then
            myHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
            WindUI:Notify({ Title = "Teleport", Content = "Berhasil ke " .. plr.Name, Duration = 3, Icon = "check" })
        end
    end,
})

-- ==========================================
-- WORLD LOGIC (clock, gravity)
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        -- Clock time
        local hour = 12
        if State.ClockTime == "Morning" then hour = 7
        elseif State.ClockTime == "Noon" then hour = 12
        elseif State.ClockTime == "Evening" then hour = 17
        elseif State.ClockTime == "Night" then hour = 0 end
        pcall(function()
            Lighting.ClockTime = hour
            Lighting.Brightness = (hour >= 6 and hour <= 18) and 2 or 0.5
        end)

        -- Gravity
        pcall(function()
            workspace.Gravity = State.NoGravity and 0 or 196.2
        end)
    end
end)

-- ==========================================
-- TAB CONFIG — SECTION: THEME
-- ==========================================
local CfgSec1 = TabConfig:Section({ Title = "Theme" })

CfgSec1:Dropdown({
    Title = "Theme",
    Desc = "Ubah tema UI",
    Values = { "Dark", "Light" },
    Default = "Dark",
    Callback = function(v)
        State.Theme = v
        pcall(function()
            WindUI:SetTheme(v)
        end)
    end,
})

-- ==========================================
-- TAB CONFIG — SECTION: SAVE / LOAD
-- ==========================================
local CfgSec2 = TabConfig:Section({ Title = "Save / Load Configuration" })

local ConfigFile = "LiteHack_Config.json"

-- Field yang akan disimpan ke JSON
local SAVE_FIELDS = {
    "AntiAdminAktif",
    "EnemyESP", "TeamESP",
    "ESP_Box", "ESP_Name", "ESP_Line", "ESP_Health",
    "ESP_Skeleton", "ESP_Distance", "ESP_Picture",
    "AimbotAktif", "TeamCheck", "WallCheck",
    "AimMode", "TriggerMode", "AimFOV", "FOVSize", "AimLine",
    "AimTargetMode", "AimDistance", "AimbotSmoothness",
    "SpeedAktif", "SpeedPercent", "MultiJump", "FlyHack",
    "AntiFallDamageAktif", "JumpAktif", "CustomJump",
    "GunModsAktif", "CustomFireRate", "RapidFire", "UnlimitedAmmo",
    "ClockTime", "NoGravity",
    "Theme",
}

-- Save (state → JSON file)
local function SaveConfig()
    if not writefile then
        WindUI:Notify({ Title = "Save", Content = "Eksekutor tidak support writefile.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    local data = {}
    for _, key in ipairs(SAVE_FIELDS) do
        local val = State[key]
        -- Color3 → hex string biar JSON-safe
        if typeof(val) == "Color3" then
            val = { __color = true, r = val.R, g = val.G, b = val.B }
        end
        data[key] = val
    end
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then
        WindUI:Notify({ Title = "Save", Content = "Gagal encode JSON.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    local wOk = pcall(function() writefile(ConfigFile, json) end)
    if wOk then
        WindUI:Notify({ Title = "Save", Content = "Konfigurasi tersimpan!", Duration = 4, Icon = "check" })
        return true
    else
        WindUI:Notify({ Title = "Save", Content = "Gagal menulis file.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
end

-- Load (JSON file → state)
local function LoadConfig()
    if not (isfile and readfile) then
        WindUI:Notify({ Title = "Load", Content = "Eksekutor tidak support readfile.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    if not isfile(ConfigFile) then
        WindUI:Notify({ Title = "Load", Content = "Belum ada file konfigurasi.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    local ok, json = pcall(function() return readfile(ConfigFile) end)
    if not ok or not json then
        WindUI:Notify({ Title = "Load", Content = "Gagal baca file.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    local ok2, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok2 or type(data) ~= "table" then
        WindUI:Notify({ Title = "Load", Content = "File JSON rusak.", Duration = 4, Icon = "alert-triangle" })
        return false
    end
    for key, val in pairs(data) do
        if typeof(val) == "table" and val.__color then
            State[key] = Color3.new(val.r or 1, val.g or 0, val.b or 0)
        else
            State[key] = val
        end
    end
    -- apply theme langsung
    pcall(function() WindUI:SetTheme(State.Theme or "Dark") end)
    -- apply FOV size
    if B1.FOVFrame then
        B1.FOVFrame.Size = UDim2.new(0, State.FOVSize * 2, 0, State.FOVSize * 2)
    end
    -- refresh warna ESP
    if _G.refreshESPColor then
        pcall(_G.refreshESPColor)
    end
    WindUI:Notify({ Title = "Load", Content = "Konfigurasi dimuat!", Duration = 4, Icon = "check" })
    return true
end

CfgSec2:Button({
    Title = "💾 Save Config (JSON)",
    Callback = function() SaveConfig() end,
})

CfgSec2:Button({
    Title = "📂 Load Config (JSON)",
    Callback = function() LoadConfig() end,
})

CfgSec2:Button({
    Title = "🔄 Reset to Default",
    Callback = function()
        -- Reset State ke default
        State.AntiAdminAktif = false
        State.EnemyESP, State.TeamESP = false, false
        State.ESP_Box, State.ESP_Name, State.ESP_Line = true, true, true
        State.ESP_Health, State.ESP_Skeleton = true, false
        State.ESP_Distance, State.ESP_Picture = true, false
        State.AimbotAktif, State.TeamCheck, State.WallCheck = false, true, true
        State.AimMode, State.TriggerMode = "FOV", "Camera"
        State.AimFOV, State.FOVSize, State.AimLine = true, 150, true
        State.AimTargetMode, State.AimDistance = "Head", 500
        State.AimbotSmoothness = 15
        State.SpeedAktif, State.SpeedPercent = false, 100
        State.MultiJump, State.FlyHack = false, false
        State.AntiFallDamageAktif = false
        State.JumpAktif, State.CustomJump = false, 100
        State.GunModsAktif, State.CustomFireRate = false, 800
        State.RapidFire, State.UnlimitedAmmo = false, false
        State.ClockTime, State.NoGravity = "Noon", false
        State.Theme = "Dark"

        -- apply visual reset
        pcall(function() WindUI:SetTheme("Dark") end)
        if B1.FOVFrame then
            B1.FOVFrame.Size = UDim2.new(0, 300, 0, 300)
        end
        if _G.refreshESPColor then pcall(_G.refreshESPColor) end

        WindUI:Notify({ Title = "Reset", Content = "Semua fitur direset ke default.", Duration = 4, Icon = "refresh-cw" })
    end,
})

-- ==========================================
-- FLOATING SKULL TOGGLE (show/hide menu)
-- ==========================================
local menuOpen = true

SkullBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    pcall(function()
        if menuOpen then
            Window:Open()
        else
            Window:Close()
        end
    end)
end)

-- keyboard shortcut: LeftControl
B1.UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        menuOpen = not menuOpen
        pcall(function()
            if menuOpen then Window:Open() else Window:Close() end
        end)
    end
end)

-- ==========================================
-- NOTIF PEMBUKA
-- ==========================================
pcall(function()
    WindUI:Notify({
        Title = "💀 Lite Hack Loaded",
        Content = "Semua fitur aktif. Tekan skull untuk show/hide.",
        Duration = 5,
        Icon = "skull",
    })
end)

-- ==========================================
-- CLEANUP STATE GLOBAL (biar tidak numpuk di rejoin)
-- ==========================================
_G.LH_Bubble1 = nil
