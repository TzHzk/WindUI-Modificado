-- ══════════════════════════════════════════
--   NoirX Tz  |  by Tz-hzk
--   Silent Aim + FOV + ESP + Hitbox
-- ══════════════════════════════════════════

-- Cargar WindUI
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"
))()

-- ══════════════════════════════════════════
--   SERVICIOS
-- ══════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera
local Mouse            = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════
--   DETECTAR REMOTES AUTOMATICO
-- ══════════════════════════════════════════

local FireRemote      = nil
local FireUnreliable  = nil

-- Buscar en ReplicatedStorage/Remotes
local function FindRemotes()
    local rs = ReplicatedStorage
    -- buscar FireWeapon y FireWeaponUnreliable
    local function Search(parent)
        for _, v in ipairs(parent:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local n = v.Name:lower()
                if n == "fireweaponunreliable" or n == "clientgunshot" then
                    FireUnreliable = v
                elseif n == "fireweapon" then
                    FireRemote = v
                end
            end
        end
    end
    Search(rs)
end

FindRemotes()

-- ══════════════════════════════════════════
--   ESTADO DEL SCRIPT
-- ══════════════════════════════════════════

local State = {
    -- Aimbot
    AimbotEnabled  = false,
    AimbotKeybind  = Enum.KeyCode.Q,
    FOVSize        = 150,
    FOVVisible     = true,
    FOVColor       = Color3.fromRGB(255, 255, 255),
    FOVColorTarget = Color3.fromRGB(0, 255, 0),

    -- ESP
    EspEnabled     = false,
    EspKeybind     = Enum.KeyCode.F,

    -- Hitbox
    HitboxEnabled  = false,
    HitboxSize     = Vector3.new(8, 8, 8),
    HitboxVisible  = false,
    HitboxKeybind  = Enum.KeyCode.H,

    -- internos
    TeamCheck      = true,
}

-- ══════════════════════════════════════════
--   HELPERS
-- ══════════════════════════════════════════

local function GetTeam(player)
    return player and player.Team
end

local function IsEnemy(player)
    if not State.TeamCheck then return true end
    return GetTeam(player) ~= GetTeam(LocalPlayer)
end

local function GetCharacter(player)
    return player and player.Character
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHead(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChild("Head")
end

local function IsAlive(player)
    local h = GetHumanoid(player)
    return h and h.Health > 0
end

-- Posicao na tela de um part
local function WorldToScreen(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

-- Distancia do cursor ao centro do FOV
local function GetMousePos()
    return UserInputService:GetMouseLocation()
end

-- ══════════════════════════════════════════
--   FOV CIRCLE (Drawing)
-- ══════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible   = true
FOVCircle.Filled    = false
FOVCircle.Color     = State.FOVColor
FOVCircle.Thickness = 1.5
FOVCircle.NumSides  = 64
FOVCircle.Radius    = State.FOVSize
FOVCircle.Position  = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ══════════════════════════════════════════
--   AIMBOT - encontrar melhor alvo no FOV
-- ══════════════════════════════════════════

local function GetFOVCenter()
    return GetMousePos()
end

local function GetClosestInFOV()
    local closest     = nil
    local closestDist = math.huge
    local fovCenter   = GetFOVCenter()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and IsAlive(player) then
            local head = GetHead(player)
            if head then
                local screenPos, onScreen = WorldToScreen(head.Position)
                if onScreen then
                    local dist = (screenPos - fovCenter).Magnitude
                    if dist <= State.FOVSize and dist < closestDist then
                        closestDist = dist
                        closest     = player
                    end
                end
            end
        end
    end

    return closest
end

-- ══════════════════════════════════════════
--   SILENT AIM  (hook FireWeapon)
-- ══════════════════════════════════════════

local OriginalNamecall = nil
local mt = getrawmetatable(game)
local OldNamecall = mt.__namecall

-- Hook seguro
pcall(function()
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args   = {...}

        if State.AimbotEnabled and method == "FireServer" then
            local name = (self and self.Name) or ""
            local lname = name:lower()

            if lname == "fireweapon" or lname == "fireweaponunreliable" or lname == "clientgunshot" then
                local target = GetClosestInFOV()
                if target then
                    local head = GetHead(target)
                    if head then
                        -- substituir o argumento de posicao/CFrame pelo head do alvo
                        -- o primeiro argumento costuma ser a posicao/direction
                        -- testado com FireWeapon(origin, direction, ...)
                        local origin = Camera.CFrame.Position
                        local direction = (head.Position - origin).Unit

                        -- tentar substituir args[1] (direction) e args[2] (position) se existirem
                        if args[1] and typeof(args[1]) == "Vector3" then
                            args[1] = direction
                        end
                        if args[2] and typeof(args[2]) == "Vector3" then
                            args[2] = head.Position
                        end
                        if args[1] and typeof(args[1]) == "CFrame" then
                            args[1] = CFrame.new(origin, head.Position)
                        end

                        return OldNamecall(self, table.unpack(args))
                    end
                end
            end
        end

        return OldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- ══════════════════════════════════════════
--   ESP  (Highlights + BillboardGui)
-- ══════════════════════════════════════════

local EspObjects = {}

local function RemoveESP(player)
    if EspObjects[player] then
        for _, obj in ipairs(EspObjects[player]) do
            pcall(function() obj:Destroy() end)
        end
        EspObjects[player] = nil
    end
end

local function AddESP(player)
    RemoveESP(player)
    local char = GetCharacter(player)
    if not char then return end

    local objects = {}

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.FillColor    = IsEnemy(player) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 200, 50)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency    = 0.5
    hl.OutlineTransparency = 0
    hl.Adornee = char
    hl.Parent  = char
    table.insert(objects, hl)

    -- BillboardGui (nome + HP)
    local bb = Instance.new("BillboardGui")
    bb.Size         = UDim2.fromOffset(120, 30)
    bb.StudsOffset  = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop  = true
    bb.Adornee      = GetHead(player) or char:FindFirstChildOfClass("BasePart")
    bb.Parent       = char

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size                   = UDim2.new(1, 0, 0.6, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text                   = player.Name
    nameLbl.Font                   = Enum.Font.GothamBold
    nameLbl.TextSize               = 13
    nameLbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    nameLbl.Parent                 = bb

    local hpLbl = Instance.new("TextLabel")
    hpLbl.Size                   = UDim2.new(1, 0, 0.4, 0)
    hpLbl.Position               = UDim2.new(0, 0, 0.6, 0)
    hpLbl.BackgroundTransparency = 1
    hpLbl.Font                   = Enum.Font.Gotham
    hpLbl.TextSize               = 11
    hpLbl.TextStrokeTransparency = 0
    hpLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    hpLbl.Parent                 = bb

    -- atualizar HP em loop
    local hpConn = RunService.RenderStepped:Connect(function()
        local h = GetHumanoid(player)
        if h then
            local hp = math.floor(h.Health)
            local max = math.floor(h.MaxHealth)
            hpLbl.Text       = hp .. " / " .. max
            hpLbl.TextColor3 = Color3.fromRGB(
                255 - math.floor((hp / max) * 255),
                math.floor((hp / max) * 255),
                0
            )
        end
    end)
    table.insert(objects, bb)
    table.insert(objects, hpConn)

    EspObjects[player] = objects
end

local function RefreshESP()
    -- limpar tudo
    for player, _ in pairs(EspObjects) do
        RemoveESP(player)
    end

    if not State.EspEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            AddESP(player)
        end
    end
end

-- Reconectar quando personagem spawna
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if State.EspEnabled then AddESP(player) end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if State.EspEnabled then AddESP(player) end
        end)
    end
end

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ══════════════════════════════════════════
--   HITBOX EXPANDER
-- ══════════════════════════════════════════

local OriginalSizes = {}

local function ApplyHitbox(player)
    local char = GetCharacter(player)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not OriginalSizes[part] then
                OriginalSizes[part] = part.Size
            end
            part.Size = State.HitboxSize
            if State.HitboxVisible then
                part.Transparency = 0.6
            else
                part.Transparency = 1
            end
        end
    end
end

local function RemoveHitbox(player)
    local char = GetCharacter(player)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and OriginalSizes[part] then
            part.Size = OriginalSizes[part]
            OriginalSizes[part] = nil
            part.Transparency = 0
        end
    end
end

local function RefreshHitbox()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if State.HitboxEnabled then
                ApplyHitbox(player)
            else
                RemoveHitbox(player)
            end
        end
    end
end

-- aplicar hitbox quando personagem spawna
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if State.HitboxEnabled then ApplyHitbox(player) end
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if State.HitboxEnabled then ApplyHitbox(player) end
        end)
    end
end)

-- ══════════════════════════════════════════
--   RENDERLOOP  (FOV + deteccao alvo)
-- ══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    -- posicionar FOV no centro da tela
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius   = State.FOVSize
    FOVCircle.Visible  = State.AimbotEnabled and State.FOVVisible

    if State.AimbotEnabled then
        local target = GetClosestInFOV()
        FOVCircle.Color = target and State.FOVColorTarget or State.FOVColor
    else
        FOVCircle.Color = State.FOVColor
    end
end)

-- ══════════════════════════════════════════
--   KEYBINDS GLOBAIS
-- ══════════════════════════════════════════

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end

    if inp.KeyCode == State.AimbotKeybind then
        State.AimbotEnabled = not State.AimbotEnabled
    end

    if inp.KeyCode == State.EspKeybind then
        State.EspEnabled = not State.EspEnabled
        RefreshESP()
    end

    if inp.KeyCode == State.HitboxKeybind then
        State.HitboxEnabled = not State.HitboxEnabled
        RefreshHitbox()
    end
end)

-- ══════════════════════════════════════════
--   WIND UI  HUB
-- ══════════════════════════════════════════

local Window = Library:CreateWindow({
    Title   = "NoirX Tz",
    Icon    = "rbxassetid://10734966248",
    Theme   = "Dark",
})

-- ── TAB: MAIN ────────────────────────────

local MainTab = Window:CreateTab("Main", "home")
local MainSection = MainTab:CreateSection("Bienvenido")

MainSection:CreateParagraph({
    Title   = "👋  Hola, " .. LocalPlayer.DisplayName,
    Content = "NoirX Tz  —  by Tz-hzk\nSilent Aim  •  ESP  •  Hitbox\n\nUsa los tabs de arriba para configurar.",
})

local remotesText = "FireWeapon: " .. (FireRemote and "✅ Encontrado" or "❌ No encontrado")
    .. "\nFireWeaponUnreliable: " .. (FireUnreliable and "✅ Encontrado" or "❌ No encontrado")

MainSection:CreateParagraph({
    Title   = "🔌  Remotes detectados",
    Content = remotesText,
})

-- ── TAB: AIMBOT ──────────────────────────

local AimbotTab = Window:CreateTab("Aimbot", "crosshair")

-- Seccion activar
local AimSection = AimbotTab:CreateSection("Silent Aim")

AimSection:CreateToggle({
    Title       = "Silent Aim",
    Description = "Redirige disparos al objetivo dentro del FOV.",
    Default     = false,
    Callback    = function(v)
        State.AimbotEnabled = v
    end,
})

AimSection:CreateKeybind({
    Title       = "Keybind Aimbot",
    Description = "Activa / desactiva el silent aim.",
    Default     = "Q",
    Callback    = function(key)
        pcall(function()
            State.AimbotKeybind = Enum.KeyCode[key]
        end)
    end,
})

-- Seccion FOV
local FOVSection = AimbotTab:CreateSection("FOV")

FOVSection:CreateSlider({
    Title       = "Tamaño FOV",
    Description = "Radio del circulo de deteccion.",
    Min         = 20,
    Max         = 500,
    Default     = 150,
    Rounding    = 0,
    Callback    = function(v)
        State.FOVSize = v
    end,
})

FOVSection:CreateToggle({
    Title       = "Mostrar FOV",
    Description = "Hace el circulo visible o invisible.",
    Default     = true,
    Callback    = function(v)
        State.FOVVisible = v
    end,
})

-- ── TAB: ESP & HITBOX ────────────────────

local EspTab = Window:CreateTab("ESP & Hitbox", "eye")

-- Parte ESP
local EspSection = EspTab:CreateSection("ESP")

EspSection:CreateToggle({
    Title       = "ESP",
    Description = "Muestra jugadores enemigos a traves de paredes.",
    Default     = false,
    Callback    = function(v)
        State.EspEnabled = v
        RefreshESP()
    end,
})

EspSection:CreateKeybind({
    Title       = "Keybind ESP",
    Description = "Activa / desactiva el ESP.",
    Default     = "F",
    Callback    = function(key)
        pcall(function()
            State.EspKeybind = Enum.KeyCode[key]
        end)
    end,
})

EspSection:CreateToggle({
    Title       = "Team Check (ESP)",
    Description = "Ignora jugadores del mismo equipo.",
    Default     = true,
    Callback    = function(v)
        State.TeamCheck = v
        if State.EspEnabled then RefreshESP() end
    end,
})

-- Parte Hitbox
local HitboxSection = EspTab:CreateSection("Hitbox")

HitboxSection:CreateToggle({
    Title       = "Hitbox Expander",
    Description = "Agranda la hitbox de los enemigos.",
    Default     = false,
    Callback    = function(v)
        State.HitboxEnabled = v
        RefreshHitbox()
    end,
})

HitboxSection:CreateKeybind({
    Title       = "Keybind Hitbox",
    Description = "Activa / desactiva el hitbox.",
    Default     = "H",
    Callback    = function(key)
        pcall(function()
            State.HitboxKeybind = Enum.KeyCode[key]
        end)
    end,
})

HitboxSection:CreateSlider({
    Title       = "Tamaño Hitbox",
    Description = "Tamaño de la hitbox expandida.",
    Min         = 4,
    Max         = 30,
    Default     = 8,
    Rounding    = 0,
    Callback    = function(v)
        State.HitboxSize = Vector3.new(v, v, v)
        if State.HitboxEnabled then RefreshHitbox() end
    end,
})

HitboxSection:CreateToggle({
    Title       = "Hitbox Visible",
    Description = "Muestra la hitbox expandida (para verificar).",
    Default     = false,
    Callback    = function(v)
        State.HitboxVisible = v
        if State.HitboxEnabled then RefreshHitbox() end
    end,
})

HitboxSection:CreateToggle({
    Title       = "Team Check (Hitbox)",
    Description = "No expande hitbox de tu equipo.",
    Default     = true,
    Callback    = function(v)
        -- ya usa State.TeamCheck global
    end,
})

-- ── TAB: SETTINGS ────────────────────────

local SettingsTab = Window:CreateTab("Settings", "settings")
local SettingsSection = SettingsTab:CreateSection("Info")

SettingsSection:CreateParagraph({
    Title   = "ℹ️  NoirX Tz",
    Content = "v1.0  —  by Tz-hzk\nSilent Aim detecta FireWeapon automaticamente.",
})
