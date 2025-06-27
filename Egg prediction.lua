-- YexScript Pet Prediction + ServerHop ESP (Rayfield UI)
-- Works in Grow a Garden, optimized for mobile/KRNL

if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Window
local Window = Rayfield:CreateWindow({
   Name = "YexScript | Pet ESP & Server Hop",
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

local SelectedPet = "Dragonfly"
local AutoHop = false

-- Egg ESP function (your own eggs only)
local function highlightMyEggs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
            if obj.Name:lower():find("egg") then
                if not obj:FindFirstChild("ESP") then
                    local esp = Instance.new("BillboardGui", obj)
                    esp.Name = "ESP"
                    esp.Size = UDim2.new(0,100,0,40)
                    esp.AlwaysOnTop = true
                    esp.Adornee = obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")

                    local label = Instance.new("TextLabel", esp)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.Text = obj.Name
                    label.TextColor3 = Color3.new(1,1,0)
                    label.TextScaled = true
                end
            end
        end
    end
end

-- Server Hop
local function hopServer()
    local PlaceId = game.PlaceId
    local cursor = ""
    local servers = {}

    repeat
        local body = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor))
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
        wait(5)
    end
end

-- Predict Pet Logic (from egg name only, placeholder)
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

-- Main Loop
task.spawn(function()
    while task.wait(3) do
        if AutoHop then
            highlightMyEggs()
            if not predictedPetMatches() then
                Rayfield:Notify({Title = "YexScript", Content = "Pet not matched, hopping...", Duration = 2})
                hopServer()
            else
                Rayfield:Notify({Title = "YexScript", Content = "Match found!", Duration = 3})
            end
        end
    end
end)

-- UI Elements
Window:CreateDropdown({
    Name = "Select Desired Pet",
    Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
    CurrentOption = "Dragonfly",
    Callback = function(val)
        SelectedPet = val
    end
})

Window:CreateToggle({
    Name = "Auto Predict + ServerHop",
    CurrentValue = false,
    Callback = function(v)
        AutoHop = v
    end
})

Window:CreateButton({
    Name = "Manual Egg ESP",
    Callback = function()
        highlightMyEggs()
    end
})
