-- 🐾 AGE 50 BYPASS GUI SCRIPT 🐾
-- Works with KRNL, Fluxus, Delta, Arceus X

local petId = "{82e4a72b-5756-4933-a2f1-d77b557ef9c8}" -- put your pet ID here!

local remote = game:GetService("ReplicatedStorage").GameEvents.ActivePetService

-- UI LIBRARY
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PetIdLabel = Instance.new("TextLabel")
local AgeLabel = Instance.new("TextLabel")
local WeightLabel = Instance.new("TextLabel")
local FeedBtn = Instance.new("TextButton")
local ToggleKey = Enum.KeyCode.Y

-- SETUP UI
ScreenGui.Name = "PetAgeUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.7, 0, 0.3, 0)
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Active = true
Main.Draggable = true
Main.Visible = true

Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🐾 Pet Age Tool"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold

PetIdLabel.Name = "PetIdLabel"
PetIdLabel.Parent = Main
PetIdLabel.Position = UDim2.new(0, 10, 0, 35)
PetIdLabel.Size = UDim2.new(1, -20, 0, 20)
PetIdLabel.Text = "Pet ID: " .. petId
PetIdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PetIdLabel.TextSize = 13
PetIdLabel.BackgroundTransparency = 1
PetIdLabel.Font = Enum.Font.Gotham

AgeLabel.Name = "AgeLabel"
AgeLabel.Parent = Main
AgeLabel.Position = UDim2.new(0, 10, 0, 55)
AgeLabel.Size = UDim2.new(1, -20, 0, 20)
AgeLabel.Text = "Age: ? (Spoof)"
AgeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AgeLabel.TextSize = 13
AgeLabel.BackgroundTransparency = 1
AgeLabel.Font = Enum.Font.Gotham

WeightLabel.Name = "WeightLabel"
WeightLabel.Parent = Main
WeightLabel.Position = UDim2.new(0, 10, 0, 75)
WeightLabel.Size = UDim2.new(1, -20, 0, 20)
WeightLabel.Text = "Weight: ? (Spoof)"
WeightLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WeightLabel.TextSize = 13
WeightLabel.BackgroundTransparency = 1
WeightLabel.Font = Enum.Font.Gotham

FeedBtn.Name = "FeedBtn"
FeedBtn.Parent = Main
FeedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
FeedBtn.Position = UDim2.new(0.2, 0, 0.75, 0)
FeedBtn.Size = UDim2.new(0.6, 0, 0.18, 0)
FeedBtn.Text = "Make Age 50"
FeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FeedBtn.TextSize = 14
FeedBtn.Font = Enum.Font.GothamBold

-- Button Logic
FeedBtn.MouseButton1Click:Connect(function()
    spawn(function()
        for i = 1, 100 do
            remote:FireServer("Feed", petId)
            task.wait(0.05)
        end
        FeedBtn.Text = "✅ Done!"
        task.wait(1)
        FeedBtn.Text = "Make Age 50"
    end)
end)

-- Toggle Keybind (press "Y" to hide/show GUI)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == ToggleKey then
        Main.Visible = not Main.Visible
    end
end)
