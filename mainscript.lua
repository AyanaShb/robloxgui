-- ========================================================
-- DEAR IMGUI PREMIUM GRADIENT UI (V5.1 - MULTI JUMP FLIGHT FIX)
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
ScreenGui.Name = "ImGui_Gradient_Hub_V51"
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
ToastContainer.Size = UDim2.new(0, 220, 0, 300)
ToastContainer.Position = UDim2.new(1, -230, 1, -310)
ToastContainer.BackgroundTransparency = 1
ToastContainer.Parent = ScreenGui

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
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
    Label.Size = UDim2.new(1, -12, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
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
    WalkSpeed = 16, MultiJump = false, MultiJumpPower = 50,
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

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ImGui_ToggleIcon"
ToggleBtn.Size = UDim2.new(0, 26, 0, 26)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "X"
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
BtnCorner.CornerRadius = UDim.new(0, 6)
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
SubText.Text = "Dear ImGui v5.1 (Flight Multi-Jump Fix)"
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
    Btn.TextSize = 12
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
            ShowToast("Chams Color: " .. colorData[2], true)
            callback(colorData[1])
        end)
    end
end

-- ==========================================
-- LOGIC IMPLEMENTATIONS (DIRECT TAP MULTI-JUMP / FLIGHT FIX)
-- ==========================================

CreateSlider(PlayerPage, "Speed Hack", 16, 150, 16, true, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump", true, function(state) Settings.MultiJump = state end)
CreateSlider(PlayerPage, "Multi Jump Power", 30, 150, 50, true, function(val) Settings.MultiJumpPower = val end)

-- FIX UTAMA: Input Spasi / Tombol Loncat langsung nambah Velocity Y (Tap terus naik ke atas)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and Settings.MultiJump then
        if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    -- Reset atau override velocity vertical agar tap berikutnya langsung melambung ke atas
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, Settings.MultiJumpPower, hrp.Velocity.Z)
                end
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
                hl.FillTransparency = 0
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

CreateColorTable(PlayerPage, "Chams Color Selector", function(col)
    Settings.ChamsColor = col
    if Settings.Chams then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ImGui_Cham") then
                plr.Character.ImGui_Cham.FillColor = col
            end
        end
    end
end)

CreateToggle(PlayerPage, "Wall Hack (Noclip)", true, function(state) Settings.Noclip = state end)

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

CreateToggle(MiscPage, "Anti Crash", true, function(state) Settings.AntiCrash = state end)
CreateToggle(MiscPage, "Anti Kick", true, function(state) Settings.AntiKick = state end)

CreateToggle(MiscPage, "Night Mode", true, function(state)
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

CreateToggle(MiscPage, "Daylight Mode", true, function(state)
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

CreateToggle(GunPage, "Silent Aim (Pure Bullet Redirect)", true, function(state) Settings.SilentAim = state end)
CreateSelector(GunPage, "Target Part", {"Head", "Body"}, 1, function(selected) 
    Settings.TargetPart = selected == "Body" and "UpperTorso" or "Head"
end)
CreateToggle(GunPage, "Show FOV Circle", true, function(state) Settings.ShowFOV = state end)
CreateSlider(GunPage, "FOV Size", 50, 400, 150, true, function(val) Settings.FOVRadius = val end)
CreateToggle(GunPage, "Line Target (Single Lock)", true, function(state) Settings.LineTarget = state end)

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
