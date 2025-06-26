-- YexScript Hub with Real Logic
-- Optimized for Grow a Garden (Delta/KRNL)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Create loading screen
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "YexScript_Loading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
local background = Instance.new("Frame", loadingGui)
background.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
background.BackgroundTransparency = 0.3
background.Size = UDim2.new(1, 0, 1, 0)

local label = Instance.new("TextLabel", background)
label.Size = UDim2.new(1, 0, 0.3, 0)
label.Position = UDim2.new(0, 0, 0.35, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBlack
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 48
label.Text = ""

-- Animate YEX -> SCRIPT
spawn(function()
	label.Text = "YEX"
	wait(1)
	label.Text = "SCRIPT"
	wait(1.5)
	loadingGui:Destroy()
end)

-- Main UI Setup
local mainGui = Instance.new("ScreenGui", PlayerGui)
mainGui.Name = "YexScript_Hub"
mainGui.ResetOnSpawn = false
local frame = Instance.new("Frame", mainGui)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.Size = UDim2.new(0, 400, 0, 250)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.2
frame.Draggable = true
frame.Active = true

-- Tabs
local tabs = {"Main", "ESP", "Shop", "Calculator"}
local tabFrames = {}
for i, tabName in ipairs(tabs) do
	local tabButton = Instance.new("TextButton", frame)
	tabButton.Size = UDim2.new(0, 100, 0, 30)
	tabButton.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	tabButton.Text = tabName
	tabButton.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
	tabButton.TextColor3 = Color3.new(1, 1, 1)

	local tabFrame = Instance.new("Frame", frame)
	tabFrame.Size = UDim2.new(1, 0, 1, -30)
	tabFrame.Position = UDim2.new(0, 0, 0, 30)
	tabFrame.Visible = i == 1
	tabFrame.BackgroundTransparency = 1
	tabFrames[tabName] = tabFrame

	tabButton.MouseButton1Click:Connect(function()
		for _, tf in pairs(tabFrames) do tf.Visible = false end
		tabFrame.Visible = true
	end)
end

-- Main Tab
local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 180, 0, 30)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local y = 0
createButton(tabFrames["Main"], "Auto Plant Seed", function()
	spawn(function()
		while wait(0.5) do
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool and tool:FindFirstChild("Plant") then
				for _, plot in pairs(Workspace:GetDescendants()) do
					if plot.Name == "Soil" and plot:FindFirstChild("PlantIcon").Image == "" then
						fireclickdetector(plot.ClickDetector)
					end
				end
			end
		end
	end)
end).Position = UDim2.new(0, 10, 0, y); y += 35

createButton(tabFrames["Main"], "Auto Watering Can", function()
	spawn(function()
		while wait(0.3) do
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Watering Can")
			if tool then
				fireclickdetector(tool.Handle:FindFirstChildWhichIsA("ClickDetector"))
			end
		end
	end)
end).Position = UDim2.new(0, 10, 0, y); y += 35

createButton(tabFrames["Main"], "Auto Collect Crops", function()
	spawn(function()
		while wait(0.5) do
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:IsA("ClickDetector") and obj.Parent.Name == "Fruit" then
					fireclickdetector(obj)
				end
			end
		end
	end)
end).Position = UDim2.new(0, 10, 0, y); y += 35

-- ESP Tab
createButton(tabFrames["ESP"], "ESP Fruits (Name + Weight)", function()
	for _, fruit in pairs(Workspace:GetDescendants()) do
		if fruit.Name == "Fruit" and fruit:FindFirstChild("BillboardGui") == nil then
			local tag = Instance.new("BillboardGui", fruit)
			tag.Size = UDim2.new(0, 200, 0, 50)
			tag.AlwaysOnTop = true
			tag.Adornee = fruit
			local lbl = Instance.new("TextLabel", tag)
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.Text = fruit:GetAttribute("Name") .. " | W: " .. tostring(fruit:GetAttribute("Weight") or "?")
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.fromRGB(255,255,255)
			lbl.TextSize = 14
		end
	end
end)

-- Calculator
createButton(tabFrames["Calculator"], "Calculate Inventory Price", function()
	local inv = LocalPlayer.Backpack:GetChildren()
	local total = 0
	for _, item in ipairs(inv) do
		if item:FindFirstChild("Price") then
			total += item.Price.Value
		end
	end
	local msg = Instance.new("TextLabel", PlayerGui)
	msg.Size = UDim2.new(0, 400, 0, 40)
	msg.Position = UDim2.new(0.5, -200, 0.05, 0)
	msg.Text = "Total Inventory Value: " .. tostring(total)
	msg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	msg.TextColor3 = Color3.new(1,1,1)
	msg.TextSize = 22
	delay(4, function() msg:Destroy() end)
end)
