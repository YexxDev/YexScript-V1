-- Optimized Remote Spy with UI and Copy Button
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Create UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpyUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.25, 0, 0.1, 0)
Main.Name = "MainFrame"
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout")
UIList.Parent = Main
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 2)

local function createLogBox(text)
	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(1, -4, 0, 50)
	Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Box.BorderSizePixel = 0

	local Txt = Instance.new("TextLabel", Box)
	Txt.Size = UDim2.new(0.8, 0, 1, 0)
	Txt.Text = text
	Txt.TextXAlignment = Enum.TextXAlignment.Left
	Txt.TextColor3 = Color3.new(1,1,1)
	Txt.Font = Enum.Font.SourceSans
	Txt.TextSize = 14
	Txt.BackgroundTransparency = 1

	local Btn = Instance.new("TextButton", Box)
	Btn.Size = UDim2.new(0.2, 0, 1, 0)
	Btn.Position = UDim2.new(0.8, 0, 0, 0)
	Btn.Text = "Copy"
	Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Font = Enum.Font.SourceSans
	Btn.TextSize = 14

	Btn.MouseButton1Click:Connect(function()
		setclipboard(text)
	end)

	return Box
end

local function logAction(action)
	task.defer(function()
		if #Main:GetChildren() > 20 then
			for i = 1, 5 do
				if Main:GetChildren()[i] and Main:GetChildren()[i]:IsA("Frame") then
					Main:GetChildren()[i]:Destroy()
				end
			end
		end
		local Log = createLogBox(action)
		Log.Parent = Main
	end)
end

-- Catch remotes
for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		local name = v:GetFullName()
		pcall(function()
			if v:IsA("RemoteEvent") then
				v.OnClientEvent:Connect(function(...)
					local args = {...}
					logAction("[RemoteEvent] "..name.." | Args: "..game:GetService("HttpService"):JSONEncode(args))
				end)
			elseif v:IsA("RemoteFunction") then
				v.OnClientInvoke = function(...)
					local args = {...}
					logAction("[RemoteFunction] "..name.." | Invoked with: "..game:GetService("HttpService"):JSONEncode(args))
				end
			end
		end)
	end
end

-- Detect ClickDetectors & Touch
local function setupClickAndTouch()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") then
			v.MouseClick:Connect(function(p)
				if p == player then
					logAction("[ClickDetector] Clicked: "..v:GetFullName())
				end
			end)
		elseif v:IsA("TouchTransmitter") and v.Parent then
			v.Parent.Touched:Connect(function(hit)
				if hit and hit:IsDescendantOf(player.Character) then
					logAction("[Touch] "..v.Parent:GetFullName())
				end
			end)
		end
	end
end

setupClickAndTouch()

-- Detect user input taps/clicks
UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		logAction("[Input] "..tostring(input.UserInputType).." at "..tostring(input.Position))
	end
end)

-- Done
logAction("✅ Remote Spy Started")
