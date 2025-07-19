-- UI Library
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MainLabel = Instance.new("TextLabel")
local PetDropdown = Instance.new("TextButton")
local PetListFrame = Instance.new("Frame")
local AutoMiddleToggle = Instance.new("TextButton")

-- Setup
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

MainLabel.Text = "Main"
MainLabel.Size = UDim2.new(1, 0, 0, 30)
MainLabel.BackgroundTransparency = 1
MainLabel.TextColor3 = Color3.new(1, 1, 1)
MainLabel.Font = Enum.Font.SourceSansBold
MainLabel.TextScaled = true
MainLabel.Parent = Frame

-- Dropdown for Pet Selection
PetDropdown.Text = "Select Pet"
PetDropdown.Size = UDim2.new(1, -20, 0, 30)
PetDropdown.Position = UDim2.new(0, 10, 0, 40)
PetDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PetDropdown.TextColor3 = Color3.new(1, 1, 1)
PetDropdown.Parent = Frame

PetListFrame.Size = UDim2.new(1, -20, 0, 70)
PetListFrame.Position = UDim2.new(0, 10, 0, 75)
PetListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetListFrame.Visible = false
PetListFrame.Parent = Frame

local selectedPet = nil
local autoMiddle = false

-- Toggle Button
AutoMiddleToggle.Text = "Auto Middle: OFF"
AutoMiddleToggle.Size = UDim2.new(1, -20, 0, 30)
AutoMiddleToggle.Position = UDim2.new(0, 10, 0, 150)
AutoMiddleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoMiddleToggle.TextColor3 = Color3.new(1, 1, 1)
AutoMiddleToggle.Parent = Frame

-- Toggle dropdown
PetDropdown.MouseButton1Click:Connect(function()
	PetListFrame.Visible = not PetListFrame.Visible
end)

-- Detect pets
function updatePetList()
	PetListFrame:ClearAllChildren()
	local pets = workspace.Pets:GetChildren()
	local y = 0
	for _, pet in ipairs(pets) do
		if pet:FindFirstChild("NameGui") then
			local button = Instance.new("TextButton")
			button.Text = pet.Name
			button.Size = UDim2.new(1, 0, 0, 25)
			button.Position = UDim2.new(0, 0, 0, y)
			button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Parent = PetListFrame
			y = y + 25

			button.MouseButton1Click:Connect(function()
				selectedPet = pet
				PetDropdown.Text = pet.Name
				PetListFrame.Visible = false
			end)
		end
	end
end

-- Auto middle logic
AutoMiddleToggle.MouseButton1Click:Connect(function()
	autoMiddle = not autoMiddle
	AutoMiddleToggle.Text = autoMiddle and "Auto Middle: ON" or "Auto Middle: OFF"
end)

-- Auto loop
task.spawn(function()
	while true do
		if autoMiddle and selectedPet and selectedPet:FindFirstChild("HumanoidRootPart") then
			selectedPet.HumanoidRootPart.CFrame = CFrame.new(workspace.Middle.Position)
		end
		task.wait(0.2)
	end
end)

-- Init
updatePetList()
