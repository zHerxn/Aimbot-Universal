--[[
    Módulo: RayfieldConfig
    Descripción: Configura y gestiona la UI de Rayfield.
    Autor: Yordan
]]

local RayfieldConfig = {}

function RayfieldConfig.Create(library, coreAimbot)
    local window = library:CreateWindow({
        Name = "Universal Aimbot by Yordan",
        LoadingTitle = "Cargando Sistema...",
        LoadingSubtitle = "by Yordan",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AimbotConfig",
            FileName = "UniversalAimbot"
        },
        Discord = {
            Enabled = false,
        },
        KeySystem = false
    })

    local settings = coreAimbot.Settings

    local combatTab = window:CreateTab("Combate", 4483362458)

    combatTab:CreateToggle({
        Name = "Activar Aimbot",
        CurrentValue = settings.Enabled,
        Flag = "AimbotEnabled",
        Callback = function(value)
            settings.Enabled = value
        end,
    })

    combatTab:CreateDropdown({
        Name = "Parte del Cuerpo",
        Options = {"Head", "UpperTorso", "HumanoidRootPart"},
        CurrentOption = settings.TargetPart,
        Flag = "TargetPart",
        Callback = function(option)
            settings.TargetPart = option
        end,
    })

    combatTab:CreateDropdown({
        Name = "Modo de Apuntado",
        Options = {"ClosestToCursor", "ClosestToPlayer"},
        CurrentOption = settings.AimMode,
        Flag = "AimMode",
        Callback = function(option)
            settings.AimMode = option
        end,
    })

    combatTab:CreateDropdown({
        Name = "Modo de Tecla",
        Options = {"Hold", "Toggle"},
        CurrentOption = settings.KeyMode,
        Flag = "KeyMode",
        Callback = function(option)
            settings.KeyMode = option
        end,
    })

    combatTab:CreateKeybind({
        Name = "Tecla de Activación",
        CurrentKeybind = settings.ActivationKey,
        Flag = "ActivationKey",
        Callback = function(key)
            settings.ActivationKey = key
        end,
    })

    combatTab:CreateToggle({
        Name = "Mostrar Círculo FOV",
        CurrentValue = settings.FovVisible,
        Flag = "FovVisible",
        Callback = function(value)
            settings.FovVisible = value
        end,
    })

    combatTab:CreateSlider({
        Name = "Radio del FOV",
        Range = {25, 500},
        Increment = 5,
        Suffix = "px",
        CurrentValue = settings.FovRadius,
        Flag = "FovRadius",
        Callback = function(value)
            settings.FovRadius = value
        end,
    })

    combatTab:CreateColorpicker({
        Name = "Color del FOV",
        Color = settings.FovColor,
        Flag = "FovColor",
        Callback = function(color)
            settings.FovColor = color
        end,
    })

    combatTab:CreateSlider({
        Name = "Suavizado",
        Range = {0, 0.99},
        Increment = 0.01,
        Suffix = " (más es más suave)",
        CurrentValue = settings.Smoothing,
        Flag = "Smoothing",
        Callback = function(value)
            settings.Smoothing = value
        end,
    })

    combatTab:CreateToggle({
        Name = "Activar Predicción",
        CurrentValue = settings.Prediction,
        Flag = "PredictionEnabled",
        Callback = function(value)
            settings.Prediction = value
        end,
    })

end

return RayfieldConfig
