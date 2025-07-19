-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Screen GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "AutoPetMiddleUI"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 280)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Auto Middle Pet - Grow A Garden"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Dropdown
local dropdown = Instance.new("TextButton", mainFrame)
dropdown.Size = UDim2.new(0.8, 0, 0, 40)
dropdown.Position = UDim2.new(0.1, 0, 0.25, 0)
dropdown.Text = "Select Pet"
dropdown.BackgroundColor3 = Color3.fromRGB(60,60,60)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextScaled = true

-- Auto Toggle
local toggle = Instance.new("TextButton", mainFrame)
toggle.Size = UDim2.new(0.8, 0, 0, 40)
toggle.Position = UDim2.new(0.1, 0, 0.5, 0)
toggle.Text = "Auto Middle: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSans
toggle.TextScaled = true

-- Variables
local autoEnabled = false
local selectedPetName = nil

-- Detect Current Pets in Garden
local function getPets()
	local petsFolder = workspace:FindFirstChild(LocalPlayer.Name .. "_Pets")
	if petsFolder then
		local pets = {}
		for _, pet in ipairs(petsFolder:GetChildren()) do
			table.insert(pets, pet.Name)
		end
		return pets
	end
	return {}
end

-- Dropdown Function
local dropdownOpen = false
local dropdownList

dropdown.MouseButton1Click:Connect(function()
	if dropdownList then dropdownList:Destroy() end
	dropdownOpen = not dropdownOpen
	if dropdownOpen then
		dropdownList = Instance.new("Frame", mainFrame)
		dropdownList.Position = UDim2.new(0.1, 0, 0.38, 0)
		dropdownList.Size = UDim2.new(0.8, 0, 0, 120)
		dropdownList.BackgroundColor3 = Color3.fromRGB(40,40,40)
		dropdownList.BorderSizePixel = 0

		local layout = Instance.new("UIListLayout", dropdownList)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		for _, petName in ipairs(getPets()) do
			local btn = Instance.new("TextButton", dropdownList)
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.Text = petName
			btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Font = Enum.Font.SourceSans
			btn.TextScaled = true

			btn.MouseButton1Click:Connect(function()
				selectedPetName = petName
				dropdown.Text = "Pet: " .. petName
				dropdownList:Destroy()
				dropdownOpen = false
			end)
		end
	end
end)

-- Toggle Button
toggle.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	toggle.Text = "Auto Middle: " .. (autoEnabled and "ON" or "OFF")
end)

-- Auto Move to Middle
RunService.Heartbeat:Connect(function()
	if autoEnabled and selectedPetName then
		local petsFolder = workspace:FindFirstChild(LocalPlayer.Name .. "_Pets")
		if petsFolder then
			local pet = petsFolder:FindFirstChild(selectedPetName)
			if pet and pet:IsA("Model") and pet:FindFirstChild("HumanoidRootPart") then
				pet:PivotTo(CFrame.new(Vector3.new(0, 1, 0))) -- Center of garden
			end
		end
	end
end)
