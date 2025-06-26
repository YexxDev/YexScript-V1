-- Blox Fruits Auto Server Hop + Devil Fruit Collector
-- Premium Version | Sea Detection + Animated Hop Screen + Teleport + Fruit List

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- SETTINGS
local DesiredFruits = {
    "Rocket", "Bomb", "Spike", "Rubber", "Light", "Ice", "Magma",
    "Shadow", "Mammoth", "Dragon", "Leopard", "Kitsune", "Yeti",
    "Venom", "Gas", "Eagle", "Smoke", "Ghost", "Diamond", "Creation", "Dark",
    "Chop", "Spring", "Flame", "Sand"
}

-- LOADING SCREEN
local function createLoading()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "ServerHopLoader"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 0.1, 0)
    label.Position = UDim2.new(0.25, 0, 0.45, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 100, 255)
    label.TextSize = 32
    label.Font = Enum.Font.GothamBlack
    label.Text = ""

    local text = "SERVERHOP"
    for i = 1, #text do
        label.Text = label.Text .. text:sub(i, i)
        wait(0.5)
    end

    return gui
end

-- TELEPORT TO FRUIT
local function teleportToFruit(fruit)
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.CFrame + Vector3.new(0, 5, 0)
    end)
end

-- SEARCH FOR FRUIT
local function findDesiredFruit()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and table.find(DesiredFruits, obj.Name) then
            return obj
        end
    end
    return nil
end

-- AUTO-HOP
local function hopServer()
    local loadingGui = createLoading()
    wait(2)

    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=2&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end

-- SEA DETECTION
local function getCurrentSea()
    if game.PlaceId == 2753915549 then return 1 end
    if game.PlaceId == 4442272183 then return 2 end
    if game.PlaceId == 7449423635 then return 3 end
    return 0
end

-- MAIN LOOP
spawn(function()
    while task.wait(5) do
        local fruit = findDesiredFruit()
        if fruit then
            teleportToFruit(fruit)
            break
        else
            hopServer()
        end
    end
end)
