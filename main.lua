-- YexScript Hub for Grow a Garden - Full Version
-- Optimized for Delta Executor, PC/Mobile support
-- Includes loading screen, ESP, auto actions, and shop features

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--[[
    Loading Screen
]]--
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false
loadingGui.Name = "YexScriptLoading"

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
bg.BackgroundTransparency = 0.3

local label1 = Instance.new("TextLabel", bg)
label1.Text = "YEX"
label1.Size = UDim2.new(1, 0, 0.2, 0)
label1.Position = UDim2.new(0, 0, 0.4, 0)
label1.Font = Enum.Font.GothamBlack
label1.TextColor3 = Color3.new(1, 1, 1)
label1.TextScaled = true
label1.BackgroundTransparency = 1

local label2 = Instance.new("TextLabel", bg)
label2.Text = ""
label2.Size = UDim2.new(1, 0, 0.2, 0)
label2.Position = UDim2.new(0, 0, 0.55, 0)
label2.Font = Enum.Font.GothamBlack
label2.TextColor3 = Color3.new(1, 1, 1)
label2.TextScaled = true
label2.BackgroundTransparency = 1

wait(1)
label2.Text = "SCRIPT"
wait(1)
loadingGui:Destroy()

--[[
    UI Library Setup
]]--
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("YEXSCRIPT HUB", "Midnight")

local Home = Window:NewTab("Home")
local HomeSection = Home:NewSection("Welcome")
HomeSection:NewButton("Copy Discord Link", "Copy invite", function()
    setclipboard("https://discord.gg/YEXSCRIPT")
end)

local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Garden Automation")

MainSection:NewToggle("Auto Plant Seed", "Plants held seed", function(state)
    getgenv().AutoPlant = state
    while getgenv().AutoPlant do
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("seed") then
            local plot = workspace:FindFirstChild("Plots")
            if plot then
                fireclickdetector(plot:FindFirstChildOfClass("ClickDetector"))
            end
        end
        wait(0.25)
    end
end)

MainSection:NewToggle("Auto Watering Can", "Waters standing location", function(state)
    getgenv().AutoWater = state
    while getgenv().AutoWater do
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Watering Can")
        if tool then
            tool:Activate()
        end
        wait(0.25)
    end
end)

MainSection:NewToggle("Auto Collect Crops", "Collects nearby fruits", function(state)
    getgenv().AutoCollect = state
    while getgenv().AutoCollect do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") and obj.Parent.Name == "Fruit" then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
            end
        end
        wait(0.25)
    end
end)

local ESP = Window:NewTab("ESP")
local ESPSection = ESP:NewSection("Visual Info")

ESPSection:NewButton("Best Fruit ESP", "Shows most valuable fruit", function()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit.Name == "Fruit" and fruit:IsA("Model") and fruit:FindFirstChild("Price") then
            local billboard = Instance.new("BillboardGui", fruit)
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.AlwaysOnTop = true
            billboard.Adornee = fruit:FindFirstChild("Head") or fruit.PrimaryPart

            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 255, 0)
            text.Text = fruit.Name .. " | Weight: " .. (fruit:FindFirstChild("Weight") and fruit.Weight.Value or "?") .. " | R$: " .. fruit.Price.Value
            text.TextScaled = true
        end
    end
end)

ESPSection:NewButton("Pet ESP (Your Garden Only)", "Show your pets", function()
    for _, pet in pairs(workspace:GetDescendants()) do
        if pet:IsA("Model") and pet:FindFirstChild("Owner") and pet.Owner.Value == LocalPlayer.Name then
            local billboard = Instance.new("BillboardGui", pet)
            billboard.Size = UDim2.new(0, 80, 0, 20)
            billboard.AlwaysOnTop = true
            billboard.Adornee = pet.PrimaryPart or pet:FindFirstChildOfClass("Part")

            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.new(1, 1, 1)
            text.Text = pet.Name .. " (Pet)"
            text.TextScaled = true
        end
    end
end)

local Shop = Window:NewTab("Shop")
local ShopSection = Shop:NewSection("Auto Buy Features")

local seeds = {"Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower", "Watermelon", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Laquat", "Feijoa", "Sugar Apple"}
local gears = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkles", "Advance Sprinkle", "Godly Sprinkle", "Tanning Mirror", "Master Sprinkle", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Plot"}
local eggs = {"Common", "Uncommon", "Rare", "Legendary", "Mythic", "Bug Egg", "Presmatic Egg"}

ShopSection:NewDropdown("Buy Seed", "Auto buy seed", seeds, function(option)
    game:GetService("ReplicatedStorage").Events.Buy:FireServer("Seed", option)
end)

ShopSection:NewDropdown("Buy Gear", "Auto buy gear", gears, function(option)
    game:GetService("ReplicatedStorage").Events.Buy:FireServer("Gear", option)
end)

ShopSection:NewDropdown("Buy Egg", "Auto buy egg", eggs, function(option)
    game:GetService("ReplicatedStorage").Events.Buy:FireServer("Egg", option)
end)
