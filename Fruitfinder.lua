-- YexScript Devil Fruit ESP + Server Hop (Stable Fix)

local fruitsToFind = {
    "Rocket", "Bomb", "Spike", "Rubber", "Light", "Ice", "Magma",
    "Shadow", "Mammoth", "Dragon", "Leopard", "Kitsune", "Yeti",
    "Venom", "Gas", "Eagle", "Smoke", "Ghost", "Diamond", "Creation", "Dark",
    "Chop", "Spring", "Flame", "Sand"
}

-- Fancy loading
local function showLoadingAnimation()
    local text = "SERVERHOP"
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "YexLoading"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 240, 0, 50)
    frame.Position = UDim2.new(0.5, -120, 0.5, -25)
    frame.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
    frame.BackgroundTransparency = 0.3

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    for i = 1, #text do
        label.Text = text:sub(1, i)
        wait(0.5)
    end

    wait(0.5)
    gui:Destroy()
end

-- ESP
local function fruitESP(fruit)
    if fruit:FindFirstChild("ESP_YEX") then return end
    local handle = fruit:FindFirstChild("Handle")
    if not handle then return end

    local gui = Instance.new("BillboardGui", fruit)
    gui.Name = "ESP_YEX"
    gui.Size = UDim2.new(0, 100, 0, 30)
    gui.Adornee = handle
    gui.AlwaysOnTop = true

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "🍇 " .. fruit.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
end

-- Teleport
local function teleportToFruit(fruit)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local handle = fruit:FindFirstChild("Handle")
    if hrp and handle then
        hrp.CFrame = handle.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Detect Fruit
local function findFruit()
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and table.find(fruitsToFind, item.Name) then
            fruitESP(item)
            teleportToFruit(item)
            return true
        end
    end
    return false
end

-- Server Hop
local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer

    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not request then
        warn("❌ This executor does not support HTTP requests!")
        return
    end

    local success, res = pcall(function()
        return request({
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        })
    end)

    if not success then return end

    local data = HttpService:JSONDecode(res.Body)
    for _, v in ipairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            showLoadingAnimation()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player)
            break
        end
    end
end

-- Main
while task.wait(3) do
    if not findFruit() then
        serverHop()
    else
        break
    end
end
