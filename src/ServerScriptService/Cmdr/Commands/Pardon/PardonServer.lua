local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModerationService = Knit.GetService("Moderation")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, player: Player, id: number, reason: string)
    if not CommandPermissionsService:comparePermissions(context.Executor, player) then
        return `You do not have a high enough personnel class to pardon {player.Name}'s moderation event!`
    end
    local message = ModerationService:pardonModerationEvent(player, context.Executor, id, reason)
    return message
end