--[[
    Script: Loader
    Descripción: Punto de entrada principal. Carga la UI y el Aimbot.
    Autor: Yordan
]]

-- Asegurarse de que el script no se ejecute dos veces
if getgenv().AimbotLoaded then return end
getgenv().AimbotLoaded = true

-- Cargar la librería Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Esperar a que los servicios necesarios estén disponibles
local Players = game:GetService("Players")
repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character

-- Crear una instancia del núcleo del Aimbot
-- Asumimos que los otros scripts están en el mismo directorio relativo al loader
local AimbotCore = require(script.Parent.Core)
local myAimbot = AimbotCore.new()

-- Crear la interfaz de usuario y conectarla con el núcleo
local UIConfig = require(script.Parent.UI.RayfieldConfig)
UIConfig.Create(Rayfield, myAimbot)

print("Aimbot Universal cargado correctamente.")
