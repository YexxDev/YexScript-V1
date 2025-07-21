--// Remote and Click Spy Script with Medium UI & Copy buttons
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RemoteSpyUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 450, 0, 350)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "📡 Remote/Click Spy"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.SourceSansSemibold
Title.TextSize = 18

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0

-- Add UIListLayout to organize items
local layout = Instance.new("UIListLayout", ScrollingFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

local index = 0

-- Helper function to add entries
local function addEntry(text, copyText)
	index += 1

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 60)
	holder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	holder.BorderSizePixel = 0
	holder.Parent = ScrollingFrame

	local lbl = Instance.new("TextLabel", holder)
	lbl.Size = UDim2.new(1, -80, 1, -10)
	lbl.Position = UDim2.new(0, 5, 0, 5)
	lbl.Text = index..". "..text
	lbl.TextWrapped = true
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local copyBtn = Instance.new("TextButton", holder)
	copyBtn.Size = UDim2.new(0, 60, 0, 25)
	copyBtn.Position = UDim2.new(1, -65, 1, -30)
	copyBtn.Text = "Copy"
	copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	copyBtn.Font = Enum.Font.SourceSans
	copyBtn.TextSize = 14
	copyBtn.MouseButton1Click:Connect(function()
		setclipboard(copyText)
	end)

	-- Resize canvas
	task.wait()
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Remote Spy Hook
local function hookRemote(obj)
	if obj:IsA("RemoteEvent") then
		local old; old = hookfunction(obj.FireServer, function(self, ...)
			local args = {...}
			local data = HttpService:JSONEncode(args)
			addEntry("RemoteEvent: "..self:GetFullName().."\nArgs: "..data, 'game:GetService("'..self.Parent.Name..'").'..self.Name..':FireServer('..data..')')
			return old(self, ...)
		end)
	elseif obj:IsA("RemoteFunction") then
		local old; old = hookfunction(obj.InvokeServer, function(self, ...)
			local args = {...}
			local data = HttpService:JSONEncode(args)
			addEntry("RemoteFunction: "..self:GetFullName().."\nArgs: "..data, 'game:GetService("'..self.Parent.Name..'").'..self.Name..':InvokeServer('..data..')')
			return old(self, ...)
		end)
	end
end

-- Initial hook of existing Remotes
for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		hookRemote(v)
	end
end

-- Listen for new remotes
game.DescendantAdded:Connect(function(obj)
	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
		hookRemote(obj)
	end
end)

-- Click Detector Spy
local function onClickDetected(part)
	addEntry("Clicked part: "..part:GetFullName(), part:GetFullName())
end

for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("ClickDetector") then
		obj.MouseClick:Connect(function(plr)
			if plr == LocalPlayer then
				onClickDetected(obj.Parent)
			end
		end)
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ClickDetector") then
		obj.MouseClick:Connect(function(plr)
			if plr == LocalPlayer then
				onClickDetected(obj.Parent)
			end
		end)
	end
end)

-- Screen touch and input spy
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe then
		addEntry("Input Detected: "..tostring(input.UserInputType), tostring(input.UserInputType))
	end
end)
