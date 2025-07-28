local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Nghĩa - Fling things and people",
    LoadingTitle = "Khata Hub",
    LoadingSubtitle = "by Nghĩa",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- 🛠 Main Tab
local MainTab = Window:CreateTab("Main", nil)

-- Biến điều khiển
_G.SuperThrowEnabled = false
_G.StrengthMultiplier = 5000
_G.AntiGrabEnabled = false

-- Toggle Siêu Ném
MainTab:CreateToggle({
    Name = "Bật Siêu Ném",
    CurrentValue = false,
    Callback = function(v)
        _G.SuperThrowEnabled = v
    end
})

-- Slider sức mạnh ném
MainTab:CreateSlider({
    Name = "Sức Mạnh Ném",
    Range = {100, 10000},
    Increment = 100,
    CurrentValue = 5000,
    Callback = function(v)
        _G.StrengthMultiplier = v
    end
})

-- Toggle Anti Grab
MainTab:CreateToggle({
    Name = "Bật Anti Grab",
    CurrentValue = false,
    Callback = function(v)
        _G.AntiGrabEnabled = v
    end
})

--==| Super Throw (Mới) |==--
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

Workspace.ChildAdded:Connect(function(NewModel)
    if not _G.SuperThrowEnabled then return end
    if NewModel.Name == "GrabParts" then
        local PartToImpulse = NewModel:FindFirstChild("GrabPart")
        if PartToImpulse and PartToImpulse:FindFirstChild("WeldConstraint") then
            PartToImpulse = PartToImpulse.WeldConstraint.Part1
            if PartToImpulse then
                local VelocityObject = Instance.new("BodyVelocity", PartToImpulse)
                VelocityObject.Name = "FlingVelocity"
                NewModel:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not NewModel.Parent and _G.SuperThrowEnabled then
                        VelocityObject.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        VelocityObject.Velocity = Workspace.CurrentCamera.CFrame.LookVector * _G.StrengthMultiplier
                        Debris:AddItem(VelocityObject, 1)
                    end
                end)
            end
        end
    end
end)

--==| Anti Grab |==--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CE = ReplicatedStorage:WaitForChild("CharacterEvents")
local Struggle = CE:WaitForChild("Struggle")
local BeingHeld = lp:WaitForChild("IsHeld")

Workspace.DescendantAdded:Connect(function(v)
    if _G.AntiGrabEnabled and v:IsA("Explosion") then
        v.BlastPressure = 0
    end
end)

BeingHeld.Changed:Connect(function(state)
    if state and _G.AntiGrabEnabled then
        local char = lp.Character
        local loop
        loop = RunService.RenderStepped:Connect(function()
            if BeingHeld.Value and _G.AntiGrabEnabled then
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    Struggle:FireServer(lp)
                end
            else
                loop:Disconnect()
            end
        end)
    end
end)

local function reconnect()
    if not _G.AntiGrabEnabled then return end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local f = hrp:FindFirstChild("FirePlayerPart")
    if f then f:Destroy() end

    hum.Changed:Connect(function(prop)
        if prop == "Sit" and hum.Sit then
            if hum.SeatPart == nil or tostring(hum.SeatPart.Parent) ~= "CreatureBlobman" then
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum.Sit = false
            end
        end
    end)
end

reconnect()
lp.CharacterAdded:Connect(reconnect)
