-- TIGER WIZARD GUI LocalScript
-- วางใน StarterPlayerScripts หรือ StarterCharacterScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local moveSpeed = 0
local stepAmount = 5
local fastTextureEnabled = false
local originalTextures = {}

-- ===== Fast Texture Functions =====

local function savePart(part)
	if part:IsA("BasePart") and not originalTextures[part] then
		originalTextures[part] = {
			Material = part.Material,
			Reflectance = part.Reflectance,
			CastShadow = part.CastShadow,
		}
	end
end

local function applyPlasticTexture(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			savePart(part)
			part.Material = Enum.Material.SmoothPlastic
			part.Reflectance = 0.15
			part.CastShadow = false
		end
	end
end

local function restoreTexture(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") and originalTextures[part] then
			part.Material = originalTextures[part].Material
			part.Reflectance = originalTextures[part].Reflectance
			part.CastShadow = originalTextures[part].CastShadow
		end
	end
	originalTextures = {}
end

local textureToggleBtn -- forward declare

local function toggleFastTexture()
	fastTextureEnabled = not fastTextureEnabled
	if fastTextureEnabled then
		applyPlasticTexture(character)
		textureToggleBtn.Text = "🔵 Plastic ON"
		textureToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
		textureToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		restoreTexture(character)
		textureToggleBtn.Text = "⚪ Plastic OFF"
		textureToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		textureToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 200)
	end
end

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = moveSpeed
	originalTextures = {}
	if fastTextureEnabled then
		task.wait(0.5)
		applyPlasticTexture(character)
	end
end)

-- ===== สร้าง GUI =====

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TigerWizardGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 310)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(120, 60, 200)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 8, 0, 5)
icon.BackgroundTransparency = 1
icon.Text = "🐯"
icon.TextSize = 18
icon.Font = Enum.Font.GothamBold
icon.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 36, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "TIGER WIZARD"
titleLabel.TextColor3 = Color3.fromRGB(210, 160, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

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

-- ===== Speed =====

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 48)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed"
speedLabel.TextColor3 = Color3.fromRGB(140, 140, 180)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

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
stepLabel.Text = "เพิ่ม/ลดทีละ"
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

local presetLabel = Instance.new("TextLabel")
presetLabel.Size = UDim2.new(1, -20, 0, 18)
presetLabel.Position = UDim2.new(0, 10, 0, 180)
presetLabel.BackgroundTransparency = 1
presetLabel.Text = "Presets"
presetLabel.TextColor3 = Color3.fromRGB(140, 140, 180)
presetLabel.TextSize = 11
presetLabel.Font = Enum.Font.Gotham
presetLabel.TextXAlignment = Enum.TextXAlignment.Left
presetLabel.Parent = mainFrame

local presetRow = Instance.new("Frame")
presetRow.Size = UDim2.new(1, -20, 0, 30)
presetRow.Position = UDim2.new(0, 10, 0, 198)
presetRow.BackgroundTransparency = 1
presetRow.Parent = mainFrame

local presetLayout = Instance.new("UIListLayout")
presetLayout.FillDirection = Enum.FillDirection.Horizontal
presetLayout.Padding = UDim.new(0, 5)
presetLayout.Parent = presetRow

local presets = {
	{label = "หยุด",    speed = 0},
	{label = "เดิน",    speed = 16},
	{label = "วิ่ง",    speed = 50},
	{label = "สุดเร็ว", speed = 200},
}

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

-- ===== Plastic Texture Toggle =====

local textureSection = Instance.new("TextLabel")
textureSection.Size = UDim2.new(1, -20, 0, 16)
textureSection.Position = UDim2.new(0, 10, 0, 236)
textureSection.BackgroundTransparency = 1
textureSection.Text = "Appearance"
textureSection.TextColor3 = Color3.fromRGB(140, 140, 180)
textureSection.TextSize = 11
textureSection.Font = Enum.Font.Gotham
textureSection.TextXAlignment = Enum.TextXAlignment.Left
textureSection.Parent = mainFrame

textureToggleBtn = Instance.new("TextButton")
textureToggleBtn.Size = UDim2.new(1, -20, 0, 32)
textureToggleBtn.Position = UDim2.new(0, 10, 0, 254)
textureToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
textureToggleBtn.Text = "⚪ Plastic OFF"
textureToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 200)
textureToggleBtn.TextSize = 13
textureToggleBtn.Font = Enum.Font.GothamBold
textureToggleBtn.BorderSizePixel = 0
textureToggleBtn.Parent = mainFrame

local texCorner = Instance.new("UICorner")
texCorner.CornerRadius = UDim.new(0, 8)
texCorner.Parent = textureToggleBtn

local texStroke = Instance.new("UIStroke")
texStroke.Color = Color3.fromRGB(80, 80, 120)
texStroke.Thickness = 1
texStroke.Parent = textureToggleBtn

textureToggleBtn.MouseButton1Click:Connect(function()
	toggleFastTexture()
end)

-- ===== Shortcut Panel =====

-- ปุ่มเปิด Shortcut (มุมล่างขวา)
local shortcutToggleBtn = Instance.new("TextButton")
shortcutToggleBtn.Size = UDim2.new(0, 36, 0, 36)
shortcutToggleBtn.Position = UDim2.new(1, 5, 1, -36)  -- ติดขวาของ mainFrame
shortcutToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
shortcutToggleBtn.Text = "⌨"
shortcutToggleBtn.TextColor3 = Color3.fromRGB(210, 160, 255)
shortcutToggleBtn.TextSize = 18
shortcutToggleBtn.Font = Enum.Font.GothamBold
shortcutToggleBtn.BorderSizePixel = 0
shortcutToggleBtn.Parent = mainFrame

local stCorner = Instance.new("UICorner")
stCorner.CornerRadius = UDim.new(0, 8)
stCorner.Parent = shortcutToggleBtn

local stStroke = Instance.new("UIStroke")
stStroke.Color = Color3.fromRGB(120, 60, 200)
stStroke.Thickness = 1.5
stStroke.Parent = shortcutToggleBtn

-- Shortcut Panel Frame
local shortcutPanel = Instance.new("Frame")
shortcutPanel.Name = "ShortcutPanel"
shortcutPanel.Size = UDim2.new(0, 220, 0, 210)
shortcutPanel.Position = UDim2.new(1, 10, 0, 0)
shortcutPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
shortcutPanel.BorderSizePixel = 0
shortcutPanel.Visible = false
shortcutPanel.Parent = mainFrame

local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 12)
spCorner.Parent = shortcutPanel

local spStroke = Instance.new("UIStroke")
spStroke.Color = Color3.fromRGB(120, 60, 200)
spStroke.Thickness = 1.5
spStroke.Parent = shortcutPanel

-- Header ของ Shortcut Panel
local spHeader = Instance.new("Frame")
spHeader.Size = UDim2.new(1, 0, 0, 36)
spHeader.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
spHeader.BorderSizePixel = 0
spHeader.Parent = shortcutPanel

local spHeaderCorner = Instance.new("UICorner")
spHeaderCorner.CornerRadius = UDim.new(0, 12)
spHeaderCorner.Parent = spHeader

local spHeaderFix = Instance.new("Frame")
spHeaderFix.Size = UDim2.new(1, 0, 0, 12)
spHeaderFix.Position = UDim2.new(0, 0, 1, -12)
spHeaderFix.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
spHeaderFix.BorderSizePixel = 0
spHeaderFix.Parent = spHeader

local spTitle = Instance.new("TextLabel")
spTitle.Size = UDim2.new(1, -10, 1, 0)
spTitle.Position = UDim2.new(0, 10, 0, 0)
spTitle.BackgroundTransparency = 1
spTitle.Text = "⌨ Shortcuts"
spTitle.TextColor3 = Color3.fromRGB(210, 160, 255)
spTitle.TextSize = 13
spTitle.Font = Enum.Font.GothamBold
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.Parent = spHeader

-- รายการ shortcuts
local shortcutList = {
	{key = "`",       desc = "เปิด/ปิด GUI"},
	{key = "=",       desc = "Speed +"},
	{key = "-",       desc = "Speed −"},
	{key = "0",       desc = "หยุด (Speed 0)"},
	{key = "1",       desc = "เดิน (Speed 16)"},
	{key = "2",       desc = "วิ่ง (Speed 50)"},
	{key = "3",       desc = "สุดเร็ว (Speed 200)"},
	{key = "P",       desc = "Toggle Plastic"},
}

local rowH = 20
for i, sc in ipairs(shortcutList) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -16, 0, rowH)
	row.Position = UDim2.new(0, 8, 0, 36 + (i - 1) * (rowH + 2))
	row.BackgroundTransparency = 1
	row.Parent = shortcutPanel

	local keyBadge = Instance.new("TextLabel")
	keyBadge.Size = UDim2.new(0, 32, 1, 0)
	keyBadge.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	keyBadge.Text = sc.key
	keyBadge.TextColor3 = Color3.fromRGB(180, 140, 255)
	keyBadge.TextSize = 11
	keyBadge.Font = Enum.Font.GothamBold
	keyBadge.TextXAlignment = Enum.TextXAlignment.Center
	keyBadge.BorderSizePixel = 0
	keyBadge.Parent = row

	local kc = Instance.new("UICorner")
	kc.CornerRadius = UDim.new(0, 4)
	kc.Parent = keyBadge

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -40, 1, 0)
	descLabel.Position = UDim2.new(0, 38, 0, 0)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = sc.desc
	descLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
	descLabel.TextSize = 11
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = row
end

shortcutToggleBtn.MouseButton1Click:Connect(function()
	shortcutPanel.Visible = not shortcutPanel.Visible
end)

-- ===== Speed Button Logic =====

plusBtn.MouseButton1Click:Connect(function()
	applySpeed(moveSpeed + stepAmount)
end)

minusBtn.MouseButton1Click:Connect(function()
	applySpeed(moveSpeed - stepAmount)
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then applySpeed(val) else speedBox.Text = tostring(moveSpeed) end
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- ===== Drag Logic =====

local dragging = false
local dragStart, startPos

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
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
		input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ===== Keyboard Shortcuts =====

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.BackQuote then
		-- ` → เปิด/ปิด GUI
		mainFrame.Visible = not mainFrame.Visible

	elseif input.KeyCode == Enum.KeyCode.Equals then
		-- = → Speed +
		applySpeed(moveSpeed + stepAmount)

	elseif input.KeyCode == Enum.KeyCode.Minus then
		-- - → Speed −
		applySpeed(moveSpeed - stepAmount)

	elseif input.KeyCode == Enum.KeyCode.Zero then
		-- 0 → หยุด
		applySpeed(0)

	elseif input.KeyCode == Enum.KeyCode.One then
		-- 1 → เดิน
		applySpeed(16)

	elseif input.KeyCode == Enum.KeyCode.Two then
		-- 2 → วิ่ง
		applySpeed(50)

	elseif input.KeyCode == Enum.KeyCode.Three then
		-- 3 → สุดเร็ว
		applySpeed(200)

	elseif input.KeyCode == Enum.KeyCode.P then
		-- P → Toggle Plastic
		toggleFastTexture()
	end
end)

-- Keep speed applied
RunService.Heartbeat:Connect(function()
	if humanoid and humanoid.WalkSpeed ~= moveSpeed then
		humanoid.WalkSpeed = moveSpeed
	end
end)

print("[TIGER WIZARD] โหลดสำเร็จ!")
print("  `   = เปิด/ปิด GUI")
print("  =   = Speed +   |   -  = Speed −")
print("  0   = หยุด  |  1 = เดิน  |  2 = วิ่ง  |  3 = สุดเร็ว")
print("  P   = Toggle Plastic")
