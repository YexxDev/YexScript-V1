--// VerdantX Premium GUI for Grow a Garden
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

-- Prevent duplicate GUIs
pcall(function() player.PlayerGui:FindFirstChild("VerdantX_GUI"):Destroy() end)

--// Loading Screen
local loadingGui = Instance.new("ScreenGui", player.PlayerGui)
loadingGui.Name = "VerdantX_Loading"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(50,0,80)
bg.BackgroundTransparency = 0.3

local text = Instance.new("TextLabel", bg)
text.Size = UDim2.new(1,0,1,0)
text.TextColor3 = Color3.new(1,1,1)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBold
text.TextScaled = true
text.Text = ""

wait(1)
text.Text = "YEX"
wait(1)
text.Text = "SCRIPT"
wait(1)
loadingGui:Destroy()

--// GUI Setup
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "VerdantX_GUI"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 430, 0, 300)
mainFrame.Position = UDim2.new(0.5, -215, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "VerdantX Hub"
title.BackgroundColor3 = Color3.fromRGB(100,0,150)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

--// Tab Buttons
local tabList = {"Main", "ESP"}
local tabButtons = {}
local contentFrames = {}

for i, tabName in ipairs(tabList) do
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 40)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(85,85,85)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    tabButtons[tabName] = btn

    local frame = Instance.new("Frame", mainFrame)
    frame.Size = UDim2.new(1, -20, 1, -80)
    frame.Position = UDim2.new(0,10,0,80)
    frame.Visible = i == 1
    frame.BackgroundTransparency = 1
    contentFrames[tabName] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(contentFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

--// Main Tab Features
local function addToggle(name, parent, callback)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 200, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 35)
    toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.Text = "🔲 "..name
    local state = false

    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = (state and "✅ " or "🔲 ") .. name
        callback(state)
    end)
end

-- Auto Plant
addToggle("Auto Plant (Hold Seed)", contentFrames["Main"], function(state)
    task.spawn(function()
        while state and task.wait(0.5) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("seed") then
                    local pos = player.Character.HumanoidRootPart.Position
                    local args = {
                        [1] = Vector3.new(pos.X, 0, pos.Z),
                        [2] = tool.Name
                    }
                    -- Use actual planting remote if found
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlantSeed"):FireServer(unpack(args))
                end
            end
        end
    end)
end)

-- Auto Watering
addToggle("Auto Water Can (Hold)", contentFrames["Main"], function(state)
    task.spawn(function()
        while state and task.wait(0.3) do
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Name:lower():find("watering") then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Water"):FireServer()
            end
        end
    end)
end)

-- Auto Collect
addToggle("Auto Collect Crops", contentFrames["Main"], function(state)
    task.spawn(function()
        while state and task.wait(0.5) do
            for _, crop in pairs(workspace:FindFirstChild("Plots"):GetDescendants()) do
                if crop:IsA("Model") and crop:FindFirstChild("ClickDetector") then
                    fireclickdetector(crop.ClickDetector)
                end
            end
        end
    end)
end)

--// ESP Tab
addToggle("ESP: My Fruits", contentFrames["ESP"], function(state)
    while state and task.wait(2) do
        for _, fruit in pairs(workspace:FindFirstChild("Plots"):GetDescendants()) do
            if fruit:IsA("Model") and fruit:FindFirstChild("Owner") and fruit.Owner.Value == player then
                if not fruit:FindFirstChild("NameTag") then
                    local tag = Instance.new("BillboardGui", fruit)
                    tag.Name = "NameTag"
                    tag.Size = UDim2.new(0,100,0,40)
                    tag.AlwaysOnTop = true
                    tag.StudsOffset = Vector3.new(0,3,0)
                    local label = Instance.new("TextLabel", tag)
                    label.Size = UDim2.new(1,0,1,0)
                    label.Text = fruit.Name .. "\nWeight: " .. (fruit:FindFirstChild("Weight") and fruit.Weight.Value or "?")
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1,1,0)
                    label.TextScaled = true
                end
            end
        end
    end
end)

addToggle("ESP: My Pets", contentFrames["ESP"], function(state)
    while state and task.wait(2) do
        for _, pet in pairs(workspace:GetDescendants()) do
            if pet:IsA("Model") and pet.Name == player.Name.."_Pet" then
                if not pet:FindFirstChild("NameTag") then
                    local tag = Instance.new("BillboardGui", pet)
                    tag.Name = "NameTag"
                    tag.Size = UDim2.new(0,100,0,40)
                    tag.AlwaysOnTop = true
                    tag.StudsOffset = Vector3.new(0,3,0)
                    local label = Instance.new("TextLabel", tag)
                    label.Size = UDim2.new(1,0,1,0)
                    label.Text = "My Pet"
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(0,1,1)
                    label.TextScaled = true
                end
            end
        end
    end
end)

--// Toggle GUI key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
