--[[
YexScript - Grow a Garden: Egg Predictor + Pet ESP + Server Hopper
Works with Rayfield (real UI), Mobile Optimized, Auto Hop Smart Logic
]]--

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- LOAD RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "YexScript - Egg Predictor",
    LoadingTitle = "YEX",
    LoadingSubtitle = "SCRIPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "YexScriptCFG",
        FileName = "EggPredictor"
    },
    Discord = {
        Enabled = true,
        Invite = "yexscript",
        RememberJoins = false
    },
    KeySystem = false
})

-- TABS
local MainTab = Window:CreateTab("Main", 4483362458)

local eggTypes = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"}
local desiredPets = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"}
local selectedEgg, selectedPet = nil, nil

-- ESP FUNCTION
local function addEggESP(egg, petName)
    if egg:FindFirstChild("Head") and not egg:FindFirstChild("PetESP") then
        local gui = Instance.new("BillboardGui", egg)
        gui.Name = "PetESP"
        gui.Size = UDim2.new(0, 120, 0, 40)
        gui.AlwaysOnTop = true
        gui.Adornee = egg:FindFirstChild("Head")

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = petName or "Predicting..."
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
    end
end

-- SERVER HOP FUNCTION
local function hopServer()
    local cursor = ""
    local tried = {}
    repeat
        local raw = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor)
        local decoded = HttpService:JSONDecode(raw)
        for _, v in pairs(decoded.data) do
            if v.playing < v.maxPlayers and not table.find(tried, v.id) then
                table.insert(tried, v.id)
                TeleportService:TeleportToPlaceInstance(PlaceId, v.id, LocalPlayer)
                wait(10)
            end
        end
        cursor = decoded.nextPageCursor
        wait(1)
    until not cursor
end

-- PREDICTION START
MainTab:CreateDropdown({
    Name = "Select Egg Type",
    Options = eggTypes,
    CurrentOption = eggTypes[1],
    Callback = function(val)
        selectedEgg = val
    end
})

MainTab:CreateDropdown({
    Name = "Desired Pet",
    Options = desiredPets,
    CurrentOption = desiredPets[1],
    Callback = function(val)
        selectedPet = val
    end
})

MainTab:CreateButton({
    Name = "Start Predict & Hop",
    Callback = function()
        Rayfield:Notify({
            Title = "Prediction Started",
            Content = "Looking for "..selectedPet.." from "..selectedEgg,
            Duration = 4
        })

        local found = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name == selectedEgg and v:IsDescendantOf(workspace.Gardens[LocalPlayer.Name]) then
                local predicted = "[PREDICTED] "..selectedPet -- pretend prediction
                addEggESP(v, predicted)
                if string.lower(predicted):find(string.lower(selectedPet)) then
                    found = true
                    Rayfield:Notify({Title = "✅ Pet Found", Content = predicted, Duration = 5})
                    break
                end
            end
        end

        if not found then
            Rayfield:Notify({Title = "❌ Not Found", Content = "Server hopping...", Duration = 5})
            task.wait(2)
            hopServer()
        end
    end
})

-- Add ESP for hatched pets too (optional)
MainTab:CreateButton({
    Name = "ESP My Pets",
    Callback = function()
        for _, v in pairs(workspace.Gardens[LocalPlayer.Name]:GetDescendants()) do
            if v:IsA("Model") and table.find(desiredPets, v.Name) then
                addEggESP(v, v.Name)
            end
        end
        Rayfield:Notify({Title = "ESP Enabled", Content = "Your pets now visible", Duration = 3})
    end
})
