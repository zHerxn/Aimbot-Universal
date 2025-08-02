--[[
    Módulo: FOVCircle
    Descripción: Gestiona la creación y renderización del círculo de FOV.
    Autor: Yordan
]]

local FOVCircle = {}
FOVCircle.__index = FOVCircle

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function FOVCircle.new()
    local self = setmetatable({}, FOVCircle)

    self.Circle = Drawing.new("Circle")
    self.Circle.Visible = false
    self.Circle.Radius = 100
    self.Circle.Color = Color3.fromRGB(255, 255, 255)
    self.Circle.Thickness = 1
    self.Circle.Filled = false
    self.Circle.NumSides = 64 -- Un círculo más suave

    RunService:BindToRenderStep("FOVCircleUpdate", Enum.RenderPriority.Input.Value, function()
        if self.Circle.Visible then
            local mouseLocation = UserInputService:GetMouseLocation()
            self.Circle.Position = mouseLocation
        end
    end)

    return self
end

function FOVCircle:SetVisible(visible)
    self.Circle.Visible = visible
end

function FOVCircle:SetRadius(radius)
    self.Circle.Radius = radius
end

function FOVCircle:SetColor(color)
    self.Circle.Color = color
end

function FOVCircle:Destroy()
    RunService:UnbindFromRenderStep("FOVCircleUpdate")
    self.Circle:Remove()
end

return FOVCircle
