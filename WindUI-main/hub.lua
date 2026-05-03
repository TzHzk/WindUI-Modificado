-- ASTRA HUB ZZ - Script Completo (Sin KeySystem)
-- Carga TU WindUI Modificado desde GitHub
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando AstraHub Zz...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA (SIN KEYSYSTEM)
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "ASTRA HUB ZZ",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZZ",
    IgnoreAlerts = false, -- IMPORTANTE: Debe ser FALSE para que el Dialog de cierre funcione
})

print("✅ Ventana cargada. Interfaz lista.")

-- ═══════════════════════════════════════════════════════════════
-- TAB PRINCIPAL (Usamos Secciones para organizar todo aquí)
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

-- Sección 1: Bienvenida
local WelcomeSection = MainTab:Section({
    Title = "Bienvenido",
    Description = "Estado del sistema",
    Collapsed = false -- Empieza abierta
})

WelcomeSection:Paragraph({
    Title = "👋 Hola, " .. game.Players.LocalPlayer.DisplayName,
    Desc = "Sistema cargado correctamente.\nModificaciones activas: Sliders Verdes, Dialog Rojo, Keybinds."
})

-- Sección 2: Prueba de Sliders (DEBEN SER VERDES por tu modificación en main.lua)
local SliderSection = MainTab:Section({
    Title = "Prueba de Sliders",
    Description = "Verifica el color verde neón",
    Collapsed = false
})

SliderSection:Slider({
    Title = "Velocidad (Verde)",
    Value = { Min = 16, Max = 120, Default = 50 },
    Callback = function(v) 
        print("Speed:", v)
    end
})

SliderSection:Slider({
    Title = "Opacidad ESP (Verde)",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Increment = 0.1,
    Callback = function(v)
        print("ESP Opacity:", v)
    end
})

-- Sección 3: Controles Variados (Toggles, Buttons, Dropdowns, Inputs, Keybinds)
local ControlSection = MainTab:Section({
    Title = "Controles Completos",
    Description = "Todos los elementos UI",
    Collapsed = false -- Dejamos esta abierta para probar todo
})

-- Toggle
ControlSection:Toggle({
    Title = "Activar Función A",
    Value = false,
    Callback = function(state)
        print("Función A:", state)
    end
})

-- Button
ControlSection:Button({
    Title = "Probar Notificación",
    Callback = function()
        WindUI:Notify({
            Title = "Éxito",
            Content = "El hub funciona perfectamente.",
            Duration = 2
        })
    end
})

-- Input
ControlSection:Input({
    Title = "Nombre de Usuario",
    Placeholder = "Escribe tu nombre...",
    Callback = function(value)
        print("Input:", value)
    end
})

-- Dropdown
ControlSection:Dropdown({
    Title = "Selecciona Opción",
    Values = {"Opción 1", "Opción 2", "Opción 3"},
    Default = "Opción 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

-- Keybind (Tecla Rápida)
ControlSection:Keybind({
    Title = "Tecla de Atajo",
    Value = "Q", -- Tecla por defecto
    Callback = function(key)
        print("Keybind Presionado:", key)
        WindUI:Notify({
            Title = "Keybind",
            Content = "Presionaste: " .. key,
            Duration = 1
        })
    end
})

-- Colorpicker
ControlSection:Colorpicker({
    Title = "Color de ESP",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color Escogido:", color)
    end
})

-- Sección 4: Info y Links
local InfoSection = MainTab:Section({
    Title = "Info & Links",
    Description = "Recursos útiles",
    Collapsed = true
})

InfoSection:Paragraph({
    Title = "Modificaciones Activas",
    Desc = "✅ Slider Verde Neón\n✅ Dialog de Cierre Personalizado (Rojo)\n✅ Diseño Minimalista\n✅ Todos los Componentes"
})

InfoSection:Button({
    Title = "Copiar Discord",
    Callback = function()
        setclipboard("https://discord.gg/drR7ZVKPXe")
        WindUI:Notify({
            Title = "Discord",
            Content = "Link copiado al portapapeles.",
            Duration = 2
        })
    end
})

print("🟢 AstraHub Zz cargado completamente.")
