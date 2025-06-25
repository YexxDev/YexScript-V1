local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Destroy any old version
if playerGui:FindFirstChild("YEX_LoadingScreen") then
	playerGui:FindFirstChild("YEX_LoadingScreen"):Destroy()
end

-- Create loading GUI
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "YEX_LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingGui.Parent = playerGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
bg.BackgroundTransparency = 0.3
bg.BorderSizePixel = 0
bg.Parent = loadingGui

-- Label text
local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.new(0.5, 0, 0.5, 0)
label.Size = UDim2.new(0, 300, 0, 100)
label.BackgroundTransparency = 1
label.Text = ""
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeTransparency = 0.8
label.Font = Enum.Font.GothamBlack
label.TextSize = 40
label.Parent = bg

-- Animation Sequence
local function animateText(text, delayPerChar)
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		wait(delayPerChar)
	end
end

-- Play animation
task.spawn(function()
	animateText("YEX", 0.2)
	wait(1)
	animateText("YEXSCRIPT", 0.15)
	wait(1)

	-- Fade out and destroy
	for i = 0, 1, 0.05 do
		bg.BackgroundTransparency = 0.3 + i * 0.7
		label.TextTransparency = i
		label.TextStrokeTransparency = i
		wait(0.03)
	end
	loadingGui:Destroy()
end)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Destroy old UI if exists
if playerGui:FindFirstChild("YEX_UI") then
	playerGui:FindFirstChild("YEX_UI"):Destroy()
end

-- Create main GUI
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "YEX_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 10, 0.2, 0)
toggle.Text = "YEXSCRIPT"
toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggle.BackgroundTransparency = 0.3
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.AutoButtonColor = true

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "MainFrame"
mainFrame.Visible = false
mainFrame.Size = UDim2.new(0, 420, 0, 300)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Make frame draggable
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Tab Buttons
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(0, 420, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tabBar.BorderSizePixel = 0

local tabs = {"Home", "Main", "ESP", "Teleport", "Shop", "Misc"}
local pages = {}

for i, tabName in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 70, 1, 0)
	tabBtn.Position = UDim2.new(0, (i - 1) * 70, 0, 0)
	tabBtn.Text = tabName
	tabBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	tabBtn.TextColor3 = Color3.new(1, 1, 1)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 12
	tabBtn.AutoButtonColor = true

	local page = Instance.new("Frame", mainFrame)
	page.Size = UDim2.new(1, 0, 1, -35)
	page.Position = UDim2.new(0, 0, 0, 35)
	page.BackgroundTransparency = 1
	page.Visible = (i == 1)
	pages[tabName] = page

	tabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		page.Visible = true
	end)
end

-- Toggle visibility
toggle.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local MainTab = pages["Main"]
local UIS = game:GetService("UserInputService")

-- Title
local title = Instance.new("TextLabel", MainTab)
title.Text = "Main Features"
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Auto Plant Seed Toggle
local autoPlant = false
local autoPlantBtn = Instance.new("TextButton", MainTab)
autoPlantBtn.Size = UDim2.new(0, 180, 0, 30)
autoPlantBtn.Position = UDim2.new(0, 10, 0, 35)
autoPlantBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoPlantBtn.TextColor3 = Color3.new(1, 1, 1)
autoPlantBtn.Font = Enum.Font.Gotham
autoPlantBtn.TextSize = 14
autoPlantBtn.Text = "Auto Plant Seed: OFF"

autoPlantBtn.MouseButton1Click:Connect(function()
	autoPlant = not autoPlant
	autoPlantBtn.Text = "Auto Plant Seed: " .. (autoPlant and "ON" or "OFF")
end)

-- Planting Logic
task.spawn(function()
	while true do
		if autoPlant and game:GetService("Players").LocalPlayer.Character then
			local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool and tool.Name:lower():find("seed") then
				mouse = game.Players.LocalPlayer:GetMouse()
				mouse1click()
			end
		end
		wait(0.25)
	end
end)

-- Auto Water Toggle
local autoWater = false
local waterBtn = Instance.new("TextButton", MainTab)
waterBtn.Size = UDim2.new(0, 180, 0, 30)
waterBtn.Position = UDim2.new(0, 10, 0, 75)
waterBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
waterBtn.TextColor3 = Color3.new(1, 1, 1)
waterBtn.Font = Enum.Font.Gotham
waterBtn.TextSize = 14
waterBtn.Text = "Auto Watering Can: OFF"

waterBtn.MouseButton1Click:Connect(function()
	autoWater = not autoWater
	waterBtn.Text = "Auto Watering Can: " .. (autoWater and "ON" or "OFF")
end)

task.spawn(function()
	while true do
		if autoWater and game:GetService("Players").LocalPlayer.Character then
			local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool and tool.Name:lower():find("watering") then
				mouse1click()
			end
		end
		wait(0.15)
	end
end)

-- Auto Collect
local collectOn = false
local collectBtn = Instance.new("TextButton", MainTab)
collectBtn.Size = UDim2.new(0, 180, 0, 30)
collectBtn.Position = UDim2.new(0, 10, 0, 115)
collectBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
collectBtn.TextColor3 = Color3.new(1, 1, 1)
collectBtn.Font = Enum.Font.Gotham
collectBtn.TextSize = 14
collectBtn.Text = "Auto Collect Crops: OFF"

collectBtn.MouseButton1Click:Connect(function()
	collectOn = not collectOn
	collectBtn.Text = "Auto Collect Crops: " .. (collectOn and "ON" or "OFF")
end)

task.spawn(function()
	while true do
		if collectOn then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("TouchTransmitter") and v.Parent and v.Parent:FindFirstChild("Value") then
					firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
					wait()
					firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
				end
			end
		end
		wait(1)
	end
end)

local espTab = pages["ESP"]

-- Title
local title = Instance.new("TextLabel", espTab)
title.Text = "ESP Features"
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Best Fruit ESP Toggle
local showFruitESP = false
local fruitBtn = Instance.new("TextButton", espTab)
fruitBtn.Size = UDim2.new(0, 180, 0, 30)
fruitBtn.Position = UDim2.new(0, 10, 0, 35)
fruitBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
fruitBtn.TextColor3 = Color3.new(1, 1, 1)
fruitBtn.Font = Enum.Font.Gotham
fruitBtn.TextSize = 14
fruitBtn.Text = "Show Best Fruit Value: OFF"

fruitBtn.MouseButton1Click:Connect(function()
	showFruitESP = not showFruitESP
	fruitBtn.Text = "Show Best Fruit Value: " .. (showFruitESP and "ON" or "OFF")
end)

-- Pet ESP Toggle
local petESP = false
local petBtn = Instance.new("TextButton", espTab)
petBtn.Size = UDim2.new(0, 180, 0, 30)
petBtn.Position = UDim2.new(0, 10, 0, 75)
petBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
petBtn.TextColor3 = Color3.new(1, 1, 1)
petBtn.Font = Enum.Font.Gotham
petBtn.TextSize = 14
petBtn.Text = "Pet ESP: OFF"

petBtn.MouseButton1Click:Connect(function()
	petESP = not petESP
	petBtn.Text = "Pet ESP: " .. (petESP and "ON" or "OFF")
end)

-- Fruit ESP Logic
task.spawn(function()
	while true do
		if showFruitESP then
			for _, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer.Name then
					if v:FindFirstChild("Name") and not v:FindFirstChild("YEX_FRUIT_ESP") then
						local tag = Instance.new("BillboardGui", v)
						tag.Name = "YEX_FRUIT_ESP"
						tag.Size = UDim2.new(0, 200, 0, 50)
						tag.Adornee = v:FindFirstChild("Name") or v.PrimaryPart
						tag.AlwaysOnTop = true

						local label = Instance.new("TextLabel", tag)
						label.Size = UDim2.new(1, 0, 1, 0)
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.fromRGB(255, 200, 0)
						label.Font = Enum.Font.GothamBold
						label.TextScaled = true
						label.Text = string.format("🍍 %s | %.1f | $%d",
							v.Name,
							v:FindFirstChild("Weight") and v.Weight.Value or 0,
							v:FindFirstChild("Price") and v.Price.Value or 0
						)
					end
				end
			end
		else
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BillboardGui") and v.Name == "YEX_FRUIT_ESP" then
					v:Destroy()
				end
			end
		end
		wait(1.5)
	end
end)

-- Pet ESP Logic
task.spawn(function()
	while true do
		if petESP then
			for _, pet in pairs(workspace:GetDescendants()) do
				if pet:IsA("Model") and pet.Name:find("Pet") and pet:FindFirstChild("Owner") and pet.Owner.Value == game.Players.LocalPlayer.Name then
					if not pet:FindFirstChild("YEX_PET_ESP") then
						local tag = Instance.new("BillboardGui", pet)
						tag.Name = "YEX_PET_ESP"
						tag.Size = UDim2.new(0, 120, 0, 40)
						tag.Adornee = pet.PrimaryPart or pet:FindFirstChildOfClass("Part")
						tag.AlwaysOnTop = true

						local label = Instance.new("TextLabel", tag)
						label.Size = UDim2.new(1, 0, 1, 0)
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.fromRGB(0, 255, 0)
						label.Font = Enum.Font.GothamBold
						label.TextScaled = true
						label.Text = "🐾 " .. pet.Name
					end
				end
			end
		else
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BillboardGui") and v.Name == "YEX_PET_ESP" then
					v:Destroy()
				end
			end
		end
		wait(1.5)
	end
end)

local shopTab = pages["Shop"]
local HttpService = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

-- Title
local title = Instance.new("TextLabel", shopTab)
title.Text = "Auto Shop"
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Item Category Dropdown
local categoryList = {"Seeds", "Gears", "Eggs"}
local selectedCategory = "Seeds"

local dropdownCategory = Instance.new("TextButton", shopTab)
dropdownCategory.Text = "Category: Seeds"
dropdownCategory.Size = UDim2.new(0, 180, 0, 30)
dropdownCategory.Position = UDim2.new(0, 10, 0, 35)
dropdownCategory.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
dropdownCategory.TextColor3 = Color3.new(1, 1, 1)
dropdownCategory.Font = Enum.Font.Gotham
dropdownCategory.TextSize = 14

dropdownCategory.MouseButton1Click:Connect(function()
	local currentIndex = table.find(categoryList, selectedCategory) or 1
	local nextIndex = currentIndex % #categoryList + 1
	selectedCategory = categoryList[nextIndex]
	dropdownCategory.Text = "Category: " .. selectedCategory
end)

-- Item Selection Input
local selectedItem = Instance.new("TextBox", shopTab)
selectedItem.PlaceholderText = "Type Item Name (e.g., Candy Blossom)"
selectedItem.Size = UDim2.new(0, 180, 0, 30)
selectedItem.Position = UDim2.new(0, 10, 0, 75)
selectedItem.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
selectedItem.TextColor3 = Color3.new(1, 1, 1)
selectedItem.Font = Enum.Font.Gotham
selectedItem.TextSize = 13
selectedItem.Text = ""

-- Auto Buy Button
local buyBtn = Instance.new("TextButton", shopTab)
buyBtn.Text = "Auto Buy Item"
buyBtn.Size = UDim2.new(0, 180, 0, 30)
buyBtn.Position = UDim2.new(0, 10, 0, 115)
buyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
buyBtn.TextColor3 = Color3.new(1, 1, 1)
buyBtn.Font = Enum.Font.Gotham
buyBtn.TextSize = 14

-- Buy Logic
buyBtn.MouseButton1Click:Connect(function()
	local item = selectedItem.Text
	if item == "" then return end

	local function findShopNPC()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("ShopType") and v.ShopType.Value == selectedCategory then
				return v
			end
		end
	end

	local shopNPC = findShopNPC()
	if shopNPC then
		local clickPart = shopNPC:FindFirstChild("ClickPart") or shopNPC:FindFirstChildWhichIsA("Part")
		if clickPart then
			fireclickdetector(clickPart:FindFirstChildOfClass("ClickDetector"))
			wait(0.5)
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("BuyItem"):FireServer(item)
			print("✅ Attempted to buy:", item)
		end
	end
end)
