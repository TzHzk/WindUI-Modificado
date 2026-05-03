-- AstraHub Zz - Script Final Optimizado
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()

print("🔄 Iniciando AstraHub Zz...")

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
-- LÓGICA DE MOVIMIENTO (FLY, NOCLIP, SPEED, JUMP)
-- ═══════════════════════════════════════════════════════════════

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

-- SPEED & JUMP LOGIC
RunService.Heartbeat:Connect(function()
    if Character and Humanoid then
        -- Speed
        if SpeedEnabled then
            Humanoid.WalkSpeed = SpeedValue
        else
            Humanoid.WalkSpeed = 16
        end

        -- Jump
        if JumpEnabled then
            Humanoid.JumpPower = JumpPower
        else
            Humanoid.JumpPower = 50
        end
    end
end)

-- Recargar variables al cambiar de personaje
LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
    
    -- Re-parentear objetos de Fly
    BodyVelocity.Parent = RootPart
    BodyGyro.Parent = RootPart
    
    -- Re-aplicar estados si están activos
    if SpeedEnabled then Humanoid.WalkSpeed = SpeedValue end
    if JumpEnabled then Humanoid.JumpPower = JumpPower end
end)

-- ═══════════════════════════════════════════════════════════════
-- INTERFAZ DE USUARIO (HUB)
-- ═══════════════════════════════════════════════════════════════

local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz", -- Título del Hub
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZz",
    IgnoreAlerts = false, -- Para que funcione el Dialog de cierre personalizado
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- TAB 1: MAIN (Bienvenida)
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Astras Hub Welcome - Steal in Peru",
    Desc = "By - ᴄ++ | ʟᴏᴀᴅɪɴɢ..."
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 2: PLAYER & CHEAT
-- ═══════════════════════════════════════════════════════════════
local PlayerTab = Window:Tab({ Title = "Player & Cheat", Icon = "user" })

-- Sección Movimiento
local MoveSection = PlayerTab:Section({
    Title = "Movement",
    Description = "Fly, Speed, Jump, Noclip",
    Collapsed = false
})

-- Fly
MoveSection:Toggle({
    Title = "Activar Fly",
    Value = false,
    Callback = function(state)
        FlyEnabled = state
    end
})

MoveSection:Slider({
    Title = "Velocidad Fly",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value)
        FlySpeed = value
    end
})

-- Noclip
MoveSection:Toggle({
    Title = "Activar Noclip",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state
    end
})

-- Speed
MoveSection:Toggle({
    Title = "Activar Speed",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
    end
})

MoveSection:Slider({
    Title = "Velocidad Speed",
    Value = { Min = 16, Max = 200, Default = 50 },
    Callback = function(value)
        SpeedValue = value
    end
})

-- Jump
MoveSection:Toggle({
    Title = "Activar Jump",
    Value = false,
    Callback = function(state)
        JumpEnabled = state
    end
})

MoveSection:Slider({
    Title = "Altura Jump",
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(value)
        JumpPower = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 3: CONFIG
-- ═══════════════════════════════════════════════════════════════
local ConfigTab = Window:Tab({ Title = "Config", Icon = "settings" })

local ConfigSection = ConfigTab:Section({
    Title = "Settings",
    Description = "Keybinds & Links",
    Collapsed = false
})

-- Keybind para abrir/cerrar el Hub
ConfigSection:Keybind({
    Title = "Tecla para Abrir/Cerrar Hub",
    Value = "RightShift", -- Tecla por defecto
    Callback = function(key)
        print("Tecla cambiada a:", key)
        -- Nota: WindUI maneja esto internamente si usas la propiedad ToggleKey en CreateWindow, 
        -- pero este keybind es visual para el usuario.
        -- Para cambiar la tecla real de toggle de WindUI, se hace así:
        Window:SetToggleKey(key) 
    end
})

-- Link de Discord
ConfigSection:Button({
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

ConfigSection:Paragraph({
    Title = "Info",
    Desc = "AstraHub Zz v1.0\nOptimized by Tz-hzk"
})

print("🟢 AstraHub Zz cargado completamente.")
