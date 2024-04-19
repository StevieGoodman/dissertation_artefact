local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, player: Player | number, id: number, reason: string)
    local playerId = if type(player) == "number" then player else player.UserId
    local playerName = `User ID {playerId}`
    pcall(function()
        playerName = Players:GetNameFromUserIdAsync(playerId)
    end)
    -- Check permissions
    if not CommandPermissionsService:comparePermissions(context.Executor.UserId, playerId) then
        return `You do not have a high enough personnel class to pardon {playerName}'s moderation event!`
    end
    -- Pardon moderation event
    PlayerDataService:createProfileUpdate(playerId, {
        service = "Moderation",
        functionName = "pardonModerationEvent",
        args = { context.Executor.UserId, id, reason },
    })
    return `Successfully pardoned moderation event ID {id} in {playerName}'s moderation record.`
end