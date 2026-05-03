-- Testing Keybind Abrir/Cerrar Hub
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando Testing Keybind...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "Keybind Test",
    Theme = "Dark",
    Size = UDim2.fromOffset(400, 300),
    Folder = "KeybindTest",
    IgnoreAlerts = true, -- Usamos nuestro propio dialog si es necesario
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- TAB PRINCIPAL
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

-- Sección de Prueba
local TestSection = MainTab:Section({
    Title = "Prueba de Keybind",
    Description = "Usa la tecla para abrir/cerrar el Hub",
    Collapsed = false
})

-- Keybind para Abrir/Cerrar el Hub
TestSection:Keybind({
    Title = "Tecla Abrir/Cerrar Hub",
    Value = "RightShift", -- Tecla por defecto
    Callback = function(key)
        -- Esta función se ejecuta cuando presionas la tecla
        -- Pero para abrir/cerrar, WindUI maneja esto internamente si usas SetToggleKey
        
        -- Notificación opcional para confirmar que la tecla fue presionada
        WindUI:Notify({
            Title = "Keybind Presionado",
            Content = "Presionaste: " .. key,
            Duration = 1.5
        })
    end
})

-- Botón para cambiar la tecla manualmente (Opcional, para testing)
TestSection:Button({
    Title = "Cambiar Tecla a 'Q'",
    Callback = function()
        Window:SetToggleKey(Enum.KeyCode.Q)
        WindUI:Notify({
            Title = "Config",
            Content = "Tecla cambiada a Q",
            Duration = 2
        })
    end
})

TestSection:Button({
    Title = "Cambiar Tecla a 'Insert'",
    Callback = function()
        Window:SetToggleKey(Enum.KeyCode.Insert)
        WindUI:Notify({
            Title = "Config",
            Content = "Tecla cambiada a Insert",
            Duration = 2
        })
    end
})

TestSection:Paragraph({
    Title = "Instrucciones",
    Desc = "1. Usa la tecla configurada (por defecto RightShift) para abrir/cerrar.\n2. Prueba cambiar la tecla con los botones.\n3. Verifica que la nueva tecla funcione."
})

print("🟢 Testing Keybind cargado completamente.")
