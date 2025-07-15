local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0.5, -90, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
frame.ZIndex = 3

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "ESP ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
toggleButton.AutoButtonColor = true
toggleButton.Parent = frame
toggleButton.ZIndex = 4

local cornerButton = Instance.new("UICorner")
cornerButton.CornerRadius = UDim.new(0, 8)
cornerButton.Parent = toggleButton

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.BackgroundTransparency = 1
credit.Text = "By Yahahaha"  -- แก้ชื่อเครดิตตรงนี้
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(170, 170, 170)
credit.Parent = frame
credit.ZIndex = 4

-- เสียงกดปุ่ม
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://452267918"
clickSound.Volume = 1
clickSound.Parent = frame

local espEnabled = true

-- ฟังก์ชันแปลง HSV เป็น RGB
local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0
    if h < 60 then
        r, g, b = c, x, 0
    elseif h < 120 then
        r, g, b = x, c, 0
    elseif h < 180 then
        r, g, b = 0, c, x
    elseif h < 240 then
        r, g, b = 0, x, c
    elseif h < 300 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return Color3.new(r + m, g + m, b + m)
end

local hue = 0
RunService.RenderStepped:Connect(function()
    if espEnabled then
        hue = (hue + 1) % 360
        toggleButton.BackgroundColor3 = HSVToRGB(hue, 1, 1)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

local function setESPState(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight.Enabled = state
            end
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") then
                player.Character.Head.NameTag.Enabled = state
            end
        end
    end
end

toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setESPState(espEnabled)
    toggleButton.Text = espEnabled and "ESP ON" or "ESP OFF"
    clickSound:Play()
end)

-- Highlight
local function createHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6 -- ทำให้จางลง
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

-- NameTag
local function createNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 180, 0, 35)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TagLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.Font = Enum.Font.Cartoon
        textLabel.TextScaled = true
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = ""
        textLabel.Parent = billboard
    end
end

local function updateNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") and player.Character:FindFirstChild("Humanoid") then
        local tag = player.Character.Head.NameTag.TagLabel
        local distance = (LocalPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
        local health = math.floor(player.Character.Humanoid.Health)
        tag.Text = player.Name .. " | " .. string.format("%.0f", distance) .. "m | ❤️" .. health
    end
end

local function updateHighlight(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(120, 0, 0)
        else
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

local function setupESP(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(0.2)
            createHighlight(player)
            createNameTag(player)
        end)
        if player.Character then
            createHighlight(player)
            createNameTag(player)
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end

Players.PlayerAdded:Connect(function(player)
    setupESP(player)
end)

while true do
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                updateNameTag(player)
                updateHighlight(player)
            end
        end
    end
    wait(0.3)
end
