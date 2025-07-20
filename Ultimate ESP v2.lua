local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

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

-- Frame หลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
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

-- ปุ่มเปิด/ปิด ESP
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

-- ช่องกรอกไอดีเสียงตาย
local deathSoundBox = Instance.new("TextBox")
deathSoundBox.Size = UDim2.new(0, 160, 0, 25)
deathSoundBox.Position = UDim2.new(0, 10, 0, 50)
deathSoundBox.PlaceholderText = "ใส่ ID เสียงตาย (เช่น 123456789)"
deathSoundBox.Font = Enum.Font.Gotham
deathSoundBox.TextSize = 14
deathSoundBox.TextColor3 = Color3.new(1, 1, 1)
deathSoundBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
deathSoundBox.ClearTextOnFocus = false
deathSoundBox.Parent = frame
deathSoundBox.ZIndex = 5

local cornerBox = Instance.new("UICorner")
cornerBox.CornerRadius = UDim.new(0, 8)
cornerBox.Parent = deathSoundBox

-- ปุ่มเปิด/ปิดเสียงตาย
local deathSoundToggle = Instance.new("TextButton")
deathSoundToggle.Size = UDim2.new(0, 160, 0, 30)
deathSoundToggle.Position = UDim2.new(0, 10, 0, 80)
deathSoundToggle.Text = "DeathSound: off"
deathSoundToggle.Font = Enum.Font.GothamBold
deathSoundToggle.TextSize = 16
deathSoundToggle.TextColor3 = Color3.new(1, 1, 1)
deathSoundToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
deathSoundToggle.AutoButtonColor = true
deathSoundToggle.Parent = frame
deathSoundToggle.ZIndex = 5

local cornerToggleDeath = Instance.new("UICorner")
cornerToggleDeath.CornerRadius = UDim.new(0, 8)
cornerToggleDeath.Parent = deathSoundToggle

-- ปุ่ม Toggle UI
local toggleGUIBtn = Instance.new("TextButton")
toggleGUIBtn.Size = UDim2.new(0, 50, 0, 30)
toggleGUIBtn.Position = UDim2.new(0, 10, 0, 10)
toggleGUIBtn.Text = "UI"
toggleGUIBtn.Font = Enum.Font.GothamBold
toggleGUIBtn.TextSize = 14
toggleGUIBtn.TextColor3 = Color3.new(1, 1, 1)
toggleGUIBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleGUIBtn.AutoButtonColor = true
toggleGUIBtn.Parent = screenGui
toggleGUIBtn.ZIndex = 6

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 8)
toggleUICorner.Parent = toggleGUIBtn

-- ตัวแปรเสียงตาย
local deathSoundEnabled = false
local customDeathSoundId = nil

-- ฟังก์ชัน ESP
local function applyESP(player)
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Parent = player.Character

	RunService.RenderStepped:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hp = player.Character.Humanoid.Health
			if hp > 75 then
				highlight.FillColor = Color3.fromRGB(0, 255, 0)
			elseif hp > 35 then
				highlight.FillColor = Color3.fromRGB(255, 165, 0)
			else
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
			end
		end
	end)
end

-- ฟังก์ชันเล่นเสียงตาย (ทุกผู้เล่น)
local function setupDeathSoundForPlayer(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			if deathSoundEnabled and customDeathSoundId then
				local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
				if root then
					local sound = Instance.new("Sound")
					sound.SoundId = customDeathSoundId
					sound.Volume = 1
					sound.Parent = root
					sound:Play()
					Debris:AddItem(sound, 5)
				end
			end
		end)
	end)
end

-- ตั้งค่าผู้เล่นใหม่
local function setupPlayer(player)
	player.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid")
		wait(0.2)
		if toggleButton.Text == "ESP ON" then
			applyESP(player)
		end
	end)
	setupDeathSoundForPlayer(player)
end

-- ปรับ ESP
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		setupPlayer(player)
	end
end

Players.PlayerAdded:Connect(setupPlayer)

-- ปุ่ม ESP
toggleButton.MouseButton1Click:Connect(function()
	if toggleButton.Text == "ESP ON" then
		toggleButton.Text = "ESP OFF"
	else
		toggleButton.Text = "ESP ON"
	end
end)

-- ปุ่มเสียงตาย
deathSoundToggle.MouseButton1Click:Connect(function()
	deathSoundEnabled = not deathSoundEnabled
	if deathSoundEnabled then
		deathSoundToggle.Text = "เสียงตาย: เปิด"
		deathSoundToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	else
		deathSoundToggle.Text = "เสียงตาย: ปิด"
		deathSoundToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)

-- อัปเดต ID เสียง
deathSoundBox:GetPropertyChangedSignal("Text"):Connect(function()
	local id = deathSoundBox.Text:match("%d+")
	if id then
		customDeathSoundId = "rbxassetid://" .. id
	end
end)

-- Toggle UI
local uiVisible = true
toggleGUIBtn.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	frame.Visible = uiVisible
end)
