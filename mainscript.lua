-- ==========================================
-- SERVICES
-- ==========================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local ScriptContext     = game:GetService("ScriptContext")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local Lighting          = game:GetService("Lighting")
local LocalPlayer       = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT (copy-paste, tidak diubah)
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
        if getcallingscript then
            pcall(function() getcallingscript = function() return nil end end)
        end
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
-- THEME SYSTEM (Light / Dark)
-- ==========================================
local Themes = {
    Dark = {
        Bg = Color3.fromRGB(18, 18, 22),
        Panel = Color3.fromRGB(26, 26, 32),
        Panel2 = Color3.fromRGB(34, 34, 42),
        Stroke = Color3.fromRGB(60, 60, 75),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(160, 160, 175),
        Accent = Color3.fromRGB(120, 80, 255),
        Accent2 = Color3.fromRGB(80, 200, 255),
        ToggleOn = Color3.fromRGB(120, 80, 255),
        ToggleOff = Color3.fromRGB(60, 60, 75),
        Danger = Color3.fromRGB(255, 80, 80),
    },
    Light = {
        Bg = Color3.fromRGB(240, 240, 248),
        Panel = Color3.fromRGB(255, 255, 255),
        Panel2 = Color3.fromRGB(235, 235, 245),
        Stroke = Color3.fromRGB(200, 200, 215),
        Text = Color3.fromRGB(30, 30, 40),
        SubText = Color3.fromRGB(100, 100, 120),
        Accent = Color3.fromRGB(120, 80, 255),
        Accent2 = Color3.fromRGB(80, 180, 255),
        ToggleOn = Color3.fromRGB(120, 80, 255),
        ToggleOff = Color3.fromRGB(190, 190, 200),
        Danger = Color3.fromRGB(220, 60, 60),
    },
}
local CurrentTheme = "Dark"
local T = Themes[CurrentTheme]

-- ==========================================
-- HELPER: FONT, ROUNDED, STROKE
-- ==========================================
local FONT_BOLD = Enum.Font.GothamBold
local FONT_MONO = Enum.Font.Code
local function Round(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = obj
    return c
end
local function Stroke(obj, col, th)
    local s = Instance.new("UIStroke"); s.Color = col or T.Stroke; s.Thickness = th or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj
    return s
end
local function Pad(obj, p)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, p); u.PaddingBottom = UDim.new(0, p)
    u.PaddingLeft = UDim.new(0, p); u.PaddingRight = UDim.new(0, p)
    u.Parent = obj
    return u
end

-- ==========================================
-- ROOT GUI (ScreenGui) + FLOATING SKULL ICON
-- ==========================================
local parentGui = (gethui and gethui()) or CoreGui
local Screen = Instance.new("ScreenGui")
Screen.Name = "LiteHackUI_" .. tostring(math.random(1e6, 9e6))
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.Parent = parentGui

-- Floating Skull Icon
local Skull = Instance.new("TextButton")
Skull.Name = "SkullIcon"
Skull.Size = UDim2.new(0, 56, 0, 56)
Skull.Position = UDim2.new(0, 24, 0, 24)
Skull.BackgroundColor3 = T.Panel
Skull.Text = "☠"
Skull.Font = FONT_BOLD
Skull.TextSize = 34
Skull.TextColor3 = T.Accent
Skull.AutoButtonColor = false
Skull.Parent = Screen
Round(Skull, 28)
local SkullStroke = Stroke(Skull, T.Accent, 2)
-- glowup (gradient)
local SkullGrad = Instance.new("UIGradient")
SkullGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, T.Accent),
    ColorSequenceKeypoint.new(1, T.Accent2),
}
SkullGrad.Parent = SkullStroke
-- pulsing glow
task.spawn(function()
    while Skull.Parent do
        for _, a in ipairs({0.3, 0.9, 0.3}) do
            TweenService:Create(SkullStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = a}):Play()
            task.wait(1.2)
        end
    end
end)

-- ==========================================
-- MAIN WINDOW
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 380)
Main.Position = UDim2.new(0.5, -280, 0.5, -190)
Main.BackgroundColor3 = T.Bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = Screen
Round(Main, 14)
local MainStroke = Stroke(Main, T.Stroke, 1.5)
local MainShadow = Instance.new("ImageLabel")
MainShadow.Image = "rbxassetid://5028857084"
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(24,24,276,276)
MainShadow.BackgroundTransparency = 1
MainShadow.Size = UDim2.new(1, 40, 1, 40)
MainShadow.Position = UDim2.new(0, -20, 0, -20)
MainShadow.ImageColor3 = Color3.new(0,0,0)
MainShadow.ImageTransparency = 0.5
MainShadow.ZIndex = 0
MainShadow.Parent = Main

-- Title bar (draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

local TitleDot = Instance.new("Frame")
TitleDot.Size = UDim2.new(0, 10, 0, 10)
TitleDot.Position = UDim2.new(0, 14, 0, 15)
TitleDot.BackgroundColor3 = T.Accent
TitleDot.BorderSizePixel = 0
TitleDot.Parent = TitleBar
Round(TitleDot, 5)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -80, 1, 0)
TitleLbl.Position = UDim2.new(0, 32, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "LITE HACK  •  ULTIMATE MODS"
TitleLbl.Font = FONT_BOLD
TitleLbl.TextSize = 14
TitleLbl.TextColor3 = T.Text
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = TitleBar

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -36, 0, 7)
CloseBtn.BackgroundColor3 = T.Panel2
CloseBtn.Text = "×"
CloseBtn.Font = FONT_BOLD
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = T.Text
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar
Round(CloseBtn, 13)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- drag
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = i.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Tab Header (horizontal scroll)
local TabHeaderScroll = Instance.new("ScrollingFrame")
TabHeaderScroll.Size = UDim2.new(1, -20, 0, 40)
TabHeaderScroll.Position = UDim2.new(0, 10, 0, 46)
TabHeaderScroll.BackgroundTransparency = 1
TabHeaderScroll.BorderSizePixel = 0
TabHeaderScroll.ScrollBarThickness = 3
TabHeaderScroll.ScrollBarImageColor3 = T.Accent
TabHeaderScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabHeaderScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabHeaderScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabHeaderScroll.Parent = Main

local TabHeaderLayout = Instance.new("UIListLayout")
TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
TabHeaderLayout.Padding = UDim.new(0, 6)
TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabHeaderLayout.Parent = TabHeaderScroll

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -140)
Content.Position = UDim2.new(0, 10, 0, 92)
Content.BackgroundColor3 = T.Panel
Content.BorderSizePixel = 0
Content.Parent = Main
Round(Content, 10)
Stroke(Content, T.Stroke, 1)

-- ==========================================
-- UI COMPONENTS
-- ==========================================
local UI = {}

-- Toggle
function UI.Toggle(parent, text, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 34)
    row.BackgroundColor3 = T.Panel2
    row.BorderSizePixel = 0
    row.Parent = parent
    Round(row, 8)
    Stroke(row, T.Stroke, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = FONT_BOLD
    lbl.TextSize = 12
    lbl.TextColor3 = T.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local state = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 20)
    btn.Position = UDim2.new(1, -54, 0, 7)
    btn.BackgroundColor3 = state and T.ToggleOn or T.ToggleOff
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = row
    Round(btn, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Parent = btn
    Round(knob, 8)

    local function set(v)
        state = v
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        if callback then callback(state) end
    end

    btn.MouseButton1Click:Connect(function() set(not state) end)

    return {
        Set = function(v) set(v) end,
        Get = function() return state end,
        Row = row,
    }
end

-- Slider
function UI.Slider(parent, text, min, max, default, suffix, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 46)
    row.BackgroundColor3 = T.Panel2
    row.BorderSizePixel = 0
    row.Parent = parent
    Round(row, 8)
    Stroke(row, T.Stroke, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default) .. (suffix or "")
    lbl.Font = FONT_BOLD
    lbl.TextSize = 12
    lbl.TextColor3 = T.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 28)
    track.BackgroundColor3 = T.ToggleOff
    track.BorderSizePixel = 0
    track.Parent = row
    Round(track, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Round(fill, 3)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = track
    Round(knob, 7)

    local value = default
    local dragging = false
    local function update(input)
        local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + relX * (max - min))
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, 0, 0.5, 0)
        lbl.Text = text .. ": " .. tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Set = function(v)
            value = v
            local relX = (v - min) / (max - min)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            knob.Position = UDim2.new(relX, 0, 0.5, 0)
            lbl.Text = text .. ": " .. tostring(v) .. (suffix or "")
            if callback then callback(v) end
        end,
        Get = function() return value end,
    }
end

-- Checkbox
function UI.Checkbox(parent, text, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 30)
    row.BackgroundColor3 = T.Panel2
    row.BorderSizePixel = 0
    row.Parent = parent
    Round(row, 8)
    Stroke(row, T.Stroke, 1)

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 18, 0, 18)
    box.Position = UDim2.new(0, 10, 0, 6)
    box.BackgroundColor3 = default and T.Accent or T.ToggleOff
    box.Text = default and "✓" or ""
    box.Font = FONT_BOLD
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.AutoButtonColor = false
    box.Parent = row
    Round(box, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = FONT_BOLD
    lbl.TextSize = 12
    lbl.TextColor3 = T.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local state = default or false
    box.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and T.Accent or T.ToggleOff
        box.Text = state and "✓" or ""
        if callback then callback(state) end
    end)

    return {
        Set = function(v)
            state = v
            box.BackgroundColor3 = state and T.Accent or T.ToggleOff
            box.Text = state and "✓" or ""
            if callback then callback(state) end
        end,
        Get = function() return state end,
    }
end

-- Button
function UI.Button(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 34)
    b.BackgroundColor3 = T.Accent
    b.Text = text
    b.Font = FONT_BOLD
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.AutoButtonColor = false
    b.Parent = parent
    Round(b, 8)
    b.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return b
end

-- Label
function UI.Label(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = FONT_BOLD
    l.TextSize = 11
    l.TextColor3 = T.SubText
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end
-- ==========================================
-- COMBO BOX (dropdown) — dengan overlay fixed supaya tidak bug klik tembus
-- ==========================================
function UI.Combo(parent, text, options, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 34)
    row.BackgroundColor3 = T.Panel2
    row.BorderSizePixel = 0
    row.Parent = parent
    Round(row, 8)
    Stroke(row, T.Stroke, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -110, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = FONT_BOLD
    lbl.TextSize = 12
    lbl.TextColor3 = T.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local chosen = default or options[1]

    local display = Instance.new("TextButton")
    display.Size = UDim2.new(0, 90, 0, 22)
    display.Position = UDim2.new(1, -100, 0, 6)
    display.BackgroundColor3 = T.Panel
    display.Text = chosen .. " ▾"
    display.Font = FONT_BOLD
    display.TextSize = 11
    display.TextColor3 = T.Text
    display.AutoButtonColor = false
    display.Parent = row
    Round(display, 6)
    Stroke(display, T.Stroke, 1)

    -- Overlay (block all clicks when combo open)
    local Overlay = Instance.new("TextButton")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Text = ""
    Overlay.Visible = false
    Overlay.ZIndex = 500
    Overlay.Parent = Screen

    -- Dropdown list
    local drop = Instance.new("ScrollingFrame")
    drop.Size = UDim2.new(0, 130, 0, math.min(#options * 26 + 8, 160))
    drop.BackgroundColor3 = T.Panel
    drop.BorderSizePixel = 0
    drop.Visible = false
    drop.ZIndex = 600
    drop.ScrollBarThickness = 3
    drop.ScrollBarImageColor3 = T.Accent
    drop.CanvasSize = UDim2.new(0, 0, 0, #options * 26 + 4)
    drop.Parent = Screen
    Round(drop, 8)
    Stroke(drop, T.Stroke, 1)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = drop
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4); pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = drop

    local optionButtons = {}
    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, -8, 0, 22)
        ob.BackgroundColor3 = T.Panel2
        ob.Text = opt
        ob.Font = FONT_BOLD
        ob.TextSize = 11
        ob.TextColor3 = T.Text
        ob.AutoButtonColor = false
        ob.ZIndex = 601
        ob.Parent = drop
        Round(ob, 5)
        ob.MouseEnter:Connect(function() ob.BackgroundColor3 = T.Accent end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3 = T.Panel2 end)
        ob.MouseButton1Click:Connect(function()
            chosen = opt
            display.Text = chosen .. " ▾"
            drop.Visible = false
            Overlay.Visible = false
            if callback then callback(chosen) end
        end)
        table.insert(optionButtons, ob)
    end

    display.MouseButton1Click:Connect(function()
        local open = not drop.Visible
        drop.Visible = open
        Overlay.Visible = open
        if open then
            local ap = display.AbsolutePosition
            local sz = display.AbsoluteSize
            drop.Position = UDim2.new(0, ap.X - 40, 0, ap.Y + sz.Y + 4)
        end
    end)
    Overlay.MouseButton1Click:Connect(function()
        drop.Visible = false
        Overlay.Visible = false
    end)

    return {
        Set = function(v)
            chosen = v
            display.Text = chosen .. " ▾"
            if callback then callback(chosen) end
        end,
        Get = function() return chosen end,
    }
end

-- ==========================================
-- LIST BOX (scrollable selectable list)
-- ==========================================
function UI.ListBox(parent, text, height, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -20, 0, height or 130)
    box.BackgroundColor3 = T.Panel2
    box.BorderSizePixel = 0
    box.Parent = parent
    Round(box, 8)
    Stroke(box, T.Stroke, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = FONT_BOLD
    lbl.TextSize = 11
    lbl.TextColor3 = T.SubText
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = box

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -28)
    scroll.Position = UDim2.new(0, 6, 0, 24)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = T.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = box

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    local items = {}
    local api = {}

    function api.AddItem(itemText, value)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 26)
        b.BackgroundColor3 = T.Panel
        b.Text = itemText
        b.Font = FONT_BOLD
        b.TextSize = 11
        b.TextColor3 = T.Text
        b.AutoButtonColor = false
        b.Parent = scroll
        Round(b, 6)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = T.Accent end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = T.Panel end)
        b.MouseButton1Click:Connect(function()
            if callback then callback(value or itemText) end
        end)
        table.insert(items, b)
    end

    function api.Clear()
        for _, b in ipairs(items) do b:Destroy() end
        items = {}
    end

    return api
end

-- ==========================================
-- COLOR PICKER (RGB sliders + preview + hue bar)
-- ==========================================
function UI.ColorPicker(parent, text, defaultColor, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -20, 0, 140)
    box.BackgroundColor3 = T.Panel2
    box.BorderSizePixel = 0
    box.Parent = parent
    Round(box, 8)
    Stroke(box, T.Stroke, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = FONT_BOLD
    lbl.TextSize = 11
    lbl.TextColor3 = T.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = box

    -- preview
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 44, 0, 44)
    preview.Position = UDim2.new(0, 10, 0, 26)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel = 0
    preview.Parent = box
    Round(preview, 8)
    Stroke(preview, T.Stroke, 1)

    local color = defaultColor or Color3.fromRGB(255, 60, 60)

    local function fire()
        preview.BackgroundColor3 = color
        if callback then callback(color) end
    end

    -- RGB sliders (custom small)
    local function makeSlider(y, name, col, getter, setter)
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -80, 0, 6)
        track.Position = UDim2.new(0, 66, 0, y)
        track.BackgroundColor3 = T.ToggleOff
        track.BorderSizePixel = 0
        track.Parent = box
        Round(track, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(getter()/255, 0, 1, 0)
        fill.BackgroundColor3 = col
        fill.BorderSizePixel = 0
        fill.Parent = track
        Round(fill, 3)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(getter()/255, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 3
        knob.Parent = track
        Round(knob, 6)

        local tag = Instance.new("TextLabel")
        tag.Size = UDim2.new(0, 18, 0, 14)
        tag.Position = UDim2.new(0, 46, 0, y - 4)
        tag.BackgroundTransparency = 1
        tag.Text = name
        tag.Font = FONT_BOLD
        tag.TextSize = 11
        tag.TextColor3 = T.SubText
        tag.Parent = box

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 30, 0, 14)
        valLbl.Position = UDim2.new(1, -34, 0, y - 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(getter())
        valLbl.Font = FONT_MONO
        valLbl.TextSize = 11
        valLbl.TextColor3 = T.Text
        valLbl.Parent = box

        local dragging = false
        local function upd(input)
            local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = math.floor(rel * 255)
            setter(v)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text = tostring(v)
            color = Color3.fromRGB(color.R * 255, color.G * 255, color.B * 255)
            -- recompose properly
            local r = math.floor(color.R*255); local g = math.floor(color.G*255); local b = math.floor(color.B*255)
            if name == "R" then r = v end
            if name == "G" then g = v end
            if name == "B" then b = v end
            color = Color3.fromRGB(r, g, b)
            fire()
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; upd(i)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    makeSlider(30, "R", Color3.fromRGB(255,60,60),
        function() return math.floor(color.R*255) end,
        function(v) end)
    makeSlider(56, "G", Color3.fromRGB(60,255,60),
        function() return math.floor(color.G*255) end,
        function(v) end)
    makeSlider(82, "B", Color3.fromRGB(60,120,255),
        function() return math.floor(color.B*255) end,
        function(v) end)

    fire()
    return {
        Set = function(c) color = c; preview.BackgroundColor3 = c; fire() end,
        Get = function() return color end,
    }
end

-- ==========================================
-- TAB SYSTEM
-- ==========================================
local Tabs = {}
local CurrentTab = nil
local function CreateTab(name)
    -- header button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, -8)
    btn.Position = UDim2.new(0, 0, 0, 4)
    btn.BackgroundColor3 = T.Panel
    btn.Text = name
    btn.Font = FONT_BOLD
    btn.TextSize = 12
    btn.TextColor3 = T.SubText
    btn.AutoButtonColor = false
    btn.Parent = TabHeaderScroll
    Round(btn, 8)

    -- content page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = T.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 2); pad.PaddingRight = UDim.new(0, 2)
    pad.Parent = page

    local tabData = {Button = btn, Page = page, Name = name}
    Tabs[name] = tabData

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = T.Panel
            t.Button.TextColor3 = T.SubText
        end
        tabData.Page.Visible = true
        btn.BackgroundColor3 = T.Accent
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        CurrentTab = name
    end)

    return tabData
end

-- Create tabs
local VisualTab = CreateTab("Visual")
local PlayerTab = CreateTab("Player")
local AimbotTab = CreateTab("Aimbot")
local WorldTab  = CreateTab("World")
local ConfigTab = CreateTab("Config")

-- activate first
VisualTab.Button.BackgroundColor3 = T.Accent
VisualTab.Button.TextColor3 = Color3.fromRGB(255,255,255)
VisualTab.Page.Visible = true
CurrentTab = "Visual"

-- Skull toggle
Skull.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
-- ==========================================
-- GLOBAL STATE
-- ==========================================
local Flags = {
    -- ESP
    ESP_Enemy = false,
    ESP_Team = false,
    ESP_Box = true,
    ESP_Name = true,
    ESP_Line = false,
    ESP_Health = false,
    ESP_Skeleton = false,
    ESP_Distance = true,
    ESP_Picture = false,
    ESP_Color = Color3.fromRGB(255, 60, 60),

    -- Aimbot
    Aimbot = false,
    TeamCheck = true,
    WallCheck = true,
    AimMode = "FOV",
    TriggerMode = "Camera",
    AimFOVShow = true,
    AimFOVSize = 150,
    AimLine = true,
    AimTarget = "Head",
    AimDistance = 500,

    -- Player
    SpeedRun = false,
    SpeedPercent = 100,
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

local FFAModeAktif = false -- internal
UI.Label(VisualTab.Page, "ESP FILTER")
Flags._ESPEnemyToggle = UI.Toggle(VisualTab.Page, "ESP Enemy (semua player bukan team)", false, function(v) Flags.ESP_Enemy = v end)
Flags._ESPTeamToggle  = UI.Toggle(VisualTab.Page, "ESP Team (player satu tim)", false, function(v) Flags.ESP_Team = v end)

UI.Label(VisualTab.Page, "ESP KOMPONEN")
Flags._CBox   = UI.Checkbox(VisualTab.Page, "Box (kotak musuh)", true,  function(v) Flags.ESP_Box = v end)
Flags._CName  = UI.Checkbox(VisualTab.Page, "Name (nama di atas box)", true, function(v) Flags.ESP_Name = v end)
Flags._CLine  = UI.Checkbox(VisualTab.Page, "Line (garis dari kepala)", false, function(v) Flags.ESP_Line = v end)
Flags._CHealth= UI.Checkbox(VisualTab.Page, "Health (dinamis: hijau >70% orange >40% merah)", false, function(v) Flags.ESP_Health = v end)
Flags._CSkel  = UI.Checkbox(VisualTab.Page, "Skeleton (tulang)", false, function(v) Flags.ESP_Skeleton = v end)
Flags._CDist  = UI.Checkbox(VisualTab.Page, "Distance (jarak di bawah box)", true, function(v) Flags.ESP_Distance = v end)
Flags._CPict  = UI.Checkbox(VisualTab.Page, "Picture (foto profil bulat di atas kepala)", false, function(v) Flags.ESP_Picture = v end)

UI.Label(VisualTab.Page, "WARNA ESP (berlaku untuk semua jenis ESP)")
Flags._CPicker = UI.ColorPicker(VisualTab.Page, "Warna ESP", Color3.fromRGB(255,60,60), function(c)
    Flags.ESP_Color = c
end)
UI.Label(AimbotTab.Page, "AIMBOT UTAMA")
Flags._AimbotT = UI.Toggle(AimbotTab.Page, "Aimbot ON/OFF", false, function(v) Flags.Aimbot = v end)
Flags._TeamT   = UI.Toggle(AimbotTab.Page, "Team Check (lewati player satu tim)", true, function(v) Flags.TeamCheck = v end)
Flags._WallT   = UI.Toggle(AimbotTab.Page, "Wall Check (lewati target di balik tembok)", true, function(v) Flags.WallCheck = v end)

Flags._AimModeC = UI.Combo(AimbotTab.Page, "Mode Aimbot", {"FOV", "360°"}, "FOV", function(v) Flags.AimMode = v end)
Flags._TrigModeC = UI.Combo(AimbotTab.Page, "Mode Trigger", {"Camera", "Fire (Snap)"}, "Camera", function(v) Flags.TriggerMode = v end)

Flags._AimFOVT = UI.Toggle(AimbotTab.Page, "Tampilkan Lingkaran FOV", true, function(v) Flags.AimFOVShow = v end)
Flags._AimFOVS = UI.Slider(AimbotTab.Page, "Ukuran FOV", 30, 600, 150, " px", function(v) Flags.AimFOVSize = v end)
Flags._AimLineT = UI.Toggle(AimbotTab.Page, "Garis Aim (FOV → Target)", true, function(v) Flags.AimLine = v end)

Flags._AimTargetC = UI.Combo(AimbotTab.Page, "Target Bagian Tubuh", {"Head", "Neck", "Chest"}, "Head", function(v) Flags.AimTarget = v end)
Flags._AimDistS = UI.Slider(AimbotTab.Page, "Aim Distance", 50, 2000, 500, " m", function(v) Flags.AimDistance = v end)
UI.Label(PlayerTab.Page, "GERAKAN")
Flags._SpeedT = UI.Toggle(PlayerTab.Page, "Speed Run", false, function(v) Flags.SpeedRun = v end)
Flags._SpeedS = UI.Slider(PlayerTab.Page, "Speed %", 50, 500, 100, "%", function(v) Flags.SpeedPercent = v end)

Flags._MultiJT = UI.Toggle(PlayerTab.Page, "Multi Jump (bisa lompat lagi di udara)", false, function(v) Flags.MultiJump = v end)
Flags._FlyT    = UI.Toggle(PlayerTab.Page, "Fly Hack (tahan Space untuk melayang)", false, function(v) Flags.FlyHack = v end)

UI.Label(PlayerTab.Page, "SENJATA")
Flags._RapidT = UI.Toggle(PlayerTab.Page, "Rapid Fire (tembakan cepat)", false, function(v) Flags.RapidFire = v end)
Flags._UnliT  = UI.Toggle(PlayerTab.Page, "Unlimited Ammo (peluru tak terbatas)", false, function(v) Flags.UnlimitedAmmo = v end)
UI.Label(WorldTab.Page, "WAKTU & SUASANA")
Flags._ClockC = UI.Combo(WorldTab.Page, "Clock Time", {"Default","Pagi","Siang","Sore","Malam"}, "Default", function(v)
    Flags.ClockTime = v
    pcall(function()
        if v == "Pagi" then Lighting.ClockTime = 6; Lighting.Brightness = 2
        elseif v == "Siang" then Lighting.ClockTime = 14; Lighting.Brightness = 3
        elseif v == "Sore" then Lighting.ClockTime = 18; Lighting.Brightness = 2
        elseif v == "Malam" then Lighting.ClockTime = 0; Lighting.Brightness = 1
        end
    end)
end)

Flags._NoGravT = UI.Toggle(WorldTab.Page, "No Gravity (efek gravitasi rendah)", false, function(v)
    Flags.NoGravity = v
    pcall(function() workspace.Gravity = v and 0 or 196.2 end)
end)

UI.Label(WorldTab.Page, "TELEPORT KE PLAYER (klik untuk teleport)")
Flags._TPList = UI.ListBox(WorldTab.Page, "Daftar Player", 180, function(plr)
    pcall(function()
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        end
    end)
end)

-- populate teleport list
local function RefreshTPList()
    Flags._TPList.Clear()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            Flags._TPList.AddItem(p.DisplayName .. " (@" .. p.Name .. ")", p)
        end
    end
end
RefreshTPList()
Players.PlayerAdded:Connect(function() task.wait(0.5); RefreshTPList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); RefreshTPList() end)
UI.Label(ConfigTab.Page, "TEMA UI")
Flags._ThemeC = UI.Combo(ConfigTab.Page, "Theme", {"Dark", "Light"}, "Dark", function(v)
    CurrentTheme = v; T = Themes[CurrentTheme]
    Flags.Theme = v
    -- reapply semua warna dasar (simple reapply inti saja)
    Main.BackgroundColor3 = T.Bg
    MainStroke.Color = T.Stroke
    TitleLbl.TextColor3 = T.Text
    Content.BackgroundColor3 = T.Panel
    Skull.BackgroundColor3 = T.Panel
    Skull.TextColor3 = T.Accent
    SkullStroke.Color = T.Accent
    for _, tab in pairs(Tabs) do
        tab.Button.BackgroundColor3 = (tab.Name == CurrentTab) and T.Accent or T.Panel
        tab.Button.TextColor3 = (tab.Name == CurrentTab) and Color3.fromRGB(255,255,255) or T.SubText
    end
end)

UI.Label(ConfigTab.Page, "KONFIGURASI")
local CONFIG_FILE = "LiteHack_Config.json"

local function SaveConfig()
    if not writefile then
        return false, "Executor tidak mendukung writefile"
    end
    local data = {}
    for k, v in pairs(Flags) do
        if type(k) == "string" and k:sub(1,1) ~= "_" and type(v) ~= "function" and type(v) ~= "userdata" then
            if typeof(v) == "Color3" then
                data[k] = {__Color3 = true, R = v.R, G = v.G, B = v.B}
            else
                data[k] = v
            end
        end
    end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
    end)
    return true
end

local function LoadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return false end
    local ok, raw = pcall(readfile, CONFIG_FILE)
    if not ok or not raw then return false end
    local data = HttpService:JSONDecode(raw)
    for k, v in pairs(data) do
        if type(v) == "table" and v.__Color3 then
            Flags[k] = Color3.new(v.R, v.G, v.B)
        else
            Flags[k] = v
        end
    end
    -- apply
    Flags._ESPEnemyToggle:Set(Flags.ESP_Enemy)
    Flags._ESPTeamToggle:Set(Flags.ESP_Team)
    Flags._CBox:Set(Flags.ESP_Box); Flags._CName:Set(Flags.ESP_Name)
    Flags._CLine:Set(Flags.ESP_Line); Flags._CHealth:Set(Flags.ESP_Health)
    Flags._CSkel:Set(Flags.ESP_Skeleton); Flags._CDist:Set(Flags.ESP_Distance)
    Flags._CPict:Set(Flags.ESP_Picture)
    Flags._CPicker:Set(Flags.ESP_Color)

    Flags._AimbotT:Set(Flags.Aimbot); Flags._TeamT:Set(Flags.TeamCheck); Flags._WallT:Set(Flags.WallCheck)
    Flags._AimModeC:Set(Flags.AimMode); Flags._TrigModeC:Set(Flags.TriggerMode)
    Flags._AimFOVT:Set(Flags.AimFOVShow); Flags._AimFOVS:Set(Flags.AimFOVSize); Flags._AimLineT:Set(Flags.AimLine)
    Flags._AimTargetC:Set(Flags.AimTarget); Flags._AimDistS:Set(Flags.AimDistance)

    Flags._SpeedT:Set(Flags.SpeedRun); Flags._SpeedS:Set(Flags.SpeedPercent)
    Flags._MultiJT:Set(Flags.MultiJump); Flags._FlyT:Set(Flags.FlyHack)
    Flags._RapidT:Set(Flags.RapidFire); Flags._UnliT:Set(Flags.UnlimitedAmmo)

    Flags._ClockC:Set(Flags.ClockTime); Flags._NoGravT:Set(Flags.NoGravity)
    Flags._ThemeC:Set(Flags.Theme)
    return true
end

UI.Button(ConfigTab.Page, "💾 SAVE CONFIG (JSON)", function()
    local ok = SaveConfig()
    print(ok and "[LiteHack] Config tersimpan." or "[LiteHack] Gagal menyimpan.")
end)
UI.Button(ConfigTab.Page, "📂 LOAD CONFIG (JSON)", function()
    local ok = LoadConfig()
    print(ok and "[LiteHack] Config dimuat." or "[LiteHack] Gagal memuat.")
end)
-- ==========================================
-- ENTITY CACHE
-- ==========================================
local ValidEntities = {}
task.spawn(function()
    while task.wait(0.4) do
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                table.insert(list, p.Character)
            end
        end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character
               and not Players:GetPlayerFromCharacter(obj)
               and obj:FindFirstChildOfClass("Humanoid") then
                table.insert(list, obj)
            end
        end
        ValidEntities = list
    end
end)

local function IsEnemy(model)
    if FFAModeAktif then return true end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end
    return true
end
local function IsTeam(model)
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    return false
end

-- ==========================================
-- ESP DRAWING SYSTEM (pakai Drawing API, tidak perlu BillboardGui)
-- ==========================================
local Drawing = Drawing or (getgenv and getgenv().Drawing) or nil

local ActiveESP = {} -- [model] = {box=..., name=..., dist=..., line=..., healthBg=..., healthFg=..., skel={}, pic=...}

local function newDraw(class, props)
    if not Drawing then return nil end
    local d = Drawing.new(class)
    for k, v in pairs(props or {}) do d[k] = v end
    d.Visible = false
    return d
end

local function removeESP(data)
    for _, d in pairs(data) do
        if type(d) == "table" then
            for _, sub in pairs(d) do pcall(function() sub:Remove() end) end
        elseif d and d.Remove then
            pcall(function() d:Remove() end)
        end
    end
end

local function getHealthColor(hp)
    if hp >= 70 then return Color3.fromRGB(50, 220, 80)
    elseif hp >= 40 then return Color3.fromRGB(255, 170, 40)
    else return Color3.fromRGB(200, 40, 40) end
end

-- picture cache
local PicCache = {}
local function getThumb(plr)
    if PicCache[plr] then return PicCache[plr] end
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok then PicCache[plr] = img; return img end
    return nil
end

RunService.RenderStepped:Connect(function()
    if not Drawing then return end
    local cam = workspace.CurrentCamera
    local viewport = cam.ViewportSize
    local center = Vector2.new(viewport.X/2, viewport.Y/2)

    local seen = {}
    for _, model in ipairs(ValidEntities) do
        local hum = model:FindFirstChildOfClass("Humanoid")
        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
        local isEnemyM = IsEnemy(model)
        local isTeamM  = IsTeam(model)

        local active = (isEnemyM and Flags.ESP_Enemy) or (isTeamM and Flags.ESP_Team)

        if active and model.Parent and hum and hum.Health > 0 and hrp then
            seen[model] = true
            if not ActiveESP[model] then
                ActiveESP[model] = {
                    box = newDraw("Square", {Thickness = 2, Filled = false}),
                    name = newDraw("Text", {Size = 14, Center = true, Outline = true, Font = 2}),
                    dist = newDraw("Text", {Size = 12, Center = true, Outline = true, Font = 2}),
                    line = newDraw("Line", {Thickness = 2}),
                    healthBg = newDraw("Square", {Thickness = 1, Filled = true}),
                    healthFg = newDraw("Square", {Thickness = 0, Filled = true}),
                    skel = {},
                    pic = nil,
                }
            end
            local data = ActiveESP[model]

            local head = model:FindFirstChild("Head")
            local topPos = hrp.Position + Vector3.new(0, 3, 0)
            local botPos = hrp.Position - Vector3.new(0, 2.5, 0)

            local top, onTop = cam:WorldToViewportPoint(topPos)
            local bot, onBot = cam:WorldToViewportPoint(botPos)
            if not (onTop and onBot) then
                -- sembunyikan
                if data.box then data.box.Visible = false end
                if data.name then data.name.Visible = false end
                if data.dist then data.dist.Visible = false end
                if data.line then data.line.Visible = false end
                if data.healthBg then data.healthBg.Visible = false end
                if data.healthFg then data.healthFg.Visible = false end
                for _, l in pairs(data.skel) do l.Visible = false end
                if data.pic then data.pic.Visible = false end
                continue
            end

            local height = math.abs(bot.Y - top.Y)
            local width = height * 0.55
            local boxX = top.X - width/2
            local boxY = top.Y
            local col = Flags.ESP_Color

            -- BOX
            if Flags.ESP_Box then
                data.box.Visible = true
                data.box.Color = col
                data.box.Size = Vector2.new(width, height)
                data.box.Position = Vector2.new(boxX, boxY)
            else data.box.Visible = false end

            -- NAME (atas box)
            if Flags.ESP_Name then
                data.name.Visible = true
                data.name.Color = col
                data.name.Position = Vector2.new(top.X, boxY - 20)
                data.name.Text = model.Name
            else data.name.Visible = false end

            -- DISTANCE (bawah box)
            if Flags.ESP_Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                local dist = math.floor((myPos - hrp.Position).Magnitude)
                data.dist.Visible = true
                data.dist.Color = col
                data.dist.Position = Vector2.new(top.X, boxY + height + 4)
                data.dist.Text = dist .. " m"
            else data.dist.Visible = false end

            -- LINE (dari kepala player kita)
            if Flags.ESP_Line and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local myHead, ok = cam:WorldToViewportPoint(LocalPlayer.Character.Head.Position)
                if ok then
                    data.line.Visible = true
                    data.line.Color = col
                    data.line.From = Vector2.new(myHead.X, myHead.Y)
                    data.line.To   = Vector2.new(top.X, boxY)
                else data.line.Visible = false end
            else data.line.Visible = false end

            -- HEALTH (kanan box, volume dinamis)
            if Flags.ESP_Health then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1) * 100
                local hc = getHealthColor(hp)
                local hbX = boxX + width + 3
                data.healthBg.Visible = true
                data.healthBg.Color = Color3.fromRGB(20,20,20)
                data.healthBg.Size = Vector2.new(4, height)
                data.healthBg.Position = Vector2.new(hbX, boxY)
                data.healthFg.Visible = true
                data.healthFg.Color = hc
                local fh = height * (hp/100)
                data.healthFg.Size = Vector2.new(4, fh)
                data.healthFg.Position = Vector2.new(hbX, boxY + (height - fh))
            else
                data.healthBg.Visible = false
                data.healthFg.Visible = false
            end

            -- SKELETON
            local skelNames = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","RightUpperArm","RightLowerArm","LeftUpperLeg","LeftLowerLeg","RightUpperLeg","RightLowerLeg"}
            local skelConn = {
                {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
                {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
                {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},
                {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
                {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},
            }
            if Flags.ESP_Skeleton then
                for i, pair_ in ipairs(skelConn) do
                    if not data.skel[i] then
                        data.skel[i] = newDraw("Line", {Thickness = 2})
                    end
                    local a, b = model:FindFirstChild(pair_[1]), model:FindFirstChild(pair_[2])
                    if a and b then
                        local av, aOk = cam:WorldToViewportPoint(a.Position)
                        local bv, bOk = cam:WorldToViewportPoint(b.Position)
                        if aOk and bOk then
                            data.skel[i].Visible = true
                            data.skel[i].Color = col
                            data.skel[i].From = Vector2.new(av.X, av.Y)
                            data.skel[i].To   = Vector2.new(bv.X, bv.Y)
                        else
                            data.skel[i].Visible = false
                        end
                    else
                        data.skel[i].Visible = false
                    end
                end
            else
                for _, l in pairs(data.skel) do l.Visible = false end
            end

            -- PICTURE (bulat di atas kepala, ada spasi)
            local plr = Players:GetPlayerFromCharacter(model)
            if Flags.ESP_Picture and plr then
                local thumb = getThumb(plr)
                if thumb then
                    if not data.pic then
                        data.pic = newDraw("Image", {Size = Vector2.new(38, 38), Transparency = 1})
                    end
                    data.pic.Visible = true
                    data.pic.Data = thumb
                    data.pic.Size = Vector2.new(38, 38)
                    data.pic.Position = Vector2.new(top.X - 19, boxY - 60) -- 22px spasi dari kepala
                elseif data.pic then data.pic.Visible = false end
            elseif data.pic then data.pic.Visible = false end
        else
            -- sembunyikan kalau tidak aktif
            if ActiveESP[model] then
                local data = ActiveESP[model]
                if data.box then data.box.Visible = false end
                if data.name then data.name.Visible = false end
                if data.dist then data.dist.Visible = false end
                if data.line then data.line.Visible = false end
                if data.healthBg then data.healthBg.Visible = false end
                if data.healthFg then data.healthFg.Visible = false end
                for _, l in pairs(data.skel) do l.Visible = false end
                if data.pic then data.pic.Visible = false end
            end
        end
    end
    for model, data in pairs(ActiveESP) do
        if not seen[model] then
            removeESP(data)
            ActiveESP[model] = nil
        end
    end
end)

-- ==========================================
-- FOV CIRCLE + AIM LINE (pakai Drawing)
-- ==========================================
local FOVCircle = newDraw("Circle", {Thickness = 2, Filled = false, NumSides = 64})
local AimLineDraw = newDraw("Line", {Thickness = 2})

RunService.RenderStepped:Connect(function()
    if not Drawing then return end
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    if Flags.Aimbot and Flags.AimFOVShow and Flags.AimMode == "FOV" then
        FOVCircle.Visible = true
        FOVCircle.Position = center
        FOVCircle.Radius = Flags.AimFOVSize
        FOVCircle.Color = Flags.ESP_Color
    else
        FOVCircle.Visible = false
    end
end)
