-- ========================================================
-- AMIN D3D MENU - ULTIMATE BULLETPROOF FIX FOR ANDROID
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Bersihkan GUI lama jika ada
if _G.AMIN_Menu_Gui then 
    pcall(function() _G.AMIN_Menu_Gui:Destroy() end) 
end
if _G.AMIN_FOV then 
    pcall(function() _G.AMIN_FOV:Remove() end) 
end
if _G.AMIN_Line then 
    pcall(function() _G.AMIN_Line:Remove() end) 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AMIN_D3D_Menu_Final"
ScreenGui.ResetOnSpawn = false
_G.AMIN_Menu_Gui = ScreenGui

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Settings State
local Settings = {
    WalkSpeed = 16, MultiJump = false, MultiJumpPower = 7.2,
    Chams = false, ChamsColor = Color3.fromRGB(255, 0, 80), 
    Noclip = false, NightMode = false, DaylightMode = false,
    SilentAim = false, ShowFOV = false, FOVRadius = 150, 
    LineTarget = false, TargetPart = "Head"
}

-- Drawing Objects (ESP / FOV)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 235, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
_G.AMIN_FOV = FOVCircle

local TargetLine = Drawing.new("Line")
TargetLine.Thickness = 2
TargetLine.Color = Color3.fromRGB(255, 30, 80)
TargetLine.Transparency = 1
TargetLine.Visible = false
_G.AMIN_Line = TargetLine

-- 1. Floating Toggle Button (Bisa digeser)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 22
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 12)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 2
BtnStroke.Color = Color3.fromRGB(140, 60, 255)
BtnStroke.Parent = ToggleBtn

-- 2. Main Frame (Window Utama Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(110, 45, 210)
MainStroke.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AMIN D3D MENU"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 150, 1, 0)
SubTitle.Position = UDim2.new(0, 135, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "[player]"
SubTitle.Font = Enum.Font.Code
SubTitle.TextSize = 11
SubTitle.TextColor3 = Color3.fromRGB(150, 130, 190)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 0, 38)
Line.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Sidebar (Menu Kiri)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 115, 1, -45)
Sidebar.Position = UDim2.new(0, 10, 0, 43)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

-- Content Container (Area Konten Kanan)
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -135, 1, -45)
ContentArea.Position = UDim2.new(0, 130, 0, 43)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Fungsi Pembuatan Halaman (Tab)
local Pages = {}
local function CreatePage(name)
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = name .. "Scroll"
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 45, 210)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Visible = false
    Scroll.Parent = ContentArea
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Scroll
    
    Pages[name] = Scroll
    return Scroll
end

local PlayerPage = CreatePage("PLAYER")
local MiscPage = CreatePage("MISC")
local GunPage = CreatePage("GUN")

local function SwitchTab(tabName, btnObj)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    SubTitle.Text = "[" .. tabName:lower() .. "]"
    for _, child in pairs(Sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
            child.TextColor3 = Color3.fromRGB(150, 135, 185)
            if child:FindFirstChild("UIStroke") then child.UIStroke.Transparency = 1 end
        end
    end
    btnObj.BackgroundColor3 = Color3.fromRGB(40, 30, 65)
    btnObj.TextColor3 = Color3.fromRGB(255, 255, 255)
    if btnObj:FindFirstChild("UIStroke") then btnObj.UIStroke.Transparency = 0 end
end

local TabNames = {"PLAYER", "MISC", "GUN"}
for i, name in ipairs(TabNames) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 11
    TabBtn.TextColor3 = Color3.fromRGB(150, 135, 185)
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Sidebar
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.Parent = TabBtn

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(140, 60, 255)
    Stroke.Transparency = 1
    Stroke.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function() 
        SwitchTab(name, TabBtn) 
    end)
    
    if i == 1 then 
        SwitchTab(name, TabBtn) 
    end
end

-- ==========================================
-- KOMPONEN UI DI DALAM TAB
-- ==========================================

local function AddToggle(parent, text, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -4, 0, 32)
    Container.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(210, 210, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ToggleBox = Instance.new("TextButton")
    ToggleBox.Size = UDim2.new(0, 36, 0, 18)
    ToggleBox.Position = UDim2.new(1, -42, 0.5, -9)
    ToggleBox.BackgroundColor3 = Color3.fromRGB(38, 30, 55)
    ToggleBox.Text = ""
    ToggleBox.AutoButtonColor = false
    ToggleBox.Parent = Container

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(1, 0)
    BoxCorner.Parent = ToggleBox

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
    Dot.BorderSizePixel = 0
    Dot.Parent = ToggleBox

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local state = false
    ToggleBox.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 45, 210)}):Play()
        else
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(150, 150, 170)}):Play()
            TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 30, 55)}):Play()
        end
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -4, 0, 42)
    Container.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Container.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -16, 0, 16)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(210, 210, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -20, 0, 12)
    SliderBar.Position = UDim2.new(0, 10, 0, 24)
    SliderBar.BackgroundColor3 = Color3.fromRGB(38, 30, 55)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Container

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 6)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(110, 45, 210)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 6)
    FillCorner.Parent = Fill

    local dragging = false
    local function UpdateVal(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateVal(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateVal(input)
        end
    end)
end

-- ==========================================
-- ISI FITUR / LOGIC GAME
-- ==========================================

-- Tab PLAYER
AddSlider(PlayerPage, "Speed Hack", 16, 150, 16, function(val) 
    Settings.WalkSpeed = val 
end)

AddToggle(PlayerPage, "Multi Jump", function(state) 
    Settings.MultiJump = state 
end)

AddSlider(PlayerPage, "Jump Power", 5, 30, 7.2, function(val) 
    Settings.MultiJumpPower = val 
end)

AddToggle(PlayerPage, "Wall Hack (Noclip)", function(state) 
    Settings.Noclip = state 
end)

-- Tab MISC
AddToggle(MiscPage, "Night Mode", function(state)
    Settings.NightMode = state
    if state then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.2
        Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

AddToggle(MiscPage, "Daylight Mode", function(state)
    Settings.DaylightMode = state
    if state then
        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

-- Tab GUN
AddToggle(GunPage, "Silent Aim", function(state) 
    Settings.SilentAim = state 
end)

AddToggle(GunPage, "Show FOV Circle", function(state) 
    Settings.ShowFOV = state 
end)

AddSlider(GunPage, "FOV Size", 50, 400, 150, function(val) 
    Settings.FOVRadius = val 
end)

AddToggle(GunPage, "Line Target", function(state) 
    Settings.LineTarget = state 
end)

-- Loop Utama Fitur Berjalan
RunService.Stepped:Connect(function()
    if Settings.WalkSpeed ~= 16 and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Settings.WalkSpeed end
    end

    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- MultiJump Listener
UserInputService.JumpRequest:Connect(function()
    if Settings.MultiJump and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Settings.MultiJumpPower, hrp.AssemblyLinearVelocity.Y and Settings.MultiJumpPower or Settings.MultiJumpPower)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.ShowFOV
end)
