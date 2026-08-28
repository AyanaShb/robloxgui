-- ========================================================
-- AMIN D3D MENU (ANDROID MOBILE OPTIMIZED UI V5.4)
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

if _G.ImGuiV4_ScreenGui then _G.ImGuiV4_ScreenGui:Destroy() end
if _G.ImGuiV4_FOV then pcall(function() _G.ImGuiV4_FOV:Remove() end) end
if _G.ImGuiV4_Line then pcall(function() _G.ImGuiV4_Line:Remove() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AMIN_D3D_Menu_Android"
ScreenGui.ResetOnSpawn = false
_G.ImGuiV4_ScreenGui = ScreenGui

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

local ToastContainer = Instance.new("Frame")
ToastContainer.Size = UDim2.new(0, 240, 0, 300)
ToastContainer.Position = UDim2.new(1, -250, 1, -320)
ToastContainer.BackgroundTransparency = 1
ToastContainer.Parent = ScreenGui

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToastLayout.Padding = UDim.new(0, 8)
ToastLayout.Parent = ToastContainer

local function ShowToast(text, isSuccess)
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 0, 38)
    Toast.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
    Toast.BackgroundTransparency = 1
    Toast.Parent = ToastContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Toast

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = isSuccess and Color3.fromRGB(0, 235, 180) or Color3.fromRGB(255, 60, 80)
    Stroke.Transparency = 1
    Stroke.Parent = Toast

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -16, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Transparency = 1
    Label.Parent = Toast

    TweenService:Create(Toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(2.5, function()
        local tweenOut = TweenService:Create(Toast, TweenInfo.new(0.4), {BackgroundTransparency = 1})
        TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function() Toast:Destroy() end)
    end)
end

local Settings = {
    WalkSpeed = 16, MultiJump = false, MultiJumpPower = 7.2, -- Normal jump height
    Chams = false, ChamsColor = Color3.fromRGB(255, 0, 80), 
    Noclip = false, NightMode = false, DaylightMode = false,
    SilentAim = false, ShowFOV = false, FOVRadius = 150, 
    LineTarget = false, TargetPart = "Head"
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 235, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
_G.ImGuiV4_FOV = FOVCircle

local TargetLine = Drawing.new("Line")
TargetLine.Thickness = 2
TargetLine.Color = Color3.fromRGB(255, 30, 80)
TargetLine.Transparency = 1
TargetLine.Visible = false
_G.ImGuiV4_Line = TargetLine

-- Floating Toggle Icon Button (Ukuran Diperbesar agar mudah disentuh jari di HP)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "AMIN_ToggleIcon"
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0.04, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 20
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

-- ==========================================
-- MAIN UI CONTAINER (RESPONSIF ANDROID)
-- ==========================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 310)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
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

-- Header Area (AMIN D3D MENU)
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 44)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.Parent = MainFrame

local HeaderText = Instance.new("TextLabel")
HeaderText.Size = UDim2.new(0, 200, 1, 0)
HeaderText.Position = UDim2.new(0, 14, 0, 0)
HeaderText.BackgroundTransparency = 1
HeaderText.Text = "AMIN D3D MENU"
HeaderText.Font = Enum.Font.GothamBold
HeaderText.TextSize = 15
HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.Parent = HeaderFrame

local SubCategoryLabel = Instance.new("TextLabel")
SubCategoryLabel.Size = UDim2.new(0, 180, 1, 0)
SubCategoryLabel.Position = UDim2.new(0, 175, 0, 0)
SubCategoryLabel.BackgroundTransparency = 1
SubCategoryLabel.Text = "[player]"
SubCategoryLabel.Font = Enum.Font.Code
SubCategoryLabel.TextSize = 12
SubCategoryLabel.TextColor3 = Color3.fromRGB(140, 120, 180)
SubCategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
SubCategoryLabel.Parent = HeaderFrame

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 44)
Divider.BackgroundColor3 = Color3.fromRGB(35, 30, 48)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Left Navigation Sidebar (Lebih besar agar ramah sentuhan jari)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 135, 1, -54)
Sidebar.Position = UDim2.new(0, 10, 0, 48)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

-- Content Container Panel (Right Side)
local PanelContainer = Instance.new("Frame")
PanelContainer.Size = UDim2.new(1, -160, 1, -54)
PanelContainer.Position = UDim2.new(0, 150, 0, 48)
PanelContainer.BackgroundTransparency = 1
PanelContainer.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Pages = {}

local function CreatePage(name)
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 45, 210)
    Scroll.Visible = false
    Scroll.Parent = PanelContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Scroll
    
    Pages[name] = Scroll
    return Scroll
end

local PlayerPage = CreatePage("PLAYER")
local MiscPage = CreatePage("MISC")
local GunPage = CreatePage("GUN")

local function SelectTab(tabName, btn)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    SubCategoryLabel.Text = "[" .. tabName:lower() .. "]"
    for _, b in pairs(Sidebar:GetChildren()) do
        if b:IsA("TextButton") then
            b.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
            b.TextColor3 = Color3.fromRGB(150, 140, 180)
            if b:FindFirstChild("UIStroke") then b.UIStroke.Transparency = 1 end
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    if btn:FindFirstChild("UIStroke") then btn.UIStroke.Transparency = 0 end
end

local tabs = {"PLAYER", "MISC", "GUN"}
for i, name in ipairs(tabs) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36) -- Tinggi tombol tab disesuaikan untuk layar HP
    Btn.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Btn.BorderSizePixel = 0
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(150, 140, 180)
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Sidebar
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.Parent = Btn

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.2
    Stroke.Color = Color3.fromRGB(140, 60, 255)
    Stroke.Transparency = 1
    Stroke.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function() SelectTab(name, Btn) end)
    if i == 1 then SelectTab(name, Btn) end
end

-- ==========================================
-- UI COMPONENTS (ANDROID TOUCH FRIENDLY)
-- ==========================================

local function CreateToggle(parent, text, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -8, 0, 38)
    Container.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container

    local FeatureName = Instance.new("TextLabel")
    FeatureName.Size = UDim2.new(0.7, 0, 1, 0)
    FeatureName.Position = UDim2.new(0, 10, 0, 0)
    FeatureName.BackgroundTransparency = 1
    FeatureName.Text = text
    FeatureName.Font = Enum.Font.GothamMedium
    FeatureName.TextSize = 12
    FeatureName.TextColor3 = Color3.fromRGB(210, 210, 230)
    FeatureName.TextXAlignment = Enum.TextXAlignment.Left
    FeatureName.Parent = Container

    local SwitchTrack = Instance.new("TextButton")
    SwitchTrack.Size = UDim2.new(0, 44, 0, 22)
    SwitchTrack.Position = UDim2.new(1, -52, 0.5, -11)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(35, 30, 48)
    SwitchTrack.Text = ""
    SwitchTrack.AutoButtonColor = false
    SwitchTrack.Parent = Container

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SwitchTrack

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
    SwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.Parent = SwitchTrack

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob

    local enabled = false
    SwitchTrack.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 45, 210)}):Play()
            ShowToast(text .. " Enabled", true)
        else
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(160, 160, 180)}):Play()
            TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 30, 48)}):Play()
            ShowToast(text .. " Disabled", false)
        end
        callback(enabled)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(1, -16, 0, 20)
    ValueText.Position = UDim2.new(0, 10, 0, 4)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = text .. ": " .. tostring(default)
    ValueText.Font = Enum.Font.GothamMedium
    ValueText.TextSize = 12
    ValueText.TextColor3 = Color3.fromRGB(210, 210, 230)
    ValueText.TextXAlignment = Enum.TextXAlignment.Left
    ValueText.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -20, 0, 16)
    SliderBar.Position = UDim2.new(0, 10, 0, 28)
    SliderBar.BackgroundColor3 = Color3.fromRGB(35, 30, 48)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Frame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(110, 45, 210)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 8)
    FillCorner.Parent = Fill

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValueText.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

local function CreateSelector(parent, text, options, defaultIndex, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = text .. ": " .. options[defaultIndex]
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(0, 235, 255)
    Btn.Parent = Frame

    local currIndex = defaultIndex
    Btn.MouseButton1Click:Connect(function()
        currIndex = currIndex + 1
        if currIndex > #options then currIndex = 1 end
        Btn.Text = text .. ": " .. options[currIndex]
        ShowToast(text .. ": " .. options[currIndex], true)
        callback(options[currIndex])
    end)
end

local function CreateColorTable(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(210, 210, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Colors = {
        {Color3.fromRGB(255, 0, 80), "Red"},
        {Color3.fromRGB(0, 235, 255), "Cyan"},
        {Color3.fromRGB(0, 255, 100), "Green"},
        {Color3.fromRGB(255, 0, 235), "Magenta"},
        {Color3.fromRGB(255, 220, 0), "Yellow"}
    }

    local ColorContainer = Instance.new("Frame")
    ColorContainer.Size = UDim2.new(0.6, 0, 1, 0)
    ColorContainer.Position = UDim2.new(0.4, 0, 0, 0)
    ColorContainer.BackgroundTransparency = 1
    ColorContainer.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = ColorContainer

    for _, colorData in ipairs(Colors) do
        local ColorBtn = Instance.new("TextButton")
        ColorBtn.Size = UDim2.new(0, 24, 0, 24) -- Tombol warna diperbesar agar pas dengan sentuhan jari
        ColorBtn.BackgroundColor3 = colorData[1]
        ColorBtn.Text = ""
        ColorBtn.Parent = ColorContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(1, 0)
        BtnCorner.Parent = ColorBtn

        ColorBtn.MouseButton1Click:Connect(function()
            ShowToast("Color: " + colorData[2], true)
            callback(colorData[1])
        end)
    end
end

-- ==========================================
-- LOGIC IMPLEMENTATIONS & MULTI-JUMP FIX
-- ==========================================

CreateSlider(PlayerPage, "Speed Hack", 16, 150, 16, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump", function(state) Settings.MultiJump = state end)
CreateSlider(PlayerPage, "Multi Jump Power", 5, 30, 7.2, function(val) Settings.MultiJumpPower = val end)

local function SetupJumpDetection()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.StateChanged:Connect(function(old, new)
        if Settings.MultiJump and new == Enum.HumanoidStateType.Jumping then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Settings.MultiJumpPower, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.delay(1, SetupJumpDetection)
end)
if LocalPlayer.Character then
    task.spawn(SetupJumpDetection)
end

task.spawn(function()
    pcall(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        local touchGui = playerGui:WaitForChild("TouchGui", 5)
        if touchGui then
            local touchControlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
            if touchControlFrame then
                local jumpButton = touchControlFrame:WaitForChild("JumpButton", 5)
                if jumpButton then
                    jumpButton.MouseButton1Down:Connect(function()
                        if Settings.MultiJump then
                            local char = LocalPlayer.Character
                            if char then
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Settings.MultiJumpPower, hrp.AssemblyLinearVelocity.Z)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end)

local function ApplyChams(plr)
    if plr == LocalPlayer then return end
    local function UpdateHighlight(char)
        if not char then return end
        local hl = char:FindFirstChild("AMIN_Cham")
        if Settings.Chams then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "AMIN_Cham"
                hl.Parent = char
            end
            hl.FillColor = Settings.ChamsColor
            hl.FillTransparency = 0
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        else
            if hl then hl:Destroy() end
        end
    end

    if plr.Character then UpdateHighlight(plr.Character) end
    plr.CharacterAdded:Connect(UpdateHighlight)
end

for _, plr in pairs(Players:GetPlayers()) do ApplyChams(plr) end
Players.PlayerAdded:Connect(ApplyChams)

CreateToggle(PlayerPage, "Chams (Wall ESP)", function(state)
    Settings.Chams = state
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = plr.Character:FindFirstChild("AMIN_Cham")
            if state then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "AMIN_Cham"
                    hl.Parent = plr.Character
                end
                hl.FillColor = Settings.ChamsColor
                hl.FillTransparency = 0
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

CreateColorTable(PlayerPage, "Chams Color", function(col)
    Settings.ChamsColor = col
    if Settings.Chams then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("AMIN_Cham") then
                plr.Character.AMIN_Cham.FillColor = col
            end
        end
    end
end)

CreateToggle(PlayerPage, "Wall Hack (Noclip)", function(state) Settings.Noclip = state end)

RunService.Stepped:Connect(function()
    if Settings.WalkSpeed ~= 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Settings.WalkSpeed
    end

    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

CreateToggle(MiscPage, "Anti Crash", function(state) Settings.AntiCrash = state end)
CreateToggle(MiscPage, "Anti Kick", function(state) Settings.AntiKick = state end)

CreateToggle(MiscPage, "Night Mode", function(state)
    Settings.NightMode = state
    if state then
        Settings.DaylightMode = false
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.2
        Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

CreateToggle(MiscPage, "Daylight Mode", function(state)
    Settings.DaylightMode = state
    if state then
        Settings.NightMode = false
        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

CreateToggle(GunPage, "Silent Aim", function(state) Settings.SilentAim = state end)
CreateSelector(GunPage, "Target Part", {"Head", "Body"}, 1, function(selected) 
    Settings.TargetPart = selected == "Body" and "UpperTorso" or "Head"
end)
CreateToggle(GunPage, "Show FOV Circle", function(state) Settings.ShowFOV = state end)
CreateSlider(GunPage, "FOV Size", 50, 400, 150, function(val) Settings.FOVRadius = val end)
CreateToggle(GunPage, "Line Target", function(state) Settings.LineTarget = state end)

local function GetClosestTarget()
    local closestTarget = nil
    local maxDist = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                local partName = Settings.TargetPart
                local targetPart = plr.Character:FindFirstChild(partName) or plr.Character:FindFirstChild("HumanoidRootPart")
                
                if targetPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        if dist < maxDist then
                            maxDist = dist
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

if hookmetamethod and getnamecallmethod then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Settings.SilentAim and not checkcaller() then
            local target = GetClosestTarget()
            if target and (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList") then
                if method == "Raycast" then
                    local origin = args[1]
                    args[2] = (target.Position - origin).Unit * 5000
                    return oldNamecall(self, unpack(args))
                elseif method == "FindPartOnRay" then
                    local origin = args[1].Origin
                    args[1] = Ray.new(origin, (target.Position - origin).Unit * 5000)
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        return oldNamecall(self, unpack(args))
    end)
end

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.ShowFOV

    local lockedTarget = GetClosestTarget()
    if lockedTarget and Settings.LineTarget then
        local pos, onScreen = Camera:WorldToViewportPoint(lockedTarget.Position)
        if onScreen then
            TargetLine.From = center
            TargetLine.To = Vector2.new(pos.X, pos.Y)
            TargetLine.Visible = true
        else
            TargetLine.Visible = false
        end
    else
        TargetLine.Visible = false
    end
end)
