-- ASTRA HUB ZZ - Script Principal (Sin KeySystem)
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
    IgnoreAlerts = true, -- Importante: Usa nuestro Dialog personalizado al cerrar
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
    Desc = "Sistema cargado correctamente.\nModificaciones activas: Sliders Verdes, Dialog Rojo."
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
        -- Lógica de velocidad aquí si quieres
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

-- Sección 3: Controles Variados (Toggles, Botones, Dropdowns)
local ControlSection = MainTab:Section({
    Title = "Controles",
    Description = "Botones, Toggles y Menús",
    Collapsed = true -- Empieza cerrada
})

ControlSection:Toggle({
    Title = "Activar Función A",
    Value = false,
    Callback = function(state)
        print("Función A:", state)
    end
})

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

ControlSection:Dropdown({
    Title = "Selecciona Opción",
    Values = {"Opción 1", "Opción 2", "Opción 3"},
    Default = "Opción 1",
    Callback = function(value)
        print("Selected:", value)
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
    Desc = "✅ Slider Verde Neón\n✅ Dialog de Cierre Personalizado (Rojo)\n✅ Diseño Minimalista"
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
