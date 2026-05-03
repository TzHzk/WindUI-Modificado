-- AstraHub Zz - Script con Consola de Logs para Debugging
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

print("🔄 Iniciando AstraHub Zz con Debug Console...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz [DEBUG]",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZz",
    IgnoreAlerts = false,
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- CONSOLA DE LOGS VISUAL (Para ver errores reales)
-- ═══════════════════════════════════════════════════════════════
local DebugTab = Window:Tab({ Title = "Debug Console", Icon = "terminal" })

local LogFrame = DebugTab:Section({
    Title = "System Logs",
    Description = "Monitor de eventos en tiempo real",
    Collapsed = false
})

-- Función para agregar logs a la UI
local function AddLog(message, type)
    local color = Color3.fromRGB(255, 255, 255)
    if type == "ERROR" then color = Color3.fromRGB(255, 50, 50) end
    if type == "SUCCESS" then color = Color3.fromRGB(50, 255, 50) end
    if type == "WARN" then color = Color3.fromRGB(255, 165, 0) end
    
    print("[" .. type .. "] " .. message) -- También imprime en la consola F9
    
    -- Creamos un Label temporal en la sección
    local LogLabel = Instance.new("TextLabel")
    LogLabel.Size = UDim2.new(1, 0, 0, 20)
    LogLabel.BackgroundTransparency = 1
    LogLabel.Text = "[" .. os.date("%H:%M:%S") .. "] " .. message
    LogLabel.TextColor3 = color
    LogLabel.TextSize = 14
    LogLabel.Font = Enum.Font.Code
    LogLabel.TextXAlignment = "Left"
    LogLabel.Parent = LogFrame.ElementFrame.Content -- Añadimos al contenido de la sección
    
    -- Auto-scroll simple (opcional, requiere ajustar CanvasPosition si es ScrollingFrame)
end

AddLog("Consola de Debug iniciada...", "SUCCESS")

-- ═══════════════════════════════════════════════════════════════
-- MONITOREO DE TECLAS (RAW INPUT)
-- ═══════════════════════════════════════════════════════════════

-- Monitoreamos TODAS las teclas presionadas para ver si Roblox las detecta
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        
        -- Solo logueamos teclas relevantes para no saturar
        if keyName == "RightShift" or keyName == "Q" or keyName == "Insert" or keyName == "Home" then
            AddLog("Tecla Detectada: " .. keyName .. " | GameProcessed: " .. tostring(gameProcessed), "WARN")
            
            -- Verificamos si WindUI tiene la tecla configurada
            if Window and Window.ToggleKey then
                if Window.ToggleKey == input.KeyCode then
                    AddLog("✅ MATCH: La tecla coincide con Window.ToggleKey (" .. Window.ToggleKey.Name .. ")", "SUCCESS")
                else
                    AddLog("❌ NO MATCH: Window.ToggleKey es " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "ERROR")
                end
            else
                AddLog("❌ ERROR CRÍTICO: Window.ToggleKey es NIL", "ERROR")
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB PRINCIPAL Y KEYBIND TEST
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Prueba de Keybind",
    Desc = "Usa la consola de Debug para ver qué ocurre cuando presionas la tecla."
})

-- Keybind de WindUI
local kb = MainTab:Keybind({
    Title = "Tecla Abrir/Cerrar (WindUI)",
    Value = "RightShift",
    Callback = function(key)
        AddLog("Callback del Keybind ejecutado: " .. key, "SUCCESS")
    end
})

-- Botón para forzar cambio de tecla y ver si se actualiza
MainTab:Button({
    Title = "Forzar ToggleKey a 'Q'",
    Callback = function()
        Window:SetToggleKey(Enum.KeyCode.Q)
        AddLog("Se ha ejecutado Window:SetToggleKey(Enum.KeyCode.Q)", "WARN")
        AddLog("Nuevo valor de Window.ToggleKey: " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "SUCCESS")
    end
})

MainTab:Button({
    Title = "Forzar ToggleKey a 'RightShift'",
    Callback = function()
        Window:SetToggleKey(Enum.KeyCode.RightShift)
        AddLog("Se ha ejecutado Window:SetToggleKey(Enum.KeyCode.RightShift)", "WARN")
        AddLog("Nuevo valor de Window.ToggleKey: " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "SUCCESS")
    end
})

-- Mostrar el estado actual al inicio
task.wait(1)
AddLog("Estado Inicial Window.ToggleKey: " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "WARN")

print("🟢 AstraHub Zz con Debug cargado completamente.")
