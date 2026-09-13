-- Modern Blade-Style Client UI Framework for Android Roblox
-- Layout: Dark Theme, Left Vertical Sidebar Tabs, Dual-Column Content Grid, Floating Toggle

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("BladeStyleUI") then
    CoreGui.BladeStyleUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeStyleUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Floating Toggle Button ("ui")
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ui"
ToggleBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
ToggleBtn.TextSize = 16

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(100, 70, 180)
ToggleStroke.Transparency = 0.4
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

-- Main Window Frame (Blade Client Aesthetic)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 560, 0, 320)
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Transparency = 0.5
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Search & Header Bar inside Main Frame
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Parent = MainFrame
TopHeader.BackgroundTransparency = 1
TopHeader.Size = UDim2.new(1, 0, 0, 45)

local LogoText = Instance.new("TextLabel")
LogoText.Parent = TopHeader
LogoText.BackgroundTransparency = 1
LogoText.Position = UDim2.new(0.03, 0, 0, 0)
LogoText.Size = UDim2.new(0.2, 0, 1, 0)
LogoText.Font = Enum.Font.GothamBold
LogoText.Text = "BLADE"
LogoText.TextColor3 = Color3.fromRGB(240, 240, 255)
LogoText.TextSize = 15
LogoText.TextXAlignment = Enum.TextXAlignment.Left

-- Search Bar Element
local SearchBar = Instance.new("Frame")
SearchBar.Name = "SearchBar"
SearchBar.Parent = TopHeader
SearchBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SearchBar.Position = UDim2.new(0.25, 0, 0.2, 0)
SearchBar.Size = UDim2.new(0, 200, 0, 26)

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBar

local SearchInput = Instance.new("TextBox")
SearchInput.Parent = SearchBar
SearchInput.BackgroundTransparency = 1
SearchInput.Size = UDim2.new(1, 0, 1, 0)
SearchInput.Font = Enum.Font.Gotham
SearchInput.PlaceholderText = "Search element..."
SearchInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
SearchInput.Text = ""
SearchInput.TextColor3 = Color3.fromRGB(200, 200, 220)
SearchInput.TextSize = 11

-- Vertical Sidebar (Left Tabs)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.Size = UDim2.new(0, 145, 1, -45)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 0

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingTop = UDim.new(0, 5)

-- Content Viewport (Right Side)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 150, 0, 45)
ContentArea.Size = UDim2.new(1, -150, 1, -45)

-- Dual-Column Layout Creator inside Tabs
local function CreateTabContentPane()
    local Pane = Instance.new("Frame")
    Pane.Parent = ContentArea
    Pane.BackgroundTransparency = 1
    Pane.Size = UDim2.new(1, 0, 1, 0)
    Pane.Visible = false

    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Parent = Pane
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
    LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftColumn.ScrollBarThickness = 2
    LeftColumn.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 90)

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Parent = LeftColumn
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Padding = UDim.new(0, 8)

    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Parent = Pane
    RightColumn.BackgroundTransparency = 1
    RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
    RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
    RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightColumn.ScrollBarThickness = 2
    RightColumn.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 90)

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Parent = RightColumn
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 8)

    return Pane
end

local tabNames = {"visual", "combat", "world", "settings"}
local tabPanes = {}

for _, tName in ipairs(tabNames) do
    tabPanes[tName] = CreateTabContentPane()

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tName .. "Btn"
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    TabBtn.BackgroundTransparency = 0.8
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = tName:gsub("^%l", string.upper)
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    TabBtn.TextSize = 12
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnPadding = Instance.new("UIPadding")
    BtnPadding.Parent = TabBtn
    BtnPadding.PaddingLeft = UDim.new(0, 10)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabPanes) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 160)}):Play()
                b.BackgroundTransparency = 0.8
            end
        end
        tabPanes[tName].Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TabBtn.BackgroundTransparency = 0.4
    end)
end

-- Default Active Tab
tabPanes["visual"].Visible = true
Sidebar:FindFirstChild("visualBtn").TextColor3 = Color3.fromRGB(255, 255, 255)
Sidebar:FindFirstChild("visualBtn").BackgroundTransparency = 0.4

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
