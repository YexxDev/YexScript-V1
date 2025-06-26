-- YexScript Devil Fruit ESP + Server Hop (First Sea)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local fruitsToTrack = {
    "Rocket", "Bomb", "Spike", "Rubber", "Light", "Ice", "Magma",
    "Shadow", "Mammoth", "Dragon", "Leopard", "Kitsune", "Yeti",
    "Venom", "Gas", "Eagle", "Smoke", "Ghost", "Diamond", "Creation", "Dark",
    "Chop", "Spring", "Flame", "Sand"
}

-- Fancy loading animation before server hop
local function showServerHopLoading()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "YexHopUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0.5, -25)
    frame.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    local text = "SERVER HOPPING..."
    for i = 1, #text do
        label.Text = text:sub(1, i)
        wait(0.2)
    end

    wait(0.5)
    gui:Destroy()
end

-- ESP function
local function createESP(obj)
    if obj:FindFirstChild("ESP_YEX") then return end
    if not obj:IsA("Tool") then return end

    local handle = obj:FindFirstChild("Handle")
    if not handle then return end

    local gui = Instance.new("BillboardGui", obj)
    gui.Name = "ESP_YEX"
    gui.Size = UDim2.new(0, 100, 0, 30)
    gui.Adornee = handle
    gui.AlwaysOnTop = true

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "🍉 " .. obj.Name
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
end

-- Find devil fruit in current server
local function findDevilFruit()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and table.find(fruitsToTrack, v.Name) then
            createESP(v)
            return true
        end
    end
    return false
end

-- Server hop logic
local function serverHop()
    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not request then
        warn("❌ Executor doesn't support HTTP requests!")
        return
    end

    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function()
        return request({ Url = url })
    end)

    if success and result and result.Body then
        local data = HttpService:JSONDecode(result.Body)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                showServerHopLoading()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    else
        warn("⚠️ Failed to fetch server list.")
    end
end

-- Main loop
while true do
    wait(3)
    if not findDevilFruit() then
        serverHop()
    else
        break
    end
end
