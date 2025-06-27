-- Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Global Controls
getgenv().EggESPEnabled = true
getgenv().SelectedEggType = "All"

-- Egg folder
local EggFolder = Workspace:WaitForChild("Eggs", 10)
if not EggFolder then
    warn("❌ Egg folder not found!")
    return
end

-- ESP Function
local function CreateEggESP(egg, petName)
    if egg:FindFirstChild("EggESP") then return end

    local esp = Instance.new("BillboardGui")
    esp.Name = "EggESP"
    esp.Adornee = egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
    esp.Size = UDim2.new(0, 100, 0, 40)
    esp.AlwaysOnTop = true
    esp.LightInfluence = 0
    esp.ResetOnSpawn = false

    local text = Instance.new("TextLabel", esp)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🐣 " .. petName
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextStrokeTransparency = 0.3
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold

    esp.Parent = egg
end

-- Main ESP loop
RunService.RenderStepped:Connect(function()
    if not getgenv().EggESPEnabled then return end

    for _, egg in pairs(EggFolder:GetChildren()) do
        if egg:IsA("Model") and not egg:FindFirstChild("EggESP") then
            local eggType = egg:FindFirstChild("EggType")
            local isReady = egg:FindFirstChild("ReadyToHatch")
            local petResult = egg:FindFirstChild("PredictedPet") or egg:FindFirstChild("Result")

            if isReady and isReady.Value == true then
                if getgenv().SelectedEggType == "All" or (eggType and eggType.Value == getgenv().SelectedEggType) then
                    local petName = petResult and petResult.Value or "Unknown"
                    CreateEggESP(egg, petName)
                end
            end
        end
    end
end)

-- GUI Setup
local Window = OrionLib:MakeWindow({
    Name = "🐣 Egg Prediction ESP",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Enable Egg Prediction ESP",
    Default = true,
    Callback = function(state)
        getgenv().EggESPEnabled = state
    end
})

MainTab:AddDropdown({
    Name = "Egg Type Filter",
    Default = "All",
    Options = { "All", "Common", "Uncommon", "Rare", "Mythic", "Paradise", "Bug" },
    Callback = function(option)
        getgenv().SelectedEggType = option
    end
})

OrionLib:Init()
