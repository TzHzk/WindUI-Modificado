-- ASTRA HUB ZZ - Intro Visual Limpia (Sin Fondo Negro)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- 1. INTRO VISUAL LIMPIA (Solo Texto Flotante)
-- ═══════════════════════════════════════════════════════════════

-- Crear Pantalla de Carga
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "AstraIntroClean"
IntroGui.Parent = game.CoreGui
IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- NOTA: No creamos un Frame de fondo negro. Solo el texto.

-- Texto Principal (Grande y Elegante)
local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0, 700, 0, 120) -- Más grande
IntroText.Position = UDim2.new(0.5, -350, 0.5, -60)
IntroText.BackgroundTransparency = 1
IntroText.Text = "ASTRAS HUB ZZ"
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextSize = 90 -- Muy grande
IntroText.Font = Enum.Font.GothamBold
IntroText.TextStrokeTransparency = 0.6 -- Borde suave para leerse bien en cualquier fondo
IntroText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
IntroText.Parent = IntroGui

-- Subtítulo Pequeño
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(0, 300, 0, 30)
SubText.Position = UDim2.new(0.5, -150, 0.5, 30)
SubText.BackgroundTransparency = 1
SubText.Text = "by Tz-hzk | v1.0"
SubText.TextColor3 = Color3.fromRGB(220, 220, 220)
SubText.TextSize = 26
SubText.Font = Enum.Font.GothamMedium
SubText.TextStrokeTransparency = 0.8
SubText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
SubText.Parent = IntroGui

-- Animación Controlada
task.spawn(function()
    -- 1. Estado Inicial: Invisible y pequeño
    IntroText.TextTransparency = 1
    SubText.TextTransparency = 1
    
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.5
    UIScale.Parent = IntroText
    
    -- 2. RETRASO FORZADO DE 0.6 SEGUNDOS ANTES DE EMPEZAR
    task.wait(0.6)

    -- 3. Animación de Entrada (Zoom-In Suave)
    local TweenInfoIn = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Aparecer Texto Principal
    TweenService:Create(IntroText, TweenInfoIn, { TextTransparency = 0 }):Play()
    TweenService:Create(UIScale, TweenInfoIn, { Scale = 1.1 }):Play()
    
    -- Aparecer Subtítulo con un poco de retraso
    task.wait(0.1)
    TweenService:Create(SubText, TweenInfoIn, { TextTransparency = 0.2 }):Play()

    -- 4. Tiempo de Lectura (Mantener visible)
    task.wait(1.5) -- Se queda visible 1.5 segundos

    -- 5. Animación de Salida (Desvanecimiento Rápido)
    local TweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    TweenService:Create(IntroText, TweenInfoOut, { TextTransparency = 1 }):Play()
    TweenService:Create(SubText, TweenInfoOut, { TextTransparency = 1 }):Play()
    TweenService:Create(UIScale, TweenInfoOut, { Scale = 1.5 }):Play() -- Se agranda al desaparecer

    -- 6. Destruir GUI
    task.wait(0.6)
    IntroGui:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════
-- 2. CARGAR WINDUI Y CREAR EL HUB
-- ═══════════════════════════════════════════════════════════════

-- Pequeña pausa extra para asegurar estabilidad visual
task.wait(0.2)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando AstraHub Zz...")

local Window = WindUI:CreateWindow({
    Title = "ASTRA HUB ZZ",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZZ",
    IgnoreAlerts = true, -- Usa nuestro Dialog personalizado
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- 3. CONTENIDO DEL HUB (Ejemplo Básico)
-- ═══════════════════════════════════════════════════════════════

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Bienvenido",
    Desc = "La intro ha terminado. El Hub está listo."
})

MainTab:Button({
    Title = "Probar Botón",
    Callback = function()
        print("Botón presionado")
    end
})

print("🟢 AstraHub Zz cargado completamente.")
