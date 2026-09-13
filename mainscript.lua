-- Compact Blade-Style Client UI Framework for Android Roblox
-- Features: Slim Sidebar fitting exact tabs, Clear borders/dividers, Dual-Column Viewport, Floating Toggle

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("CompactBladeUI") then
    CoreGui.CompactBladeUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CompactBladeUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Floating Toggle Button ("ui")
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ui"
ToggleBtn.TextColor3 = Color3.fromRGB(160, 110, 255)
ToggleBtn.TextSize = 15

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(120, 80, 200)
ToggleStroke.Transparency = 0.3
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

-- Main Window Frame (Compact & Sharp Borders)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 270)
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 95)
MainStroke.Transparency = 0.2
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Header / Drag Bar
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Parent = MainFrame
TopHeader.BackgroundTransparency = 1
TopHeader.Size = UDim2.new(1, 0, 0, 38)

local LogoText = Instance.new("TextLabel")
LogoText.Parent = TopHeader
LogoText.BackgroundTransparency = 1
LogoText.Position = UDim2.new(0.03, 0, 0, 0)
LogoText.Size = UDim2.new(0.2, 0, 1, 0)
LogoText.Font = Enum.Font.GothamBold
LogoText.Text = "BLADE"
LogoText.TextColor3 = Color3.fromRGB(240, 240, 255)
LogoText.TextSize = 14
LogoText.TextXAlignment = Enum.TextXAlignment.Left

-- Header Divider Line
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Parent = MainFrame
HeaderDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Position = UDim2.new(0, 0, 0, 38)
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)

-- Vertical Sidebar (Slim, Exact Fit for Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 0, 39)
Sidebar.Size = UDim2.new(0, 115, 1, -39)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingTop = UDim.new(0, 8)

-- Vertical Divider Line separating Sidebar & Content
local VerticalDivider = Instance.new("Frame")
VerticalDivider.Parent = MainFrame
VerticalDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
VerticalDivider.BorderSizePixel = 0
VerticalDivider.Position = UDim2.new(0, 115, 0, 39)
VerticalDivider.Size = UDim2.new(0, 1, 1, -39)

-- Content Area Viewport (Right Side)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 120, 0, 43)
ContentArea.Size = UDim2.new(1, -125, 1, -45)

local function CreateTabContentPane()
    local Pane = Instance.new("Frame")
    Pane.Parent = ContentArea
    Pane.BackgroundTransparency = 1
    Pane.Size = UDim2.new(1, 0, 1, 0)
    Pane.Visible = false

    -- Left Column (Scrollable & Touchable)
    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Parent = Pane
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
    LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftColumn.ScrollBarThickness = 2
    LeftColumn.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 120)

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Parent = LeftColumn
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Padding = UDim.new(0, 6)

    -- Right Column (Scrollable & Touchable)
    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Parent = Pane
    RightColumn.BackgroundTransparency = 1
    RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
    RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
    RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightColumn.ScrollBarThickness = 2
    RightColumn.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 120)

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Parent = RightColumn
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 6)

    return Pane
end

local tabNames = {"visual", "combat", "world", "settings"}
local tabPanes = {}

for _, tName in ipairs(tabNames) do
    tabPanes[tName] = CreateTabContentPane()

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tName .. "Btn"
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TabBtn.BackgroundTransparency = 0.8
    TabBtn.Size = UDim2.new(1, -8, 0, 28)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = tName:gsub("^%l", string.upper)
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 175)
    TabBtn.TextSize = 11
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnPadding = Instance.new("UIPadding")
    BtnPadding.Parent = TabBtn
    BtnPadding.PaddingLeft = UDim.new(0, 8)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabPanes) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 150, 175)}):Play()
                b.BackgroundTransparency = 0.8
            end
        end
        tabPanes[tName].Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TabBtn.BackgroundTransparency = 0.35
    end)
end

-- Default Tab Active
tabPanes["visual"].Visible = true
Sidebar:FindFirstChild("visualBtn").TextColor3 = Color3.fromRGB(255, 255, 255)
Sidebar:FindFirstChild("visualBtn").BackgroundTransparency = 0.35

-- Draggable Logic for Mobile
local function MakeDraggable(guiObject, dragTarget)
    dragTarget = dragTarget or guiObject
    local dragging, dragStart, startPos

    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame, TopHeader)
MakeDraggable(ToggleBtn, ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
