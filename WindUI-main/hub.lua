-- AstraHub Zz - Script Final Definitivo con Transparencias Reales
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando AstraHub Zz...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz", -- Título del Hub
    Theme = "Dark", -- Tema por defecto
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZz",
    IgnoreAlerts = false, -- Para que funcione el Dialog de cierre personalizado
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- SERVICIOS Y VARIABLES GLOBALES
-- ═══════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Estados de Funciones
local FlyEnabled = false
local FlySpeed = 50
local NoclipEnabled = false
local SpeedEnabled = false
local SpeedValue = 50
local JumpEnabled = false
local JumpPower = 50

-- Variables para Fly
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
BodyVelocity.Velocity = Vector3.new(0, 0, 0)
BodyVelocity.Parent = RootPart

local BodyGyro = Instance.new("BodyGyro")
BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
BodyGyro.D = 100
BodyGyro.P = 10000
BodyGyro.CFrame = RootPart.CFrame
BodyGyro.Parent = RootPart

-- ═══════════════════════════════════════════════════════════════
-- LÓGICA DE MOVIMIENTO (FLY, NOCLIP, SPEED, JUMP) - CORREGIDA
-- ═══════════════════════════════════════════════════════════════

-- FUNCIÓN CENTRALIZADA PARA ACTUALIZAR ESTADÍSTICAS
local function UpdateStats()
    if Character and Humanoid then
        -- Speed: Se fuerza constantemente si está activo
        if SpeedEnabled then
            Humanoid.WalkSpeed = SpeedValue
        else
            Humanoid.WalkSpeed = 16
        end

        -- Jump: Se fuerza constantemente si está activo
        if JumpEnabled then
            Humanoid.JumpPower = JumpPower
        else
            Humanoid.JumpPower = 50
        end
    end
end

-- FLY LOGIC
RunService.RenderStepped:Connect(function()
    if FlyEnabled and Character and RootPart then
        local MoveDirection = Vector3.new(0, 0, 0)
        
        -- Controles WASD + Espacio/Shift
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + RootPart.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - RootPart.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - RootPart.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + RootPart.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDirection = MoveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
            MoveDirection = MoveDirection - Vector3.new(0, 1, 0) 
        end
        
        if MoveDirection.Magnitude > 0 then
            MoveDirection = MoveDirection.Unit * FlySpeed
        end
        
        BodyVelocity.Velocity = MoveDirection
        BodyGyro.CFrame = Camera.CFrame
    else
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- NOCLIP LOGIC
RunService.Stepped:Connect(function()
    if NoclipEnabled and Character then
        for _, Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.CanCollide then
                Part.CanCollide = false
            end
        end
    end
end)

-- LOOP CONSTANTE PARA SPEED/JUMP (ANTI-RESET)
RunService.Heartbeat:Connect(UpdateStats)

-- DETECTAR CAMBIO DE PERSONAJE (RESPAWN)
LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(0.5) -- Pequeño delay para asegurar carga
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
    
    -- Re-parentear objetos de Fly
    BodyVelocity.Parent = RootPart
    BodyGyro.Parent = RootPart
    
    -- Re-aplicar estados inmediatamente
    UpdateStats()
end)

-- ═══════════════════════════════════════════════════════════════
-- INTERFAZ DE USUARIO (HUB)
-- ═══════════════════════════════════════════════════════════════

-- TAB 1: MAIN (Bienvenida)
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Astras Hub Welcome",
    Desc = "By - ᴄ++ | ʟᴏᴀɴɢ..."
})

-- TAB 2: PLAYER & CHEAT
local PlayerTab = Window:Tab({ Title = "Player & Cheat", Icon = "user" })

-- Fly
PlayerTab:Toggle({
    Title = "Activar Fly",
    Value = false,
    Callback = function(state)
        FlyEnabled = state
    end
})

PlayerTab:Slider({
    Title = "Velocidad Fly",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value)
        FlySpeed = value
    end
})

-- Noclip
PlayerTab:Toggle({
    Title = "Activar Noclip",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state
    end
})

-- Speed
PlayerTab:Toggle({
    Title = "Activar Speed",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        UpdateStats() -- Forzar actualización inmediata
    end
})

PlayerTab:Slider({
    Title = "Velocidad Speed",
    Value = { Min = 16, Max = 200, Default = 50 },
    Callback = function(value)
        SpeedValue = value
        -- SOLUCIÓN: Actualizar siempre que cambie el slider
        if SpeedEnabled then UpdateStats() end
    end
})

-- Jump
PlayerTab:Toggle({
    Title = "Activar Jump",
    Value = false,
    Callback = function(state)
        JumpEnabled = state
        UpdateStats() -- Forzar actualización inmediata
    end
})

PlayerTab:Slider({
    Title = "Altura Jump",
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(value)
        JumpPower = value
        -- SOLUCIÓN: Actualizar siempre que cambie el slider
        if JumpEnabled then UpdateStats() end
    end
})

-- TAB 3: CONFIG (Keybind, Discord, Temas y Transparencias REALES)
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
        -- SOLUCIÓN: Configurar la tecla real de WindUI
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

-- Sección de Transparencias
local TransparencySection = SettingsTab:Section({
    Title = "Transparencias",
    Description = "Ajusta la opacidad del Hub y los Frames",
    Collapsed = false
})

-- Slider para controlar la transparencia general del Hub (Fondo Principal)
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

-- NUEVO: Slider para controlar la transparencia de los FRAMES internos (REAL Y COMPLETO)
TransparencySection:Slider({
    Title = "Opacidad de Frames Internos (%)",
    Value = { Min = 0, Max = 100, Default = 100 }, -- 100% = Opaco, 0% = Invisible
    Callback = function(value)
        local frameTransparency = 1 - (value / 100)
        
        -- Recorrer todas las tabs registradas en el módulo de tabs
        if Window and Window.TabModule and Window.TabModule.Tabs then
            for _, tab in pairs(Window.TabModule.Tabs) do
                -- Cada tab tiene una lista de elementos en 'tab.Elements'
                if tab.Elements then
                    for _, element in pairs(tab.Elements) do
                        -- WindUI guarda el frame principal del elemento en 'element.ElementFrame'
                        if element.ElementFrame then
                            -- Buscar todos los ImageLabels que actúan como fondo dentro del ElementFrame
                            -- Estos suelen tener nombres como "Squircle", "Glass-1", "Background", o ser el primer hijo si es un botón simple
                            for _, child in ipairs(element.ElementFrame:GetDescendants()) do
                                if child:IsA("ImageLabel") then
                                    -- Excluir iconos, bordes finos o elementos decorativos que no son el fondo principal
                                    -- Los fondos principales suelen tener ImageTransparency inicial bajo (0 a 0.1) o ser parte del tema
                                    if child.Name == "Squircle" or child.Name == "Glass-1" or child.Name == "Background" or child.Name == "Frame" then
                                        -- Ajustar la transparencia del fondo
                                        child.ImageTransparency = math.clamp(frameTransparency, 0, 1)
                                    end
                                elseif child:IsA("Frame") and child.BackgroundTransparency < 0.5 then
                                    -- Algunos elementos usan Frames simples con BackgroundColor3
                                    child.BackgroundTransparency = math.clamp(frameTransparency, 0, 1)
                                end
                            end
                            
                            -- Caso especial para elementos que tienen un fondo directo en el ElementFrame (como Buttons simples)
                            if element.ElementFrame:IsA("ImageLabel") then
                                element.ElementFrame.ImageTransparency = math.clamp(frameTransparency, 0, 1)
                            elseif element.ElementFrame:IsA("Frame") then
                                element.ElementFrame.BackgroundTransparency = math.clamp(frameTransparency, 0, 1)
                            end
                        end
                    end
                end
            end
        end
        
        print("Transparencia de Frames Internos:", value .. "%")
    end
})

SettingsTab:Paragraph({
    Title = "Info",
    Desc = "AstraHub Zz v1.0\nOptimized by ᴄ++ | ʟᴏɴɢ..."
})

print("🟢 AstraHub Zz cargado completamente.")
