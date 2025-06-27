-- // YexScript: Pet Prediction & Server Hop UI (Grow a Garden) //
-- Requirements: KRNL or Synapse. Rayfield UI. Works only for **your** Garden.

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local desiredEgg = "Bug Egg"
local desiredPet = "Dragonfly"
local gameId = 14732615257
local scanning = false

-- Egg-to-Pet Dictionary (Estimation Table)
local EggTable = {
    ["Bug Egg"] = {"Dragonfly"},
    ["Mythic Egg"] = {"Red Fox"},
    ["Paradise Egg"] = {"Mimic Octopus"},
    ["Common"] = {},
    ["Rare"] = {},
    ["Uncommon"] = {},
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "YexScript - Egg Prediction Hub",
    LoadingTitle = "YEX",
    LoadingSubtitle = "Predicting...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "YexPredict",
        FileName = "EggScanner"
    },
    Discord = {
        Enabled = true,
        Invite = "yexhub",
        RememberJoins = true
    },
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Predictor", 4483362458)

MainTab:CreateDropdown({
    Name = "Select Egg Type",
    Options = {"Bug Egg", "Mythic Egg", "Paradise Egg", "Common", "Rare", "Uncommon"},
    CurrentOption = "Bug Egg",
    Callback = function(Value)
        desiredEgg = Value
    end
})

MainTab:CreateDropdown({
    Name = "Desired Pet",
    Options = {"Dragonfly", "Red Fox", "Mimic Octopus"},
    CurrentOption = "Dragonfly",
    Callback = function(Value)
        desiredPet = Value
    end
})

-- ESP Egg + Predicted Pet
local function createESP(part, labelText)
    local esp = Instance.new("BillboardGui", part)
    esp.Size = UDim2.new(0, 100, 0, 40)
    esp.AlwaysOnTop = true
    esp.Adornee = part

    local label = Instance.new("TextLabel", esp)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.TextScaled = true
end

-- Scan & ESP My Garden
local function scanEggs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("egg") and obj:FindFirstChild("Owner") then
            local owner = obj:FindFirstChild("Owner").Value
            if owner == LocalPlayer.Name and obj.Name == desiredEgg then
                local predictedPets = EggTable[desiredEgg] or {}
                local matched = table.find(predictedPets, desiredPet)
                createESP(obj:FindFirstChildOfClass("Part") or obj.PrimaryPart, obj.Name .. "\nPet: " .. (predictedPets[1] or "Unknown"))
                if matched then return true end
            end
        end
    end
    return false
end

-- Server Hop Logic
local function serverHop()
    local cursor = ""
    local tried = {}
    repeat
        local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=2&limit=100&cursor=" .. cursor
        local response = HttpService:JSONDecode(game:HttpGet(url))
        for _, server in ipairs(response.data) do
            if server.playing < server.maxPlayers and not tried[server.id] then
                tried[server.id] = true
                TeleportService:TeleportToPlaceInstance(gameId, server.id, LocalPlayer)
                task.wait(7)
            end
        end
        cursor = response.nextPageCursor
    until not cursor
end

MainTab:CreateButton({
    Name = "Start Predict & Hop",
    Callback = function()
        if scanning then return end
        scanning = true
        local match = scanEggs()
        if match then
            Rayfield:Notify({Title="YexScript", Content="✅ Found Matching Pet in This Server!", Duration=5})
        else
            Rayfield:Notify({Title="YexScript", Content="❌ Not Found. Hopping Server...", Duration=5})
            serverHop()
        end
        scanning = false
    end
})
