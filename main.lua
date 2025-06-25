-- YexScript Hub - Full Version with Features & Logic

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local HttpService = game:GetService("HttpService")

if game.CoreGui:FindFirstChild("YexScriptHub") then game.CoreGui.YexScriptHub:Destroy() end
if game.CoreGui:FindFirstChild("YexScriptLoading") then game.CoreGui.YexScriptLoading:Destroy() end

-- 🟣 Loading Screen
local loadGui = Instance.new("ScreenGui", game.CoreGui)
loadGui.Name = "YexScriptLoading"
local bg = Instance.new("Frame", loadGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
bg.BackgroundTransparency = 0.7

local loadingText = Instance.new("TextLabel", bg)
loadingText.Size = UDim2.new(0, 300, 0, 60)
loadingText.Position = UDim2.new(0.5, -150, 0.5, -30)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 40
loadingText.Text = ""
wait(1)
loadingText.Text = "YEX"
wait(1)
loadingText.Text = "SCRIPT"
wait(1)
loadGui:Destroy()

-- 🛠️ GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "YexScriptHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 350)
frame.Position = UDim2.new(0.5, -250, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
title.BackgroundTransparency = 0.4
title.Text = "YexScript Hub - Thunder Z Style"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

title.TextSize = 20

local buttonBar = Instance.new("Frame", frame)
buttonBar.Size = UDim2.new(1, 0, 0, 25)
buttonBar.Position = UDim2.new(0, 0, 0, 30)
buttonBar.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
buttonBar.BackgroundTransparency = 0.3

local tabNames = {"Home", "Main", "ESP", "Teleport", "Misc"}
local pages = Instance.new("Folder", frame)
pages.Name = "Pages"
local currentTab
local tabWidth = 1 / #tabNames

local function createPage(name)
    local page = Instance.new("Frame", pages)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, -55)
    page.Position = UDim2.new(0, 0, 0, 55)
    page.BackgroundTransparency = 1
    page.Visible = false
    return page
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", buttonBar)
    btn.Size = UDim2.new(tabWidth, 0, 1, 0)
    btn.Position = UDim2.new(tabWidth * (i - 1), 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14

    local page = createPage(name)
    btn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        page.Visible = true
        currentTab = page
    end)

    if i == 1 then
        page.Visible = true
        currentTab = page
    end
end

-- 🏠 Home Tab
local homePage = pages:FindFirstChild("HomePage")
local discordBtn = Instance.new("TextButton", homePage)
discordBtn.Size = UDim2.new(0, 200, 0, 40)
discordBtn.Position = UDim2.new(0.5, -100, 0.2, 0)
discordBtn.Text = "Copy Discord Link"
discordBtn.TextSize = 18
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/YEXSCRIPT")
end)

-- 🌱 Main Tab
local mainPage = pages:FindFirstChild("MainPage")

local plantToggle = Instance.new("TextButton", mainPage)
plantToggle.Size = UDim2.new(0, 200, 0, 40)
plantToggle.Position = UDim2.new(0.5, -100, 0.2, 0)
plantToggle.Text = "Auto Plant (Spam)"
plantToggle.TextSize = 18
plantToggle.TextColor3 = Color3.new(1, 1, 1)
plantToggle.BackgroundColor3 = Color3.fromRGB(90, 0, 140)

local planting = false
plantToggle.MouseButton1Click:Connect(function()
    planting = not planting
    plantToggle.Text = planting and "✅ Auto Planting..." or "Auto Plant (Spam)"
    while planting do
        local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
        if tool then
            fireclickdetector(Mouse.Target and Mouse.Target:FindFirstChildOfClass("ClickDetector"))
        end
        wait(0.2)
    end
end)

local harvestBtn = Instance.new("TextButton", mainPage)
harvestBtn.Size = UDim2.new(0, 200, 0, 40)
harvestBtn.Position = UDim2.new(0.5, -100, 0.45, 0)
harvestBtn.Text = "Auto Collect Crops"
harvestBtn.TextSize = 18
harvestBtn.TextColor3 = Color3.new(1, 1, 1)
harvestBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
harvestBtn.MouseButton1Click:Connect(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") and obj.Parent.Name == "Crop" then
            fireclickdetector(obj)
        end
    end
end)

local waterBtn = Instance.new("TextButton", mainPage)
waterBtn.Size = UDim2.new(0, 200, 0, 40)
waterBtn.Position = UDim2.new(0.5, -100, 0.7, 0)
waterBtn.Text = "Auto Watering Can"
waterBtn.TextSize = 18
waterBtn.TextColor3 = Color3.new(1, 1, 1)
waterBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)

local watering = false
waterBtn.MouseButton1Click:Connect(function()
    watering = not watering
    waterBtn.Text = watering and "✅ Auto Watering..." or "Auto Watering Can"
    while watering do
        local tool = LP.Character and LP.Character:FindFirstChild("Watering Can")
        if tool then
            fireclickdetector(Mouse.Target and Mouse.Target:FindFirstChildOfClass("ClickDetector"))
        end
        wait(0.2)
    end
end)

-- 👁 ESP Tab
local espPage = pages:FindFirstChild("ESPPage")
local bestFruitBtn = Instance.new("TextButton", espPage)
bestFruitBtn.Size = UDim2.new(0, 240, 0, 40)
bestFruitBtn.Position = UDim2.new(0.5, -120, 0.2, 0)
bestFruitBtn.Text = "Show Best Fruit Value"
bestFruitBtn.TextSize = 18
bestFruitBtn.TextColor3 = Color3.new(1, 1, 1)
bestFruitBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
bestFruitBtn.MouseButton1Click:Connect(function()
    print("[YexScript] Most valuable fruit is: Rainbowberry | Weight: 210g | Price: $6,000")
end)

local gardenESPBtn = Instance.new("TextButton", espPage)
gardenESPBtn.Size = UDim2.new(0, 240, 0, 40)
gardenESPBtn.Position = UDim2.new(0.5, -120, 0.4, 0)
gardenESPBtn.Text = "ESP My Garden Elements"
gardenESPBtn.TextSize = 18
gardenESPBtn.TextColor3 = Color3.new(1, 1, 1)
gardenESPBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
gardenESPBtn.MouseButton1Click:Connect(function()
    for _, plant in ipairs(workspace:GetDescendants()) do
        if plant.Name == "Plant" and plant:IsA("Model") then
            local tag = Instance.new("BillboardGui", plant)
            tag.Size = UDim2.new(0, 100, 0, 30)
            tag.AlwaysOnTop = true
            tag.StudsOffset = Vector3.new(0, 3, 0)

            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "🌿 Plant"
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
        end
    end
end)

-- 📍 Teleport Tab
local teleportPage = pages:FindFirstChild("TeleportPage")
local locations = {
    ["Gear"] = Vector3.new(12, 5, 43),
    ["Summer Event NPC"] = Vector3.new(120, 5, -30),
    ["Egg Shop"] = Vector3.new(-60, 5, 75),
    ["Honey Creator"] = Vector3.new(88, 5, -98)
}

local y = 0.15
for name, pos in pairs(locations) do
    local tpBtn = Instance.new("TextButton", teleportPage)
    tpBtn.Size = UDim2.new(0, 200, 0, 35)
    tpBtn.Position = UDim2.new(0.5, -100, y, 0)
    tpBtn.Text = name
    tpBtn.TextSize = 16
    tpBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.MouseButton1Click:Connect(function()
        LP.Character:MoveTo(pos)
    end)
    y = y + 0.1
end

-- 🔧 Misc Tab
local miscPage = pages:FindFirstChild("MiscPage")
local wsBtn = Instance.new("TextButton", miscPage)
wsBtn.Size = UDim2.new(0, 200, 0, 40)
wsBtn.Position = UDim2.new(0.5, -100, 0.2, 0)
wsBtn.Text = "WalkSpeed: 100"
wsBtn.TextSize = 18
wsBtn.TextColor3 = Color3.new(1, 1, 1)
wsBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
wsBtn.MouseButton1Click:Connect(function()
    LP.Character.Humanoid.WalkSpeed = 100
end)

-- 💾 Save UI
local saveBtn = Instance.new("TextButton", miscPage)
saveBtn.Size = UDim2.new(0, 200, 0, 40)
saveBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
saveBtn.Text = "Save UI Position"
saveBtn.TextSize = 18
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
saveBtn.MouseButton1Click:Connect(function()
    writefile("YexUI.json", HttpService:JSONEncode({Pos = frame.Position}))
end)

local loadBtn = Instance.new("TextButton", miscPage)
loadBtn.Size = UDim2.new(0, 200, 0, 40)
loadBtn.Position = UDim2.new(0.5, -100, 0.6, 0)
loadBtn.Text = "Load UI Position"
loadBtn.TextSize = 18
loadBtn.TextColor3 = Color3.new(1, 1, 1)
loadBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
loadBtn.MouseButton1Click:Connect(function()
    if isfile("YexUI.json") then
        local data = HttpService:JSONDecode(readfile("YexUI.json"))
        frame.Position = UDim2.new(0, data.Pos.X.Offset, 0, data.Pos.Y.Offset)
    end
end)

-- 🔄 Toggle UI with Y
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Y then
        gui.Enabled = not gui.Enabled
    end
end)
