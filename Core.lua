local Core = {}
Core.__index = Core

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

function Core.new()
    local self = setmetatable({}, Core)

    self.Settings = {
        Enabled = false,
        TargetPart = "Head",
        AimMode = "ClosestToCursor", -- "ClosestToCursor" or "ClosestToPlayer"
        ActivationKey = Enum.KeyCode.E,
        KeyMode = "Hold", -- "Hold" or "Toggle"
        FovRadius = 150,
        FovColor = Color3.fromRGB(255, 255, 255),
        FovVisible = true,
        Smoothing = 0.15, -- 0 = instant, 1 = very slow
        Prediction = false
    }

    self.Targeting = require(script.Parent.Targeting)
    self.Prediction = require(script.Parent.Prediction)
    self.FOVCircle = require(script.Parent.FOVCircle).new()

    self.CurrentTarget = nil
    self.isAiming = false
    self.isToggleActive = false

    self:SetupConnections()

    return self
end

function Core:AimAt(targetPosition)
    local smoothing = self.Settings.Smoothing
    local newCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)

    -- Si el suavizado es casi nulo, aplicamos directamente para evitar overhead
    if smoothing <= 0.01 then
        Camera.CFrame = newCFrame
    else
        -- Slerp para un movimiento suave y curvo
        Camera.CFrame = Camera.CFrame:Slerp(newCFrame, 1 - smoothing)
    end
end

function Core:Update()
    if not self.Settings.Enabled or not self.isAiming then
        self.CurrentTarget = nil
        return
    end

    self.CurrentTarget = self.Targeting.GetClosestTarget(self.Settings)

    if self.CurrentTarget then
        local targetPart = self.CurrentTarget:FindFirstChild(self.Settings.TargetPart) or self.CurrentTarget.HumanoidRootPart
        if not targetPart then
            self.CurrentTarget = nil
            return
        end

        local aimPosition
        if self.Settings.Prediction then
            aimPosition = self.Prediction.PredictFuturePosition(self.CurrentTarget, targetPart)
        else
            aimPosition = targetPart.Position
        end

        if aimPosition then
            self:AimAt(aimPosition)
        end
    end
end

function Core:SetupConnections()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == self.Settings.ActivationKey then
            if self.Settings.KeyMode == "Toggle" then
                self.isToggleActive = not self.isToggleActive
                self.isAiming = self.isToggleActive
            else -- Hold
                self.isAiming = true
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == self.Settings.ActivationKey then
            if self.Settings.KeyMode == "Hold" then
                self.isAiming = false
            end
        end
    end)

    RunService:BindToRenderStep("AimbotCoreUpdate", Enum.RenderPriority.Camera.Value + 1, function()
        self:Update()
        self.FOVCircle:SetVisible(self.Settings.FovVisible and self.Settings.Enabled and self.Settings.AimMode == "ClosestToCursor")
        self.FOVCircle:SetRadius(self.Settings.FovRadius)
        self.FOVCircle:SetColor(self.Settings.FovColor)
    end)
end

return Core
