loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])()
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.IgnoreGuiInset = true

-- Create Squircle Frame
local frame = Instance.new("ImageLabel")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundTransparency = 1
frame.Image = "rbxassetid://89973542420407" -- Squircle shape (adjust if needed)
frame.Parent = screenGui

-- Create Moving Rainbow Background
local rainbow = Instance.new("ImageLabel")
rainbow.Size = UDim2.new(1.2, 0, 1.2, 0)
rainbow.Position = UDim2.new(-0.1, 0, -0.1, 0)
rainbow.BackgroundTransparency = 1
rainbow.Image = "rbxassetid://6424968174" -- Rainbow texture
rainbow.Parent = frame

-- Animate Background Movement
game:GetService("RunService").RenderStepped:Connect(function()
     rainbow.Position = rainbow.Position + UDim2.new(0.005, 0, 0.005, 0)
end)

-- Create Text Label
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Loading."
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 20
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Parent = frame

-- Fade In Effect
frame.ImageTransparency = 1
textLabel.TextTransparency = 1
for i = 1, 10 do
    frame.ImageTransparency = frame.ImageTransparency - 0.1
    textLabel.TextTransparency = textLabel.TextTransparency - 0.1
    wait(0.1)
end

-- Animate Loading Dots
spawn(function()
     while task.wait(1) do
         if not screenGui then return end
         textLabel.Text = "Loading."
         task.wait(1)
         textLabel.Text = "Loading.."
         task.wait(1)
         textLabel.Text = "Loading..."
     end
end)
-- Fade Out After 10 Seconds
task.wait(10)
for i = 1, 10 do
    frame.ImageTransparency = frame.ImageTransparency + 0.1
    textLabel.TextTransparency = textLabel.TextTransparency + 0.1
    wait(0.1)
end

-- Destroy GUI & Send Notification
screenGui:Destroy()
game.StarterGui:SetCore("SendNotification", {
    Title = "Loaded",
    Text = "Thanks for using!",
    Icon = "rbxassetid://89973542420407",
    Duration = 7
})


local Fluent =
loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/
download/main.lua"))()
local SaveManager =
loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/
master/Addons/SaveManager.lua"))()
local InterfaceManager =
loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/
master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Khata Hub - MM2 ",
    SubTitle = "by Nghĩa dz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Players = Window:AddTab({ Title = "Ingame Players", Icon = "users" }),
    AutoFarm = Window:AddTab({ Title = "Autofarm", Icon = "cross" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "flame" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}



-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Aimbot Settings
local AIMBOT_ENABLED = false
local TEAM_CHECK = false
local WALL_CHECK = false
local   SMOOTHNESS_ENABLED = true
local   FOV_RADIUS = 90
local   SMOOTHNESS = 0.1
local   LOCK_PART = "Head"
local   DRAW_FOV = false -- Toggle for drawing FOV circle

-- Create FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Update FOV Circle Position
RunService.RenderStepped:Connect(function()
     local screenCenter = workspace.CurrentCamera.ViewportSize / 2
     FOVCircle.Position = Vector2.new(screenCenter.X, screenCenter.Y)
     FOVCircle.Visible = DRAW_FOV -- Toggle visibility
end)

-- Function to check if a target is valid
local function IsValidTarget(player)
    if TEAM_CHECK and player.Team == LocalPlayer.Team then
        return false
    end

    if WALL_CHECK then
        local character = player.Character
        local head = character and character:FindFirstChild(LOCK_PART)
        if head then
            local origin = workspace.CurrentCamera.CFrame.Position
            local ray = Ray.new(origin, (head.Position - origin).Unit *
(head.Position - origin).Magnitude)
            local hitPart = workspace:FindPartOnRay(ray, LocalPlayer.Character,
true)
            return hitPart == head
        end
    end

      return true
end

-- Function to find the closest player
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and
player.Character:FindFirstChild(LOCK_PART) and IsValidTarget(player) then
            local head = player.Character:FindFirstChild(LOCK_PART)
            local headScreenPos, onScreen =
workspace.CurrentCamera:WorldToViewportPoint(head.Position)

            if onScreen then
                local screenCenter =
Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2,
workspace.CurrentCamera.ViewportSize.Y / 2)
                local distance = (Vector2.new(headScreenPos.X, headScreenPos.Y) -
screenCenter).Magnitude

                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                  end
            end
      end

      return closestPlayer
end

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if AIMBOT_ENABLED then
        local target = GetClosestPlayer()

        if target and target.Character and
target.Character:FindFirstChild(LOCK_PART) then
            local head = target.Character:FindFirstChild(LOCK_PART)
            local currentCameraCFrame = workspace.CurrentCamera.CFrame
            local targetCameraCFrame = CFrame.new(currentCameraCFrame.Position,
head.Position)

             -- Apply smoothness if enabled
             if SMOOTHNESS_ENABLED then
                  workspace.CurrentCamera.CFrame =
currentCameraCFrame:Lerp(targetCameraCFrame, SMOOTHNESS)
             else
                  workspace.CurrentCamera.CFrame = targetCameraCFrame
             end
         end
     end
end)
local Toggle = Tabs.Combat:AddToggle("SilentAimToggle", {
         Title = "Silent Aim",
         Description = "High unc executors only",
         Default = false,
         Callback = function(state)
             SILENTAIM_ENABLED = state
             print("Silent Aim Enabled:", state)
         end
     })

      local   players = game:GetService("Players")
      local   lp = players.LocalPlayer
      local   mouse = lp:GetMouse()
      local   lockedplayer

      local highlight = Instance.new("Highlight")
      highlight.FillColor = Color3.fromRGB(255, 0, 0)
      highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
      highlight.OutlineTransparency = 0.5
      highlight.FillTransparency = 0.3

      local function closestPlayer()
          local closest, closestDistance
        for _, player in pairs(players:GetPlayers()) do
            if player ~= lp and player.Character and
player.Character:FindFirstChild("HumanoidRootPart") then
                local targetpart = player.Character.HumanoidRootPart
                local screenPos, onScreen =
workspace.CurrentCamera:WorldToViewportPoint(targetpart.Position)
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local distance = (mousePos - Vector2.new(screenPos.X,
screenPos.Y)).Magnitude
                if onScreen and (not closest or distance < closestDistance) then
                    closest = player
                    closestDistance = distance
                end
            end
        end
        return closest
    end

    local function updateLock()
        if SILENTAIM_ENABLED then
             lockedplayer = closestPlayer()
             if lockedplayer and lockedplayer.Character then
                 highlight.Parent = lockedplayer.Character
             end
        else
             highlight.Parent = nil
             lockedplayer = nil
        end
    end


    LPH_NO_VIRTUALIZE(function()
        local originalmethod
        originalmethod = hookmetamethod(game, "__index", function(self, key)
             if not checkcaller() and self:IsA("Mouse") and key == "Hit" then
                 if SILENTAIM_ENABLED and lockedplayer and lockedplayer.Character
and lockedplayer.Character:FindFirstChild("HumanoidRootPart") then
                     return lockedplayer.Character.HumanoidRootPart.CFrame
                 end
             end
             return originalmethod(self, key)
        end)
    end)()


    game:GetService("RunService").RenderStepped:Connect(updateLock)

    local HitChance = 100

    local Slider = Tabs.Combat:AddSlider("HitChanceSlider",
    {
        Title = "Hit Chance",
        Description = "Adjust the probability of Hit",
        Default = 100,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            HitChance = Value
         end
    })

    local function shouldHit()
        return math.random(1, 100) <= HitChance
    end

    LPH_NO_VIRTUALIZE(function()
        local originalmethod
        originalmethod = hookmetamethod(game, "__index", function(self, key)
             if not checkcaller() and self:IsA("Mouse") and key == "Hit" then
                 if SILENTAIM_ENABLED and lockedplayer and lockedplayer.Character
and lockedplayer.Character:FindFirstChild("HumanoidRootPart") then
                     if shouldHit() then
                         return lockedplayer.Character.HumanoidRootPart.CFrame
                     end
                 end
             end
             return originalmethod(self, key)
        end)
    end)()




    local Section = Tabs.Combat:AddSection("Camlock")

-- Toggles
local Toggle = Tabs.Combat:AddToggle("AimbotToggle", {
    Title = "Aimbot",
    Description = "Enable or disable the aimbot",
    Default = false,
    Callback = function(state)
        AIMBOT_ENABLED = state
        print("Aimbot Enabled:", state)
    end
})

local Toggle = Tabs.Combat:AddToggle("TeamCheckToggle", {
    Title = "Team Check",
    Description = "Toggle team check functionality",
    Default = false,
    Callback = function(state)
        TEAM_CHECK = state
        print("Team Check Enabled:", state)
    end
})

local Toggle = Tabs.Combat:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Description = "Toggle wall check functionality",
    Default = false,
    Callback = function(state)
        WALL_CHECK = state
        print("Wall Check Enabled:", state)
    end
})
local Toggle = Tabs.Combat:AddToggle("SmoothnessToggle", {
    Title = "Smoothness",
    Description = "Enable or disable smoothness",
    Default = true,
    Callback = function(state)
        SMOOTHNESS_ENABLED = state
        print("Smoothness Enabled:", state)
    end
})

local Toggle = Tabs.Combat:AddToggle("FOVToggle", {
    Title = "Draw FOV",
    Description = "Toggle FOV circle visibility",
    Default = false,
    Callback = function(state)
        DRAW_FOV = state
        print("Draw FOV Enabled:", state)
    end
})

-- Inputs
local Input = Tabs.Combat:AddInput("FOVInput", {
    Title = "Adjust FOV",
    Description = "Set the aimbot FOV radius",
    Default = tostring(FOV_RADIUS),
    Placeholder = "Enter FOV Radius",
    Numeric = true,
    Callback = function(Value)
        FOV_RADIUS = tonumber(Value) or FOV_RADIUS
        FOVCircle.Radius = FOV_RADIUS
        print("FOV Radius Updated:", FOV_RADIUS)
    end
})

local Input = Tabs.Combat:AddInput("SmoothnessInput", {
    Title = "Adjust Smoothness",
    Description = "Set the aimbot smoothness",
    Default = tostring(SMOOTHNESS),
    Placeholder = "Enter Smoothness Value",
    Numeric = true,
    Callback = function(Value)
        SMOOTHNESS = tonumber(Value) or SMOOTHNESS
        print("Smoothness Updated:", SMOOTHNESS)
    end
})

-- Dropdown
local Dropdown = Tabs.Combat:AddDropdown("TargetPartDropdown", {
    Title = "Target Part",
    Description = "Choose the body part to aim at",
    Values = {"Head", "Torso"},
    Default = 1,
    Callback = function(Value)
        LOCK_PART = Value
        print("Target Part Updated:", LOCK_PART)
    end
})
local   Players = game:GetService("Players")
local   RunService = game:GetService("RunService")
local   UserInputService = game:GetService("UserInputService")
local   LocalPlayer = Players.LocalPlayer
local   Camera = workspace.CurrentCamera

local WalkspeedSlider = Tabs.Main:AddSlider("Walkspeed", {
    Title = "Walkspeed",
    Description = "Adjust your player's walkspeed.",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        if LocalPlayer.Character and
LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed =
Value
        end
    end
})

local JumpPowerSlider = Tabs.Main:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Adjust your player's jump power.",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        if LocalPlayer.Character and
LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower =
Value
        end
    end
})

local GravitySlider = Tabs.Main:AddSlider("Gravity", {
    Title = "Gravity",
    Description = "Adjust the game gravity.",
    Default = workspace.Gravity,
    Min = 0,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

local FOVSlider = Tabs.Main:AddSlider("FOV", {
    Title = "Field of View",
    Description = "Adjust the camera's field of view.",
    Default = Camera.FieldOfView,
    Min = 20,
     Max = 120,
     Rounding = 1,
     Callback = function(Value)
         Camera.FieldOfView = Value
     end
})

local InfJumpToggle = Tabs.Main:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Description = "Enable infinite jump."
})

local InfJumpEnabled = false
local InfJumpConnection

InfJumpToggle:OnChanged(function()
    InfJumpEnabled = InfJumpToggle.Value
    if InfJumpEnabled then
        InfJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and
LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then

LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidSt
ateType.Jumping)
               end
          end)
     else
          if InfJumpConnection then
               InfJumpConnection:Disconnect()
          end
     end
end)

local NoclipToggle = Tabs.Main:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false,
    Description = "Enable noclip (walk through walls)."
})

local NoclipEnabled = false
NoclipToggle:OnChanged(function()
     NoclipEnabled = NoclipToggle.Value
end)

RunService.Stepped:Connect(function()
     if NoclipEnabled and LocalPlayer.Character then
         for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
             if part:IsA("BasePart") then
                 part.CanCollide = false
             end
         end
     end
end)

local FlyToggle = Tabs.Main:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Description = "Enable flying mode."
})

local FlySpeedSlider = Tabs.Main:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Description = "Adjust your fly speed.",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)

     end
})

local FlyEnabled = false
local FlyBodyVelocity, FlyBodyGyro
local FlyConnection

FlyToggle:OnChanged(function()
    FlyEnabled = FlyToggle.Value
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
return end
    local hrp = character:FindFirstChild("HumanoidRootPart")

     if FlyEnabled then

           FlyBodyVelocity = Instance.new("BodyVelocity")
           FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
           FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
           FlyBodyVelocity.Parent = hrp

           FlyBodyGyro = Instance.new("BodyGyro")
           FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
           FlyBodyGyro.CFrame = hrp.CFrame
           FlyBodyGyro.Parent = hrp

           FlyConnection = RunService.RenderStepped:Connect(function()
               local direction = Vector3.new()
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                   direction = direction + (Camera.CFrame.LookVector)
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                   direction = direction - (Camera.CFrame.LookVector)
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                   direction = direction - (Camera.CFrame.RightVector)
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                   direction = direction + (Camera.CFrame.RightVector)
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                   direction = direction + Vector3.new(0, 1, 0)
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                   direction = direction - Vector3.new(0, 1, 0)
               end

               FlyBodyVelocity.Velocity = direction * FlySpeedSlider.Value
              if direction.Magnitude > 0 then
                  FlyBodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position +
direction)
              else
                    FlyBodyGyro.CFrame = hrp.CFrame
              end
          end)
    else
          if FlyConnection then
              FlyConnection:Disconnect()
          end
          if FlyBodyVelocity then
              FlyBodyVelocity:Destroy()
          end
          if FlyBodyGyro then
              FlyBodyGyro:Destroy()
          end
    end
end)


Tabs.Main:AddButton({
    Title = "Reset Player",
    Description = "Reset WalkSpeed and JumpPower to default values.",
    Callback = function()
        if LocalPlayer.Character and
LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
            WalkspeedSlider:SetValue(16)
            JumpPowerSlider:SetValue(50)
        end
    end
})

local ESPSection = Tabs.Visuals:AddSection("ESP")

local   ReplicatedStorage = game:GetService("ReplicatedStorage")
local   Players = game:GetService("Players")
local   RunService = game:GetService("RunService")
local   LP = Players.LocalPlayer
local   roles
local   murdererESPToggle

function CreateHighlight()
     for i, v in pairs(Players:GetChildren()) do
         if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight")
then
             Instance.new("Highlight", v.Character)
         end
     end
end

function UpdateHighlights()
    for _, v in pairs(Players:GetChildren()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
            local Highlight = v.Character:FindFirstChild("Highlight")
            if v.Name == Murder and IsAlive(v) and murdererESPToggle.Value then
                Highlight.FillColor = Color3.fromRGB(225, 0, 0)
            elseif v.Name == Sheriff and IsAlive(v) then
                 Highlight.FillColor = Color3.fromRGB(0, 0, 225)
            elseif v.Name == Hero and IsAlive(v) and not
IsAlive(game.Players[Sheriff]) then
                 Highlight.FillColor = Color3.fromRGB(255, 250, 0)
            else
                 Highlight.FillColor = Color3.fromRGB(0, 225, 0)
            end
        end
    end
end

function IsAlive(Player)
    for i, v in pairs(roles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                 return true
            else
                 return false
            end
        end
    end
end

RunService.RenderStepped:connect(function()
     roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
     for i, v in pairs(roles) do
         if v.Role == "Murderer" then
             Murder = i
         elseif v.Role == 'Sheriff' then
             Sheriff = i
         elseif v.Role == 'Hero' then
             Hero = i
         end
     end
     CreateHighlight()
     UpdateHighlights()
end)

murdererESPToggle = ESPSection:AddToggle("MurdererESP", {
    Title = " All ESP",
    Description = "All ESP",
    Default = false
})

murdererESPToggle:OnChanged(function(bool)
     UpdateHighlights()
end)

local espEnabled = false
local checkingThread = nil

local function toggleGunESP(enabled)
    local normal = workspace:FindFirstChild("Normal")
    if normal then
        for _, gunDrop in ipairs(normal:GetChildren()) do
            if gunDrop.Name == "GunDrop" then
                local highlight = gunDrop:FindFirstChild("Highlight")
                if enabled and not highlight then
                            local blah = Instance.new("Highlight", gunDrop)
                            blah.FillColor = Color3.fromRGB(7, 0, 255)
                            blah.OutlineTransparency = 0.75
                        elseif not enabled and highlight then
                            highlight:Destroy()
                        end
                  end
            end
      end
end

local function checkForNewGunDrops()
    while espEnabled do
        local normal = workspace:FindFirstChild("Normal")
        if normal then
            for _, gunDrop in ipairs(normal:GetChildren()) do
                if gunDrop.Name == "GunDrop" and not
gunDrop:FindFirstChild("Highlight") then
                    local blah = Instance.new("Highlight", gunDrop)
                    blah.FillColor = Color3.fromRGB(7, 0, 255)
                    blah.OutlineTransparency = 0.75
                end
            end
        end
        task.wait(0.5)
    end
end

local gunESPToggle = ESPSection:AddToggle("GunESP", {
    Title = "Gun ESP",
    Description = "Gun ESP",
    Default = false
})

gunESPToggle:OnChanged(function(bool)
     espEnabled = bool
     toggleGunESP(espEnabled)
     if espEnabled then
          if checkingThread then
              task.cancel(checkingThread)
          end
          checkingThread = task.spawn(checkForNewGunDrops)
     else
          if checkingThread then
              task.cancel(checkingThread)
              checkingThread = nil
          end
     end
end)

workspace.ChildAdded:Connect(function(child)
     if child.Name == "Normal" and espEnabled then
         toggleGunESP(true)
     end
end)



local utilitiesSection = Tabs.Misc:AddSection("Utilities")
utilitiesSection:AddButton({
    Title = "Rejoin",
    Description = "Rejoin the current server.",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

utilitiesSection:AddButton({
    Title = "Serverhop",
    Description = "Hop to a different server instance.",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local PlaceId = game.PlaceId

        local req = syn and syn.request or http_request or request
        if not req then
            warn("HTTP request function not available.")
            return
        end

        local url = "https://games.roblox.com/v1/games/" .. PlaceId ..
"/servers/Public?sortOrder=Asc&limit=100"
        local response = req({
             Url = url,
             Method = "GET"
        })
        if response and response.Body then
             local data = HttpService:JSONDecode(response.Body)
             local servers = {}
             for i, v in ipairs(data.data) do
                  if v.playing < v.maxPlayers then
                      table.insert(servers, v.id)
                  end
             end
             if #servers > 0 then
                  local randomServer = servers[math.random(1, #servers)]
                  TeleportService:TeleportToPlaceInstance(PlaceId, randomServer,
LocalPlayer)
             else
                  warn("No available servers found!")
             end
        end
    end
})

local executorName, executorVersion = "Unknown", "Unknown"
if identifyexecutor and type(identifyexecutor) == "function" then
    local result1, result2 = identifyexecutor()
    if type(result1) == "string" and type(result2) == "string" then
        executorName = result1
        executorVersion = result2
      end
end

utilitiesSection:AddParagraph({
    Title = "Executor Type",
    Content = "Executor: " .. executorName .. " (v" .. executorVersion .. ")"
})

utilitiesSection:AddButton({
    Title = "Set FPS Cap",
    Description = "Set your FPS cap.",
    Callback = function()
        if setfpscap then
             setfpscap(999)
        else
             warn("setfpscap function not available on your executor.")
        end
    end
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Variables
local selectedPlayer = nil
local teleportToggle = false
local bringPlayerToggle = false
local massTeleportToggle = false
local massTeleportLoop = nil
local orbitToggle = false
local orbitSpeed = 1 -- Default orbit speed
local orbitDistance = 10 -- Default orbit distance
local viewPlayerToggle = false -- Track if viewing is enabled

-- Function to Get All Players
local function getPlayers()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

-- Dropdown to Select Player (Auto-updates)
local Dropdown = Tabs.Players:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Description = "Select a player",
    Values = getPlayers(),
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedPlayer = value
        print("Selected Player:", selectedPlayer)
    end
})
-- Auto-Update Dropdown on Player Join/Leave
local function updateDropdown()
    Dropdown:SetValues(getPlayers())
end

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

-- Toggle for Viewing the Player
Tabs.Players:AddToggle("ToggleViewPlayer", {
    Title = "Toggle View Player",
    Description = "Toggle viewing the selected player",
    Default = false,
    Callback = function(state)
        viewPlayerToggle = state
        if viewPlayerToggle and selectedPlayer then
             local target = Players:FindFirstChild(selectedPlayer)
             if target and target.Character and
target.Character:FindFirstChild("Humanoid") then
                  Camera.CameraSubject = target.Character.Humanoid
                  print("Viewing", selectedPlayer)
             else
                  print("Selected player not found or not loaded yet.")
             end
        else
             Camera.CameraSubject = LocalPlayer.Character and
LocalPlayer.Character:FindFirstChild("Humanoid") or Camera
             print("Stopped Viewing", selectedPlayer)
        end
    end
})

-- Toggle for Teleporting to the Player
Tabs.Players:AddToggle("ToggleTeleport", {
    Title = "Teleport to Player",
    Description = "Teleport to the selected player",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and
target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame =
target.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

-- Toggle for Bringing the Selected Player
Tabs.Players:AddToggle("ToggleBring", {
    Title = "Bring Player",
    Description = "Bring the selected player (client-sided)",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and
target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame =
LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

-- Toggle for Mass Teleport to Player
Tabs.Players:AddToggle("MassTeleport", {
    Title = "Mass Teleport",
    Description = "Continuously teleport to the selected player",
    Default = false,
    Callback = function(state)
        massTeleportToggle = state
        if massTeleportToggle then
             massTeleportLoop = RunService.Stepped:Connect(function()
                  if selectedPlayer then
                      local target = Players:FindFirstChild(selectedPlayer)
                      if target and target.Character and
target.Character:FindFirstChild("HumanoidRootPart") then
                          LocalPlayer.Character.HumanoidRootPart.CFrame =
target.Character.HumanoidRootPart.CFrame
                      end
                  end
             end)
        else
             if massTeleportLoop then
                  massTeleportLoop:Disconnect()
                  massTeleportLoop = nil
             end
        end
    end
})

-- Toggle for Removing Selected Player from DataModel
Tabs.Players:AddToggle("ToggleRemovePlayer", {
    Title = "Remove Player from DataModel",
    Description = "Remove the selected player from the game (client-sided)",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
             local target = Players:FindFirstChild(selectedPlayer)
             if target then
                  print("Removing Player from DataModel:", target.Name)
                  target:Destroy() -- Remove the player from the client’s data model
             else
                  print("Selected player not found.")
             end
        else
             print("Toggle off or no player selected.")
        end
    end
})

-- Toggle for Orbiting the Selected Player
Tabs.Players:AddToggle("ToggleOrbit", {
    Title = "Toggle Orbit Around Player",
    Description = "Orbit around the selected player",
    Default = false,
    Callback = function(state)
        orbitToggle = state
        if orbitToggle and selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character then
                local offset = Vector3.new(orbitDistance, 0, 0)
                RunService.Heartbeat:Connect(function()
                     if orbitToggle and target and target.Character then
                         local targetPos =
target.Character.HumanoidRootPart.Position
                         -- Orbiting Logic (simple circular movement)
                         local newPos = targetPos + offset
                         newPos = newPos + Vector3.new(math.sin(tick() * orbitSpeed)
* orbitDistance, 0, math.cos(tick() * orbitSpeed) * orbitDistance)
                         LocalPlayer.Character.HumanoidRootPart.CFrame =
CFrame.new(newPos)
                     end
                end)
            end
        end
    end
})

-- Input for Orbit Speed
Tabs.Players:AddInput("OrbitSpeedInput", {
    Title = "Orbit Speed",
    Description = "Adjust the speed of the orbit",
    Default = "1",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = true, -- Call callback when user presses enter
    Callback = function(Value)
        orbitSpeed = tonumber(Value) or 1 -- Update orbit speed
        print("Orbit Speed changed to:", orbitSpeed)
    end
})

-- Input for Orbit Distance
Tabs.Players:AddInput("OrbitDistanceInput", {
    Title = "Orbit Distance",
    Description = "Adjust the distance of the orbit",
    Default = "10",
    Placeholder = "Enter Distance",
    Numeric = true,
    Finished = true, -- Call callback when user presses enter
    Callback = function(Value)
        orbitDistance = tonumber(Value) or 10 -- Update orbit distance
        print("Orbit Distance changed to:", orbitDistance)
    end
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local autoFarmToggle = false
local farmDelay = 2 -- Default delay
local lastCoin = nil -- Track last teleported coin
local autoFarmLoop = nil
local teleportMode = "Teleport to coin" -- Default mode
local teleportOffset = 8 -- Default teleport offset

-- Function to get all coins
local function getCoins()
    local coins = {}
    for _, container in ipairs(workspace:GetDescendants()) do
        if container:IsA("Model") and container.Name == "CoinContainer" then
            for _, coinServer in ipairs(container:GetChildren()) do
                 if coinServer.Name == "Coin_Server" then
                     local coinVisual = coinServer:FindFirstChild("CoinVisual")
                     if coinVisual then
                         local mainCoin = coinVisual:FindFirstChild("MainCoin")
                         if mainCoin and mainCoin:IsA("MeshPart") then
                             table.insert(coins, mainCoin)
                         end
                     end
                 end
            end
        end
    end
    return coins
end

-- Function to freeze the character
local function freezeCharacter(freeze)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if freeze then
             humanoid.PlatformStand = true -- Freeze the character
             humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        else
             humanoid.PlatformStand = false -- Unfreeze the character
             humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

-- Function to teleport to a coin
local function teleportToCoin()
    local coins = getCoins()

    if #coins > 0 then
        local randomIndex = math.random(1, #coins)
        local targetCoin = coins[randomIndex]

        -- Avoid teleporting to the same coin twice
        if targetCoin == lastCoin then
            randomIndex = (randomIndex % #coins) + 1 -- Get next coin in list
            targetCoin = coins[randomIndex]
        end

        lastCoin = targetCoin

        -- Teleport the player based on the selected mode
        if LocalPlayer.Character and
LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            if teleportMode == "Teleport above" then
                 rootPart.CFrame = targetCoin.CFrame + Vector3.new(0,
teleportOffset, 0)
            elseif teleportMode == "Teleport under" then
                 rootPart.CFrame = targetCoin.CFrame - Vector3.new(0,
teleportOffset, 0)
            else
                 rootPart.CFrame = targetCoin.CFrame + Vector3.new(0, 3, 0) --
Default method
            end
        end

            -- Freeze the character after teleporting
            freezeCharacter(true)
            task.wait(farmDelay) -- Stay frozen for the delay time
            freezeCharacter(false) -- Unfreeze the character
      end
end

-- AutoFarm Toggle
local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmToggle", {
    Title = "AutoFarm Coins",
    Description = "Toggles AutoFarm for coins",
    Default = false,
    Callback = function(state)
        autoFarmToggle = state
        if autoFarmToggle then
             print("AutoFarm Enabled")
             autoFarmLoop = task.spawn(function()
                  while autoFarmToggle do
                      teleportToCoin()
                      task.wait(farmDelay) -- Wait for the user-defined delay
                  end
             end)
        else
             print("AutoFarm Disabled")
             autoFarmToggle = false
        end
    end
})

-- Dropdown for Teleport Mode
local Dropdown = Tabs.AutoFarm:AddDropdown("TeleportModeDropdown", {
    Title = "Teleport Mode",
    Description = "Select the teleportation mode",
    Values = {"Teleport above", "Teleport to coin", "Teleport under"},
    Multi = false,
    Default = 2,
    Callback = function(value)
        teleportMode = value
        print("Teleport mode set to:", teleportMode)
    end
})

-- Slider for Teleport Offset
local Slider = Tabs.AutoFarm:AddSlider("TeleportOffsetSlider", {
    Title = "Teleport Offset",
    Description = "Adjust teleport height (above/under mode)",
     Default = 8,
     Min = 1,
     Max = 20,
     Rounding = 1,
     Callback = function(Value)
         teleportOffset = Value
         print("Teleport offset set to:", teleportOffset)
     end
})

-- Slider for AutoFarm Delay
local Slider = Tabs.AutoFarm:AddSlider("AutoFarmDelay", {
    Title = "AutoFarm Delay",
    Description = "Adjust the time delay before teleporting to a coin",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        farmDelay = Value
        print("AutoFarm delay set to:", farmDelay)
    end
})

-- Informational Paragraphs
Tabs.AutoFarm:AddParagraph({
    Title = "Kicked",
    Content = "If you had been kicked from the experience, rejoin and stay inside
the game for about 2 mins and then activate the autofarm."
})

Tabs.AutoFarm:AddParagraph({
    Title = "To Avoid Detection: ",
    Content = "Set the autofarm delay larger than 0.9"
})


local Section = Tabs.Main:AddSection("Murd and sheriff functions")


local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local murdererName = nil
local sheriffName = nil

local function findRoles()
    murdererName = nil
    sheriffName = nil

     for _, player in ipairs(Players:GetPlayers()) do
         if player == LocalPlayer then continue end
         if not player.Character then continue end

         local function hasTool(toolName)
             if player:FindFirstChild("Backpack") then
                 for _, tool in ipairs(player.Backpack:GetChildren()) do
                     if tool:IsA("Tool") and tool.Name == toolName then
                                return true
                          end
                      end
                  end
                  for _, item in ipairs(player.Character:GetChildren()) do
                      if item:IsA("Tool") and item.Name == toolName then
                          return true
                      end
                  end
                  return false
            end

            if hasTool("Knife") then
                murdererName = player.Name
            elseif hasTool("Gun") then
                sheriffName = player.Name
            end
      end
end

local function sendChatMessage()
    if murdererName and sheriffName then
        local message = string.format("%s is the Murderer, and %s is the Sheriff!",
murdererName, sheriffName)
        TextChatService.TextChannels.RBXGeneral:SendAsync(message)
    end
end

Tabs.Main:AddButton({
    Title = "Reveal Roles",
    Description = "Detect Murderer & Sheriff and send to chat",
    Callback = function()
        findRoles()
        sendChatMessage()
    end
})

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local function getAvatarHeadshot(userId)
    return string.format("https://www.roblox.com/headshot-thumbnail/image?userId=
%d&width=420&height=420&format=png", userId)
end

local function findRoles()
    local murderer = nil
    local sheriff = nil

      for _, player in ipairs(Players:GetPlayers()) do
          if not player.Character then continue end

            local function hasTool(toolName)
                if player:FindFirstChild("Backpack") then
                    for _, tool in ipairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name == toolName then
                            return true
                        end
                    end
                  end
                  for _, item in ipairs(player.Character:GetChildren()) do
                      if item:IsA("Tool") and item.Name == toolName then
                          return true
                      end
                  end
                  return false
            end

            if hasTool("Knife") then
                murderer = player
            elseif hasTool("Gun") then
                sheriff = player
            end
      end

      return murderer, sheriff
end

local function sendRobloxNotification(title, text, imageUrl)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5,
        Icon = imageUrl
    })
end

local function sendRoleNotifications()
    local murderer, sheriff = findRoles()

    if sheriff then
        sendRobloxNotification("Sheriff Found!", sheriff.Name .. " is the
Sheriff!", getAvatarHeadshot(sheriff.UserId))
    end
    if murderer then
        sendRobloxNotification("Murderer Found!", murderer.Name .. " is the
Murderer!", getAvatarHeadshot(murderer.UserId))
    end
end

-- Button to trigger the notifications
Tabs.Main:AddButton({
    Title = "Detect Roles ( notification)",
    Description = "Find Murderer & Sheriff and notify",
    Callback = function()
        sendRoleNotifications()
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function grabGun()
    local character = LP.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
return end

      local hrp = character:FindFirstChild("HumanoidRootPart")
      local normal = workspace:FindFirstChild("Normal")
      if not normal then return end

      local gunDrop = nil
      for _, obj in ipairs(normal:GetChildren()) do
          if obj.Name == "GunDrop" then
              gunDrop = obj
              break
          end
      end

      if gunDrop then
          local originalPosition = hrp.Position
          hrp.CFrame = gunDrop.CFrame
          task.wait(0.2) -- Espera para recoger la pistola
          hrp.CFrame = CFrame.new(originalPosition)
      end
end

local grabGunButton = Main:AddButton({
    Title = "Auto Grab Gun",
    Description = "Teleports to the gun and returns.",
    Callback = function()
        grabGun()
    end
})




SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("SendoxHub")
SaveManager:SetFolder("SendoxHub/MM2")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)


SaveManager:LoadAutoloadConfig()

