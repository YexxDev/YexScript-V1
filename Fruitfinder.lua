-- YexScript Devil Fruit ESP + Server Hop + Auto Collect

-- 💥 Fruits to Detect:
local fruitsToFind = {
    "Rocket", "Bomb", "Spike", "Rubber", "Light", "Ice", "Magma",
    "Shadow", "Mammoth", "Dragon", "Leopard", "Kitsune", "Yeti",
    "Venom", "Gas", "Eagle", "Smoke", "Ghost", "Diamond", "Creation", "Dark",
    "Chop", "Spring", "Flame", "Sand"
}

-- 🎬 Fancy loading animation
local function showLoadingAnimation()
    local word = "SERVERHOP"
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "YexLoading"

    local frame = Instance.new("Frame", screenGui)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 260, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true

    for i = 1, #word do
        text.Text = word:sub(1, i)
        wait(0.5)
    end

    screenGui:Destroy()
end

-- 🔎 ESP
local function fruitESP(fruit)
    if fruit:FindFirstChild("ESP_Yex") then return end

    local gui = Instance.new("BillboardGui", fruit)
    gui.Name = "ESP_Yex"
    gui.Size = UDim2.new(0, 120, 0, 30)
    gui.AlwaysOnTop = true
    gui.Adornee = fruit:FindFirstChild("Handle") or fruit

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "🍇 " .. fruit.Name .. " 🍇"
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
end

-- 📦 Teleport player to fruit
local function teleportToFruit(fruit)
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and fruit and fruit:IsA("Tool") then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0, 5, 0)
    end
end

-- 🍉 Detect fruit in current server
local function findFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and table.find(fruitsToFind, obj.Name) then
            fruitESP(obj)
            teleportToFruit(obj)
            return true
        end
    end
    return false
end

-- 🌍 Server hop
local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer

    local req = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
    if not req then return warn("Executor does not support HTTP requests.") end

    local success, response = pcall(function()
        return req({
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        })
    end)

    if success and response and response.Body then
        local data = HttpService:JSONDecode(response.Body)
        local servers = {}

        for _, v in pairs(data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end

        if #servers > 0 then
            showLoadingAnimation()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
        end
    end
end

-- 🔁 Main Loop
while task.wait(3) do
    local found = findFruit()
    if not found then
        serverHop()
    else
        break
    end
end
