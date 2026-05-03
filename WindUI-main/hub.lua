-- AstraHub Zz - Script Final con Fix de Frames
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando AstraHub Zz...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZZ",
    IgnoreAlerts = false, -- Para que funcione el Dialog de cierre personalizado
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- TAB 1: MAIN (Bienvenida)
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Astras Hub Welcome - Steal in Peru",
    Desc = "By - ᴄ++ | ʟᴏᴀɴɢ..."
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 2: PLAYER & CHEAT
-- ═══════════════════════════════════════════════════════════════
local PlayerTab = Window:Tab({ Title = "Player & Cheat", Icon = "user" })

PlayerTab:Toggle({
    Title = "Activar Fly",
    Value = false,
    Callback = function(state) print("Fly:", state) end
})

PlayerTab:Slider({
    Title = "Velocidad Fly",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value) print("Fly Speed:", value) end
})

PlayerTab:Toggle({
    Title = "Activar Noclip",
    Value = false,
    Callback = function(state) print("Noclip:", state) end
})

PlayerTab:Toggle({
    Title = "Activar Speed",
    Value = false,
    Callback = function(state) print("Speed:", state) end
})

PlayerTab:Slider({
    Title = "Velocidad Speed",
    Value = { Min = 16, Max = 200, Default = 50 },
    Callback = function(value) print("Speed Value:", value) end
})

PlayerTab:Toggle({
    Title = "Activar Jump",
    Value = false,
    Callback = function(state) print("Jump:", state) end
})

PlayerTab:Slider({
    Title = "Altura Jump",
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(value) print("Jump Power:", value) end
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 3: SETTINGS (Temas, Config y Transparencia)
-- ═══════════════════════════════════════════════════════════════
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- Sección de Configuración Básica
local BasicConfigSection = SettingsTab:Section({
    Title = "Configuración Básica",
    Description = "Teclas y Enlaces",
    Collapsed = false
})

-- Keybind para abrir/cerrar el Hub
BasicConfigSection:Keybind({
    Title = "Tecla para Abrir/Cerrar Hub",
    Value = "RightShift",
    Callback = function(key)
        Window:SetToggleKey(key)
        WindUI:Notify({
            Title = "Config",
            Content = "Tecla cambiada a: " .. key,
            Duration = 2
        })
    end
})

-- Link de Discord
BasicConfigSection:Button({
    Title = "Copiar Discord",
    Icon = "message-circle",
    Callback = function()
        setclipboard("https://discord.gg/drR7ZVKPXe")
        WindUI:Notify({
            Title = "Discord",
            Content = "Link copiado al portapapeles.",
            Duration = 2
        })
    end
})

-- Sección de Apariencia (Temas)
local AppearanceSection = SettingsTab:Section({
    Title = "Apariencia",
    Description = "Personaliza el look del hub",
    Collapsed = false
})

-- Dropdown para cambiar el tema
AppearanceSection:Dropdown({
    Title = "Seleccionar Tema",
    Values = {
        "Dark", "Light", "Red", "Sky", "Violet", "Amber", "Emerald", "Midnight", "Rainbow"
    },
    Default = "Dark",
    Callback = function(value)
        WindUI:SetTheme(value)
        WindUI:Notify({
            Title = "Tema Cambiado",
            Content = "El tema ahora es: " .. value,
            Duration = 2
        })
    end
})

-- Botón extra para alternar rápido entre Dark/Light
AppearanceSection:Button({
    Title = "Alternar Dark/Light Rápido",
    Callback = function()
        local current = WindUI:GetCurrentTheme()
        if current == "Dark" then
            WindUI:SetTheme("Light")
        else
            WindUI:SetTheme("Dark")
        end
    end
})

-- Sección de Transparencia
local TransparencySection = SettingsTab:Section({
    Title = "Transparencia",
    Description = "Ajusta la opacidad de la ventana",
    Collapsed = false
})

-- Slider para controlar la transparencia del Hub
TransparencySection:Slider({
    Title = "Opacidad del Hub (%)",
    Value = { Min = 10, Max = 100, Default = 100 },
    Callback = function(value)
        local transparency = 1 - (value / 100)
        
        -- Aplicar transparencia al fondo principal de la ventana
        if Window and Window.UIElements and Window.UIElements.Main then
            if Window.UIElements.Main.Background then
                Window.UIElements.Main.Background.ImageTransparency = transparency
            end
            
            -- Si usas Acrylic, también ajustamos su transparencia
            if Window.AcrylicPaint and Window.AcrylicPaint.Model then
                Window.AcrylicPaint.Model.Transparency = transparency + 0.1
            end
        end
        
        print("Transparencia del Hub:", value .. "%")
    end
})

SettingsTab:Paragraph({
    Title = "Info",
    Desc = "AstraHub Zz v1.0\nOptimized by ᴄ++ | ʟᴏɪɴɢ..."
})

-- ═══════════════════════════════════════════════════════════════
-- FIX DE FRAMES: Ajustar tamaño de contenedores para evitar huecos
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(1) -- Esperar a que todo cargue
    
    -- Forzar el tamaño correcto de los contenedores principales
    if Window and Window.UIElements then
        -- Ajustar el contenedor de la barra lateral
        if Window.UIElements.SideBarContainer then
            Window.UIElements.SideBarContainer.Size = UDim2.new(0, 200, 1, -52) -- Altura fija menos topbar
        end
        
        -- Ajustar el contenedor principal de contenido
        if Window.UIElements.MainBar then
            Window.UIElements.MainBar.Size = UDim2.new(1, -200, 1, -52) -- Ancho total menos sidebar, altura menos topbar
        end
        
        -- Ajustar el fondo principal para que cubra todo
        if Window.UIElements.Main and Window.UIElements.Main.Background then
            Window.UIElements.Main.Background.Size = UDim2.new(1, 0, 1, 0)
        end
    end
    
    print("🟢 Frames ajustados correctamente.")
end)

print("🟢 AstraHub Zz cargado completamente.")
