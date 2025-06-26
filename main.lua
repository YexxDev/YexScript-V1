-- YexScript Premium Hub
-- Made for Grow a Garden Simulator

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI Lib (custom Kavo-like with transparency)
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/Vt4pv0zY"))() -- Assume a working library, if not we'll build from scratch
local Window = Library.CreateLib("YEXSCRIPT HUB", Color3.fromRGB(140, 80, 255))

-- Loading Screen
local loadingGui = Instance.new("ScreenGui", game.CoreGui)
loadingGui.ResetOnSpawn = false
local frame = Instance.new("Frame", loadingGui)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
local title = Instance.new("TextLabel", frame)
title.Text = "YEX"
title.Size = UDim2.new(1, 0, 1, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.new(1, 1, 1)
task.wait(1)
title.Text = "SCRIPT"
task.wait(1)
loadingGui:Destroy()

-- Tabs
local mainTab = Window:NewTab("Main")
local shopTab = Window:NewTab("Shop")
local espTab = Window:NewTab("ESP")
local calcTab = Window:NewTab("Calculator")
local homeTab = Window:NewTab("Home")

-- MAIN TAB
local mainSection = mainTab:NewSection("Main Features")
mainSection:NewToggle("Auto Plant Seed", "Plant held seed at player's position", function(state)
    getgenv().autoPlant = state
    while getgenv().autoPlant do
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("seed") then
            local args = {[1] = workspace.Plots:GetChildren()[1].ClickDetector}
            fireclickdetector(unpack(args))
        end
        task.wait(0.5)
    end
end)\n
mainSection:NewToggle("Auto Watering Can", "Auto use watering can on your position", function(state)
    getgenv().autoWater = state
    while getgenv().autoWater do
        local tool = player.Character and player.Character:FindFirstChild("Watering Can")
        if tool then
            tool:Activate()
        end
        task.wait(0.3)
    end
end)

mainSection:NewToggle("Auto Collect Crops", "Collect fruits nearby", function(state)
    getgenv().autoCollect = state
    while getgenv().autoCollect do
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name == "Fruit" and v:FindFirstChild("ClickDetector") then
                if (v.Position - player.Character.HumanoidRootPart.Position).magnitude < 10 then
                    fireclickdetector(v.ClickDetector)
                end
            end
        end
        task.wait(1)
    end
end)

-- SHOP TAB
local shopSection = shopTab:NewSection("Auto Buy")
local seeds = {"Carrot","Strawberry","Blueberry","Tomato","Cauliflower","Watermelon","Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper","Prickly Pear","Laquat","Feijoa","Sugar Apple"}
local gears = {"Watering Can","Trowel","Recall Wrench","Basic Sprinkles","Advance Sprinkle","Godly Sprinkle","Tanning Mirror","Master Sprinkle","Cleaning Spray","Favorite Tool","Harvest Tool","Friendship Plot"}
local eggs = {"Common","Uncommon","Rare","Legendary","Mythic","Bug Egg","Presmatic Egg"}

shopSection:NewDropdown("Buy Seed", "Select a seed to auto buy", seeds, function(selected)
    -- Simulate remote buying
    print("Buying Seed:", selected)
end)

shopSection:NewDropdown("Buy Gear", "Select gear to buy", gears, function(selected)
    print("Buying Gear:", selected)
end)

shopSection:NewDropdown("Buy Egg", "Select egg to buy", eggs, function(selected)
    print("Buying Egg:", selected)
end)

-- ESP TAB
local espSection = espTab:NewSection("Visuals")
espSection:NewToggle("ESP Fruits", "Show fruits in your garden", function(state)
    getgenv().espFruit = state
    while getgenv().espFruit do
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name == "Fruit" and v:FindFirstChild("BillboardGui") == nil then
                local label = Instance.new("BillboardGui", v)
                label.Size = UDim2.new(0,100,0,40)
                label.Adornee = v
                label.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", label)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = v.Name .. "\nWeight: ???\nPrice: ???"
                txt.TextColor3 = Color3.new(1,1,1)
                txt.TextScaled = true
            end
        end
        task.wait(2)
    end
end)

espSection:NewToggle("ESP Pets", "Show your pets in garden", function(state)
    getgenv().espPets = state
    while getgenv().espPets do
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.Name == player.Name .. "_Pet" then
                if not v:FindFirstChild("BillboardGui") then
                    local label = Instance.new("BillboardGui", v)
                    label.Size = UDim2.new(0,100,0,40)
                    label.Adornee = v:FindFirstChild("Head") or v:FindFirstChildWhichIsA("BasePart")
                    label.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", label)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "Pet"
                    txt.TextColor3 = Color3.fromRGB(255, 200, 100)
                    txt.TextScaled = true
                end
            end
        end
        task.wait(2)
    end
end)

-- CALCULATOR TAB
local calcSection = calcTab:NewSection("Inventory Price")
calcSection:NewButton("Calculate Inventory Price", "Estimate value of all fruits", function()
    local total = 0
    -- Here you would pull real inventory and pricing if exposed
    print("[YEXSCRIPT] Estimated inventory price: R$"..total)
end)

-- HOME TAB
local homeSection = homeTab:NewSection("Links")
homeSection:NewButton("Copy Discord Link", "Copy invite to clipboard", function()
    setclipboard("https://discord.gg/YexScript")
end)
