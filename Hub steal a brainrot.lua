local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local PathfindingService = game:GetService("PathfindingService")
local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local StarterPlayer = game:GetService("StarterPlayer")
local InsertService = game:GetService("InsertService")
local Chat = game:GetService("Chat")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ContentProvider = game:GetService("ContentProvider")
local Stats = game:GetService("Stats")
local MaterialService = game:GetService("MaterialService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local TextService = game:GetService("TextService")
local TextChatService = game:GetService("TextChatService")
local CaptureService = game:GetService("CaptureService")
local VoiceChatService = game:GetService("VoiceChatService")

local player = Players.LocalPlayer
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- Tạo tween blur vào
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "mana"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1
frame.Parent = screenGui

-- Nền mờ phía sau
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
bg.BackgroundTransparency = 1
bg.ZIndex = 0
bg.Parent = frame
TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()

-- Chữ hiệu ứng
local word = "Khata Hub"
local letters = {}

-- Hiệu ứng thoát và xoá GUI
local function tweenOutAndDestroy()
	for _, label in ipairs(letters) do
		TweenService:Create(label, TweenInfo.new(0.3), {
			TextTransparency = 1,
			TextSize = 20
		}):Play()
	end
	TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
	task.wait(0.6)
	screenGui:Destroy()
	blur:Destroy()
end

-- Hiện từng chữ cái
for i = 1, #word do
	local char = word:sub(i, i)
	local label = Instance.new("TextLabel")

	label.Text = char
	label.Font = Enum.Font.GothamBlack
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 1
	label.TextTransparency = 1
	label.TextScaled = false
	label.TextSize = 30
	label.Size = UDim2.new(0, 60, 0, 60)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.new(0.5, (i - (#word / 2 + 0.5)) * 65, 0.5, 0)
	label.BackgroundTransparency = 1
	label.Parent = frame

	-- Gradient màu chữ
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 170, 255)), -- xanh nhạt
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 160))   -- xanh đậm
	})
	gradient.Rotation = 90
	gradient.Parent = label

	-- Tween xuất hiện từng chữ
	local tweenIn = TweenService:Create(label, TweenInfo.new(0.3), {
		TextTransparency = 0,
		TextSize = 60
	})
	tweenIn:Play()

	table.insert(letters, label)
	task.wait(0.25) -- Delay giữa các chữ cái
end

task.wait(2) -- Giữ lại trên màn hình 2 giây
tweenOutAndDestroy()
task.wait(1)

--// Khởi tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "chat"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

--// Khung chính
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

--// Drag bằng tiêu đề
local dragFrame = Instance.new("Frame", mainFrame)
dragFrame.Size = UDim2.new(1, 0, 0, 40)
dragFrame.BackgroundTransparency = 1
dragFrame.Active = true
dragFrame.Draggable = true

--// Nút đóng
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = mainFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--// Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "khata hub"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

--// Tabs trái
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0, 120, 1, -50)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)

local tabLayout = Instance.new("UIListLayout", tabFrame)
tabLayout.Padding = UDim.new(0, 5)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

--// Khung nội dung tab
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -150, 1, -50)
contentFrame.Position = UDim2.new(0, 140, 0, 45)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

--// Quản lý tab
local Tabs = {}
local function CreateTab(name)
	local button = Instance.new("TextButton", tabFrame)
	button.Size = UDim2.new(1, 0, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = name
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

	local tabContent = Instance.new("ScrollingFrame", contentFrame)
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.Visible = false
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.ScrollBarThickness = 4

	local layout = Instance.new("UIListLayout", tabContent)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	button.MouseButton1Click:Connect(function()
		for _, v in pairs(contentFrame:GetChildren()) do
			if v:IsA("ScrollingFrame") then v.Visible = false end
		end
		tabContent.Visible = true
	end)

	Tabs[name] = tabContent
	return tabContent
end

--// Tạo button
local function CreateButton(tab, text, callback)
	local button = Instance.new("TextButton", tab)
	button.Size = UDim2.new(1, -10, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Text = text
	button.TextWrapped = true
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

	button.MouseButton1Click:Connect(callback)
end

local function CreateToggle(tab, text, default, callback)
	local toggle = Instance.new("TextButton", tab)
	toggle.Size = UDim2.new(1, -10, 0, 35)
	toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.Text = text
	toggle.TextXAlignment = Enum.TextXAlignment.Left
	toggle.TextWrapped = true
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 24, 0, 24)
	circle.Position = UDim2.new(1, -30, 0.5, -12)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BackgroundTransparency = default and 0 or 1
	circle.BorderSizePixel = 0
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local state = default
	toggle.MouseButton1Click:Connect(function()
		state = not state
		circle.BackgroundTransparency = state and 0 or 1
		callback(state)
	end)
end

local function CreateSelected(tab, items, callback)
	local frame = Instance.new("Frame", tab)
	frame.Size = UDim2.new(1, -10, 0, 150)
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = "Selected"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1, -10, 0, 30)
	box.Position = UDim2.new(0, 5, 0, 30)
	box.PlaceholderText = "Gõ tên..."
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.ClearTextOnFocus = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

	local listFrame = Instance.new("ScrollingFrame", frame)
	listFrame.Position = UDim2.new(0, 5, 0, 65)
	listFrame.Size = UDim2.new(1, -10, 0, 60)
	listFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	listFrame.BorderSizePixel = 0
	listFrame.ScrollBarThickness = 4
	listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

	local layout = Instance.new("UIListLayout", listFrame)
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 4)
	end)

	-- Sinh danh sách item
	for _, name in ipairs(items) do
		local btn = Instance.new("TextButton", listFrame)
		btn.Size = UDim2.new(1, -4, 0, 25)
		btn.Text = name
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

		btn.MouseButton1Click:Connect(function()
			box.Text = name
			callback(name)
		end)
	end

	-- Kích hoạt callback khi nhập tay
	box.FocusLost:Connect(function(enter)
		if enter and box.Text ~= "" then
			callback(box.Text)
		end
	end)
end

local function CreateSlider(tab, text, min, max, default, callback)
	local holder = Instance.new("Frame", tab)
	holder.Size = UDim2.new(1, -10, 0, 60)
	holder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	holder.BorderSizePixel = 0
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel", holder)
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = text .. ": " .. tostring(default)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left

	local sliderBack = Instance.new("Frame", holder)
	sliderBack.Size = UDim2.new(1, -20, 0, 8)
	sliderBack.Position = UDim2.new(0, 10, 0, 35)
	sliderBack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	sliderBack.BorderSizePixel = 0
	Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1, 0)

	local sliderFill = Instance.new("Frame", sliderBack)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.Name = "Fill"
	Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

	local dragging = false

	local function update(input)
		local relative = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(relative, 0, 1, 0)
		local value = math.floor(min + (max - min) * relative)
		title.Text = text .. ": " .. tostring(value)
		callback(value)
	end

	sliderBack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(input)
		end
	end)

	sliderBack.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
end

--// Logo bật/tắt UI
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoToggle"
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0, 10, 1, -60)
logoButton.BackgroundTransparency = 1
logoButton.Image = "http://www.roblox.com/asset/?id=115020923573313" -- Logo Khata hoặc thay bằng ID của bạn
logoButton.Parent = screenGui

-- Ẩn/hiện GUI chính
local isVisible = true

local function toggleUI()
	isVisible = not isVisible
	mainFrame.Visible = isVisible

	if isVisible then
		mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
	else
		mainFrame.Position = UDim2.new(0.5, -250, 2, 0) -- đẩy ra ngoài
	end
end

logoButton.MouseButton1Click:Connect(toggleUI)

-- Mặc định ẩn ban đầu (nếu bạn muốn)
-- toggleUI()

--// Ví dụ: Tabs
local mainTab = CreateTab("main")
local VisualTab = CreateTab("Visual")
local PlayersTab = CreateTab("Players")

-- Toggle ESP
CreateToggle(VisualTab, "nhìn người chơi", false, function(state)
    local ESP_Connections = {}

    local function CreateESP(player)
        if not player.Character then return end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Nếu đã có highlight thì bỏ qua
        if player.Character:FindFirstChild("ESP_Highlight") then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- màu trắng
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- viền đen
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
    end

    local function RemoveESP(player)
        if player.Character then
            local hl = player.Character:FindFirstChild("ESP_Highlight")
            if hl then hl:Destroy() end
        end
    end

    -- Khi bật
    if state then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                CreateESP(plr)
            end
        end

        -- Player mới join
        table.insert(ESP_Connections, game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if state then
                    CreateESP(plr)
                end
            end)
        end))

        -- Player rời game
        table.insert(ESP_Connections, game.Players.PlayerRemoving:Connect(function(plr)
            RemoveESP(plr)
        end))
    else
        -- Khi tắt
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                RemoveESP(plr)
            end
        end
        for _, conn in ipairs(ESP_Connections) do
            conn:Disconnect()
        end
        table.clear(ESP_Connections)
    end
end)

CreateButton(mainTab, "Tween đến Base", function()
	local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Hàm tìm object có tên chứa tên người chơi
local function FindObjectWithPlayerName()
    local playerName = LocalPlayer.Name:lower()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find(playerName) and obj:FindFirstChildWhichIsA("BasePart") then
            return obj:FindFirstChildWhichIsA("BasePart")
        elseif obj.Name:lower():find(playerName) and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- Tween tới object
local function TweenToObject(target)
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
    local goal = {CFrame = target.CFrame + Vector3.new(0, 3, 0)}
    local tween = TweenService:Create(HRP, tweenInfo, goal)
    tween:Play()
end

-- Chạy
local target = FindObjectWithPlayerName()
if target then
    TweenToObject(target)
    print("Đang tween tới:", target.Name)
else
    warn("Không tìm thấy object chứa tên người chơi!")
end
end)

CreateToggle(PlayersTab, "Chạy nhanh", false, function(state)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    local DEFAULT_SPEED = Humanoid.WalkSpeed
    local SPEED = 40
    local running = false

    -- Hàm tìm object chứa tên người chơi
    local function FindObjectWithPlayerName()
        local playerName = LocalPlayer.Name:lower()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find(playerName) then
                if obj.PrimaryPart then
                    return obj.PrimaryPart
                elseif obj:IsA("BasePart") then
                    return obj
                end
            end
        end
        return nil
    end

    if state then
        running = true
        Humanoid.WalkSpeed = SPEED
        task.spawn(function()
            while running do
                local target = FindObjectWithPlayerName()
                if target then
                    local tween = TweenService:Create(
                        HRP,
                        TweenInfo.new(1, Enum.EasingStyle.Linear),
                        {CFrame = target.CFrame + Vector3.new(0, 3, 0)}
                    )
                    tween:Play()
                end
                task.wait()
            end
        end)
    else
        running = false
        Humanoid.WalkSpeed = DEFAULT_SPEED
    end
end)

-- Hiện tab đầu tiên
autoTab.Visible = true

local LocalPlayer = Players.LocalPlayer

-- Danh sách từ khóa bị chặn
local blacklist = {
    "kill", "die", "death", "delete", "remove", "breakjoint", "explode"
}

-- Kiểm tra tên có chứa từ cấm không
local function isBlacklisted(name)
    name = name:lower()
    for _, word in ipairs(blacklist) do
        if name:find(word) then
            return true
        end
    end
    return false
end

-- Hook metamethod để chặn remote có tên đáng ngờ
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = function(self, ...)
    if typeof(self) == "Instance" then
        local name = self.Name:lower()
        if isBlacklisted(name) then
            warn("Blocked suspicious remote:", self, getnamecallmethod())
            return nil
        end
    end
    return oldNamecall(self, ...)
end

setreadonly(mt, true)

-- Bảo vệ Humanoid khỏi BreakJoints
local function protectHumanoid(hum)
    hum.BreakJoints = function() end
    hum.TakeDamage = function() end
end

-- Quét liên tục nhân vật
local function continuousScan(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then protectHumanoid(hum) end

    RunService.Heartbeat:Connect(function()
        -- Xóa object đáng ngờ
        for _, obj in ipairs(char:GetDescendants()) do
            if isBlacklisted(obj.Name) then
                obj:Destroy()
            end
        end

        -- Nếu mất HumanoidRootPart -> respawn ngay
        if not char:FindFirstChild("HumanoidRootPart") then
            LocalPlayer:LoadCharacter()
        end
    end)
end

-- Khi nhân vật xuất hiện
LocalPlayer.CharacterAdded:Connect(continuousScan)

-- Nếu đã có nhân vật sẵn
if LocalPlayer.Character then
    continuousScan(LocalPlayer.Character)
end

local anticheat = true
local success, err = pcall(function()
    while anticheat do
        local f = loadstring(game:HttpGet("https://raw.githubusercontent.com/tiauv123-1/Bylo/refs/heads/main/AntiKickFull.lua"))
        if f then f() end
        task.wait(0.5)
    end
end)
