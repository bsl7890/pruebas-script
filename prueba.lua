wait(0.5)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local ba = Instance.new("ScreenGui")
local ca = Instance.new("Frame")
local titulo = Instance.new("TextLabel")
local inputBox = Instance.new("TextBox")
local ejecutarBtn = Instance.new("TextButton")
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
ejecutarBtn.Position = UDim2.new(0.3, 0, 0.55, 0)
ejecutarBtn.Size = UDim2.new(0.4, 0, 0, 40)
ejecutarBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.5)
ejecutarBtn.Font = Enum.Font.SourceSansBold
ejecutarBtn.Text = "Ejecutar"
ejecutarBtn.TextColor3 = Color3.new(1, 1, 1)
ejecutarBtn.TextSize = 22

-- Label de salida (mensajes)
outputLabel.Parent = ca
outputLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
outputLabel.Size = UDim2.new(0.9, 0, 0, 40)
outputLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
outputLabel.Font = Enum.Font.SourceSansItalic
outputLabel.TextColor3 = Color3.new(0, 1, 1)
outputLabel.TextSize = 18
outputLabel.Text = "Esperando comando..."

-- Variables vuelo y noclip
local flyEnabled = false
local noclipEnabled = false
local bodyVelocity, bodyGyro

local keysPressed = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysPressed[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysPressed[input.KeyCode] = false
    end
end)

-- Función para activar/desactivar noclip
local function toggleNoclip()
    local character = player.Character
    if not character then
        outputLabel.Text = "No hay personaje."
        return
    end

    noclipEnabled = not noclipEnabled

    if noclipEnabled then
        outputLabel.Text = "Noclip activado."
    else
        outputLabel.Text = "Noclip desactivado."
        -- Restaurar colisiones normales
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Función para actualizar noclip cada frame
local function updateNoclip()
    if not noclipEnabled then return end
    local character = player.Character
    if not character then return end

    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Función para actualizar vuelo
local function updateFly()
    if not flyEnabled then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local camCFrame = workspace.CurrentCamera.CFrame
    local direction = Vector3.new(0,0,0)

    if keysPressed[Enum.KeyCode.W] then
        direction = direction + camCFrame.LookVector
    end
    if keysPressed[Enum.KeyCode.S] then
        direction = direction - camCFrame.LookVector
    end
    if keysPressed[Enum.KeyCode.A] then
        direction = direction - camCFrame.RightVector
    end
    if keysPressed[Enum.KeyCode.D] then
        direction = direction + camCFrame.RightVector
    end
    if keysPressed[Enum.KeyCode.Space] then
        direction = direction + Vector3.new(0,1,0)
    end
    if keysPressed[Enum.KeyCode.LeftShift] then
        direction = direction - Vector3.new(0,1,0)
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit * 50 -- velocidad vuelo
    end

    bodyVelocity.Velocity = direction
    bodyGyro.CFrame = camCFrame
end

-- Función para activar/desactivar vuelo
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
        -- Desactivar vuelo
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        humanoid.PlatformStand = false
        outputLabel.Text = "Vuelo desactivado."
    else
        -- Activar vuelo
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

-- Ejecutar comando según texto
local function ejecutarComando(cmd)
    cmd = cmd:lower()
    if cmd == "saludar" then
        outputLabel.Text = "¡Hola, " .. player.Name .. "! Has usado el comando Saludar."
    elseif cmd == "volar" then
        toggleFly()
    elseif cmd == "noclip" then
        toggleNoclip()
    else
        outputLabel.Text = "Comando no reconocido."
    end
end

-- Actualizar cada frame vuelo y noclip
RunService.Heartbeat:Connect(function()
    if flyEnabled then
        updateFly()
    end
    if noclipEnabled then
        updateNoclip()
    end
end)

-- Evento botón
ejecutarBtn.MouseButton1Click:Connect(function()
    local texto = inputBox.Text
    if texto ~= "" then
        ejecutarComando(texto)
    else
        outputLabel.Text = "Por favor, escribe un comando."
    end
end)
