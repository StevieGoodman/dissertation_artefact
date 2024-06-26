local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local BanService = Knit.GetService("Ban")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player | number}, reason: string)
    local userIds = TableUtil.Map(players, function(player)
        local userId = if typeof(player) == "number"
            then player
            else player.UserId
        return userId
    end)
    local kickableUserIds = TableUtil.Filter(userIds, function(userId)
        local canKick = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        return canKick
    end)
    local success, err = BanService:Ban({
        UserIds = kickableUserIds,
        DisplayReason = reason,
        PrivateReason = reason,
        Duration = BanService.KickDuration,
    })
    if not success then
        return `Failed to kick players: {err}`
    end
    local message = ""
    for _, userId in userIds do
        local canKick = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        message ..= if canKick
            then `Kicked user ID {userId} successfully\n`
            else `Failed to kick user ID {userId}: Insufficient personnel class\n`
    end
    return string.sub(message, 1, -2)
end