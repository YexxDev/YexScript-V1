-- YexScript Hub - Thunder Z Clone with Mobile, Draggable, Full UI Features

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SettingsFile = "YexScriptSettings.json"

if game.CoreGui:FindFirstChild("YexScriptHub") then
    game.CoreGui.YexScriptHub:Destroy()
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "YexScriptHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Loading screen
local loadingGui = Instance.new("ScreenGui", game.CoreGui)
loadingGui.Name = "YexScriptLoading"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.4

local yText = Instance.new("TextLabel", loadingFrame)
yText.Size = UDim2.new(1, 0, 0.2, 0)
yText.Position = UDim2.new(0, 0, 0.4, 0)
yText.Text = ""
yText.Font = Enum.Font.GothamBlack
yText.TextColor3 = Color3.fromRGB(180, 100, 255)
yText.TextSize = 48
yText.BackgroundTransparency = 1

local sText = Instance.new("TextLabel", loadingFrame)
sText.Size = UDim2.new(1, 0, 0.2, 0)
sText.Position = UDim2.new(0, 0, 0.5, 0)
sText.Text = ""
sText.Font = Enum.Font.GothamBlack
sText.TextColor3 = Color3.fromRGB(180, 100, 255)
sText.TextSize = 48
sText.BackgroundTransparency = 1

local function animateText(label, content)
    local tween = TweenService:Create(label, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
    label.Text = content
    label.TextTransparency = 1
    tween:Play()
    tween.Completed:Wait()
end

coroutine.wrap(function()
    wait(1)
    animateText(yText, "YEX")
    wait(1)
    animateText(sText, "SCRIPT")
    wait(1.5)
    loadingGui:Destroy()
    gui.Enabled = true
end)()

gui.Enabled = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 440, 0, 300)
frame.Position = UDim2.new(0.5, -220, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Toggle Keybind
local isVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Y then
        isVisible = not isVisible
        gui.Enabled = isVisible
    end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
title.Text = "YexScript Hub - Thunder Z Style"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

title.Active = true
title.Draggable = true

local tabHolder = Instance.new("ScrollingFrame", frame)
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.CanvasSize = UDim2.new(0, 1000, 0, 0)
tabHolder.ScrollBarThickness = 2

tabHolder.ScrollingDirection = Enum.ScrollingDirection.X

local pages = Instance.new("Folder", frame)
pages.Name = "Pages"

local currentTab = nil
function createTab(name)
    local button = Instance.new("TextButton", tabHolder)
    button.Size = UDim2.new(0, 100, 1, 0)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansSemibold
    button.TextSize = 14

    local page = Instance.new("Frame", pages)
    page.Size = UDim2.new(1, 0, 1, -60)
    page.Position = UDim2.new(0, 0, 0, 60)
    page.BackgroundTransparency = 1
    page.Visible = false

    button.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        page.Visible = true
        currentTab = page
    end)

    return page
end

-- Main Tab
local main = createTab("Main")

local function createButton(parent, text, posY, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

createButton(main, "Auto Plant Seeds", 0.05, function()
    _G.autoPlant = not _G.autoPlant
    while _G.autoPlant do
        wait()
        for _, tool in ipairs(LP.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                LP.Character.Humanoid:EquipTool(tool)
                for _, plot in ipairs(workspace.Plots:GetChildren()) do
                    fireclickdetector(plot:FindFirstChildOfClass("ClickDetector"))
                end
            end
        end
    end
end)

createButton(main, "Auto Water (Spam Click)", 0.2, function()
    _G.autoWater = not _G.autoWater
    while _G.autoWater do
        wait(0.1)
        local tool = LP.Backpack:FindFirstChild("Watering Can")
        if tool then
            LP.Character.Humanoid:EquipTool(tool)
            mouse1click()
        end
    end
end)

createButton(main, "Auto Harvester", 0.35, function()
    _G.autoHarvest = not _G.autoHarvest
    while _G.autoHarvest do
        wait()
        for _, tool in ipairs(LP.Backpack:GetChildren()) do
            if tool.Name:lower():find("harvest") then
                LP.Character.Humanoid:EquipTool(tool)
                for _, plant in ipairs(workspace.Plants:GetChildren()) do
                    fireclickdetector(plant:FindFirstChildOfClass("ClickDetector"))
                end
            end
        end
    end
end)

createButton(main, "Auto Collect Items & Pets", 0.5, function()
    _G.autoCollect = not _G.autoCollect
    while _G.autoCollect do
        wait(1)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent then
                firetouchinterest(LP.Character.HumanoidRootPart, v.Parent, 0)
                firetouchinterest(LP.Character.HumanoidRootPart, v.Parent, 1)
            end
        end
    end
end)

-- Save/Load Settings
local settings = {
    autoPlant = false,
    autoWater = false,
    autoHarvest = false,
    autoCollect = false
}

createButton(main, "Save Settings", 0.65, function()
    pcall(function()
        writefile(SettingsFile, HttpService:JSONEncode(settings))
    end)
end)

createButton(main, "Load Settings", 0.8, function()
    pcall(function()
        local data = readfile(SettingsFile)
        local decoded = HttpService:JSONDecode(data)
        for k,v in pairs(decoded) do
            settings[k] = v
        end
    end)
end)

-- ESP Tab
local esp = createTab("ESP")
createButton(esp, "Show Fruit ESP", 0.05, function()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Model") and fruit:FindFirstChild("Price") then
            local tag = Instance.new("BillboardGui", fruit)
            tag.Size = UDim2.new(0, 100, 0, 20)
            tag.AlwaysOnTop = true
            tag.StudsOffset = Vector3.new(0, 2, 0)
            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = fruit.Name .. " - $" .. fruit.Price.Value
            label.TextScaled = true
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 0)
        end
    end
end)

-- Teleport Tab
local tp = createTab("Teleport")
createButton(tp, "Summer Event NPC", 0.05, function()
    LP.Character:MoveTo(Vector3.new(-35, 4, 295))
end)
createButton(tp, "Gear Shop", 0.2, function()
    LP.Character:MoveTo(Vector3.new(120, 3, -30))
end)
createButton(tp, "Honey Machine", 0.35, function()
    LP.Character:MoveTo(Vector3.new(40, 3, 145))
end)

-- Misc Tab
local misc = createTab("Misc")
createButton(misc, "Enable Fly", 0.05, function()
    loadstring(game:HttpGet("https://pastebin.com/raw/YFL1bX1v"))()
end)

-- Home Tab
local home = createTab("Home")
createButton(home, "Copy Discord Invite", 0.05, function()
    setclipboard("https://discord.gg/YexScript")
end)

-- Default Tab
currentTab = main
main.Visible = true
