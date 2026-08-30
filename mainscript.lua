-- ========================================================
-- D3D MENU AMIN GANTENG V6 (RESTORED STABLE VERSION)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if _G.ImGuiV6_ScreenGui then _G.ImGuiV6_ScreenGui:Destroy() end

local function GetSafeParent()
    if gethui then
        local success, parent = pcall(gethui)
        if success and parent then return parent end
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then return playerGui end
    return CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_Native_Hub_V6"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = GetSafeParent()
_G.ImGuiV6_ScreenGui = ScreenGui

local Settings = {
    SpeedHack = false, WalkSpeed = 30, MultiJump = false, MultiJumpPower = 50,
    NightMode = false, Daylight = false,
    Chams = false, ChamsColor = Color3.fromRGB(255, 0, 80), GlowColor = Color3.fromRGB(0, 235, 255), 
    Noclip = false,
    Aimbot = false, FOVRadius = 150, AimDistance = 500, TargetPart = "Head",
    ESPLine = false, ESPName = false, ESPDistance = false, ESPHealth = false
}

-- FOV Circle V6 Original
local FOVCircleGui = Instance.new("Frame")
FOVCircleGui.Name = "FOVCircle"
FOVCircleGui.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircleGui.BackgroundTransparency = 1
FOVCircleGui.Visible = false
FOVCircleGui.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.5
FOVStroke.Color = Color3.fromRGB(0, 235, 255)
FOVStroke.Parent = FOVCircleGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircleGui

-- Aim Target Line (Garis Aim ke Target dalam FOV)
local AimTargetLine = Instance.new("Frame")
AimTargetLine.Name = "AimTargetLine"
AimTargetLine.AnchorPoint = Vector2.new(0.5, 0)
AimTargetLine.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
AimTargetLine.BorderSizePixel = 0
AimTargetLine.Size = UDim2.new(0, 1, 0, 0)
AimTargetLine.Visible = false
AimTargetLine.Parent = ScreenGui

-- UI Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ImGui_ToggleIcon"
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "UI"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.TextColor3 = Color3.fromRGB(0, 235, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 1.5
BtnStroke.Color = Color3.fromRGB(0, 235, 255)
BtnStroke.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(140, 60, 255)
MainStroke.Parent = MainFrame

local SuperHeader = Instance.new("Frame")
SuperHeader.Size = UDim2.new(1, 0, 0, 32)
SuperHeader.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
SuperHeader.BorderSizePixel = 0
SuperHeader.Parent = MainFrame

local SuperHeaderCorner = Instance.new("UICorner")
SuperHeaderCorner.CornerRadius = UDim.new(0, 8)
SuperHeaderCorner.Parent = SuperHeader

local SuperText = Instance.new("TextLabel")
SuperText.Size = UDim2.new(1, 0, 1, 0)
SuperText.BackgroundTransparency = 1
SuperText.Text = "★ D3D MENU AMIN GANTENG V6 ★"
SuperText.Font = Enum.Font.FredokaOne
SuperText.TextSize = 14
SuperText.TextColor3 = Color3.fromRGB(255, 255, 255)
SuperText.Parent = SuperHeader

local SubBar = Instance.new("Frame")
SubBar.Size = UDim2.new(1, 0, 0, 20)
SubBar.Position = UDim2.new(0, 0, 0, 32)
SubBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
SubBar.BorderSizePixel = 0
SubBar.Parent = MainFrame

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, -10, 1, 0)
SubText.Position = UDim2.new(0, 8, 0, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "Native GUI V6 (Original Version Restored)"
SubText.Font = Enum.Font.Code
SubText.TextSize = 10
SubText.TextColor3 = Color3.fromRGB(150, 160, 180)
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = SubBar

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 26)
TabFrame.Position = UDim2.new(0, 6, 0, 56)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local UIListTab = Instance.new("UIListLayout")
UIListTab.FillDirection = Enum.FillDirection.Horizontal
UIListTab.SortOrder = Enum.SortOrder.LayoutOrder
UIListTab.Padding = UDim.new(0, 5)
UIListTab.Parent = TabFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -12, 1, -90)
ContentFrame.Position = UDim2.new(0, 6, 0, 84)
ContentFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentFrame

local Pages = {}

local function CreatePage(name)
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -8, 1, -8)
    Scroll.Position = UDim2.new(0, 4, 0, 4)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 255)
    Scroll.Visible = false
    Scroll.Parent = ContentFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Scroll
    
    Pages[name] = Scroll
    return Scroll
end

local PlayerPage = CreatePage("PLAYER")
local VisualPage = CreatePage("VISUAL")
local MiscPage = CreatePage("MISC")
local GunPage = CreatePage("GUN")

local function SelectTab(tabName, btn)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    for _, b in pairs(TabFrame:GetChildren()) do
        if b:IsA("TextButton") then
            b.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local tabs = {"PLAYER", "VISUAL", "MISC", "GUN"}
for i, name in ipairs(tabs) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.24, 0, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
    Btn.BorderSizePixel = 0
    Btn.Text = name
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    Btn.Parent = TabFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function() SelectTab(name, Btn) end)
    if i == 1 then SelectTab(name, Btn) end
end

local function CreateFeatureHeader(parent, titleText, isSupported)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 16)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.65, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "▼ " .. titleText
    Title.Font = Enum.Font.Code
    Title.TextSize = 11
    Title.TextColor3 = Color3.fromRGB(0, 210, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Tag = Instance.new("TextLabel")
    Tag.Size = UDim2.new(0.35, 0, 1, 0)
    Tag.Position = UDim2.new(0.65, 0, 0, 0)
    Tag.BackgroundTransparency = 1
    Tag.Font = Enum.Font.Code
    Tag.TextSize = 10
    Tag.TextXAlignment = Enum.TextXAlignment.Right
    Tag.Parent = Frame

    if isSupported then
        Tag.Text = "[Supported]"
        Tag.TextColor3 = Color3.fromRGB(50, 255, 130)
    else
        Tag.Text = "[Not Supported]"
        Tag.TextColor3 = Color3.fromRGB(255, 60, 80)
    end
end

local function CreateToggle(parent, text, isSupported, callback)
    CreateFeatureHeader(parent, text, isSupported)
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 26)
    Container.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 4)
    ContainerCorner.Parent = Container

    local FeatureName = Instance.new("TextLabel")
    FeatureName.Size = UDim2.new(0.7, 0, 1, 0)
    FeatureName.Position = UDim2.new(0, 8, 0, 0)
    FeatureName.BackgroundTransparency = 1
    FeatureName.Text = text
    FeatureName.Font = Enum.Font.Code
    FeatureName.TextSize = 11
    FeatureName.TextColor3 = Color3.fromRGB(200, 200, 220)
    FeatureName.TextXAlignment = Enum.TextXAlignment.Left
    FeatureName.Parent = Container

    local SwitchTrack = Instance.new("TextButton")
    SwitchTrack.Size = UDim2.new(0, 42, 0, 20)
    SwitchTrack.Position = UDim2.new(1, -48, 0.5, -10)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    SwitchTrack.Text = ""
    SwitchTrack.AutoButtonColor = false
    SwitchTrack.Parent = Container

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SwitchTrack

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
    SwitchKnob.Position = UDim2.new(0, 2, 0.5, -8)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.Parent = SwitchTrack

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob

    local enabled = false
    SwitchTrack.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            SwitchKnob.Position = UDim2.new(1, -18, 0.5, -8)
            SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            FeatureName.TextColor3 = Color3.fromRGB(0, 255, 200)
        else
            SwitchKnob.Position = UDim2.new(0, 2, 0.5, -8)
            SwitchKnob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            FeatureName.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        callback(enabled)
    end)
end

local function CreateSlider(parent, text, min, max, default, isSupported, callback)
    CreateFeatureHeader(parent, text, isSupported)
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, 0, 0, 18)
    SliderBar.Position = UDim2.new(0, 0, 0, 8)
    SliderBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Frame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 4)
    SliderCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(1, 0, 1, 0)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = text .. ": " .. tostring(default)
    ValueText.Font = Enum.Font.Code
    ValueText.TextSize = 11
    ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueText.Parent = SliderBar

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
    CreateFeatureHeader(parent, text, true)
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 26)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = text .. ": " .. options[defaultIndex]
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(0, 235, 255)
    Btn.Parent = Frame

    local currIndex = defaultIndex
    Btn.MouseButton1Click:Connect(function()
        currIndex = currIndex + 1
        if currIndex > #options then currIndex = 1 end
        Btn.Text = text .. ": " .. options[currIndex]
        callback(options[currIndex])
    end)
end

local function CreateColorTable(parent, text, callback)
    CreateFeatureHeader(parent, text, true)
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 26)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Frame

    local Colors = {
        Color3.fromRGB(255, 0, 80),
        Color3.fromRGB(0, 235, 255),
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(255, 0, 235),
        Color3.fromRGB(255, 220, 0)
    }

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Frame

    for _, col in ipairs(Colors) do
        local ColorBtn = Instance.new("TextButton")
        ColorBtn.Size = UDim2.new(0, 18, 0, 18)
        ColorBtn.BackgroundColor3 = col
        ColorBtn.Text = ""
        ColorBtn.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(1, 0)
        BtnCorner.Parent = ColorBtn

        ColorBtn.MouseButton1Click:Connect(function()
            callback(col)
        end)
    end
end

-- ==========================
-- PLAYER SYSTEM V6 (ORIGINAL MULTI JUMP)
-- ==========================
CreateToggle(PlayerPage, "Speed Hack", true, function(state) Settings.SpeedHack = state end)
CreateSlider(PlayerPage, "Speed Value", 16, 150, 30, true, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump", true, function(state) Settings.MultiJump = state end)
CreateSlider(PlayerPage, "Multi Jump Power", 30, 150, 50, true, function(val) Settings.MultiJumpPower = val end)

-- Multi Jump V6 Original (True Infinite Jump langsung lompat di udara tanpa cooldown)
UserInputService.JumpRequest:Connect(function()
    if Settings.MultiJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

CreateToggle(PlayerPage, "Chams (Wall ESP)", true, function(state)
    Settings.Chams = state
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = plr.Character:FindFirstChild("ImGui_Cham")
            if state then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ImGui_Cham"
                    hl.Parent = plr.Character
                end
                hl.FillColor = Settings.ChamsColor
                hl.FillTransparency = 0.25
                hl.OutlineColor = Settings.GlowColor
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

CreateColorTable(PlayerPage, "Chams Body Color", function(col) Settings.ChamsColor = col end)
CreateColorTable(PlayerPage, "Chams Glow / Outline Color", function(col) Settings.GlowColor = col end)
CreateToggle(PlayerPage, "Wall Hack (Noclip)", true, function(state) Settings.Noclip = state end)

RunService.Stepped:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and Settings.SpeedHack then
        hum.WalkSpeed = Settings.WalkSpeed
    end

    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================
-- MISC SYSTEM V6
-- ==========================
CreateToggle(MiscPage, "Night Mode", true, function(state)
    Settings.NightMode = state
    if state then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(15, 15, 25)
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

CreateToggle(MiscPage, "Daylight (FullBright)", true, function(state)
    Settings.Daylight = state
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

-- ==========================
-- VISUAL SYSTEM V6 (ORIGINAL CLEAN BOX & SNAPLINE BAWAH TENGAH)
-- ==========================
CreateToggle(VisualPage, "ESP Snapline", true, function(state) Settings.ESPLine = state end)
CreateToggle(VisualPage, "ESP Name", true, function(state) Settings.ESPName = state end)
CreateToggle(VisualPage, "ESP Distance", true, function(state) Settings.ESPDistance = state end)
CreateToggle(VisualPage, "ESP Health Bar", true, function(state) Settings.ESPHealth = state end)

local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPContainer"
ESPContainer.Parent = ScreenGui

local ESPObjects = {}

local function GetESPUI(plr)
    if ESPObjects[plr] then return ESPObjects[plr] end
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0, 100, 0, 100)
    holder.BackgroundTransparency = 1
    holder.Visible = false
    holder.Parent = ESPContainer

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 11
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = holder

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 14)
    distLabel.Position = UDim2.new(0, 0, 0, 14)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.Code
    distLabel.TextSize = 10
    distLabel.TextColor3 = Color3.fromRGB(0, 235, 255)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Parent = holder

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 4, 0, 40)
    healthBg.Position = UDim2.new(0, -8, 0, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = holder

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    local snapLine = Instance.new("Frame")
    snapLine.AnchorPoint = Vector2.new(0.5, 0)
    snapLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    snapLine.BorderSizePixel = 0
    snapLine.Size = UDim2.new(0, 1, 0, 0)
    snapLine.Visible = false
    snapLine.Parent = ScreenGui

    ESPObjects[plr] = {Holder = holder, Name = nameLabel, Dist = distLabel, HealthBg = healthBg, HealthFill = healthFill, Line = snapLine}
    return ESPObjects[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        pcall(function() ESPObjects[plr].Holder:Destroy() end)
        pcall(function() ESPObjects[plr].Line:Destroy() end)
        ESPObjects[plr] = nil
    end
end)

-- ==========================
-- GUN MENU / AIMBOT SYSTEM V6 (FIXED & FULLY WORKING)
-- ==========================
CreateToggle(GunPage, "Aimbot", true, function(state) Settings.Aimbot = state end)
CreateSelector(GunPage, "Target Part", {"Head", "HumanoidRootPart"}, 1, function(selected) Settings.TargetPart = selected end)
CreateSlider(GunPage, "Aim FOV Size", 50, 400, 150, true, function(val) Settings.FOVRadius = val end)
CreateSlider(GunPage, "Aim Distance", 100, 2000, 500, true, function(val) Settings.AimDistance = val end)

local function GetClosestTarget()
    local closestTarget = nil
    local maxDist = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local targetPart = plr.Character:FindFirstChild(Settings.TargetPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart and targetHrp and myRoot then
                local worldDist = (targetPart.Position - myRoot.Position).Magnitude
                if worldDist <= Settings.AimDistance then
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

-- RenderStepped V6 Original (ESP, FOV, Aim Line, & Auto Aim Lock ke Target)
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bottomScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    FOVCircleGui.Visible = Settings.Aimbot
    if Settings.Aimbot then
        FOVCircleGui.Position = UDim2.new(0, center.X, 0, center.Y)
        FOVCircleGui.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
        
        local target = GetClosestTarget()
        if target then
            local targetScreenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                AimTargetLine.Visible = true
                local fromPos = center
                local toPos = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                local magnitude = (toPos - fromPos).Magnitude
                AimTargetLine.Position = UDim2.new(0, (fromPos.X + toPos.X) / 2, 0, (fromPos.Y + toPos.Y) / 2)
                AimTargetLine.Size = UDim2.new(0, 1, 0, magnitude)
                AimTargetLine.Rotation = math.deg(math.atan2(toPos.Y - fromPos.Y, toPos.X - fromPos.X)) - 90
            else
                AimTargetLine.Visible = false
            end

            -- Camera Lock otomatis ke target saat Aimbot aktif
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        else
            AimTargetLine.Visible = false
        end
    else
        AimTargetLine.Visible = false
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head") or hrp
            local ui = GetESPUI(plr)

            if hum.Health > 0 then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                
                if headOnScreen then
                    ui.Holder.Visible = true
                    ui.Holder.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 35)

                    ui.Name.Visible = Settings.ESPName
                    ui.Name.Text = plr.Name

                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if Settings.ESPDistance and myRoot then
                        local distanceMeters = math.floor((hrp.Position - myRoot.Position).Magnitude)
                        ui.Dist.Visible = true
                        ui.Dist.Text = "[" .. tostring(distanceMeters) .. "m]"
                    else
                        ui.Dist.Visible = false
                    end

                    ui.HealthBg.Visible = Settings.ESPHealth
                    local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    ui.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
                    ui.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                else
                    ui.Holder.Visible = false
                end

                if Settings.ESPLine and headOnScreen then
                    local line = ui.Line
                    line.Visible = true
                    local fromPos = bottomScreenCenter
                    local toPos = Vector2.new(headPos.X, headPos.Y)
                    local magnitude = (toPos - fromPos).Magnitude
                    line.Position = UDim2.new(0, (fromPos.X + toPos.X) / 2, 0, (fromPos.Y + toPos.Y) / 2)
                    line.Size = UDim2.new(0, 1, 0, magnitude)
                    line.Rotation = math.deg(math.atan2(toPos.Y - fromPos.Y, toPos.X - fromPos.X)) - 90
                else
                    ui.Line.Visible = false
                end
            else
                ui.Holder.Visible = false
                ui.Line.Visible = false
            end
        else
            if ESPObjects[plr] then
                ESPObjects[plr].Holder.Visible = false
                ESPObjects[plr].Line.Visible = false
            end
        end
    end
end)
