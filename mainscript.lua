-- ==========================================
-- BYPASS ANTI-CHEAT (COPY PASTE ASLI)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function()
                setreadonly(getrenv(), false)
                setreadonly(getreg(), false)
                setreadonly(getgc(), false)
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

local Camera = workspace.CurrentCamera
if Camera.ViewportSize.Y > Camera.ViewportSize.X then
    repeat task.wait(0.5) until Camera.ViewportSize.X > Camera.ViewportSize.Y
    task.wait(1)
end

-- ==========================================
-- CONFIG GLOBAL
-- ==========================================
_G.LiteHackCfg = {
    ESPEnemy = false,
    ESPTeam = false,
    ESPBox = true,
    ESPName = true,
    ESPLine = false,
    ESPHealth = true,
    ESPSkeleton = false,
    ESPDistance = true,
    ESPPicture = false,
    ESPWeapon = true,
    ESPBomb = false,
    ESPColor = Color3.fromRGB(255, 60, 60),
    Aimbot = false,
    AimTeamCheck = true,
    AimWallCheck = true,
    AimMode = "FOV",
    AimTrigger = "Camera",
    AimFOV = true,
    AimFOVSize = 150,
    AimLine = true,
    AimTarget = "Head",
    AimDistance = 500,
    AimSmoothness = 100,
    AutoFire = false,
    ShowCrosshair = false,
    SpeedRun = false,
    SpeedRunValue = 50,
    RapidFire = false,
    UnlimitedAmmo = false,
    NoRecoil = false,
    WallHack = false,
    ClockTime = "Default",
    LowGravity = false,
    Theme = "Dark",
}

local Cfg = _G.LiteHackCfg

-- ==========================================
-- UTILITY
-- ==========================================
local function getGuiParent()
    return (gethui and gethui()) or CoreGui
end

local function make(className, props, children)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = obj end
    return obj
end

local function corner(obj, r)
    return make("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = obj})
end

local function stroke(obj, color, thick, transparency)
    return make("UIStroke", {
        Color = color or Color3.fromRGB(255,255,255),
        Thickness = thick or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

local function padding(obj, p)
    return make("UIPadding", {
        PaddingTop = UDim.new(0, p),
        PaddingBottom = UDim.new(0, p),
        PaddingLeft = UDim.new(0, p),
        PaddingRight = UDim.new(0, p),
        Parent = obj
    })
end

local FONT_BOLD = Enum.Font.GothamBold

-- ==========================================
-- SMOOTH TELEPORT (BodyVelocity - anti-detect)
-- ==========================================
-- Logika: gerakkan karakter pakai BodyVelocity yang di-update tiap frame,
-- jadi server lihat "gerak cepat" bukan "loncat CFrame".
_G.__SmoothTeleport = function(targetPos, duration)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Batalkan teleport sebelumnya kalau masih jalan
    if _G.__ActiveTeleportBV then
        pcall(function() _G.__ActiveTeleportBV:Destroy() end)
        _G.__ActiveTeleportBV = nil
    end
    if _G.__ActiveTeleportConn then
        pcall(function() _G.__ActiveTeleportConn:Disconnect() end)
        _G.__ActiveTeleportConn = nil
    end

    local startPos = hrp.Position
    local startTime = tick()
    local conn
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.P = 3000
    bv.Parent = hrp
    _G.__ActiveTeleportBV = bv

    conn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then
            if conn then conn:Disconnect() end
            if bv then pcall(function() bv:Destroy() end) end
            return
        end

        local currentPos = hrp.Position
        local diff = targetPos - currentPos
        local dist = diff.Magnitude
        local elapsed = tick() - startTime

        -- Sampai tujuan atau timeout
        if dist < 5 or elapsed > duration then
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            _G.__ActiveTeleportBV = nil
            _G.__ActiveTeleportConn = nil

            -- Fallback: kalau masih jauh, teleport CFrame pelan-pelan
            if dist > 5 and elapsed > duration then
                -- Teleport step kecil biar nggak loncat jauh
                local stepTarget = currentPos + diff.Unit * math.min(dist, 30)
                hrp.CFrame = CFrame.new(stepTarget, stepTarget + hrp.CFrame.LookVector * 0.001 + hrp.CFrame.UpVector * 0.001)
            end
            return
        end

        -- Kecepatan disesuaikan: 60-180 studs/detik
        -- Makin jauh, makin cepat, tapi ada limit
        local speed = math.clamp(dist * 3, 60, 180)
        bv.Velocity = diff.Unit * speed
    end)
    _G.__ActiveTeleportConn = conn
end

-- ==========================================
-- FAKE WALKSPEED
-- ==========================================
if hookmetamethod and checkcaller then
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if not checkcaller() and key == "WalkSpeed"
               and typeof(self) == "Instance"
               and self:IsA("Humanoid")
               and self.Parent == LocalPlayer.Character then
                return 16
            end
            return oldIndex(self, key)
        end)
    end)
end

-- ==========================================
-- FLOATING ICON
-- ==========================================
local FloatingGui = make("ScreenGui", {
    Name = "LiteHack_FloatingIcon",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = getGuiParent()
})

local IconBtn = make("TextButton", {
    Name = "SkullIcon",
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0, 40, 0.5, -28),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    Text = "☠",
    TextColor3 = Color3.fromRGB(255, 70, 70),
    TextSize = 32,
    Font = Enum.Font.GothamBlack,
    AutoButtonColor = false,
    Active = true,
    Parent = FloatingGui
})
corner(IconBtn, 28)
local iconStroke = stroke(IconBtn, Color3.fromRGB(255, 60, 60), 2, 0)
local iconGlow = make("ImageLabel", {
    Size = UDim2.new(1, 20, 1, 20),
    Position = UDim2.new(0, -10, 0, -10),
    BackgroundTransparency = 1,
    Image = "rbxassetid://5028857084",
    ImageColor3 = Color3.fromRGB(255, 50, 50),
    ImageTransparency = 0.6,
    ZIndex = 0,
    Parent = IconBtn
})

task.spawn(function()
    while IconBtn.Parent do
        TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.5}):Play()
        TweenService:Create(iconGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.85, Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15)}):Play()
        task.wait(1.2)
        TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0}):Play()
        TweenService:Create(iconGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.6, Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10)}):Play()
        task.wait(1.2)
    end
end)

-- ==========================================
-- MAIN WINDOW
-- ==========================================
local WinGui = make("ScreenGui", {
    Name = "LiteHack_MainUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = getGuiParent()
})

local MainFrame = make("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 420, 0, 320),
    Position = UDim2.new(0.5, -210, 0.5, -160),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
    ZIndex = 1,
    Parent = WinGui
})
corner(MainFrame, 14)
stroke(MainFrame, Color3.fromRGB(60, 60, 80), 1.5, 0.2)
padding(MainFrame, 8)

local TopBar = make("Frame", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Parent = MainFrame
})
local Title = make("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    BackgroundTransparency = 1,
    Text = "☠  LITE HACK  ☠",
    TextColor3 = Color3.fromRGB(255, 70, 70),
    TextSize = 16,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})
local CloseBtn = make("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -28, 0, 2),
    BackgroundColor3 = Color3.fromRGB(60, 20, 20),
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 120, 120),
    TextSize = 14,
    Font = FONT_BOLD,
    AutoButtonColor = false,
    Parent = TopBar
})
corner(CloseBtn, 6)

local TabScroll = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(24, 24, 32),
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.X,
    ScrollingDirection = Enum.ScrollingDirection.X,
    Parent = MainFrame
})
corner(TabScroll, 8)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = TabScroll
})
padding(TabScroll, 6)

local Content = make("Frame", {
    Size = UDim2.new(1, 0, 1, -84),
    Position = UDim2.new(0, 0, 0, 84),
    BackgroundColor3 = Color3.fromRGB(24, 24, 32),
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = MainFrame
})
corner(Content, 10)
-- ==========================================
-- WIDGET BUILDERS
-- ==========================================
local Tabs = {}
local TabButtons = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    local btn = make("TextButton", {
        Size = UDim2.new(0, 100, 0, 28),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        Text = icon .. " " .. name,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 12,
        Font = FONT_BOLD,
        AutoButtonColor = false,
        Parent = TabScroll
    })
    corner(btn, 6)

    local page = make("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(255, 70, 70),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = Content
    })
    make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page
    })

    TabButtons[name] = btn
    Tabs[name] = page

    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            b.TextColor3 = Color3.fromRGB(200, 200, 210)
            Tabs[n].Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        ActiveTab = name
    end)

    return page
end

local function Section(page, text)
    local f = make("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = page
    })
    make("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "▸ " .. text,
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 13,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f
    })
    return f
end

local function Toggle(page, text, default, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = page
    })
    corner(row, 8)
    make("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local state = default or false
    local btn = make("TextButton", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 70),
        Text = "",
        AutoButtonColor = false,
        Parent = row
    })
    corner(btn, 11)
    local knob = make("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = btn
    })
    corner(knob, 9)

    local function update(v, fire)
        state = v
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = v and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 70)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        if fire and callback then callback(v) end
    end

    btn.MouseButton1Click:Connect(function() update(not state, true) end)
    return {
        Set = function(_, v) update(v, true) end,
        Get = function() return state end
    }
end

local function Slider(page, text, min, max, default, suffix, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = page
    })
    corner(row, 8)
    local lbl = make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 2),
        BackgroundTransparency = 1,
        Text = text .. ": " .. tostring(default) .. (suffix or ""),
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local track = make("Frame", {
        Size = UDim2.new(1, -20, 0, 10),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        BorderSizePixel = 0,
        Parent = row
    })
    corner(track, 5)
    local fill = make("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        BorderSizePixel = 0,
        Parent = track
    })
    corner(fill, 5)
    local knob = make("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track
    })
    corner(knob, 7)

    local dragging = false
    local value = default

    local function setValue(v, fire)
        value = math.clamp(math.floor(v + 0.5), min, max)
        local alpha = (value - min) / (max - min)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        lbl.Text = text .. ": " .. tostring(value) .. (suffix or "")
        if fire and callback then callback(value) end
    end

    local function inputAt(x)
        local rel = (x - track.AbsolutePosition.X) / track.AbsoluteSize.X
        setValue(min + rel * (max - min), true)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            inputAt(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            inputAt(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Set = function(_, v) setValue(v, true) end,
        Get = function() return value end
    }
end

local function ComboBox(page, text, options, default, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = page
    })
    corner(row, 8)
    make("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local value = default or options[1]
    local btn = make("TextButton", {
        Size = UDim2.new(0, 150, 0, 22),
        Position = UDim2.new(1, -162, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(45, 45, 58),
        Text = value .. "  ▼",
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 11,
        Font = FONT_BOLD,
        AutoButtonColor = false,
        ZIndex = 20,
        Parent = row
    })
    corner(btn, 6)

    local open = false
    local listFrame
    local overlay

    local function closeList()
        if overlay then overlay:Destroy(); overlay = nil end
        if listFrame then listFrame:Destroy(); listFrame = nil end
        open = false
    end

    local function openList()
        open = true
        overlay = make("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 998,
            Parent = WinGui
        })
        overlay.MouseButton1Click:Connect(closeList)

        local absPos = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        listFrame = make("ScrollingFrame", {
            Size = UDim2.new(0, absSize.X, 0, math.min(#options * 26 + 8, 140)),
            Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4),
            BackgroundColor3 = Color3.fromRGB(20, 20, 28),
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 999,
            Parent = WinGui
        })
        corner(listFrame, 6)
        stroke(listFrame, Color3.fromRGB(255, 60, 60), 1, 0.3)
        make("UIListLayout", {Padding = UDim.new(0, 2), Parent = listFrame})
        padding(listFrame, 4)

        for _, opt in ipairs(options) do
            local ob = make("TextButton", {
                Size = UDim2.new(1, -8, 0, 22),
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                Text = opt,
                TextColor3 = Color3.fromRGB(220, 220, 230),
                TextSize = 11,
                Font = FONT_BOLD,
                AutoButtonColor = false,
                ZIndex = 1000,
                Parent = listFrame
            })
            corner(ob, 4)
            ob.MouseButton1Click:Connect(function()
                value = opt
                btn.Text = value .. "  ▼"
                closeList()
                if callback then callback(value) end
            end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        if open then closeList() else openList() end
    end)

    return {
        Set = function(_, v) value = v; btn.Text = v .. "  ▼"; if callback then callback(v) end end,
        Get = function() return value end
    }
end

local function ListBox(page, text, getItems, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = page
    })
    corner(row, 8)
    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local scroll = make("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 78),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundColor3 = Color3.fromRGB(20, 20, 28),
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 5,
        Parent = row
    })
    corner(scroll, 6)
    make("UIListLayout", {Padding = UDim.new(0, 2), Parent = scroll})
    padding(scroll, 4)

    local function refresh()
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, item in ipairs(getItems()) do
            local ob = make("TextButton", {
                Size = UDim2.new(1, -8, 0, 22),
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                Text = item,
                TextColor3 = Color3.fromRGB(220, 220, 230),
                TextSize = 11,
                Font = FONT_BOLD,
                AutoButtonColor = false,
                ZIndex = 6,
                Parent = scroll
            })
            corner(ob, 4)
            ob.MouseButton1Click:Connect(function()
                if callback then callback(item) end
            end)
        end
    end
    refresh()
    task.spawn(function()
        while row.Parent do task.wait(2); pcall(refresh) end
    end)
end

local function Button(page, text, callback)
    local btn = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = FONT_BOLD,
        AutoButtonColor = false,
        Parent = page
    })
    corner(btn, 8)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return btn
end

local function TextBox(page, placeholder, callback)
    local tb = make("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        Text = "",
        PlaceholderText = placeholder or "Ketik...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 160),
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = page
    })
    corner(tb, 8)
    padding(tb, 10)
    tb.FocusLost:Connect(function()
        if callback then callback(tb.Text) end
    end)
    return tb
end

-- ==========================================
-- CREATE TABS
-- ==========================================
local VisualTab = CreateTab("Visual", "👁")
local AimbotTab = CreateTab("Aimbot", "🎯")
local PlayerTab = CreateTab("Player", "🏃")
local WorldTab  = CreateTab("World", "🌍")
local ConfigTab = CreateTab("Config", "⚙")

TabButtons["Visual"].BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TabButtons["Visual"].TextColor3 = Color3.fromRGB(255, 255, 255)
VisualTab.Visible = true
ActiveTab = "Visual"

-- ==========================================
-- TAB VISUAL
-- ==========================================
Section(VisualTab, "ESP Filter")
Toggle(VisualTab, "ESP Enemy", Cfg.ESPEnemy, function(v) Cfg.ESPEnemy = v end)
Toggle(VisualTab, "ESP Team", Cfg.ESPTeam, function(v) Cfg.ESPTeam = v end)

Section(VisualTab, "ESP Elements")
Toggle(VisualTab, "Box", Cfg.ESPBox, function(v) Cfg.ESPBox = v end)
Toggle(VisualTab, "Name", Cfg.ESPName, function(v) Cfg.ESPName = v end)
Toggle(VisualTab, "Weapon", Cfg.ESPWeapon, function(v) Cfg.ESPWeapon = v end)
Toggle(VisualTab, "Line", Cfg.ESPLine, function(v) Cfg.ESPLine = v end)
Toggle(VisualTab, "Health", Cfg.ESPHealth, function(v) Cfg.ESPHealth = v end)
Toggle(VisualTab, "Skeleton", Cfg.ESPSkeleton, function(v) Cfg.ESPSkeleton = v end)
Toggle(VisualTab, "Distance", Cfg.ESPDistance, function(v) Cfg.ESPDistance = v end)
Toggle(VisualTab, "Picture", Cfg.ESPPicture, function(v) Cfg.ESPPicture = v end)

Section(VisualTab, "Bomb ESP")
Toggle(VisualTab, "Bomb ESP (PlantedC4)", Cfg.ESPBomb, function(v) Cfg.ESPBomb = v end)

-- ==========================================
-- TAB AIMBOT
-- ==========================================
Section(AimbotTab, "Aimbot Settings")
Toggle(AimbotTab, "Aimbot", Cfg.Aimbot, function(v) Cfg.Aimbot = v end)
Toggle(AimbotTab, "Auto Fire", Cfg.AutoFire, function(v) Cfg.AutoFire = v end)
Toggle(AimbotTab, "Show Crosshair", Cfg.ShowCrosshair, function(v) Cfg.ShowCrosshair = v end)
Toggle(AimbotTab, "Team Check", Cfg.AimTeamCheck, function(v) Cfg.AimTeamCheck = v end)
Toggle(AimbotTab, "Wall Check", Cfg.AimWallCheck, function(v) Cfg.AimWallCheck = v end)
ComboBox(AimbotTab, "Mode Aimbot", {"FOV", "360°"}, Cfg.AimMode, function(v) Cfg.AimMode = v end)
ComboBox(AimbotTab, "Mode Trigger", {"Camera", "Fire (Snap)"}, Cfg.AimTrigger, function(v) Cfg.AimTrigger = v end)
Toggle(AimbotTab, "Aim FOV", Cfg.AimFOV, function(v) Cfg.AimFOV = v end)
Slider(AimbotTab, "Size FOV", 20, 600, Cfg.AimFOVSize, "px", function(v) Cfg.AimFOVSize = v end)
Toggle(AimbotTab, "Aim Line", Cfg.AimLine, function(v) Cfg.AimLine = v end)
ComboBox(AimbotTab, "Aim Target", {"Head", "Neck", "Chest"}, Cfg.AimTarget, function(v) Cfg.AimTarget = v end)
Slider(AimbotTab, "Aim Distance", 50, 2000, Cfg.AimDistance, "m", function(v) Cfg.AimDistance = v end)
Slider(AimbotTab, "Aim Smoothness", 1, 100, Cfg.AimSmoothness, "%", function(v) Cfg.AimSmoothness = v end)
-- ==========================================
-- FORWARD DECLARE
-- ==========================================
restoreAll = nil
restoreRecoil = nil

-- ==========================================
-- TAB PLAYER
-- ==========================================
Section(PlayerTab, "Movement")
Toggle(PlayerTab, "Speed Run", Cfg.SpeedRun, function(v)
    Cfg.SpeedRun = v
    if not v and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end)
Slider(PlayerTab, "Speed %", 100, 500, Cfg.SpeedRunValue, "%", function(v) Cfg.SpeedRunValue = v end)

Section(PlayerTab, "Combat")
Toggle(PlayerTab, "Rapid Fire", Cfg.RapidFire, function(v)
    Cfg.RapidFire = v
    if not v and not Cfg.UnlimitedAmmo and restoreAll then pcall(restoreAll) end
end)
Toggle(PlayerTab, "Unlimited Ammo", Cfg.UnlimitedAmmo, function(v)
    Cfg.UnlimitedAmmo = v
    if not v and not Cfg.RapidFire and restoreAll then pcall(restoreAll) end
end)
Toggle(PlayerTab, "No Recoil", Cfg.NoRecoil, function(v)
    Cfg.NoRecoil = v
    if not v and restoreRecoil then pcall(restoreRecoil) end
end)
Toggle(PlayerTab, "Wall Hack (Noclip)", Cfg.WallHack, function(v)
    Cfg.WallHack = v
    if not v and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CanCollide = true end
    end
end)

-- ==========================================
-- TAB WORLD
-- ==========================================
Section(WorldTab, "World Mods")
ComboBox(WorldTab, "Clock Time", {"Default", "Pagi", "Siang", "Sore", "Malam"}, Cfg.ClockTime, function(v)
    Cfg.ClockTime = v
    local Lighting = game:GetService("Lighting")
    if v == "Pagi" then
        Lighting.ClockTime = 6; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(160,160,180)
    elseif v == "Siang" then
        Lighting.ClockTime = 14; Lighting.Brightness = 3; Lighting.OutdoorAmbient = Color3.fromRGB(140,140,140)
    elseif v == "Sore" then
        Lighting.ClockTime = 18; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(180,120,90)
    elseif v == "Malam" then
        Lighting.ClockTime = 0; Lighting.Brightness = 1; Lighting.OutdoorAmbient = Color3.fromRGB(30,30,50)
    else
        Lighting.ClockTime = 14; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

-- ==========================================
-- LOW GRAVITY
-- ==========================================
local LOW_GRAVITY_VALUE = 2

local function applyLowGravity(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if not _G.__LG_Original then
        _G.__LG_Original = {
            JumpPower = hum.JumpPower,
            HipHeight = hum.HipHeight,
            UseJumpPower = hum.UseJumpPower,
        }
    end

    local gravity = workspace.Gravity
    local lift = gravity - LOW_GRAVITY_VALUE
    if lift < 0 then lift = 0 end

    if _G.__LG_Force then pcall(function() _G.__LG_Force:Destroy() end) end
    local bf = Instance.new("BodyForce")
    bf.Force = Vector3.new(0, hrp:GetMass() * lift, 0)
    bf.Parent = hrp
    _G.__LG_Force = bf

    hum.HipHeight = _G.__LG_Original.HipHeight + 2
    hum.UseJumpPower = true
    hum.JumpPower = 100
end

local function removeLowGravity()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and _G.__LG_Original then
            hum.JumpPower = _G.__LG_Original.JumpPower
            hum.HipHeight = _G.__LG_Original.HipHeight
            hum.UseJumpPower = _G.__LG_Original.UseJumpPower
        end
    end
    if _G.__LG_Force then pcall(function() _G.__LG_Force:Destroy() end); _G.__LG_Force = nil end
    _G.__LG_Original = nil
end

Toggle(WorldTab, "Low Gravity", Cfg.LowGravity, function(v)
    Cfg.LowGravity = v
    if v then
        applyLowGravity(LocalPlayer.Character)
    else
        removeLowGravity()
    end
end)

RunService.Heartbeat:Connect(function()
    if not Cfg.LowGravity then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if _G.__LG_Force and _G.__LG_Force.Parent ~= hrp then
        applyLowGravity(char)
    end

    local vel = hrp.AssemblyLinearVelocity
    if vel.Y < -15 then
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -15, vel.Z)
    end
end)

ListBox(WorldTab, "Teleport ke Pemain", function()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end, function(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if _G.__SmoothTeleport then
            _G.__SmoothTeleport(target.Character.HumanoidRootPart.Position, 1.7)
        end
    end
end)

-- ==========================================
-- SAVE LOCATION SYSTEM
-- ==========================================
Section(WorldTab, "Saved Locations")

local LocationsFile = "LiteHack_Locations.json"
local SavedLocations = {}

local function loadLocations()
    SavedLocations = {}
    if isfile and isfile(LocationsFile) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(LocationsFile))
        end)
        if ok and type(data) == "table" then
            SavedLocations = data
        end
    end
end

local function saveLocations()
    if writefile then
        pcall(function()
            writefile(LocationsFile, HttpService:JSONEncode(SavedLocations))
        end)
    end
end

loadLocations()

local locNameBox = TextBox(WorldTab, "Nama lokasi...", function(text) end)

Button(WorldTab, "💾 SAVE LOKASI SEKARANG", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local name = locNameBox.Text
    if not name or name == "" then
        name = "Lokasi_" .. os.date("%H%M%S")
    end
    table.insert(SavedLocations, {
        name = name,
        x = math.floor(hrp.Position.X),
        y = math.floor(hrp.Position.Y),
        z = math.floor(hrp.Position.Z),
        game = game.PlaceId,
        time = os.time()
    })
    saveLocations()
    locNameBox.Text = ""
end)

local locRow = make("Frame", {
    Size = UDim2.new(1, 0, 0, 160),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Parent = WorldTab
})
corner(locRow, 8)
make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 20),
    Position = UDim2.new(0, 10, 0, 4),
    BackgroundTransparency = 1,
    Text = "📍 Lokasi Tersimpan",
    TextColor3 = Color3.fromRGB(230, 230, 240),
    TextSize = 12,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = locRow
})
local locScroll = make("ScrollingFrame", {
    Size = UDim2.new(1, -20, 0, 128),
    Position = UDim2.new(0, 10, 0, 26),
    BackgroundColor3 = Color3.fromRGB(20, 20, 28),
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = locRow
})
corner(locScroll, 6)
make("UIListLayout", {Padding = UDim.new(0, 2), Parent = locScroll})
padding(locScroll, 4)

local function refreshLocList()
    for _, c in ipairs(locScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for i, loc in ipairs(SavedLocations) do
        local row = make("Frame", {
            Size = UDim2.new(1, -8, 0, 26),
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            BorderSizePixel = 0,
            Parent = locScroll
        })
        corner(row, 4)

        make("TextLabel", {
            Size = UDim2.new(1, -140, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text = loc.name .. " [" .. loc.x .. ", " .. loc.y .. ", " .. loc.z .. "]",
            TextColor3 = Color3.fromRGB(220, 220, 230),
            TextSize = 10,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row
        })

        local tpBtn = make("TextButton", {
            Size = UDim2.new(0, 60, 0, 22),
            Position = UDim2.new(1, -126, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(255, 60, 60),
            Text = "TP",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 11,
            Font = FONT_BOLD,
            AutoButtonColor = false,
            Parent = row
        })
        corner(tpBtn, 4)
        tpBtn.MouseButton1Click:Connect(function()
            if _G.__SmoothTeleport then
                _G.__SmoothTeleport(Vector3.new(loc.x, loc.y, loc.z), 1.7)
            end
        end)

        local delBtn = make("TextButton", {
            Size = UDim2.new(0, 60, 0, 22),
            Position = UDim2.new(1, -64, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(160, 0, 0),
            Text = "DEL",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 11,
            Font = FONT_BOLD,
            AutoButtonColor = false,
            Parent = row
        })
        corner(delBtn, 4)
        delBtn.MouseButton1Click:Connect(function()
            table.remove(SavedLocations, i)
            saveLocations()
            refreshLocList()
        end)
    end
    locScroll.CanvasSize = UDim2.new(0, 0, 0, #SavedLocations * 28 + 10)
end

refreshLocList()
task.spawn(function()
    while locRow.Parent do
        task.wait(1)
        pcall(refreshLocList)
    end
end)

-- ==========================================
-- TAB CONFIG
-- ==========================================
Section(ConfigTab, "UI Theme")
ComboBox(ConfigTab, "Theme", {"Dark", "Light"}, Cfg.Theme, function(v)
    Cfg.Theme = v
    if v == "Light" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
        Content.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        TabScroll.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        Title.TextColor3 = Color3.fromRGB(200, 40, 40)
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Content.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        TabScroll.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        Title.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

Section(ConfigTab, "Save / Load")
Button(ConfigTab, "💾 SAVE CONFIG", function()
    pcall(function()
        local data = HttpService:JSONEncode(Cfg)
        if writefile then writefile("LiteHack_Config.json", data) end
    end)
end)

Button(ConfigTab, "📂 LOAD CONFIG", function()
    pcall(function()
        if isfile and isfile("LiteHack_Config.json") then
            local data = HttpService:JSONDecode(readfile("LiteHack_Config.json"))
            for k, v in pairs(data) do
                if Cfg[k] ~= nil then Cfg[k] = v end
            end
        end
    end)
end)

-- ==========================================
-- DRAG
-- ==========================================
local function makeDraggable(frame, handle)
    local dragging, startPos, startInput = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame, TopBar)
makeDraggable(IconBtn, IconBtn)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
IconBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ==========================================
-- FOV CIRCLE + AIM LINE + CROSSHAIR (SMALL & RAPAT)
-- ==========================================
local FOVGui = make("ScreenGui", {Name = "LiteHack_FOV", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = getGuiParent()})
local FOVCircle = make("Frame", {
    Size = UDim2.new(0, 300, 0, 300),
    Position = UDim2.new(0.5, -150, 0.5, -150),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = FOVGui
})
corner(FOVCircle, 9999)
stroke(FOVCircle, Color3.fromRGB(255, 80, 80), 2, 0.3)

local AimLineGui = make("Frame", {
    Size = UDim2.new(0, 2, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 80, 80),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Visible = false,
    Parent = FOVGui
})

-- CROSSHAIR SMALL & RAPAT
local CrosshairDot = make("Frame", {
    Size = UDim2.new(0, 3, 0, 3),
    Position = UDim2.new(0.5, -1.5, 0.5, -1.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 100,
    Parent = FOVGui
})
corner(CrosshairDot, 2)
stroke(CrosshairDot, Color3.fromRGB(0, 0, 0), 1, 0.5)

local CrosshairLines = {}
for i = 1, 4 do
    local line = make("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
        Parent = FOVGui
    })
    stroke(line, Color3.fromRGB(0, 0, 0), 1, 0.5)
    table.insert(CrosshairLines, line)
end

RunService.RenderStepped:Connect(function()
    if Cfg.ShowCrosshair then
        local vs = Camera.ViewportSize
        local cx = vs.X / 2
        local cy = vs.Y / 2
        CrosshairDot.Visible = true
        CrosshairDot.Position = UDim2.new(0, cx - 1.5, 0, cy - 1.5)

        -- 4 garis kecil: panjang 5px, jarak 4px dari center
        -- Atas
        CrosshairLines[1].Size = UDim2.new(0, 1, 0, 5)
        CrosshairLines[1].Position = UDim2.new(0, cx - 0.5, 0, cy - 9)
        CrosshairLines[1].Visible = true
        -- Bawah
        CrosshairLines[2].Size = UDim2.new(0, 1, 0, 5)
        CrosshairLines[2].Position = UDim2.new(0, cx - 0.5, 0, cy + 4)
        CrosshairLines[2].Visible = true
        -- Kiri
        CrosshairLines[3].Size = UDim2.new(0, 5, 0, 1)
        CrosshairLines[3].Position = UDim2.new(0, cx - 9, 0, cy - 0.5)
        CrosshairLines[3].Visible = true
        -- Kanan
        CrosshairLines[4].Size = UDim2.new(0, 5, 0, 1)
        CrosshairLines[4].Position = UDim2.new(0, cx + 4, 0, cy - 0.5)
        CrosshairLines[4].Visible = true
    else
        CrosshairDot.Visible = false
        for _, l in ipairs(CrosshairLines) do l.Visible = false end
    end
end)

-- ==========================================
-- ESP ENGINE
-- ==========================================
local ESPGui = make("ScreenGui", {Name = "LiteHack_ESP", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = getGuiParent()})
local ESPData = {}

local function isEnemy(model)
    local plr = Players:GetPlayerFromCharacter(model)
    if not plr then return true end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end
    return true
end

local function isTeam(model)
    local plr = Players:GetPlayerFromCharacter(model)
    if not plr then return false end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    return false
end

local function createESP(model)
    local box = make("Frame", {
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
        ZIndex = 3, Parent = ESPGui, Name = "Box"
    })
    local c1 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c2 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c3 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c4 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c5 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c6 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c7 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})
    local c8 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = box})

    local name = make("TextLabel", {
        BackgroundTransparency = 1, TextSize = 13, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.white, TextStrokeTransparency = 0.4, Visible = false,
        ZIndex = 10, Parent = ESPGui
    })

    local weapon = make("TextLabel", {
        BackgroundTransparency = 1, TextSize = 12, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 220, 100), TextStrokeTransparency = 0.4, Visible = false,
        ZIndex = 10, Parent = ESPGui
    })

    local dist = make("TextLabel", {
        BackgroundTransparency = 1, TextSize = 12, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(220,220,220), TextStrokeTransparency = 0.5, Visible = false,
        ZIndex = 10, Parent = ESPGui
    })

    local pic = make("Frame", {
        Size = UDim2.new(0, 42, 0, 42),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(40,40,50),
        Visible = false, ZIndex = 5, Parent = ESPGui
    })
    corner(pic, 21)
    stroke(pic, Color3.fromRGB(255,80,80), 2, 0.2)
    local img = make("ImageLabel", {
        Size = UDim2.new(1,-6,1,-6), Position = UDim2.new(0,3,0,3),
        BackgroundTransparency = 1, Visible = false, ZIndex = 6, Parent = pic
    })
    corner(img, 19)

    local healthBar = make("Frame", {
        Size = UDim2.new(0, 6, 0, 40),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0, Visible = false, ZIndex = 7, Parent = ESPGui
    })
    corner(healthBar, 3)
    stroke(healthBar, Color3.fromRGB(0,0,0), 1, 0.3)
    local healthFill = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0,255,80),
        BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
        ZIndex = 8, Parent = healthBar
    })
    corner(healthFill, 3)

    local skeletonParts = {}
    for i = 1, 9 do
        table.insert(skeletonParts, make("Frame", {
            BackgroundColor3 = Color3.fromRGB(255,80,80), BorderSizePixel = 0,
            Visible = false, ZIndex = 6, Parent = ESPGui, Size = UDim2.new(0,0,0,0)
        }))
    end

    local line = make("Frame", {
        BackgroundColor3 = Color3.fromRGB(255,80,80), BorderSizePixel = 0,
        Size = UDim2.new(0,2,0,0), AnchorPoint = Vector2.new(0.5,1),
        Visible = false, ZIndex = 4, Parent = ESPGui
    })

    return {
        Box = box, Corners = {c1,c2,c3,c4,c5,c6,c7,c8},
        Name = name, Weapon = weapon, Dist = dist, Pic = pic, Img = img,
        HealthBar = healthBar, HealthFill = healthFill,
        Skeleton = skeletonParts, Line = line
    }
end

local function destroyESP(data)
    for _, v in pairs(data) do
        if typeof(v) == "Instance" then pcall(function() v:Destroy() end)
        elseif typeof(v) == "table" then
            for _, x in ipairs(v) do pcall(function() x:Destroy() end) end
        end
    end
end

local ValidEntities = {}
task.spawn(function()
    while task.wait(0.4) do
        local list = {}
        local aliveModels = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character.Parent then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    table.insert(list, p.Character)
                    aliveModels[p.Character] = true
                end
            end
        end
        ValidEntities = list
        for model, data in pairs(ESPData) do
            if not aliveModels[model] or not model.Parent then
                destroyESP(data)
                ESPData[model] = nil
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if p.Character and ESPData[p.Character] then
        destroyESP(ESPData[p.Character])
        ESPData[p.Character] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    for model, data in pairs(ESPData) do
        destroyESP(data)
        ESPData[model] = nil
    end
end)

local R15 = {"Head","UpperTorso","LowerTorso","LeftHand","RightHand","LeftLowerArm","RightLowerArm","LeftUpperArm","RightUpperArm","LeftFoot","RightFoot","LeftLowerLeg","RightLowerLeg","LeftUpperLeg","RightUpperLeg"}
local R6 = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}

local function pos2d(part)
    if not part then return nil end
    local p, on = Camera:WorldToViewportPoint(part.Position)
    if not on then return nil end
    return Vector2.new(p.X, p.Y)
end

local function drawLine(frame, a, b)
    if not a or not b then frame.Visible = false; return end
    frame.Visible = true
    local dist = (b - a).Magnitude
    local center = (a + b) / 2
    local ang = math.atan2(b.Y - a.Y, b.X - a.X)
    frame.Size = UDim2.new(0, dist, 0, 1)
    frame.Position = UDim2.new(0, center.X, 0, center.Y)
    frame.Rotation = math.deg(ang)
end

RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position

    for _, model in ipairs(ValidEntities) do
        local hum = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        local head = model:FindFirstChild("Head")
        if not hum or not root or not head or hum.Health <= 0 or not model.Parent then
            if ESPData[model] then
                destroyESP(ESPData[model])
                ESPData[model] = nil
            end
            continue
        end

        local isE = isEnemy(model)
        local isT = isTeam(model)
        local showESP = (isE and Cfg.ESPEnemy) or (isT and Cfg.ESPTeam)
        if not showESP then
            if ESPData[model] then
                local d = ESPData[model]
                d.Box.Visible = false; d.Name.Visible = false; d.Weapon.Visible = false
                d.Dist.Visible = false
                d.Pic.Visible = false; d.HealthBar.Visible = false; d.Line.Visible = false
                for _, s in ipairs(d.Skeleton) do s.Visible = false end
            end
            continue
        end

        local d = ESPData[model] or createESP(model)
        ESPData[model] = d
        local color = Cfg.ESPColor

        local topLeft = pos2d(head)
        local isR15 = model:FindFirstChild("UpperTorso") ~= nil
        local footName = isR15 and "LeftFoot" or "Left Leg"
        local foot = model:FindFirstChild(footName)
        local footPos = pos2d(foot)

        if topLeft and footPos then
            local height = (footPos.Y - topLeft.Y) + 16
            local width = height * 0.55
            d.Box.Position = UDim2.new(0, topLeft.X - width/2, 0, topLeft.Y - 8)
            d.Box.Size = UDim2.new(0, width, 0, height)
            d.Box.Visible = Cfg.ESPBox
            for _, c in ipairs(d.Corners) do c.BackgroundColor3 = color end

            d.Dist.Position = UDim2.new(0, topLeft.X, 0, topLeft.Y + height + 4)
            d.Dist.Size = UDim2.new(0, 200, 0, 14)
            d.Dist.AnchorPoint = Vector2.new(0.5, 0)
            local meters = myPos and math.floor((myPos - root.Position).Magnitude) or 0
            d.Dist.Text = meters .. " m"
            d.Dist.Visible = Cfg.ESPDistance

            d.Name.Position = UDim2.new(0, topLeft.X, 0, topLeft.Y - 26)
            d.Name.Size = UDim2.new(0, 220, 0, 16)
            d.Name.AnchorPoint = Vector2.new(0.5, 0)
            d.Name.Text = model.Name
            d.Name.TextColor3 = color
            d.Name.Visible = Cfg.ESPName

            local weaponName = ""
            local tool = model:FindFirstChildOfClass("Tool")
            if tool then weaponName = tool.Name end
            d.Weapon.Position = UDim2.new(0, topLeft.X, 0, topLeft.Y - 46)
            d.Weapon.Size = UDim2.new(0, 220, 0, 14)
            d.Weapon.AnchorPoint = Vector2.new(0.5, 0)
            d.Weapon.Text = weaponName
            d.Weapon.TextColor3 = Color3.fromRGB(255, 220, 100)
            d.Weapon.Visible = Cfg.ESPWeapon and weaponName ~= ""

            local picTopY = topLeft.Y - 93
            local picCenterY = picTopY + 21

            if Cfg.ESPPicture then
                d.Pic.Visible = true
                d.Pic.Size = UDim2.new(0, 42, 0, 42)
                d.Pic.Position = UDim2.new(0, topLeft.X - 21, 0, picTopY)
                d.Img.Visible = true
                local plr = Players:GetPlayerFromCharacter(model)
                if plr then
                    local ok, thumb = pcall(function()
                        return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    end)
                    if ok and thumb then d.Img.Image = thumb end
                else
                    d.Img.Visible = false
                end
            else
                d.Pic.Visible = false
            end

            if Cfg.ESPLine then
                local screenTop = Vector2.new(Camera.ViewportSize.X / 2, 0)
                local targetPt = Vector2.new(topLeft.X, picCenterY)
                d.Line.Visible = true
                d.Line.ZIndex = 4
                local diff = targetPt - screenTop
                local dist2 = diff.Magnitude
                local ang = math.atan2(diff.Y, diff.X)
                d.Line.Size = UDim2.new(0, dist2, 0, 1)
                d.Line.Position = UDim2.new(0, screenTop.X, 0, screenTop.Y)
                d.Line.Rotation = math.deg(ang)
                d.Line.BackgroundColor3 = color
            else
                d.Line.Visible = false
            end

            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            d.HealthBar.Visible = Cfg.ESPHealth
            d.HealthBar.Position = UDim2.new(0, topLeft.X + (width/2) + 4, 0, topLeft.Y - 8)
            d.HealthBar.Size = UDim2.new(0, 6, 0, height)
            local hcol
            if hp > 0.7 then hcol = Color3.fromRGB(0, 220, 60)
            elseif hp > 0.4 then hcol = Color3.fromRGB(255, 150, 0)
            else hcol = Color3.fromRGB(160, 0, 0) end
            d.HealthFill.BackgroundColor3 = hcol
            d.HealthFill.Size = UDim2.new(1, 0, hp, 0)

            if Cfg.ESPSkeleton then
                local parts = {}
                local bones = {}
                if isR15 then
                    for _, k in ipairs(R15) do parts[k] = pos2d(model:FindFirstChild(k)) end
                    bones = {
                        {parts.Head, parts.UpperTorso},
                        {parts.UpperTorso, parts.LowerTorso},
                        {parts.UpperTorso, parts.LeftUpperArm}, {parts.LeftUpperArm, parts.LeftLowerArm}, {parts.LeftLowerArm, parts.LeftHand},
                        {parts.UpperTorso, parts.RightUpperArm}, {parts.RightUpperArm, parts.RightLowerArm}, {parts.RightLowerArm, parts.RightHand},
                        {parts.LowerTorso, parts.LeftUpperLeg},
                    }
                else
                    for _, k in ipairs(R6) do parts[k] = pos2d(model:FindFirstChild(k)) end
                    bones = {
                        {parts.Head, parts.Torso},
                        {parts.Torso, parts["Left Arm"]}, {parts.Torso, parts["Right Arm"]},
                        {parts.Torso, parts["Left Leg"]}, {parts.Torso, parts["Right Leg"]},
                    }
                end
                for i = 1, 9 do
                    if bones[i] then
                        drawLine(d.Skeleton[i], bones[i][1], bones[i][2])
                        d.Skeleton[i].BackgroundColor3 = color
                        d.Skeleton[i].Visible = true
                    else
                        d.Skeleton[i].Visible = false
                    end
                end
            else
                for _, s in ipairs(d.Skeleton) do s.Visible = false end
            end
        end
    end
end)

-- ==========================================
-- ESP BOM (PlantedC4)
-- ==========================================
local BombGui = make("ScreenGui", {Name = "LiteHack_Bomb", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = getGuiParent()})
local BombBox = make("Frame", {
    Size = UDim2.new(0, 100, 0, 100),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 3,
    Parent = BombGui
})
local bc1 = make("Frame", {Size = UDim2.new(0, 15, 0, 3), BackgroundColor3 = Color3.fromRGB(255, 40, 40), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc2 = make("Frame", {Size = UDim2.new(0, 3, 0, 15), BackgroundColor3 = Color3.fromRGB(255, 40, 40), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc3 = make("Frame", {Size = UDim2.new(0, 15, 0, 3), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc4 = make("Frame", {Size = UDim2.new(0, 3, 0, 15), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc5 = make("Frame", {Size = UDim2.new(0, 15, 0, 3), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc6 = make("Frame", {Size = UDim2.new(0, 3, 0, 15), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc7 = make("Frame", {Size = UDim2.new(0, 15, 0, 3), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})
local bc8 = make("Frame", {Size = UDim2.new(0, 3, 0, 15), BackgroundColor3 = Color3.fromRGB(255, 40, 40), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4, Parent = BombBox})

local BombLabel = make("TextLabel", {
    Size = UDim2.new(0, 200, 0, 18),
    BackgroundTransparency = 1,
    Text = "💣 BOM",
    TextColor3 = Color3.fromRGB(255, 60, 60),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextStrokeTransparency = 0.3,
    Visible = false,
    ZIndex = 10,
    Parent = BombGui
})

local BombDist = make("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    BackgroundTransparency = 1,
    Text = "0 m",
    TextColor3 = Color3.fromRGB(255, 200, 200),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextStrokeTransparency = 0.4,
    Visible = false,
    ZIndex = 10,
    Parent = BombGui
})

RunService.RenderStepped:Connect(function()
    if not Cfg.ESPBomb then
        BombBox.Visible = false
        BombLabel.Visible = false
        BombDist.Visible = false
        return
    end

    local c4 = workspace:FindFirstChild("PlantedC4")
    if not c4 then
        BombBox.Visible = false
        BombLabel.Visible = false
        BombDist.Visible = false
        return
    end

    -- Ambil posisi bom
    local bombPos
    local ok, pivot = pcall(function() return c4:GetPivot().Position end)
    if ok and pivot then
        bombPos = pivot
    else
        -- Fallback: cari BasePart pertama di dalamnya
        for _, child in ipairs(c4:GetDescendants()) do
            if child:IsA("BasePart") then
                bombPos = child.Position
                break
            end
        end
    end

    if not bombPos then
        BombBox.Visible = false
        BombLabel.Visible = false
        BombDist.Visible = false
        return
    end

    -- Project ke layar
    local screenPos, onScreen = Camera:WorldToViewportPoint(bombPos)
    if not onScreen then
        BombBox.Visible = false
        BombLabel.Visible = false
        BombDist.Visible = false
        return
    end

    -- Hitung ukuran kotak berdasarkan jarak (makin dekat, makin besar)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local meters = 0
    if myRoot then
        meters = math.floor((myRoot.Position - bombPos).Magnitude)
    end

    local size = math.clamp(2000 / math.max(meters, 5), 40, 200)
    local sx = screenPos.X
    local sy = screenPos.Y

    BombBox.Position = UDim2.new(0, sx - size/2, 0, sy - size/2)
    BombBox.Size = UDim2.new(0, size, 0, size)
    BombBox.Visible = true

    BombLabel.Position = UDim2.new(0, sx, 0, sy - size/2 - 22)
    BombLabel.AnchorPoint = Vector2.new(0.5, 0)
    BombLabel.Visible = true

    BombDist.Position = UDim2.new(0, sx, 0, sy + size/2 + 2)
    BombDist.AnchorPoint = Vector2.new(0.5, 0)
    BombDist.Text = meters .. " m"
    BombDist.Visible = true
end)

-- ==========================================
-- AIMBOT + AUTO FIRE
-- ==========================================
local LockedTarget = nil
local lastFireTime = 0
local FIRE_INTERVAL = 0.08
local fireHoldActive = false
local lastFireToggle = 0
local FIRE_TOGGLE_DURATION = 0.05

local function isVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local r = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 2000, params)
    return r == nil or r.Instance:IsDescendantOf(part.Parent)
end

local function getAimPart(model)
    if not model then return nil end
    local map = {Head = "Head", Neck = "Neck", Chest = "UpperTorso"}
    local targetName = map[Cfg.AimTarget] or "Head"
    local part = model:FindFirstChild(targetName)
    if part then return part end
    return model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
end

local function validTarget(model)
    if not model or not model.Parent then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if Cfg.AimTeamCheck and isTeam(model) then return false end
    local rootPart = model:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and rootPart then
        local d = (myRoot.Position - rootPart.Position).Magnitude
        if d > Cfg.AimDistance then return false end
    end
    if Cfg.AimWallCheck then
        local p = getAimPart(model)
        if not p or not isVisible(p) then return false end
    end
    return true
end

local function pickTarget()
    local best, bestDist = nil, (Cfg.AimMode == "FOV") and Cfg.AimFOVSize or math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, model in ipairs(ValidEntities) do
        if validTarget(model) then
            local p = getAimPart(model)
            if p then
                local pos, on = Camera:WorldToViewportPoint(p.Position)
                if on then
                    local d = (screenCenter - Vector2.new(pos.X, pos.Y)).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = model
                    end
                end
            end
        end
    end
    return best
end

local function getHoldFireTarget()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(screenCenter.X, screenCenter.Y)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(ray.Origin, ray.Direction * 5000, params)
    if not result then return nil end
    local hit = result.Instance
    local hitModel = hit:FindFirstAncestorOfClass("Model")
    if not hitModel then return nil end
    local plr = Players:GetPlayerFromCharacter(hitModel)
    if not plr or plr == LocalPlayer then return nil end
    if Cfg.AimTeamCheck and isTeam(hitModel) then return nil end
    local hum = hitModel:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    if Cfg.AimMode == "FOV" then
        local targetPart = getAimPart(hitModel)
        if targetPart then
            local pos, on = Camera:WorldToViewportPoint(targetPart.Position)
            if on then
                local d = (screenCenter - Vector2.new(pos.X, pos.Y)).Magnitude
                if d > Cfg.AimFOVSize then return nil end
            end
        end
    end
    return hitModel, hum
end

local function getEquippedTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

local function holdFireToggle()
    local tool = getEquippedTool()
    if not tool then return end
    local now = tick()
    if (now - lastFireToggle) < FIRE_TOGGLE_DURATION then return end
    lastFireToggle = now
    pcall(function()
        if fireHoldActive then
            tool:Deactivate()
        else
            tool:Activate()
        end
    end)
    fireHoldActive = not fireHoldActive
end

RunService.RenderStepped:Connect(function()
    if Cfg.Aimbot and Cfg.AimFOV then
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0, Cfg.AimFOVSize * 2, 0, Cfg.AimFOVSize * 2)
        FOVCircle.Position = UDim2.new(0.5, -Cfg.AimFOVSize, 0.5, -Cfg.AimFOVSize)
    else
        FOVCircle.Visible = false
    end

    if Cfg.AutoFire then
        local targetModel, targetHum = getHoldFireTarget()
        if targetModel and targetHum and targetHum.Health > 0 then
            holdFireToggle()
        else
            local tool = getEquippedTool()
            if tool and fireHoldActive then
                pcall(function() tool:Deactivate() end)
                fireHoldActive = false
            end
        end
    else
        if fireHoldActive then
            local tool = getEquippedTool()
            if tool then pcall(function() tool:Deactivate() end) end
            fireHoldActive = false
        end
    end

    if not Cfg.Aimbot then
        LockedTarget = nil
        AimLineGui.Visible = false
        return
    end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    LockedTarget = pickTarget()

    if LockedTarget then
        local p = getAimPart(LockedTarget)
        if p then
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            if Cfg.AimLine then
                local screenPos = Camera:WorldToViewportPoint(p.Position)
                AimLineGui.Visible = true
                AimLineGui.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
                local diff = Vector2.new(screenPos.X - screenCenter.X, screenPos.Y - screenCenter.Y)
                AimLineGui.Size = UDim2.new(0, 2, 0, diff.Magnitude)
                AimLineGui.Rotation = math.deg(math.atan2(diff.Y, diff.X)) - 90
            else
                AimLineGui.Visible = false
            end

            local smoothAlpha = math.clamp(Cfg.AimSmoothness / 100, 0.01, 1)

            if Cfg.AimTrigger == "Camera" then
                local targetCF = CFrame.lookAt(Camera.CFrame.Position, p.Position)
                if Cfg.AimSmoothness >= 100 then
                    Camera.CFrame = targetCF
                else
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, smoothAlpha)
                end
            elseif Cfg.AimTrigger == "Fire (Snap)" then
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local targetCF = CFrame.lookAt(Camera.CFrame.Position, p.Position)
                    if Cfg.AimSmoothness >= 100 then
                        Camera.CFrame = targetCF
                    else
                        Camera.CFrame = Camera.CFrame:Lerp(targetCF, smoothAlpha)
                    end
                end
            end
        end
    else
        AimLineGui.Visible = false
    end
end)

-- ==========================================
-- SPEED RUN
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Cfg.SpeedRun then
        hum.WalkSpeed = 16 * (Cfg.SpeedRunValue / 100)
    end
end)

-- ==========================================
-- WALL HACK (NOCLIP)
-- ==========================================
RunService.Stepped:Connect(function()
    if Cfg.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- ==========================================
-- GUN MODS
-- ==========================================
local OriginalAttrs = {}
local OriginalValues = {}
local OriginalTables = {}
local isSnapshotted = false

local function snapshotTool(tool)
    if OriginalAttrs[tool] then return end
    local attrs = {}
    local attrList = {"TotalAmmo","NewMax","magazineSize","_ammo","spread","recoilMax","recoilMin","reloadTime","rateOfFire"}
    for _, name in ipairs(attrList) do
        local v = tool:GetAttribute(name)
        if v ~= nil then attrs[name] = v end
    end
    OriginalAttrs[tool] = attrs
    for _, obj in pairs(tool:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            OriginalValues[obj] = obj.Value
        end
    end
end

local function snapshotGCTables()
    if isSnapshotted then return end
    isSnapshotted = true
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                local hasKey = rawget(v, "Ammo") or rawget(v, "MaxAmmo") or rawget(v, "ClipSize")
                    or rawget(v, "RPM") or rawget(v, "FireRate") or rawget(v, "rateOfFire")
                if hasKey then
                    local snap = {}
                    local keys = {"Ammo","CurrentAmmo","MaxAmmo","StoredAmmo","ClipSize","Magazine","RPM","FireRate","rateOfFire","Spread","MaxSpread","Recoil","Kickback"}
                    for _, k in ipairs(keys) do
                        local val = rawget(v, k)
                        if type(val) == "number" then snap[k] = val end
                    end
                    OriginalTables[v] = snap
                end
            end
        end
    end)
end

function restoreAll()
    for tool, attrs in pairs(OriginalAttrs) do
        if tool and tool.Parent then
            for name, value in pairs(attrs) do
                pcall(function() tool:SetAttribute(name, value) end)
            end
        end
    end
    OriginalAttrs = {}
    for obj, value in pairs(OriginalValues) do
        if obj and obj.Parent then pcall(function() obj.Value = value end) end
    end
    OriginalValues = {}
    for tbl, snap in pairs(OriginalTables) do
        if type(tbl) == "table" then
            for k, v in pairs(snap) do pcall(function() tbl[k] = v end) end
        end
    end
    OriginalTables = {}
    isSnapshotted = false
end

local function ScanValueMods(tool)
    pcall(function()
        snapshotTool(tool)
        local function SetSafe(attr, value)
            if tool:GetAttribute(attr) ~= nil and tool:GetAttribute(attr) ~= value then
                tool:SetAttribute(attr, value)
            end
        end
        if Cfg.UnlimitedAmmo then
            SetSafe("TotalAmmo", 999999); SetSafe("NewMax", 999999)
            SetSafe("magazineSize", 999999); SetSafe("_ammo", 999999)
        end
        if Cfg.RapidFire or Cfg.UnlimitedAmmo then SetSafe("spread", 0) end
        if Cfg.RapidFire then SetSafe("reloadTime", 0.05); SetSafe("rateOfFire", 2500) end
        for _, obj in pairs(tool:GetDescendants()) do
            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                local name = obj.Name:lower()
                if Cfg.UnlimitedAmmo and (name:find("ammo") or name:find("clip") or name:find("mag")) then
                    obj.Value = 999999
                elseif Cfg.RapidFire and (name:find("firerate") or name:find("rpm") or name:find("rate")) then
                    if name:find("rpm") then obj.Value = 2500 else obj.Value = 60 / 2500 end
                end
            end
        end
    end)
end

local wasGunModActive = false
RunService.RenderStepped:Connect(function()
    local isActive = Cfg.RapidFire or Cfg.UnlimitedAmmo
    if isActive and not wasGunModActive then snapshotGCTables() end
    if not isActive and wasGunModActive then restoreAll() end
    wasGunModActive = isActive
    if not isActive then return end
    if LocalPlayer.Character then
        for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
            if t:IsA("Tool") or t:IsA("Model") then ScanValueMods(t) end
        end
    end
    for _, v in ipairs(Camera:GetChildren()) do
        if v:IsA("Model") then ScanValueMods(v) end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Cfg.UnlimitedAmmo or Cfg.RapidFire then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "MaxAmmo") or rawget(v, "ClipSize") or rawget(v, "RPM") or rawget(v, "FireRate") or rawget(v, "rateOfFire") then
                            if Cfg.UnlimitedAmmo then
                                if rawget(v, "Ammo") and type(v.Ammo) == "number" then v.Ammo = 999999 end
                                if rawget(v, "CurrentAmmo") and type(v.CurrentAmmo) == "number" then v.CurrentAmmo = 999999 end
                                if rawget(v, "MaxAmmo") and type(v.MaxAmmo) == "number" then v.MaxAmmo = 999999 end
                                if rawget(v, "StoredAmmo") and type(v.StoredAmmo) == "number" then v.StoredAmmo = 999999 end
                                if rawget(v, "ClipSize") and type(v.ClipSize) == "number" then v.ClipSize = 999999 end
                                if rawget(v, "Magazine") and type(v.Magazine) == "number" then v.Magazine = 999999 end
                            end
                            if Cfg.RapidFire then
                                if rawget(v, "RPM") and type(v.RPM) == "number" then v.RPM = 2500 end
                                if rawget(v, "FireRate") and type(v.FireRate) == "number" then v.FireRate = 60 / 2500 end
                                if rawget(v, "rateOfFire") and type(v.rateOfFire) == "number" then v.rateOfFire = 2500 end
                            end
                            if rawget(v, "Spread") then v.Spread = 0 end
                            if rawget(v, "MaxSpread") then v.MaxSpread = 0 end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- NO RECOIL
-- ==========================================
local RecoilAttrs = {}
local RecoilValues = {}
local RecoilTables = {}
local recoilSnapshotted = false

local RECOIL_ATTR_NAMES = {
    "Recoil","recoil","RecoilAmount","recoilAmount","RecoilMax","recoilMax","RecoilMin","recoilMin",
    "RecoilX","RecoilY","VerticalRecoil","HorizontalRecoil","CameraRecoil","GunRecoil","WeaponRecoil",
    "Kickback","kickback","KickBack","Spread","spread","MaxSpread","MinSpread","BulletSpread",
    "Shake","CameraShake","ViewKick","viewKick"
}
local RECOIL_ATTR_LOWER = {}
for _, n in ipairs(RECOIL_ATTR_NAMES) do RECOIL_ATTR_LOWER[n:lower()] = true end

local function isRecoilKey(key)
    if type(key) ~= "string" then return false end
    local k = key:lower()
    if RECOIL_ATTR_LOWER[k] then return true end
    if k:find("recoil") or k:find("kickback") or k:find("camerashake") or k:find("viewkick") then return true end
    return false
end

local function snapshotRecoilTool(tool)
    if RecoilAttrs[tool] then return end
    local attrs = {}
    for _, name in ipairs(RECOIL_ATTR_NAMES) do
        local v = tool:GetAttribute(name)
        if v ~= nil then attrs[name] = v end
    end
    RecoilAttrs[tool] = attrs
    for _, obj in pairs(tool:GetDescendants()) do
        if (obj:IsA("IntValue") or obj:IsA("NumberValue")) and isRecoilKey(obj.Name) then
            RecoilValues[obj] = obj.Value
        end
    end
end

local function snapshotRecoilGC()
    if recoilSnapshotted then return end
    recoilSnapshotted = true
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                local snap = {}
                local has = false
                for k, val in pairs(v) do
                    if isRecoilKey(k) and type(val) == "number" then
                        snap[k] = val; has = true
                    end
                end
                if has then RecoilTables[v] = snap end
            end
        end
    end)
end

function restoreRecoil()
    for tool, attrs in pairs(RecoilAttrs) do
        if tool and tool.Parent then
            for name, value in pairs(attrs) do
                pcall(function() tool:SetAttribute(name, value) end)
            end
        end
    end
    RecoilAttrs = {}
    for obj, value in pairs(RecoilValues) do
        if obj and obj.Parent then pcall(function() obj.Value = value end) end
    end
    RecoilValues = {}
    for tbl, snap in pairs(RecoilTables) do
        if type(tbl) == "table" then
            for k, v in pairs(snap) do pcall(function() tbl[k] = v end) end
        end
    end
    RecoilTables = {}
    recoilSnapshotted = false
end

local function applyNoRecoilTool(tool)
    pcall(function()
        snapshotRecoilTool(tool)
        for _, name in ipairs(RECOIL_ATTR_NAMES) do
            local v = tool:GetAttribute(name)
            if v ~= nil and type(v) == "number" then tool:SetAttribute(name, 0) end
        end
        for _, obj in pairs(tool:GetDescendants()) do
            if (obj:IsA("IntValue") or obj:IsA("NumberValue")) and isRecoilKey(obj.Name) then
                obj.Value = 0
            end
        end
    end)
end

local wasNoRecoil = false
RunService.RenderStepped:Connect(function()
    local isActive = Cfg.NoRecoil
    if isActive and not wasNoRecoil then snapshotRecoilGC() end
    if not isActive and wasNoRecoil then restoreRecoil() end
    wasNoRecoil = isActive
    if not isActive then return end
    if LocalPlayer.Character then
        for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
            if t:IsA("Tool") or t:IsA("Model") then applyNoRecoilTool(t) end
        end
    end
    for _, v in ipairs(Camera:GetChildren()) do
        if v:IsA("Model") then applyNoRecoilTool(v) end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Cfg.NoRecoil then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        for k, val in pairs(v) do
                            if isRecoilKey(k) and type(val) == "number" then v[k] = 0 end
                        end
                    end
                end
            end)
        end
    end
end)

print("[LiteHack] UI Loaded (v15). Multi Jump removed. Small crosshair. BodyVelocity teleport. Bomb ESP added.")
