local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ComandosMenu"
screenGui.Parent = playerGui

-- Crear Frame (ventana)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Crear título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titulo.Text = "Menú de Comandos"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.SourceSansBold
titulo.TextSize = 24
titulo.Parent = frame

-- Crear texto para mostrar mensajes
local outputText = Instance.new("TextLabel")
outputText.Size = UDim2.new(1, -20, 0, 50)
outputText.Position = UDim2.new(0, 10, 1, -60)
outputText.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
outputText.TextColor3 = Color3.new(1, 1, 1)
outputText.Font = Enum.Font.SourceSans
outputText.TextSize = 18
outputText.TextWrapped = true
outputText.Text = "Aquí aparecerán los mensajes..."
outputText.Parent = frame

-- Función para mostrar mensaje en el texto
local function mostrarMensaje(msg)
    outputText.Text = msg
end

-- Botón Saludar
local btnSaludar = Instance.new("TextButton")
btnSaludar.Size = UDim2.new(0.8, 0, 0, 40)
btnSaludar.Position = UDim2.new(0.1, 0, 0, 50)
btnSaludar.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
btnSaludar.Text = "Saludar"
btnSaludar.TextColor3 = Color3.new(1, 1, 1)
btnSaludar.Font = Enum.Font.SourceSansBold
btnSaludar.TextSize = 22
btnSaludar.Parent = frame

btnSaludar.MouseButton1Click:Connect(function()
    mostrarMensaje("¡Hola, " .. player.Name .. "! Has usado el comando Saludar.")
end)

-- Botón Cambiar velocidad
local btnVelocidad = Instance.new("TextButton")
btnVelocidad.Size = UDim2.new(0.8, 0, 0, 40)
btnVelocidad.Position = UDim2.new(0.1, 0, 0, 100)
btnVelocidad.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
btnVelocidad.Text = "Velocidad a 50"
btnVelocidad.TextColor3 = Color3.new(1, 1, 1)
btnVelocidad.Font = Enum.Font.SourceSansBold
btnVelocidad.TextSize = 22
btnVelocidad.Parent = frame

btnVelocidad.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
        mostrarMensaje("Velocidad cambiada a 50.")
    else
        mostrarMensaje("No se encontró Humanoid.")
    end
end)
