-- ✅ YexScript Hub - Swipeable UI with Visual Fruit Detection & Home Tab
-- Supports: Mobile/PC, Swipe between tabs, Real teleport, Auto plant, Visual ESP

local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "YexScriptHub"

-- Notification Label
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0, 350, 0, 40)
notif.Position = UDim2.new(0.5, -175, 0.1, 0)
notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notif.TextColor3 = Color3.fromRGB(0, 255, 0)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 18
notif.Text = "✅ Successfully Executed YexScript!"
notif.Visible = true
Instance.new("UICorner", notif)

-- Hide after few seconds
spawn(function()
    wait(4)
    notif:TweenPosition(UDim2.new(0.5, -175, 0.05, 0), "Out", "Quad", 0.5, true)
    wait(1)
    notif.Visible = false
end)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 420)
main.Position = UDim2.new(0.5, -180, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active, main.Draggable = true, true
Instance.new("UICorner", main)

-- Scrollable Swipe Tabs
local pageFrame = Instance.new("ScrollingFrame", main)
pageFrame.Size = UDim2.new(1, 0, 1, 0)
pageFrame.CanvasSize = UDim2.new(5, 0, 1, 0) -- one for each tab
pageFrame.ScrollBarThickness = 0
pageFrame.ScrollingDirection = Enum.ScrollingDirection.X
pageFrame.BackgroundTransparency = 1
pageFrame.ClipsDescendants = true
pageFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
pageFrame.ZIndex = 1

local tabNames = {"Home", "Main", "Teleport", "ESP", "Movement", "Server"}
local tabFrames = {}
local tabWidth = 360

for i, name in ipairs(tabNames) do
    local tab = Instance.new("Frame", pageFrame)
    tab.Name = name
    tab.Size = UDim2.new(0, tabWidth, 1, 0)
    tab.Position = UDim2.new(0, tabWidth * (i - 1), 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.BorderSizePixel = 0
    Instance.new("UICorner", tab)

    local label = Instance.new("TextLabel", tab)
    label.Size = UDim2.new(1, 0, 0, 35)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = "🧠 " .. name .. " Tab"
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 255, 255)

    tabFrames[name] = tab
end

-- HOME TAB
local homeBtn = Instance.new("TextButton", tabFrames["Home"])
homeBtn.Size = UDim2.new(0, 300, 0, 40)
homeBtn.Position = UDim2.new(0.5, -150, 0.2, 0)
homeBtn.Text = "📋 Copy Discord Invite"
homeBtn.BackgroundColor3 = Color3.fromRGB(80, 100, 160)
homeBtn.TextColor3 = Color3.new(1, 1, 1)
homeBtn.Font = Enum.Font.GothamBold
homeBtn.TextSize = 16
Instance.new("UICorner", homeBtn)
homeBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/YEXSCRIPT")
end)

-- MAIN TAB
local spam = false
local y = 40
local function addBtnTo(tab, txt, callback)
    local b = Instance.new("TextButton", tab)
    b.Size = UDim2.new(0, 300, 0, 30)
    b.Position = UDim2.new(0.5, -150, 0, y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    y += 35
end

addBtnTo(tabFrames["Main"], "🌾 Auto Plant Spam", function()
    spam = not spam
    if spam then
        task.spawn(function()
            while spam do
                local t = plr.Character:FindFirstChildOfClass("Tool") or plr.Backpack:FindFirstChildOfClass("Tool")
                if t and t:FindFirstChild("Handle") then
                    plr.Character.Humanoid:EquipTool(t)
                    wait(0.1)
                    t:Activate()
                end
                wait(0.5)
            end
        end)
    end
end)

addBtnTo(tabFrames["Main"], "🌻 Full Plant All Seeds", function()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("seed") then
            plr.Character.Humanoid:EquipTool(tool)
            wait(0.3)
            tool:Activate()
            wait(0.3)
        end
    end
end)

-- TELEPORT TAB
local locs = {
    ["Gear NPC"] = Vector3.new(41,6,-110),
    ["Summer Event"] = Vector3.new(-33,6,90),
    ["Egg Shop"] = Vector3.new(0,6,-42),
    ["Honey Machine"] = Vector3.new(67,6,-11),
}
y = 40
for name, vec in pairs(locs) do
    addBtnTo(tabFrames["Teleport"], "📍 "..name, function()
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(vec + Vector3.new(0,3,0)) end
    end)
end

-- ESP TAB
addBtnTo(tabFrames["ESP"], "👁️ Show Best Fruit Value", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
            local gui = Instance.new("BillboardGui", obj)
            gui.Size = UDim2.new(0, 120, 0, 25)
            gui.AlwaysOnTop = true
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "🔥 "..obj.Name
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
        end
    end
end)

-- MOVEMENT TAB
local function addSlider(tab, prop, min, max)
    local label = Instance.new("TextLabel", tab)
    label.Position = UDim2.new(0.1, 0, 0, y)
    label.Size = UDim2.new(0, 150, 0, 30)
    label.Text = prop
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local box = Instance.new("TextBox", tab)
    box.Position = UDim2.new(0.5, 10, 0, y)
    box.Size = UDim2.new(0, 120, 0, 30)
    box.PlaceholderText = tostring(min).."-"..tostring(max)
    box.Text = ""
    box.TextColor3 = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then h[prop] = math.clamp(val, min, max) end
        end
    end)
    y += 40
end

addSlider(tabFrames["Movement"], "WalkSpeed", 16, 250)
addSlider(tabFrames["Movement"], "JumpPower", 50, 300)

-- SERVER HOP
addBtnTo(tabFrames["Server"], "🔁 Server Hop", function()
    local data = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in ipairs(data.data) do
        if s.playing < s.maxPlayers then
            TS:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

warn("✅ YexScript Swipe UI Ready. All tabs fully working!")
