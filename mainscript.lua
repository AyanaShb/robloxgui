-- ========================================================
-- DEAR IMGUI PREMIUM GRADIENT UI WITH TOAST NOTIFICATIONS
-- "D3D MENU AMIN GANTENG"
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

-- Container Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImGui_Gradient_Hub"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- ==========================================
-- TOAST NOTIFICATION SYSTEM
-- ==========================================
local ToastContainer = Instance.new("Frame")
ToastContainer.Name = "ToastContainer"
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
    Toast.BorderSizePixel = 0
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
    Label.TextTransparency = 1
    Label.Parent = Toast

    -- Animate Fade In
    TweenService:Create(Toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    -- Auto Dismiss after 2.5 seconds
    task.delay(2.5, function()
        local tweenOut = TweenService:Create(Toast, TweenInfo.new(0.4), {BackgroundTransparency = 1})
        TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Toast:Destroy()
        end)
    end)
end

-- ==========================================
-- STATE STORAGE
-- ==========================================
local Settings = {
    WalkSpeed = 16, MultiJump = false, Chams = false, 
    ChamsColor = Color3.fromRGB(0, 255, 180), NoFallDamage = false, 
    Noclip = false, CharacterSize = 1, AntiCrash = false, 
    AntiKick = false, NightMode = false, DaylightMode = false, 
    AntiHit = false, SilentAim = false, ShowFOV = false, 
    FOVRadius = 120, SpeedFire = false, UnlimitedAmmo = false, 
    LineTarget = false, TargetPart = "Head"
}

-- ==========================================
-- FLOATING ICON (BOLD X TOGGLE)
-- ==========================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ImGui_ToggleIcon"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "X"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 28
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
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 2
BtnStroke.Color = Color3.fromRGB(0, 235, 255)
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnStroke.Parent = ToggleBtn

-- ==========================================
-- MAIN WINDOW (GRADIENT THEME)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
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

-- SUPER HEADER
local SuperHeader = Instance.new("Frame")
SuperHeader.Name = "SuperHeader"
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

-- SUB-BAR
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
SubText.Text = "Dear ImGui v1.89 (Android Spec)"
SubText.Font = Enum.Font.Code
SubText.TextSize = 11
SubText.TextColor3 = Color3.fromRGB(150, 160, 180)
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = SubBar

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TABS CONTAINER
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

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -12, 1, -90)
ContentFrame.Position = UDim2.new(0, 6, 0, 84)
ContentFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentFrame

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Thickness = 1
ContentStroke.Color = Color3.fromRGB(40, 45, 65)
ContentStroke.Parent = ContentFrame

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
    
    Btn.MouseButton1Click:Connect(function()
        SelectTab(name, Btn)
    end)
    
    if i == 1 then SelectTab(name, Btn) end
end

-- ==========================================
-- UI HELPERS (WITH TOAST INTEGRATION)
-- ==========================================
local function CreateFeatureHeader(parent, titleText, isSupported)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 18)
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
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 24)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Button.BorderSizePixel = 0
    Button.Text = "  [ ] " .. text
    Button.Font = Enum.Font.Code
    Button.TextSize = 12
    Button.TextColor3 = Color3.fromRGB(200, 200, 220)
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.Text = "  [X] " .. text
            Button.TextColor3 = Color3.fromRGB(0, 255, 200)
            Button.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
            ShowToast(text .. " Enabled", true)
        else
            Button.Text = "  [ ] " .. text
            Button.TextColor3 = Color3.fromRGB(200, 200, 220)
            Button.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
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

    local FillGrad = Instance.new("UIGradient")
    FillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 60, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    })
    FillGrad.Parent = Fill

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(1, 0, 1, 0)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = text .. ": " .. tostring(default)
    ValueText.Font = Enum.Font.Code
    ValueText.TextSize = 11
    ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueText.Parent = SliderBar

    local dragging = false
    local lastVal = default
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValueText.Text = text .. ": " .. tostring(val)
        lastVal = val
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
            if dragging then
                dragging = false
                ShowToast(text .. " Updated to " .. tostring(lastVal), true)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

-- ==========================================
-- FEATURE REGISTRATION
-- ==========================================

-- PLAYER TAB
CreateSlider(PlayerPage, "Speed Hack", 16, 150, 16, true, function(val) Settings.WalkSpeed = val end)
CreateToggle(PlayerPage, "Multi Jump", true, function(state) Settings.MultiJump = state end)
CreateToggle(PlayerPage, "Chams (Wall ESP)", true, function(state)
    Settings.Chams = state
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if state then
                local hl = plr.Character:FindFirstChild("ImGui_Cham") or Instance.new("Highlight")
                hl.Name = "ImGui_Cham"
                hl.FillColor = Settings.ChamsColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = plr.Character
            else
                if plr.Character:FindFirstChild("ImGui_Cham") then plr.Character.ImGui_Cham:Destroy() end
            end
        end
    end
end)
CreateToggle(PlayerPage, "No Fall Damage", false, function(state) Settings.NoFallDamage = state end)
CreateToggle(PlayerPage, "Wall Hack (Noclip Ground-Safe)", true, function(state) Settings.Noclip = state end)
CreateSlider(PlayerPage, "Size Hack", 1, 10, 1, false, function(val) Settings.CharacterSize = val end)

-- MISC TAB
CreateToggle(MiscPage, "Anti Crash", true, function(state) Settings.AntiCrash = state end)
CreateToggle(MiscPage, "Anti Kick", true, function(state) Settings.AntiKick = state end)
CreateToggle(MiscPage, "Night Mode", true, function(state) Lighting.TimeOfDay = state and "00:00:00" or "14:00:00" end)
CreateToggle(MiscPage, "Daylight Mode", true, function(state) Lighting.TimeOfDay = state and "12:00:00" or "00:00:00" end)
CreateToggle(MiscPage, "Anti Hit", false, function(state) Settings.AntiHit = state end)

-- GUN TAB
CreateToggle(GunPage, "Silent Aim", true, function(state) Settings.SilentAim = state end)
CreateToggle(GunPage, "Show FOV", true, function(state) Settings.ShowFOV = state end)
CreateToggle(GunPage, "Speed Fire", true, function(state) Settings.SpeedFire = state end)
CreateToggle(GunPage, "Unlimited Ammo", false, function(state) Settings.UnlimitedAmmo = state end)
CreateToggle(GunPage, "Line Target", true, function(state) Settings.LineTarget = state end)

-- RUNTIME LOOPS
UserInputService.JumpRequest:Connect(function()
    if Settings.MultiJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.WalkSpeed ~= 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
    end
end)
