task.wait(1)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SelectedPet = "Dragonfly"
local AutoHop = false

-- UI Window
local Window = Rayfield:CreateWindow({
   Name = "YexScript - Pet ESP & Hop",
   LoadingTitle = "YEX",
   LoadingSubtitle = "SCRIPT",
   ConfigurationSaving = {Enabled = false},
   Discord = {Enabled = false},
   KeySystem = false
})

local MainTab = Window:CreateTab("🐾 Pet Scanner", Color3.fromRGB(135, 0, 255))

-- Smart Egg ESP
local function highlightMyEggs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
            if obj.Name:lower():find("egg") and not obj:FindFirstChild("ESP") then
                local predict = obj:FindFirstChild("Prediction") or obj:FindFirstChild("PetPredict")
                local petName = predict and predict.Value or obj.Name

                local esp = Instance.new("BillboardGui", obj)
                esp.Name = "ESP"
                esp.Size = UDim2.new(0,100,0,40)
                esp.AlwaysOnTop = true
                esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")

                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = "🐾 " .. petName
                label.TextColor3 = Color3.new(1,1,0)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
            end
        end
    end
end

-- Smart Match Check
local function predictedPetMatches()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
            if obj.Name:lower():find("egg") then
                local predict = obj:FindFirstChild("Prediction") or obj:FindFirstChild("PetPredict")
                if predict and predict.Value:lower():find(SelectedPet:lower()) then
                    return true
                end
            end
        end
    end
    return false
end

-- Server Hop Logic
local function hopServer()
    local PlaceId = game.PlaceId
    local cursor = ""
    local servers = {}

    repeat
        local response = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor)
        local body = HttpService:JSONDecode(response)
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers then
                table.insert(servers, v.id)
            end
        end
        cursor = body.nextPageCursor
        wait()
    until not cursor

    for _, sid in ipairs(servers) do
        TeleportService:TeleportToPlaceInstance(PlaceId, sid, LocalPlayer)
        wait(10)
    end
end

-- Auto Hop Loop
task.spawn(function()
    while task.wait(5) do
        if AutoHop then
            highlightMyEggs()
            if not predictedPetMatches() then
                Rayfield:Notify({
                    Title = "YexScript",
                    Content = "Pet not matched. Hopping...",
                    Duration = 3
                })
                hopServer()
            else
                Rayfield:Notify({
                    Title = "YexScript",
                    Content = "Desired pet detected!",
                    Duration = 3
                })
            end
        end
    end
end)

-- UI ELEMENTS
MainTab:CreateDropdown({
    Name = "Select Pet Prediction",
    Options = {"Dragonfly", "Red Fox", "Raccon", "Mimic Octopus"},
    CurrentOption = "Dragonfly",
    Callback = function(opt)
        SelectedPet = opt
    end
})

MainTab:CreateToggle({
    Name = "Auto ServerHop (Smart)",
    CurrentValue = false,
    Callback = function(v)
        AutoHop = v
    end
})

MainTab:CreateButton({
    Name = "Manual ESP Now",
    Callback = function()
        highlightMyEggs()
    end
})

MainTab:CreateParagraph({
    Title = "📌 Info",
    Content = "This hub only shows YOUR own eggs.\nUses smart prediction from hidden values if available.\nEnable toggle to hop until your pet is detected."
})
