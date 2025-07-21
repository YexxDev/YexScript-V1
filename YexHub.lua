-- Remote Spy with UI (Medium size + Copy buttons)
-- Author: ChatGPT (Yexel's request)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Clean old UI if any
if CoreGui:FindFirstChild("RemoteSpyUI") then
    CoreGui.RemoteSpyUI:Destroy()
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RemoteSpyUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 500, 0, 350)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Remote Spy Logger"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.BorderSizePixel = 0

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.BackgroundTransparency = 0.1
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Utility Function
local function logRemote(actionType, remote, ...)
    local args = {...}
    local argText = ""
    for i, v in pairs(args) do
        local success, result = pcall(function()
            return HttpService:JSONEncode(v)
        end)
        argText = argText .. "["..i.."] " .. (success and result or tostring(v)) .. "\n"
    end

    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -10, 0, 120)
    entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    entry.Parent = ScrollingFrame
    entry.BorderSizePixel = 0

    local label = Instance.new("TextLabel", entry)
    label.Size = UDim2.new(1, -10, 0, 90)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Text = string.format("[%s] %s\n%s", actionType, remote:GetFullName(), argText)

    local copyButton = Instance.new("TextButton", entry)
    copyButton.Size = UDim2.new(0, 100, 0, 25)
    copyButton.Position = UDim2.new(1, -105, 1, -30)
    copyButton.Text = "Copy"
    copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    copyButton.TextColor3 = Color3.new(1, 1, 1)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 14
    copyButton.MouseButton1Click:Connect(function()
        setclipboard(label.Text)
    end)
end

-- Hook RemoteEvents and Functions
local function hookRemotes()
    local rawmt = getrawmetatable(game)
    local namecall = rawmt.__namecall
    setreadonly(rawmt, false)

    rawmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            logRemote(method, self, ...)
        end
        return namecall(self, ...)
    end)
end

-- ClickDetector & Touch
local function hookMouse()
    Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target then
            logRemote("Click", target)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart").Touched:Connect(function(hit)
            logRemote("Touch", hit)
        end)
    end)
end

hookRemotes()
hookMouse()
logRemote("Spy", workspace, "Spy started successfully.")
