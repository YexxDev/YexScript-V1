-- // YexScript Devil Fruit Finder UI by ChatGPT

-- Settings
local fruitList = {
    "Rocket", "Bomb", "Spike", "Rubber", "Light", "Ice", "Magma",
    "Shadow", "Mammoth", "Dragon", "Leopard", "Kitsune", "Yeti",
    "Venom", "Gas", "Eagle", "Smoke", "Ghost", "Diamond", "Creation",
    "Dark", "Chop", "Spring", "Flame", "Sand"
}

-- UI Setup
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
screenGui.Name = "YexScriptDFFinder"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 120)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "YexScript: DF Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local button = Instance.new("TextButton", mainFrame)
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.5, -10)
button.Text = "Start Server Hop"
button.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.Gotham
button.TextSize = 16

local loadingText = Instance.new("TextLabel", mainFrame)
loadingText.Size = UDim2.new(1, 0, 0, 25)
loadingText.Position = UDim2.new(0, 0, 1, -20)
loadingText.Text = ""
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(180, 180, 180)
loadingText.Font = Enum.Font.Code
loadingText.TextSize = 14

-- ESP Function
local function addESP(part, name)
    local billboard = Instance.new("BillboardGui", part)
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "🍇 " .. name
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextScaled = true
    label.BackgroundTransparency = 1
end

-- Check for fruit
local function checkForFruit()
    local found = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and table.find(fruitList, obj.Name) then
            addESP(obj.Handle or obj:FindFirstChildOfClass("Part"), obj.Name)
            found = true
        end
    end
    return found
end

-- Server hop
local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local PlaceID = game.PlaceId

    loadingText.Text = "S"
    for _, letter in ipairs({"E","R","V","E","E","R","H","O","P","."}) do
        wait(0.5)
        loadingText.Text = loadingText.Text .. letter
    end

    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=2&limit=100"))
    for _, v in pairs(servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(PlaceID, v.id, plr)
            break
        end
    end
end

-- Button logic
button.MouseButton1Click:Connect(function()
    loadingText.Text = "Scanning..."
    local found = checkForFruit()
    if found then
        loadingText.Text = "✅ Devil Fruit Found!"
    else
        loadingText.Text = "❌ No Fruit Found. Hopping..."
        wait(1)
        serverHop()
    end
end)
