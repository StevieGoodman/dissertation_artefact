local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, player: Player | number, id: number, reason: string)
    local playerId = if type(player) == "number" then player else player.UserId
    -- Check permissions
    if not CommandPermissionsService:comparePermissions(context.Executor, player) then
        return `You do not have a high enough personnel class to pardon {player.Name}'s moderation event!`
    end
    -- Pardon moderation event
    PlayerDataService:createProfileUpdate(playerId, {
        service = "Moderation",
        functionName = "pardonModerationEvent",
        args = { context.Executor.UserId, id, reason },
    })
    return `Successfully pardoned moderation event ID {id} in {player}'s moderation record.`
end