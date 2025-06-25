-- YexScript Hub (Updated with Working Logic)
-- Fully working UI with ESP, Auto Plant, Shop System

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Loading Screen
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "YexScriptLoading"
loadingGui.IgnoreGuiInset = true

local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
loadingFrame.BackgroundTransparency = 0.3
loadingFrame.BorderSizePixel = 0
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.Size = UDim2.new(0, 300, 0, 100)
loadingFrame.Visible = true

local label1 = Instance.new("TextLabel", loadingFrame)
label1.Size = UDim2.new(1, 0, 0.5, 0)
label1.Position = UDim2.new(0, 0, 0, 0)
label1.BackgroundTransparency = 1
label1.TextColor3 = Color3.fromRGB(180, 100, 255)
label1.Text = "YEX"
label1.Font = Enum.Font.GothamBlack
label1.TextSize = 36
label1.TextTransparency = 1

local label2 = Instance.new("TextLabel", loadingFrame)
label2.Size = UDim2.new(1, 0, 0.5, 0)
label2.Position = UDim2.new(0, 0, 0.5, 0)
label2.BackgroundTransparency = 1
label2.TextColor3 = Color3.fromRGB(180, 100, 255)
label2.Text = "SCRIPT"
label2.Font = Enum.Font.GothamBlack
label2.TextSize = 36
label2.TextTransparency = 1

TweenService:Create(label1, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(1)
TweenService:Create(label2, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(1.5)
loadingGui:Destroy()

-- UI Framework
local library = loadstring(game:HttpGet("https://pastebin.com/raw/edJT9EGX"))()
local ui = library:CreateWindow("YEXSCRIPT HUB", Color3.fromRGB(130, 100, 255), "Grow a Garden")

-- Tabs
local homeTab = ui:CreateTab("Home")
homeTab:CreateButton("Copy Discord Link", function()
    setclipboard("https://discord.gg/YOUR-LINK")
end)

local mainTab = ui:CreateTab("Main")
mainTab:CreateToggle("Auto Collect Crops", false, function(state)
    if state then
        task.spawn(function()
            while state do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name == "Fruit" then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

mainTab:CreateToggle("Auto Plant Seed", false, function(state)
    if state then
        task.spawn(function()
            while state do
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Plant") then
                    fireclickdetector(workspace:FindFirstChild("Plot").ClickDetector)
                end
                task.wait(0.3)
            end
        end)
    end
end)

mainTab:CreateToggle("Auto Watering Can", false, function(state)
    if state then
        task.spawn(function()
            while state do
                local tool = LocalPlayer.Character:FindFirstChild("Watering Can")
                if tool then
                    tool:Activate()
                end
                task.wait(0.25)
            end
        end)
    end
end)

-- ESP Tab
local espTab = ui:CreateTab("ESP")
espTab:CreateToggle("ESP Fruits (Name, Weight)", false, function(state)
    if state then
        task.spawn(function()
            while state do
                for _, fruit in pairs(workspace:GetDescendants()) do
                    if fruit:IsA("Model") and fruit.Name == "Fruit" and not fruit:FindFirstChild("YexESP") then
                        local label = Instance.new("BillboardGui", fruit)
                        label.Name = "YexESP"
                        label.Size = UDim2.new(0, 100, 0, 40)
                        label.StudsOffset = Vector3.new(0, 3, 0)
                        label.AlwaysOnTop = true

                        local txt = Instance.new("TextLabel", label)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.new(1, 1, 1)
                        txt.Text = fruit:GetAttribute("Name") .. " | W: " .. tostring(fruit:GetAttribute("Weight"))
                        txt.TextScaled = true
                        txt.Font = Enum.Font.Gotham
                    end
                end
                task.wait(2)
            end
        end)
    else
        for _, gui in pairs(workspace:GetDescendants()) do
            if gui:IsA("BillboardGui") and gui.Name == "YexESP" then
                gui:Destroy()
            end
        end
    end
end)

espTab:CreateToggle("ESP Pets (Your Garden Only)", false, function(state)
    if state then
        task.spawn(function()
            while state do
                for _, pet in pairs(workspace:GetDescendants()) do
                    if pet:IsA("Model") and pet.Name == "Pet" and not pet:FindFirstChild("YexPetESP") then
                        local tag = Instance.new("BillboardGui", pet)
                        tag.Name = "YexPetESP"
                        tag.Size = UDim2.new(0, 100, 0, 30)
                        tag.StudsOffset = Vector3.new(0, 2, 0)
                        tag.AlwaysOnTop = true
                        local text = Instance.new("TextLabel", tag)
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255, 200, 0)
                        text.Text = pet:GetAttribute("PetName") or "Pet"
                        text.Font = Enum.Font.Gotham
                        text.TextScaled = true
                    end
                end
                task.wait(1.5)
            end
        end)
    else
        for _, gui in pairs(workspace:GetDescendants()) do
            if gui:IsA("BillboardGui") and gui.Name == "YexPetESP" then
                gui:Destroy()
            end
        end
    end
end)

-- Shop Tab
local shopTab = ui:CreateTab("Shop")
local seeds = {"Carrot","Strawberry","Blueberry","Tomato","Cauliflower","Watermelon","Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper","Prickly Pear","Laquat","Feijoa","Sugar Apple"}
local gears = {"Watering Can","Trowel","Recall Wrench","Basic Sprinkles","Advance Sprinkle","Godly Sprinkle","Tanning Mirror","Master Sprinkle","Cleaning Spray","Favorite Tool","Harvest Tool","Friendship Plot"}
local eggs = {"Common","Uncommon","Rare","Legendary","Mythic","Bug Egg","Presmatic Egg"}

shopTab:CreateDropdown("Buy Seed", seeds, function(selected)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuySeed"):FireServer(selected)
end)

shopTab:CreateDropdown("Buy Gear", gears, function(selected)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyGear"):FireServer(selected)
end)

shopTab:CreateDropdown("Buy Egg", eggs, function(selected)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyEgg"):FireServer(selected)
end)

-- Toggle UI with Right Shift
library:CreateKeybind(Enum.KeyCode.RightShift, function()
    ui:ToggleUI()
end)
