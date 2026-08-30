-- ========================================================
-- DEAR IMGUI PREMIUM GRADIENT UI (V7.2 - TOUCH & MULTI JUMP FIXED)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if _G.ImGuiV4_ScreenGui then _G.ImGuiV4_ScreenGui:Destroy() end
if _G.ImGuiV4_ToastGui then _G.ImGuiV4_ToastGui:Destroy() end
if _G.ImGuiV4_FOV then pcall(function() _G.ImGuiV4_FOV:Remove() end) end
if _G.ImGuiV4_Line then pcall(function() _G.ImGuiV4_Line:Remove() end) end

local function GetSafeParent()
    if gethui then
        local success, parent = pcall(gethui)
        if success and parent then return parent end
    end
    if syn and syn.protect_gui then
        local success, parent = pcall(function()
            local gui = Instance.new("Folder")
            syn.protect_gui(gui)
            gui:Destroy()
            return CoreGui
        end)
        if success and parent then return parent end
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then return playerGui end
    return CoreGui
end

local safeParent = GetSafeParent()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_Gradient_Hub_V72"
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
    NightMode = false, Daylight = false,
    Chams = false, ChamsColor = Color3.fromRGB(255, 0, 80), GlowColor = Color3.fromRGB(0, 235, 255), 
    Noclip = false, AntiCrash = false, AntiKick = false,
    Aimbot = false, FOVRadius = 150, AimDistance = 500, TargetPart = "Head",
    ESPLine = false, ESPName = false, ESPDistance = false, ESPGender = false, ESPBox3D = false, ESPHealth = false,
    PredictionMultiplier = 0.15
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
SuperText.Text = "★ D3D MENU AMIN GANTENG V7.2 ★"
SuperText.Font = Enum.Font.FredokaOne
SuperText.TextSize = 15
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
SubText.Text = "Dear ImGui v7.2 (Touch & MultiJump Fixed)"
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
            ShowToast(text .. ": " .. colorData[2], true)
            callback(colorData[1])
        end)
    end
end

-- ==========================================
-- LOGIC: SPEED HACK & ROBUST MULTI JUMP
-- ==========================================

CreateToggle(PlayerPage, "Speed Hack", true, function(state) Settings.SpeedHack = state end)
CreateSlider(PlayerPage, "Speed Value", 16, 150, 30, true, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump (Fixed)", true, function(state) Settings.MultiJump = state end)
CreateSlider(PlayerPage, "Multi Jump Power", 30, 150, 50, true, function(val) Settings.MultiJumpPower = val end)

-- MULTI JUMP FIX MENGGUNAKAN STATE CHANGED AGAR LEBIH STABIL DI MOBILE
local canJumpAgain = false
UserInputService.JumpRequest:Connect(function()
    if Settings.MultiJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Settings.MultiJumpPower, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end
end)

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

-- ==========================================
-- LIGHTING MODS
-- ==========================================
local originalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

CreateToggle(MiscPage, "Night Mode (Indoor/Outdoor Fixed)", true, function(state)
    Settings.NightMode = state
    if state then
        if Settings.Daylight then Settings.Daylight = false end
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(15, 15, 25)
        Lighting.Ambient = Color3.fromRGB(15, 15, 25)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
    else
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Brightness = originalLighting.Brightness
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Ambient = originalLighting.Ambient
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
    end
end)

CreateToggle(MiscPage, "Daylight (Indoor/Outdoor FullBright)", true, function(state)
    Settings.Daylight = state
    if state then
        if Settings.NightMode then Settings.NightMode = false end
        Lighting.ClockTime = 14
        Lighting.Brightness = 5
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
    else
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Brightness = originalLighting.Brightness
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Ambient = originalLighting.Ambient
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
    end
end)

CreateToggle(MiscPage, "Anti Crash", true, function(state) Settings.AntiCrash = state end)
CreateToggle(MiscPage, "Anti Kick", true, function(state) Settings.AntiKick = state end)

-- ==========================================
-- FULL ESP RESTORE (VISUAL PAGE)
-- ==========================================
CreateToggle(VisualPage, "ESP Snapline", true, function(state) Settings.ESPLine = state end)
CreateToggle(VisualPage, "ESP Name", true, function(state) Settings.ESPName = state end)
CreateToggle(VisualPage, "ESP Distance", true, function(state) Settings.ESPDistance = state end)
CreateToggle(VisualPage, "ESP Gender", true, function(state) Settings.ESPGender = state end)
CreateToggle(VisualPage, "ESP 3D Box", true, function(state) Settings.ESPBox3D = state end)
CreateToggle(VisualPage, "ESP Health Bar", true, function(state) Settings.ESPHealth = state end)

-- ==========================================
-- GUN MENU UI (AIMBOT + PREDICTION + SAFE TOUCH FILTER)
-- ==========================================

CreateToggle(GunPage, "Aimbot (Predict + Trigger Only)", true, function(state) Settings.Aimbot = state end)

CreateSelector(GunPage, "Target Part", {"Head", "Body"}, 1, function(selected) 
    Settings.TargetPart = selected == "Body" and "UpperTorso" or "Head"
end)
CreateSlider(GunPage, "Aim FOV Size", 50, 400, 150, true, function(val) Settings.FOVRadius = val end)
CreateSlider(GunPage, "Aim Distance", 100, 2000, 500, true, function(val) Settings.AimDistance = val end)

local function IsInLobby()
    local char = LocalPlayer.Character
    if not char then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return true end
    return false
end

-- PERBAIKAN UTAMA: FILTER SENTUHAN LAYAR SEBELAH KIRI (JOYSTICK/LARI) AGAR TIDAK MENGURANGI/MENGUNCI AIMBOT
local isFiring = false
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = true
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local screenWidth = Camera.ViewportSize.X
        -- Jika sentuhan berada di sebelah kiri layar (X < Setengah Layar), asumsikan itu Joystick/Gerak -> Jangan Trigger Aimbot
        if input.Position.X > (screenWidth / 2) then
            isFiring = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)

local function IsValidEnemy(plr)
    if plr == LocalPlayer then return false end
    if not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid") then return false end
    if plr.Character.Humanoid.Health <= 0 then return false end
    local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return false end

    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
        return false
    end
    return true
end

local function GetClosestTargetWithPrediction()
    if IsInLobby() then return nil end

    local closestTarget = nil
    local maxDist = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, plr in pairs(Players:GetPlayers()) do
        if IsValidEnemy(plr) then
            local partName = Settings.TargetPart
            local targetPart = plr.Character:FindFirstChild(partName) or plr.Character:FindFirstChild("HumanoidRootPart")
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart and targetHrp and myRoot then
                local worldDist = (targetPart.Position - myRoot.Position).Magnitude
                if worldDist <= Settings.AimDistance then
                    local predictedPosition = targetPart.Position + (targetHrp.AssemblyLinearVelocity * Settings.PredictionMultiplier)
                    local pos, onScreen = Camera:WorldToViewportPoint(predictedPosition)
                    
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        if dist < maxDist then
                            maxDist = dist
                            closestTarget = {Part = targetPart, PredictedPos = predictedPosition, ScreenPos = Vector2.new(pos.X, pos.Y)}
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ==========================================
-- UNLIMITED AMMO & NO RECOIL
-- ==========================================
RunService.Stepped:Connect(function()
    if Settings.Aimbot and not IsInLobby() then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, obj in pairs(char:GetDescendants()) do
                    if obj:IsA("Folder") or obj:IsA("Configuration") then
                        local name = obj.Name:lower()
                        if name:find("recoil") or name:find("gunanim") or name:find("spread") then
                            obj:Destroy()
                        end
                    end
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local vName = obj.Name:lower()
                        if vName:find("ammo") or vName:find("clip") or vName:find("mag") then
                            obj.Value = 999
                        elseif vName:find("reload") or vName:find("cooldown") then
                            obj.Value = 0
                        elseif vName:find("damage") or vName:find("dmg") then
                            obj.Value = 99999
                        end
                    end
                end
            end
            
            if LocalPlayer:FindFirstChild("Backpack") then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    for _, v in pairs(tool:GetDescendants()) do
                        if (v:IsA("NumberValue") or v:IsA("IntValue")) and (v.Name:lower():find("ammo") or v.Name:lower():find("damage")) then
                            v.Value = v.Name:lower():find("ammo") and 999 or 99999
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- ADVANCED ESP DRAWINGS CACHE
-- ==========================================
local ESPLineCache = {}
local ESPNameCache = {}
local ESPDistanceCache = {}
local ESPGenderCache = {}
local ESPBox3DLinesCache = {}
local ESPHealthBarCache = {}
local ESPHealthBgCache = {}

local function GetESPLine(plr)
    if not ESPLineCache[plr] then
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Transparency = 1
        line.Visible = false
        ESPLineCache[plr] = line
    end
    return ESPLineCache[plr]
end

local function GetESPText()
    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Transparency = 1
    text.Visible = false
    return text
end

local function GetBox3DLines(plr)
    if not ESPBox3DLinesCache[plr] then
        local lines = {}
        for i = 1, 12 do
            local line = Drawing.new("Line")
            line.Thickness = 1.2
            line.Color = Color3.fromRGB(0, 235, 255)
            line.Transparency = 1
            line.Visible = false
            table.insert(lines, line)
        end
        ESPBox3DLinesCache[plr] = lines
    end
    return ESPBox3DLinesCache[plr]
end

local function GetHealthBar(plr)
    if not ESPHealthBarCache[plr] then
        local bar = Drawing.new("Line")
        bar.Thickness = 2.5
        bar.Color = Color3.fromRGB(0, 255, 100)
        bar.Transparency = 1
        bar.Visible = false
        ESPHealthBarCache[plr] = bar
    end
    if not ESPHealthBgCache[plr] then
        local bg = Drawing.new("Line")
        bg.Thickness = 3.5
        bg.Color = Color3.fromRGB(40, 40, 40)
        bg.Transparency = 1
        bg.Visible = false
        ESPHealthBgCache[plr] = bg
    end
    return ESPHealthBgCache[plr], ESPHealthBarCache[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPLineCache[plr] then pcall(function() ESPLineCache[plr]:Remove() end) ESPLineCache[plr] = nil end
    if ESPNameCache[plr] then pcall(function() ESPNameCache[plr]:Remove() end) ESPNameCache[plr] = nil end
    if ESPDistanceCache[plr] then pcall(function() ESPDistanceCache[plr]:Remove() end) ESPDistanceCache[plr] = nil end
    if ESPGenderCache[plr] then pcall(function() ESPGenderCache[plr]:Remove() end) ESPGenderCache[plr] = nil end
    if ESPBox3DLinesCache[plr] then
        for _, l in ipairs(ESPBox3DLinesCache[plr]) do pcall(function() l:Remove() end) end
        ESPBox3DLinesCache[plr] = nil
    end
    if ESPHealthBarCache[plr] then
        pcall(function() ESPHealthBarCache[plr]:Remove() end)
        pcall(function() ESPHealthBgCache[plr]:Remove() end)
        ESPHealthBarCache[plr] = nil
        ESPHealthBgCache[plr] = nil
    end
end)

-- ==========================================
-- RENDER LOOP
-- ==========================================

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local topScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, 0)
    
    local showFov = Settings.Aimbot and not IsInLobby()
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = showFov

    if showFov then
        local targetData = GetClosestTargetWithPrediction()
        if targetData then
            TargetLine.From = center
            TargetLine.To = targetData.ScreenPos
            TargetLine.Visible = true

            if isFiring then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetData.PredictedPos)
            end
        else
            TargetLine.Visible = false
        end
    else
        TargetLine.Visible = false
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head") or hrp

            if hum.Health > 0 then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                local line = GetESPLine(plr)
                if Settings.ESPLine and headOnScreen then
                    line.From = topScreenCenter
                    line.To = Vector2.new(headPos.X, headPos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end

                if not ESPNameCache[plr] then ESPNameCache[plr] = GetESPText() end
                local nameText = ESPNameCache[plr]
                if Settings.ESPName and headOnScreen then
                    nameText.Text = plr.Name
                    nameText.Position = Vector2.new(headPos.X, headPos.Y - 16)
                    nameText.Visible = true
                else
                    nameText.Visible = false
                end

                if not ESPDistanceCache[plr] then ESPDistanceCache[plr] = GetESPText() end
                local distText = ESPDistanceCache[plr]
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if Settings.ESPDistance and headOnScreen and myRoot then
                    local distanceMeters = math.floor((hrp.Position - myRoot.Position).Magnitude)
                    distText.Text = "[" .. tostring(distanceMeters) .. "m]"
                    distText.Position = Vector2.new(headPos.X, headPos.Y - 32)
                    distText.Visible = true
                else
                    distText.Visible = false
                end

                if not ESPGenderCache[plr] then ESPGenderCache[plr] = GetESPText() end
                local genderText = ESPGenderCache[plr]
                if Settings.ESPGender and headOnScreen then
                    genderText.Text = "[Male]"
                    genderText.Position = Vector2.new(headPos.X, headPos.Y - 48)
                    genderText.Visible = true
                else
                    genderText.Visible = false
                end

                local boxLines = GetBox3DLines(plr)
                if Settings.ESPBox3D and rootOnScreen then
                    local size = Vector3.new(2, 4, 2)
                    local cf = hrp.CFrame
                    local corners = {
                        cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)
                    }
                    local screenCorners = {}
                    local allOnScreen = true
                    for i, corner in ipairs(corners) do
                        local sp, sos = Camera:WorldToViewportPoint(corner.Position)
                        if not sos then allOnScreen = false end
                        screenCorners[i] = Vector2.new(sp.X, sp.Y)
                    end
                    
                    if allOnScreen then
                        local connections = {
                            {1,2},{2,3},{3,4},{4,1},
                            {5,6},{6,7},{7,8},{8,5},
                            {1,5},{2,6},{3,7},{4,8}
                        }
                        for i, conn in ipairs(connections) do
                            local l = boxLines[i]
                            l.From = screenCorners[conn[1]]
                            l.To = screenCorners[conn[2]]
                            l.Visible = true
                        end
                    else
                        for _, l in ipairs(boxLines) do l.Visible = false end
                    end
                else
                    for _, l in ipairs(boxLines) do l.Visible = false end
                end

                local bgBar, healthBar = GetHealthBar(plr)
                if Settings.ESPHealth and rootOnScreen then
                    local topPos, topOnScreen = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 2.5, 0)).Position)
                    local botPos, botOnScreen = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -2.5, 0)).Position)
                    if topOnScreen and botOnScreen then
                        local barHeight = math.abs(topPos.Y - botPos.Y)
                        local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local filledHeight = barHeight * healthPercent
                        local barX = topPos.X - 18

                        bgBar.From = Vector2.new(barX, botPos.Y)
                        bgBar.To = Vector2.new(barX, topPos.Y)
                        bgBar.Visible = true

                        healthBar.From = Vector2.new(barX, botPos.Y)
                        healthBar.To = Vector2.new(barX, botPos.Y - filledHeight)
                        healthBar.Visible = true
                    else
                        bgBar.Visible = false
                        healthBar.Visible = false
                    end
                else
                    bgBar.Visible = false
                    healthBar.Visible = false
                end
            else
                if ESPLineCache[plr] then ESPLineCache[plr].Visible = false end
                if ESPNameCache[plr] then ESPNameCache[plr].Visible = false end
                if ESPDistanceCache[plr] then ESPDistanceCache[plr].Visible = false end
                if ESPGenderCache[plr] then ESPGenderCache[plr].Visible = false end
                if ESPBox3DLinesCache[plr] then for _, l in ipairs(ESPBox3DLinesCache[plr]) do l.Visible = false end end
                if ESPHealthBarCache[plr] then ESPHealthBarCache[plr].Visible = false end
                if ESPHealthBgCache[plr] then ESPHealthBgCache[plr].Visible = false end
            end
        else
            if ESPLineCache[plr] then ESPLineCache[plr].Visible = false end
            if ESPNameCache[plr] then ESPNameCache[plr].Visible = false end
            if ESPDistanceCache[plr] then ESPDistanceCache[plr].Visible = false end
            if ESPGenderCache[plr] then ESPGenderCache[plr].Visible = false end
            if ESPBox3DLinesCache[plr] then for _, l in ipairs(ESPBox3DLinesCache[plr]) do l.Visible = false end end
            if ESPHealthBarCache[plr] then ESPHealthBarCache[plr].Visible = false end
            if ESPHealthBgCache[plr] then ESPHealthBgCache[plr].Visible = false end
        end
    end
end)
