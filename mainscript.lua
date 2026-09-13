-- Modern Mobile Drawing UI Framework (Vertical Tabs)
-- Designed for lightweight execution on Android (Delta, Codex, etc.)

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Configuration & State Management
local UIConfig = {
    Open = true,
    CurrentTab = "Visual",
    Position = Vector2.new(100, 100),
    Size = Vector2.new(420, 260),
    AccentColor = Color3.fromRGB(0, 229, 255),
    SecondaryColor = Color3.fromRGB(15, 17, 23),
    PanelColor = Color3.fromRGB(22, 25, 35),
    TextColor = Color3.fromRGB(240, 240, 240),
    MutedColor = Color3.fromRGB(110, 115, 130)
}

local DrawingObjects = {}

-- Helper: Create primitive drawing objects safely
local function CreateDrawing(class, properties)
    local obj = Drawing.new(class)
    for k, v in pairs(properties) do
        obj[k] = v
    end
    table.insert(DrawingObjects, obj)
    return obj
end

-- Main Window Components
local Background = CreateDrawing("Square", {
    Size = UIConfig.Size,
    Position = UIConfig.Position,
    Color = UIConfig.SecondaryColor,
    Filled = true,
    Visible = UIConfig.Open,
    ZIndex = 1
})

local Outline = CreateDrawing("Square", {
    Size = UIConfig.Size,
    Position = UIConfig.Position,
    Color = UIConfig.AccentColor,
    Thickness = 1,
    Filled = false,
    Visible = UIConfig.Open,
    ZIndex = 2
})

local TopBar = CreateDrawing("Square", {
    Size = Vector2.new(UIConfig.Size.X, 28),
    Position = UIConfig.Position,
    Color = UIConfig.PanelColor,
    Filled = true,
    Visible = UIConfig.Open,
    ZIndex = 3
})

local TitleText = CreateDrawing("Text", {
    Text = "NEBULA // MOBILE HUB",
    Size = 13,
    Color = UIConfig.TextColor,
    Position = UIConfig.Position + Vector2.new(12, 7),
    Visible = UIConfig.Open,
    ZIndex = 4
})

-- Sidebar (Vertical Tabs) Background
local Sidebar = CreateDrawing("Square", {
    Size = Vector2.new(110, UIConfig.Size.Y - 28),
    Position = UIConfig.Position + Vector2.new(0, 28),
    Color = UIConfig.PanelColor,
    Filled = true,
    Visible = UIConfig.Open,
    ZIndex = 3
})

-- Tab Data Configuration
local Tabs = {"Visual", "Combat", "World", "Settings"}
local TabButtons = {}
local ContentContainers = {}

for i, tabName in ipairs(Tabs) do
    local tabY = UIConfig.Position.Y + 35 + ((i - 1) * 36)
    
    local btnBg = CreateDrawing("Square", {
        Size = Vector2.new(98, 30),
        Position = UIConfig.Position + Vector2.new(6, 33 + ((i - 1) * 36)),
        Color = (tabName == UIConfig.CurrentTab) and UIConfig.AccentColor or Color3.fromRGB(28, 32, 44),
        Filled = true,
        Visible = UIConfig.Open,
        ZIndex = 4
    })
    
    local btnText = CreateDrawing("Text", {
        Text = tabName,
        Size = 13,
        Color = (tabName == UIConfig.CurrentTab) and UIConfig.SecondaryColor or UIConfig.TextColor,
        Position = UIConfig.Position + Vector2.new(16, 41 + ((i - 1) * 36)),
        Visible = UIConfig.Open,
        ZIndex = 5
    })
    
    TabButtons[tabName] = {Bg = btnBg, Text = btnText, Index = i}
end

-- Floating Toggle Button for Mobile Screen
local ToggleButton = CreateDrawing("Square", {
    Size = Vector2.new(45, 45),
    Position = Vector2.new(30, 150),
    Color = UIConfig.AccentColor,
    Filled = true,
    Visible = true,
    ZIndex = 10
})

local ToggleLabel = CreateDrawing("Text", {
    Text = "UI",
    Size = 14,
    Color = UIConfig.SecondaryColor,
    Position = Vector2.new(45, 164),
    Visible = true,
    ZIndex = 11
})

-- Simple Touch / Drag Interaction System
local dragging = false
local dragOffset = Vector2.new(0, 0)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = input.Position
        local pos2D = Vector2.new(pos.X, pos.Y)
        
        -- Check Toggle Button Click
        if pos2D.X >= ToggleButton.Position.X and pos2D.X <= ToggleButton.Position.X + ToggleButton.Size.X and
           pos2D.Y >= ToggleButton.Position.Y and pos2D.Y <= ToggleButton.Position.Y + ToggleButton.Size.Y then
            UIConfig.Open = not UIConfig.Open
            for _, obj in ipairs(DrawingObjects) do
                obj.Visible = UIConfig.Open
            end
            -- Keep Floating Toggle always visible when closed
            ToggleButton.Visible = true
            ToggleLabel.Visible = true
            return
        end
        
        if not UIConfig.Open then return end
        
        -- Check TopBar Dragging
        if pos2D.X >= TopBar.Position.X and pos2D.X <= TopBar.Position.X + TopBar.Size.X and
           pos2D.Y >= TopBar.Position.Y and pos2D.Y <= TopBar.Position.Y + TopBar.Size.Y then
            dragging = true
            dragOffset = TopBar.Position - pos2D
        end
        
        -- Check Tab Selection Click
        for name, data in pairs(TabButtons) do
            if pos2D.X >= data.Bg.Position.X and pos2D.X <= data.Bg.Position.X + data.Bg.Size.X and
               pos2D.Y >= data.Bg.Position.Y and pos2D.Y <= data.Bg.Position.Y + data.Bg.Size.Y then
                UIConfig.CurrentTab = name
                -- Update Tab Button Colors
                for tName, tData in pairs(TabButtons) do
                    if tName == name then
                        tData.Bg.Color = UIConfig.AccentColor
                        tData.Text.Color = UIConfig.SecondaryColor
                    else
                        tData.Bg.Color = Color3.fromRGB(28, 32, 44)
                        tData.Text.Color = UIConfig.TextColor
                    end
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local pos = input.Position
        local newPos = Vector2.new(pos.X, pos.Y) + dragOffset
        
        UIConfig.Position = newPos
        
        -- Move all UI elements relative to new window position
        Background.Position = newPos
        Outline.Position = newPos
        TopBar.Position = newPos
        TitleText.Position = newPos + Vector2.new(12, 7)
        Sidebar.Position = newPos + Vector2.new(0, 28)
        
        for name, data in pairs(TabButtons) do
            local i = data.Index
            data.Bg.Position = newPos + Vector2.new(6, 33 + ((i - 1) * 36))
            data.Text.Position = newPos + Vector2.new(16, 41 + ((i - 1) * 36))
        end
    end
end)
