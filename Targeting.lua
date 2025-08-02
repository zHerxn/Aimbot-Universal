-[[
    Módulo: Targeting
    Descripción: Lógica para encontrar, filtrar y seleccionar el mejor objetivo.
    Autor: Yordan
]]

local Targeting = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

function Targeting.GetPlayers()
    return Players:GetPlayers()
end

function Targeting.IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)

    local ignoreList = {LocalPlayer.Character, targetPart.Parent}
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

    return (not hit) or (hit:IsDescendantOf(targetPart.Parent))
end

function Targeting.GetClosestTarget(settings)
    local potentialTargets = {}
    local mouseLocation = UserInputService:GetMouseLocation()
    local fovRadius = settings.FovRadius
    local targetPartName = settings.TargetPart
    local closestPlayerDist = math.huge
    local target = nil

    for _, player in ipairs(Targeting.GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and humanoid.Health > 0 and rootPart and (not player.Team or player.Team ~= LocalPlayer.Team) then
                local targetPart = player.Character:FindFirstChild(targetPartName) or rootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)

                if onScreen and Targeting.IsVisible(targetPart) then
                    local distance
                    if settings.AimMode == "ClosestToCursor" then
                        distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                    else -- ClosestToPlayer
                        distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                    end

                    if distance < closestPlayerDist then
                        if settings.AimMode == "ClosestToCursor" then
                            if distance <= fovRadius then
                                closestPlayerDist = distance
                                target = player.Character
                            end
                        else
                            closestPlayerDist = distance
                            target = player.Character
                        end
                    end
                end
            end
        end
    end

    return target
end

return Targeting
