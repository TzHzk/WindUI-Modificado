-- Carga TU WindUI compilado
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/TzHzk/WindUI-Modificado/main/WindUI-main/dist/main.lua"))()

-- ═══════════════════════════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- Speed
local SpeedEnabled = false
local SpeedValue = 16

-- ESP
local ESPEnabled = false
local ESPObjects = {}

-- Keybind (por defecto: K)
local ToggleKey = Enum.KeyCode.K
local Window = nil

-- ═══════════════════════════════════════════════════════════════
-- FUNCIONES DE VELOCIDAD
-- ═══════════════════════════════════════════════════════════════
local function ApplySpeed()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SpeedEnabled and SpeedValue or 16
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplySpeed()
end)

-- ═══════════════════════════════════════════════════════════════
-- ESP NAMES
-- ═══════════════════════════════════════════════════════════════
local function CreateESPName(plr)
    if plr == LP then return end
    if ESPObjects[plr] then
        if ESPObjects[plr].Billboard then ESPObjects[plr].Billboard:Destroy() end
        ESPObjects[plr] = nil
    end
    
    local char = plr.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "_ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 150
    billboard.Parent = char
    
    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = plr.DisplayName or plr.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    
    ESPObjects[plr] = { Billboard = billboard, Text = text }
end

local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        if obj.Billboard then obj.Billboard:Destroy() end
    end
    ESPObjects = {}
end

local function UpdateESP()
    if not ESPEnabled then
        ClearESP()
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if not ESPObjects[plr] then
                        CreateESPName(plr)
                    end
                elseif ESPObjects[plr] then
                    if ESPObjects[plr].Billboard then ESPObjects[plr].Billboard:Destroy() end
                    ESPObjects[plr] = nil
                end
            elseif ESPObjects[plr] then
                if ESPObjects[plr].Billboard then ESPObjects[plr].Billboard:Destroy() end
                ESPObjects[plr] = nil
            end
        end
    end
end

-- Loop para ESP
RunService.Heartbeat:Connect(function()
    UpdateESP()
end)

-- ═══════════════════════════════════════════════════════════════
-- CREAR VENTANA
-- ═══════════════════════════════════════════════════════════════
Window = WindUI:CreateWindow({
    Title = "SPEED HUB + ESP",
    Icon = "zap",
    Theme = "Dark",
    Size = UDim2.fromOffset(400, 250)
})

-- Pestaña principal
local MainTab = Window:Tab({ Title = "Velocidad", Icon = "gauge" })

-- Toggle Speed
MainTab:Toggle({
    Title = "Speed Activado",
    Desc = "Activa o desactiva la modificación de velocidad",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        ApplySpeed()
        WindUI:Notify({
            Title = "Speed",
            Content = state and "Activado" or "Desactivado",
            Duration = 2
        })
    end
})

-- Slider Speed
MainTab:Slider({
    Title = "Velocidad",
    Desc = "Ajusta la velocidad de movimiento (16-100)",
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(value)
        SpeedValue = value
        if SpeedEnabled then ApplySpeed() end
    end
})

-- Pestaña ESP
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })

-- Toggle ESP
ESPTab:Toggle({
    Title = "ESP Names Activado",
    Desc = "Muestra los nombres de los jugadores sobre sus cabezas",
    Value = false,
    Callback = function(state)
        ESPEnabled = state
        WindUI:Notify({
            Title = "ESP",
            Content = state and "Activado" or "Desactivado",
            Duration = 2
        })
    end
})

-- Pestaña Keybind
local KeysTab = Window:Tab({ Title = "Keybinds", Icon = "command" })

-- Keybind para abrir/cerrar
KeysTab:Keybind({
    Title = "Abrir/Cerrar Hub",
    Desc = "Tecla para mostrar u ocultar el hub",
    Value = "K",
    Callback = function(key)
        ToggleKey = Enum.KeyCode[key]
    end
})

-- ═══════════════════════════════════════════════════════════════
-- KEYBIND GLOBAL
-- ═══════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == ToggleKey then
        Window:Toggle()
    end
end)

print("✅ SPEED HUB + ESP cargado")
print("🔑 Tecla K para abrir/cerrar el hub")
