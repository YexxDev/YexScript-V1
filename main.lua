-- YexScript Hub (Full Custom GUI for Grow a Garden)
-- Features: Swipeable Tabs, Auto Plant, ESP, Pet Info, UI Toggle

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Destroy old GUI if re-executed
if game.CoreGui:FindFirstChild("YexScriptHub") then
    game.CoreGui.YexScriptHub:Destroy()
end

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "YexScriptHub"
gui.ResetOnSpawn = false

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 110, 0, 30)
toggle.Position = UDim2.new(0, 10, 0.5, -15)
toggle.Text = "YEXSCRIPT HUB"
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 380, 0, 260)
frame.Position = UDim2.new(0.5, -190, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Visible = true
frame.ClipsDescendants = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "YexScript Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14

toggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Tab container
local tabHolder = Instance.new("ScrollingFrame", frame)
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.CanvasSize = UDim2.new(0, 1000, 0, 0)
tabHolder.ScrollBarThickness = 2

local pages = Instance.new("Folder", frame)
pages.Name = "Pages"

-- Tab system
local currentTab = nil
function createTab(name)
    local button = Instance.new("TextButton", tabHolder)
    button.Size = UDim2.new(0, 100, 1, 0)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12

    local page = Instance.new("Frame", pages)
    page.Size = UDim2.new(1, 0, 1, -60)
    page.Position = UDim2.new(0, 0, 0, 60)
    page.BackgroundTransparency = 1
    page.Visible = false

    button.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        page.Visible = true
        currentTab = page
    end)

    return page
end

-- Notify
local note = Instance.new("TextLabel", gui)
note.Size = UDim2.new(0, 200, 0, 30)
note.Position = UDim2.new(0.5, -100, 0, 40)
note.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
note.Text = "✅ YexScript Loaded"
note.TextColor3 = Color3.new(0, 1, 0)
note.Font = Enum.Font.GothamBold
note.TextSize = 14
wait(3)
note:Destroy()

--===[ TABS ]===--

-- MAIN TAB
local mainPage = createTab("Main")
local mainLabel = Instance.new("TextLabel", mainPage)
mainLabel.Size = UDim2.new(1, 0, 0, 30)
mainLabel.Text = "Auto Plant Tools"
mainLabel.TextColor3 = Color3.new(1, 1, 1)
mainLabel.BackgroundTransparency = 1
mainLabel.Font = Enum.Font.GothamSemibold
mainLabel.TextSize = 14

local dropSpeed = Instance.new("TextButton", mainPage)
dropSpeed.Size = UDim2.new(0, 160, 0, 30)
dropSpeed.Position = UDim2.new(0, 10, 0, 40)
dropSpeed.Text = "Speed: Normal"
dropSpeed.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropSpeed.TextColor3 = Color3.new(1, 1, 1)
dropSpeed.Font = Enum.Font.Gotham
dropSpeed.TextSize = 12

local speeds = {"Instant", "Fast", "Normal"}
local selectedSpeed = "Normal"
dropSpeed.MouseButton1Click:Connect(function()
    local i = table.find(speeds, selectedSpeed) or 3
    selectedSpeed = speeds[i % #speeds + 1]
    dropSpeed.Text = "Speed: "..selectedSpeed
end)

local autoPlant = Instance.new("TextButton", mainPage)
autoPlant.Size = UDim2.new(0, 160, 0, 30)
autoPlant.Position = UDim2.new(0, 10, 0, 80)
autoPlant.Text = "Plant Held Seed"
autoPlant.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoPlant.TextColor3 = Color3.new(1, 1, 1)
autoPlant.Font = Enum.Font.Gotham
autoPlant.TextSize = 12

autoPlant.MouseButton1Click:Connect(function()
    local t = {Instant = 0.05, Fast = 0.25, Normal = 0.6}
    local delay = t[selectedSpeed] or 0.6
    while true do
        local seed = LP.Backpack:FindFirstChildWhichIsA("Tool")
        if seed then
            LP.Character.Humanoid:EquipTool(seed)
            local pos = LP.Character.HumanoidRootPart.Position
            RS.Plant:FireServer(pos)
        end
        wait(delay)
    end
end)

local waterBtn = Instance.new("TextButton", mainPage)
waterBtn.Size = UDim2.new(0, 160, 0, 30)
waterBtn.Position = UDim2.new(0, 10, 0, 120)
waterBtn.Text = "Auto Water Can"
waterBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
waterBtn.TextColor3 = Color3.new(1, 1, 1)
waterBtn.Font = Enum.Font.Gotham
waterBtn.TextSize = 12

waterBtn.MouseButton1Click:Connect(function()
    while true do
        RS.Water:FireServer(LP.Character.HumanoidRootPart.Position)
        wait(0.25)
    end
end)

-- ESP TAB
local espPage = createTab("ESP")
local fruitBtn = Instance.new("TextButton", espPage)
fruitBtn.Size = UDim2.new(0, 160, 0, 30)
fruitBtn.Position = UDim2.new(0, 10, 0, 10)
fruitBtn.Text = "Show Best Fruit Value"
fruitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fruitBtn.TextColor3 = Color3.new(1, 1, 0)
fruitBtn.Font = Enum.Font.Gotham
fruitBtn.TextSize = 12

fruitBtn.MouseButton1Click:Connect(function()
    for _, f in pairs(workspace.MyGarden.Fruits:GetChildren()) do
        local tag = Instance.new("BillboardGui", f)
        tag.Size = UDim2.new(0, 100, 0, 40)
        tag.AlwaysOnTop = true
        tag.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        local w = f:FindFirstChild("Weight") and f.Weight.Value or "N/A"
        local p = f:FindFirstChild("Price") and f.Price.Value or "N/A"
        label.Text = f.Name.." | "..w.."kg | $"..p
        label.TextColor3 = Color3.new(1, 1, 0)
        label.TextScaled = true
        label.BackgroundTransparency = 1
    end
end)

local petBtn = Instance.new("TextButton", espPage)
petBtn.Size = UDim2.new(0, 160, 0, 30)
petBtn.Position = UDim2.new(0, 10, 0, 50)
petBtn.Text = "Pet ESP"
petBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
petBtn.TextColor3 = Color3.new(0, 1, 1)
petBtn.Font = Enum.Font.Gotham
petBtn.TextSize = 12

petBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(workspace.MyGarden.Pets:GetChildren()) do
        local tag = Instance.new("BillboardGui", p)
        tag.Size = UDim2.new(0, 100, 0, 40)
        tag.AlwaysOnTop = true
        tag.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = p.Name
        label.TextColor3 = Color3.new(0, 1, 1)
        label.TextScaled = true
        label.BackgroundTransparency = 1
    end
end)

-- Default tab
currentTab = mainPage
mainPage.Visible = true
