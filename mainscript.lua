-- Modern Lightweight Tabbed UI Framework for Android Roblox
-- Features: Vertical Tabs, Colorful Glassmorphism, Draggable, Smooth Show/Hide Floating Button

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Prevent duplicate UI execution
if CoreGui:FindFirstChild("ModernMobileUI") then
    CoreGui.ModernMobileUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernMobileUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Floating Toggle Button ("ui")
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ui"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
ToggleBtn.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 220, 255)
ToggleStroke.Transparency = 0.5
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

-- Main Window Container (Glassmorphism & Minimalist)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 90)
MainStroke.Transparency = 0.4
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Drag Bar / Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 35)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "MOBILE HUB"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Vertical Tab Container (Left Sidebar)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.Size = UDim2.new(0, 110, 1, -35)
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabBar
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 8)

-- Content Area Container (Right Viewport)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 115, 0, 35)
ContentContainer.Size = UDim2.new(1, -115, 1, -35)

-- Tab Management System
local tabs = {}
local activeTab = nil

local function CreateTabPane(name)
    local Pane = Instance.new("ScrollingFrame")
    Pane.Name = name .. "Pane"
    Pane.Parent = ContentContainer
    Pane.BackgroundTransparency = 1
    Pane.Size = UDim2.new(1, -10, 1, -10)
    Pane.Position = UDim2.new(0, 5, 0, 5)
    Pane.CanvasSize = UDim2.new(0, 0, 0, 0)
    Pane.ScrollBarThickness = 2
    Pane.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
    Pane.Visible = false

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Pane
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)

    return Pane
end

local tabNames = {"visual", "combat", "world", "settings"}
local tabPanes = {}

for _, tName in ipairs(tabNames) do
    tabPanes[tName] = CreateTabPane(tName)

    -- Create Vertical Tab Selection Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tName .. "Btn"
    TabBtn.Parent = TabBar
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = tName:gsub("^%l", string.upper)
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 190)
    TabBtn.TextSize = 12

    local BtnCorner = Instance.new("UICorner")
N   BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabPanes) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 30), TextColor3 = Color3.fromRGB(160, 160, 190)}):Play()
            end
        end
        tabPanes[tName].Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end

-- Open default tab
tabPanes["visual"].Visible = true
TabBar:FindFirstChild("visualBtn").BackgroundColor3 = Color3.fromRGB(0, 180, 255)
TabBar:FindFirstChild("visualBtn").TextColor3 = Color3.fromRGB(255, 255, 255)

-- Smooth Mobile Dragging System (Draggable Main Frame & Floating Button)
local function MakeDraggable(guiObject, dragTarget)
    dragTarget = dragTarget or guiObject
    local dragging, dragInput, dragStart, startPos

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

MakeDraggable(MainFrame, Header)
MakeDraggable(ToggleBtn, ToggleBtn)

-- Toggle Show/Hide Window via Floating Button
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
