-- WAIT FOR GAME LOAD
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GardenFolder = workspace:WaitForChild("Gardens")[Players.LocalPlayer.Name]
local RS = ReplicatedStorage:WaitForChild("Events")

-- FLAG VARIABLES
local S = {
  autoCollect=false, autoWater=false, autoHatch=false, autoPlaceEgg=false,
  autoTranquil=false, autoSubmit=false
}

-- UI SETUP
local gui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ZenGardenHub"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5,-160,0.4,-190)
frame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
frame.Active = true; frame.Draggable = true
frame.Visible = false

-- Toggle Key Button
local btnToggle = Instance.new("TextButton", gui)
btnToggle.Text = "🧘"
btnToggle.Size = UDim2.new(0, 40, 0, 40)
btnToggle.Position = UDim2.new(0, 10, 0.5, -20)
btnToggle.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
btnToggle.TextColor3 = Color3.new(1,1,1)
btnToggle.Font = Enum.Font.GothamBold; btnToggle.TextSize = 24
btnToggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

-- Notify function
local function notify(msg)
    game.StarterGui:SetCore("SendNotification", {Title="Zen Hub",Text=msg,Duration=3})
end

notify("Zen Garden Hub Loaded!")

-- Tab creation helper
local tabs = {}
local function mkTab(name, x)
    local b = Instance.new("TextButton", frame)
    b.Text = name; b.Size = UDim2.new(0,80,0,30)
    b.Position = UDim2.new(0, x, 0, 40)
    b.BackgroundColor3 = Color3.new(0.2,0.2,0.2); b.TextColor3 = Color3.new(1,1,1)
    local f = Instance.new("Frame", frame)
    f.Size = UDim2.new(1, -10, 1, -100); f.Position = UDim2.new(0,5,0,80)
    f.Visible = false
    tabs[#tabs+1] = {btn=b,frame=f}
    b.MouseButton1Click:Connect(function()
        for _,t in pairs(tabs) do t.frame.Visible=false end
        f.Visible=true
    end)
    return f
end

-- MAIN TAB
local main = mkTab("Main", 0.05)
local function addToggle(f, text, flag)
    local btn = Instance.new("TextButton", f)
    btn.Text = text..": OFF"; btn.Size = UDim2.new(0,200,0,30)
    btn.Position = UDim2.new(0,10,#f:GetChildren()*0.12+10)
    btn.BackgroundColor3 = Color3.new(0.3,0.3,0.3); btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        S[flag] = not S[flag]
        btn.Text = text..": "..(S[flag] and "ON" or "OFF")
        notify(text.." "..(S[flag] and "Enabled" or "Disabled"))
    end)
end

addToggle(main, "Auto Collect Crops", "autoCollect")
addToggle(main, "Auto Water Plants", "autoWater")

-- EGG TAB
local egg = mkTab("Egg", 0.30)
addToggle(egg, "Auto Hatch Egg", "autoHatch")
addToggle(egg, "Auto Place Egg", "autoPlaceEgg")

-- ZEN TAB
local zen = mkTab("Zen", 0.55)
addToggle(zen, "Auto Collect Tranquil", "autoTranquil")
addToggle(zen, "Auto Submit Zen Quest", "autoSubmit")
local btnShop = Instance.new("TextButton", zen)
btnShop.Text="Open Zen Shop"; btnShop.Size=UDim2.new(0,200,0,30)
btnShop.Position=UDim2.new(0,10,0,200)
btnShop.BackgroundColor3 = Color3.new(0.3,0.3,0.3); btnShop.TextColor3=Color3.new(1,1,1)
btnShop.MouseButton1Click:Connect(function()
    if RS:FindFirstChild("OpenShop") then RS.OpenShop:FireServer("Zen") end
    notify("Zen Shop Opened")
end)

-- MISC TAB
local misc = mkTab("Misc", 0.80)
local spd = Instance.new("TextBox", misc)
spd.PlaceholderText="WalkSpeed"; spd.Size=UDim2.new(0,120,0,25); spd.Position=UDim2.new(0,10,0,10)
spd.FocusLost:Connect(function(e)
    local v=tonumber(spd.Text)
    if v then Player.Character.Humanoid.WalkSpeed=v; notify("WalkSpeed="..v) end
end)
local jp = Instance.new("TextBox", misc)
jp.PlaceholderText="JumpPower"; jp.Size=UDim2.new(0,120,0,25); jp.Position=UDim2.new(0,10,0,50)
jp.FocusLost:Connect(function(e)
    local v=tonumber(jp.Text)
    if v then Player.Character.Humanoid.JumpPower=v; notify("JumpPower="..v) end
end)

-- ACTIVITY LOOPS
task.spawn(function()
    while true do
        task.wait(1)
        if S.autoCollect then
            for _,crop in pairs(GardenFolder:GetChildren()) do
                if crop:FindFirstChild("Collect") then fireproximityprompt(crop.Collect) end
            end
        end
        if S.autoWater then
            RS.ToolUse:FireServer("Watering Can", Player.Character.HumanoidRootPart.Position)
        end
        if S.autoHatch then
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name:match("Egg") and v:IsA("ClickDetector") then fireclickdetector(v) end
            end
        end
        if S.autoPlaceEgg then
            for _,it in pairs(Player.Backpack:GetChildren()) do
                if it.Name:match("Egg") then RS.PlaceEgg:FireServer(it) end
            end
        end
        if S.autoTranquil then
            for _,crop in pairs(GardenFolder:GetChildren()) do
                if crop:FindFirstChild("Collect") and crop:FindFirstChild("Mutation") and crop.Mutation.Value=="Tranquil" then
                    fireproximityprompt(crop.Collect)
                end
            end
        end
        if S.autoSubmit then
            RS.SubmitZenQuest:FireServer()
        end
    end
end)

tabs[1].btn.MouseButton1Click()
frame.Visible = true
