local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

function ban(playerId: number, moderator: Player, reason: string, endTimestamp: number)
    local updateData = {
        service = "Moderation",
        functionName = "logModerationEvent",
        args = { moderator.UserId, "Ban", reason, { endTimestamp = endTimestamp } },
    }
    PlayerDataService:createProfileUpdate(playerId, updateData)
end

return function(context, players: {Player | number}, duration: number, reason: string)
    local message = ""
    for _, player in players do
        local userId = if type(player) == "number" then player else player.UserId
        local playerName = `user ID {player}`
        pcall(function()
            playerName = Players:GetNameFromUserIdAsync(userId)
        end)
        -- Check permissions
        local canKick = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        if not canKick then
            message ..= `You do not have a high enough personnel class to ban {player.Name}!\n`
            continue
        end
        local endTimestamp = os.time() + duration
        ban(userId, context.Executor, reason, endTimestamp)
        message ..= `Successfully banned {playerName}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end

