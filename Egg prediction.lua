-- Safe load Rayfield (handles errors)
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield/library.lua"))()
end)

if not success then
    warn("Failed to load Rayfield.")
    return
end

-- Create Window
local Window = Rayfield:CreateWindow({
	Name = "YexScript | Egg Predictor",
	LoadingTitle = "YEXSCRIPT",
	LoadingSubtitle = "Pet ESP + ServerHop",
	ConfigurationSaving = {
		Enabled = false
	}
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local desiredPet = "Dragonfly"
local selectedEgg = "Bug Egg"

-- Dropdowns
MainTab:CreateDropdown({
	Name = "Choose Egg",
	Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythic Egg", "Bug Egg", "Paradise Egg"},
	CurrentOption = "Bug Egg",
	Callback = function(Value)
		selectedEgg = Value
	end,
})

MainTab:CreateDropdown({
	Name = "Choose Desired Pet",
	Options = {"Dragonfly", "Raccon", "Red Fox", "Mimic Octopus"},
	CurrentOption = "Dragonfly",
	Callback = function(Value)
		desiredPet = Value
	end,
})

-- ESP
local function highlightPetEgg(eggModel, petName)
	local gui = Instance.new("BillboardGui", eggModel)
	gui.Size = UDim2.new(0, 120, 0, 40)
	gui.Adornee = eggModel:FindFirstChildOfClass("Part")
	gui.AlwaysOnTop = true

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = petName .. " (Prediction)"
	label.TextColor3 = Color3.new(1, 1, 0)
	label.TextScaled = true
end

-- Scan Egg
local function scanEggs()
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") and egg:FindFirstChild("Owner") then
			local owner = egg:FindFirstChild("Owner")
			if owner and owner.Value == LocalPlayer.Name then
				local predicted = egg:FindFirstChild("PredictedPet") or egg:FindFirstChild("Prediction")
				if predicted and predicted.Value == desiredPet then
					highlightPetEgg(egg, predicted.Value)
					return true
				end
			end
		end
	end
	return false
end

-- Hop Function
local function hop()
	local servers = {}
	local cursor = ""

	repeat
		local res = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=2&limit=100&cursor="..cursor)
		local body = HttpService:JSONDecode(res)
		for _, v in ipairs(body.data) do
			if v.playing < v.maxPlayers then
				table.insert(servers, v.id)
			end
		end
		cursor = body.nextPageCursor
	until not cursor

	for _, id in pairs(servers) do
		TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
		wait(5)
	end
end

-- Button
MainTab:CreateButton({
	Name = "Start Predict & Hop",
	Callback = function()
		if scanEggs() then
			Rayfield:Notify({
				Title = "Found Match!",
				Content = desiredPet .. " is in your egg!",
				Duration = 4,
			})
		else
			Rayfield:Notify({
				Title = "Not Found",
				Content = "Hopping to another server...",
				Duration = 3,
			})
			hop()
		end
	end,
})
