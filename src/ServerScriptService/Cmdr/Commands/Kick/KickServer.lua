local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModerationService = Knit.GetService("Moderation")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player}, reason: string)
    local message = ""
    for _, player in players do
        local canKick = CommandPermissionsService:comparePermissions(context.Executor, player)
        if not canKick then
            message ..= `You do not have a high enough personnel class to kick {player.Name}!\n`
            continue
        end
        ModerationService:kick(player, context.Executor, reason)
        message ..= `Successfully kicked {player.Name}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end