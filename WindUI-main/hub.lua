-- ASTRA HUB ZZ - Intro Visual Mejorada
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- 1. INTRO VISUAL MEJORADA (Animaciones Suaves + Texto Grande)
-- ═══════════════════════════════════════════════════════════════

-- Crear Pantalla de Carga
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "AstraIntroV2"
IntroGui.Parent = game.CoreGui
IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fondo Semitransparente (No negro sólido, sino oscuro con transparencia)
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.BackgroundTransparency = 0.4 -- <--- CAMBIO: No es negro sólido, es semitransparente
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = IntroGui

-- Texto Principal (Más Grande y con Efecto)
local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0, 600, 0, 100) -- <--- CAMBIO: Más grande
IntroText.Position = UDim2.new(0.5, -300, 0.5, -50)
IntroText.BackgroundTransparency = 1
IntroText.Text = "ASTRAS HUB ZZ"
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextSize = 80 -- <--- CAMBIO: Tamaño de fuente mucho mayor
IntroText.Font = Enum.Font.GothamBold
IntroText.TextStrokeTransparency = 0.5 -- Borde suave
IntroText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
IntroText.Parent = IntroFrame

-- Subtítulo Opcional (Para darle más estilo)
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(0, 300, 0, 30)
SubText.Position = UDim2.new(0.5, -150, 0.5, 20) -- Debajo del título principal
SubText.BackgroundTransparency = 1
SubText.Text = "by Tz-hzk | v1.0"
SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
SubText.TextSize = 24
SubText.Font = Enum.Font.GothamMedium
SubText.TextTransparency = 1 -- Empieza invisible
SubText.Parent = IntroFrame

-- Animación de Entrada (Zoom-In + Fade-In)
task.spawn(function()
    -- 1. Estado Inicial: Escala pequeña y transparente
    IntroText.TextTransparency = 1
    IntroText.Scale = Vector2.new(0.5, 0.5) -- No existe propiedad Scale directa en TextLabel, usaremos UIScale
    
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.5 -- Empieza pequeño
    UIScale.Parent = IntroText
    
    SubText.TextTransparency = 1

    task.wait(0.2)

    -- 2. Animación de Aparición (Zoom-In Suave)
    local TweenInfoIn = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Animar Texto Principal
    local GoalText = { TextTransparency = 0 }
    local TweenText = TweenService:Create(IntroText, TweenInfoIn, GoalText)
    TweenText:Play()
    
    -- Animar Escala (Zoom)
    local GoalScale = { Scale = 1.1 } -- Llega a 1.1 para luego ajustar
    local TweenScale = TweenService:Create(UIScale, TweenInfoIn, GoalScale)
    TweenScale:Play()

    -- Animar Subtítulo
    local GoalSub = { TextTransparency = 0.3 }
    local TweenSub = TweenService:Create(SubText, TweenInfoIn, GoalSub)
    TweenSub:Play()

    -- Esperar mientras se lee el texto
    task.wait(2.0)

    -- 3. Animación de Salida (Fade-Out + Zoom-Out)
    local TweenInfoOut = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    -- Desvanecer Texto
    local GoalTextOut = { TextTransparency = 1 }
    local TweenTextOut = TweenService:Create(IntroText, TweenInfoOut, GoalTextOut)
    TweenTextOut:Play()
    
    -- Desvanecer Subtítulo
    local GoalSubOut = { TextTransparency = 1 }
    local TweenSubOut = TweenService:Create(SubText, TweenInfoOut, GoalSubOut)
    TweenSubOut:Play()

    -- Desvanecer Fondo
    local GoalBg = { BackgroundTransparency = 1 }
    local TweenBg = TweenService:Create(IntroFrame, TweenInfoOut, GoalBg)
    TweenBg:Play()

    -- Destruir GUI después de la animación
    task.wait(0.7)
    IntroGui:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════
-- 2. CARGAR WINDUI Y CREAR EL HUB
-- ═══════════════════════════════════════════════════════════════

-- Pequeña pausa para asegurar que la intro se vea bien antes de cargar la librería
task.wait(0.5)

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
