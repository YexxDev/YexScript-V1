
-- Grow a Garden Auto GUI Script (ZEN UPDATE) by Yexel
-- Features: Auto Plant, Auto Water, Auto Hatch, Tranquil Collect, Weather Toggle, Shops, Full GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "GrowAGardenGUI"

-- Toggle Button (Z Icon)
local toggleBtn = Instance.new("ImageButton", ScreenGui)
toggleBtn.Name = "ToggleGUI"
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Image = "rbxassetid://17582948232" -- Z icon
toggleBtn.BackgroundTransparency = 1

-- Main Frame
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Name = "MainFrame"
mainFrame.Position = UDim2.new(0, 60, 0, 50)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

-- Tabs
local tabs = {"Main", "Zen", "Egg", "Shop", "Misc"}
local tabFrames = {}

local function createTabButton(tabName, index)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Text = tabName
    btn.Size = UDim2.new(0, 80, 0, 25)
    btn.Position = UDim2.new(0, (index - 1) * 80, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do frame.Visible = false end
        tabFrames[tabName].Visible = true
    end)
end

for i, tabName in ipairs(tabs) do
    createTabButton(tabName, i)
    local frame = Instance.new("Frame", mainFrame)
    frame.Position = UDim2.new(0, 0, 0, 30)
    frame.Size = UDim2.new(1, 0, 1, -30)
    frame.Visible = i == 1
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabFrames[tabName] = frame
end

-- Utility Functions
local function createToggle(parent, text, callback)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = text .. ": OFF"
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- Feature Implementations
local autoPlant = false
local autoWater = false
local autoTranquil = false
local autoHatch = false
local autoEggPlant = false

RunService.RenderStepped:Connect(function()
    if autoPlant then
        local tool = Player.Character:FindFirstChild("Seed Bag")
        if tool then
            for _, plot in ipairs(workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("ClickDetector") and not plot:FindFirstChild("Plant") then
                    fireclickdetector(plot.ClickDetector)
                end
            end
        end
    end

    if autoWater then
        local tool = Player.Character:FindFirstChild("Watering Can")
        if tool then
            for _, plot in ipairs(workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("Plant") and plot:FindFirstChild("Thirst") then
                    fireclickdetector(plot.ClickDetector)
                end
            end
        end
    end

    if autoTranquil then
        for _, plant in ipairs(workspace.Tranquil:GetChildren()) do
            if plant:IsA("Model") and plant:FindFirstChild("ClickDetector") then
                fireclickdetector(plant.ClickDetector)
            end
        end
    end

    if autoHatch then
        for _, egg in ipairs(workspace.Eggs:GetChildren()) do
            if egg:FindFirstChild("ClickDetector") then
                fireclickdetector(egg.ClickDetector)
            end
        end
    end

    if autoEggPlant then
        local tool = Player.Character:FindFirstChild("Egg Planting Tool")
        if tool then
            for _, plot in ipairs(workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("ClickDetector") and not plot:FindFirstChild("Plant") then
                    fireclickdetector(plot.ClickDetector)
                end
            end
        end
    end
end)

-- Main Tab
createToggle(tabFrames["Main"], "Auto Plant Seeds", function(state) autoPlant = state end)
createToggle(tabFrames["Main"], "Auto Watering Can", function(state) autoWater = state end)

-- Zen Tab
createToggle(tabFrames["Zen"], "Auto Collect Tranquil Plants", function(state) autoTranquil = state end)
createButton(tabFrames["Zen"], "Open Tranquil Shop", function()
    local shopBtn = Player.PlayerGui:FindFirstChild("UI"):FindFirstChild("TranquilShop")
    if shopBtn then shopBtn.Visible = true end
end)

-- Egg Tab
createToggle(tabFrames["Egg"], "Auto Hatch Eggs", function(state) autoHatch = state end)
createToggle(tabFrames["Egg"], "Auto Plant Eggs", function(state) autoEggPlant = state end)

-- Shop Tab
createButton(tabFrames["Shop"], "Open Seed Shop", function()
    local shop = Player.PlayerGui:FindFirstChild("UI"):FindFirstChild("SeedShop")
    if shop then shop.Visible = true end
end)
createButton(tabFrames["Shop"], "Open Gear Shop", function()
    local gear = Player.PlayerGui:FindFirstChild("UI"):FindFirstChild("GearShop")
    if gear then gear.Visible = true end
end)
createButton(tabFrames["Shop"], "Open Tranquil Shop", function()
    local tranquil = Player.PlayerGui:FindFirstChild("UI"):FindFirstChild("TranquilShop")
    if tranquil then tranquil.Visible = true end
end)

-- Misc Tab
local fakeWeatherEnabled = false
createToggle(tabFrames["Misc"], "Fake Weather", function(state)
    fakeWeatherEnabled = state
    if state then
        game.Lighting.TimeOfDay = "18:00:00"
        game.Lighting.FogEnd = 100
    else
        game.Lighting.TimeOfDay = "12:00:00"
        game.Lighting.FogEnd = 1000
    end
end)

-- Toggle GUI
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
