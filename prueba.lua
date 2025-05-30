local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Chat = game:GetService("Chat")

local commands = {}

-- Comando para saludar
commands["saludar"] = function(args)
    print("¡Hola, " .. player.Name .. "! Has usado el comando saludar.")
end

-- Comando para cambiar la velocidad del personaje
commands["velocidad"] = function(args)
    local speed = tonumber(args[1])
    if speed then
        player.Character.Humanoid.WalkSpeed = speed
        print("Velocidad cambiada a " .. speed)
    else
        print("Por favor ingresa un número válido para la velocidad.")
    end
end

-- Escuchar mensajes del chat del jugador
player.Chatted:Connect(function(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, word)
    end
    local cmd = args[1]:lower()
    table.remove(args, 1) -- remover comando

    if commands[cmd] then
        commands[cmd](args)
    else
        print("Comando no encontrado: " .. cmd)
    end
end)
