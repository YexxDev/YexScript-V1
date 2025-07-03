-- YexScript - Auto Buy Seed with Rayfield UI (Updated)

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "YexScript Hub",
    LoadingTitle = "YEXSCRIPT",
    LoadingSubtitle = "by Yex",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "YexScriptHub",
       FileName = "YexScriptSettings"
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

-- Create Tab
local ShopTab = Window:CreateTab("Shop", 4483362458)

-- Variables
local selectedSeed = "Carrot"
local autoBuy = false

-- Dropdown for selecting seed
ShopTab:CreateDropdown({
    Name = "Select Seed to Auto Buy",
    Options = {
        "Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower",
        "Watermelon", "Green Apple", "Avocado", "Banana", "Pineapple",
        "Kiwi", "Bell Pepper", "Prickly Pear", "Laquat", "Feijoa", "Sugar Apple"
    },
    CurrentOption = "Carrot",
    Flag = "SeedSelect",
    Callback = function(Option)
        selectedSeed = Option
    end
})

-- Toggle for auto buy
ShopTab:CreateToggle({
    Name = "Auto Buy Seed (if in stock)",
    CurrentValue = false,
    Flag = "AutoBuySeed",
    Callback = function(Value)
        autoBuy = Value
    end
})

-- Loop to run auto buy
spawn(function()
    while true do
        wait(2)
        if autoBuy and selectedSeed then
            pcall(function()
                game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(selectedSeed)
            end)
        end
    end
end)
