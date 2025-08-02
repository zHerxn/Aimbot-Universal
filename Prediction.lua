--[[
    Módulo: Prediction
    Descripción: Calcula la posición futura de un objetivo.
    Autor: Yordan
]]

local Prediction = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Prediction.GetPing()
    -- GetNetworkPing() está obsoleto, usamos una alternativa moderna.
    -- El ping se devuelve en segundos, así que no necesitamos dividir por 1000.
    return tonumber(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()) / 1000
end


function Prediction.PredictFuturePosition(character, targetPart)
    if not character or not targetPart then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    local velocity = targetPart.AssemblyLinearVelocity
    local ping = Prediction.GetPing()

    -- Fórmula básica de predicción: Posición + (Velocidad * (Ping + TiempoDeReacciónSimple))
    -- Ajustamos el multiplicador para compensar el tiempo de viaje del proyectil si es necesario.
    local predictedPosition = targetPart.Position + (velocity * ping)

    return predictedPosition
end

return Prediction
