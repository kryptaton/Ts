-- Load OrionLib from online source
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Main Window
local Window = OrionLib:MakeWindow({
    Name = "🌌 Scripters Heaven by @ok",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ScriptersHeaven"
})

-- Global Toggles
getgenv().autoBubble = false
getgenv().autoSell = false
getgenv().autoHatch = false
getgenv().autoEnchant = false
getgenv().fpsBoost = false

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- Generic loop handler
local function toggleLoop(flag, delay, action)
    task.spawn(function()
        while getgenv()[flag] do
            pcall(action)
            task.wait(delay)
        end
    end)
end

-- FPS Boost Function
local function enableFPSBoost(enable)
    if enable then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Workspace").StreamingEnabled = false
        game:GetService("Workspace").Gravity = 0
        game:GetService("Workspace").Terrain.CanCollide = false
        game:GetService("Workspace").Terrain.Material = Enum.Material.SmoothPlastic
        game:GetService("Workspace").Terrain.WaterWaveSize = 0
        local waterfall = game:GetService("ReplicatedStorage"):FindFirstChild("Waterfall")
        if waterfall then
            waterfall:SetAttribute("Enabled", false)
        end
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("ParticleEmitter") then
                part.Enabled = false
            end
        end
    else
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Workspace").StreamingEnabled = true
        game:GetService("Workspace").Gravity = 196.2
        game:GetService("Workspace").Terrain.CanCollide = true
        game:GetService("Workspace").Terrain.Material = Enum.Material.SmoothPlastic
        game:GetService("Workspace").Terrain.WaterWaveSize = 1
        local waterfall = game:GetService("ReplicatedStorage"):FindFirstChild("Waterfall")
        if waterfall then
            waterfall:SetAttribute("Enabled", true)
        end
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("ParticleEmitter") then
                part.Enabled = true
            end
        end
    end
end

-- Welcome Tab
local InfoTab = Window:MakeTab({
    Name = "📢 Welcome",
    Icon = "rbxassetid://6031075938",
    PremiumOnly = false
})

InfoTab:AddParagraph("Welcome to Scripters Heaven", "Made with 💜 by @ok")
InfoTab:AddParagraph("Join our Discord", "🔗 https://discord.gg/mU9SSFRT")

-- Main Features Tab
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://6034977833",
    PremiumOnly = false
})

-- Auto Bubble
MainTab:AddToggle({
    Name = "🫧 Auto Bubble",
    Default = false,
    Callback = function(v)
        getgenv().autoBubble = v
        if v then toggleLoop("autoBubble", 0.2, function()
            Events.BlowBubble:FireServer()
        end) end
    end
})

-- Auto Sell
MainTab:AddToggle({
    Name = "💰 Auto Sell",
    Default = false,
    Callback = function(v)
        getgenv().autoSell = v
        if v then toggleLoop("autoSell", 2, function()
            Events.Sell:FireServer()
        end) end
    end
})

-- Auto Hatch
MainTab:AddToggle({
    Name = "🐣 Fast Auto Hatch (Skip Animation)",
    Default = false,
    Callback = function(v)
        getgenv().autoHatch = v
        if v then toggleLoop("autoHatch", 0.1, function()
            Events.HatchEgg:FireServer()
        end) end
    end
})

-- Auto Enchant
MainTab:AddToggle({
    Name = "✨ Auto Enchant",
    Default = false,
    Callback = function(v)
        getgenv().autoEnchant = v
        if v then toggleLoop("autoEnchant", 2, function()
            Events.EnchantPet:FireServer()
        end) end
    end
})

-- FPS Boost
MainTab:AddToggle({
    Name = "🚀 FPS Boost",
    Default = false,
    Callback = function(value)
        getgenv().fpsBoost = value
        enableFPSBoost(value)
    end
})

-- Launch UI
OrionLib:Init()
