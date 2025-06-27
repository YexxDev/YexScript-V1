-- Rayfield-based YexScript Egg Predictor Hub (Smart Visual) -- Mobile/KRNL Friendly

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Workspace = game:GetService("Workspace") local HttpService = game:GetService("HttpService") local TeleportService = game:GetService("TeleportService")

local UI = Rayfield:CreateWindow({ Name = "YexScript - Egg Predictor", LoadingTitle = "YEXSCRIPT", LoadingSubtitle = "Loading Smart Egg System...", ConfigurationSaving = { Enabled = true, FolderName = "YexEggPred", FileName = "EggPrefs" }, Discord = { Enabled = true, Invite = "yourdiscordinvite", RememberJoins = true }, KeySystem = false })

local mainTab = UI:CreateTab("Main", 4483362458)

local desiredPet = ""

mainTab:CreateInput({ Name = "Desired Pet Name", PlaceholderText = "Type desired pet (e.g. Raccon)", RemoveTextAfterFocusLost = false, Callback = function(Value) desiredPet = string.lower(Value) end })

mainTab:CreateButton({ Name = "🔍 Start Prediction", Callback = function() local matched = false for _, egg in pairs(Workspace:GetDescendants()) do if egg:IsA("Model") and egg.Name:lower():find("egg") and egg:FindFirstChild("Owner") then if egg.Owner.Value == LocalPlayer then local petHint = egg:FindFirstChild("Predicted") or egg:FindFirstChild("Display") if petHint and petHint:IsA("StringValue") and string.lower(petHint.Value) == desiredPet then local gui = Instance.new("BillboardGui", egg) gui.Size = UDim2.new(0, 100, 0, 40) gui.Adornee = egg:FindFirstChildWhichIsA("BasePart") gui.AlwaysOnTop = true

local label = Instance.new("TextLabel", gui)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "✅ Match: " .. petHint.Value
                    label.TextColor3 = Color3.new(0, 1, 0)
                    label.TextScaled = true
                    matched = true
                end
            end
        end
    end

    if not matched then
        Rayfield:Notify({
            Title = "Pet Not Found",
            Content = "Server hopping for pet: "..desiredPet,
            Duration = 3,
            Image = 4483362458
        })

        task.wait(2)
        local servers = {}
        local cursor = ""

        repeat
            local success, body = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor))
            end)
            if success and body and body.data then
                for _, s in pairs(body.data) do
                    if s.playing < s.maxPlayers then
                        table.insert(servers, s.id)
                    end
                end
                cursor = body.nextPageCursor or ""
            else
                break
            end
            task.wait(1)
        until cursor == "" or #servers >= 10

        local random = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, random, LocalPlayer)
    else
        Rayfield:Notify({
            Title = "Match Found!",
            Content = "Egg with desired pet detected in your garden!",
            Duration = 4,
            Image = 4483362458
        })
    end
end

})

