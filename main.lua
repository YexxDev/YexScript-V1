-- YexScript Hub - Thunder Z Style with Violet Transparent Theme, Toggle Features, and Smooth Loading

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

if game.CoreGui:FindFirstChild("YexScriptHub") then
    game.CoreGui.YexScriptHub:Destroy()
end

-- Loading Screen
local loadGui = Instance.new("ScreenGui", game.CoreGui)
loadGui.Name = "YexScriptLoading"
local loadingFrame = Instance.new("Frame", loadGui)
loadingFrame.Size = UDim2.new(0, 300, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
loadingFrame.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
loadingFrame.BackgroundTransparency = 0.3

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.Text = ""
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 28

for _, word in ipairs({"YEX", "SCRIPT"}) do
    loadingText.Text = word
    wait(1)
end
wait(0.5)
loadGui:Destroy()

-- Main GUI
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

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
title.BackgroundTransparency = 0.4
title.Text = "YexScript Hub - Thunder Z Style"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Tab Buttons
local buttonBar = Instance.new("Frame", frame)
buttonBar.Size = UDim2.new(1, 0, 0, 25)
buttonBar.Position = UDim2.new(0, 0, 0, 30)
buttonBar.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
buttonBar.BackgroundTransparency = 0.3

local tabs = {}
local currentTab = nil
local pages = Instance.new("Folder", frame)
pages.Name = "Pages"

function createTab(name)
    local button = Instance.new("TextButton", buttonBar)
    button.Size = UDim2.new(0, 96, 1, 0)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    button.BackgroundTransparency = 0.3
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansSemibold
    button.TextSize = 14

    local page = Instance.new("Frame", pages)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, -55)
    page.Position = UDim2.new(0, 0, 0, 55)
    page.BackgroundTransparency = 1
    page.Visible = false

    button.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        page.Visible = true
        currentTab = page
    end)

    tabs[name] = page
    return page
end

-- Tabs
local home = createTab("Home")
local main = createTab("Main")
local esp = createTab("ESP")
local teleport = createTab("Teleport")
local misc = createTab("Misc")

-- Default Tab
currentTab = home
home.Visible = true

-- Toggle UI
local isVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Y then
        isVisible = not isVisible
        gui.Enabled = isVisible
    end
end)

-- Toggle function
local function createToggle(parent, labelText, posY, callback)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 240, 0, 30)
    toggle.Position = UDim2.new(0, 20, 0, posY)
    toggle.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    toggle.BackgroundTransparency = 0.3
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 14
    toggle.Text = labelText .. " [OFF]"

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = labelText .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- Home Tab
createToggle(home, "Copy Discord Invite", 20, function(on)
    if on then
        setclipboard("https://discord.gg/YexScript")
    end
end)

-- Main Tab
createToggle(main, "Auto Plant Seed (Hold Seed)", 20, function(on)
    _G.autoPlant = on
    task.spawn(function()
        while _G.autoPlant do
            wait(0.5)
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then mouse1click() end
        end
    end)
end)

createToggle(main, "Auto Watering Can", 60, function(on)
    _G.autoWater = on
    task.spawn(function()
        while _G.autoWater do
            wait(1)
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Name:lower():find("water") then mouse1click() end
        end
    end)
end)

createToggle(main, "Auto Harvester", 100, function(on)
    _G.autoHarvest = on
    task.spawn(function()
        while _G.autoHarvest do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Name == "Harvest" then
                    fireproximityprompt(v)
                end
            end
            wait(2)
        end
    end)
end)

-- ESP Tab
createToggle(esp, "Show Best Fruit Value", 20, function(on)
    if on then
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:FindFirstChild("FruitTag") then
                local tag = fruit.FruitTag
                print("Fruit:", fruit.Name, "Weight:", tag:FindFirstChild("Weight") and tag.Weight.Value, "Price:", tag:FindFirstChild("Price") and tag.Price.Value)
            end
        end
    end
end)

createToggle(esp, "Show My Pets In Garden", 60, function(on)
    if on then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name == LP.Name.."_Pet" then
                print("Your Pet:", v.Name)
            end
        end
    end
end)

-- Teleport Tab
createToggle(teleport, "Summer Event NPC", 20, function(on)
    if on then LP.Character:MoveTo(Vector3.new(-35, 4, 295)) end
end)

createToggle(teleport, "Gear Shop", 60, function(on)
    if on then LP.Character:MoveTo(Vector3.new(120, 3, -30)) end
end)

createToggle(teleport, "Honey Machine", 100, function(on)
    if on then LP.Character:MoveTo(Vector3.new(40, 3, 145)) end
end)

-- Misc Tab
createToggle(misc, "Enable Fly", 20, function(on)
    if on then loadstring(game:HttpGet("https://pastebin.com/raw/YFL1bX1v"))() end
end)

createToggle(misc, "WalkSpeed x2", 60, function(on)
    if on and LP.Character then
        LP.Character.Humanoid.WalkSpeed = 32
    elseif LP.Character then
        LP.Character.Humanoid.WalkSpeed = 16
    end
end)
