--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

--// LOAD RAYFIELD UI LIBRARY (Safe)
local RayfieldLibURL = "https://sirius.menu/rayfield/library.lua"
local RayfieldSuccess, Rayfield = pcall(function()
    return loadstring(game:HttpGet(RayfieldLibURL))()
end)

if not RayfieldSuccess or not Rayfield then
    warn("Rayfield UI failed to load.")
    return
end

--// CREATE WINDOW
local Window = Rayfield:CreateWindow({
    Name = "YexScript | Egg Prediction",
    LoadingTitle = "YEXSCRIPT",
    LoadingSubtitle = "ServerHop & ESP",
    ConfigurationSaving = {
        Enabled = false
    }
})

--// VARIABLES
local desiredPet = "Dragonfly"
local selectedEgg = "Bug Egg"

--// MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateDropdown({
    Name = "Choose Egg Type",
    Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
    CurrentOption = selectedEgg,
    Callback = function(Value)
        selectedEgg = Value
    end
})

MainTab:CreateDropdown({
    Name = "Choose Desired Pet",
    Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
    CurrentOption = desiredPet,
    Callback = function(Value)
        desiredPet = Value
    end
})

--// FUNCTION: ESP HIGHLIGHT
local function highlightEgg(eggModel, petName)
    if eggModel:FindFirstChildOfClass("Part") and not eggModel:FindFirstChild("ESP") then
        local gui = Instance.new("BillboardGui", eggModel)
        gui.Name = "ESP"
        gui.Size = UDim2.new(0, 120, 0, 40)
        gui.Adornee = eggModel:FindFirstChildOfClass("Part")
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

--// FUNCTION: Scan local player’s eggs
local function scanMyEggs()
    for _, obj in ipairs(workspace:GetDescendants()) do
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

--// FUNCTION: Hop Servers
local function hopToNewServer()
    local serverList = {}
    local cursor = ""

    repeat
        local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=2&limit=100&cursor=" .. cursor)
        local data = HttpService:JSONDecode(raw)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers then
                table.insert(serverList, server.id)
            end
        end
        cursor = data.nextPageCursor
        task.wait()
    until not cursor

    for _, id in pairs(serverList) do
        TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
        task.wait(5)
    end
end

--// BUTTON: Start Prediction + Hop
MainTab:CreateButton({
    Name = "Start Predict & Hop",
    Callback = function()
        local found = scanMyEggs()
        if found then
            Rayfield:Notify({
                Title = "✅ Found Match!",
                Content = "Your egg will hatch " .. desiredPet,
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "❌ Not Found",
                Content = "Server hopping to find your desired pet...",
                Duration = 4
            })
            hopToNewServer()
        end
    end
})
