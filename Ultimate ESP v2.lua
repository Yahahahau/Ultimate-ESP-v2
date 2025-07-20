local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ลบ UI เดิมถ้ามี
local existingGui = CoreGui:FindFirstChild("ESPGui")
if existingGui then
    existingGui:Destroy()
end

-- สร้าง GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Frame หลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 90)
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

-- ปุ่มเปิด/ปิด ESP
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
deathSoundLabel.TextColor3 = Color3.new(1, 1, 1)
deathSoundLabel.BackgroundTransparency = 1
deathSoundLabel.Parent = frame
deathSoundLabel.ZIndex = 4

local deathSoundInput = Instance.new("TextBox")
deathSoundInput.Size = UDim2.new(0, 110, 0, 25)
deathSoundInput.Position = UDim2.new(0, 110, 0, 42)
deathSoundInput.PlaceholderText = "ใส่ ID ที่นี่"
deathSoundInput.Font = Enum.Font.Gotham
deathSoundInput.TextSize = 14
deathSoundInput.TextColor3 = Color3.new(1, 1, 1)
deathSoundInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
deathSoundInput.TextWrapped = true
deathSoundInput.ClearTextOnFocus = false
deathSoundInput.Parent = frame
deathSoundInput.ZIndex = 4

local cornerInput = Instance.new("UICorner")
cornerInput.CornerRadius = UDim.new(0, 6)
cornerInput.Parent = deathSoundInput

-- ปุ่มเปิด/ปิดเสียงตาย
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

-- ตัวแปรสถานะ
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

-- ฟังก์ชันหาสัดส่วนเลือด
local function getHealthRatio(humanoid)
    local maxHealth = humanoid.MaxHealth or 100
    local health = math.clamp(humanoid.Health, 0, maxHealth)
    return health / maxHealth
end

-- ฟังก์ชันหาสีทีมง่าย ๆ
local function getPlayerTeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

-- สร้าง NameTag (ไม่มีแถบเลือด แต่มีหัวใจ)
local function createNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 25)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head

        local tagLabel = Instance.new("TextLabel")
        tagLabel.Name = "TagLabel"
        tagLabel.Size = UDim2.new(1, 0, 1, 0)
        tagLabel.Position = UDim2.new(0, 0, 0, 0)
        tagLabel.BackgroundTransparency = 1
        tagLabel.TextColor3 = Color3.new(1, 1, 1)
        tagLabel.Font = Enum.Font.GothamBold
        tagLabel.TextScaled = true
        tagLabel.TextStrokeTransparency = 0.7
        tagLabel.Text = ""
        tagLabel.Parent = billboard

        -- หัวใจสวยๆ
        local heartIcon = Instance.new("ImageLabel")
        heartIcon.Name = "HeartIcon"
        heartIcon.Size = UDim2.new(0, 20, 0, 20)
        heartIcon.Position = UDim2.new(1, -30, 0, 2)
        heartIcon.BackgroundTransparency = 1
        heartIcon.Image = "rbxassetid://6031094673"
        heartIcon.Parent = billboard
    end
end

-- อัพเดต NameTag (ไม่อัพเดตตัวเอง)
local function updateNameTag(player)
    if player == LocalPlayer then return end

    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") and player.Character:FindFirstChild("Humanoid") and player.Character.PrimaryPart then
        local tagLabel = player.Character.Head.NameTag.TagLabel
        local humanoid = player.Character.Humanoid
        local distance = math.floor((LocalPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude)
        local healthValue = math.floor(humanoid.Health)

        tagLabel.Text = string.format("%s | %dm | ❤️ %d", player.Name, distance, healthValue)
    end
end

-- สร้าง Highlight ให้ตัวละคร
local function createHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

-- อัพเดตสี Highlight ตามเลือด (ไม่อัพเดตตัวเอง)
local function updateHighlight(player)
    if player == LocalPlayer then return end

    if player.Character and player.Character:FindFirstChild("ESPHighlight") and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local ratio = getHealthRatio(humanoid)
        local highlight = player.Character.ESPHighlight
        if humanoid.Health <= 0 then
            highlight.FillColor = Color3.fromRGB(120, 0, 0)
        else
            local r, g
            if ratio > 0.5 then
                r = (1 - ratio) * 2
                g = 1
            else
                r = 1
                g = ratio * 2
            end
            highlight.FillColor = Color3.new(r, g, 0)
        end
    end
end

-- ระบบเสียงตายสำหรับทุกคน
local function setupDeathSound(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if deathSoundEnabled and customDeathSoundId and player.Character and player.Character.PrimaryPart then
                local deathSound = Instance.new("Sound")
                deathSound.SoundId = customDeathSoundId
                deathSound.Volume = 1
                deathSound.Parent = player.Character.PrimaryPart
                deathSound:Play()
                game.Debris:AddItem(deathSound, 5)
            end
        end)
    end)
end

-- ตั้งค่าผู้เล่นใหม่ รวมสร้าง Highlight, NameTag, และเสียงตาย
local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        wait(0.1)
        createHighlight(player)
        createNameTag(player)
        setupDeathSound(player)
    end)
    if player.Character then
        createHighlight(player)
        createNameTag(player)
        setupDeathSound(player)
    end
end

-- สั่งเปิด/ปิด ESP ทุกคน
local function setESPEnabled(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            local nameTag = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag")
            if highlight then
                highlight.Enabled = state
            end
            if nameTag then
                nameTag.Enabled = state
            end
        end
    end
end

-- สีพื้นหลังปุ่มเปลี่ยนสีรุ้งตอนเปิด ESP
local hue = 0
RunService.RenderStepped:Connect(function()
    if espEnabled then
        hue = (hue + 1) % 360
        toggleButton.BackgroundColor3 = HSVToRGB(hue, 1, 1)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

-- อัพเดต NameTag + Highlight ทุกเฟรม (ไม่อัพเดตตัวเอง)
RunService.RenderStepped:Connect(function()
    if espEnabled and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.PrimaryPart then
                updateNameTag(player)
                updateHighlight(player)
            end
        end
    end
end)

-- ปุ่มกดเปิด/ปิด ESP
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setESPEnabled(espEnabled)
    toggleButton.Text = espEnabled and "ESP ON" or "ESP OFF"
    clickSound:Play()
end)

-- ปุ่มกดเปิด/ปิด GUI
toggleGUIBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    frame.Visible = uiVisible
    clickSound:Play()
end)

-- ปุ่มกดเปิด/ปิดเสียงตาย
toggleDeathSoundBtn.MouseButton1Click:Connect(function()
    deathSoundEnabled = not deathSoundEnabled
    toggleDeathSoundBtn.Text = deathSoundEnabled and "Death Sound: ON" or "Death Sound: OFF"
    toggleDeathSoundBtn.BackgroundColor3 = deathSoundEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    clickSound:Play()
end)

-- รับค่า ID เสียงตายจาก TextBox
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

-- เรียก setupPlayer สำหรับทุกคนในเกมตอนเริ่ม
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- เมื่อมีผู้เล่นเข้ามาใหม่
Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)
end)

-- เปิด ESP และ GUI ตั้งต้น
setESPEnabled(espEnabled)
frame.Visible = uiVisible
