YexScript.lua (KRNL-ready final)
-- Paste whole file into KRNL and run.

-- ======= Environment & Helpers =======
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getHumRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- session settings (persisted in executor session)
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

-- Prehistoric NPC name patterns (edit to match your server)
local PREHISTORIC_KEYWORDS = {
    "prehistoric",
    "dino",
    "raptor",
    "ancient",
    "bronto",
    "t-rex",
    "trex",
    "saurus",
    "beast"
}

-- safe print wrapper
local function sWarn(msg) pcall(function() warn("[YexScript] "..tostring(msg)) end) end

-- ======= UI Helpers =======
local function create(parent, class, props)
    local o = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            pcall(function() o[k] = v end)
        end
    end
    o.Parent = parent
    return o
end

local function makeRoundedFrame(parent, size, pos, bg, trans, corner)
    local f = create(parent, "Frame", {Size=size, Position=pos, BackgroundColor3=bg, BackgroundTransparency=trans or 0, BorderSizePixel=0})
    local u = create(f, "UICorner", {CornerRadius = corner or UDim.new(0,8)})
    return f
end

-- ======= Build GUI =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YexScript_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main frame
local mainFrame = makeRoundedFrame(screenGui, UDim2.new(0,460,0,340), UDim2.new(0.08,0,0.12,0), Color3.fromRGB(40,40,40), 0.32)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- Top bar and title
local topBar = makeRoundedFrame(mainFrame, UDim2.new(1,0,0,40), UDim2.new(0,0,0,0), Color3.fromRGB(20,20,20), 0.28, UDim.new(0,10))
local title = create(topBar, "TextLabel", {
    Size = UDim2.new(1,-20,1,0),
    Position = UDim2.new(0,10,0,0),
    BackgroundTransparency = 1,
    Text = "YexScript",
    TextColor3 = Color3.new(1,1,1),
    TextScaled = true,
    Font = Enum.Font.GothamBlack
})

-- Tab bar (left-to-right exact order)
local tabBar = create(mainFrame, "Frame", {Size=UDim2.new(1,0,0,34), Position=UDim2.new(0,0,0,44), BackgroundTransparency=1})
local function makeTabBtn(name, x)
    local b = create(tabBar, "TextButton", {
        Size = UDim2.new(0,64,1,0),
        Position = UDim2.new(0, (x-1)*64, 0, 0),
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(70,70,70),
        BackgroundTransparency = 0.4,
        TextColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0
    })
    return b
end

-- Create pages container
local content = makeRoundedFrame(mainFrame, UDim2.new(1,-12,1,-104), UDim2.new(0,6,0,84), Color3.fromRGB(28,28,28), 0.45)
content.ClipsDescendants = true

-- Tabs ordered exactly
local ordered = {"Main","ESP","Teleport","Raid","Prehistoric","Misc","Settings"}
local pages = {}
for i,name in ipairs(ordered) do
    local p = create(content, "Frame", {Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundTransparency = 1, Visible = (i==1)})
    pages[name] = p
end

-- Add tab buttons and switching
local tabButtons = {}
for i,name in ipairs(ordered) do
    local btn = makeTabBtn(name, i)
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        for k,v in pairs(pages) do v.Visible = false end
        pages[name].Visible = true
        for _,tb in pairs(tabButtons) do tb.BackgroundColor3 = Color3.fromRGB(70,70,70) end
        btn.BackgroundColor3 = Color3.fromRGB(105,105,105)
    end)
end
-- set initial active look
tabButtons["Main"].BackgroundColor3 = Color3.fromRGB(105,105,105)

-- ======= Small left ⚡ toggle (draggable) =======
local toggleBtn = makeRoundedFrame(screenGui, UDim2.new(0,46,0,46), UDim2.new(0,0.02,0,0.42), Color3.fromRGB(25,25,25), 0.25, UDim.new(0,12))
toggleBtn.Active = true
toggleBtn.Draggable = true
local lightning = create(toggleBtn, "TextLabel", {
    Size = UDim2.new(1,1,1,1),
    BackgroundTransparency = 1,
    Text = "⚡", Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = Color3.new(1,1,1)
})
local function setHubVisible(v)
    Yex.GuiVisible = v
    mainFrame.Visible = v
    if v then toggleBtn.BackgroundColor3 = Color3.fromRGB(25,25,25) else toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80) end
end
toggleBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then setHubVisible(not Yex.GuiVisible) end end)
setHubVisible(true)

-- ======= Small UI widgets builder: label, switch, textbox, button =======
local function makeLabel(parent, txt, pos)
    return create(parent, "TextLabel", {
        Size = UDim2.new(0.6,0,0,24),
        Position = pos,
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.Gotham,
        TextScaled = true
    })
end

local function makeSwitch(parent, pos, initial)
    initial = initial or false
    local frame = create(parent, "Frame", {Size=UDim2.new(0,46,0,22), Position=pos, BackgroundColor3 = initial and Color3.fromRGB(0,200,80) or Color3.fromRGB(0,0,0), BackgroundTransparency = initial and 0 or 0.25, BorderSizePixel=0})
    create(frame, "UICorner", {CornerRadius=UDim.new(0,12)})
    local knob = create(frame, "Frame", {Size=UDim2.new(0,18,0,18), Position = UDim2.new(initial and 1 or 0, initial and -20 or 2, 0, 2), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel=0})
    create(knob, "UICorner", {CornerRadius=UDim.new(0,12)})
    local state = initial
    local function set(s)
        state = s
        if s then
            frame.BackgroundColor3 = Color3.fromRGB(0,200,80)
            frame.BackgroundTransparency = 0
            knob:TweenPosition(UDim2.new(1,-20,0,2),"Out","Quad",0.18,true)
        else
            frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            frame.BackgroundTransparency = 0.25
            knob:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.18,true)
        end
    end
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then set(not state) end
    end)
    set(initial)
    return {Frame=frame, Set=set, Get=function() return state end}
end

local function makeTextBox(parent, pos, default)
    local tb = create(parent, "TextBox", {Size=UDim2.new(0,120,0,26), Position=pos, BackgroundTransparency=0.6, Text=default or "", ClearTextOnFocus=false, Font=Enum.Font.Gotham, TextScaled=true, TextColor3=Color3.new(1,1,1)})
    return tb
end

local function makeButton(parent, pos, text)
    local b = create(parent, "TextButton", {Size=UDim2.new(0,160,0,30), Position=pos, Text=text, Font=Enum.Font.GothamSemibold, TextScaled=true, BackgroundTransparency=0.6})
    return b
end

-- ======= MAIN PAGE content =======
do
    local p = pages["Main"]
    makeLabel(p, "Main Controls", UDim2.new(0,0,0,6))

    makeLabel(p, "Auto Farm Nearest NPC", UDim2.new(0,0,0,40))
    local farmSwitch = makeSwitch(p, UDim2.new(0.72,0,0,40), Yex.FarmOn)

    makeLabel(p, "Attack Delay (lower=faster)", UDim2.new(0,0,0,80))
    local attackBox = makeTextBox(p, UDim2.new(0.72,0,0,80), tostring(Yex.AttackDelay))

    makeLabel(p, "Auto Quest (if needed)", UDim2.new(0,0,0,120))
    local questSwitch = makeSwitch(p, UDim2.new(0.72,0,0,120), false)

    -- connect switches
    farmSwitch.Frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            local v = not Yex.FarmOn
            Yex.FarmOn = v
            farmSwitch.Set(v)
            if v then
                startFarm() -- defined later; safe call via forward declaration
            else
                stopFarm()
            end
        end
    end)
    attackBox.FocusLost:Connect(function()
        local n = tonumber(attackBox.Text)
        if n and n>0 then Yex.AttackDelay = n else attackBox.Text = tostring(Yex.AttackDelay) end
    end)
end

-- ======= ESP PAGE content =======
do
    local p = pages["ESP"]
    makeLabel(p, "ESP Controls", UDim2.new(0,0,0,6))

    makeLabel(p, "Fruit ESP", UDim2.new(0,0,0,36))
    local fruitSwitch = makeSwitch(p, UDim2.new(0.72,0,0,36), Yex.ESP.fruit)
    makeLabel(p, "Flower ESP", UDim2.new(0,0,0,76))
    local flowerSwitch = makeSwitch(p, UDim2.new(0.72,0,0,76), Yex.ESP.flower)
    makeLabel(p, "Chest ESP", UDim2.new(0,0,0,116))
    local chestSwitch = makeSwitch(p, UDim2.new(0.72,0,0,116), Yex.ESP.chest)
    makeLabel(p, "Player ESP", UDim2.new(0,0,0,156))
    local playerSwitch = makeSwitch(p, UDim2.new(0.72,0,0,156), Yex.ESP.player)

    -- store to global state when toggled
    fruitSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.fruit = not Yex.ESP.fruit end end)
    flowerSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.flower = not Yex.ESP.flower end end)
    chestSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.chest = not Yex.ESP.chest end end)
    playerSwitch.Frame.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then Yex.ESP.player = not Yex.ESP.player end end)
end

-- ======= Teleport PAGE content =======
do
    local p = pages["Teleport"]
    makeLabel(p, "Teleport Tools", UDim2.new(0,0,0,6))

    local tpSpawn = makeButton(p, UDim2.new(0,0,0,40), "Teleport to Spawn")
    tpSpawn.MouseButton1Click:Connect(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("spawn")
        local hrp = getHumRoot()
        if spawn and spawn:IsA("BasePart") and hrp then hrp.CFrame = spawn.CFrame + Vector3.new(0,4,0) end
    end)

    local tpMouse = makeButton(p, UDim2.new(0,0,0,84), "Teleport to Mouse")
    tpMouse.MouseButton1Click:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local hrp = getHumRoot()
        if mouse and mouse.Hit and hrp then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,4,0)) end
    end)

    local coordBox = makeTextBox(p, UDim2.new(0,0,0,128), "x,y,z")
    coordBox.Size = UDim2.new(0,260,0,26)
    local tpCoord = makeButton(p, UDim2.new(0,0,0,164), "Teleport to Coord")
    tpCoord.MouseButton1Click:Connect(function()
        local txt = coordBox.Text
        local x,y,z = string.match(txt, "([^,]+),([^,]+),([^,]+)")
        if x and y and z then
            local vx,vy,vz = tonumber(x:match("%S+")), tonumber(y:match("%S+")), tonumber(z:match("%S+"))
            if vx and vy and vz then
                local hrp = getHumRoot()
                if hrp then hrp.CFrame = CFrame.new(vx,vy,vz) end
            end
        end
    end)
end

-- ======= Raid PAGE (UI + placeholders) =======
do
    local p = pages["Raid"]
    makeLabel(p, "Raid Utilities", UDim2.new(0,0,0,6))

    makeLabel(p, "Auto Raid (placeholder - game specific)", UDim2.new(0,0,0,40))
    local raidSwitch = makeSwitch(p, UDim2.new(0.72,0,0,40), false)

    makeLabel(p, "Auto Buy Chip (placeholder)", UDim2.new(0,0,0,80))
    local chipSwitch = makeSwitch(p, UDim2.new(0.72,0,0,80), false)

    -- placeholders: servers differ; these toggles are UI controls you can wire to remotes for your server
    raidSwitch.Frame.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            raidSwitch.Set(not raidSwitch.Get())
        end
    end)
end

-- ======= Prehistoric PAGE content (implemented) =======
do
    local p = pages["Prehistoric"]
    makeLabel(p, "Prehistoric Farming", UDim2.new(0,0,0,6))

    makeLabel(p, "Auto Farm Prehistoric NPCs", UDim2.new(0,0,0,40))
    local preSwitch = makeSwitch(p, UDim2.new(0.72,0,0,40), Yex.PreOn)

    makeLabel(p, "Auto Collect Drops", UDim2.new(0,0,0,80))
    local collectSwitch = makeSwitch(p, UDim2.new(0.72,0,0,80), true)

    -- A function to detect a model is prehistoric by name keywords
    local function isPrehistoricModel(m)
        if not m or not m.Name then return false end
        local name = string.lower(m.Name)
        for _,kw in ipairs(PREHISTORIC_KEYWORDS) do
            if string.find(name, kw) then return true end
        end
        -- also check descendants
        for _,d in pairs(m:GetDescendants()) do
            if d:IsA("BasePart") and d.Name and string.find(string.lower(d.Name), "dino") then return true end
        end
        return false
    end

    -- toggles handler
    preSwitch.Frame.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            Yex.PreOn = not Yex.PreOn
            preSwitch.Set(Yex.PreOn)
            if Yex.PreOn then
                startPrehistoricFarm()
            else
                stopPrehistoricFarm()
            end
        end
    end)

    collectSwitch.Frame.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            collectSwitch.Set(not collectSwitch.Get())
        end
    end)
end

-- ======= MISC PAGE content =======
local misc = {}
do
    local p = pages["Misc"]
    makeLabel(p, "Miscellaneous", UDim2.new(0,0,0,6))

    makeLabel(p, "Bring Mob Distance (0-300)", UDim2.new(0,0,0,40))
    local bringBox = makeTextBox(p, UDim2.new(0.72,0,0,40), tostring(Yex.BringDistance))

    makeLabel(p, "Tween Speed (0-300)", UDim2.new(0,0,0,80))
    local tweenBox = makeTextBox(p, UDim2.new(0.72,0,0,80), tostring(Yex.TweenSpeed))

    makeLabel(p, "Farm Distance (0-35)", UDim2.new(0,0,0,120))
    local farmDistBox = makeTextBox(p, UDim2.new(0.72,0,0,120), tostring(Yex.FarmDistance))

    makeLabel(p, "WalkSpeed", UDim2.new(0,0,0,160))
    local wsBox = makeTextBox(p, UDim2.new(0.72,0,0,160), tostring(Yex.WalkSpeed))

    -- update functions
    bringBox.FocusLost:Connect(function() local n=tonumber(bringBox.Text); if n then Yex.BringDistance=n else bringBox.Text=tostring(Yex.BringDistance) end end)
    tweenBox.FocusLost:Connect(function() local n=tonumber(tweenBox.Text); if n then Yex.TweenSpeed=n else tweenBox.Text=tostring(Yex.TweenSpeed) end end)
    farmDistBox.FocusLost:Connect(function() local n=tonumber(farmDistBox.Text); if n then Yex.FarmDistance=n else farmDistBox.Text=tostring(Yex.FarmDistance) end end)
    wsBox.FocusLost:Connect(function() local n=tonumber(wsBox.Text); if n then Yex.WalkSpeed=n else wsBox.Text=tostring(Yex.WalkSpeed) end end)
end

-- ======= SETTINGS PAGE content =======
do
    local p = pages["Settings"]
    makeLabel(p, "Settings", UDim2.new(0,0,0,6))

    makeLabel(p, "Farm Position Y offset", UDim2.new(0,0,0,40))
    local farmPosBox = makeTextBox(p, UDim2.new(0.72,0,0,40), tostring(Yex.FarmYOffset))
    farmPosBox.FocusLost:Connect(function() local n=tonumber(farmPosBox.Text); if n then Yex.FarmYOffset=n else farmPosBox.Text=tostring(Yex.FarmYOffset) end end)

    makeLabel(p, "Toggle GUI Key", UDim2.new(0,0,0,80))
    local keyBox = makeTextBox(p, UDim2.new(0.72,0,0,80), Yex.ToggleKey)
    keyBox.FocusLost:Connect(function() if keyBox.Text and #keyBox.Text>0 then Yex.ToggleKey = tostring(keyBox.Text):upper() else keyBox.Text = Yex.ToggleKey end end)

    makeLabel(p, "Attack Delay (default)", UDim2.new(0,0,0,120))
    local attackDefaultBox = makeTextBox(p, UDim2.new(0.72,0,0,120), tostring(Yex.AttackDelay))
    attackDefaultBox.FocusLost:Connect(function() local n=tonumber(attackDefaultBox.Text); if n then Yex.AttackDelay=n else attackDefaultBox.Text=tostring(Yex.AttackDelay) end end)

    -- Save/Reset buttons
    local saveBtn = makeButton(p, UDim2.new(0,0,0,160), "Save Session")
    local resetBtn = makeButton(p, UDim2.new(0.5,0,0,160), "Reset Toggles")
    saveBtn.MouseButton1Click:Connect(function()
        -- getgenv already stores Yex table; for KRNL session that's enough
        sWarn("Session saved to getgenv().Yex")
    end)
    resetBtn.MouseButton1Click:Connect(function()
        -- reset toggles to defaults
        Yex = {
            FarmOn=false, PreOn=false, ESP={fruit=false,flower=false,chest=false,player=false},
            TweenSpeed=80, BringDistance=50, FarmDistance=35, WalkSpeed=16,
            FarmYOffset=5, AttackDelay=0.03, ToggleKey="Y", GuiVisible=true
        }
        getgenv().Yex = Yex
        sWarn("Settings reset. Reopen UI to reflect.")
    end)
end

-- ======= Utility: billboard ESP manager =======
local activeBillboards = {}
local function makeBillboard(part, text)
    if not part or not part:IsA("BasePart") then return end
    local id = tostring(part:GetDebugId()) or tostring(part)
    if activeBillboards[id] and activeBillboards[id].Parent then return end
    local bg = Instance.new("BillboardGui")
    bg.Adornee = part
    bg.Size = UDim2.new(0,140,0,28)
    bg.AlwaysOnTop = true
    bg.StudsOffset = Vector3.new(0,2,0)
    bg.Parent = part

    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text or part.Name
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.new(1,1,1)
    activeBillboards[id] = bg
    return bg
end

local function clearBillboardsIf(fn)
    for id,gui in pairs(activeBillboards) do
        if not gui or not gui.Parent then activeBillboards[id]=nil else
            if fn and fn(gui) then
                pcall(function() gui:Destroy() end)
                activeBillboards[id]=nil
            end
        end
    end
end

-- ======= Core: finding nearest NPC (generic) =======
local function findNearestEnemy(maxDist)
    maxDist = maxDist or 9999
    local root = getHumRoot()
    if not root then return nil end
    local nearest, nd = nil, maxDist
    -- prioritize workspace.Enemies
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _,m in pairs(enemiesFolder:GetChildren()) do
            if m and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health>0 then
                local d = (m.HumanoidRootPart.Position - root.Position).Magnitude
                if d < nd then nd = d; nearest = m end
            end
        end
    end
    -- fallback: scan workspace
    if not nearest then
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health>0 then
                local d = (m.HumanoidRootPart.Position - root.Position).Magnitude
                if d < nd then nd = d; nearest = m end
            end
        end
    end
    return nearest
end

-- ======= Attack helper (use current tool fast) =======
local function useToolFast(delay)
    delay = tonumber(delay) or Yex.AttackDelay or 0.03
    local c = getChar()
    local tool = c and c:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
        task.wait(delay)
        pcall(function() tool:Activate() end)
    end
end

-- ======= Tween helper =======
local function tweenToPosition(pos, speed)
    local hrp = getHumRoot()
    if not hrp then return end
    local dist = (hrp.Position - pos).Magnitude
    if dist < 2 then hrp.CFrame = CFrame.new(pos); return end
    local t = math.clamp(dist / math.max(1,speed), 0.03, 4)
    local ok, err = pcall(function()
        local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
        tw:Play()
        tw.Completed:Wait()
    end)
    if not ok then hrp.CFrame = CFrame.new(pos) end
end

-- ======= Auto Farm main loop (for Main tab) =======
local farmThread = nil
function startFarm()
    if farmThread and coroutine.status(farmThread) ~= "dead" then return end
    farmThread = coroutine.create(function()
        while Yex.FarmOn do
            local nearest = findNearestEnemy(Yex.FarmDistance or 9999)
            if nearest and nearest:FindFirstChild("HumanoidRootPart") then
                local hrp = nearest.HumanoidRootPart
                local targetPos = hrp.Position + Vector3.new(0, (Yex.FarmYOffset or 5), 0)
                -- move
                if tonumber(Yex.TweenSpeed) and tonumber(Yex.TweenSpeed) > 0 then
                    tweenToPosition(targetPos, tonumber(Yex.TweenSpeed))
                else
                    local myhrp = getHumRoot()
                    if myhrp then myhrp.CFrame = CFrame.new(targetPos) end
                end
                -- attack quickly while target alive
                if nearest:FindFirstChild("Humanoid") and nearest.Humanoid.Health > 0 then
                    useToolFast(Yex.AttackDelay)
                end
            end
            task.wait(0.06)
        end
    end)
    coroutine.resume(farmThread)
end

function stopFarm()
    Yex.FarmOn = false
    -- farmThread will gracefully finish
end

-- ======= Prehistoric auto-farm loop implementation =======
local preThread = nil
local function findPrehistoricTargets(maxDist)
    maxDist = maxDist or 9999
    local root = getHumRoot()
    if not root then return {} end
    local found = {}
    -- look in workspace.Enemies first
    local searchList = {}
    if workspace:FindFirstChild("Enemies") then
        for _,m in pairs(workspace.Enemies:GetChildren()) do table.insert(searchList, m) end
    else
        for _,m in pairs(workspace:GetDescendants()) do if m:IsA("Model") then table.insert(searchList,m) end end
    end
    for _,m in pairs(searchList) do
        if m and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 and isPrehistoricModel(m) then
            local d = (m.HumanoidRootPart.Position - root.Position).Magnitude
            if d <= (maxDist or 9999) then table.insert(found, m) end
        end
    end
    return found
end

function startPrehistoricFarm()
    if preThread and coroutine.status(preThread) ~= "dead" then return end
    preThread = coroutine.create(function()
        while Yex.PreOn do
            -- find prehistoric monsters near
            local targets = findPrehistoricTargets(Yex.FarmDistance or 9999)
            if #targets > 0 then
                -- pick the nearest
                table.sort(targets, function(a,b)
                    return (a.HumanoidRootPart.Position - getHumRoot().Position).Magnitude < (b.HumanoidRootPart.Position - getHumRoot().Position).Magnitude
                end)
                local t = targets[1]
                if t and t:FindFirstChild("HumanoidRootPart") then
                    local pos = t.HumanoidRootPart.Position + Vector3.new(0, (Yex.FarmYOffset or 8), 0)
                    tweenToPosition(pos, Yex.TweenSpeed or 80)
                    -- attack while alive
                    for i=1,5 do
                        if t and t:FindFirstChild("Humanoid") and t.Humanoid.Health>0 then
                            useToolFast(Yex.AttackDelay)
                        else break end
                        task.wait(0.04)
                    end
                    -- try to collect drops (move to their parts)
                    if collectSwitch and collectSwitch.Get and collectSwitch.Get() then
                        -- scan workspace for Tools/parts dropped with names like "Relic","Drop","Prehistoric"
                        for _,obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") or obj:IsA("Tool") then
                                local nm = string.lower(tostring(obj.Name))
                                if string.find(nm,"drop") or string.find(nm,"relic") or string.find(nm,"prehistoric") then
                                    pcall(function() getHumRoot().CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0)) end)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            else
                -- no targets; small wait
                task.wait(0.5)
            end
            task.wait(0.06)
        end
    end)
    coroutine.resume(preThread)
end

function stopPrehistoricFarm()
    Yex.PreOn = false
    -- thread will finish
end

-- ======= ESP update loop =======
local function updateESP()
    -- Fruit ESP: search for Tools with 'fruit' in name
    if Yex.ESP.fruit then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(string.lower(v.Name),"fruit") then
                makeBillboard(v.Handle, v.Name)
            end
        end
    else
        clearBillboardsIf(function(bg) local par = bg and bg.Adornee and bg.Adornee.Parent; return par and par:IsA("Tool") and string.find(string.lower(par.Parent.Name or par.Name or ""), "fruit") end)
    end
    -- Flower ESP
    if Yex.ESP.flower then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and string.find(string.lower(v.Name),"flower") then
                makeBillboard(v,v.Name)
            end
        end
    else
        clearBillboardsIf(function(bg) return string.find(string.lower(tostring(bg.Adornee.Name or "")),"flower") end)
    end
    -- Chest ESP
    if Yex.ESP.chest then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and string.find(string.lower(v.Name),"chest") then
                makeBillboard(v,v.Name)
            end
        end
    else
        clearBillboardsIf(function(bg) return string.find(string.lower(tostring(bg.Adornee.Name or "")),"chest") end)
    end
    -- Player ESP
    if Yex.ESP.player then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                makeBillboard(plr.Character.HumanoidRootPart, plr.Name)
            end
        end
    else
        clearBillboardsIf(function(bg) return Players:FindFirstChild(bg.Adornee.Parent.Name) end)
    end
end

-- ======= Connect loops & housekeeping =======
-- Apply WalkSpeed and ESP every heartbeat
RunService.Heartbeat:Connect(function()
    -- apply walk speed
    pcall(function()
        local c = getChar()
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = Yex.WalkSpeed or 16
        end
    end)
    -- update ESP
    pcall(updateESP)
end)

-- Keybind toggle for GUI
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        local keyname = tostring(inp.KeyCode):gsub("Enum.KeyCode.","")
        if keyname == tostring(Yex.ToggleKey or "Y") then
            setHubVisible(not Yex.GuiVisible)
        end
    end
end)

-- Ensure UI reflects values on startup
-- set initial switch visuals by simulating toggles
-- (iterate through main page descendants to set matching initial states)
local function applyInitialUI()
    -- Main: find the first switch (we know we created it) and set based on Yex.FarmOn
    for _,f in pairs(pages["Main"]:GetChildren()) do
        if f:IsA("Frame") and f.Size.X.Offset==46 then
            -- set initial based on Yex.FarmOn
            local init = Yex.FarmOn
            f.BackgroundColor3 = init and Color3.fromRGB(0,200,80) or Color3.fromRGB(0,0,0)
            local knob = f:FindFirstChildWhichIsA("Frame")
            if knob then knob.Position = init and UDim2.new(1,-20,0,2) or UDim2.new(0,2,0,2) end
            break
        end
    end
    -- others (esp switches): will be set when toggled by user
end

applyInitialUI()

-- Start running Prehistoric or Farm if toggles were set already
if Yex.FarmOn then startFarm() end
if Yex.PreOn then startPrehistoricFarm() end

-- Final message
sWarn("YexScript loaded (KRNL). Tabs arranged: Main, ESP, Teleport, Raid, Prehistoric, Misc, Settings.")
