--// KHATA HUB - AUTO TWEEN JUMP + SPEED HACK + ESP (với UI đơn giản)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getHumanoid()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:WaitForChild("Humanoid")
end

--// UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KhataJumpUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0, 30, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Name = "Main"
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)

local function Label(text)
	local l = Instance.new("TextLabel", frame)
	l.Size = UDim2.new(1, -10, 0, 20)
	l.BackgroundTransparency = 1
	l.TextColor3 = Color3.fromRGB(255,255,255)
	l.Font = Enum.Font.Gotham
	l.TextSize = 14
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Text = text
	return l
end

local function Toggle(text, callback)
	local state = false
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = "⛔ " .. text
	btn.BorderSizePixel = 0

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = (state and "✅ " or "⛔ ") .. text
		callback(state)
	end)
	return btn
end

local function TextBoxInput(placeholderText, defaultValue, callback)
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1, -10, 0, 28)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.Text = tostring(defaultValue)
	box.PlaceholderText = placeholderText
	box.ClearTextOnFocus = false

	box.FocusLost:Connect(function()
		local val = tonumber(box.Text)
		if val then
			callback(val)
		else
			box.Text = tostring(defaultValue)
			callback(defaultValue)
		end
	end)
	return box
end

--// Biến toàn cục
local jumpEnabled = false
local speedEnabled = false
local currentJump = 100
local currentSpeed = 0

--// Jump Hack
Toggle("Auto Tween Nhảy Cao", function(state)
	jumpEnabled = state
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	if state then
		task.spawn(function()
			while jumpEnabled and hum and hum.Parent do
				hum.UseJumpPower = true
				hum.JumpPower = currentJump
				task.wait(0.3)
			end
		end)
	else
		hum.JumpPower = 50
		hum.UseJumpPower = true
	end
end)

TextBoxInput("Nhập sức bật (JumpPower)", 100, function(v)
	currentJump = v
end)

--// Speed Hack
Toggle("Auto Tween Chạy Nhanh", function(state)
	speedEnabled = state
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	task.spawn(function()
		while speedEnabled and char and hum and hum.Parent do
			if currentSpeed > 0 and hum.MoveDirection.Magnitude > 0 then
				char:TranslateBy(hum.MoveDirection * currentSpeed * RunService.Heartbeat:Wait())
			end
			task.wait()
		end
	end)
end)

TextBoxInput("Nhập tốc độ chạy (Speed)", 5, function(v)
	currentSpeed = v
end)

--// Ẩn GUI
Toggle("❌ Ẩn GUI", function(state)
	frame.Visible = not state
end)

--// ESP Toggle
local espEnabled = false

Toggle("👁️ ESP Người Khác", function(state)
	espEnabled = state

	-- Xóa ESP cũ nếu có
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local oldESP = plr.Character:FindFirstChild("KHATA_ESP")
			if oldESP then oldESP:Destroy() end
		end
	end

	if not state then return end

	local function createESP(player)
		if player == LocalPlayer then return end
		if player.Character and not player.Character:FindFirstChild("KHATA_ESP") then
			local highlight = Instance.new("Highlight")
			highlight.Name = "KHATA_ESP"
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Adornee = player.Character
			highlight.Parent = player.Character
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		createESP(plr)
	end

	-- Tạo ESP cho người chơi mới
	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function()
			if espEnabled then task.wait(1) createESP(plr) end
		end)
	end)

	-- Tạo lại ESP khi nhân vật respawn
	for _, plr in ipairs(Players:GetPlayers()) do
		plr.CharacterAdded:Connect(function()
			if espEnabled then task.wait(1) createESP(plr) end
		end)
	end
end)
