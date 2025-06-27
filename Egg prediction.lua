-- YexScript Egg Prediction & ServerHop UI using Sirius Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "YexScript Hub - Pet Prediction",
   LoadingTitle = "YEX",
   LoadingSubtitle = "SCRIPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "YexScript",
      FileName = "YexPredictor"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

local selectedEgg = ""
local selectedPet = ""

MainTab:CreateDropdown({
   Name = "Choose Egg to Predict",
   Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
   CurrentOption = "Common Egg",
   Callback = function(Value)
      selectedEgg = Value
   end
})

MainTab:CreateDropdown({
   Name = "Desired Pet",
   Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
   CurrentOption = "Dragonfly",
   Callback = function(Value)
      selectedPet = Value
   end
})

local function showESPOnEggs()
   for _, obj in ipairs(workspace:GetDescendants()) do
      if obj:IsA("Model") and obj.Name:lower():find("egg") and obj:FindFirstChild("Pet") then
         if obj.Name:lower():find(selectedEgg:lower():split(" ")[1]) then
            local petInside = obj.Pet.Value
            if petInside == selectedPet then
               local esp = Instance.new("BillboardGui", obj)
               esp.Size = UDim2.new(0, 100, 0, 40)
               esp.AlwaysOnTop = true
               esp.Adornee = obj:FindFirstChildOfClass("Part") or obj.PrimaryPart
               local label = Instance.new("TextLabel", esp)
               label.Size = UDim2.new(1, 0, 1, 0)
               label.Text = petInside .. " 🐾"
               label.TextColor3 = Color3.new(0, 1, 0)
               label.BackgroundTransparency = 1
               label.TextScaled = true
               return true
            end
         end
      end
   end
   return false
end

local function hopServers()
   local servers = {}
   local cursor = ""

   repeat
      local success, result = pcall(function()
         return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=2&limit=100&cursor=" .. cursor))
      end)
      if success and result and result.data then
         for _, s in pairs(result.data) do
            if s.playing < s.maxPlayers then
               table.insert(servers, s.id)
            end
         end
         cursor = result.nextPageCursor
      else
         break
      end
      wait(0.2)
   until not cursor

   for _, serverId in pairs(servers) do
      TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
      wait(7)
   end
end

MainTab:CreateButton({
   Name = "Start Predict & Hop",
   Callback = function()
      local found = showESPOnEggs()
      if not found then
         Rayfield:Notify({Title = "YexScript", Content = "Desired Pet not found, hopping...", Duration = 5})
         hopServers()
      else
         Rayfield:Notify({Title = "YexScript", Content = "Matched Pet found!", Duration = 5})
      end
   end
})
