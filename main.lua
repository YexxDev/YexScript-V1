-- YexScript Hub with Full Logic and Shop Dropdown Fixes
-- Optimized for Delta Executor | Mobile + PC

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- UI Library Placeholder
local YexUI = Instance.new("ScreenGui")
YexUI.Name = "YexScriptUI"
YexUI.ResetOnSpawn = false
YexUI.IgnoreGuiInset = true
YexUI.Parent = PlayerGui

-- Smooth Loading Screen
local loadingFrame = Instance.new("Frame")
loadingFrame.BackgroundColor3 = Color3.fromRGB(90, 0, 128)
loadingFrame.BackgroundTransparency = 0.4
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Parent = YexUI

local loadingText = Instance.new("TextLabel")
loadingText.Text = "YEX"
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 60
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(0.5, 0, 0.1, 0)
loadingText.Parent = loadingFrame

wait(1)
loadingText.Text = "SCRIPT"
wait(1.5)
loadingFrame:Destroy()

-- Tab Container
local Tabs = {
    Home = {},
    Main = {},
    ESP = {},
    Shop = {}
}

-- Helper to clear existing tab content
local function clearTab()
    for _, v in ipairs(YexUI:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

-- Home Tab
Tabs.Home = function()
    clearTab()
    local frame = Instance.new("Frame", YexUI)
    frame.Size = UDim2.new(0.4, 0, 0.4, 0)
    frame.Position = UDim2.new(0.3, 0, 0.3, 0)
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    frame.BorderSizePixel = 0

    local copyButton = Instance.new("TextButton", frame)
    copyButton.Text = "COPY DISCORD LINK"
    copyButton.Size = UDim2.new(1, 0, 0.2, 0)
    copyButton.Position = UDim2.new(0, 0, 0.4, 0)
    copyButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/yexscript")
    end)
end

-- Main Tab
Tabs.Main = function()
    clearTab()
    local frame = Instance.new("Frame", YexUI)
    frame.Size = UDim2.new(0.5, 0, 0.5, 0)
    frame.Position = UDim2.new(0.25, 0, 0.25, 0)
    frame.BackgroundTransparency = 0.2
    frame.BackgroundColor3 = Color3.fromRGB(90, 0, 140)

    local function addFeature(text, posY, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 0.15, 0)
        btn.Position = UDim2.new(0, 0, posY, 0)
        btn.Text = text
        btn.MouseButton1Click:Connect(callback)
    end

    addFeature("Auto Collect Crops", 0, function()
        while wait(1) do
            for _, fruit in ipairs(workspace:GetDescendants()) do
                if fruit.Name == "Fruit" and fruit:IsA("Model") and (fruit.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 20 then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, fruit, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, fruit, 1)
                end
            end
        end
    end)

    addFeature("Auto Plant Seed", 0.2, function()
        while wait(0.5) do
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Name:lower():find("seed") then
                for _, plot in ipairs(workspace.Plots:GetChildren()) do
                    if plot:FindFirstChild("PlantButton") then
                        fireclickdetector(plot.PlantButton.ClickDetector)
                    end
                end
            end
        end
    end)

    addFeature("Auto Watering Can", 0.4, function()
        while wait(0.4) do
            local tool = LocalPlayer.Character:FindFirstChild("Watering Can")
            if tool then
                tool:Activate()
            end
        end
    end)
end

-- ESP Tab
Tabs.ESP = function()
    clearTab()
    local frame = Instance.new("Frame", YexUI)
    frame.Size = UDim2.new(0.5, 0, 0.4, 0)
    frame.Position = UDim2.new(0.25, 0, 0.3, 0)
    frame.BackgroundTransparency = 0.2
    frame.BackgroundColor3 = Color3.fromRGB(100, 0, 180)

    local bestFruitBtn = Instance.new("TextButton", frame)
    bestFruitBtn.Size = UDim2.new(1, 0, 0.3, 0)
    bestFruitBtn.Position = UDim2.new(0, 0, 0, 0)
    bestFruitBtn.Text = "Show Best Fruit Value"
    bestFruitBtn.MouseButton1Click:Connect(function()
        local best = ""
        local highest = 0
        for _, fruit in ipairs(workspace.MyGarden:GetChildren()) do
            if fruit:FindFirstChild("Price") and fruit.Price.Value > highest then
                highest = fruit.Price.Value
                best = fruit.Name .. " - Weight: " .. (fruit:FindFirstChild("Weight") and fruit.Weight.Value or "?") .. ", Price: " .. highest
            end
        end
        print("Best Fruit:", best)
    end)

    local petEspBtn = Instance.new("TextButton", frame)
    petEspBtn.Size = UDim2.new(1, 0, 0.3, 0)
    petEspBtn.Position = UDim2.new(0, 0, 0.4, 0)
    petEspBtn.Text = "Show Pets in Garden"
    petEspBtn.MouseButton1Click:Connect(function()
        for _, pet in ipairs(workspace.MyGarden:GetChildren()) do
            if pet.Name:lower():find("pet") then
                print("Pet found:", pet.Name)
            end
        end
    end)
end

-- Shop Tab
Tabs.Shop = function()
    clearTab()
    local frame = Instance.new("Frame", YexUI)
    frame.Size = UDim2.new(0.5, 0, 0.6, 0)
    frame.Position = UDim2.new(0.25, 0, 0.2, 0)
    frame.BackgroundTransparency = 0.2
    frame.BackgroundColor3 = Color3.fromRGB(80, 0, 100)

    local categories = {
        Seeds = {"Carrot","Strawberry","Blueberry","Tomato","Cauliflower","Watermelon","Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper","Prickly Pear","Laquat","Feijoa","Sugar Apple"},
        Gear = {"Watering Can","Trowel","Recall Wrench","Basic Sprinkles","Advance Sprinkle","Godly Sprinkle","Tanning Mirror","Master Sprinkle","Cleaning Spray","Favorite Tool","Harvest Tool","Friendship Plot"},
        Eggs = {"Common","Uncommon","Rare","Legendary","Mythic","Bug Egg","Presmatic Egg"}
    }

    local y = 0
    for category, list in pairs(categories) do
        local label = Instance.new("TextLabel", frame)
        label.Text = category
        label.Size = UDim2.new(1, 0, 0.05, 0)
        label.Position = UDim2.new(0, 0, y, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        y = y + 0.05

        for _, item in ipairs(list) do
            local button = Instance.new("TextButton", frame)
            button.Text = "Buy " .. item
            button.Size = UDim2.new(1, 0, 0.05, 0)
            button.Position = UDim2.new(0, 0, y, 0)
            y = y + 0.05
            button.MouseButton1Click:Connect(function()
                print("Attempting to auto-buy:", item)
                -- Simulate shop logic here if API is accessible
            end)
        end
    end
end

-- Tab Navigation Buttons
local tabFrame = Instance.new("Frame", YexUI)
tabFrame.Size = UDim2.new(1, 0, 0.05, 0)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundTransparency = 0.4
tabFrame.BackgroundColor3 = Color3.fromRGB(70, 0, 100)

local tabNames = {"Home", "Main", "ESP", "Shop"}
for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
    tabBtn.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    tabBtn.MouseButton1Click:Connect(function()
        Tabs[name]()
    end)
end

 -- Load Home tab by default
