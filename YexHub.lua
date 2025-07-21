--// Full RemoteEvent/Function Spy Tool with Big UI and Copy Button
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Destroy old UI if exists
pcall(function() game.CoreGui:FindFirstChild("RemoteSpyUI"):Destroy() end)

-- Create UI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RemoteSpyUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔥 Remote Spy Tool with Copy"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIList = Instance.new("UIListLayout", ScrollingFrame)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function formatArgument(arg)
	local typeofArg = typeof(arg)
	if typeofArg == "string" then
		return string.format("%q", arg)
	elseif typeofArg == "Instance" then
		return string.format("game.%s", arg:GetFullName())
	elseif typeofArg == "Vector3" then
		return string.format("Vector3.new(%s, %s, %s)", arg.X, arg.Y, arg.Z)
	elseif typeofArg == "CFrame" then
		return string.format("CFrame.new(%s)", tostring(arg))
	elseif typeofArg == "table" then
		local success, result = pcall(function() return game:GetService("HttpService"):JSONEncode(arg) end)
		if success then return result end
	end
	return tostring(arg)
end

local function createEntry(name, args, method)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -12, 0, 60)
	Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame.BorderSizePixel = 0
	Frame.Parent = ScrollingFrame

	local Label = Instance.new("TextLabel", Frame)
	Label.Size = UDim2.new(1, -100, 1, 0)
	Label.Position = UDim2.new(0, 5, 0, 0)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Enum.TextYAlignment.Top
	Label.TextWrapped = true
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.TextSize = 14
	Label.Font = Enum.Font.Code
	Label.BackgroundTransparency = 1

	local code = method .. " = game." .. name .. ":" .. method .. "Server(" .. table.concat(args, ", ") .. ")"

	Label.Text = code

	local CopyButton = Instance.new("TextButton", Frame)
	CopyButton.Size = UDim2.new(0, 90, 0, 30)
	CopyButton.Position = UDim2.new(1, -95, 1, -35)
	CopyButton.Text = "Copy"
	CopyButton.TextColor3 = Color3.new(1, 1, 1)
	CopyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	CopyButton.Font = Enum.Font.SourceSansBold
	CopyButton.TextSize = 14

	CopyButton.MouseButton1Click:Connect(function()
		setclipboard(code)
	end)
end

-- Hook Metamethods
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = function(self, ...)
	local method = getnamecallmethod()
	local args = { ... }
	if method == "FireServer" or method == "InvokeServer" then
		local name = self:GetFullName()
		local formattedArgs = {}
		for i, v in ipairs(args) do
			table.insert(formattedArgs, formatArgument(v))
		end
		createEntry(name, formattedArgs, method)
	end
	return oldNamecall(self, ...)
end

setreadonly(mt, true)

-- Notification
game.StarterGui:SetCore("SendNotification", {
	Title = "Remote Spy",
	Text = "Now listening to FireServer & InvokeServer...",
	Duration = 5
})
