local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player | number}, reason: string)
    local message = ""
    for _, player in players do
        local userId = if type(player) == "number" then player else player.UserId
        local playerName = `user ID {player}`
        pcall(function()
            playerName = Players:GetNameFromUserIdAsync(userId)
        end)
        -- Check for permissions
        local canKick = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        if not canKick then
            message ..= `You do not have a high enough personnel class to kick {player.Name}!\n`
            continue
        end
        -- Kick player
        local updateData = {
            service = "Moderation",
            functionName = "logModerationEvent",
            args = { context.Executor.UserId, "Kick", reason },
        }
        PlayerDataService:createProfileUpdate(userId, updateData)
        player:Kick(`You have been kicked from this server by {context.Executor} for "{reason}".`)
        message ..= `Successfully kicked {playerName}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end

