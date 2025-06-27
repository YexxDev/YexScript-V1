-- Fixed Pet ESP & ServerHop Hub | YexScript | Grow a Garden

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local SelectedPet = "Dragonfly"
local AutoHop = false

-- Rayfield UI Window
local Window = Rayfield:CreateWindow({
   Name = "YexScript Hub - Pet ESP",
   LoadingTitle = "YEX",
   LoadingSubtitle = "SCRIPT",
   ConfigurationSaving = {
       Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Function: ESP Only My Eggs
local function highlightMyEggs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
            if obj.Name:lower():find("egg") then
                if not obj:FindFirstChild("ESP") then
                    local esp = Instance.new("BillboardGui", obj)
                    esp.Name = "ESP"
                    esp.Size = UDim2.new(0,100,0,40)
                    esp.AlwaysOnTop = true
                    esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")

                    local label = Instance.new("TextLabel", esp)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.Text = obj.Name
                    label.TextColor3 = Color3.new(1,1,0)
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                end
            end
        end
    end
end

-- Function: Pet Prediction
local function predictedPetMatches()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
            if obj.Name:lower():find("egg") then
                local predicted = obj.Name:lower()
                if predicted:find(SelectedPet:lower()) then
                    return true
                end
            end
        end
    end
    return false
end

-- Function: Server Hop
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
        wait(0.5)
    until not cursor

    for _, sid in ipairs(servers) do
        TeleportService:TeleportToPlaceInstance(PlaceId, sid, LocalPlayer)
        wait(5)
    end
end

-- Loop if AutoHop is Enabled
task.spawn(function()
    while task.wait(5) do
        if AutoHop then
            highlightMyEggs()
            if not predictedPetMatches() then
                Rayfield:Notify({
                    Title = "YexScript",
                    Content = "Pet doesn't match. Hopping...",
                    Duration = 3
                })
                hopServer()
            else
                Rayfield:Notify({
                    Title = "YexScript",
                    Content = "Found desired egg!",
                    Duration = 3
                })
            end
        end
    end
end)

-- UI Options
Window:CreateDropdown({
    Name = "Select Pet to Match",
    Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
    CurrentOption = "Dragonfly",
    Callback = function(opt)
        SelectedPet = opt
    end
})

Window:CreateToggle({
    Name = "Enable Auto ServerHop",
    CurrentValue = false,
    Callback = function(bool)
        AutoHop = bool
    end
})

Window:CreateButton({
    Name = "Manual Egg ESP",
    Callback = function()
        highlightMyEggs()
    end
})
