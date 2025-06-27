local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- Variables
local desiredPet = ""
local selectedEgg = ""

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "YexScript - Pet Predictor",
    LoadingTitle = "YEX",
    LoadingSubtitle = "SCRIPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "YexScriptPredict",
        FileName = "YEX_Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("🐣 Egg Prediction", 4483362458)

MainTab:CreateDropdown({
    Name = "Select Egg Type",
    Options = { "Common", "Uncommon", "Rare", "Legendary", "Mythic", "Bug Egg", "Paradise Egg" },
    CurrentOption = "Common",
    Callback = function(egg)
        selectedEgg = egg
    end
})

MainTab:CreateDropdown({
    Name = "Select Desired Pet",
    Options = { "Dragonfly", "Raccon", "Red Fox", "Mimic Octopus" },
    CurrentOption = "Dragonfly",
    Callback = function(pet)
        desiredPet = pet
    end
})

-- ESP Function
local function CreateESP(target, labelText)
    if not target or not target:IsA("Model") then return end
    local head = target:FindFirstChild("Head") or target:FindFirstChildOfClass("Part")
    if not head then return end

    local Billboard = Instance.new("BillboardGui", head)
    Billboard.Size = UDim2.new(0, 200, 0, 40)
    Billboard.AlwaysOnTop = true
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.Name = "ESP"

    local Label = Instance.new("TextLabel", Billboard)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 0)
    Label.TextScaled = true
end

-- Prediction & ESP Scan Function
local function ScanYourEggs()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("egg") and obj:FindFirstChild("Owner") then
            local owner = obj:FindFirstChild("Owner")
            if owner.Value == LocalPlayer then
                local predicted = desiredPet
                CreateESP(obj, obj.Name .. " ➜ " .. predicted)
                return predicted
            end
        end
    end
    return nil
end

-- Server Hop Logic
local function ServerHop()
    local PlaceId = game.PlaceId
    local servers = {}
    local cursor = ""

    repeat
        local response = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=2&limit=100&cursor=" .. cursor)
        local body = HttpService:JSONDecode(response)
        for _, server in pairs(body.data) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
        cursor = body.nextPageCursor
        wait()
    until not cursor

    for _, serverId in ipairs(servers) do
        TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
        wait(5)
    end
end

MainTab:CreateButton({
    Name = "Start Predict & Hop",
    Callback = function()
        local match = ScanYourEggs()
        if match and match:lower() == desiredPet:lower() then
            Rayfield:Notify({
                Title = "🎉 Match Found!",
                Content = desiredPet .. " is predicted!",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "❌ Not Found",
                Content = "Server hopping...",
                Duration = 3
            })
            ServerHop()
        end
    end
})

