-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PetDropdown = Instance.new("TextButton")
local PetList = Instance.new("Frame")
local AutoMiddleToggle = Instance.new("TextButton")

-- Parent setup
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame settings
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
Title.Text = "Grow a Garden - Pet Control"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Dropdown Button
PetDropdown.Text = "Select Pet"
PetDropdown.Size = UDim2.new(0, 300, 0, 40)
PetDropdown.Position = UDim2.new(0, 50, 0, 60)
PetDropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PetDropdown.TextColor3 = Color3.new(1,1,1)
PetDropdown.Font = Enum.Font.SourceSans
PetDropdown.TextScaled = true
PetDropdown.Parent = MainFrame

-- Dropdown list frame
PetList.Visible = false
PetList.Size = UDim2.new(0, 300, 0, 150)
PetList.Position = PetDropdown.Position + UDim2.new(0, 0, 0, 40)
PetList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PetList.BorderSizePixel = 0
PetList.Parent = MainFrame

-- Toggle Button
AutoMiddleToggle.Text = "Auto Middle: OFF"
AutoMiddleToggle.Size = UDim2.new(0, 300, 0, 40)
AutoMiddleToggle.Position = UDim2.new(0, 50, 0, 230)
AutoMiddleToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AutoMiddleToggle.TextColor3 = Color3.new(1, 1, 1)
AutoMiddleToggle.Font = Enum.Font.SourceSans
AutoMiddleToggle.TextScaled = true
AutoMiddleToggle.Parent = MainFrame

-- Logic
local selectedPet = nil
local autoMiddle = false

-- Fetch and populate pets
local function refreshPetList()
	PetList:ClearAllChildren()
	local pets = workspace.Pets:GetChildren()
	for _, pet in pairs(pets) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, 0, 0, 30)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.TextColor3 = Color3.new(1, 1, 1)
		button.Font = Enum.Font.SourceSans
		button.TextScaled = true
		button.Text = pet.Name
		button.Parent = PetList

		button.MouseButton1Click:Connect(function()
			selectedPet = pet
			PetDropdown.Text = "Pet: " .. pet.Name
			PetList.Visible = false
		end)
	end
end

PetDropdown.MouseButton1Click:Connect(function()
	PetList.Visible = not PetList.Visible
	refreshPetList()
end)

AutoMiddleToggle.MouseButton1Click:Connect(function()
	autoMiddle = not autoMiddle
	AutoMiddleToggle.Text = "Auto Middle: " .. (autoMiddle and "ON" or "OFF")
end)

-- Loop to move selected pet to center
task.spawn(function()
	while true do
		task.wait(0.5)
		if autoMiddle and selectedPet and selectedPet:FindFirstChild("HumanoidRootPart") then
			selectedPet.HumanoidRootPart.CFrame = CFrame.new(workspace.Garden.Middle.Position + Vector3.new(0, 2, 0))
		end
	end
end)
