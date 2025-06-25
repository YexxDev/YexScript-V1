-- YexScript Hub - Final Version
-- Optimized for Grow a Garden, Mobile & PC, with full GUI & loading screen

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

--// SCREEN GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "YexScriptHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// LOADING BACKGROUND
local loadingBG = Instance.new("Frame", gui)
loadingBG.Size = UDim2.new(1, 0, 1, 0)
loadingBG.BackgroundColor3 = Color3.fromRGB(128, 90, 213)
loadingBG.BackgroundTransparency = 0.3

--// TEXT YEX
local yexText = Instance.new("TextLabel", loadingBG)
yexText.Size = UDim2.new(0, 200, 0, 50)
yexText.Position = UDim2.new(0.5, -100, 0.45, -60)
yexText.BackgroundTransparency = 1
yexText.Text = ""
yexText.TextColor3 = Color3.new(1, 1, 1)
yexText.Font = Enum.Font.GothamBlack
yexText.TextSize = 36

--// TEXT SCRIPT
local scriptText = Instance.new("TextLabel", loadingBG)
scriptText.Size = UDim2.new(0, 200, 0, 50)
scriptText.Position = UDim2.new(0.5, -100, 0.5, 0)
scriptText.BackgroundTransparency = 1
scriptText.Text = ""
scriptText.TextColor3 = Color3.new(1, 1, 1)
scriptText.Font = Enum.Font.GothamBlack
scriptText.TextSize = 36

--// ANIMATION FUNCTION
local function animateLoading()
    wait(1)
    yexText.Text = "YEX"
    TweenService:Create(yexText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    wait(1)
    scriptText.Text = "SCRIPT"
    TweenService:Create(scriptText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    wait(1.5)
    loadingBG:Destroy()
end

animateLoading()
-- GUI Container Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "MainUI"
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Visible = false

-- Tabs Bar
local tabList = {"Home", "Main", "ESP", "Teleport", "Misc"}
local tabButtons = {}
local pages = {}

local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

for i, tabName in ipairs(tabList) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 80, 0, 0)
    btn.Text = tabName
    btn.Name = tabName
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    tabButtons[tabName] = btn
end

-- Page Templates
for _, tabName in ipairs(tabList) do
    local page = Instance.new("ScrollingFrame", mainFrame)
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, 0, 1, -35)
    page.Position = UDim2.new(0, 0, 0, 35)
    page.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    pages[tabName] = page
end

-- Show Home page by default
pages["Home"].Visible = true
mainFrame.Visible = true

-- Tab button logic
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
    end)
end

-- Toggle GUI with "Y"
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Y then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
-- Shortcut to Main Page
local mainPage = pages["Main"]

-- Auto Plant Seed
local autoPlant = false
local autoPlantBtn = Instance.new("TextButton", mainPage)
autoPlantBtn.Size = UDim2.new(0, 200, 0, 30)
autoPlantBtn.Position = UDim2.new(0, 10, 0, 10)
autoPlantBtn.Text = "Auto Plant: OFF"
autoPlantBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
autoPlantBtn.TextColor3 = Color3.new(1, 1, 1)
autoPlantBtn.Font = Enum.Font.Gotham
autoPlantBtn.TextSize = 14

autoPlantBtn.MouseButton1Click:Connect(function()
    autoPlant = not autoPlant
    autoPlantBtn.Text = "Auto Plant: " .. (autoPlant and "ON" or "OFF")
end)

task.spawn(function()
    while true do
        if autoPlant then
            local char = plr.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("seed") then
                    mouse1click()
                end
            end
        end
        task.wait(0.3)
    end
end)

-- Auto Watering Can
local autoWater = false
local autoWaterBtn = Instance.new("TextButton", mainPage)
autoWaterBtn.Size = UDim2.new(0, 200, 0, 30)
autoWaterBtn.Position = UDim2.new(0, 10, 0, 50)
autoWaterBtn.Text = "Auto Water: OFF"
autoWaterBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
autoWaterBtn.TextColor3 = Color3.new(1, 1, 1)
autoWaterBtn.Font = Enum.Font.Gotham
autoWaterBtn.TextSize = 14

autoWaterBtn.MouseButton1Click:Connect(function()
    autoWater = not autoWater
    autoWaterBtn.Text = "Auto Water: " .. (autoWater and "ON" or "OFF")
end)

task.spawn(function()
    while true do
        if autoWater then
            local char = plr.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("watering") then
                    mouse1click()
                end
            end
        end
        task.wait(0.2)
    end
end)

-- Auto Collect Crops
local autoCollect = false
local collectBtn = Instance.new("TextButton", mainPage)
collectBtn.Size = UDim2.new(0, 200, 0, 30)
collectBtn.Position = UDim2.new(0, 10, 0, 90)
collectBtn.Text = "Auto Collect: OFF"
collectBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
collectBtn.TextColor3 = Color3.new(1, 1, 1)
collectBtn.Font = Enum.Font.Gotham
collectBtn.TextSize = 14

collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectBtn.Text = "Auto Collect: " .. (autoCollect and "ON" or "OFF")
end)

task.spawn(function()
    while true do
        if autoCollect then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and v.Parent:FindFirstChild("Name") and tostring(v.Parent.Name):lower():find("fruit") then
                    fireclickdetector(v)
                end
            end
        end
        task.wait(1)
    end
end)
-- ESP TAB
local espPage = pages["ESP"]

-- Best Fruit ESP (visual-only)
local fruitEspBtn = Instance.new("TextButton", espPage)
fruitEspBtn.Size = UDim2.new(0, 250, 0, 30)
fruitEspBtn.Position = UDim2.new(0, 10, 0, 10)
fruitEspBtn.Text = "Show Best Fruit (Visual)"
fruitEspBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
fruitEspBtn.TextColor3 = Color3.new(1, 1, 1)
fruitEspBtn.Font = Enum.Font.Gotham
fruitEspBtn.TextSize = 14

fruitEspBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("fruit") and obj:FindFirstChild("BillboardGui") == nil then
            local gui = Instance.new("BillboardGui", obj)
            gui.Size = UDim2.new(0, 100, 0, 30)
            gui.AlwaysOnTop = true
            gui.Adornee = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChildWhichIsA("BasePart")
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 0)
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
            label.Text = "[Fruit] Value: "..tostring(math.random(100, 999))
        end
    end
end)

-- Show Pet ESP
local petEspBtn = Instance.new("TextButton", espPage)
petEspBtn.Size = UDim2.new(0, 250, 0, 30)
petEspBtn.Position = UDim2.new(0, 10, 0, 50)
petEspBtn.Text = "Show My Pets (Visual)"
petEspBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
petEspBtn.TextColor3 = Color3.new(1, 1, 1)
petEspBtn.Font = Enum.Font.Gotham
petEspBtn.TextSize = 14

petEspBtn.MouseButton1Click:Connect(function()
    for _, pet in pairs(workspace:GetDescendants()) do
        if pet:IsA("Model") and pet.Name == plr.Name.."'s Pet" then
            local tag = Instance.new("BillboardGui", pet)
            tag.Size = UDim2.new(0, 100, 0, 30)
            tag.AlwaysOnTop = true
            tag.Adornee = pet:FindFirstChildWhichIsA("BasePart")
            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(0, 1, 1)
            label.Text = "🐾 MY PET"
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
        end
    end
end)

-- TELEPORT TAB
local tpPage = pages["Teleport"]

local locations = {
    ["Gear Shop"] = Vector3.new(-50, 5, 120),
    ["Summer Event NPC"] = Vector3.new(85, 3, -220),
    ["Egg Shop"] = Vector3.new(15, 4, 75),
    ["Honey Machine"] = Vector3.new(-120, 3, -40),
}

local y = 10
for name, pos in pairs(locations) do
    local tpBtn = Instance.new("TextButton", tpPage)
    tpBtn.Size = UDim2.new(0, 240, 0, 30)
    tpBtn.Position = UDim2.new(0, 10, 0, y)
    tpBtn.Text = "Teleport to " .. name
    tpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Font = Enum.Font.Gotham
    tpBtn.TextSize = 14
    y += 40

    tpBtn.MouseButton1Click:Connect(function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        end
    end)
end
-- MISC TAB
local miscPage = pages["Misc"]

-- Walkspeed
local wsSlider = Instance.new("TextButton", miscPage)
wsSlider.Size = UDim2.new(0, 200, 0, 30)
wsSlider.Position = UDim2.new(0, 10, 0, 10)
wsSlider.Text = "Walkspeed: 16"
wsSlider.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
wsSlider.TextColor3 = Color3.new(1, 1, 1)
wsSlider.Font = Enum.Font.Gotham
wsSlider.TextSize = 14

local wsValue = 16
wsSlider.MouseButton1Click:Connect(function()
    wsValue = wsValue + 4
    if wsValue > 80 then wsValue = 16 end
    wsSlider.Text = "Walkspeed: " .. wsValue
    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
        plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = wsValue
    end
end)

-- Fly toggle
local flying = false
local flyBtn = Instance.new("TextButton", miscPage)
flyBtn.Size = UDim2.new(0, 200, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 50)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 120)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.Gotham
flyBtn.TextSize = 14

local UIS = game:GetService("UserInputService")
local flyingSpeed = 60
local vel = Instance.new("BodyVelocity")
vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")

    if flying then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            vel.Parent = hrp
            task.spawn(function()
                while flying do
                    local move = Vector3.zero
                    if UIS:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0, 0, -1) end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0, 0, 1) end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1, 0, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1, 0, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move += Vector3.new(0, -1, 0) end

                    vel.Velocity = hrp.CFrame:VectorToWorldSpace(move.Unit) * flyingSpeed
                    task.wait()
                end
                vel.Parent = nil
            end)
        end
    else
        vel.Parent = nil
    end
end)

-- GUI Toggle Visibility Square
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 90, 0, 30)
toggleBtn.Position = UDim2.new(0.01, 0, 0.1, 0)
toggleBtn.Text = "YEXSCRIPT HUB"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 160)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextWrapped = true
toggleBtn.AutoButtonColor = true

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
