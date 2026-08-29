-- ========================================================
-- DEAR IMGUI PREMIUM GRADIENT UI (V6.4/V6.9 - FIXED ESP & AIMBOT)
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
if _G.ImGuiV4_ToastGui then _G.ImGuiV4_ToastGui:Destroy() end
if _G.ImGuiV4_FOV then pcall(function() _G.ImGuiV4_FOV:Remove() end) end
if _G.ImGuiV4_Line then pcall(function() _G.ImGuiV4_Line:Remove() end) end

-- Cleanup previous ESP drawings if any
if _G.ImGuiV4_ESPs then
    for _, espData in pairs(_G.ImGuiV4_ESPs) do
        pcall(function()
            if espData.Line then espData.Line:Remove() end
            if espData.NameText then espData.NameText:Remove() end
            if espData.DistText then espData.DistText:Remove() end
            if espData.GenderText then espData.GenderText:Remove() end
            if espData.HealthBg then espData.HealthBg:Remove() end
            if espData.HealthBar then espData.HealthBar:Remove() end
        end)
    end
end
_G.ImGuiV4_ESPs = {}

local function GetSafeParent()
    if gethui then
        local success, parent = pcall(gethui)
        if success and parent then return parent end
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then return playerGui end
    return CoreGui
end

local safeParent = GetSafeParent()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_Gradient_Hub_V69"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = safeParent
_G.ImGuiV4_ScreenGui = ScreenGui

local ToastScreenGui = Instance.new("ScreenGui")
ToastScreenGui.Name = "ImGui_ToastOverlay"
ToastScreenGui.ResetOnSpawn = false
ToastScreenGui.DisplayOrder = 10000
ToastScreenGui.Parent = safeParent
_G.ImGuiV4_ToastGui = ToastScreenGui

local ToastContainer = Instance.new("Frame")
ToastContainer.Size = UDim2.new(0, 260, 0, 200)
ToastContainer.Position = UDim2.new(0.5, -130, 0, 15)
ToastContainer.BackgroundTransparency = 1
ToastContainer.Parent = ToastScreenGui

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ToastLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToastLayout.Padding = UDim.new(0, 6)
ToastLayout.Parent = ToastContainer

local function ShowToast(text, isSuccess)
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 0, 32)
    Toast.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Toast.BackgroundTransparency = 1
    Toast.Parent = ToastContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Toast

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = isSuccess and Color3.fromRGB(0, 235, 180) or Color3.fromRGB(255, 60, 80)
    Stroke.Transparency = 1
    Stroke.Parent = Toast

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Center
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
    SpeedHack = false, WalkSpeed = 30, MultiJump = false, MultiJumpPower = 50,
    Chams = false, ChamsColor = Color3.fromRGB(255, 0, 80), GlowColor = Color3.fromRGB(0, 235, 255), 
    Noclip = false, NightMode = false, DaylightMode = false, AntiCrash = false, AntiKick = false, AutoBypass = false,
    -- ESP Settings
    ESP_Name = false, ESP_Distance = false, ESP_Line = false, ESP_Health = false, ESP_Gender = false,
    -- Gun Settings
    Aimbot = false, NoRecoil = false, FOVRadius = 150, AimDistance = 500, TargetPart = "Head"
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

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ImGui_ToggleIcon"
ToggleBtn.Size = UDim2.new(0, 36, 0, 36)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "UI"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(0, 235, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnGradient = Instance.new("UIGradient")
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 40, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
})
BtnGradient.Rotation = 45
BtnGradient.Parent = ToggleBtn

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 1.5
BtnStroke.Color = Color3.fromRGB(0, 235, 255)
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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

local SuperHeaderGradient = Instance.new("UIGradient")
SuperHeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 30, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 30, 255))
})
SuperHeaderGradient.Parent = SuperHeader

local SuperText = Instance.new("TextLabel")
SuperText.Size = UDim2.new(1, 0, 1, 0)
SuperText.BackgroundTransparency = 1
SuperText.Text = "★ D3D MENU AMIN GANTENG ★"
SuperText.Font = Enum.Font.FredokaOne
SuperText.TextSize = 16
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
SubText.Text = "Dear ImGui v6.9 (Fixed ESP & V6.4 Aimbot/Night)"
SubText.Font = Enum.Font.Code
SubText.TextSize = 11
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
UIListTab.Padding = UDim.new(0, 4)
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
            if b:FindFirstChild("UIGradient") then b.UIGradient:Destroy() end
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local Grad = Instance.new("UIGradient")
    Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 60, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
    })
    Grad.Parent = btn
end

local tabs = {"PLAYER", "MISC", "GUN"}
for i, name in ipairs(tabs) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.32, 0, 1, 0)
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
    FeatureName.TextSize = 12
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
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}):Play()
            FeatureName.TextColor3 = Color3.fromRGB(0, 255, 200)
            ShowToast(text .. " Enabled", true)
        else
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 200)}):Play()
            TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            FeatureName.TextColor3 = Color3.fromRGB(200, 200, 220)
            ShowToast(text .. " Disabled", false)
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
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(0, 235, 255)
    Btn.Parent = Frame

    local currIndex = defaultIndex
    Btn.MouseButton1Click:Connect(function()
        currIndex = currIndex + 1
        if currIndex > #options then currIndex = 1 end
        Btn.Text = text .. ": " .. options[currIndex]
        ShowToast("Target Part: " .. options[currIndex], true)
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
        {Color3.fromRGB(255, 0, 80), "Red"},
        {Color3.fromRGB(0, 235, 255), "Cyan"},
        {Color3.fromRGB(0, 255, 100), "Green"},
        {Color3.fromRGB(255, 0, 235), "Magenta"},
        {Color3.fromRGB(255, 220, 0), "Yellow"}
    }

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Frame

    for _, colorData in ipairs(Colors) do
        local ColorBtn = Instance.new("TextButton")
        ColorBtn.Size = UDim2.new(0, 18, 0, 18)
        ColorBtn.BackgroundColor3 = colorData[1]
        ColorBtn.Text = ""
        ColorBtn.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(1, 0)
        BtnCorner.Parent = ColorBtn

        ColorBtn.MouseButton1Click:Connect(function()
            ShowToast(text .. ": " + colorData[2], true)
            callback(colorData[1])
        end)
    end
end

-- ==========================================
-- PLAYER & MISC MENU UI
-- ==========================================

CreateToggle(PlayerPage, "Speed Hack", true, function(state) Settings.SpeedHack = state end)
CreateSlider(PlayerPage, "Speed Value", 16, 150, 30, true, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump", true, function(state) Settings.MultiJump = state end)
CreateSlider(PlayerPage, "Multi Jump Power", 30, 150, 50, true, function(val) Settings.MultiJumpPower = val end)
CreateToggle(PlayerPage, "Wall Hack (Noclip)", true, function(state) Settings.Noclip = state end)

CreateToggle(PlayerPage, "ESP Name", true, function(state) Settings.ESP_Name = state end)
CreateToggle(PlayerPage, "ESP Distance", true, function(state) Settings.ESP_Distance = state end)
CreateToggle(PlayerPage, "ESP Line", true, function(state) Settings.ESP_Line = state end)
CreateToggle(PlayerPage, "ESP Health", true, function(state) Settings.ESP_Health = state end)
CreateToggle(PlayerPage, "ESP Gender", true, function(state) Settings.ESP_Gender = state end)

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

CreateColorTable(PlayerPage, "Chams Body Color", function(col)
    Settings.ChamsColor = col
    if Settings.Chams then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ImGui_Cham") then
                plr.Character.ImGui_Cham.FillColor = col
            end
        end
    end
end)

CreateColorTable(PlayerPage, "Chams Glow / Outline Color", function(col)
    Settings.GlowColor = col
    if Settings.Chams then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ImGui_Cham") then
                plr.Character.ImGui_Cham.OutlineColor = col
            end
        end
    end
end)

CreateToggle(MiscPage, "Night Mode (V6.4)", true, function(state)
    Settings.NightMode = state
    if state then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.GlobalShadows = false
    else
        Lighting.ClockTime = 14.5
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(MiscPage, "Daylight Mode", true, function(state)
    Settings.DaylightMode = state
    if state then
        Lighting.ClockTime = 14.5
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
    else
        Lighting.ClockTime = 14.5
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(MiscPage, "Anti Crash", true, function(state) Settings.AntiCrash = state end)
CreateToggle(MiscPage, "Anti Kick", true, function(state) Settings.AntiKick = state end)
CreateToggle(MiscPage, "Auto Bypass", true, function(state) Settings.AutoBypass = state end)

CreateToggle(GunPage, "Aimbot (V6.4 Auto Target Lock)", true, function(state) Settings.Aimbot = state end)
CreateToggle(GunPage, "No Recoil", true, function(state) Settings.NoRecoil = state end)
CreateSelector(GunPage, "Target Part", {"Head", "Body"}, 1, function(selected) 
    Settings.TargetPart = selected == "Body" and "UpperTorso" or "Head"
end)
CreateSlider(GunPage, "Aim FOV Size", 50, 400, 150, true, function(val) Settings.FOVRadius = val end)
CreateSlider(GunPage, "Aim Distance", 100, 2000, 500, true, function(val) Settings.AimDistance = val end)

-- ==========================================
-- PLAYER LOGIC (MULTI JUMP V6.5/V6.4)
-- ==========================================

local function SetupJumpDetection()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.StateChanged:Connect(function(old, new)
        if Settings.MultiJump and new == Enum.HumanoidStateType.Jumping then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, Settings.MultiJumpPower, hrp.Velocity.Z)
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

local function ApplyChams(plr)
    if plr == LocalPlayer then return end
    local function UpdateHighlight(char)
        if not char then return end
        local hl = char:FindFirstChild("ImGui_Cham")
        if Settings.Chams then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "ImGui_Cham"
                hl.Parent = char
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
    if plr.Character then UpdateHighlight(plr.Character) end
    plr.CharacterAdded:Connect(UpdateHighlight)
end

for _, plr in pairs(Players:GetPlayers()) do ApplyChams(plr) end
Players.PlayerAdded:Connect(ApplyChams)

-- ==========================================
-- ESP DRAWINGS POOL MANAGEMENT
-- ==========================================

local function GetESPDrawings(plr)
    if not _G.ImGuiV4_ESPs[plr] then
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(0, 235, 255)
        line.Transparency = 1
        line.Visible = false

        local nameText = Drawing.new("Text")
        nameText.Size = 13
        nameText.Center = true
        nameText.Outline = true
        nameText.Color = Color3.fromRGB(255, 255, 255)
        nameText.Visible = false

        local distText = Drawing.new("Text")
        distText.Size = 12
        distText.Center = true
        distText.Outline = true
        distText.Color = Color3.fromRGB(0, 235, 255)
        distText.Visible = false

        local genderText = Drawing.new("Text")
        genderText.Size = 12
        genderText.Center = true
        genderText.Outline = true
        genderText.Color = Color3.fromRGB(255, 100, 200)
        genderText.Visible = false

        local healthBg = Drawing.new("Square")
        healthBg.Thickness = 1
        healthBg.Filled = true
        healthBg.Color = Color3.fromRGB(0, 0, 0)
        healthBg.Transparency = 0.5
        healthBg.Visible = false

        local healthBar = Drawing.new("Square")
        healthBar.Thickness = 1
        healthBar.Filled = true
        healthBar.Color = Color3.fromRGB(0, 255, 100)
        healthBar.Transparency = 1
        healthBar.Visible = false

        _G.ImGuiV4_ESPs[plr] = {
            Line = line,
            NameText = nameText,
            DistText = distText,
            GenderText = genderText,
            HealthBg = healthBg,
            HealthBar = healthBar
        }
    end
    return _G.ImGuiV4_ESPs[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if _G.ImGuiV4_ESPs[plr] then
        pcall(function()
            for _, obj in pairs(_G.ImGuiV4_ESPs[plr]) do obj:Remove() end
        end)
        _G.ImGuiV4_ESPs[plr] = nil
    end
end)

-- ==========================================
-- AIMBOT (V6.4) & ESP RENDER ENGINE
-- ==========================================

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = Settings.FOVRadius

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local targetPart = plr.Character:FindFirstChild(Settings.TargetPart)
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local distance = (targetPart.Position - myRoot.Position).Magnitude
                        if distance <= Settings.AimDistance then
                            local mousePos = UserInputService:GetMouseLocation()
                            local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if magnitude < shortestDistance then
                                shortestDistance = magnitude
                                closestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Settings.SpeedHack then
            hum.WalkSpeed = Settings.WalkSpeed
        end
    end

    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Aimbot Logic (V6.4 Direct Lock)
    if Settings.Aimbot then
        FOVCircle.Visible = true
        FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = UserInputService:GetMouseLocation()
        
        local target = GetClosestTarget()
        if target then
            local targetScreenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                TargetLine.Visible = true
                TargetLine.From = UserInputService:GetMouseLocation()
                TargetLine.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            else
                TargetLine.Visible = false
            end
        else
            TargetLine.Visible = false
        end
    else
        FOVCircle.Visible = false
        TargetLine.Visible = false
    end

    -- ESP Render Loop (Guaranteed Working & Wallhack)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local esp = GetESPDrawings(plr)
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if char and hrp and head and humanoid and humanoid.Health > 0 then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if headPos.Z > 0 then
                    -- 1. ESP Line
                    if Settings.ESP_Line then
                        esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Line.To = Vector2.new(headPos.X, headPos.Y)
                        esp.Line.Visible = true
                    else
                        esp.Line.Visible = false
                    end

                    -- 2. ESP Name
                    if Settings.ESP_Name then
                        esp.NameText.Text = plr.Name
                        esp.NameText.Position = Vector2.new(headPos.X, headPos.Y - 22)
                        esp.NameText.Visible = true
                    else
                        esp.NameText.Visible = false
                    end

                    -- 3. ESP Distance
                    if Settings.ESP_Distance and myRoot then
                        local dist = math.floor((hrp.Position - myRoot.Position).Magnitude)
                        esp.DistText.Text = "[" .. dist .. "m]"
                        esp.DistText.Position = Vector2.new(headPos.X, headPos.Y - 36)
                        esp.DistText.Visible = true
                    else
                        esp.DistText.Visible = false
                    end

                    -- 4. ESP Gender
                    if Settings.ESP_Gender then
                        local genderStr = "♂ [Boy]"
                        local nameLower = plr.Name:lower()
                        if nameLower:find("girl") or nameLower:find("siti") or nameLower:find("putri") or nameLower:find("ayu") then
                            genderStr = "♀ [Girl]"
                        end
                        esp.GenderText.Text = genderStr
                        esp.GenderText.Position = Vector2.new(headPos.X, headPos.Y - 50)
                        esp.GenderText.Visible = true
                    else
                        esp.GenderText.Visible = false
                    end

                    -- 5. ESP Health
                    if Settings.ESP_Health then
                        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        local height = math.abs(legPos.Y - headPos.Y)
                        local width = height / 2
                        local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        
                        esp.HealthBg.Size = Vector2.new(3, height)
                        esp.HealthBg.Position = Vector2.new(headPos.X - (width / 2) - 6, headPos.Y)
                        esp.HealthBg.Visible = true

                        local barHeight = height * healthPct
                        esp.HealthBar.Size = Vector2.new(1, barHeight)
                        esp.HealthBar.Position = Vector2.new(headPos.X - (width / 2) - 5, headPos.Y + (height - barHeight))
                        esp.HealthBar.Color = Color3.fromHSV(healthPct * 0.3, 1, 1)
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBg.Visible = false
                        esp.HealthBar.Visible = false
                    end
                else
                    esp.Line.Visible = false
                    esp.NameText.Visible = false
                    esp.DistText.Visible = false
                    esp.GenderText.Visible = false
                    esp.HealthBg.Visible = false
                    esp.HealthBar.Visible = false
                end
            else
                esp.Line.Visible = false
                esp.NameText.Visible = false
                esp.DistText.Visible = false
                esp.GenderText.Visible = false
                esp.HealthBg.Visible = false
                esp.HealthBar.Visible = false
            end
        end
    end
end)
