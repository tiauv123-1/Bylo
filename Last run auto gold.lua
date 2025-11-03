
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="GoldFarmUI"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,280,0,160)
frame.Position=UDim2.new(0.5,-140,0.18,0)
frame.BackgroundColor3=Color3.fromRGB(24,24,24)
frame.BackgroundTransparency=0.05
frame.BorderSizePixel=0
frame.Active=true
frame.Draggable=true
frame.Parent=gui
Instance.new("UICorner",frame)
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,30)
title.BackgroundTransparency=1
title.Text="AutoGold"
title.TextColor3=Color3.fromRGB(255,215,0)
title.Font=Enum.Font.GothamBold
title.TextSize=16
local toggleFrame=Instance.new("Frame",frame)
toggleFrame.Size=UDim2.new(0,72,0,34)
toggleFrame.Position=UDim2.new(0.5,-36,0.35,0)
toggleFrame.BackgroundColor3=Color3.fromRGB(140,20,20)
toggleFrame.BorderSizePixel=0
Instance.new("UICorner",toggleFrame)
local toggleCircle=Instance.new("Frame",toggleFrame)
toggleCircle.Size=UDim2.new(0,30,0,30)
toggleCircle.Position=UDim2.new(0,2,0,2)
toggleCircle.BackgroundColor3=Color3.fromRGB(255,255,255)
Instance.new("UICorner",toggleCircle)
local timerLabel=Instance.new("TextLabel",frame)
timerLabel.Size=UDim2.new(1,0,0,22)
timerLabel.Position=UDim2.new(0,0,0.58,0)
timerLabel.BackgroundTransparency=1
timerLabel.Text="Time: 00:00:00"
timerLabel.TextColor3=Color3.fromRGB(100,255,255)
timerLabel.Font=Enum.Font.Code
timerLabel.TextSize=14
local goldLabel=Instance.new("TextLabel",frame)
goldLabel.Size=UDim2.new(1,0,0,22)
goldLabel.Position=UDim2.new(0,0,0.73,0)
goldLabel.BackgroundTransparency=1
goldLabel.Text="Gold: 0"
goldLabel.TextColor3=Color3.fromRGB(255,215,0)
goldLabel.Font=Enum.Font.GothamBold
goldLabel.TextSize=15
local statusLabel=Instance.new("TextLabel",frame)
statusLabel.Size=UDim2.new(1,0,0,20)
statusLabel.Position=UDim2.new(0,0,1,-26)
statusLabel.BackgroundTransparency=1
statusLabel.Text="OFF"
statusLabel.TextColor3=Color3.fromRGB(255,80,80)
statusLabel.Font=Enum.Font.GothamBold
statusLabel.TextSize=13
local dragging,dragStart,startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=frame.Position
	end
end)
frame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
		local delta=input.Position-dragStart
		frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=false
	end
end)
local autoPickup=false
local goldCount=0
local startTime=0
local hrp
local savedOrigin=nil
local function refreshHRP()
	local char=player.Character or player.CharacterAdded:Wait()
	hrp=char:WaitForChild("HumanoidRootPart")
end
refreshHRP()
player.CharacterAdded:Connect(refreshHRP)
local function formatTime(seconds)
	local h=math.floor(seconds/3600)
	local m=math.floor((seconds%3600)/60)
	local s=seconds%60
	return string.format("%02d:%02d:%02d",h,m,s)
end
local function findPromptInGold(goldBar)
	if not goldBar then return nil end
	local p=goldBar:FindFirstChild("PickupGoldPrompt",true)
	if p and p:IsA("ProximityPrompt") then return p end
	return goldBar:FindFirstChildWhichIsA("ProximityPrompt",true)
end
local function safeFirePrompt(prompt)
	if not prompt then return false end
	local ok=pcall(function()
		if typeof(prompt.RequiresLineOfSight)=="boolean" then prompt.RequiresLineOfSight=false end
		if typeof(prompt.MaxActivationDistance)=="number" then prompt.MaxActivationDistance=100 end
		fireproximityprompt(prompt)
	end)
	if ok then
		goldCount=goldCount+1
		goldLabel.Text="Gold: "..goldCount
	end
	return ok
end
local function scannerLoop()
	local isFrozen=false
	while autoPickup do
		local barsFolder=workspace:FindFirstChild("GoldBars")
		if not barsFolder then task.wait(1) continue end
		local goldList={}
		for _,gb in pairs(barsFolder:GetChildren()) do
			local prompt=findPromptInGold(gb)
			if prompt and prompt.Enabled then
				local tpPart=gb.PrimaryPart or gb:FindFirstChildWhichIsA("BasePart",true)
				if tpPart and hrp then
					local distance=(tpPart.Position-hrp.Position).Magnitude
					table.insert(goldList,{gold=gb,prompt=prompt,part=tpPart,dist=distance})
				end
			end
		end
		if #goldList==0 then
			statusLabel.Text="NO GOLD - SAFE SKY"
			if hrp and not isFrozen then
				local upPos=hrp.CFrame+Vector3.new(0,100,0)
				hrp.CFrame=upPos
				task.wait(0.1)
				hrp.Anchored=true
				isFrozen=true
			end
			task.wait(2)
			continue
		end
		if isFrozen then
			hrp.Anchored=false
			isFrozen=false
			statusLabel.Text="FARMING..."
		end
		table.sort(goldList,function(a,b) return a.dist<b.dist end)
		for _,entry in ipairs(goldList) do
			if not autoPickup then break end
			local gb,prompt,tpPart=entry.gold,entry.prompt,entry.part
			if hrp then
				hrp.CFrame=tpPart.CFrame+Vector3.new(0,3,0)
				task.wait(0.25)
			end
			safeFirePrompt(prompt)
			task.wait(0.15)
		end
		task.wait(1)
	end
	if hrp then hrp.Anchored=false end
end
spawn(function()
	while task.wait(1) do
		if autoPickup and startTime>0 then
			timerLabel.Text="Time: "..formatTime(math.floor(os.time()-startTime))
		end
	end
end)
local function setToggle(state)
	autoPickup=state
	if state then
		startTime=os.time()
		goldCount=0
		goldLabel.Text="Gold: 0"
		timerLabel.Text="Time: 00:00:00"
		statusLabel.Text="FARMING..."
		statusLabel.TextColor3=Color3.fromRGB(120,255,120)
		TweenService:Create(toggleFrame,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(20,150,20)}):Play()
		TweenService:Create(toggleCircle,TweenInfo.new(0.18),{Position=UDim2.new(1,-32,0,2)}):Play()
		if hrp and not savedOrigin then
			savedOrigin=hrp.CFrame
		end
		task.spawn(scannerLoop)
	else
		statusLabel.Text="OFF"
		statusLabel.TextColor3=Color3.fromRGB(255,80,80)
		TweenService:Create(toggleFrame,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(140,20,20)}):Play()
		TweenService:Create(toggleCircle,TweenInfo.new(0.18),{Position=UDim2.new(0,2,0,2)}):Play()
		if hrp and savedOrigin then
			hrp.Anchored=false
			hrp.CFrame=savedOrigin
		end
	end
end
toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		setToggle(not autoPickup)
	end
end)
UserInputService.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	if input.KeyCode==Enum.KeyCode.P then
		setToggle(not autoPickup)
	end
end)
player.CharacterAdded:Connect(function()
	task.wait(3)
	refreshHRP()
	savedOrigin=nil
	if autoPickup then task.spawn(scannerLoop) end
end)
setToggle(false)
