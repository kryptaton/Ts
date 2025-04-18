local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = game:GetService("Workspace").CurrentCamera

local speedMultiplier = 200
local normalSpeed = 16
local isActive = false
local runConnection

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "ReverseFlashGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
button.TextColor3 = Color3.fromRGB(1, 1, 1)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Text = "Enable Reverse Flash"
button.Parent = gui

-- Debugging: Print statements
print("Script loaded successfully!")

-- Function to create lightning curled around the body while standing still
local function spawnCurledBodyLightning()
    print("Spawning curled lightning...") -- Debug
    local lightning = Instance.new("Part")
    lightning.Size = Vector3.new(0.2, 0.2, math.random(2, 4))  -- Shorten the lightning
    lightning.Anchored = true
    lightning.CanCollide = false
    lightning.Material = Enum.Material.Neon
    lightning.Color = Color3.fromRGB(255, 0, 0)
    lightning.CFrame = hrp.CFrame

    -- Make the lightning curl around the body
    local angleOffset = math.random(0, 360)  -- Randomize angle to create a curl effect
    local heightOffset = math.random(1, 2)
    local radius = math.random(2, 4)
    
    local offset = Vector3.new(
        math.cos(math.rad(angleOffset)) * radius,
        heightOffset,
        math.sin(math.rad(angleOffset)) * radius
    )

    lightning.CFrame = hrp.CFrame * CFrame.new(offset)

    -- Add random curve effect using BodyVelocity or Tween
    local curve = Instance.new("BodyVelocity")
    curve.MaxForce = Vector3.new(5000, 5000, 5000)
    curve.Velocity = Vector3.new(math.random(-20, 20), math.random(-10, 10), math.random(-20, 20))
    curve.Parent = lightning

    -- Add glowing effect
    local lightEffect = Instance.new("PointLight")
    lightEffect.Parent = lightning
    lightEffect.Color = Color3.fromRGB(255, 0, 0)
    lightEffect.Range = 5  -- Reduce glow range
    lightEffect.Brightness = 1 -- Less glowing intensity

    lightning.Parent = workspace

    -- Fade out the lightning after a short time
    game:GetService("TweenService"):Create(lightning, TweenInfo.new(0.5), {Transparency = 1}):Play()
    game:GetService("Debris"):AddItem(lightning, 0.5)
end

-- Function to create larger lightning from the body (sprawling effect)
local function spawnBodyLightning()
    print("Spawning body lightning...") -- Debug
    local angle = math.rad(math.random(0, 360))
    local radius = math.random(1, 2) -- Randomize radius for variety
    local height = math.random(-2, 2)

    local offset = Vector3.new(
        math.cos(angle) * radius,
        height,
        math.sin(angle) * radius
    )

    local length = math.random(3, 4) -- Shorten the length
    local boltEnd = hrp.Position + offset + Vector3.new(math.random(-4, 4), math.random(-2, 2), math.random(-4, 4))

    local lightning = Instance.new("Part")
    lightning.Size = Vector3.new(0.2, 0.2, length)
    lightning.Anchored = true
    lightning.CanCollide = false
    lightning.Material = Enum.Material.Neon
    lightning.Color = Color3.fromRGB(255, 0, 0)
    lightning.CFrame = CFrame.new(hrp.Position, boltEnd) * CFrame.new(0, 0, -length / 2)

    -- Add glowing effect
    local lightEffect = Instance.new("PointLight")
    lightEffect.Parent = lightning
    lightEffect.Color = Color3.fromRGB(255, 0, 0)
    lightEffect.Range = 7  -- Reduced glow range
    lightEffect.Brightness = 1.5  -- Slightly less brightness

    lightning.Parent = workspace

    -- Add random curve effect using BodyVelocity or Tween
    local curve = Instance.new("BodyVelocity")
    curve.MaxForce = Vector3.new(5000, 5000, 5000)
    curve.Velocity = Vector3.new(math.random(-20, 20), math.random(-10, 10), math.random(-20, 20))
    curve.Parent = lightning

    -- Fade out the lightning after a short time
    game:GetService("TweenService"):Create(lightning, TweenInfo.new(0.3), {Transparency = 1}):Play()
    game:GetService("Debris"):AddItem(lightning, 0.3)
end

-- Function to add glowing effects around the character
local function addCharacterGlow()
    local lightEffect = Instance.new("PointLight")
    lightEffect.Parent = hrp
    lightEffect.Color = Color3.fromRGB(255, 0, 0) -- Glow color
    lightEffect.Range = 10  -- Reduced glow range
    lightEffect.Brightness = 2  -- Slightly dimmer glow
end

-- Activate reverse flash speed and effects
local function enableReverseFlash()
    print("Enabling Reverse Flash...") -- Debug
    humanoid.WalkSpeed = speedMultiplier

    -- Add glow around the character
    addCharacterGlow()

    runConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if humanoid.MoveDirection.Magnitude > 0 then
            for _ = 1, 3 do
                spawnBodyLightning()
            end
        else
            -- Spawn curled lightning around the body while standing still
            for _ = 1, 2 do
                spawnCurledBodyLightning()
            end
        end
    end)
end

-- Deactivate reverse flash effects
local function disableReverseFlash()
    print("Disabling Reverse Flash...") -- Debug
    humanoid.WalkSpeed = normalSpeed

    if runConnection then
        runConnection:Disconnect()
        runConnection = nil
    end
end

-- Button toggle logic
button.MouseButton1Click:Connect(function()
    isActive = not isActive

    if isActive then
        button.Text = "Disable Reverse Flash"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        enableReverseFlash()
    else
        button.Text = "Enable Reverse Flash"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        disableReverseFlash()
    end
end)
