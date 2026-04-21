-- ═══════════════════════════════════════════════════════════════
--   MI HUB PERSONAL - Usando mi WindUI modificado
--   by TzHzk
-- ═══════════════════════════════════════════════════════════════

-- Cargar WindUI
local WindUI = require("./src/Init")

-- Variables
local SpeedEnabled = false
local SpeedValue = 16
local Player = game:GetService("Players").LocalPlayer

-- Aplicar velocidad
local function ApplySpeed()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SpeedEnabled and SpeedValue or 16
    end
end

-- Eventos
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplySpeed()
end)

-- Crear ventana
local Window = WindUI:CreateWindow({
    Title = "SPEED HUB",
    Icon = "zap",
    Theme = "Dark",
    Size = UDim2.fromOffset(350, 200)
})

-- Pestaña principal
local MainTab = Window:Tab({ Title = "Velocidad", Icon = "gauge" })

-- Toggle para activar/desactivar
MainTab:Toggle({
    Title = "Speed Activado",
    Desc = "Activa o desactiva la modificación de velocidad",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        ApplySpeed()
        WindUI:Notify({
            Title = "Speed",
            Content = state and "Activado" or "Desactivado",
            Duration = 2
        })
    end
})

-- Slider para ajustar velocidad
MainTab:Slider({
    Title = "Velocidad",
    Desc = "Ajusta la velocidad de movimiento",
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(value)
        SpeedValue = value
        if SpeedEnabled then
            ApplySpeed()
        end
    end
})

print("✅ Speed Hub cargado - Usando mi WindUI modificado")
