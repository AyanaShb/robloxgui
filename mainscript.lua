-- ==========================================
-- SERVICE
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- AUTO BYPASS ANTI-CHEAT (COPY PASTE)
-- ==========================================
task.spawn(function()
    pcall(function()
        if setreadonly then
            pcall(function()
                setreadonly(getrenv(), false)
                setreadonly(getreg(), false)
                setreadonly(getgc(), false)
            end)
        end
        if make_writeable then
            pcall(function()
                make_writeable(getreg())
            end)
        end
        if detour_function then
            detour_function = function(...) return true end
        end
        if getconnections then
            pcall(function()
                for _, connection in ipairs(getconnections(ScriptContext.Error)) do
                    connection:Disable()
                end
            end)
        end
        if getcallingscript then
            pcall(function()
                getcallingscript = function() return nil end
            end)
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
-- CUSTOM IMGUI LIBRARY (FROM SCRATCH)
-- ==========================================
local IMGUI = {}
IMGUI.__index = IMGUI

local Themes = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 22),
        Panel      = Color3.fromRGB(26, 26, 32),
        Header     = Color3.fromRGB(34, 34, 42),
        Accent     = Color3.fromRGB(0, 200, 255),
        Accent2    = Color3.fromRGB(255, 60, 120),
        Text       = Color3.fromRGB(235, 235, 245),
        SubText    = Color3.fromRGB(150, 150, 165),
        ToggleOff  = Color3.fromRGB(60, 60, 72),
        ToggleOn   = Color3.fromRGB(0, 200, 255),
        Slider     = Color3.fromRGB(70, 70, 85),
        SliderFill = Color3.fromRGB(0, 200, 255),
        Stroke     = Color3.fromRGB(55, 55, 68),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Panel      = Color3.fromRGB(255, 255, 255),
        Header     = Color3.fromRGB(225, 225, 235),
        Accent     = Color3.fromRGB(0, 140, 220),
        Accent2    = Color3.fromRGB(230, 60, 120),
        Text       = Color3.fromRGB(25, 25, 35),
        SubText    = Color3.fromRGB(90, 90, 105),
        ToggleOff  = Color3.fromRGB(190, 190, 200),
        ToggleOn   = Color3.fromRGB(0, 140, 220),
        Slider     = Color3.fromRGB(200, 200, 215),
        SliderFill = Color3.fromRGB(0, 140, 220),
        Stroke     = Color3.fromRGB(180, 180, 195),
    },
}

local CurrentTheme = Themes.Dark

-- CoreGui
local ParentGui = (gethui and gethui()) or game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IMGUI_Universal"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- Floating Skull Icon
local SkullBtn = Instance.new("TextButton")
SkullBtn.Name = "SkullBtn"
SkullBtn.Size = UDim2.new(0, 60, 0, 60)
SkullBtn.Position = UDim2.new(0, 20, 0.5, -30)
SkullBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
SkullBtn.BorderSizePixel = 0
SkullBtn.Text = "💀"
SkullBtn.TextSize = 34
SkullBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
SkullBtn.AutoButtonColor = false
SkullBtn.Active = true
SkullBtn.Draggable = false
SkullBtn.Parent = ScreenGui

local SkullCorner = Instance.new("UICorner")
SkullCorner.CornerRadius = UDim.new(1, 0)
SkullCorner.Parent = SkullBtn

local SkullStroke = Instance.new("UIStroke")
SkullStroke.Color = Color3.fromRGB(0, 220, 255)
SkullStroke.Thickness = 2
SkullStroke.Transparency = 0.2
SkullStroke.Parent = SkullBtn

local SkullGlow = Instance.new("ImageLabel")
SkullGlow.BackgroundTransparency = 1
SkullGlow.Image = "rbxassetid://5028857084"
SkullGlow.ImageColor3 = Color3.fromRGB(0, 220, 255)
SkullGlow.ImageTransparency = 0.55
SkullGlow.Size = UDim2.new(1, 20, 1, 20)
SkullGlow.Position = UDim2.new(0, -10, 0, -10)
SkullGlow.ZIndex = 0
SkullGlow.Parent = SkullBtn

-- Glow pulse
task.spawn(function()
    while SkullBtn.Parent do
        TweenService:Create(SkullStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
        TweenService:Create(SkullGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.85}):Play()
        task.wait(1.2)
        TweenService:Create(SkullStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.15}):Play()
        TweenService:Create(SkullGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.45}):Play()
        task.wait(1.2)
    end
end)

-- Drag skull
do
    local dragging, dragInput, dragStart, startPos
    SkullBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = SkullBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    SkullBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            SkullBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 400)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
MainFrame.BackgroundColor3 = CurrentTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CurrentTheme.Stroke
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Window Drag
do
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

SkullBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = CurrentTheme.Header
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "💀 ULTIMATE MODS"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = CurrentTheme.Accent
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Header Bar (horizontal scroll, wrapped)
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, -16, 0, 40)
TabScroll.Position = UDim2.new(0, 8, 0, 50)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 3
TabScroll.ScrollBarImageColor3 = CurrentTheme.Accent
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabScroll

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingRight = UDim.new(0, 4)
TabPadding.PaddingTop = UDim.new(0, 4)
TabPadding.Parent = TabScroll

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -20, 1, -110)
ContentArea.Position = UDim2.new(0, 10, 0, 96)
ContentArea.BackgroundColor3 = CurrentTheme.Panel
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentArea

-- Page container
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, 0, 1, 0)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentArea

-- API
function IMGUI:CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 30)
    btn.BackgroundColor3 = CurrentTheme.ToggleOff
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = CurrentTheme.Text
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TabScroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    local tab = {Button = btn, Page = page, Layout = layout}

    local allTabs = {}
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(ScreenGui:GetDescendants()) do
            if t:IsA("TextButton") and t.Parent == TabScroll then
                t.BackgroundColor3 = CurrentTheme.ToggleOff
            end
        end
        for _, p in ipairs(PageContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        btn.BackgroundColor3 = CurrentTheme.Accent
        page.Visible = true
    end)

    if #PageContainer:GetChildren() == 1 then
        btn.BackgroundColor3 = CurrentTheme.Accent
        page.Visible = true
    end

    return tab
end

-- Toggle
function IMGUI:CreateToggle(parent, text, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 34)
    holder.BackgroundTransparency = 1
    holder.Parent = parent.Page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = CurrentTheme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(0, 46, 0, 24)
    bg.Position = UDim2.new(1, -46, 0.5, -12)
    bg.BackgroundColor3 = default and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff
    bg.Text = ""
    bg.BorderSizePixel = 0
    bg.AutoButtonColor = false
    bg.Parent = holder

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = bg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local state = default
    local api = {Value = state}
    function api:Set(v)
        state = v
        api.Value = v
        TweenService:Create(bg, TweenInfo.new(0.15), {BackgroundColor3 = v and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        if callback then callback(v) end
    end
    bg.MouseButton1Click:Connect(function()
        api:Set(not state)
    end)
    return api
end

-- Slider
function IMGUI:CreateSlider(parent, text, min, max, default, suffix, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 46)
    holder.BackgroundTransparency = 1
    holder.Parent = parent.Page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default) .. (suffix or "")
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = CurrentTheme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 26)
    bar.BackgroundColor3 = CurrentTheme.Slider
    bar.BorderSizePixel = 0
    bar.Parent = holder
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = CurrentTheme.SliderFill
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = bar
    local kc2 = Instance.new("UICorner")
    kc2.CornerRadius = UDim.new(1, 0)
    kc2.Parent = knob

    local value = default
    local dragging = false

    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -9, 0.5, -9)
        label.Text = text .. ": " .. tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local api = {Value = value}
    function api:Set(v)
        value = math.clamp(v, min, max)
        api.Value = value
        local rel = (value - min) / (max - min)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -9, 0.5, -9)
        label.Text = text .. ": " .. tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end
    return api
end

-- Button
function IMGUI:CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 34)
    btn.BackgroundColor3 = CurrentTheme.Header
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = CurrentTheme.Text
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent.Page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- Label
function IMGUI:CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -4, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextColor3 = CurrentTheme.SubText
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = parent.Page
    return lbl
end
-- Combo Box (fixed touch bug with overlay blocker)
function IMGUI:CreateCombo(parent, text, options, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 34)
    holder.BackgroundTransparency = 1
    holder.Parent = parent.Page

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = CurrentTheme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.6, -4, 1, 0)
    btn.Position = UDim2.new(0.4, 4, 0, 0)
    btn.BackgroundColor3 = CurrentTheme.Header
    btn.Text = default .. "  ▾"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = CurrentTheme.Text
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = holder
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local current = default
    local api = {Value = current}

    local overlay
    local isOpen = false

    local function closeOverlay()
        if overlay then overlay:Destroy() overlay = nil end
        isOpen = false
    end

    local function openOverlay()
        isOpen = true
        overlay = Instance.new("TextButton")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundTransparency = 1
        overlay.Text = ""
        overlay.ZIndex = 100
        overlay.Parent = ScreenGui
        overlay.MouseButton1Click:Connect(closeOverlay)

        local dropdown = Instance.new("Frame")
        dropdown.ZIndex = 101
        dropdown.BackgroundColor3 = CurrentTheme.Panel
        dropdown.BorderSizePixel = 0
        dropdown.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, math.min(#options * 30, 180))
        dropdown.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 2)
        dropdown.Parent = ScreenGui
        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(0, 8)
        dc.Parent = dropdown
        local ds = Instance.new("UIStroke")
        ds.Color = CurrentTheme.Accent
        ds.Parent = dropdown

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = CurrentTheme.Accent
        scroll.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
        scroll.ZIndex = 102
        scroll.Parent = dropdown

        for i, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.Size = UDim2.new(1, -8, 0, 28)
            ob.Position = UDim2.new(0, 4, 0, (i - 1) * 30 + 1)
            ob.BackgroundColor3 = (opt == current) and CurrentTheme.Accent or CurrentTheme.Header
            ob.Text = opt
            ob.Font = Enum.Font.GothamBold
            ob.TextSize = 12
            ob.TextColor3 = (opt == current) and Color3.fromRGB(255,255,255) or CurrentTheme.Text
            ob.BorderSizePixel = 0
            ob.AutoButtonColor = false
            ob.ZIndex = 103
            ob.Parent = scroll
            local oc = Instance.new("UICorner")
            oc.CornerRadius = UDim.new(0, 6)
            oc.Parent = ob
            ob.MouseButton1Click:Connect(function()
                current = opt
                api.Value = opt
                btn.Text = opt .. "  ▾"
                closeOverlay()
                if callback then callback(opt) end
            end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        if isOpen then closeOverlay() else openOverlay() end
    end)

    function api:Set(v)
        current = v
        api.Value = v
        btn.Text = v .. "  ▾"
        if callback then callback(v) end
    end
    return api
end

-- List Box (multi-select / single)
function IMGUI:CreateList(parent, text, options, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 150)
    holder.BackgroundColor3 = CurrentTheme.Header
    holder.BorderSizePixel = 0
    holder.Parent = parent.Page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = holder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 20)
    lbl.Position = UDim2.new(0, 8, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = CurrentTheme.SubText
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -28)
    scroll.Position = UDim2.new(0, 4, 0, 26)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = CurrentTheme.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    scroll.Parent = holder

    local api = {}

    function api:Refresh(newOptions)
        for _, ch in ipairs(scroll:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        for i, opt in ipairs(newOptions) do
            local ob = Instance.new("TextButton")
            ob.Size = UDim2.new(1, -4, 0, 26)
            ob.Position = UDim2.new(0, 2, 0, (i - 1) * 28)
            ob.BackgroundColor3 = CurrentTheme.Panel
            ob.Text = opt
            ob.Font = Enum.Font.GothamBold
            ob.TextSize = 12
            ob.TextColor3 = CurrentTheme.Text
            ob.BorderSizePixel = 0
            ob.AutoButtonColor = false
            ob.Parent = scroll
            local oc = Instance.new("UICorner")
            oc.CornerRadius = UDim.new(0, 6)
            oc.Parent = ob
            ob.MouseButton1Click:Connect(function()
                if callback then callback(opt) end
            end)
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, #newOptions * 28 + 4)
    end

    api:Refresh(options)
    return api
end

-- RGB Color Picker
function IMGUI:CreateColorPicker(parent, text, defaultColor, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 130)
    holder.BackgroundColor3 = CurrentTheme.Header
    holder.BorderSizePixel = 0
    holder.Parent = parent.Page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = holder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 20)
    lbl.Position = UDim2.new(0, 8, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = CurrentTheme.SubText
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 60, 0, 20)
    preview.Position = UDim2.new(1, -70, 0, 4)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel = 0
    preview.Parent = holder
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 6)
    pc.Parent = preview

    local r, g, b = defaultColor.R * 255, defaultColor.G * 255, defaultColor.B * 255
    local api = {Color = defaultColor}

    local function mkSlider(y, name, init, minv, maxv, cb)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -16, 0, 24)
        row.Position = UDim2.new(0, 8, 0, y)
        row.BackgroundTransparency = 1
        row.Parent = holder
        local nm = Instance.new("TextLabel")
        nm.Size = UDim2.new(0, 14, 1, 0)
        nm.BackgroundTransparency = 1
        nm.Text = name
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 12
        nm.TextColor3 = CurrentTheme.Text
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.Parent = row
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0, 34, 1, 0)
        val.Position = UDim2.new(1, -34, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = tostring(math.floor(init))
        val.Font = Enum.Font.GothamBold
        val.TextSize = 12
        val.TextColor3 = CurrentTheme.Text
        val.Parent = row
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -94, 0, 8)
        bar.Position = UDim2.new(0, 20, 0.5, -4)
        bar.BackgroundColor3 = CurrentTheme.Slider
        bar.BorderSizePixel = 0
        bar.Parent = row
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(1, 0)
        bc.Parent = bar
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((init - minv) / (maxv - minv), 0, 1, 0)
        fill.BackgroundColor3 = CurrentTheme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = bar
        local fc = Instance.new("UICorner")
        fc.CornerRadius = UDim.new(1, 0)
        fc.Parent = fill
        local dragging = false
        local function upd(input)
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(minv + (maxv - minv) * rel + 0.5)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            val.Text = tostring(v)
            cb(v)
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                upd(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                upd(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local function updateColor()
        local col = Color3.fromRGB(r, g, b)
        preview.BackgroundColor3 = col
        api.Color = col
        if callback then callback(col) end
    end

    mkSlider(28, "R", r, 0, 255, function(v) r = v; updateColor() end)
    mkSlider(54, "G", g, 0, 255, function(v) g = v; updateColor() end)
    mkSlider(80, "B", b, 0, 255, function(v) b = v; updateColor() end)

    function api:Set(col)
        r, g, b = col.R * 255, col.G * 255, col.B * 255
        preview.BackgroundColor3 = col
        api.Color = col
        if callback then callback(col) end
    end
    return api
end

-- ==========================================
-- CREATE TABS
-- ==========================================
local VisualTab = IMGUI:CreateTab("VISUAL")
local PlayerTab = IMGUI:CreateTab("PLAYER")
local AimbotTab = IMGUI:CreateTab("AIMBOT")
local WorldTab  = IMGUI:CreateTab("WORLD")
local ConfigTab = IMGUI:CreateTab("CONFIG")

-- ==========================================
-- VARIABEL SISTEM
-- ==========================================
local AimbotAktif = false
local AimbotMode = "FOV"
local TriggerMode = "Camera"
local AimTargetMode = "Head"
local TeamCheckAktif = true
local WallCheckAktif = true
local ShowFOV = false
local FOVRadius = 150
local AimLine = false
local AimDistance = 500
local AimbotSmoothness = 15

local ESPEnemyAktif = false
local ESPTeamAktif = false
local ESPColor = Color3.fromRGB(255, 60, 60)
local ESPOptions = {
    Box = false, Name = false, Line = false, Health = false,
    Skeleton = false, Distance = false, Picture = false
}

local SpeedAktif = false
local CustomSpeedPercent = 150
local MultiJumpAktif = false
local FlyHackAktif = false
local RapidFireAktif = false
local UnlimitedAmmoAktif = false

local NoGravityAktif = false
local ClockTime = "Default"

local FlyVelocity = nil
-- ==========================================
-- TAB VISUAL (ESP)
-- ==========================================
IMGUI:CreateLabel(VisualTab, "── ESP ENEMY ──")
local ToggleESPEnemy = IMGUI:CreateToggle(VisualTab, "ESP Enemy (semua musuh)", false, function(v)
    ESPEnemyAktif = v
end)
IMGUI:CreateLabel(VisualTab, "── ESP TEAM ──")
local ToggleESPTeam = IMGUI:CreateToggle(VisualTab, "ESP Team (semua tim)", false, function(v)
    ESPTeamAktif = v
end)
IMGUI:CreateLabel(VisualTab, "── PENGATURAN ESP ──")
local ColorPicker = IMGUI:CreateColorPicker(VisualTab, "Warna Semua ESP", ESPColor, function(c)
    ESPColor = c
end)
IMGUI:CreateLabel(VisualTab, "── ELEMEN ESP ──")
IMGUI:CreateToggle(VisualTab, "☐ Box", false, function(v) ESPOptions.Box = v end)
IMGUI:CreateToggle(VisualTab, "☐ Name", false, function(v) ESPOptions.Name = v end)
IMGUI:CreateToggle(VisualTab, "☐ Line", false, function(v) ESPOptions.Line = v end)
IMGUI:CreateToggle(VisualTab, "☐ Health", false, function(v) ESPOptions.Health = v end)
IMGUI:CreateToggle(VisualTab, "☐ Skeleton", false, function(v) ESPOptions.Skeleton = v end)
IMGUI:CreateToggle(VisualTab, "☐ Distance", false, function(v) ESPOptions.Distance = v end)
IMGUI:CreateToggle(VisualTab, "☐ Picture", false, function(v) ESPOptions.Picture = v end)

-- ==========================================
-- TAB AIMBOT
-- ==========================================
local ToggleAimbot = IMGUI:CreateToggle(AimbotTab, "🎯 Aimbot", false, function(v) AimbotAktif = v end)
local ToggleTeamCheck = IMGUI:CreateToggle(AimbotTab, "Team Check", true, function(v) TeamCheckAktif = v end)
local ToggleWallCheck = IMGUI:CreateToggle(AimbotTab, "Wall Check", true, function(v) WallCheckAktif = v end)
local ComboModeAim = IMGUI:CreateCombo(AimbotTab, "Mode Aimbot", {"FOV", "360°"}, "FOV", function(v) AimbotMode = v end)
local ComboTrigger = IMGUI:CreateCombo(AimbotTab, "Mode Trigger", {"Camera", "Fire (Snap)"}, "Camera", function(v) TriggerMode = v end)
local ToggleAimFov = IMGUI:CreateToggle(AimbotTab, "Tampilkan FOV", false, function(v) ShowFOV = v end)
local SliderFovSize = IMGUI:CreateSlider(AimbotTab, "Size FOV", 20, 600, 150, "px", function(v) FOVRadius = v end)
local ToggleAimLine = IMGUI:CreateToggle(AimbotTab, "Aim Line (garis ke target)", false, function(v) AimLine = v end)
local ComboTarget = IMGUI:CreateCombo(AimbotTab, "Aim Target", {"Head", "Neck", "Chest"}, "Head", function(v) AimTargetMode = v end)
local SliderAimDist = IMGUI:CreateSlider(AimbotTab, "Aim Distance", 50, 2000, 500, "m", function(v) AimDistance = v end)
local SliderSmooth = IMGUI:CreateSlider(AimbotTab, "Smoothness", 1, 100, 15, "%", function(v) AimbotSmoothness = v end)

-- ==========================================
-- TAB PLAYER
-- ==========================================
local ToggleSpeed = IMGUI:CreateToggle(PlayerTab, "⚡ Speed Run", false, function(v)
    SpeedAktif = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
local SliderSpeed = IMGUI:CreateSlider(PlayerTab, "Speed", 100, 500, 150, "%", function(v) CustomSpeedPercent = v end)
local ToggleMultiJump = IMGUI:CreateToggle(PlayerTab, "🦘 Multi Jump", false, function(v) MultiJumpAktif = v end)
local ToggleFly = IMGUI:CreateToggle(PlayerTab, "🕊️ Fly Hack (tahan jump)", false, function(v)
    FlyHackAktif = v
    if not v then FlyVelocity = nil end
end)
local ToggleRapid = IMGUI:CreateToggle(PlayerTab, "🔥 Rapid Fire", false, function(v) RapidFireAktif = v end)
local ToggleAmmo = IMGUI:CreateToggle(PlayerTab, "♾️ Unlimited Ammo", false, function(v) UnlimitedAmmoAktif = v end)

-- ==========================================
-- TAB WORLD
-- ==========================================
local ComboTime = IMGUI:CreateCombo(WorldTab, "Clock Time", {"Default", "Pagi", "Siang", "Sore", "Malam"}, "Default", function(v) ClockTime = v end)
local ToggleGravity = IMGUI:CreateToggle(WorldTab, "🌀 No Gravity", false, function(v)
    NoGravityAktif = v
    pcall(function()
        workspace.Gravity = v and 0 or 196.2
    end)
end)
IMGUI:CreateLabel(WorldTab, "── TELEPORT KE PLAYER ──")
local TeleportList = IMGUI:CreateList(WorldTab, "Players", {}, function(plrName)
    pcall(function()
        local target = Players:FindFirstChild(plrName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    end)
end)

task.spawn(function()
    while task.wait(2) do
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        pcall(function() TeleportList:Refresh(names) end)
    end
end)

-- ==========================================
-- TAB CONFIG
-- ==========================================
local ComboTheme = IMGUI:CreateCombo(ConfigTab, "Theme", {"Dark", "Light"}, "Dark", function(v)
    CurrentTheme = Themes[v] or Themes.Dark
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    ContentArea.BackgroundColor3 = CurrentTheme.Panel
    TitleBar.BackgroundColor3 = CurrentTheme.Header
    TitleLabel.TextColor3 = CurrentTheme.Accent
    MainStroke.Color = CurrentTheme.Stroke
end)

local ConfigFileName = "IMGUI_Config.json"

local function GetConfig()
    return {
        Aimbot = AimbotAktif, AimbotMode = AimbotMode, TriggerMode = TriggerMode,
        AimTargetMode = AimTargetMode, TeamCheck = TeamCheckAktif, WallCheck = WallCheckAktif,
        ShowFOV = ShowFOV, FOVRadius = FOVRadius, AimLine = AimLine,
        AimDistance = AimDistance, Smoothness = AimbotSmoothness,
        ESPEnemy = ESPEnemyAktif, ESPTeam = ESPTeamAktif,
        ESPColor = {ESPColor.R * 255, ESPColor.G * 255, ESPColor.B * 255},
        ESPOptions = ESPOptions,
        Speed = SpeedAktif, SpeedPercent = CustomSpeedPercent,
        MultiJump = MultiJumpAktif, Fly = FlyHackAktif,
        Rapid = RapidFireAktif, UnlimitedAmmo = UnlimitedAmmoAktif,
        NoGravity = NoGravityAktif, ClockTime = ClockTime,
    }
end

IMGUI:CreateButton(ConfigTab, "💾 SAVE CONFIG", function()
    if not writefile then return end
    local ok = pcall(function()
        writefile(ConfigFileName, HttpService:JSONEncode(GetConfig()))
    end)
    if ok then print("[IMGUI] Config Saved") end
end)

IMGUI:CreateButton(ConfigTab, "📂 LOAD CONFIG", function()
    if not (isfile and readfile) then return end
    if not isfile(ConfigFileName) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFileName)) end)
    if not ok or not data then return end

    if data.Aimbot ~= nil then ToggleAimbot:Set(data.Aimbot) end
    if data.AimbotMode then ComboModeAim:Set(data.AimbotMode) end
    if data.TriggerMode then ComboTrigger:Set(data.TriggerMode) end
    if data.AimTargetMode then ComboTarget:Set(data.AimTargetMode) end
    if data.TeamCheck ~= nil then ToggleTeamCheck:Set(data.TeamCheck) end
    if data.WallCheck ~= nil then ToggleWallCheck:Set(data.WallCheck) end
    if data.ShowFOV ~= nil then ToggleAimFov:Set(data.ShowFOV) end
    if data.FOVRadius then SliderFovSize:Set(data.FOVRadius) end
    if data.AimLine ~= nil then ToggleAimLine:Set(data.AimLine) end
    if data.AimDistance then SliderAimDist:Set(data.AimDistance) end
    if data.Smoothness then SliderSmooth:Set(data.Smoothness) end
    if data.ESPEnemy ~= nil then ToggleESPEnemy:Set(data.ESPEnemy) end
    if data.ESPTeam ~= nil then ToggleESPTeam:Set(data.ESPTeam) end
    if data.ESPColor then ColorPicker:Set(Color3.fromRGB(data.ESPColor[1], data.ESPColor[2], data.ESPColor[3])) end
    if data.Speed ~= nil then ToggleSpeed:Set(data.Speed) end
    if data.SpeedPercent then SliderSpeed:Set(data.SpeedPercent) end
    if data.MultiJump ~= nil then ToggleMultiJump:Set(data.MultiJump) end
    if data.Fly ~= nil then ToggleFly:Set(data.Fly) end
    if data.Rapid ~= nil then ToggleRapid:Set(data.Rapid) end
    if data.UnlimitedAmmo ~= nil then ToggleAmmo:Set(data.UnlimitedAmmo) end
    if data.NoGravity ~= nil then ToggleGravity:Set(data.NoGravity) end
    if data.ClockTime then ComboTime:Set(data.ClockTime) end
end)

IMGUI:CreateButton(ConfigTab, "🔄 RESET DEFAULT", function()
    ToggleAimbot:Set(false); ComboModeAim:Set("FOV"); ComboTrigger:Set("Camera")
    ComboTarget:Set("Head"); ToggleTeamCheck:Set(true); ToggleWallCheck:Set(true)
    ToggleAimFov:Set(false); SliderFovSize:Set(150); ToggleAimLine:Set(false)
    SliderAimDist:Set(500); SliderSmooth:Set(15)
    ToggleESPEnemy:Set(false); ToggleESPTeam:Set(false)
    ColorPicker:Set(Color3.fromRGB(255, 60, 60))
    ToggleSpeed:Set(false); SliderSpeed:Set(150)
    ToggleMultiJump:Set(false); ToggleFly:Set(false)
    ToggleRapid:Set(false); ToggleAmmo:Set(false)
    ToggleGravity:Set(false); ComboTime:Set("Default")
end)

-- ==========================================
-- ESP SYSTEM (custom draw pakai GUI)
-- ==========================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "IMGUI_ESP"
ESPFolder.Parent = ScreenGui

local ActiveESP = {}
local Drawing = {}

local FOVGui = Instance.new("Frame")
FOVGui.Name = "FOVCircle"
FOVGui.AnchorPoint = Vector2.new(0.5, 0.5)
FOVGui.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVGui.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
FOVGui.BackgroundTransparency = 1
FOVGui.Visible = false
FOVGui.Parent = ScreenGui
local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.4
FOVStroke.Parent = FOVGui
local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVGui

local AimLineGui = Instance.new("Frame")
AimLineGui.Name = "AimLine"
AimLineGui.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
AimLineGui.BorderSizePixel = 0
AimLineGui.Visible = false
AimLineGui.ZIndex = 5
AimLineGui.Parent = ScreenGui

local function CreateESPFor(plr)
    if ActiveESP[plr] then return ActiveESP[plr] end
    local data = {
        Box = Instance.new("Frame", ESPFolder),
        BoxTop = Instance.new("Frame", ESPFolder),
        BoxBot = Instance.new("Frame", ESPFolder),
        BoxL = Instance.new("Frame", ESPFolder),
        BoxR = Instance.new("Frame", ESPFolder),
        Name = Instance.new("TextLabel", ESPFolder),
        Dist = Instance.new("TextLabel", ESPFolder),
        HealthBG = Instance.new("Frame", ESPFolder),
        HealthFill = Instance.new("Frame", ESPFolder),
        PicBG = Instance.new("Frame", ESPFolder),
        Pic = Instance.new("ImageLabel", ESPFolder),
        Line = Instance.new("Frame", ESPFolder),
    }
    -- Box
    for _, f in ipairs({data.Box, data.BoxTop, data.BoxBot, data.BoxL, data.BoxR}) do
        f.BackgroundColor3 = ESPColor
        f.BorderSizePixel = 0
        f.BackgroundTransparency = 0.2
    end
    data.Box.BackgroundTransparency = 1
    -- Name
    data.Name.BackgroundTransparency = 1
    data.Name.Font = Enum.Font.GothamBold
    data.Name.TextSize = 13
    data.Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    data.Name.TextStrokeTransparency = 0.3
    -- Distance
    data.Dist.BackgroundTransparency = 1
    data.Dist.Font = Enum.Font.GothamBold
    data.Dist.TextSize = 12
    data.Dist.TextColor3 = Color3.fromRGB(220, 220, 220)
    data.Dist.TextStrokeTransparency = 0.3
    -- Health
    data.HealthBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    data.HealthBG.BorderSizePixel = 0
    data.HealthBG.BackgroundTransparency = 0.3
    data.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
    data.HealthFill.BorderSizePixel = 0
    -- Picture
    data.PicBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    data.PicBG.BackgroundTransparency = 0.4
    data.PicBG.BorderSizePixel = 0
    local pc = Instance.new("UICorner", data.PicBG)
    pc.CornerRadius = UDim.new(1, 0)
    data.Pic.BackgroundTransparency = 1
    data.Pic.Image = "rbxthumb://type=AvatarHeadShot&id=0&w=150&h=150"
    data.Pic.Parent = data.PicBG
    data.Pic.Size = UDim2.new(1, -4, 1, -4)
    data.Pic.Position = UDim2.new(0, 2, 0, 2)
    local picCorner = Instance.new("UICorner", data.Pic)
    picCorner.CornerRadius = UDim.new(1, 0)
    -- Line
    data.Line.BackgroundColor3 = ESPColor
    data.Line.BorderSizePixel = 0
    data.Line.BackgroundTransparency = 0.3
    ActiveESP[plr] = data
    return data
end

local function UpdateESP()
    local playerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local isTeam = (plr.TeamColor and plr.TeamColor == LocalPlayer.TeamColor)
            local shouldDraw = (isTeam and ESPTeamAktif) or ((not isTeam) and ESPEnemyAktif)
            playerList[plr] = shouldDraw
        end
    end

    for plr, data in pairs(ActiveESP) do
        if not playerList[plr] then
            for _, obj in pairs(data) do
                if typeof(obj) == "Instance" then obj.Visible = false end
            end
        end
    end

    for plr, shouldDraw in pairs(playerList) do
        if shouldDraw and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
            local data = CreateESPFor(plr)
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            local topPos, topOn = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 3, 0)).Position)
            local botPos, botOn = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -3, 0)).Position)

            if topOn or botOn then
                local boxHeight = math.abs(botPos.Y - topPos.Y)
                local boxWidth = boxHeight * 0.5
                local centerX = (topPos.X + botPos.X) / 2
                local centerY = (topPos.Y + botPos.Y) / 2

                -- Box
                local boxVisible = ESPOptions.Box
                data.Box.Visible = boxVisible
                data.BoxTop.Visible = boxVisible
                data.BoxBot.Visible = boxVisible
                data.BoxL.Visible = boxVisible
                data.BoxR.Visible = boxVisible
                if boxVisible then
                    local t = 2
                    local x = centerX - boxWidth/2
                    local y = centerY - boxHeight/2
                    data.Box.Position = UDim2.new(0, x, 0, y)
                    data.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                    data.Box.BackgroundTransparency = 1
                    data.BoxTop.Position = UDim2.new(0, x, 0, y); data.BoxTop.Size = UDim2.new(0, boxWidth, 0, t)
                    data.BoxBot.Position = UDim2.new(0, x, 0, y + boxHeight - t); data.BoxBot.Size = UDim2.new(0, boxWidth, 0, t)
                    data.BoxL.Position = UDim2.new(0, x, 0, y); data.BoxL.Size = UDim2.new(0, t, 0, boxHeight)
                    data.BoxR.Position = UDim2.new(0, x + boxWidth - t, 0, y); data.BoxR.Size = UDim2.new(0, t, 0, boxHeight)
                    for _, f in ipairs({data.BoxTop, data.BoxBot, data.BoxL, data.BoxR}) do
                        f.BackgroundColor3 = ESPColor
                    end
                end

                -- Name
                data.Name.Visible = ESPOptions.Name
                if ESPOptions.Name then
                    data.Name.Text = plr.DisplayName
                    data.Name.Position = UDim2.new(0, centerX - 100, 0, centerY - boxHeight/2 - 20)
                    data.Name.Size = UDim2.new(0, 200, 0, 16)
                end

                -- Distance
                data.Dist.Visible = ESPOptions.Distance
                if ESPOptions.Distance then
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    data.Dist.Text = dist .. "m"
                    data.Dist.Position = UDim2.new(0, centerX - 40, 0, centerY + boxHeight/2 + 3)
                    data.Dist.Size = UDim2.new(0, 80, 0, 14)
                end

                -- Health
                data.HealthBG.Visible = ESPOptions.Health
                data.HealthFill.Visible = ESPOptions.Health
                if ESPOptions.Health and hum then
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local hx = centerX + boxWidth/2 + 3
                    local hy = centerY - boxHeight/2
                    data.HealthBG.Position = UDim2.new(0, hx, 0, hy)
                    data.HealthBG.Size = UDim2.new(0, 4, 0, boxHeight)
                    data.HealthFill.Position = UDim2.new(0, 0, 1 - hp, 0)
                    data.HealthFill.Size = UDim2.new(1, 0, hp, 0)
                    if hp > 0.7 then
                        data.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
                    elseif hp > 0.4 then
                        data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                    else
                        data.HealthFill.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    end
                end

                -- Picture
                data.PicBG.Visible = ESPOptions.Picture
                if ESPOptions.Picture then
                    local picSize = 36
                    data.PicBG.Position = UDim2.new(0, centerX - picSize/2, 0, centerY - boxHeight/2 - picSize - 26)
                    data.PicBG.Size = UDim2.new(0, picSize, 0, picSize)
                    pcall(function()
                        data.Pic.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                    end)
                end

                -- Line
                data.Line.Visible = ESPOptions.Line
                if ESPOptions.Line then
                    local srcX, srcY = Camera.ViewportSize.X / 2, 0
                    local dstX = centerX
                    local dstY = centerY - boxHeight/2 - (ESPOptions.Picture and 60 or 20)
                    local dx, dy = dstX - srcX, dstY - srcY
                    local len = math.sqrt(dx*dx + dy*dy)
                    local ang = math.atan2(dy, dx)
                    data.Line.Position = UDim2.new(0, srcX, 0, srcY)
                    data.Line.Size = UDim2.new(0, len, 0, 1)
                    data.Line.Rotation = math.deg(ang)
                    data.Line.BackgroundColor3 = ESPColor
                end
            end
        end
    end

    -- FOV
    FOVGui.Visible = ShowFOV and AimbotAktif
    FOVGui.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVStroke.Color = ESPColor
end

-- ==========================================
-- AIMBOT LOGIC
-- ==========================================
local LockedTarget = nil

local function GetTargetPart(char)
    if not char then return nil end
    if AimTargetMode == "Head" then return char:FindFirstChild("Head") end
    if AimTargetMode == "Neck" then return char:FindFirstChild("Neck") or char:FindFirstChild("Head") end
    if AimTargetMode == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") end
    return char:FindFirstChild("Head")
end

local function IsVisible(targetPart)
    if not WallCheckAktif then return true end
    if not targetPart then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), params)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function IsEnemy(plr)
    if not TeamCheckAktif then return true end
    if plr.TeamColor == LocalPlayer.TeamColor then return false end
    return true
end

local function GetClosestTarget()
    local closest, closestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp and IsEnemy(plr) then
                local part = GetTargetPart(plr.Character)
                if part and IsVisible(part) then
                    local dist = (Camera.CFrame.Position - part.Position).Magnitude
                    if dist <= AimDistance then
                        if AimbotMode == "360°" then
                            if dist < closestDist then
                                closestDist = dist
                                closest = plr
                            end
                        else
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local screenDist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                                if screenDist <= FOVRadius and screenDist < closestDist then
                                    closestDist = screenDist
                                    closest = plr
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

RunService.RenderStepped:Connect(function()
    if AimbotAktif then
        if TriggerMode == "Fire (Snap)" and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            LockedTarget = nil
            AimLineGui.Visible = false
            return
        end

        if LockedTarget and LockedTarget.Parent and LockedTarget.Character and LockedTarget.Character:FindFirstChildOfClass("Humanoid") and LockedTarget.Character.Humanoid.Health > 0 then
            if not IsEnemy(LockedTarget) then LockedTarget = nil end
        else
            LockedTarget = nil
        end

        if not LockedTarget then
            LockedTarget = GetClosestTarget()
        end

        if LockedTarget and LockedTarget.Character then
            local part = GetTargetPart(LockedTarget.Character)
            if part and IsVisible(part) then
                local targetCF = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                if TriggerMode == "Fire (Snap)" then
                    Camera.CFrame = targetCF
                else
                    local smooth = math.clamp(AimbotSmoothness / 100, 0.02, 1)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
                end
                if AimLine then
                    local src = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local pos = Camera:WorldToViewportPoint(part.Position)
                    local dx, dy = pos.X - src.X, pos.Y - src.Y
                    local len = math.sqrt(dx*dx + dy*dy)
                    local ang = math.atan2(dy, dx)
                    AimLineGui.Position = UDim2.new(0, src.X, 0, src.Y)
                    AimLineGui.Size = UDim2.new(0, len, 0, 1)
                    AimLineGui.Rotation = math.deg(ang)
                    AimLineGui.BackgroundColor3 = ESPColor
                    AimLineGui.Visible = true                else
                    AimLineGui.Visible = false
                end
            end
        else
            AimLineGui.Visible = false
        end
    else
        AimLineGui.Visible = false
    end

    UpdateESP()
end)

-- ==========================================
-- PLAYER PHYSICS
-- ==========================================
local JumpCount = 0
local LastGroundTime = tick()
local FlyBodyVel = nil
local FlyBodyGyro = nil

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if hum then
            if SpeedAktif then
                hum.WalkSpeed = 16 * (CustomSpeedPercent / 100)
            end

            if MultiJumpAktif and hrp then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics then
                    JumpCount = 0
                end
            end

            if FlyHackAktif and hrp then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    if not FlyBodyVel then
                        FlyBodyVel = Instance.new("BodyVelocity", hrp)
                        FlyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        FlyBodyVel.Velocity = Vector3.new(0, 0, 0)
                    end
                    local camDir = Camera.CFrame.LookVector
                    FlyBodyVel.Velocity = Vector3.new(camDir.X, 1, camDir.Z) * 60
                else
                    if FlyBodyVel then
                        FlyBodyVel:Destroy()
                        FlyBodyVel = nil
                    end
                end
            else
                if FlyBodyVel then
                    FlyBodyVel:Destroy()
                    FlyBodyVel = nil
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if MultiJumpAktif and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                if JumpCount < 3 then
                    JumpCount = JumpCount + 1
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

-- ==========================================
-- RAPID FIRE & UNLIMITED AMMO
-- ==========================================
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                if UnlimitedAmmoAktif then
                    pcall(function()
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                                local n = obj.Name:lower()
                                if n:find("ammo") or n:find("clip") or n:find("mag") then
                                    obj.Value = 999999
                                end
                            end
                        end
                    end)
                end
                if RapidFireAktif then
                    pcall(function()
                        local mt = getrawmetatable(game)
                        if mt and mt.__index then
                            -- silent attempt; avoid recursion
                        end
                    end)
                end
            end
        end
    end
end)

-- ==========================================
-- CLOCK TIME
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        if ClockTime ~= "Default" then
            pcall(function()
                local lighting = game:GetService("Lighting")
                if ClockTime == "Pagi" then
                    lighting.ClockTime = 7; lighting.Brightness = 2; lighting.Ambient = Color3.fromRGB(100, 100, 100)
                elseif ClockTime == "Siang" then
                    lighting.ClockTime = 12; lighting.Brightness = 3; lighting.Ambient = Color3.fromRGB(140, 140, 140)
                elseif ClockTime == "Sore" then
                    lighting.ClockTime = 17; lighting.Brightness = 2; lighting.Ambient = Color3.fromRGB(120, 80, 60)
                elseif ClockTime == "Malam" then
                    lighting.ClockTime = 0; lighting.Brightness = 0.5; lighting.Ambient = Color3.fromRGB(20, 20, 40)
                end
            end)
        end
    end
end)

-- ==========================================
-- ANTI FALL / MISC (dari kode lama)
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

print("[IMGUI] ✅ Script Loaded Successfully")
