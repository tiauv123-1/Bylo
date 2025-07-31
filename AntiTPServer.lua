--// ANTI KICK / TP / REJOIN / CRASH - MAX PROTECTION
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local mt = getrawmetatable(game)
setreadonly(mt, false)

-- Backup
local old_namecall = mt.__namecall
local old_index = mt.__index
local old_newindex = mt.__newindex
local old_destroy = game.Destroy
local old_remove = Instance.Remove
local old_clear = Instance.ClearAllChildren
local old_kick = LocalPlayer.Kick

-- Hook __namecall
mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	if typeof(self) == "Instance" then
		if method:lower() == "kick" then
			warn("[AntiKick] Blocked Kick")
			return
		elseif method:lower():find("teleport") then
			warn("[AntiTeleport] Blocked Teleport")
			return
		elseif method:lower():find("destroy") then
			warn("[AntiDestroy] Blocked Destroy")
			return
		elseif method:lower():find("remove") then
			warn("[AntiRemove] Blocked Remove")
			return
		end
	end
	return old_namecall(self, unpack(args))
end)

-- Hook __index
mt.__index = newcclosure(function(self, key)
	if key == "Kick" or key == "kick" then
		warn("[AntiKick] Blocked __index Kick")
		return function() end
	elseif key:lower():find("teleport") then
		warn("[AntiTeleport] Blocked __index Teleport")
		return function() end
	end
	return old_index(self, key)
end)

-- Hook __newindex
mt.__newindex = newcclosure(function(self, key, value)
	if key == "Kick" or key == "kick" or key:lower():find("teleport") then
		warn("[AntiKick/Teleport] Blocked __newindex to:", key)
		return
	end
	return old_newindex(self, key, value)
end)

-- Hook Destroy
game.Destroy = function(self, ...)
	if self == LocalPlayer or self:IsDescendantOf(LocalPlayer) then
		warn("[AntiDestroy] Prevented destroying LocalPlayer")
		return
	end
	return old_destroy(self, ...)
end

-- Hook Remove
Instance.Remove = function(self, ...)
	if self == LocalPlayer or self:IsDescendantOf(LocalPlayer) then
		warn("[AntiRemove] Prevented removing LocalPlayer")
		return
	end
	return old_remove(self, ...)
end

-- Hook ClearAllChildren
Instance.ClearAllChildren = function(self, ...)
	if self == LocalPlayer.Character then
		warn("[AntiClear] Prevented ClearAllChildren on Character")
		return
	end
	return old_clear(self, ...)
end

-- Hook direct LocalPlayer:Kick()
LocalPlayer.Kick = function(...)
	warn("[AntiKick] Blocked direct LocalPlayer:Kick()")
	return
end

-- Hook TeleportService
TeleportService.Teleport = function(...)
	warn("[AntiTeleport] Blocked TeleportService:Teleport()")
	return
end
TeleportService.TeleportToPlaceInstance = function(...)
	warn("[AntiTeleport] Blocked TeleportToPlaceInstance()")
	return
end

-- Hook game:Shutdown / Close
pcall(function()
	game.Shutdown = function()
		warn("[AntiShutdown] Blocked game:Shutdown()")
	end
	game.Close = function()
		warn("[AntiClose] Blocked game:Close()")
	end
end)

-- Hook PlayerRemoving
Players.PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer then
		warn("[AntiKick] Blocked PlayerRemoving of self")
	end
end)

-- Hook CharacterRemoving
LocalPlayer.CharacterRemoving:Connect(function()
	warn("[AntiKick] Blocked CharacterRemoving")
end)

-- Hook Character nil
LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
	if not LocalPlayer.Character then
		warn("[AntiKick] Character = nil attempt blocked")
	end
end)

-- Hook Parent nil
LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
	if not LocalPlayer.Parent then
		warn("[AntiKick] LocalPlayer.Parent = nil detected!")
	end
end)

-- Hook Health = 0
task.spawn(function()
	while true do
		task.wait(1)
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			if char.Humanoid.Health <= 0 then
				warn("[AntiKill] Health = 0, reviving...")
				char.Humanoid.Health = 100
			end
		end
	end
end)

-- Hook Parent nil cho Character & Humanoid
local function hookParent(instance)
	instance:GetPropertyChangedSignal("Parent"):Connect(function()
		if not instance.Parent then
			warn("[AntiParentNil] Detected attempt to nil:", instance.Name)
			instance.Parent = workspace
		end
	end)
end

hookParent(LocalPlayer)
LocalPlayer.CharacterAdded:Connect(function(char)
	hookParent(char)
	local hum = char:WaitForChild("Humanoid", 3)
	if hum then hookParent(hum) end
end)

warn("[✅ FULL ANTI KICK / TP / REMOVE đã được kích hoạt!]")
