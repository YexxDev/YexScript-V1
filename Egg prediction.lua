-- // Rayfield Loader
loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Garden = workspace:FindFirstChild(LocalPlayer.Name .. "'s Garden")

-- // Settings
local SelectedEgg = "Common Egg"
local DesiredPet = "Dragonfly"
local PlaceId = game.PlaceId

-- // UI Setup
local Window = Rayfield:CreateWindow({
   Name = "YexScript | Egg Prediction",
   LoadingTitle = "YEXSCRIPT",
   LoadingSubtitle = "Egg ESP & Auto Hop",
   ConfigurationSaving = {Enabled = false},
   Discord = {Enabled = false},
   KeySystem = false
})

local MainTab = Window:CreateTab("Prediction 🥚", 4483362458)

local eggDropdown = MainTab:CreateDropdown({
   Name = "Select Egg Type",
   Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
   CurrentOption = "Common Egg",
   Callback = function(Value)
      SelectedEgg = Value
   end,
})

local petDropdown = MainTab:CreateDropdown({
   Name = "Select Desired Pet",
   Options = {"Dragonfly", "Red Fox", "Raccoon", "Mimic Octopus"},
   CurrentOption = "Dragonfly",
   Callback = function(Value)
      DesiredPet = Value
   end,
})

local predictBtn = MainTab:CreateButton({
   Name = "Start Predict & Hop 🔁",
   Callback = function()
      predictAndHop()
   end
})

-- // Prediction Logic
function getPetFromEgg(egg)
   local hint = egg:FindFirstChild("Prediction") or egg:FindFirstChildWhichIsA("StringValue")
   if hint and hint.Value then
      return hint.Value
   end
   return "Unknown"
end

function highlightEgg(egg)
   local petName = getPetFromEgg(egg)
   local gui = Instance.new("BillboardGui", egg)
   gui.Size = UDim2.new(0, 100, 0, 40)
   gui.Adornee = egg
   gui.AlwaysOnTop = true
   local label = Instance.new("TextLabel", gui)
   label.Size = UDim2.new(1, 0, 1, 0)
   label.BackgroundTransparency = 1
   label.Text = SelectedEgg .. ": " .. petName
   label.TextColor3 = Color3.fromRGB(255, 255, 0)
   label.TextScaled = true
end

function scanEggs()
   for _, obj in pairs(Garden:GetDescendants()) do
      if obj:IsA("Model") and obj.Name == SelectedEgg then
         local petPredicted = getPetFromEgg(obj)
         highlightEgg(obj)
         if string.lower(petPredicted) == string.lower(DesiredPet) then
            Rayfield:Notify({Title="Match Found!", Content="Your pet was found in this server!", Duration=6})
            return true
         end
      end
   end
   return false
end

-- // Server Hop Logic
function predictAndHop()
   if scanEggs() then return end
   Rayfield:Notify({Title="Searching...", Content="Desired pet not found. Hopping servers...", Duration=4})
   local cursor = ""
   local servers = {}

   repeat
      local success, response = pcall(function()
         return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=2&limit=100&cursor="..cursor))
      end)
      if success and response and response.data then
         for _, server in pairs(response.data) do
            if server.playing < server.maxPlayers then
               table.insert(servers, server.id)
            end
         end
         cursor = response.nextPageCursor
      else
         break
      end
      wait(0.5)
   until not cursor

   for _, id in pairs(servers) do
      wait(2)
      TeleportService:TeleportToPlaceInstance(PlaceId, id, LocalPlayer)
   end
end
