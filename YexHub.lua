-- YexScript_Final_KRNL.lua
-- Final KRNL-ready script with Prehistoric pressure bar and logic (client-side fallbacks)
-- Paste into KRNL and execute.

-- ===== Environment =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getHumRoot() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end

getgenv().Yex = getgenv().Yex or {}
local Yex = getgenv().Yex

-- defaults
Yex.FarmOn = Yex.FarmOn or false
Yex.PreOn = Yex.PreOn or false
Yex.ESP = Yex.ESP or {fruit=false,flower=false,chest=false,player=false}
Yex.TweenSpeed = Yex.TweenSpeed or 80
Yex.BringDistance = Yex.BringDistance or 50
Yex.FarmDistance = Yex.FarmDistance or 35
Yex.WalkSpeed = Yex.WalkSpeed or 16
Yex.FarmYOffset = Yex.FarmYOffset or 5
Yex.AttackDelay = Yex.AttackDelay or 0.03
Yex.ToggleKey = Yex.ToggleKey or "Y"
Yex.GuiVisible = true

-- Prehistoric name keywords (edit to match server)
local PREHISTORIC_KEYWORDS = {"lava","prehistoric","dino","raptor","ancient","bronto","t-rex","trex","saurus","beast","lava_golem","golem"}
local RELIC_KEYWORDS = {"relic","skeleton","skeletonhead","bighead","relic_base","relic_head"}

-- utility
local function create(parent, class, props)
    local o = Instance.new(class)
    if props then for k,v in pairs(props) do pcall(function() o[k]=v end) end end
    o.Parent = parent
    return o
end
local function makeFrame(parent,size,pos,bg,trans)
    local f = create(parent,"Frame",{Size=size,Position=pos,BackgroundColor3=bg,BackgroundTransparency=trans or 0,BorderSizePixel=0})
    create(f,"UICorner",{CornerRadius=UDim.new(0,8)})
    return f
end

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YexScript_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") -- KRNL allows this

local mainFrame = makeFrame(screenGui,UDim2.new(0,480,0,360),UDim2.new(0.08,0,0.12,0),Color3.fromRGB(40,40,40),0.32)
mainFrame.Active = true mainFrame.Draggable = true mainFrame.ClipsDescendants = true

local topBar = makeFrame(mainFrame,UDim2.new(1,0,0,40),UDim2.new(0,0,0,0),Color3.fromRGB(20,20,20),0.28)
local title = create(topBar,"TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="YexScript",TextColor3=Color3.new(1,1,1),TextScaled=true,Font=Enum.Font.GothamBlack})

-- tabbar
local tabBar = create(mainFrame,"Frame",{Size=UDim2.new(1,0,0,34),Position=UDim2.new(0,0,0,44),BackgroundTransparency=1})
local function makeTabBtn(name,x) 
    return create(tabBar,"TextButton",{Size=UDim2.new(0,64,1,0),Position=UDim2.new(0,(x-1)*64,0,0),Text=name,Font=Enum.Font.GothamSemibold,TextScaled=true,BackgroundColor3=Color3.fromRGB(70,70,70),BackgroundTransparency=0.4,TextColor3=Color3.new(1,1,1),BorderSizePixel=0})
end

local content = makeFrame(mainFrame,UDim2.new(1,-12,1,-104),UDim2.new(0,6,0,84),Color3.fromRGB(28,28,28),0.45)
content.ClipsDescendants = true

local ordered = {"Main","ESP","Teleport","Raid","Prehistoric","Misc","Settings"}
local pages = {}
for i,name in ipairs(ordered) do
    pages[name] = create(content,"Frame",{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,Visible=(i==1)})
end
local tabButtons = {}
for i,name in ipairs(ordered) do
    local btn = makeTabBtn(name,i)
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        for k,v in pairs(pages) do v.Visible=false end
        pages[name].Visible = true
        for _,tb in pairs(tabButtons) do tb.BackgroundColor3=Color3.fromRGB(70,70,70) end
        btn.BackgroundColor3 = Color3.fromRGB(105,105,105)
    end)
end
tabButtons["Main"].BackgroundColor3 = Color3.fromRGB(105,105,105)

-- left small ⚡ toggle
local toggleBtn = makeFrame(screenGui,UDim2.new(0,46,0,46),UDim2.new(0,0.02,0,0.42),Color3.fromRGB(25,25,25),0.25)
toggleBtn.Active = true toggleBtn.Draggable = true
local lightning = create(toggleBtn,"TextLabel",{Size=UDim2.new(1,1,1,1),BackgroundTransparency=1,Text="⚡",Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.new(1,1,1)})
local function setHubVisible(v) Yex.GuiVisible=v mainFrame.Visible=v if v then toggleBtn.BackgroundColor3=Color3.fromRGB(25,25,25) else toggleBtn.BackgroundColor3=Color3.fromRGB(80,80,80) end end
toggleBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then setHubVisible(not Yex.GuiVisible) end end)
setHubVisible(true)

-- small UI builders
local function makeLabel(parent,txt,pos) return create(parent,"TextLabel",{Size=UDim2.new(0.62,0,0,24),Position=pos,BackgroundTransparency=1,Text=txt,TextColor3=Color3.new(1,1,1),Font=Enum.Font.Gotham,TextScaled=true}) end
local function makeSwitch(parent,pos,init)
    local frame = create(parent,"Frame",{Size=UDim2.new(0,46,0,22),Position=pos,BackgroundColor3=(init and Color3.fromRGB(0,200,80) or Color3.fromRGB(0,0,0)),BackgroundTransparency=(init and 0 or 0.25),BorderSizePixel=0})
    create(frame,"UICorner",{CornerRadius=UDim.new(0,12)})
    local knob = create(frame,"Frame",{Size=UDim2.new(0,18,0,18),Position=(init and UDim2.new(1,-20,0,2) or UDim2.new(0,2,0,2)),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0})
    create(knob,"UICorner",{CornerRadius=UDim.new(0,12)})
    local state = init or false
    local function set(s)
        state=s
        if s then frame.BackgroundColor3=Color3.fromRGB(0,200,80); frame.BackgroundTransparency=0; knob:TweenPosition(UDim2.new(1,-20,0,2),"Out","Quad",0.18,true)
        else frame.BackgroundColor3=Color3.fromRGB(0,0,0); frame.BackgroundTransparency=0.25; knob:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.18,true) end
    end
    frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then set(not state) end end)
    set(state)
    return {Frame=frame,Set=set,Get=function() return state end}
end
local function makeTextBox(parent,pos,default) return create(parent,"TextBox",{Size=UDim2.new(0,120,0,26),Position=pos,BackgroundTransparency=0.6,Text=default or "",ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextScaled=true,TextColor3=Color3.new(1,1,1)}) end
local function makeButton(parent,pos,text) return create(parent,"TextButton",{Size=UDim2.new(0,160,0,30),Position=pos,Text=text,Font=Enum.Font.GothamSemibold,TextScaled=true,BackgroundTransparency=0.6}) end

-- ===== PAGE CONTENTS =====
-- Main
do
    local p = pages["Main"]
    makeLabel(p,"Main Controls",UDim2.new(0,0,0,6))
    makeLabel(p,"Auto Farm Nearest NPC",UDim2.new(0,0,0,40))
    local farmSwitch = makeSwitch(p,UDim2.new(0.74,0,0,40),Yex.FarmOn)
    makeLabel(p,"Attack Delay (lower=faster)",UDim2.new(0,0,0,80))
    local attackBox = makeTextBox(p,UDim2.new(0.74,0,0,80),tostring(Yex.AttackDelay))
    makeLabel(p,"Auto Quest (if required)",UDim2.new(0,0,0,120))
    local questSwitch = makeSwitch(p,UDim2.new(0.74,0,0,120),false)

    farmSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.FarmOn=not Yex.FarmOn farmSwitch.Set(Yex.FarmOn) if Yex.FarmOn then startFarm() else stopFarm() end end end)
    attackBox.FocusLost:Connect(function() local n=tonumber(attackBox.Text) if n and n>0 then Yex.AttackDelay=n else attackBox.Text=tostring(Yex.AttackDelay) end end)
end

-- ESP
local espSwitches = {}
do
    local p = pages["ESP"]
    makeLabel(p,"ESP Controls",UDim2.new(0,0,0,6))
    makeLabel(p,"Fruit ESP",UDim2.new(0,0,0,36)); espSwitches.fruit = makeSwitch(p,UDim2.new(0.74,0,0,36),Yex.ESP.fruit)
    makeLabel(p,"Flower ESP",UDim2.new(0,0,0,76)); espSwitches.flower = makeSwitch(p,UDim2.new(0.74,0,0,76),Yex.ESP.flower)
    makeLabel(p,"Chest ESP",UDim2.new(0,0,0,116)); espSwitches.chest = makeSwitch(p,UDim2.new(0.74,0,0,116),Yex.ESP.chest)
    makeLabel(p,"Player ESP",UDim2.new(0,0,0,156)); espSwitches.player = makeSwitch(p,UDim2.new(0.74,0,0,156),Yex.ESP.player)
    espSwitches.fruit.Frame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.fruit = not Yex.ESP.fruit end end)
    espSwitches.flower.Frame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.flower = not Yex.ESP.flower end end)
    espSwitches.chest.Frame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.chest = not Yex.ESP.chest end end)
    espSwitches.player.Frame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.player = not Yex.ESP.player end end)
end

-- Teleport
do
    local p = pages["Teleport"]
    makeLabel(p,"Teleport Tools",UDim2.new(0,0,0,6))
    local tpSpawn = makeButton(p,UDim2.new(0,0,0,40),"Teleport to Spawn")
    tpSpawn.MouseButton1Click:Connect(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("spawn")
        local hrp = getHumRoot()
        if spawn and spawn:IsA("BasePart") and hrp then hrp.CFrame = spawn.CFrame + Vector3.new(0,4,0) end
    end)
    local tpMouse = makeButton(p,UDim2.new(0,0,0,84),"Teleport to Mouse")
    tpMouse.MouseButton1Click:Connect(function() local m=LocalPlayer:GetMouse(); local hrp=getHumRoot(); if m and m.Hit and hrp then hrp.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,4,0)) end end)
    local coordBox = makeTextBox(p,UDim2.new(0,0,0,128),"x,y,z"); coordBox.Size = UDim2.new(0,260,0,26)
    local tpCoord = makeButton(p,UDim2.new(0,0,0,164),"Teleport to Coord")
    tpCoord.MouseButton1Click:Connect(function()
        local txt=coordBox.Text; local x,y,z = string.match(txt,"([^,]+),([^,]+),([^,]+)")
        if x and y and z then local vx,vy,vz = tonumber(x:match("%S+")),tonumber(y:match("%S+")),tonumber(z:match("%S+")); if vx and vy and vz and getHumRoot() then getHumRoot().CFrame = CFrame.new(vx,vy,vz) end end
    end)
end

-- Raid (UI with placeholder fruits and auto-buy logic for low-value)
do
    local p = pages["Raid"]
    makeLabel(p,"Raid Utilities",UDim2.new(0,0,0,6))
    local fruitList = {"Flame","Ice","Light","Dark","Rumble","Magma","Buddha","String","Phoenix","Dough","Control","Revive"} -- placeholder
    local y = 44
    for _,name in ipairs(fruitList) do
        local btn = makeButton(p,UDim2.new(0,0,0,y),name)
        btn.MouseButton1Click:Connect(function()
            -- attempt to find low-value fruit in inventory
            local used = false
            local char = getChar()
            for _,v in ipairs(char:GetChildren()) do
                if v:IsA("Tool") and v.Name and (string.find(string.lower(v.Name),"common") or string.find(string.lower(v.Name),"uncommon") or string.find(string.lower(v.Name),"low")) then
                    -- equip/use it: this is heuristic; many servers manage inventory differently
                    pcall(function() LocalPlayer.Character.Humanoid:EquipTool(v) end)
                    used = true
                    warn("[YexScript] Selected low-value fruit '"..tostring(v.Name).."' for chip purchase for "..name)
                    break
                end
            end
            if not used then warn("[YexScript] No low-value fruit found in your character. You may need to place one in your inventory to auto-swap.") end
            -- Placeholder: attempt to fire server remote for buy chip (server-specific)
            local found = workspace:FindFirstChild("RaidRemote") or game.ReplicatedStorage:FindFirstChild("RaidRemote") or nil
            if found and found.FireServer then
                pcall(function() found:FireServer(name) end)
                warn("[YexScript] Fired RaidRemote for "..name.." (placeholder remote used)")
            else
                warn("[YexScript] No Raid remote found. Replace 'RaidRemote' with game's remote name to automate starting raids/server buy chip.")
            end
        end)
        y = y + 38
    end
end

-- Prehistoric (pressure bar + logic)
do
    local p = pages["Prehistoric"]
    makeLabel(p,"Prehistoric System",UDim2.new(0,0,0,6))
    makeLabel(p,"Auto Farm Prehistoric NPCs",UDim2.new(0,0,0,40))
    local preSwitch = makeSwitch(p,UDim2.new(0.72,0,0,40),Yex.PreOn)
    makeLabel(p,"Auto Collect Drops",UDim2.new(0,0,0,80))
    local collectSwitch = makeSwitch(p,UDim2.new(0.72,0,0,80),true)

    -- Pressure UI: label + progress bar
    local pressureLabel = create(p,"TextLabel",{Size=UDim2.new(0.6,0,0,24),Position=UDim2.new(0,0,0,120),BackgroundTransparency=1,Text="Pressure: 0%",TextColor3=Color3.new(1,1,1),Font=Enum.Font.Gotham,TextScaled=true})
    local barBg = makeFrame(p,UDim2.new(0.6,0,0,18),UDim2.new(0,0,0,150),Color3.fromRGB(60,60,60),0.3)
    local barFill = makeFrame(barBg,UDim2.new(0,0,1,0),UDim2.new(0,0,0,0),Color3.fromRGB(60,130,255),0)
    barFill.Size = UDim2.new(0,0,1,0) -- start at 0

    -- local pressure value
    local pressure = 0
    local pressureRate = 0.4 -- percent per second increase
    local pressureDecreaseByLava = 1.2 -- percent per second if lava present (reduces)
    local function updatePressureUI()
        pressure = math.clamp(pressure,0,100)
        pressureLabel.Text = "Pressure: "..math.floor(pressure).."%"
        local pct = pressure/100
        barFill:TweenSize(UDim2.new(pct,0,1,0),"Out","Quad",0.15,true)
    end

    -- detect volcano/lava parts to decrease pressure
    local function lavaPresent()
        -- Example detection: part or model called "Volcano" or "Lava" or with "volcano" in parent name
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local n = string.lower(v.Name)
                local pn = v.Parent and tostring(v.Parent.Name):lower() or ""
                if string.find(n,"lava") or string.find(n,"volcano") or string.find(pn,"volcano") then
                    return true
                end
            end
        end
        return false
    end

    -- helper: find Relic (big skeleton head) in workspace
    local function findRelic()
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local name = string.lower(v.Name)
                for _,kw in ipairs(RELIC_KEYWORDS) do
                    if string.find(name,kw) then
                        if v:IsA("Model") then
                            if v:FindFirstChildWhichIsA("BasePart") then return v end
                        else
                            return v
                        end
                    end
                end
            end
        end
        return nil
    end

    -- helper: find LavaGolem if exists (server-spawned)
    local function findLavaGolem()
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") then
                local nm = string.lower(m.Name)
                for _,kw in ipairs(PREHISTORIC_KEYWORDS) do
                    if string.find(nm,kw) then
                        -- extra check for humanoid presence
                        if m:FindFirstChild("Humanoid") or m:FindFirstChildWhichIsA("Humanoid") then
                            return m
                        end
                    end
                end
            end
        end
        return nil
    end

    -- local dummy lava golem creation (client-only) if no remote to spawn server-side one
    local function spawnLocalGolem()
        -- build a simple model with Humanoid so client tools can interact (local only)
        local model = Instance.new("Model")
        model.Name = "LavaGolem_Local"
        local root = Instance.new("Part")
        root.Name = "HumanoidRootPart"
        root.Size = Vector3.new(4,6,4)
        root.Position = (getHumRoot() and getHumRoot().Position or Vector3.new(0,50,0)) + Vector3.new(0,0,12)
        root.Anchored = false
        root.Parent = model
        local hum = Instance.new("Humanoid")
        hum.Parent = model
        model.PrimaryPart = root
        model.Parent = workspace
        -- simple auto removal after some time if not killed
        delay(90,function() if model and model.Parent then model:Destroy() end end)
        return model
    end

    -- Prehistoric farm loop
    local preThread = nil
    local function startPre()
        if preThread and coroutine.status(preThread)~="dead" then return end
        preThread = coroutine.create(function()
            while Yex.PreOn do
                -- update pressure: increases unless lavaPresent lowers it
                local hasLava = lavaPresent()
                if hasLava then
                    pressure = pressure - (pressureDecreaseByLava * (0.5 + math.random()*0.8))
                else
                    pressure = pressure + (pressureRate * (0.8 + math.random()*0.8))
                end
                updatePressureUI()

                -- if pressure >= 100 => attempt spawn lava golem
                if pressure >= 100 then
                    pressure = 100
                    updatePressureUI()
                    warn("[YexScript] Pressure reached 100% - attempting to spawn Lava Golem.")
                    -- try to fire server remote named 'SpawnLavaGolem' or similar
                    local success = false
                    local tryNames = {"SpawnLavaGolem","SpawnGolem","VolcanoSpawn","TriggerLavaGolem"}
                    for _,nm in ipairs(tryNames) do
                        local remote = game.ReplicatedStorage:FindFirstChild(nm) or workspace:FindFirstChild(nm) or game:GetService("ReplicatedStorage"):FindFirstChild(nm)
                        if remote and remote.FireServer then
                            pcall(function() remote:FireServer() end)
                            warn("[YexScript] Fired remote '"..nm.."' to spawn Lava Golem.")
                            success = true
                            break
                        end
                    end
                    if not success then
                        -- fallback: create local dummy golem
                        local lg = spawnLocalGolem()
                        warn("[YexScript] No server remote found to spawn a Lava Golem — created local dummy '"..tostring(lg.Name).."'.")
                    end
                    -- after spawn attempt, pressure decreases to avoid immediate re-spawn
                    pressure = 40
                    updatePressureUI()
                end

                -- try to find any lava golem to attack
                local golem = findLavaGolem()
                if golem then
                    -- protect relic: move near relic part if found
                    local relicModel = findRelic()
                    if relicModel then
                        local rpart = relicModel:IsA("Model") and (relicModel:FindFirstChildWhichIsA("BasePart") or relicModel.PrimaryPart) or (relicModel:IsA("BasePart") and relicModel)
                        if rpart and getHumRoot() then
                            -- move near relic within safe distance
                            local protectPos = rpart.Position + Vector3.new(0,4,4)
                            pcall(function() tweenToPosition(protectPos, Yex.TweenSpeed or 80) end)
                        end
                    end

                    -- attack the golem: move to its HumanoidRootPart and use tool
                    local hrpG = golem:FindFirstChild("HumanoidRootPart") or golem:FindFirstChildWhichIsA("BasePart")
                    if hrpG and getHumRoot() then
                        local targetPos = hrpG.Position + Vector3.new(0, Yex.FarmYOffset or 6, 0)
                        pcall(function() tweenToPosition(targetPos, Yex.TweenSpeed or 80) end)
                        -- attack loop until its humanoid is dead or toggle off
                        for i=1,60 do
                            if not Yex.PreOn then break end
                            if golem:FindFirstChild("Humanoid") and golem.Humanoid.Health > 0 then
                                useToolFast(Yex.AttackDelay or 0.03)
                            else break end
                            task.wait(0.06)
                        end
                    end
                end

                -- collect drops near relic or workspace if collectSwitch ON
                if collectSwitch and collectSwitch.Get and collectSwitch.Get() then
                    for _,obj in pairs(workspace:GetDescendants()) do
                        if (obj:IsA("Tool") or obj:IsA("BasePart")) and obj.Name and (string.find(string.lower(obj.Name),"relic") or string.find(string.lower(obj.Name),"drop")) then
                            -- attempt to move and pick up
                            if getHumRoot() and obj:IsA("BasePart") then
                                pcall(function() getHumRoot().CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0)) end)
                                task.wait(0.25)
                            end
                        end
                    end
                end

                task.wait(0.25)
            end
        end)
        coroutine.resume(preThread)
    end

    local function stopPre() Yex.PreOn = false end

    -- connect UI toggle
    preSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.PreOn = not Yex.PreOn preSwitch.Set(Yex.PreOn) if Yex.PreOn then startPre() else stopPre() end end end)
end

-- Misc page
local misc = {}
do
    local p = pages["Misc"]
    makeLabel(p,"Miscellaneous",UDim2.new(0,0,0,6))
    makeLabel(p,"Bring Mob Distance (0-300)",UDim2.new(0,0,0,40))
    local bringBox = makeTextBox(p,UDim2.new(0.72,0,0,40),tostring(Yex.BringDistance))
    makeLabel(p,"Tween Speed (0-300)",UDim2.new(0,0,0,80))
    local tweenBox = makeTextBox(p,UDim2.new(0.72,0,0,80),tostring(Yex.TweenSpeed))
    makeLabel(p,"Farm Distance (0-35)",UDim2.new(0,0,0,120))
    local farmDistBox = makeTextBox(p,UDim2.new(0.72,0,0,120),tostring(Yex.FarmDistance))
    makeLabel(p,"WalkSpeed",UDim2.new(0,0,0,160))
    local wsBox = makeTextBox(p,UDim2.new(0.72,0,0,160),tostring(Yex.WalkSpeed))
    bringBox.FocusLost:Connect(function() local n=tonumber(bringBox.Text); if n then Yex.BringDistance=n else bringBox.Text=tostring(Yex.BringDistance) end end)
    tweenBox.FocusLost:Connect(function() local n=tonumber(tweenBox.Text); if n then Yex.TweenSpeed=n else tweenBox.Text=tostring(Yex.TweenSpeed) end end)
    farmDistBox.FocusLost:Connect(function() local n=tonumber(farmDistBox.Text); if n then Yex.FarmDistance=n else farmDistBox.Text=tostring(Yex.FarmDistance) end end)
    wsBox.FocusLost:Connect(function() local n=tonumber(wsBox.Text); if n then Yex.WalkSpeed=n else wsBox.Text=tostring(Yex.WalkSpeed) end end)
end

-- Settings page
do
    local p = pages["Settings"]
    makeLabel(p,"Settings",UDim2.new(0,0,0,6))
    makeLabel(p,"Farm Position Y offset",UDim2.new(0,0,0,40))
    local farmPosBox = makeTextBox(p,UDim2.new(0.72,0,0,40),tostring(Yex.FarmYOffset))
    farmPosBox.FocusLost:Connect(function() local n=tonumber(farmPosBox.Text); if n then Yex.FarmYOffset=n else farmPosBox.Text=tostring(Yex.FarmYOffset) end end)
    makeLabel(p,"Toggle GUI Key",UDim2.new(0,0,0,80))
    local keyBox = makeTextBox(p,UDim2.new(0.72,0,0,80),Yex.ToggleKey)
    keyBox.FocusLost:Connect(function() if keyBox.Text and #keyBox.Text>0 then Yex.ToggleKey=tostring(keyBox.Text):upper() else keyBox.Text=Yex.ToggleKey end end)
    makeLabel(p,"Attack Delay (default)",UDim2.new(0,0,0,120))
    local attackDefaultBox = makeTextBox(p,UDim2.new(0.72,0,0,120),tostring(Yex.AttackDelay))
    attackDefaultBox.FocusLost:Connect(function() local n=tonumber(attackDefaultBox.Text); if n then Yex.AttackDelay=n else attackDefaultBox.Text=tostring(Yex.AttackDelay) end end)
    local saveBtn = makeButton(p,UDim2.new(0,0,0,160),"Save Session")
    local resetBtn = makeButton(p,UDim2.new(0.5,0,0,160),"Reset Toggles")
    saveBtn.MouseButton1Click:Connect(function() getgenv().Yex = Yex; warn("[YexScript] Session saved to getgenv().Yex") end)
    resetBtn.MouseButton1Click:Connect(function()
        getgenv().Yex = {FarmOn=false,PreOn=false,ESP={fruit=false,flower=false,chest=false,player=false},TweenSpeed=80,BringDistance=50,FarmDistance=35,WalkSpeed=16,FarmYOffset=5,AttackDelay=0.03,ToggleKey="Y",GuiVisible=true}
        Yex = getgenv().Yex
        warn("[YexScript] Settings reset. Reopen GUI to reflect.")
    end)
end

-- ======= Billboards/ESP helpers =======
local activeBillboards = {}
local function makeBillboard(part,text)
    if not part or not part:IsA("BasePart") then return end
    local id = tostring(part:GetDebugId())
    if activeBillboards[id] then return end
    local bg = Instance.new("BillboardGui", part)
    bg.Adornee = part; bg.Size = UDim2.new(0,140,0,28); bg.AlwaysOnTop=true; bg.StudsOffset = Vector3.new(0,2,0)
    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency=1; label.Text=text or part.Name; label.TextScaled=true; label.Font=Enum.Font.GothamSemibold; label.TextColor3=Color3.new(1,1,1)
    activeBillboards[id] = bg
end
local function clearBillboardsIf(fn)
    for id,bg in pairs(activeBillboards) do
        if not bg or not bg.Parent then activeBillboards[id]=nil else
            if fn and fn(bg) then pcall(function() bg:Destroy() end); activeBillboards[id]=nil end
        end
    end
end

-- ======= Generic helpers used above (defined here to avoid forward errors) =======
function tweenToPosition(pos,speed)
    local hrp = getHumRoot()
    if not hrp then return end
    local dist = (hrp.Position - pos).Magnitude
    if dist < 2 then hrp.CFrame = CFrame.new(pos); return end
    local t = math.clamp(dist / math.max(1,speed), 0.03, 4)
    local ok,err = pcall(function()
        local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
        tw:Play()
        tw.Completed:Wait()
    end)
    if not ok then hrp.CFrame = CFrame.new(pos) end
end

function useToolFast(delay)
    delay = tonumber(delay) or Yex.AttackDelay or 0.03
    local c = getChar()
    local tool = c and c:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
        task.wait(delay)
        pcall(function() tool:Activate() end)
    end
end

-- find nearest enemy generic
function findNearestEnemy(maxDist)
    maxDist = maxDist or 9999
    local hr = getHumRoot()
    if not hr then return nil end
    local nearest, nd = nil, maxDist
    if workspace:FindFirstChild("Enemies") then
        for _,m in pairs(workspace.Enemies:GetChildren()) do
            if m and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 then
                local d = (m.HumanoidRootPart.Position - hr.Position).Magnitude
                if d < nd then nd = d; nearest = m end
            end
        end
    end
    if not nearest then
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health>0 then
                local d = (m.HumanoidRootPart.Position - hr.Position).Magnitude
                if d < nd then nd = d; nearest = m end
            end
        end
    end
    return nearest
end

-- ======= AutoFarm core (used by Main tab) =======
local farmThread = nil
function startFarm()
    if farmThread and coroutine.status(farmThread)~="dead" then return end
    farmThread = coroutine.create(function()
        while Yex.FarmOn do
            local target = findNearestEnemy(Yex.FarmDistance or 9999)
            if target and target:FindFirstChild("HumanoidRootPart") then
                local hrp = target.HumanoidRootPart
                local pos = hrp.Position + Vector3.new(0, (Yex.FarmYOffset or 5), 0)
                if tonumber(Yex.TweenSpeed) and tonumber(Yex.TweenSpeed) > 0 then tweenToPosition(pos, Yex.TweenSpeed) else if getHumRoot() then getHumRoot().CFrame = CFrame.new(pos) end end
                if target:FindFirstChild("Humanoid") and target.Humanoid.Health>0 then
                    useToolFast(Yex.AttackDelay)
                end
            end
            task.wait(0.06)
        end
    end)
    coroutine.resume(farmThread)
end
function stopFarm() Yex.FarmOn=false end

-- ======= Pre-start housekeeping: ESP update & WalkSpeed apply =======
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- walk speed
        local c = getChar()
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = Yex.WalkSpeed or 16 end
    end)
    -- ESP update simplified
    pcall(function()
        if Yex.ESP.fruit then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(string.lower(v.Name),"fruit") then makeBillboard(v.Handle,v.Name) end
            end
        else
            clearBillboardsIf(function(bg) local par=bg.Adornee; return par and par.Parent and par.Parent:IsA("Tool") and string.find(string.lower(par.Parent.Name or par.Name or ""),"fruit") end)
        end
        if Yex.ESP.flower then
            for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and string.find(string.lower(v.Name),"flower") then makeBillboard(v,v.Name) end end
        else clearBillboardsIf(function(bg) return string.find(string.lower(tostring(bg.Adornee.Name or "")),"flower") end) end
        if Yex.ESP.chest then
            for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and string.find(string.lower(v.Name),"chest") then makeBillboard(v,v.Name) end end
        else clearBillboardsIf(function(bg) return string.find(string.lower(tostring(bg.Adornee.Name or "")),"chest") end) end
        if Yex.ESP.player then
            for _,plr in pairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then makeBillboard(plr.Character.HumanoidRootPart,plr.Name) end end
        else clearBillboardsIf(function(bg) return Players:FindFirstChild(bg.Adornee.Parent.Name) end) end
    end)
end)

-- Keybind to toggle GUI
UserInputService.InputBegan:Connect(function(inp,gpe) if gpe then return end if inp.UserInputType==Enum.UserInputType.Keyboard then local keyname = tostring(inp.KeyCode):gsub("Enum.KeyCode.","") if keyname==tostring(Yex.ToggleKey or "Y") then setHubVisible(not Yex.GuiVisible) end end end)

-- Apply initial UI states quickly
-- (Set main first switch visual)
do
    for _,f in pairs(pages["Main"]:GetChildren()) do
        if f:IsA("Frame") and f.Size and f.Size.X and f.Size.X.Offset==46 then
            local init = Yex.FarmOn
            f.BackgroundColor3 = init and Color3.fromRGB(0,200,80) or Color3.fromRGB(0,0,0)
            local knob = f:FindFirstChildWhichIsA("Frame")
            if knob then knob.Position = init and UDim2.new(1,-20,0,2) or UDim2.new(0,2,0,2) end
            break
        end
    end
end

-- Start loops if toggles were already ON
if Yex.FarmOn then startFarm() end
if Yex.PreOn then
    -- find prehistoric start function by simulating toggle
    for _,child in pairs(pages["Prehistoric"]:GetChildren()) do
        if child:IsA("Frame") and child.Size and child.Size.X and child.Size.X.Offset==46 then
            -- set visually and start
            child.BackgroundColor3 = Color3.fromRGB(0,200,80)
            local knob = child:FindFirstChildWhichIsA("Frame")
            if knob then knob.Position = UDim2.new(1,-20,0,2) end
            -- call start: find the preSwitch's toggle function by triggering a small event
            -- We'll start Pre process directly:
            Yex.PreOn = true
            -- startPre is declared inside Prehistoric section; call by name if available
            -- use pcall to find by scanning for function 'startPre' in environment:
            pcall(function() if startPre then startPre() end end)
            break
        end
    end
end

warn("[YexScript] Loaded (KRNL). Tabs: Main, ESP, Teleport, Raid, Prehistoric, Misc, Settings. Prehistoric has Pressure bar UI and basic auto logic.")
