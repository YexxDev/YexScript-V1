-- // Load Rayfield
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Workspace = game:GetService("Workspace")
local Player = game.Players.LocalPlayer
local PetsFolder = Workspace:WaitForChild("Pets")
local gardenCenter = Vector3.new(0, 5, 0) -- Adjust this position if center is different

-- Auto middle toggle
local autoMidPet = false

-- UI Setup
local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden - Auto Mid Pet",
   LoadingTitle = "Grow a Garden",
   LoadingSubtitle = "by Yexelzz",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
   Name = "Auto Mid Pet",
   CurrentValue = false,
   Flag = "AutoMidPet",
   Callback = function(Value)
      autoMidPet = Value
   end
})

-- Loop logic
task.spawn(function()
   while task.wait(0.2) do
      if autoMidPet then
         for _, pet in pairs(PetsFolder:GetChildren()) do
            if pet:FindFirstChild("Owner") and pet.Owner.Value == Player then
               if pet:FindFirstChild("HumanoidRootPart") then
                  pet:PivotTo(CFrame.new(gardenCenter))
               end
            end
         end
      end
   end
end)
