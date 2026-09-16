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
    -- Visual
    ESPEnemy = false,
    ESPTeam = false,
    ESPBox = true,
    ESPName = true,
    ESPLine = false,
    ESPHealth = true,
    ESPSkeleton = false,
    ESPDistance = true,
    ESPPicture = false,
    ESPColor = Color3.fromRGB(255, 60, 60),
    -- Aimbot
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
    -- Player
    SpeedRun = false,
    SpeedRunValue = 50,
    MultiJump = false,
    FlyHack = false,
    RapidFire = false,
    UnlimitedAmmo = false,
    WallHack = false,
    -- World
    ClockTime = "Default",
    NoGravity = false,
    -- Config
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
-- FLOATING ICON (SKULL GLOWUP)
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

-- Pulsing glow
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
    Parent = WinGui
})
corner(MainFrame, 14)
stroke(MainFrame, Color3.fromRGB(60, 60, 80), 1.5, 0.2)
padding(MainFrame, 8)

-- TopBar
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

-- TabBar (wrapped horizontal scroll)
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
local TabLayout = make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = TabScroll
})
padding(TabScroll, 6)

-- Content area
local Content = make("Frame", {
    Size = UDim2.new(1, 0, 1, -84),
    Position = UDim2.new(0, 0, 0, 84),
    BackgroundColor3 = Color3.fromRGB(24, 24, 32),
    BorderSizePixel = 0,
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
    local pageLayout = make("UIListLayout", {
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
    local lbl = make("TextLabel", {
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
    local lbl = make("TextLabel", {
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

    btn.MouseButton1Click:Connect(function()
        update(not state, true)
    end)

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

-- ComboBox anti bentrok (ZIndex tinggi + tutup saat klik luar)
local function ComboBox(page, text, options, default, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = page
    })
    corner(row, 8)
    local lbl = make("TextLabel", {
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
            ZIndex = 50,
            Parent = WinGui
        })
        overlay.MouseButton1Click:Connect(closeList)

        listFrame = make("ScrollingFrame", {
            Size = UDim2.new(0, 150, 0, math.min(#options * 26 + 6, 130)),
            Position = UDim2.new(0, 0, 1, 4),
            BackgroundColor3 = Color3.fromRGB(20, 20, 28),
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 60,
            Parent = btn
        })
        corner(listFrame, 6)
        stroke(listFrame, Color3.fromRGB(255, 60, 60), 1, 0.4)
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
                ZIndex = 61,
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

-- ListBox (bisa scroll, anti-bentrok juga)
local function ListBox(page, text, getItems, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = page
    })
    corner(row, 8)
    local lbl = make("TextLabel", {
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
    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
    return btn
end

-- ==========================================
-- CREATE TABS
-- ==========================================
local VisualTab = CreateTab("Visual", "👁")
local AimbotTab = CreateTab("Aimbot", "🎯")
local PlayerTab = CreateTab("Player", "🏃")
local WorldTab  = CreateTab("World", "🌍")
local ConfigTab = CreateTab("Config", "⚙")

-- Default buka Visual
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
Toggle(VisualTab, "Line", Cfg.ESPLine, function(v) Cfg.ESPLine = v end)
Toggle(VisualTab, "Health", Cfg.ESPHealth, function(v) Cfg.ESPHealth = v end)
Toggle(VisualTab, "Skeleton", Cfg.ESPSkeleton, function(v) Cfg.ESPSkeleton = v end)
Toggle(VisualTab, "Distance", Cfg.ESPDistance, function(v) Cfg.ESPDistance = v end)
Toggle(VisualTab, "Picture", Cfg.ESPPicture, function(v) Cfg.ESPPicture = v end)

-- ==========================================
-- TAB AIMBOT
-- ==========================================
Section(AimbotTab, "Aimbot Settings")
Toggle(AimbotTab, "Aimbot", Cfg.Aimbot, function(v) Cfg.Aimbot = v end)
Toggle(AimbotTab, "Team Check", Cfg.AimTeamCheck, function(v) Cfg.AimTeamCheck = v end)
Toggle(AimbotTab, "Wall Check", Cfg.AimWallCheck, function(v) Cfg.AimWallCheck = v end)
ComboBox(AimbotTab, "Mode Aimbot", {"FOV", "360°"}, Cfg.AimMode, function(v) Cfg.AimMode = v end)
ComboBox(AimbotTab, "Mode Trigger", {"Camera", "Fire (Snap)"}, Cfg.AimTrigger, function(v) Cfg.AimTrigger = v end)
Toggle(AimbotTab, "Aim FOV", Cfg.AimFOV, function(v) Cfg.AimFOV = v end)
Slider(AimbotTab, "Size FOV", 20, 600, Cfg.AimFOVSize, "px", function(v) Cfg.AimFOVSize = v end)
Toggle(AimbotTab, "Aim Line", Cfg.AimLine, function(v) Cfg.AimLine = v end)
ComboBox(AimbotTab, "Aim Target", {"Head", "Neck", "Chest"}, Cfg.AimTarget, function(v) Cfg.AimTarget = v end)
Slider(AimbotTab, "Aim Distance", 50, 2000, Cfg.AimDistance, "m", function(v) Cfg.AimDistance = v end)
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

Toggle(PlayerTab, "Multi Jump", Cfg.MultiJump, function(v) Cfg.MultiJump = v end)
Toggle(PlayerTab, "Fly Hack (tahan Jump)", Cfg.FlyHack, function(v) Cfg.FlyHack = v end)

Section(PlayerTab, "Combat")
Toggle(PlayerTab, "Rapid Fire", Cfg.RapidFire, function(v) Cfg.RapidFire = v end)
Toggle(PlayerTab, "Unlimited Ammo", Cfg.UnlimitedAmmo, function(v) Cfg.UnlimitedAmmo = v end)
Toggle(PlayerTab, "Wall Hack (Noclip)", Cfg.WallHack, function(v) Cfg.WallHack = v end)

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
        Lighting.ClockTime = 14
    end
end)

Toggle(WorldTab, "No Gravity", Cfg.NoGravity, function(v)
    Cfg.NoGravity = v
    workspace.Gravity = v and 0 or 196.2
end)

ListBox(WorldTab, "Teleport ke Pemain", function()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end, function(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- ==========================================
-- TAB CONFIG
-- ==========================================
local ThemeState = {Light = false}

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
    local ok = pcall(function()
        local data = HttpService:JSONEncode({
            ESPEnemy = Cfg.ESPEnemy, ESPTeam = Cfg.ESPTeam,
            ESPBox = Cfg.ESPBox, ESPName = Cfg.ESPName, ESPLine = Cfg.ESPLine,
            ESPHealth = Cfg.ESPHealth, ESPSkeleton = Cfg.ESPSkeleton,
            ESPDistance = Cfg.ESPDistance, ESPPicture = Cfg.ESPPicture,
            Aim = Cfg.Aimbot, AimTC = Cfg.AimTeamCheck, AimWC = Cfg.AimWallCheck,
            AimMode = Cfg.AimMode, AimTrigger = Cfg.AimTrigger, AimFOV = Cfg.AimFOV,
            AimFOVSize = Cfg.AimFOVSize, AimLine = Cfg.AimLine, AimTarget = Cfg.AimTarget, AimDist = Cfg.AimDistance,
            SpeedRun = Cfg.SpeedRun, SpeedRunValue = Cfg.SpeedRunValue,
            MultiJump = Cfg.MultiJump, FlyHack = Cfg.FlyHack, RapidFire = Cfg.RapidFire,
            UnlimitedAmmo = Cfg.UnlimitedAmmo, WallHack = Cfg.WallHack,
            ClockTime = Cfg.ClockTime, NoGravity = Cfg.NoGravity, Theme = Cfg.Theme
        })
        if writefile then writefile("LiteHack_Config.json", data) end
    end)
    return ok
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
-- DRAG: WINDOW + FLOATING ICON
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

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- FOV CIRCLE DRAW
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

-- ==========================================
-- ENTITY CACHE
-- ==========================================
local ValidEntities = {}
task.spawn(function()
    while task.wait(0.4) do
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then table.insert(list, p.Character) end
        end
        ValidEntities = list
    end
end)

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

-- ==========================================
-- ESP ENGINE (Box, Name, Line, Health, Skeleton, Distance, Picture)
-- ==========================================
local ESPGui = make("ScreenGui", {Name = "LiteHack_ESP", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = getGuiParent()})
local ESPData = {}

local function createESP(model)
    local box = make("Frame", {
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, Parent = ESPGui,
        Name = "Box"
    })
    -- Corner putus-putus
    local c1 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, Parent = box})
    local c2 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, Parent = box})
    local c3 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Parent = box})
    local c4 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Parent = box})
    local c5 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Parent = box})
    local c6 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Parent = box})
    local c7 = make("Frame", {Size = UDim2.new(0, 10, 0, 2), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Parent = box})
    local c8 = make("Frame", {Size = UDim2.new(0, 2, 0, 10), BackgroundColor3 = Color3.white, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Parent = box})

    local name = make("TextLabel", {
        BackgroundTransparency = 1, TextSize = 13, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.white, TextStrokeTransparency = 0.4, Visible = false, Parent = ESPGui
    })

    local dist = make("TextLabel", {
        BackgroundTransparency = 1, TextSize = 12, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(220,220,220), TextStrokeTransparency = 0.5, Visible = false, Parent = ESPGui
    })

    local pic = make("Frame", {
        Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(40,40,50), Visible = false, Parent = ESPGui
    })
    corner(pic, 18)
    stroke(pic, Color3.fromRGB(255,80,80), 2, 0.2)
    local img = make("ImageLabel", {
        Size = UDim2.new(1,-4,1,-4), Position = UDim2.new(0,2,0,2),
        BackgroundTransparency = 1, Visible = false, Parent = pic
    })
    corner(img, 16)

    local healthBar = make("Frame", {
        Size = UDim2.new(0, 5, 0, 40), BackgroundColor3 = Color3.fromRGB(20,20,20),
        BorderSizePixel = 0, Visible = false, Parent = ESPGui
    })
    corner(healthBar, 2)
    local healthFill = make("Frame", {
        Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,255,80),
        BorderSizePixel = 0, AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0),
        Parent = healthBar
    })
    corner(healthFill, 2)

    local skeletonParts = {}
    for i = 1, 9 do
        table.insert(skeletonParts, make("Frame", {
            BackgroundColor3 = Color3.fromRGB(255,80,80), BorderSizePixel = 0,
            Visible = false, Parent = ESPGui, Size = UDim2.new(0,0,0,0)
        }))
    end

    local line = make("Frame", {
        BackgroundColor3 = Color3.fromRGB(255,80,80), BorderSizePixel = 0,
        Size = UDim2.new(0,2,0,0), AnchorPoint = Vector2.new(0.5,1), Visible = false, Parent = ESPGui
    })

    return {
        Box = box, Corners = {c1,c2,c3,c4,c5,c6,c7,c8},
        Name = name, Dist = dist, Pic = pic, Img = img,
        HealthBar = healthBar, HealthFill = healthFill,
        Skeleton = skeletonParts, Line = line
    }
end

local R15 = {
    Head = "Head", UpperTorso = "UpperTorso", LowerTorso = "LowerTorso",
    LeftHand = "LeftHand", RightHand = "RightHand",
    LeftLowerArm = "LeftLowerArm", RightLowerArm = "RightLowerArm",
    LeftUpperArm = "LeftUpperArm", RightUpperArm = "RightUpperArm",
    LeftFoot = "LeftFoot", RightFoot = "RightFoot",
    LeftLowerLeg = "LeftLowerLeg", RightLowerLeg = "RightLowerLeg",
    LeftUpperLeg = "LeftUpperLeg", RightUpperLeg = "RightUpperLeg"
}
local R6 = {
    Head = "Head", Torso = "Torso",
    LeftArm = "Left Arm", RightArm = "Right Arm",
    LeftLeg = "Left Leg", RightLeg = "Right Leg"
}

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
        if not hum or not root or not head or hum.Health <= 0 then
            if ESPData[model] then
                for _, v in pairs(ESPData[model]) do
                    if typeof(v) == "Instance" then v.Visible = false
                    elseif typeof(v) == "table" then for _, x in ipairs(v) do x.Visible = false end end
                end
            end
            continue
        end

        local isE = isEnemy(model)
        local isT = isTeam(model)
        local showESP = (isE and Cfg.ESPEnemy) or (isT and Cfg.ESPTeam)
        if not showESP then continue end

        local d = ESPData[model] or createESP(model)
        ESPData[model] = d
        local color = Cfg.ESPColor

        -- Box
        local topLeft = pos2d(head)
        local bottom = pos2d(model:FindFirstChild("HumanoidRootPart"))
        local isR15 = model:FindFirstChild("UpperTorso") ~= nil
        local foot = isR15 and model:FindFirstChild("LeftFoot") or model:FindFirstChild("Left Leg")
        local footPos = pos2d(foot)
        if topLeft and footPos then
            local height = (footPos.Y - topLeft.Y) + 16
            local width = height * 0.55
            local boxPos = UDim2.new(0, topLeft.X - width/2, 0, topLeft.Y - 8)
            d.Box.Position = boxPos
            d.Box.Size = UDim2.new(0, width, 0, height)
            d.Box.Visible = Cfg.ESPBox
            for _, c in ipairs(d.Corners) do c.BackgroundColor3 = color end

            -- Name
            d.Name.Position = UDim2.new(0, topLeft.X, 0, topLeft.Y - 26)
            d.Name.Size = UDim2.new(0, 200, 0, 16)
            d.Name.AnchorPoint = Vector2.new(0.5, 0)
            d.Name.Text = model.Name
            d.Name.TextColor3 = color
            d.Name.Visible = Cfg.ESPName

            -- Distance
            d.Dist.Position = UDim2.new(0, topLeft.X, 0, topLeft.Y + height + 4)
            d.Dist.Size = UDim2.new(0, 200, 0, 14)
            d.Dist.AnchorPoint = Vector2.new(0.5, 0)
            local meters = myPos and math.floor((myPos - root.Position).Magnitude) or 0
            d.Dist.Text = meters .. " m"
            d.Dist.Visible = Cfg.ESPDistance

            -- Health
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local hcol = hp > 0.7 and Color3.fromRGB(0,255,80) or (hp > 0.4 and Color3.fromRGB(255,150,0) or Color3.fromRGB(180,0,0))
            d.HealthBar.Position = UDim2.new(0, topLeft.X + width + 4, 0, topLeft.Y - 8)
            d.HealthBar.Size = UDim2.new(0, 5, 0, height)
            d.HealthFill.Size = UDim2.new(1, 0, hp, 0)
            d.HealthFill.BackgroundColor3 = hcol
            d.HealthBar.Visible = Cfg.ESPHealth

            -- Picture
            if Cfg.ESPPicture then
                d.Pic.Visible = true
                d.Pic.Position = UDim2.new(0, topLeft.X - 18, 0, topLeft.Y - 52)
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

            -- Line (dari tengah atas layar ke titik atas picture)
            if Cfg.ESPLine then
                local screenTop = Vector2.new(Camera.ViewportSize.X / 2, 0)
                local targetPt = Vector2.new(topLeft.X, topLeft.Y - (Cfg.ESPPicture and 52 or 8))
                d.Line.Visible = true
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

            -- Skeleton
            if Cfg.ESPSkeleton then
                local parts = {}
                if isR15 then
                    for k in pairs(R15) do parts[k] = pos2d(model:FindFirstChild(k)) end
                    local bones = {
                        {parts.Head, parts.UpperTorso},
                        {parts.UpperTorso, parts.LowerTorso},
                        {parts.UpperTorso, parts.LeftUpperArm}, {parts.LeftUpperArm, parts.LeftLowerArm}, {parts.LeftLowerArm, parts.LeftHand},
                        {parts.UpperTorso, parts.RightUpperArm}, {parts.RightUpperArm, parts.RightLowerArm}, {parts.RightLowerArm, parts.RightHand},
                        {parts.LowerTorso, parts.LeftUpperLeg}, {parts.LeftUpperLeg, parts.LeftLowerLeg}, {parts.LeftLowerLeg, parts.LeftFoot},
                        {parts.LowerTorso, parts.RightUpperLeg}, {parts.RightUpperLeg, parts.RightLowerLeg}, {parts.RightLowerLeg, parts.RightFoot},
                    }
                    for i = 1, 9 do d.Skeleton[i].Visible = false end
                    for i, b in ipairs(bones) do
                        if i > 9 then break end
                        drawLine(d.Skeleton[i], b[1], b[2])
                        d.Skeleton[i].BackgroundColor3 = color
                    end
                else
                    for k in pairs(R6) do parts[k] = pos2d(model:FindFirstChild(k)) end
                    local bones = {
                        {parts.Head, parts.Torso},
                        {parts.Torso, parts["Left Arm"]}, {parts.Torso, parts["Right Arm"]},
                        {parts.Torso, parts["Left Leg"]}, {parts.Torso, parts["Right Leg"]},
                    }
                    for i = 1, 9 do d.Skeleton[i].Visible = false end
                    for i, b in ipairs(bones) do
                        if i > 9 then break end
                        drawLine(d.Skeleton[i], b[1], b[2])
                        d.Skeleton[i].BackgroundColor3 = color
                    end
                end
            else
                for _, s in ipairs(d.Skeleton) do s.Visible = false end
            end
        end
    end
end)

-- ==========================================
-- AIMBOT ENGINE
-- ==========================================
local LockedTarget = nil

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
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local d = (myRoot.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude
        if d > Cfg.AimDistance then return false end
    end
    if Cfg.AimWallCheck then
        local p = getAimPart(model)
        if not p or not isVisible(p) then return false end
    end
    return true
end

RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if Cfg.Aimbot and Cfg.AimFOV then
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0, Cfg.AimFOVSize * 2, 0, Cfg.AimFOVSize * 2)
        FOVCircle.Position = UDim2.new(0.5, -Cfg.AimFOVSize, 0.5, -Cfg.AimFOVSize)
    else
        FOVCircle.Visible = false
    end

    if not Cfg.Aimbot then LockedTarget = nil; AimLineGui.Visible = false; return end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- Pilih target terbaik
    local best, bestDist = nil, Cfg.AimMode == "FOV" and Cfg.AimFOVSize or math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, model in ipairs(ValidEntities) do
        if validTarget(model) then
            local p = getAimPart(model)
            if p then
                local pos, on = Camera:WorldToViewportPoint(p.Position)
                if on then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local d = (screenCenter - screenPos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = model
                    end
                end
            end
        end
    end

    LockedTarget = best
    if LockedTarget then
        local p = getAimPart(LockedTarget)
        if p then
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

            if Cfg.AimTrigger == "Camera" then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, p.Position)
            elseif Cfg.AimTrigger == "Fire (Snap)" then
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, p.Position)
                end
            end
        end
    else
        AimLineGui.Visible = false
    end
end)

-- ==========================================
-- PLAYER HACKS
-- ==========================================
-- Speed Run
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Cfg.SpeedRun then
        hum.WalkSpeed = 16 * (Cfg.SpeedRunValue / 100)
    elseif not Cfg.SpeedRun and hum.WalkSpeed ~= 16 and Cfg.SpeedRunValue == 50 then
        hum.WalkSpeed = 16
    end
end)

-- Multi Jump
local jumpCount = 0
UserInputService.JumpRequest:Connect(function()
    if Cfg.MultiJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Fly Hack (tahan Jump)
local flyBV
RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if Cfg.FlyHack and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if not flyBV or flyBV.Parent ~= root then
            if flyBV then flyBV:Destroy() end
            flyBV = Instance.new("BodyVelocity", root)
            flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBV.Velocity = Vector3.new(0, 50, 0)
        else
            flyBV.Velocity = Vector3.new(0, 50, 0)
        end
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
    end
end)

-- Wall Hack (Noclip)
RunService.Stepped:Connect(function()
    if Cfg.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- ==========================================
-- GUN MODS: RAPID FIRE + UNLIMITED AMMO
-- ==========================================
-- 1. Scan Value & Attribute
local function ScanValueMods(tool)
    pcall(function()
        local function SetSafe(attr, value)
            if tool:GetAttribute(attr) ~= nil and tool:GetAttribute(attr) ~= value then
                tool:SetAttribute(attr, value)
            end
        end
        if Cfg.UnlimitedAmmo then
            SetSafe("TotalAmmo", 999999)
            SetSafe("NewMax", 999999)
            SetSafe("magazineSize", 999999)
            SetSafe("_ammo", 999999)
        end
        SetSafe("spread", 0)
        SetSafe("recoilMax", 0)
        SetSafe("recoilMin", 0)
        if Cfg.RapidFire then
            SetSafe("reloadTime", 0.05)
            SetSafe("rateOfFire", 2500)
        end
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

RunService.RenderStepped:Connect(function()
    if not (Cfg.RapidFire or Cfg.UnlimitedAmmo) then return end
    if LocalPlayer.Character then
        for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
            if t:IsA("Tool") or t:IsA("Model") then ScanValueMods(t) end
        end
    end
    for _, v in ipairs(Camera:GetChildren()) do
        if v:IsA("Model") then ScanValueMods(v) end
    end
end)

-- 2. Deep Memory GC Scanner
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
-- SCRIPT LOADED NOTIFICATION
-- ==========================================
IconBtn.Text = "☠"
print("[LiteHack] UI Loaded. Tekan ikon tengkorak untuk show/hide.")
