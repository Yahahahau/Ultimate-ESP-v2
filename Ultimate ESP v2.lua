local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ลบ UI เดิมถ้ามี
local existingGui = CoreGui:FindFirstChild("ESPGui")
if existingGui then
    existingGui:Destroy()
end

-- GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Frame หลักของ UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 90) -- เพิ่มขนาดให้พอใส่ UI ใหม่
frame.Position = UDim2.new(0.5, -110, 0.05, 0)
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

-- ปุ่มเปิดปิด ESP
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 30)
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

-- Label + TextBox ใส่ ID เสียงตาย
local deathSoundLabel = Instance.new("TextLabel")
deathSoundLabel.Size = UDim2.new(0, 100, 0, 20)
deathSoundLabel.Position = UDim2.new(0, 10, 0, 45)
deathSoundLabel.Text = "Death Sound ID:"
deathSoundLabel.Font = Enum.Font.Gotham
deathSoundLabel.TextSize = 14
deathSoundLabel.TextColor3 = Color3.new(1,1,1)
deathSoundLabel.BackgroundTransparency = 1
deathSoundLabel.Parent = frame
deathSoundLabel.ZIndex = 4

local deathSoundInput = Instance.new("TextBox")
deathSoundInput.Size = UDim2.new(0, 110, 0, 25)
deathSoundInput.Position = UDim2.new(0, 110, 0, 42)
deathSoundInput.PlaceholderText = "ใส่ ID ที่นี่"
deathSoundInput.Font = Enum.Font.Gotham
deathSoundInput.TextSize = 14
deathSoundInput.TextColor3 = Color3.new(1,1,1)
deathSoundInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
deathSoundInput.TextWrapped = true
deathSoundInput.ClearTextOnFocus = false
deathSoundInput.Parent = frame
deathSoundInput.ZIndex = 4

local cornerInput = Instance.new("UICorner")
cornerInput.CornerRadius = UDim.new(0, 6)
cornerInput.Parent = deathSoundInput

-- ปุ่มเปิด/ปิดเสียงตาย custom
local toggleDeathSoundBtn = Instance.new("TextButton")
toggleDeathSoundBtn.Size = UDim2.new(0, 200, 0, 25)
toggleDeathSoundBtn.Position = UDim2.new(0, 10, 0, 70)
toggleDeathSoundBtn.Text = "Death Sound: OFF"
toggleDeathSoundBtn.Font = Enum.Font.GothamBold
toggleDeathSoundBtn.TextSize = 16
toggleDeathSoundBtn.TextColor3 = Color3.new(1, 1, 1)
toggleDeathSoundBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
toggleDeathSoundBtn.AutoButtonColor = true
toggleDeathSoundBtn.Parent = frame
toggleDeathSoundBtn.ZIndex = 4

local cornerToggleDeath = Instance.new("UICorner")
cornerToggleDeath.CornerRadius = UDim.new(0, 8)
cornerToggleDeath.Parent = toggleDeathSoundBtn

-- ปุ่ม Toggle GUI เล็กๆ ลอยมุมจอ
local toggleGUIBtn = Instance.new("TextButton")
toggleGUIBtn.Size = UDim2.new(0, 50, 0, 30)
toggleGUIBtn.Position = UDim2.new(0, 10, 0, 10)
toggleGUIBtn.Text = "UI"
toggleGUIBtn.Font = Enum.Font.GothamBold
toggleGUIBtn.TextSize = 16
toggleGUIBtn.TextColor3 = Color3.new(1, 1, 1)
toggleGUIBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleGUIBtn.AutoButtonColor = true
toggleGUIBtn.Parent = screenGui
toggleGUIBtn.ZIndex = 10
toggleGUIBtn.Active = true
toggleGUIBtn.Draggable = true

local cornerToggleGUI = Instance.new("UICorner")
cornerToggleGUI.CornerRadius = UDim.new(0, 8)
cornerToggleGUI.Parent = toggleGUIBtn

-- เสียงกดปุ่ม
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://452267918"
clickSound.Volume = 1
clickSound.Parent = frame

local espEnabled = true
local uiVisible = true
local deathSoundEnabled = false
local customDeathSoundId = nil

-- ฟังก์ชันแปลง HSV เป็น RGB (ทำสีรุ้ง)
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

-- ฟังก์ชันเช็คทีมง่าย ๆ
local function getPlayerTeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
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

toggleGUIBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    frame.Visible = uiVisible
    clickSound:Play()
end)

toggleDeathSoundBtn.MouseButton1Click:Connect(function()
    deathSoundEnabled = not deathSoundEnabled
    toggleDeathSoundBtn.Text = deathSoundEnabled and "Death Sound: ON" or "Death Sound: OFF"
    toggleDeathSoundBtn.BackgroundColor3 = deathSoundEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    clickSound:Play()
end)

deathSoundInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputId = tonumber(deathSoundInput.Text)
        if inputId then
            customDeathSoundId = "rbxassetid://" .. tostring(inputId)
        else
            customDeathSoundId = nil
        end
    end
end)

-- Highlight
local function createHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = getPlayerTeamColor(player)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6
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
        local humanoid = player.Character.Humanoid
        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth or 100

        if health <= 0 then
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(120, 0, 0)
        else
            local ratio = math.clamp(health / maxHealth, 0, 1)
            local r, g
            if ratio > 0.5 then
                r = (1 - ratio) * 2
                g = 1
            else
                r = 1
                g = ratio * 2
            end
            player.Character.ESPHighlight.FillColor = Color3.new(r, g, 0)
        end
    end
end

-- ระบบเสียงตาย
local function setupDeathSoundForPlayer(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")

        humanoid.Died:Connect(function()
            if player == LocalPlayer and deathSoundEnabled and customDeathSoundId then
                local sound = Instance.new("Sound")
                sound.SoundId = customDeathSoundId
                sound.Volume = 1
                sound.Parent = LocalPlayer.Character.PrimaryPart or LocalPlayer.Character:FindFirstChildWhichIsA("BasePart")
                sound:Play()
                game.Debris:AddItem(sound, 5)
            end
        end)
    end)
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
    -- Setup เสียงตายเฉพาะ LocalPlayer เท่านั้น
    if player == LocalPlayer then
        setupDeathSoundForPlayer(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end

Players.PlayerAdded:Connect(function(player)
    setupESP(player)
end)

RunService.RenderStepped:Connect(function()
    if espEnabled and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.PrimaryPart then
                    updateNameTag(player)
                    updateHighlight(player)
                end
            end
        end
    end
end)
