-- YexScript Hub Final Version for Grow a Garden

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI LIBRARY (redz-style small GUI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/UILibrary"))()
local Window = Library.CreateLib("YEXSCRIPT HUB", "DarkTheme")

-- Toggle UI
local toggleUI = Instance.new("ScreenGui", game.CoreGui)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "YEXSCRIPT HUB"
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = toggleUI
local frameVisible = true

toggleBtn.MouseButton1Click:Connect(function()
    frameVisible = not frameVisible
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:FindFirstChild("MainFrame") then
            v.MainFrame.Visible = frameVisible
        end
    end
end)

-- Notify Loaded
game.StarterGui:SetCore("SendNotification", {
    Title = "YEXSCRIPT HUB",
    Text = "Successfully Executed!",
    Duration = 4
})

-- HOME TAB
local HomeTab = Window:NewTab("Home")
local HomeSection = HomeTab:NewSection("Utilities")
HomeSection:NewButton("Copy Discord Link", "Copy server invite", function()
    setclipboard("https://discord.gg/YOUR_INVITE_CODE")
end)

-- MAIN TAB
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Planting")

-- Dropdown speed
local speedOption = "Normal"
MainSection:NewDropdown("Plant Speed", "Select speed", {"Instant", "Fast", "Normal"}, function(option)
    speedOption = option
end)

-- Auto Plant Seed
MainSection:NewButton("Plant Seed", "Auto plant held seed on plot", function()
    local function getSeedTool()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("SeedScript") then
                return item
            end
        end
        return nil
    end

    local delayMap = {["Instant"] = 0.05, ["Fast"] = 0.25, ["Normal"] = 0.6}
    local delayTime = delayMap[speedOption] or 0.5

    while true do
        local seed = getSeedTool()
        if seed then
            LocalPlayer.Character.Humanoid:EquipTool(seed)
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            game:GetService("ReplicatedStorage").Plant:FireServer(pos)
        end
        task.wait(delayTime)
    end
end)

-- Auto Watering Can
MainSection:NewButton("Auto Watering Can", "Auto click water", function()
    while true do
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        game:GetService("ReplicatedStorage").Water:FireServer(pos)
        task.wait(0.25)
    end
end)

-- ESP TAB
local ESPTab = Window:NewTab("ESP")
local ESPSection = ESPTab:NewSection("Visual Tools")

-- Fruit ESP
ESPSection:NewButton("Show Best Fruit Value", "Visual fruit value", function()
    for _, fruit in pairs(workspace.MyGarden.Fruits:GetChildren()) do
        local name = fruit.Name
        local weight = fruit:FindFirstChild("Weight") and fruit.Weight.Value or "N/A"
        local price = fruit:FindFirstChild("Price") and fruit.Price.Value or "N/A"
        print("[Best Fruit] "..name.." | Weight: "..tostring(weight).." | Price: "..tostring(price))

        local tag = Instance.new("BillboardGui", fruit)
        tag.Size = UDim2.new(0, 100, 0, 40)
        tag.AlwaysOnTop = true
        tag.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = name.." | "..weight.."kg | $"..price
        label.TextColor3 = Color3.new(1, 1, 0)
        label.TextScaled = true
        label.BackgroundTransparency = 1
    end
end)

-- Pet ESP
ESPSection:NewButton("Pet ESP", "Show your pets", function()
    for _, pet in pairs(workspace.MyGarden.Pets:GetChildren()) do
        local tag = Instance.new("BillboardGui", pet)
        tag.Size = UDim2.new(0, 100, 0, 40)
        tag.AlwaysOnTop = true
        tag.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = pet.Name
        label.TextColor3 = Color3.new(0, 1, 1)
        label.TextScaled = true
        label.BackgroundTransparency = 1
    end
end)
