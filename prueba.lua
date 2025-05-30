wait(0.5)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ba = Instance.new("ScreenGui")
local ca = Instance.new("Frame")
local titulo = Instance.new("TextLabel")
local inputBox = Instance.new("TextBox")
local ejecutarBtn = Instance.new("TextButton")
local cerrarBtn = Instance.new("TextButton") -- Botón cerrar
local outputLabel = Instance.new("TextLabel")

ba.Name = "MenuComandos"
ba.Parent = player:WaitForChild("PlayerGui")
ba.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
ca.Parent = ba
ca.Active = true
ca.BackgroundColor3 = Color3.new(0.176, 0.176, 0.176)
ca.Position = UDim2.new(0.7, 0, 0.1, 0)
ca.Size = UDim2.new(0, 370, 0, 200)
ca.Draggable = true

-- Título
titulo.Parent = ca
titulo.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Font = Enum.Font.SourceSansSemibold
titulo.Text = "Menú de Comandos"
titulo.TextColor3 = Color3.new(0, 1, 1)
titulo.TextSize = 22

-- Caja de texto para comandos
inputBox.Parent = ca
inputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
inputBox.Size = UDim2.new(0.9, 0, 0, 40)
inputBox.PlaceholderText = "Escribe comando aquí..."
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 20
inputBox.ClearTextOnFocus = false

-- Botón ejecutar
ejecutarBtn.Parent = ca
ejecutarBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
ejecutarBtn.Size = UDim2.new(0.4, 0, 0, 40)
ejecutarBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.5)
ejecutarBtn.Font = Enum.Font.SourceSansBold
ejecutarBtn.Text = "Ejecutar"
ejecutarBtn.TextColor3 = Color3.new(1, 1, 1)
ejecutarBtn.TextSize = 22

-- Botón cerrar
cerrarBtn.Parent = ca
cerrarBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
cerrarBtn.Size = UDim2.new(0.4, 0, 0, 40)
cerrarBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
cerrarBtn.Font = Enum.Font.SourceSansBold
cerrarBtn.Text = "Cerrar"
cerrarBtn.TextColor3 = Color3.new(1, 1, 1)
cerrarBtn.TextSize = 22

-- Label de salida (mensajes)
outputLabel.Parent = ca
outputLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
outputLabel.Size = UDim2.new(0.9, 0, 0, 40)
outputLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
outputLabel.Font = Enum.Font.SourceSansItalic
outputLabel.TextColor3 = Color3.new(0, 1, 1)
outputLabel.TextSize = 18
outputLabel.Text = "Esperando comando..."

-- Variables para fly
local flyEnabled = false
local bodyVelocity, bodyGyro

local function toggleFly()
    local character = player.Character
    if not character then 
        outputLabel.Text = "No hay personaje."
        return 
    end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then
        outputLabel.Text = "No se encontró Humanoid o HumanoidRootPart."
        return
    end

    if flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        humanoid.PlatformStand = false
        outputLabel.Text = "Vuelo desactivado."
    else
        flyEnabled = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 10
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.Parent = humanoidRootPart

        humanoid.PlatformStand = true
        outputLabel.Text = "Vuelo activado."
    end
end

local noclipEnabled = false
local function toggleNoclip()
    local character = player.Character
    if not character then
        outputLabel.Text = "No hay personaje."
        return
    end
    noclipEnabled = not noclipEnabled
    outputLabel.Text = noclipEnabled and "Noclip activado." or "Noclip desactivado."
end

-- Conexión para noclip
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local function teleportToPlayer(name)
    local target = Players:FindFirstChild(name)
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not target then
        outputLabel.Text = "Jugador no encontrado: " .. name
        return
    end

    if not humanoidRootPart then
        outputLabel.Text = "No se pudo teletransportar (sin HumanoidRootPart)."
        return
    end

    local targetCharacter = target.Character
    local targetHRP = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

    if not targetHRP then
        outputLabel.Text = "El jugador objetivo no tiene HumanoidRootPart."
        return
    end

    humanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    outputLabel.Text = "Teletransportado a " .. name
end

-- Función para ejecutar comandos
local function ejecutarComando(cmd)
    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word)
    end

    local command = args[1] and args[1]:lower() or ""

    if command == "saludar" then
        outputLabel.Text = "¡Hola, " .. player.Name .. "! Has usado el comando Saludar."
    elseif command == "volar" then
        toggleFly()
    elseif command == "noclip" then
        toggleNoclip()
    elseif command == "teleport" and args[2] then
        teleportToPlayer(args[2])
    else
        outputLabel.Text = "Comando no reconocido."
    end
end

-- Evento botón ejecutar
ejecutarBtn.MouseButton1Click:Connect(function()
    local texto = inputBox.Text
    if texto ~= "" then
        ejecutarComando(texto)
    else
        outputLabel.Text = "Por favor, escribe un comando."
    end
end)

-- Evento botón cerrar
cerrarBtn.MouseButton1Click:Connect(function()
    ba:Destroy()
end)
