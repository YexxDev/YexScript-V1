-- Load Official Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- Create the UI
local Window = Rayfield:CreateWindow({
    Name = "YexScript - Egg Predictor",
    LoadingTitle = "YEXSCRIPT",
    LoadingSubtitle = "Egg Prediction + Server Hop",
    ConfigurationSaving = {
        Enabled = false
    }
})

local desiredPet = "Dragonfly"
local selectedEgg = "Bug Egg"

local MainTab = Window:CreateTab("Main", 4483362458)

-- Egg Selection
MainTab:CreateDropdown({
    Name = "Select Egg Type",
    Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
    CurrentOption = "Bug Egg",
    Callback = function(Value)
        selectedEgg = Value
    end
})

-- Desired Pet
MainTab:CreateDropdown({
    Name = "Select Desired Pet",
    Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
    CurrentOption = "Dragonfly",
    Callback = function(Value)
        desiredPet = Value
    end
})

-- ESP Function
local function highlightEgg(eggModel, petName)
    if not eggModel:FindFirstChild("ESP") and eggModel:FindFirstChildWhichIsA("Part") then
        local gui = Instance.new("BillboardGui", eggModel)
        gui.Name = "ESP"
        gui.Size = UDim2.new(0, 120, 0, 40)
        gui.Adornee = eggModel:FindFirstChildWhichIsA("Part")
        gui.AlwaysOnTop = true

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = petName .. " (Predicted)"
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.BackgroundColor3 = Color3.new(0, 0, 0)
    end
end

-- Scan Your Own Eggs
local function scanMyEggs()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("egg") and obj:FindFirstChild("Owner") then
            local owner = obj:FindFirstChild("Owner")
            if owner and owner.Value == LocalPlayer.Name then
                local predict = obj:FindFirstChild("PredictedPet") or obj:FindFirstChild("Prediction")
                if predict and predict.Value == desiredPet then
                    highlightEgg(obj, predict.Value)
                    return true
                end
            end
        end
    end
    return false
end

-- Server Hop Logic
local function hopServers()
    local cursor = ""
    local serverList = {}

    repeat
        local raw = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor)
        local data = HttpService:JSONDecode(raw)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers then
                table.insert(serverList, server.id)
            end
        end
        cursor = data.nextPageCursor
        wait()
    until not cursor

    for _, id in ipairs(serverList) do
        TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
        wait(5)
    end
end

-- Main Button to Start
MainTab:CreateButton({
    Name = "Start Predict & Hop",
    Callback = function()
        local found = scanMyEggs()
        if found then
            Rayfield:Notify({
                Title = "✅ Match Found",
                Content = "Predicted Pet: " .. desiredPet,
                Duration = 5
            })
        else
            Rayfield:Notify({
                Title = "❌ Not Found",
                Content = "Hopping servers...",
                Duration = 4
            })
            hopServers()
        end
    end
})

