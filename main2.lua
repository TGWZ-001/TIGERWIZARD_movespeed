-- MoveSpeedGUI LocalScript
-- Place in StarterPlayerScripts or StarterCharacterScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local moveSpeed = 0
local stepAmount = 5

-- Update on respawn
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = moveSpeed
end)

-- ===== Create GUI =====

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoveSpeedGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 120)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title Bar (Draggable part)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix bottom corners of titleBar
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Icon
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 8, 0, 5)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextSize = 18
icon.Font = Enum.Font.GothamBold
icon.Parent = titleBar

-- Title Text
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 36, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Move Speed"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- ===== Speed Display =====

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 48)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Walk Speed"
speedLabel.TextColor3 = Color3.fromRGB(140, 140, 180)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

-- Speed Control Row
local controlRow = Instance.new("Frame")
controlRow.Size = UDim2.new(1, -20, 0, 48)
controlRow.Position = UDim2.new(0, 10, 0, 68)
controlRow.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
controlRow.BorderSizePixel = 0
controlRow.Parent = mainFrame

local rowCorner = Instance.new("UICorner")
rowCorner.CornerRadius = UDim.new(0, 8)
rowCorner.Parent = controlRow

local rowStroke = Instance.new("UIStroke")
rowStroke.Color = Color3.fromRGB(60, 60, 90)
rowStroke.Thickness = 1
rowStroke.Parent = controlRow

-- Minus Button
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 44, 1, -10)
minusBtn.Position = UDim2.new(0, 5, 0, 5)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
minusBtn.TextSize = 22
minusBtn.Font = Enum.Font.GothamBold
minusBtn.BorderSizePixel = 0
minusBtn.Parent = controlRow

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minusBtn

-- Speed Input (TextBox)
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -104, 1, -10)
speedBox.Position = UDim2.new(0, 54, 0, 5)
speedBox.BackgroundTransparency = 1
speedBox.Text = "0"
speedBox.TextColor3 = Color3.fromRGB(100, 200, 255)
speedBox.TextSize = 26
speedBox.Font = Enum.Font.GothamBold
speedBox.TextXAlignment = Enum.TextXAlignment.Center
speedBox.ClearTextOnFocus = true
speedBox.PlaceholderText = "0"
speedBox.Parent = controlRow

-- Plus Button
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 44, 1, -10)
plusBtn.Position = UDim2.new(1, -49, 0, 5)
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 22
plusBtn.Font = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0
plusBtn.Parent = controlRow

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusBtn

-- ===== Step Selector =====

local stepLabel = Instance.new("TextLabel")
stepLabel.Size = UDim2.new(1, -20, 0, 18)
stepLabel.Position = UDim2.new(0, 10, 0, 124)
stepLabel.BackgroundTransparency = 1
stepLabel.Text = "Increment Step"
stepLabel.TextColor3 = Color3.fromRGB(140, 140, 180)
stepLabel.TextSize = 11
stepLabel.Font = Enum.Font.Gotham
stepLabel.TextXAlignment = Enum.TextXAlignment.Left
stepLabel.Parent = mainFrame

local stepRow = Instance.new("Frame")
stepRow.Size = UDim2.new(1, -20, 0, 30)
stepRow.Position = UDim2.new(0, 10, 0, 144)
stepRow.BackgroundTransparency = 1
stepRow.Parent = mainFrame

local stepLayout = Instance.new("UIListLayout")
stepLayout.FillDirection = Enum.FillDirection.Horizontal
stepLayout.Padding = UDim.new(0, 5)
stepLayout.Parent = stepRow

local steps = {1, 5, 10, 50}
local stepButtons = {}

local function updateStepButtons()
    for _, data in ipairs(stepButtons) do
        if data.val == stepAmount then
            data.btn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
            data.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
            data.btn.TextColor3 = Color3.fromRGB(160, 160, 200)
        end
    end
end

for _, s in ipairs(steps) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
    btn.Text = tostring(s)
    btn.TextColor3 = Color3.fromRGB(160, 160, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = stepRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    table.insert(stepButtons, {btn = btn, val = s})

    btn.MouseButton1Click:Connect(function()
        stepAmount = s
        updateStepButtons()
    end)
end

updateStepButtons()

-- ===== Preset Buttons =====

local presetRow = Instance.new("Frame")
presetRow.Size = UDim2.new(1, -20, 0, 30)
presetRow.Position = UDim2.new(0, 10, 0, 180)
presetRow.BackgroundTransparency = 1
presetRow.Parent = mainFrame

local presetLayout = Instance.new("UIListLayout")
presetLayout.FillDirection = Enum.FillDirection.Horizontal
presetLayout.Padding = UDim.new(0, 5)
presetLayout.Parent = presetRow

local presets = {
    {label = "Stop", speed = 0},
    {label = "Walk", speed = 16},
    {label = "Run", speed = 50},
    {label = "Max", speed = 200},
}

-- ===== Apply Speed Function =====

local function applySpeed(val)
    moveSpeed = math.max(0, math.floor(val))
    speedBox.Text = tostring(moveSpeed)
    if humanoid then
        humanoid.WalkSpeed = moveSpeed
    end
end

for _, p in ipairs(presets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 56, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 55, 30)
    btn.Text = p.label
    btn.TextColor3 = Color3.fromRGB(120, 220, 120)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = presetRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        applySpeed(p.speed)
    end)
end

-- ===== Button Logic =====

plusBtn.MouseButton1Click:Connect(function()
    applySpeed(moveSpeed + stepAmount)
end)

minusBtn.MouseButton1Click:Connect(function()
    applySpeed(moveSpeed - stepAmount)
end)

speedBox.FocusLost:Connect(function(enterPressed)
    local val = tonumber(speedBox.Text)
    if val then
        applySpeed(val)
    else
        speedBox.Text = tostring(moveSpeed)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ===== Drag Logic =====

local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ===== Toggle GUI Button =====
-- Press ` (backtick) to show/hide GUI

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.BackQuote then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Keep speed applied
RunService.Heartbeat:Connect(function()
    if humanoid and humanoid.WalkSpeed ~= moveSpeed then
        humanoid.WalkSpeed = moveSpeed
    end
end)

print("[MoveSpeedGUI] Loaded successfully! Press ` to toggle GUI")
