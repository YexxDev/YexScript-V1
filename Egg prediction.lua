-- Load Rayfield UI
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

repeat wait() until Rayfield and Rayfield.CreateWindow

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- UI
local Window = Rayfield:CreateWindow({
    Name = "YexScript | Egg Predictor",
    LoadingTitle = "YEX",
    LoadingSubtitle = "SCRIPT",
    ConfigurationSaving = {
        Enabled = false
    }
})

local MainTab = Window:CreateTab("🥚 Main", Color3.fromRGB(180, 0, 255))

local selectedPet = "Dragonfly" -- default
MainTab:CreateInput({
    Name = "🐾 Desired Pet Name",
    PlaceholderText = "Type pet name (e.g., Dragonfly)",
    RemoveTextAfterFocusLost = true,
    Callback = function(txt)
        selectedPet = txt
        Rayfield:Notify({ Title = "Pet Filter", Content = "Now looking for: " .. selectedPet, Duration = 3 })
    end
})

local function hasMatchingEgg()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("egg") then
            local owner = obj:FindFirstChild("Owner")
            if owner and owner.Value == LocalPlayer then
                local prediction = obj:FindFirstChild("Prediction") or obj:FindFirstChild("PetPredict")
                if prediction and prediction.Value:lower():find(selectedPet:lower()) then
                    return true
                end
            end
        end
    end
    return false
end

local function drawESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("egg") then
            local owner = obj:FindFirstChild("Owner")
            if owner and owner.Value == LocalPlayer and not obj:FindFirstChild("ESP") then
                local pred = obj:FindFirstChild("Prediction") or obj:FindFirstChild("PetPredict")
                local predictName = pred and pred.Value or "Unknown Pet"
                
                local esp = Instance.new("BillboardGui", obj)
                esp.Name = "ESP"
                esp.Size = UDim2.new(0, 120, 0, 45)
                esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")
                esp.AlwaysOnTop = true

                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "🥚 " .. obj.Name .. "\n➡️ " .. predictName
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
            end
        end
    end
end

MainTab:CreateButton({
    Name = "🔍 ESP My Garden Eggs",
    Callback = function()
        drawESP()
        Rayfield:Notify({ Title = "ESP Active", Content = "Egg prediction showing!", Duration = 3 })
    end
})

MainTab:CreateButton({
    Name = "🔁 Start ServerHop Until Match",
    Callback = function()
        Rayfield:Notify({ Title = "ServerHop", Content = "Searching servers...", Duration = 3 })

        local function hop()
            local cursor = ""
            local tried = 0
            while true do
                local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=2&limit=100&cursor=%s"):format(placeId, cursor)
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)
                if success then
                    for _, server in ipairs(result.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            tried += 1
                            TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                            wait(8)
                            if hasMatchingEgg() then
                                Rayfield:Notify({ Title = "Match Found", Content = "Matching egg detected!", Duration = 4 })
                                return
                            end
                        end
                    end
                    if not result.nextPageCursor then break end
                    cursor = result.nextPageCursor
                else
                    warn("Failed to fetch servers")
                    break
                end
            end
        end

        hop()
    end
})
