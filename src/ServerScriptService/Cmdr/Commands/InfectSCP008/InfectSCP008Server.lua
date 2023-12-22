return function(_, players: {Player})
    local message = ""
    for _, player in players do
        if player.Character and player.Character.PrimaryPart then
            player.Character.PrimaryPart:AddTag("SCP008Infection")
            message = `{message}{player.Name} has been infected with SCP-008!\n`
        end
    end
    message = string.sub(message, 1, -2)
    return message
end