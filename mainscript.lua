-- ========================================================
-- TRUST CODE STYLE UI - ROBLOX MOBILE / PC
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if _G.TrustCode_ScreenGui then _G.TrustCode_ScreenGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrustCode_UI"
ScreenGui.ResetOnSpawn = false
_G.TrustCode_ScreenGui = ScreenGui

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Toggle Button (Floating Icon)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 36, 0, 36)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
ToggleBtn.Text = "TC"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize, ToggleBtn.TextColor3 = 14, Color3.fromRGB(140, 90, 255)
ToggleBtn.Active, ToggleBtn.Draggable = true, true
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Thickness = 1.5
ToggleStroke.Color = Color3.fromRGB(80, 50, 150)

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 380)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active, MainFrame.Draggable = true, true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(50, 40, 80)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Sidebar (Left Panel)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0, 50)
LogoText.BackgroundTransparency = 1
LogoText.Text = "TRUST CODE"
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 14
LogoText.TextColor3 = Color3.fromRGB(240, 240, 255)
LogoText.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Container (Right Panel)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -170, 1, -16)
ContentContainer.Position = UDim2.new(0, 168, 0, 8)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Two Column Layout for Content Inside Pages
local Pages = {}
local function CreatePage()
    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.BorderSizePixel = 0
    PageFrame.ScrollBarThickness = 2
    PageFrame.Visible = false
    PageFrame.Parent = ContentContainer

    local UICols = Instance.new("UIListLayout")
    UICols.FillDirection = Enum.FillDirection.Horizontal
    UICols.SortOrder = Enum.SortOrder.LayoutOrder
    UICols.Padding = UDim.new(0, 10)
    UICols.Parent = PageFrame
    
    local function CreateColumn()
        local Col = Instance.new("ScrollingFrame")
        Col.Size = UDim2.new(0.48, 0, 1, 0)
        Col.BackgroundTransparency = 1
        Col.BorderSizePixel = 0
        Col.ScrollBarThickness = 0
        Col.Parent = PageFrame
        
        local ColLayout = Instance.new("UIListLayout")
        ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColLayout.Padding = UDim.new(0, 8)
        ColLayout.Parent = Col
        return Col
    end

    return PageFrame, CreateColumn(), CreateColumn()
end

-- Tabs Setup
local TabButtons = {}
local function AddTab(name, isDefault)
    local Page, Col1, Col2 = CreatePage()
    Pages[name] = {Page = Page, Col1 = Col1, Col2 = Col2}

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(28, 28, 40) or Color3.fromRGB(16, 16, 23)
    TabBtn.Text = "  " .. name
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize, TabBtn.TextColor3 = 12, isDefault and Color3.fromRGB(220, 220, 255) or Color3.fromRGB(130, 130, 150)
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do
            data.Page.Visible = (tName == name)
        end
        for _, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
            btn.TextColor3 = Color3.fromRGB(130, 130, 150)
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        TabBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
    end)

    table.insert(TabButtons, TabBtn)
    if isDefault then Page.Visible = true end
    return Col1, Col2
end

local AimbotCol1, AimbotCol2 = AddTab("AimBot", true)
local VisualCol1, VisualCol2 = AddTab("Visuals", false)
local SettingsCol1, SettingsCol2 = AddTab("Settings", false)

-- Component Builder Helpers (Mirip TrustCode Elements)
local function AddToggle(parent, title, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.Font = Enum.Font.Gotham
    Label.TextSize, Label.TextColor3 = 11, Color3.fromRGB(180, 180, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ToggleBox = Instance.new("TextButton")
    ToggleBox.Size = UDim2.new(0, 36, 0, 18)
    ToggleBox.Position = UDim2.new(1, -36, 0.5, -9)
    ToggleBox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    ToggleBox.Text = ""
    ToggleBox.Parent = Frame
    Instance.new("UICorner", ToggleBox).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(120, 120, 140)
    Circle.Parent = ToggleBox
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local state = false
    ToggleBox.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(35, 35, 48)
        local circleColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 140)
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = circleColor}):Play()
        TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        callback(state)
    end)
end

-- Contoh Penggunaan Elemen di Menu AimBot
AddToggle(AimbotCol1, "Enabled", function(v) print("Aim Enabled:", v) end)
AddToggle(AimbotCol1, "Through Walls", function(v) print("Through Walls:", v) end)
AddToggle(AimbotCol1, "Bullet Tracer", function(v) print("Bullet Tracer:", v) end)

AddToggle(AimbotCol2, "Enabled Chams", function(v) print("Chams:", v) end)
AddToggle(AimbotCol2, "Offscreen ESP", function(v) print("Offscreen:", v) end)
