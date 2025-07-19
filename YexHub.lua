local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables
local AutoMid = false
local RunService = game:GetService("RunService")

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden - Pet Center Control",
    LoadingTitle = "Grow a Garden",
    LoadingSubtitle = "by Yexellzz",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Icon optional
MainTab:CreateToggle({
    Name = "Auto Mid Pet",
    CurrentValue = false,
    Flag = "AutoMidPetToggle",
    Callback = function(Value)
        AutoMid = Value
    end,
})

-- Move pets to garden center loop
task.spawn(function()
    while true do
        if AutoMid then
            local garden = game:GetService("Workspace"):FindFirstChild("Garden")
            if garden then
                local center = garden.Position
                for _, pet in ipairs(garden:GetChildren()) do
                    if pet:IsA("Model") and pet:FindFirstChild("HumanoidRootPart") then
                        pet.HumanoidRootPart.CFrame = CFrame.new(center)
                    end
                end
            end
        end
        task.wait(1) -- You can adjust speed
    end
end)
