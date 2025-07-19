-- // Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- // Variables
local player = game.Players.LocalPlayer
local PetsFolder = workspace:WaitForChild("Pets")
local gardenCenter = Vector3.new(0, 5, 0) -- Change this to actual center of your garden
local autoMid = false

-- // Rayfield UI Setup
local Window = Rayfield:CreateWindow({
    Name = "🌱 Grow a Garden - Yex UI",
    LoadingTitle = "Grow a Garden Hub",
    LoadingSubtitle = "by Yexel",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateToggle({
    Name = "Auto Mid Pet",
    CurrentValue = false,
    Flag = "AutoMidPetToggle",
    Callback = function(Value)
        autoMid = Value
    end,
})

-- // Loop to auto-mid pet
task.spawn(function()
    while task.wait(0.3) do
        if autoMid then
            for _, pet in pairs(PetsFolder:GetChildren()) do
                if pet:FindFirstChild("Owner") and pet.Owner.Value == player then
                    local hrp = pet:FindFirstChild("HumanoidRootPart") or pet:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        pet:PivotTo(CFrame.new(gardenCenter))
                    end
                end
            end
        end
    end
end)
