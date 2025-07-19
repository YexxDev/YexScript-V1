-- UI and Fast Age Boost Script for Pets (by Yexellzz)
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local holdingPet = nil

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", plr.PlayerGui)
ScreenGui.Name = "PetAgeUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 170, 0, 130)
Main.Position = UDim2.new(0, 20, 0, 200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Draggable = true

local title = Instance.new("TextLabel", Main)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Pet Info"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local ageLabel = Instance.new("TextLabel", Main)
ageLabel.Size = UDim2.new(1, 0, 0, 25)
ageLabel.Position = UDim2.new(0, 0, 0, 30)
ageLabel.BackgroundTransparency = 1
ageLabel.Text = "Age: --"
ageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ageLabel.Font = Enum.Font.Gotham
ageLabel.TextSize = 14

local weightLabel = Instance.new("TextLabel", Main)
weightLabel.Size = UDim2.new(1, 0, 0, 25)
weightLabel.Position = UDim2.new(0, 0, 0, 60)
weightLabel.BackgroundTransparency = 1
weightLabel.Text = "Weight: --"
weightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
weightLabel.Font = Enum.Font.Gotham
weightLabel.TextSize = 14

local make50 = Instance.new("TextButton", Main)
make50.Size = UDim2.new(1, 0, 0, 30)
make50.Position = UDim2.new(0, 0, 0, 95)
make50.Text = "Make Age 50"
make50.TextColor3 = Color3.fromRGB(255, 255, 255)
make50.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
make50.Font = Enum.Font.GothamBold
make50.TextSize = 14

-- Toggle Button
local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(0, 0, 0, 170)
toggleBtn.Text = "🧬"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextSize = 18
toggleBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- 🔁 Get current held pet
local function getHeldPet()
	for _,v in pairs(workspace.Pets:GetChildren()) do
		if v:FindFirstChild("Owner") and v.Owner.Value == plr.Name then
			return v
		end
	end
	return nil
end

-- ⏱️ Loop to update UI
task.spawn(function()
	while true do
		holdingPet = getHeldPet()
		if holdingPet then
			local age = holdingPet:FindFirstChild("Age")
			local weight = holdingPet:FindFirstChild("Weight")
			if age and weight then
				ageLabel.Text = "Age: " .. tostring(age.Value)
				weightLabel.Text = "Weight: " .. tostring(weight.Value)
			end
		else
			ageLabel.Text = "Age: --"
			weightLabel.Text = "Weight: --"
		end
		task.wait(0.5)
	end
end)

-- 🚀 Boost to Age 50 Only Once
make50.MouseButton1Click:Connect(function()
	holdingPet = getHeldPet()
	if holdingPet and holdingPet:FindFirstChild("Age") then
		local ageVal = holdingPet:FindFirstChild("Age")
		while ageVal.Value < 50 do
			game:GetService("ReplicatedStorage").Remotes.FeedPet:FireServer(holdingPet)
			task.wait(0.2)
		end
	end
end)
