local p=game:GetService("Players").LocalPlayer
local mt=getrawmetatable(game)
setreadonly(mt,false)

local oldNamecall=mt.__namecall
local oldIndex=mt.__index
local oldNewIndex=mt.__newindex

local function blockKickNamecall(self,...)
    local method=getnamecallmethod()
    if self==p and method=="Kick" then
        warn("[AK] Blocked :Kick()")
        warn(debug.traceback("",2))
        return
    end
    return oldNamecall(self,...)
end

local function blockKickIndex(self,key)
    if self==p and key=="Kick" then
        warn("[AK] Blocked .Kick")
        warn(debug.traceback("",2))
        return function() end
    end
    return oldIndex(self,key)
end

local function blockKickNewIndex(self,key,value)
    if self==p and key=="Kick" then
        warn("[AK] Blocked setting .Kick")
        warn(debug.traceback("",2))
        return
    end
    return oldNewIndex(self,key,value)
end

local function hookNamecall()
    mt.__namecall=newcclosure(blockKickNamecall)
end

local function hookIndex()
    mt.__index=newcclosure(blockKickIndex)
end

local function hookNewIndex()
    mt.__newindex=newcclosure(blockKickNewIndex)
end

local function protectKickFunc()
    p.Kick=function(...)
        warn("[AK] Blocked direct Kick call")
        warn(debug.traceback("",2))
    end
end

local function hookHookfunction()
    if hookfunction then
        pcall(function()
            hookfunction(p.Kick,function(...)
                warn("[AK] Blocked Kick via hookfunction")
                warn(debug.traceback("",2))
            end)
        end)
    end
end

local function hookMetamethod()
    if hookmetamethod then
        local oldHook=hookmetamethod
        hookmetamethod=function(...)
            local args={...}
            if args[2]=="Kick" or args[2]=="__namecall" or args[2]=="__index" then
                return
            end
            return oldHook(...)
        end
    end
end

local function disableConnections()
    if getconnections then
        local conns=getconnections(p.Kick)
        for _,c in pairs(conns) do
            c:Disable()
            warn("[AK] Disabled Kick connection")
        end
    end
end

local function retryHooking()
    task.spawn(function()
        while true do
            if mt.__namecall~=blockKickNamecall then
                mt.__namecall=blockKickNamecall
            end
            if mt.__index~=blockKickIndex then
                mt.__index=blockKickIndex
            end
            if mt.__newindex~=blockKickNewIndex then
                mt.__newindex=blockKickNewIndex
            end
            if p.Kick~=function(...) warn("[AK] Blocked direct Kick call") warn(debug.traceback("",2)) end then
                protectKickFunc()
            end
            task.wait(3)
        end
    end)
end

hookNamecall()
hookIndex()
hookNewIndex()
protectKickFunc()
hookHookfunction()
hookMetamethod()
retryHooking()

local p=game:GetService("Players").LocalPlayer
local mt=getrawmetatable(game)
setreadonly(mt,false)
local oldNamecall=mt.__namecall
local oldIndex=mt.__index
local oldNewIndex=mt.__newindex

local function blockKick1(self,...)
    local m=getnamecallmethod()
    if self==p and m=="Kick" then return end
    return oldNamecall(self,...)
end

local function blockKick2(self,key)
    if self==p and key=="Kick" then return function() end end
    return oldIndex(self,key)
end

local function blockKick3(self,key,value)
    if self==p and key=="Kick" then return end
    return oldNewIndex(self,key,value)
end

local function protectKickFunc1()
    p.Kick=function() end
end

local function protectKickFunc2()
    local orig=p.Kick
    p.Kick=function(...)
        warn("[AK] Blocked Kick call 2")
        return orig(...)
    end
end

local function hookHookfunction1()
    if hookfunction then
        pcall(function()
            hookfunction(p.Kick,function(...) end)
        end)
    end
end

local function hookHookfunction2()
    if hookfunction then
        local ok,unhook=pcall(function()
            return hookfunction(p.Kick,function(...)
                warn("[AK] Hooked Kick")
            end)
        end)
    end
end

local function hookMetamethod1()
    if hookmetamethod then
        local old=hookmetamethod
        hookmetamethod=function(...)
            local args={...}
            if args[2]=="Kick" then return end
            return old(...)
        end
    end
end

local function hookMetamethod2()
    if hookmetamethod then
        local old=hookmetamethod
        hookmetamethod=function(self,mtName,...)
            if mtName=="Kick" then return end
            return old(self,mtName,...)
        end
    end
end

local function disableConnections1()
    if getconnections then
        for _,c in pairs(getconnections(p.Kick) or {}) do
            c:Disable()
        end
    end
end

local function disableConnections2()
    if getconnections then
        local conns=getconnections(p.Kick)
        for i=1,#conns do
            conns[i]:Disable()
        end
    end
end

local function rehookNamecall()
    mt.__namecall=newcclosure(function(self,...)
        local m=getnamecallmethod()
        if self==p and m=="Kick" then return end
        return oldNamecall(self,...)
    end)
end

local function rehookIndex()
    mt.__index=newcclosure(function(self,k)
        if self==p and k=="Kick" then return function() end end
        return oldIndex(self,k)
    end)
end

local function rehookNewIndex()
    mt.__newindex=newcclosure(function(self,k,v)
        if self==p and k=="Kick" then return end
        return oldNewIndex(self,k,v)
    end)
end

local function dummyKick()
    p.Kick=function() end
end

local function dummyKick2()
    local old=p.Kick
    p.Kick=function(...)
        return old(...)
    end
end

local function dummyKick3()
    local kicked=false
    p.Kick=function()
        if not kicked then
            kicked=true
        end
    end
end

local function safeCall1()
    pcall(function()
        p.Kick=function() end
    end)
end

local function safeCall2()
    pcall(function()
        mt.__namecall=newcclosure(function(self,...)
            local m=getnamecallmethod()
            if self==p and m=="Kick" then return end
            return oldNamecall(self,...)
        end)
    end)
end

local function safeCall3()
    pcall(function()
        mt.__index=newcclosure(function(self,k)
            if self==p and k=="Kick" then return function() end end
            return oldIndex(self,k)
        end)
    end)
end



blockKick2()
protectKickFunc1()
protectKickFunc2()
hookHookfunction1()
hookHookfunction2()
hookMetamethod1()
hookMetamethod2()
disableConnections1()
disableConnections2()
rehookNamecall()
rehookIndex()
rehookNewIndex()
dummyKick()
dummyKick2()
dummyKick3()
safeCall1()
safeCall2()
safeCall3()

local p=game:GetService("Players").LocalPlayer
local mt=getrawmetatable(game)
setreadonly(mt,false)
local oldNamecall=mt.__namecall
local oldIndex=mt.__index
local oldNewIndex=mt.__newindex
local rs=game:GetService("RunService")

local function blockKickNamecall1()
    mt.__namecall=newcclosure(function(self,...)
        if self==p and getnamecallmethod()=="Kick" then return end
        return oldNamecall(self,...)
    end)
end

local function blockKickIndex1()
    mt.__index=newcclosure(function(self,k)
        if self==p and k=="Kick" then return function() end end
        return oldIndex(self,k)
    end)
end

local function blockKickNewIndex1()
    mt.__newindex=newcclosure(function(self,k,v)
        if self==p and k=="Kick" then return end
        return oldNewIndex(self,k,v)
    end)
end

local function dummyKick1()
    p.Kick=function() end
end

local function disconnectKickConns1()
    if getconnections then
        for _,c in pairs(getconnections(p.Kick) or {}) do
            c:Disable()
        end
    end
end

local function blockKickNamecall2()
    mt.__namecall=newcclosure(function(self,...)
        local method=getnamecallmethod()
        if self==p and (method=="Kick" or method=="Destroy" or method=="BreakJoints") then return end
        return oldNamecall(self,...)
    end)
end

local function fakeMetatable1()
    local proxy={}
    local proxyMt={
        __index=function(t,k)
            if k=="Kick" then return function() end end
            return oldIndex(p,k)
        end,
        __newindex=function(t,k,v)
            if k=="Kick" then return end
            oldNewIndex(p,k,v)
        end,
    }
    setmetatable(proxy,proxyMt)
    _G.fakePlayer=proxy
end

local function hookFunctionOverride()
    if hookfunction then
        local ok,unhook=pcall(function()
            return hookfunction(p.Kick,function(...) end)
        end)
    end
end

local function safePcallOverride()
    pcall(function()
        p.Kick=function() end
    end)
end

local function repeatedBlock()
    task.spawn(function()
        while true do
            p.Kick=function() end
            task.wait(0.5)
        end
    end)
end

local function obfuscationJunk1()
    local a,b,c,d,e,f,g,h,i,j=math.random(),math.random(),math.random(),math.random(),math.random(),math.random(),math.random(),math.random(),math.random(),math.random()
    local x=a+b-c*d+e/f-g+h*i-j
end

local function protectKickFunc()
    local old=p.Kick
    p.Kick=function(...)
        warn("[AK] Kick prevented")
        return old(...)
    end
end

local function overrideKickWithClosure()
    local closed=false
    p.Kick=function()
        if closed then return end
        closed=true
    end
end

local function blockKickNamecall3()
    mt.__namecall=newcclosure(function(self,...)
        if self==p and getnamecallmethod()=="Kick" then return end
        return oldNamecall(self,...)
    end)
end

local function delayDisableConnections()
    task.spawn(function()
        task.wait(1)
        if getconnections then
            for _,c in pairs(getconnections(p.Kick) or {}) do
                c:Disable()
            end
        end
    end)
end

local function randomJunkVars()
    local zxc,asd,qwe,rty,uio,pas=dfkj(),plk(),mok(),yiw(),rto(),vbn()
end

local function overrideMetatableIndex()
    local old=mt.__index
    mt.__index=newcclosure(function(self,k)
        if self==p and k=="Kick" then return function() end end
        return old(self,k)
    end)
end

local function overrideMetatableNewIndex()
    local old=mt.__newindex
    mt.__newindex=newcclosure(function(self,k,v)
        if self==p and k=="Kick" then return end
        return old(self,k,v)
    end)
end

blockKickNamecall1()
blockKickIndex1()
blockKickNewIndex1()
dummyKick1()
disconnectKickConns1()
blockKickNamecall2()
fakeMetatable1()
hookFunctionOverride()
safePcallOverride()
repeatedBlock()
obfuscationJunk1()
protectKickFunc()
overrideKickWithClosure()
blockKickNamecall3()
delayDisableConnections()
randomJunkVars()
overrideMetatableIndex()
overrideMetatableNewIndex()

local p = game:GetService("Players").LocalPlayer
local mt = getrawmetatable(game)
setreadonly(mt,false)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
local rs = game:GetService("RunService")

local Proxy = newproxy(true)
local pm = getmetatable(Proxy)
pm.__tostring = function() return "PlayerProxy" end
pm.__index = function(t,k)
    if k == "Kick" then return function() end end
    return rawget(t,k)
end
pm.__newindex = function(t,k,v)
    if k == "Kick" then return end
    rawset(t,k,v)
end

local function useProxyPlayer()
    _G.ProxyPlayer = Proxy
end

local function spoofConnections()
    if getconnections then
        local cons = getconnections(p.Kick) or {}
        for i=1,#cons do
            coroutine.wrap(function()
                while true do
                    cons[i]:Enable()
                    task.wait(0.3)
                    cons[i]:Disable()
                    task.wait(0.3)
                end
            end)()
        end
    end
end

local function overrideKickSignal()
    if p.Kick and typeof(p.Kick) == "RBXScriptSignal" then
        local oldFire = p.Kick.Fire
        p.Kick.Fire = function() end
    end
end

local function swapMetatable()
    local fakeMT = {}
    for k,v in pairs(mt) do
        fakeMT[k] = v
    end
    fakeMT.__namecall = newcclosure(function(self,...)
        if self == p and getnamecallmethod() == "Kick" then
            return
        end
        return oldNamecall(self,...)
    end)
    debug.setmetatable(p, fakeMT)
end

local function blockKickEvent()
    if p:FindFirstChild("KickEvent") then
        p.KickEvent:Disconnect()
    end
end

local function blockDestroy()
    mt.__namecall = newcclosure(function(self,...)
        if self == p and getnamecallmethod() == "Destroy" then
            return
        end
        return oldNamecall(self,...)
    end)
end

local function hookRawMetatable()
    local rawMT = getrawmetatable(p)
    rawMT.__index = newcclosure(function(self,k)
        if k == "Kick" then return function() end end
        return oldIndex(self,k)
    end)
end

local function overwriteKickWithError()
    p.Kick = function()
        error("Kick blocked")
    end
end

local function lockPosition()
    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local pos = root.CFrame
    local locked = false
    local conn
    conn = rs.Heartbeat:Connect(function()
        if locked then return end
        locked = true
        root.CFrame = pos
        locked = false
    end)
    task.delay(5,function() conn:Disconnect() end)
end

local function blockDestroyAndBreak()
    mt.__namecall = newcclosure(function(self,...)
        local method = getnamecallmethod()
        if self == p and (method == "Destroy" or method == "BreakJoints") then
            return
        end
        return oldNamecall(self,...)
    end)
end

local function infiniteDummyKick()
    task.spawn(function()
        while true do
            p.Kick = function() end
            task.wait(0.1)
        end
    end)
end

local function fakeCharacterSpawn()
    local fakeChar = Instance.new("Model")
    fakeChar.Name = p.Name.."_Fake"
    fakeChar.Parent = workspace
    local hrp = Instance.new("Part", fakeChar)
    hrp.Name = "HumanoidRootPart"
    hrp.Anchored = true
    hrp.Size = Vector3.new(2,2,1)
    hrp.CFrame = CFrame.new(0,1000,0)
end

local function blockKickOnEvents()
    local kickConnections = {}
    if getconnections then
        kickConnections = getconnections(p.Kick) or {}
    end
    for i=1,#kickConnections do
        pcall(function() kickConnections[i]:Disable() end)
    end
end

local function overrideMetatableWithProxy()
    local proxyTbl = {}
    local proxyMT = {
        __index = function(t,k)
            if k == "Kick" then return function() end end
            return oldIndex(p,k)
        end,
        __newindex = function(t,k,v)
            if k == "Kick" then return end
            return oldNewIndex(p,k,v)
        end,
        __namecall = newcclosure(function(self,...)
            if self == p and getnamecallmethod() == "Kick" then
                return
            end
            return oldNamecall(self,...)
        end)
    }
    setmetatable(proxyTbl, proxyMT)
    _G.ProxyTbl = proxyTbl
end

local function spoofNamecallHook()
    if hookmetamethod then
        local oldHook = hookmetamethod
        hookmetamethod = function(self,mtName,...)
            if mtName == "Kick" then
                return
            end
            return oldHook(self,mtName,...)
        end
    end
end

local function replaceKickWithNoop()
    p.Kick = function() end
end

local function blockKickWithLoop()
    task.spawn(function()
        while true do
            p.Kick = function() end
            task.wait(0.2)
        end
    end)
end


useProxyPlayer()
spoofConnections()
overrideKickSignal()
swapMetatable()
blockKickEvent()
blockDestroy()
hookRawMetatable()
overwriteKickWithError()
lockPosition()
blockDestroyAndBreak()
infiniteDummyKick()
fakeCharacterSpawn()
blockKickOnEvents()
overrideMetatableWithProxy()
spoofNamecallHook()
replaceKickWithNoop()
blockKickWithLoop()
