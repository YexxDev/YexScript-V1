-- Load Rayfield UI (working)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

-- Window
local Window = Rayfield:CreateWindow({
	Name = "YexScript | Egg Predictor",
	LoadingTitle = "YEXSCRIPT",
	LoadingSubtitle = "Pet ESP + ServerHop",
	ConfigurationSaving = {
		Enabled = false
	}
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Dropdowns
local selectedEgg = "Bug Egg"
local desiredPet = "Dragonfly"

MainTab:CreateDropdown({
	Name = "Egg to Predict",
	Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
	CurrentOption = "Bug Egg",
	Callback = function(opt)
		selectedEgg = opt
	end,
})

MainTab:CreateDropdown({
	Name = "Desired Pet",
	Options = {"Dragonfly", "Mimic Octopus", "Raccon", "Red Fox"},
	CurrentOption = "Dragonfly",
	Callback = function(opt)
		desiredPet = opt
	end,
})

-- ESP Function
local function highlightEgg(eggModel, petName)
	local gui = Instance.new("BillboardGui", eggModel)
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.Adornee = eggModel:FindFirstChildOfClass("Part")
	gui.AlwaysOnTop = true

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = petName .. " 🥚"
	label.TextColor3 = Color3.fromRGB(255, 255, 0)
	label.TextScaled = true
end

-- Predict and Check
local function scanEggs()
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") and egg:FindFirstChild("Owner") then
			local owner = egg:FindFirstChild("Owner")
			if owner and owner.Value == LocalPlayer.Name then
				local predictedPet = egg:FindFirstChild("PredictedPet") or egg:FindFirstChild("Prediction")
				if predictedPet and predictedPet.Value == desiredPet then
					highlightEgg(egg, predictedPet.Value)
					return true
				end
			end
		end
	end
	return false
end

-- ServerHop
local function hopServer()
	local servers = {}
	local cursor = ""
	local PlaceId = game.PlaceId

	repeat
		local response = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=2&limit=100&cursor=" .. cursor)
		local data = HttpService:JSONDecode(response)
		for _, s in pairs(data.data) do
			if s.playing < s.maxPlayers then
				table.insert(servers, s.id)
			end
		end
		cursor = data.nextPageCursor or ""
	until cursor == "" or #servers >= 5

	for _, serverId in pairs(servers) do
		TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
		wait(10)
	end
end

-- Button to Start
MainTab:CreateButton({
	Name = "Start Predict & Hop",
	Callback = function()
		local matched = scanEggs()
		if matched then
			Rayfield:Notify({
				Title = "Pet Found!",
				Content = desiredPet .. " found in your egg!",
				Duration = 5
			})
		else
			Rayfield:Notify({
				Title = "Not Found",
				Content = "Hopping to find " .. desiredPet,
				Duration = 3
			})
			wait(1)
			hopServer()
		end
	end,
})
