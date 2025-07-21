-- Remote Spy UI + Logger | For Touch, Click, FireServer, InvokeServer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Prevent duplicate UI
if CoreGui:FindFirstChild("RemoteSpyUI") then
    CoreGui:FindFirstChild("RemoteSpyUI"):Destroy()
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RemoteSpyUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0.4, 0, 0.5, 0)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Remote Spy (Click/Touch/Server Logs)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 10, 0)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 4)

local function logMessage(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 22)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Text = text
	label.Parent = ScrollingFrame
end

-- Hook FireServer
local oldFireServer
oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
	local args = {...}
	logMessage("[RemoteEvent] "..self:GetFullName().." fired with: "..HttpService:JSONEncode(args))
	return oldFireServer(self, unpack(args))
end)

-- Hook InvokeServer
local oldInvokeServer
oldInvokeServer = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(self, ...)
	local args = {...}
	logMessage("[RemoteFunction] "..self:GetFullName().." invoked with: "..HttpService:JSONEncode(args))
	return oldInvokeServer(self, unpack(args))
end)

-- Detect ClickDetectors and ProximityPrompts
for _, v in ipairs(workspace:GetDescendants()) do
	if v:IsA("ClickDetector") then
		v.MouseClick:Connect(function(player)
			logMessage("[ClickDetector] "..v:GetFullName().." clicked by "..player.Name)
		end)
	elseif v:IsA("ProximityPrompt") then
		v.Triggered:Connect(function(player)
			logMessage("[ProximityPrompt] "..v:GetFullName().." triggered by "..player.Name)
		end)
	end
end

-- Detect Tool Activation
LocalPlayer.CharacterAdded:Connect(function(char)
	char.ChildAdded:Connect(function(tool)
		if tool:IsA("Tool") then
			tool.Activated:Connect(function()
				logMessage("[Tool] Activated: "..tool.Name)
			end)
		end
	end)
end)

-- Detect Touched Events (optional)
workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ClickDetector") then
		obj.MouseClick:Connect(function(player)
			logMessage("[ClickDetector] "..obj:GetFullName().." clicked by "..player.Name)
		end)
	elseif obj:IsA("ProximityPrompt") then
		obj.Triggered:Connect(function(player)
			logMessage("[ProximityPrompt] "..obj:GetFullName().." triggered by "..player.Name)
		end)
	end
end)

logMessage("✅ Remote Spy Loaded. Waiting for interactions...")
