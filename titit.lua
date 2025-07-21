local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- KONFIGURASI
local HIT_FORCE = 50  -- Kekuatan pukulan
local HIT_RANGE = 12  -- Jarak deteksi bola
local COOLDOWN = 0.4  -- Cooldown pukulan

-- Variabel
local canHit = true

-- Fungsi untuk memukul bola (tanpa kontrol arah)
local function hitBall()
    if not canHit then return end

    local ball = workspace:FindFirstChild("Volleyball")
    if ball and (ball.Position - rootPart.Position).Magnitude < HIT_RANGE then
        canHit = false

        -- Arah pukulan mengikuti arah kamera (depan saja)
        local camera = workspace.CurrentCamera
        local direction = (camera.CFrame.LookVector + Vector3.new(0, 0.3, 0)).Unit

        -- Terapkan gaya
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = direction * HIT_FORCE
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = ball
        game:GetService("Debris"):AddItem(bodyVelocity, 0.1)

        -- Cooldown
        task.delay(COOLDOWN, function()
            canHit = true
        end)
    end
end

-- Pukul bola otomatis saat lompat
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping then
        task.delay(0.3, hitBall)  -- Delay saat di puncak lompatan
    end
end)
