local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player | number}, reason: string)
    local message = ""
    for _, player in players do
        -- Check for permissions
        local canKick = CommandPermissionsService:comparePermissions(context.Executor, player)
        if not canKick then
            message ..= `You do not have a high enough personnel class to kick {player.Name}!\n`
            continue
        end
        -- Kick player
        local playerId = if type(player) == "number" then player else player.UserId
        local updateData = {
            service = "Moderation",
            functionName = "logModerationEvent",
            args = { context.Executor.UserId, "Kick", reason },
        }
        PlayerDataService:createProfileUpdate(playerId, updateData)
        player:Kick(`You have been kicked from this server by {context.Executor} for "{reason}".`)
        message ..= `Successfully kicked {player.Name}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end

