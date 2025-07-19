-- ✨ AGE 50 UI SCRIPT v2 ✨
-- Works on Arceus X, KRNL, Fluxus, Delta

local lastPetUUID = nil -- will auto-update when you feed manually
local remote = game:GetService("ReplicatedStorage").GameEvents.ActivePetService

-- 📦 Hook Remote Calls to Capture UUID Automatically
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if tostring(self) == "ActivePetService" and method == "FireServer" and args[1] == "Feed" then
        lastPetUUID = args[2]
        print("📦 Captured Pet UUID:", lastPetUUID)
    end
    return oldNamecall(self, unpack(args))
end)

-- 🖥 UI Elements
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PetAgeUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.75, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "🐾 Age Pet to 50"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0, 30)
button.Position = UDim2.new(0.1, 0, 0.55, 0)
button.Text = "Start Feeding"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 14

-- ✅ Button Logic
button.MouseButton1Click:Connect(function()
    if lastPetUUID == nil then
        button.Text = "⚠️ No pet detected!"
        task.wait(2)
        button.Text = "Start Feeding"
        return
    end

    button.Text = "Feeding..."
    for i = 1, 100 do
        remote:FireServer("Feed", lastPetUUID)
        task.wait(0.05)
    end
    button.Text = "✅ Done!"
    task.wait(2)
    button.Text = "Start Feeding"
end)

-- 🎹 Toggle GUI with "Y"
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Y then
        frame.Visible = not frame.Visible
    end
end)

print("✅ Pet Age UI loaded! Feed a pet once manually so it can detect the ID.")
