-- ============================================================
-- LITE HACK + ULTIMATE MODS | Custom UI (No Library)
-- Bubble 1/3 : Bypass + UI Framework + Floating Skull
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
-- CORE GUI
-- ==========================================
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiteHack_Custom"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ==========================================
-- STATE GLOBAL
-- ==========================================
local State = {
    AntiAdminAktif = false,
    -- Visual
    EnemyESP = false, TeamESP = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    ESP_Box = true, ESP_Name = true, ESP_Line = true,
    ESP_Health = true, ESP_Skeleton = false,
    ESP_Distance = true, ESP_Picture = false,
    -- Aimbot
    AimbotAktif = false, TeamCheck = true, WallCheck = true,
    AimMode = "FOV", TriggerMode = "Camera",
    AimFOV = true, FOVSize = 150, AimLine = true,
    AimTargetMode = "Head", AimDistance = 500,
    AimbotSmoothness = 15,
    -- Player
    SpeedAktif = false, SpeedPercent = 100,
    MultiJump = false, FlyHack = false,
    AntiFallDamageAktif = false, JumpAktif = false, CustomJump = 100,
    GunModsAktif = false, CustomFireRate = 800,
    RapidFire = false, UnlimitedAmmo = false,
    -- World
    ClockTime = "Noon", NoGravity = false, TeleportTarget = nil,
    -- Config
    Theme = "Dark",
}
_G.LH = { State = State }

-- ==========================================
-- THEME (Light / Dark)
-- ==========================================
local Themes = {
    Dark = {
        Bg = Color3.fromRGB(18, 18, 24),
        BgTransparency = 0.15,
        Panel = Color3.fromRGB(28, 28, 38),
        PanelTransparency = 0.25,
        Accent = Color3.fromRGB(180, 0, 255),
        AccentSoft = Color3.fromRGB(120, 0, 200),
        Text = Color3.fromRGB(240, 240, 255),
        TextDim = Color3.fromRGB(160, 160, 180),
        Stroke = Color3.fromRGB(120, 0, 200),
        ToggleOff = Color3.fromRGB(60, 60, 80),
        ToggleOn = Color3.fromRGB(180, 0, 255),
    },
    Light = {
        Bg = Color3.fromRGB(240, 240, 250),
        BgTransparency = 0.05,
        Panel = Color3.fromRGB(255, 255, 255),
        PanelTransparency = 0.1,
        Accent = Color3.fromRGB(140, 0, 220),
        AccentSoft = Color3.fromRGB(90, 0, 160),
        Text = Color3.fromRGB(20, 20, 30),
        TextDim = Color3.fromRGB(90, 90, 110),
        Stroke = Color3.fromRGB(140, 0, 220),
        ToggleOff = Color3.fromRGB(180, 180, 200),
        ToggleOn = Color3.fromRGB(140, 0, 220),
    },
}
local function T() return Themes[State.Theme] or Themes.Dark end

-- ==========================================
-- HELPER: BUAT ROUNDED FRAME
-- ==========================================
local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(180, 0, 255)
    s.Thickness = thickness or 1.5
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

-- ==========================================
-- FLOATING SKULL (glowup)
-- ==========================================
local SkullBtn = Instance.new("TextButton")
SkullBtn.Name = "SkullButton"
SkullBtn.Size = UDim2.fromOffset(56, 56)
SkullBtn.Position = UDim2.new(0, 20, 0.5, -28)
SkullBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
SkullBtn.BackgroundTransparency = 0.1
SkullBtn.Text = "💀"
SkullBtn.TextSize = 32
SkullBtn.Font = Enum.Font.GothamBlack
SkullBtn.TextColor3 = Color3.fromRGB(200, 0, 255)
SkullBtn.AutoButtonColor = false
SkullBtn.Active = true
SkullBtn.Draggable = true
SkullBtn.Parent = ScreenGui
round(SkullBtn, 28)
local skullStroke = stroke(SkullBtn, Color3.fromRGB(200, 0, 255), 2.5, 0.1)

task.spawn(function()
    while SkullBtn.Parent do
        TweenService:Create(skullStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine), { Transparency = 0.75, Thickness = 1.5 }):Play()
        task.wait(1.3)
        TweenService:Create(skullStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine), { Transparency = 0.05, Thickness = 3 }):Play()
        task.wait(1.3)
    end
end)

-- ==========================================
-- WINDOW UTAMA (compact: 520x340)
-- ==========================================
local WIN_W, WIN_H = 520, 340

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(WIN_W, WIN_H)
Window.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
Window.BackgroundColor3 = T().Bg
Window.BackgroundTransparency = T().BgTransparency
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.ClipsDescendants = true
Window.Parent = ScreenGui
round(Window, 14)
local winStroke = stroke(Window, T().Stroke, 2, 0.1)

-- ==========================================
-- TITLE BAR
-- ==========================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = T().Panel
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Window
round(TitleBar, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromOffset(16, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 LITE HACK + ULTIMATE MODS"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextColor3 = T().Accent
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = T().AccentSoft
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(28, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 60)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar
round(CloseBtn, 8)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.fromOffset(28, 28)
MinBtn.Position = UDim2.new(1, -68, 0, 5)
MinBtn.BackgroundColor3 = T().AccentSoft
MinBtn.Text = "—"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleBar
round(MinBtn, 8)

-- ==========================================
-- TAB HEADER BAR (horizontal scroll / wrapped)
-- ==========================================
local HeaderBar = Instance.new("ScrollingFrame")
HeaderBar.Name = "HeaderBar"
HeaderBar.Size = UDim2.new(1, -16, 0, 38)
HeaderBar.Position = UDim2.fromOffset(8, 44)
HeaderBar.BackgroundColor3 = T().Panel
HeaderBar.BackgroundTransparency = 0.35
HeaderBar.BorderSizePixel = 0
HeaderBar.ScrollBarThickness = 3
HeaderBar.ScrollBarImageColor3 = T().Accent
HeaderBar.ScrollingDirection = Enum.ScrollingDirection.X
HeaderBar.CanvasSize = UDim2.new(0, 0, 0, 0)
HeaderBar.AutomaticCanvasSize = Enum.AutomaticSize.X
HeaderBar.Parent = Window
round(HeaderBar, 10)

local HeaderLayout = Instance.new("UIListLayout")
HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
HeaderLayout.Padding = UDim.new(0, 6)
HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
HeaderLayout.Parent = HeaderBar

local HeaderPad = Instance.new("UIPadding")
HeaderPad.PaddingLeft = UDim.new(0, 6)
HeaderPad.PaddingRight = UDim.new(0, 6)
HeaderPad.PaddingTop = UDim.new(0, 5)
HeaderPad.PaddingBottom = UDim.new(0, 5)
HeaderPad.Parent = HeaderBar

-- ==========================================
-- CONTENT AREA (vertical scroll)
-- ==========================================
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -100)
Content.Position = UDim2.fromOffset(8, 88)
Content.BackgroundColor3 = T().Panel
Content.BackgroundTransparency = 0.4
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = T().Accent
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Window
round(Content, 10)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingLeft = UDim.new(0, 8)
ContentPad.PaddingRight = UDim.new(0, 8)
ContentPad.PaddingTop = UDim.new(0, 8)
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = Content

-- ==========================================
-- API: BUAT TAB (page)
-- ==========================================
local Tabs = {}
local ActiveTab = nil
local TabButtons = {}

local function switchTab(name)
    for n, page in pairs(Tabs) do
        page.Visible = (n == name)
    end
    for n, btn in pairs(TabButtons) do
        if n == name then
            btn.BackgroundColor3 = T().Accent
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = T().ToggleOff
            btn.TextColor3 = T().Text
        end
    end
    ActiveTab = name
end

local function createTab(name, icon)
    -- header button
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.fromOffset(110, 26)
    btn.BackgroundColor3 = T().ToggleOff
    btn.Text = (icon and (icon .. " ") or "") .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = T().Text
    btn.AutoButtonColor = false
    btn.Parent = HeaderBar
    round(btn, 8)
    local s = stroke(btn, T().Accent, 1, 0.5)

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    -- page
    local page = Instance.new("Frame")
    page.Name = "Page_" .. name
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    Tabs[name] = page
    TabButtons[name] = btn

    if not ActiveTab then switchTab(name) end
    return page
end

-- buat 5 tab sesuai request
local PageVisual = createTab("Visual", "👁")
local PagePlayer = createTab("Player", "🏃")
local PageAim    = createTab("Aimbot", "🎯")
local PageWorld  = createTab("World", "🌍")
local PageConfig = createTab("Config", "⚙")

-- ==========================================
-- API: SECTION (label + container)
-- ==========================================
local function createSection(page, title)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.BackgroundColor3 = T().Panel
    wrap.BackgroundTransparency = 0.55
    wrap.BorderSizePixel = 0
    wrap.Parent = page
    round(wrap, 8)
    stroke(wrap, T().AccentSoft, 1, 0.6)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = wrap

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 5)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = wrap

    if title and title ~= "" then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = "▸ " .. title
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 12
        lbl.TextColor3 = T().Accent
        lbl.TextStrokeTransparency = 0.4
        lbl.TextStrokeColor3 = T().AccentSoft
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = -1
        lbl.Parent = wrap
    end
    return wrap
end

-- ==========================================
-- API: TOGGLE
-- ==========================================
local function createToggle(parent, opts)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = T().Bg
    row.BackgroundTransparency = 0.5
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent
    round(row, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.Title or "Toggle"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = T().Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(38, 18)
    track.Position = UDim2.new(1, -46, 0.5, -9)
    track.BackgroundColor3 = T().ToggleOff
    track.BorderSizePixel = 0
    track.Parent = row
    round(track, 9)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    knob.BorderSizePixel = 0
    knob.Parent = track
    round(knob, 7)

    local value = opts.Default and true or false
    local function apply()
        if value then
            TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = T().ToggleOn }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { Position = UDim2.fromOffset(22, 2) }):Play()
        else
            TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = T().ToggleOff }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { Position = UDim2.fromOffset(2, 2) }):Play()
        end
    end
    apply()

    row.MouseButton1Click:Connect(function()
        value = not value
        apply()
        if opts.Callback then task.spawn(opts.Callback, value) end
    end)

    return row
end

-- ==========================================
-- API: SLIDER
-- ==========================================
local function createSlider(parent, opts)
    local min = opts.Min or 0
    local max = opts.Max or 100
    local value = opts.Default or min

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 34)
    wrap.BackgroundColor3 = T().Bg
    wrap.BackgroundTransparency = 0.5
    wrap.BorderSizePixel = 0
    wrap.Parent = parent
    round(wrap, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 16)
    label.Position = UDim2.fromOffset(8, 2)
    label.BackgroundTransparency = 1
    label.Text = opts.Title or "Slider"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = T().Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = wrap

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.fromOffset(50, 16)
    valLbl.Position = UDim2.new(1, -58, 0, 2)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(value)
    valLbl.Font = Enum.Font.GothamBlack
    valLbl.TextSize = 11
    valLbl.TextColor3 = T().Accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = wrap

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 6)
    bar.Position = UDim2.new(0, 8, 1, -12)
    bar.BackgroundColor3 = T().ToggleOff
    bar.BorderSizePixel = 0
    bar.Parent = wrap
    round(bar, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
    fill.BackgroundColor3 = T().Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    round(fill, 3)

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, 0, 0, 18)
    track.Position = UDim2.new(0, 0, 1, -18)
    track.BackgroundTransparency = 1
    track.Text = ""
    track.Parent = wrap

    local dragging = false
    local function setFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + rel * (max - min) + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(value)
        if opts.Callback then task.spawn(opts.Callback, value) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)

    return wrap
end

-- ==========================================
-- API: DROPDOWN (combo box)
-- ==========================================
local function createDropdown(parent, opts)
    local values = opts.Values or {}
    local current = opts.Default or values[1] or ""

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = T().Bg
    row.BackgroundTransparency = 0.5
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent
    round(row, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.Title or "Select"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = T().Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.5, -20, 1, 0)
    valLbl.Position = UDim2.new(0.5, 8, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = current .. "  ▾"
    valLbl.Font = Enum.Font.GothamBlack
    valLbl.TextSize = 12
    valLbl.TextColor3 = T().Accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    -- popup list
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(1, 0, 0, math.min(#values, 6) * 24 + 8)
    popup.Position = UDim2.new(0, 0, 1, 2)
    popup.BackgroundColor3 = T().Bg
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.ZIndex = 10
    popup.Parent = row
    round(popup, 6)
    stroke(popup, T().Accent, 1, 0.3)

    local ply = Instance.new("UIListLayout")
    ply.Padding = UDim.new(0, 2)
    ply.Parent = popup

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.Parent = popup

    local function rebuild()
        for _, c in ipairs(popup:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, v in ipairs(values) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 20)
            b.BackgroundColor3 = T().Panel
            b.BackgroundTransparency = 0.5
            b.Text = "  " .. tostring(v)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 11
            b.TextColor3 = T().Text
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.AutoButtonColor = false
            b.Parent = popup
            round(b, 4)
            b.MouseButton1Click:Connect(function()
                current = v
                valLbl.Text = tostring(v) .. "  ▾"
                popup.Visible = false
                if opts.Callback then task.spawn(opts.Callback, v) end
            end)
        end
        popup.Size = UDim2.new(1, 0, 0, math.min(#values, 6) * 22 + 8)
    end
    rebuild()

    row.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
    end)

    return row, function(newList)
        values = newList
        rebuild()
    end
end

-- ==========================================
-- API: BUTTON
-- ==========================================
local function createButton(parent, title, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = T().AccentSoft
    b.Text = title
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.AutoButtonColor = false
    b.Parent = parent
    round(b, 6)
    stroke(b, T().Accent, 1, 0.2)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T().Accent }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T().AccentSoft }):Play()
    end)
    b.MouseButton1Click:Connect(function()
        if callback then task.spawn(callback) end
    end)
    return b
end

-- ==========================================
-- API: COLOR PICKER (RGB)
-- ==========================================
local function createColorPicker(parent, opts)
    local initC = opts.Default or Color3.fromRGB(255, 0, 0)

    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 78)
    wrap.BackgroundColor3 = T().Bg
    wrap.BackgroundTransparency = 0.5
    wrap.BorderSizePixel = 0
    wrap.Parent = parent
    round(wrap, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 16)
    label.Position = UDim2.fromOffset(8, 2)
    label.BackgroundTransparency = 1
    label.Text = opts.Title or "Color"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = T().Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = wrap

    local preview = Instance.new("Frame")
    preview.Size = UDim2.fromOffset(30, 16)
    preview.Position = UDim2.new(1, -38, 0, 2)
    preview.BackgroundColor3 = initC
    preview.BorderSizePixel = 0
    preview.Parent = wrap
    round(preview, 4)
    stroke(preview, Color3.fromRGB(0,0,0), 1, 0.5)

    local function makeSlider(y, name, initV, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.fromOffset(14, 16)
        lbl.Position = UDim2.fromOffset(8, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 11
        lbl.TextColor3 = color
        lbl.Parent = wrap

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -50, 0, 6)
        bar.Position = UDim2.new(0, 28, 0, y + 5)
        bar.BackgroundColor3 = T().ToggleOff
        bar.BorderSizePixel = 0
        bar.Parent = wrap
        round(bar, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(initV, 0, 1, 0)
        fill.BackgroundColor3 = color
        fill.BorderSizePixel = 0
        fill.Parent = bar
        round(fill, 3)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 16)
        btn.Position = UDim2.new(0, 0, 0, y - 3)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = bar.Parent
        btn.Size = UDim2.new(1, -20, 0, 22)
        btn.Position = UDim2.new(0, 20, 0, y - 3)

        local dragging = false
        local function apply(x)
            local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            return rel
        end
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                local r = apply(input.Position.X)
                if name == "R" then initC = Color3.new(r, initC.G, initC.B)
                elseif name == "G" then initC = Color3.new(initC.R, r, initC.B)
                else initC = Color3.new(initC.R, initC.G, r) end
                preview.BackgroundColor3 = initC
                if opts.Callback then task.spawn(opts.Callback, initC) end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local r = apply(input.Position.X)
                if name == "R" then initC = Color3.new(r, initC.G, initC.B)
                elseif name == "G" then initC = Color3.new(initC.R, r, initC.B)
                else initC = Color3.new(initC.R, initC.G, r) end
                preview.BackgroundColor3 = initC
                if opts.Callback then task.spawn(opts.Callback, initC) end
            end
        end)
    end

    makeSlider(20, "R", initC.R, Color3.fromRGB(255, 60, 60))
    makeSlider(42, "G", initC.G, Color3.fromRGB(60, 255, 60))
    makeSlider(64, "B", initC.B, Color3.fromRGB(60, 120, 255))

    return wrap
end

-- ==========================================
-- SIMPAN API & TAB UNTUK BUBBLE 2-3
-- ==========================================
_G.LH.Api = {
    ScreenGui = ScreenGui,
    Window = Window,
    Content = Content,
    HeaderBar = HeaderBar,
    Tabs = Tabs,
    SwitchTab = switchTab,
    createTab = createTab,
    createSection = createSection,
    createToggle = createToggle,
    createSlider = createSlider,
    createDropdown = createDropdown,
    createButton = createButton,
    createColorPicker = createColorPicker,
    Themes = Themes,
    T = T,
    round = round,
    stroke = stroke,
}
_G.LH.TabPages = {
    Visual = PageVisual,
    Player = PagePlayer,
    Aimbot = PageAim,
    World  = PageWorld,
    Config = PageConfig,
}

-- ==========================================
-- SHOW / HIDE MENU via skull
-- ==========================================
local menuOpen = true
local function setMenuVisible(v)
    menuOpen = v
    Window.Visible = v
    if not v then
        pcall(function() WindUI = nil end)
    end
end

SkullBtn.MouseButton1Click:Connect(function()
    setMenuVisible(not menuOpen)
end)
CloseBtn.MouseButton1Click:Connect(function() setMenuVisible(false) end)
MinBtn.MouseButton1Click:Connect(function() setMenuVisible(false) end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        setMenuVisible(not menuOpen)
    end
end)

-- ==========================================
-- ANTI-ADMIN (dari kodemu, notifikasi custom)
-- ==========================================
local NotifyGui = Instance.new("Frame")
NotifyGui.Name = "Notify"
NotifyGui.Size = UDim2.new(0, 320, 0, 60)
NotifyGui.Position = UDim2.new(1, -340, 0, 20)
NotifyGui.BackgroundColor3 = T().Bg
NotifyGui.BackgroundTransparency = 0.1
NotifyGui.BorderSizePixel = 0
NotifyGui.Visible = false
NotifyGui.ZIndex = 50
NotifyGui.Parent = ScreenGui
round(NotifyGui, 10)
stroke(NotifyGui, T().Accent, 2, 0)

local NotifyTitle = Instance.new("TextLabel")
NotifyTitle.Size = UDim2.new(1, -16, 0, 20)
NotifyTitle.Position = UDim2.fromOffset(8, 6)
NotifyTitle.BackgroundTransparency = 1
NotifyTitle.Font = Enum.Font.GothamBlack
NotifyTitle.TextSize = 13
NotifyTitle.TextColor3 = T().Accent
NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
NotifyTitle.Parent = NotifyGui

local NotifyBody = Instance.new("TextLabel")
NotifyBody.Size = UDim2.new(1, -16, 0, 30)
NotifyBody.Position = UDim2.fromOffset(8, 24)
NotifyBody.BackgroundTransparency = 1
NotifyBody.Font = Enum.Font.GothamBold
NotifyBody.TextSize = 11
NotifyBody.TextColor3 = T().Text
NotifyBody.TextXAlignment = Enum.TextXAlignment.Left
NotifyBody.TextWrapped = true
NotifyBody.Parent = NotifyGui

local notifyHideToken = 0
function _G.LH.Notify(title, content, duration)
    notifyHideToken = notifyHideToken + 1
    local myToken = notifyHideToken
    NotifyTitle.Text = title
    NotifyBody.Text = content
    NotifyGui.Visible = true
    TweenService:Create(NotifyGui, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 }):Play()
    task.delay(duration or 4, function()
        if notifyHideToken == myToken then
            TweenService:Create(NotifyGui, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            if notifyHideToken == myToken then NotifyGui.Visible = false end
        end
    end)
end

-- Anti-Admin logic
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
            local v = string.upper(tostring(stat.Value))
            if v == "GM" or v == "MOD" or v == "GAME MASTER" or v == "MODERATOR" then return true end
        end
    end
    return false
end

local function SendAdminWarning(p)
    _G.LH.Notify("⚠️ GM TERDETEKSI!", "Admin/Moderator ["..p.Name.."] ada di room ini!", 8)
end
_G.LH.CheckIfAdmin = CheckIfAdmin
_G.LH.SendAdminWarning = SendAdminWarning

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

_G.LH.Services = {
    Players = Players, RunService = RunService,
    LocalPlayer = LocalPlayer, Camera = Camera,
    UserInputService = UserInputService, Lighting = Lighting,
    HttpService = HttpService, TweenService = TweenService,
    ReplicatedStorage = ReplicatedStorage,
}

_G.LH.Notify("💀 Lite Hack Loaded", "Semua fitur siap. Tekan skull untuk show/hide.", 5)
-- ============================================================
-- LITE HACK + ULTIMATE MODS | Custom UI
-- Bubble 2/3 : Tab Visual (ESP) + Tab Aimbot
-- ============================================================

local LH       = _G.LH
local State    = LH.State
local Api      = LH.Api
local Pages    = LH.TabPages
local Services = LH.Services
local Notify   = LH.Notify

local Players     = Services.Players
local RunService  = Services.RunService
local LocalPlayer = Services.LocalPlayer
local Camera      = Services.Camera
local UIS         = Services.UserInputService

-- helper shortcut
local createSection     = Api.createSection
local createToggle      = Api.createToggle
local createSlider      = Api.createSlider
local createDropdown    = Api.createDropdown
local createButton      = Api.createButton
local createColorPicker = Api.createColorPicker

-- ============================================================
-- TAB VISUAL
-- ============================================================
local VSec1 = createSection(Pages.Visual, "ESP FILTER")

createToggle(VSec1, {
    Title = "Enemy ESP  (semua player musuh)",
    Default = false,
    Callback = function(v) State.EnemyESP = v end,
})

createToggle(VSec1, {
    Title = "Team ESP  (semua player team)",
    Default = false,
    Callback = function(v) State.TeamESP = v end,
})

-- ============================================================
-- RGB COLOR PICKER
-- ============================================================
local VSec2 = createSection(Pages.Visual, "ESP COLOR (RGB)")

createColorPicker(VSec2, {
    Title = "Warna Semua ESP",
    Default = State.ESPColor,
    Callback = function(c)
        State.ESPColor = c
        if _G.refreshESPColor then pcall(_G.refreshESPColor) end
    end,
})

-- ============================================================
-- CHECKBOX ELEMEN ESP
-- ============================================================
local VSec3 = createSection(Pages.Visual, "ESP ELEMENTS")

createToggle(VSec3, {
    Title = "Box  (kotak persegi)",
    Default = true,
    Callback = function(v) State.ESP_Box = v end,
})
createToggle(VSec3, {
    Title = "Name  (di atas box)",
    Default = true,
    Callback = function(v) State.ESP_Name = v end,
})
createToggle(VSec3, {
    Title = "Line  (garis dari atas layar ke kepala, tebal)",
    Default = true,
    Callback = function(v) State.ESP_Line = v end,
})
createToggle(VSec3, {
    Title = "Health  (kanan box, warna dinamis)",
    Default = true,
    Callback = function(v) State.ESP_Health = v end,
})
createToggle(VSec3, {
    Title = "Skeleton  (tulang R15/R6)",
    Default = false,
    Callback = function(v) State.ESP_Skeleton = v end,
})
createToggle(VSec3, {
    Title = "Distance  (bawah box)",
    Default = true,
    Callback = function(v) State.ESP_Distance = v end,
})
createToggle(VSec3, {
    Title = "Picture  (avatar bulat di atas kepala)",
    Default = false,
    Callback = function(v) State.ESP_Picture = v end,
})

-- ============================================================
-- ESP RENDER ENGINE (Drawing API + Picture Billboard)
-- ============================================================
local CoreGui = LH.Api.ScreenGui

local PicFolder = Instance.new("Folder")
PicFolder.Name = "LH_ESP_Pictures"
PicFolder.Parent = CoreGui

local espData    = {}
local thumbCache = {}

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

_G.refreshESPColor = function()
    for _, d in pairs(espData) do
        if d.box  then d.box.Color  = State.ESPColor end
        if d.name then d.name.Color = State.ESPColor end
        if d.dist then d.dist.Color = State.ESPColor end
        if d.line then d.line.Color = State.ESPColor end
        for _, s in ipairs(d.skel or {}) do s.draw.Color = State.ESPColor end
        if d.picStroke then d.picStroke.Color = State.ESPColor end
    end
end

local function createESPData(char)
    local d = {}
    d.box  = Drawing.new("Square"); d.box.Thickness = 2.5; d.box.Filled = false
    d.name = Drawing.new("Text");   d.name.Size = 15; d.name.Center = true
    d.name.Outline = true; d.name.OutlineColor = Color3.new(0,0,0)
    d.dist = Drawing.new("Text");   d.dist.Size = 13; d.dist.Center = true
    d.dist.Outline = true; d.dist.OutlineColor = Color3.new(0,0,0)
    d.line = Drawing.new("Line");   d.line.Thickness = 2.5
    d.hbBG   = Drawing.new("Square"); d.hbBG.Filled = true; d.hbBG.Thickness = 0; d.hbBG.Color = Color3.new(0,0,0)
    d.hbFill = Drawing.new("Square"); d.hbFill.Filled = true; d.hbFill.Thickness = 0

    d.skel = {}
    local conns = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
        {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    for _, c in ipairs(conns) do
        local dl = Drawing.new("Line"); dl.Thickness = 2
        table.insert(d.skel, { from = c[1], to = c[2], draw = dl })
    end
    return d
end

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
    bg.Parent = PicFolder

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1,1)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
    frame.BorderSizePixel = 0
    frame.Parent = bg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1,0)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromScale(1,1)
    img.BackgroundTransparency = 1
    img.Parent = frame
    Instance.new("UICorner", img).CornerRadius = UDim.new(1,0)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = State.ESPColor
    stroke.Thickness = 2

    local url = getThumb(plr)
    if url then img.Image = url end

    return bg, stroke
end

local function destroyESP(char)
    local d = espData[char]
    if not d then return end
    if d.box    then d.box:Remove()    end
    if d.name   then d.name:Remove()   end
    if d.dist   then d.dist:Remove()   end
    if d.line   then d.line:Remove()   end
    if d.hbBG   then d.hbBG:Remove()   end
    if d.hbFill then d.hbFill:Remove() end
    for _, s in ipairs(d.skel) do s.draw:Remove() end
    if d.picFrame then d.picFrame:Destroy() end
    espData[char] = nil
end

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local seen = {}

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
                    local bg, stroke = createPicture(char, plr)
                    if bg then
                        espData[char].picFrame  = bg
                        espData[char].picStroke = stroke
                    end
                end

                local d = espData[char]
                local headPos, onH = worldToScreen(head.Position)
                local footPos, onF = worldToScreen(hrp.Position - Vector3.new(0, 3, 0))

                if onH and onF and headPos.Y > -300 and headPos.Y < Camera.ViewportSize.Y + 300 then
                    local boxH = math.abs(footPos.Y - headPos.Y)
                    local boxW = boxH * 0.55
                    local boxX = headPos.X - boxW/2
                    local boxY = headPos.Y

                    d.box.Visible  = State.ESP_Box
                    d.box.Size     = Vector2.new(boxW, boxH)
                    d.box.Position = Vector2.new(boxX, boxY)
                    d.box.Color    = State.ESPColor

                    d.name.Visible  = State.ESP_Name
                    d.name.Text     = plr.Name
                    d.name.Position = Vector2.new(headPos.X, boxY - 20)
                    d.name.Color    = State.ESPColor

                    local meters = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    d.dist.Visible  = State.ESP_Distance
                    d.dist.Text     = meters .. "m"
                    d.dist.Position = Vector2.new(headPos.X, boxY + boxH + 5)
                    d.dist.Color    = State.ESPColor

                    d.line.Visible = State.ESP_Line
                    d.line.From    = Vector2.new(center.X, 0)
                    d.line.To      = headPos
                    d.line.Color   = State.ESPColor

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

                    if State.ESP_Health then
                        local pct = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
                        local col = pct > 0.7 and Color3.fromRGB(0,255,0)
                            or pct > 0.4 and Color3.fromRGB(255,150,0)
                            or Color3.fromRGB(139,0,0)
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

                    if d.picFrame then
                        d.picFrame.Enabled = State.ESP_Picture
                        if State.ESP_Picture and d.picStroke then
                            d.picStroke.Color = State.ESPColor
                        end
                    end
                else
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

    for char, _ in pairs(espData) do
        if not seen[char] then destroyESP(char) end
    end
end)

-- ============================================================
-- TAB AIMBOT
-- ============================================================
local ASec1 = createSection(Pages.Aimbot, "AIMBOT SETTINGS")

createToggle(ASec1, {
    Title = "Aimbot",
    Default = false,
    Callback = function(v) State.AimbotAktif = v end,
})
createToggle(ASec1, {
    Title = "Team Check  (hindari team sendiri)",
    Default = true,
    Callback = function(v) State.TeamCheck = v end,
})
createToggle(ASec1, {
    Title = "Wall Check  (hindari target di balik tembok)",
    Default = true,
    Callback = function(v) State.WallCheck = v end,
})
createDropdown(ASec1, {
    Title = "Mode Aimbot",
    Values = { "FOV", "360°" },
    Default = "FOV",
    Callback = function(v) State.AimMode = v end,
})
createDropdown(ASec1, {
    Title = "Mode Trigger",
    Values = { "Camera", "Fire" },
    Default = "Camera",
    Callback = function(v) State.TriggerMode = v end,
})
createToggle(ASec1, {
    Title = "Aim FOV  (tampilkan lingkaran)",
    Default = true,
    Callback = function(v) State.AimFOV = v end,
})
createSlider(ASec1, {
    Title = "Size FOV (pixel)",
    Min = 10, Max = 600, Default = 150,
    Callback = function(v) State.FOVSize = v end,
})
createToggle(ASec1, {
    Title = "Aim Line  (garis ke target)",
    Default = true,
    Callback = function(v) State.AimLine = v end,
})
createDropdown(ASec1, {
    Title = "Aim Target",
    Values = { "Head", "Neck", "Chest" },
    Default = "Head",
    Callback = function(v) State.AimTargetMode = v end,
})
createSlider(ASec1, {
    Title = "Aim Distance (m)",
    Min = 50, Max = 2000, Default = 500,
    Callback = function(v) State.AimDistance = v end,
})
createSlider(ASec1, {
    Title = "Smoothness (1-100)",
    Min = 1, Max = 100, Default = 15,
    Callback = function(v) State.AimbotSmoothness = v end,
})

-- ============================================================
-- FOV CIRCLE (Drawing)
-- ============================================================
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.8
FovCircle.Transparency = 0.6
FovCircle.Color = Color3.fromRGB(255, 255, 255)
FovCircle.Visible = false

-- ============================================================
-- AIM LINE
-- ============================================================
local AimLine = Drawing.new("Line")
AimLine.Thickness = 2.5
AimLine.Visible = false

-- ============================================================
-- AIMBOT LOGIC
-- ============================================================
local LockedTarget = nil

local function getTargetPart(char)
    if not char then return nil end
    local head  = char:FindFirstChild("Head")
    local neck  = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local chest = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if State.AimTargetMode == "Head"  then return head  or neck  or chest end
    if State.AimTargetMode == "Neck"  then return neck  or head  or chest end
    if State.AimTargetMode == "Chest" then return chest or neck  or head  end
    return head
end

local function isVisibleToCamera(targetPart)
    if not targetPart then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.FilterType = Enum.RaycastFilterType.Exclude
    local origin = Camera.CFrame.Position
    local dir = (targetPart.Position - origin)
    local res = workspace:Raycast(origin, dir, params)
    if not res then return true end
    return res.Instance:IsDescendantOf(targetPart.Parent)
end

local function getClosest3D()
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                if State.TeamCheck and not isEnemyPlayer(plr) then
                    -- skip
                else
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    if dist <= State.AimDistance then
                        local tp = getTargetPart(char)
                        if tp and (not State.WallCheck or isVisibleToCamera(tp)) then
                            if dist < bestDist then bestDist = dist; best = char end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function getClosest2D()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                if State.TeamCheck and not isEnemyPlayer(plr) then
                    -- skip
                else
                    local dist3 = (Camera.CFrame.Position - hrp.Position).Magnitude
                    if dist3 <= State.AimDistance then
                        local tp = getTargetPart(char)
                        if tp and (not State.WallCheck or isVisibleToCamera(tp)) then
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
    end
    return best
end

RunService.RenderStepped:Connect(function()
    -- FOV circle
    if State.AimbotAktif and State.AimFOV and State.AimMode == "FOV" then
        FovCircle.Visible = true
        FovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FovCircle.Radius = State.FOVSize
    else
        FovCircle.Visible = false
    end

    if not State.AimbotAktif then
        LockedTarget = nil
        AimLine.Visible = false
        return
    end

    local valid = false
    local tp = nil

    if LockedTarget and LockedTarget.Parent then
        local hum = LockedTarget:FindFirstChildOfClass("Humanoid")
        local hrp = LockedTarget:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then
            tp = getTargetPart(LockedTarget)
            if tp and (not State.WallCheck or isVisibleToCamera(tp)) then
                local d3 = (Camera.CFrame.Position - hrp.Position).Magnitude
                if d3 <= State.AimDistance then
                    if State.AimMode == "360°" then
                        valid = true
                    else
                        local sp, on = Camera:WorldToViewportPoint(tp.Position)
                        if on then
                            local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                            if (c - Vector2.new(sp.X, sp.Y)).Magnitude <= State.FOVSize then
                                valid = true
                            end
                        end
                    end
                end
            end
        end
    end

    if not valid then
        local nt = (State.AimMode == "360°") and getClosest3D() or getClosest2D()
        LockedTarget = nt
        tp = LockedTarget and getTargetPart(LockedTarget)
    end

    if LockedTarget and tp then
        if State.TriggerMode == "Camera" or State.AimMode == "360°" then
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, tp.Position)
            if State.AimMode == "360°" then
                Camera.CFrame = targetCF
            else
                local f = State.AimbotSmoothness / 100
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, f)
            end
        end
        if State.AimLine then
            local sp, on = Camera:WorldToViewportPoint(tp.Position)
            if on then
                AimLine.Visible = true
                AimLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
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

-- ============================================================
-- PHYSICS BYPASS (copy utuh dari kodemu)
-- ============================================================
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
-- LITE HACK + ULTIMATE MODS | Custom UI
-- Bubble 3/3 : Tab Player + Tab World + Tab Config
-- ============================================================

local LH       = _G.LH
local State    = LH.State
local Api      = LH.Api
local Pages    = LH.TabPages
local Services = LH.Services
local Notify   = LH.Notify

local Players     = Services.Players
local RunService  = Services.RunService
local LocalPlayer = Services.LocalPlayer
local Camera      = Services.Camera
local UIS         = Services.UserInputService
local Lighting    = Services.Lighting
local HttpService = Services.HttpService

local createSection     = Api.createSection
local createToggle      = Api.createToggle
local createSlider      = Api.createSlider
local createDropdown    = Api.createDropdown
local createButton      = Api.createButton

-- ============================================================
-- TAB PLAYER
-- ============================================================
local PSec1 = createSection(Pages.Player, "MOVEMENT")

createToggle(PSec1, {
    Title = "Speed Run",
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
createSlider(PSec1, {
    Title = "Speed %  (100 = normal)",
    Min = 50, Max = 500, Default = 100,
    Callback = function(v) State.SpeedPercent = v end,
})
createToggle(PSec1, {
    Title = "Multi Jump  (lompat berkali-kali di udara)",
    Default = false,
    Callback = function(v) State.MultiJump = v end,
})
createToggle(PSec1, {
    Title = "Fly Hack  (tahan tombol Jump)",
    Default = false,
    Callback = function(v) State.FlyHack = v end,
})
createToggle(PSec1, {
    Title = "No Fall Damage",
    Default = false,
    Callback = function(v) State.AntiFallDamageAktif = v end,
})

local PSec2 = createSection(Pages.Player, "JUMP")
createToggle(PSec2, {
    Title = "Lompat Tinggi",
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
createSlider(PSec2, {
    Title = "Set Power",
    Min = 50, Max = 500, Default = 100,
    Callback = function(v) State.CustomJump = v end,
})

local PSec3 = createSection(Pages.Player, "GUN")
createToggle(PSec3, {
    Title = "Rapid Fire",
    Default = false,
    Callback = function(v) State.RapidFire = v end,
})
createToggle(PSec3, {
    Title = "Unlimited Ammo",
    Default = false,
    Callback = function(v) State.UnlimitedAmmo = v end,
})
createToggle(PSec3, {
    Title = "Gun Mods (Deep Memory Scan)",
    Default = false,
    Callback = function(v) State.GunModsAktif = v end,
})
createSlider(PSec3, {
    Title = "RPM Fire Rate",
    Min = 400, Max = 2500, Default = 800,
    Callback = function(v) State.CustomFireRate = v end,
})

-- ============================================================
-- PLAYER LOGIC
-- ============================================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end

    if State.SpeedAktif then
        hum.WalkSpeed = 16 * (State.SpeedPercent / 100)
    end

    if State.JumpAktif then
        hum.UseJumpPower = true
        hum.JumpPower = State.CustomJump
    end

    if State.FlyHack and hrp then
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end

    if State.AntiFallDamageAktif and hrp and hrp.Velocity.Y < -40 then
        local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -20, 0), RaycastParams.new())
        if hit then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z)
        end
    end
end)

-- Multi jump
UIS.JumpRequest:Connect(function()
    if not State.MultiJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================
-- GUN MODS SCAN (copy utuh dari kodemu)
-- ============================================================
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

-- Deep memory GC scan (copy utuh dari kodemu)
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

-- ============================================================
-- TAB WORLD
-- ============================================================
local WSec1 = createSection(Pages.World, "ENVIRONMENT")

createDropdown(WSec1, {
    Title = "Clock Time",
    Values = { "Morning", "Noon", "Evening", "Night" },
    Default = "Noon",
    Callback = function(v) State.ClockTime = v end,
})

createToggle(WSec1, {
    Title = "No Gravity",
    Default = false,
    Callback = function(v) State.NoGravity = v end,
})

-- ============================================================
-- TELEPORT
-- ============================================================
local WSec2 = createSection(Pages.World, "TELEPORT TO PLAYER")

local function getPlayerNames()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t, p.Name) end
    end
    return t
end

local PlayerDrop, refreshPlayerList = createDropdown(WSec2, {
    Title = "Select Player",
    Values = getPlayerNames(),
    Default = "",
    Callback = function(v) State.TeleportTarget = v end,
})

Players.PlayerAdded:Connect(function()
    task.wait(1)
    if refreshPlayerList then refreshPlayerList(getPlayerNames()) end
end)
Players.PlayerRemoving:Connect(function()
    task.wait(1)
    if refreshPlayerList then refreshPlayerList(getPlayerNames()) end
end)

createButton(WSec2, "⚡  TELEPORT NOW", function()
    local t = State.TeleportTarget
    if not t or t == "" then
        Notify("Teleport", "Pilih player dulu!", 3)
        return
    end
    local plr = Players:FindFirstChild(t)
    if not plr or not plr.Character then
        Notify("Teleport", "Target tidak valid.", 3)
        return
    end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myHrp then
        myHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
        Notify("Teleport", "Berhasil ke " .. plr.Name, 3)
    end
end)

-- World logic
task.spawn(function()
    while task.wait(1) do
        local hour = 12
        if State.ClockTime == "Morning" then hour = 7
        elseif State.ClockTime == "Noon" then hour = 12
        elseif State.ClockTime == "Evening" then hour = 17
        elseif State.ClockTime == "Night" then hour = 0 end
        pcall(function()
            Lighting.ClockTime = hour
            Lighting.Brightness = (hour >= 6 and hour <= 18) and 2 or 0.5
        end)
        pcall(function()
            workspace.Gravity = State.NoGravity and 0 or 196.2
        end)
    end
end)

-- ============================================================
-- TAB CONFIG
-- ============================================================
local CSec1 = createSection(Pages.Config, "THEME")

local ThemeDrop
ThemeDrop = createDropdown(CSec1, {
    Title = "Theme",
    Values = { "Dark", "Light" },
    Default = "Dark",
    Callback = function(v)
        State.Theme = v
        pcall(function()
            local T = Api.Themes[v] or Api.Themes.Dark
            Api.Window.BackgroundColor3 = T.Bg
            Api.Window.BackgroundTransparency = T.BgTransparency
            Api.Content.BackgroundColor3 = T.Panel
            Api.HeaderBar.BackgroundColor3 = T.Panel
        end)
    end,
})

-- ============================================================
-- SAVE / LOAD
-- ============================================================
local CSec2 = createSection(Pages.Config, "SAVE / LOAD (JSON)")

local ConfigFile = "LiteHack_Config.json"
local SAVE_FIELDS = {
    "AntiAdminAktif",
    "EnemyESP","TeamESP","ESP_Box","ESP_Name","ESP_Line","ESP_Health",
    "ESP_Skeleton","ESP_Distance","ESP_Picture",
    "AimbotAktif","TeamCheck","WallCheck",
    "AimMode","TriggerMode","AimFOV","FOVSize","AimLine",
    "AimTargetMode","AimDistance","AimbotSmoothness",
    "SpeedAktif","SpeedPercent","MultiJump","FlyHack",
    "AntiFallDamageAktif","JumpAktif","CustomJump",
    "GunModsAktif","CustomFireRate","RapidFire","UnlimitedAmmo",
    "ClockTime","NoGravity","Theme",
}

createButton(CSec2, "💾  SAVE CONFIG", function()
    if not writefile then
        Notify("Save", "Eksekutor tidak support writefile.", 4)
        return
    end
    local data = {}
    for _, key in ipairs(SAVE_FIELDS) do
        local v = State[key]
        if typeof(v) == "Color3" then
            v = { __color = true, r = v.R, g = v.G, b = v.B }
        end
        data[key] = v
    end
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then
        local wOk = pcall(function() writefile(ConfigFile, json) end)
        if wOk then Notify("Save", "Konfigurasi tersimpan!", 4)
        else Notify("Save", "Gagal menulis file.", 4) end
    else
        Notify("Save", "Gagal encode JSON.", 4)
    end
end)

createButton(CSec2, "📂  LOAD CONFIG", function()
    if not (isfile and readfile) then
        Notify("Load", "Eksekutor tidak support readfile.", 4)
        return
    end
    if not isfile(ConfigFile) then
        Notify("Load", "Belum ada file config.", 4)
        return
    end
    local ok, json = pcall(function() return readfile(ConfigFile) end)
    if not ok or not json then Notify("Load", "Gagal baca file.", 4); return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok2 or type(data) ~= "table" then Notify("Load", "JSON rusak.", 4); return end
    for k, v in pairs(data) do
        if typeof(v) == "table" and v.__color then
            State[k] = Color3.new(v.r or 1, v.g or 0, v.b or 0)
        else
            State[k] = v
        end
    end
    if _G.refreshESPColor then pcall(_G.refreshESPColor) end
    Notify("Load", "Konfigurasi dimuat!", 4)
end)

createButton(CSec2, "🔄  RESET TO DEFAULT", function()
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
    if _G.refreshESPColor then pcall(_G.refreshESPColor) end
    Notify("Reset", "Semua fitur kembali ke default.", 4)
end)

-- ============================================================
-- ANTI-ADMIN TOGGLE (dipindah ke Config biar rapi)
-- ============================================================
local CSec3 = createSection(Pages.Config, "MISC")
createToggle(CSec3, {
    Title = "🚨 Peringatan Admin (GM/MOD Detector)",
    Default = false,
    Callback = function(v) State.AntiAdminAktif = v end,
})

-- ============================================================
-- PENUTUP
-- ============================================================
Notify("💀 Lite Hack Ready", "Semua tab siap. Tekan LCtrl / skull untuk hide.", 5)

-- cleanup referensi global
_G.LH.Api    = nil
_G.LH.Services = nil
-- tetap simpan State agar Save/Load bisa akses
