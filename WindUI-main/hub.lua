-- ᴄ++ | ʟᴏᴅɪɴɢ... - Script Final Optimizado (CORREGIDO)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando ᴄ++ | ʟᴏᴀɪɴɢ...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "CppLoading",
    IgnoreAlerts = false,
})

-- 🔧 CORRECCIÓN 1: Configurar tecla por defecto para abrir/cerrar
Window:SetToggleKey("RightShift")

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

local BodyGyro = Instance.new("BodyGyro")
BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
BodyGyro.D = 100
BodyGyro.P = 10000
BodyGyro.CFrame = RootPart.CFrame

-- Función para re-parentear fly al respawn
local function AttachFlyParts()
    if RootPart and BodyVelocity and BodyGyro then
        BodyVelocity.Parent = RootPart
        BodyGyro.Parent = RootPart
    end
end
AttachFlyParts()

-- ═══════════════════════════════════════════════════════════════
-- LÓGICA DE MOVIMIENTO
-- ═══════════════════════════════════════════════════════════════

-- FLY LOGIC
RunService.RenderStepped:Connect(function()
    if FlyEnabled and Character and RootPart then
        local MoveDirection = Vector3.new(0, 0, 0)
        
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
        if BodyVelocity then BodyVelocity.Velocity = Vector3.new(0, 0, 0) end
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

-- 🔧 CORRECCIÓN 2 y 3: SPEED & JUMP (bien aplicados)
local function UpdateStats()
    if not Character or not Humanoid then return end
    
    -- Speed: solo si está encendido
    if SpeedEnabled then
        Humanoid.WalkSpeed = SpeedValue
    else
        Humanoid.WalkSpeed = 16
    end
    
    -- Jump: solo si está encendido
    if JumpEnabled then
        Humanoid.JumpPower = JumpPower
    else
        Humanoid.JumpPower = 50
    end
end

-- Actualizar cuando cambie el personaje (respawn)
LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(0.5)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
    
    BodyVelocity.Parent = RootPart
    BodyGyro.Parent = RootPart
    
    -- Reaplicar estados después del respawn
    UpdateStats()
end)

-- Loop constante para mantener los valores
RunService.Heartbeat:Connect(UpdateStats)

-- ═══════════════════════════════════════════════════════════════
-- INTERFAZ DE USUARIO
-- ═══════════════════════════════════════════════════════════════

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Astras Hub Welcome - Steal in Peru",
    Desc = "By - ᴄ++ | ʟᴏᴀɪɴɢ..."
})

local PlayerTab = Window:Tab({ Title = "Player & Cheat", Icon = "user" })

-- Fly
PlayerTab:Toggle({
    Title = "Activar Fly",
    Value = false,
    Callback = function(state)
        FlyEnabled = state
        if not state and BodyVelocity then
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
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

-- 🔧 Speed CORREGIDO
PlayerTab:Toggle({
    Title = "Activar Speed",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        UpdateStats()
    end
})

PlayerTab:Slider({
    Title = "Velocidad Speed",
    Value = { Min = 16, Max = 200, Default = 50 },
    Callback = function(value)
        SpeedValue = value
        if SpeedEnabled then UpdateStats() end  -- ← clave: si está activo, actualiza
    end
})

-- 🔧 Jump CORREGIDO
PlayerTab:Toggle({
    Title = "Activar Jump",
    Value = false,
    Callback = function(state)
        JumpEnabled = state
        UpdateStats()
    end
})

PlayerTab:Slider({
    Title = "Altura Jump",
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(value)
        JumpPower = value
        if JumpEnabled then UpdateStats() end  -- ← clave: si está activo, actualiza
    end
})

-- TAB CONFIG
local ConfigTab = Window:Tab({ Title = "Config", Icon = "settings" })

-- 🔧 CORRECCIÓN 1: Keybind funcional
ConfigTab:Keybind({
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

ConfigTab:Button({
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

ConfigTab:Paragraph({
    Title = "Info",
    Desc = "AstraHub Zz v1.1 CORREGIDO\nSpeed/Jump solo si están ON\nKeybind funcional"
})

print("🟢 ᴄ++ | ᴄᴏʀʀᴇɢɪᴅᴏ - Todo funcionando correctamente.")
