--// UI Lib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = Library:MakeWindow({
    Name = "Pet Garden Hub",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false,
    ConfigFolder = "NoLagStyle",
    IntroText = "Pet Garden Hub"
})

--// Variables
local SelectedPet = nil
local MoveToMiddle = false

--// Get Pet List (from garden)
local function GetGardenPets()
    local pets = {}
    for _, pet in pairs(workspace.GardenPets:GetChildren()) do
        if pet:IsA("Model") then
            table.insert(pets, pet.Name)
        end
    end
    return pets
end

--// Move Pet to Middle Function
local function MovePetToCenter(petName)
    local pet = workspace.GardenPets:FindFirstChild(petName)
    if pet then
        local center = workspace:FindFirstChild("GardenCenter") or Vector3.new(0, 0, 0)
        pet:SetPrimaryPartCFrame(CFrame.new(center.Position))
    end
end

--// Pet Movement Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if MoveToMiddle and SelectedPet then
            MovePetToCenter(SelectedPet)
        end
    end
end)

--// MAIN TAB
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7734053494",
    PremiumOnly = false
})

--// Dropdown to select pet
MainTab:AddDropdown({
    Name = "Select Pet",
    Default = "",
    Options = GetGardenPets(),
    Callback = function(value)
        SelectedPet = value
    end
})

--// Refresh Button
MainTab:AddButton({
    Name = "🔄 Refresh Pet List",
    Callback = function()
        MainTab:UpdateDropdownOptions("Select Pet", GetGardenPets())
    end
})

--// Toggle to enable logic
MainTab:AddToggle({
    Name = "🔁 Auto Move To Middle",
    Default = false,
    Callback = function(state)
        MoveToMiddle = state
    end
})

--// UI Toggle Keybind
Library:Init()
