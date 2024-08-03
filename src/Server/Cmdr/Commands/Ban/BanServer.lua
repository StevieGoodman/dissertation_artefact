local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local BanService = Knit.GetService("Ban")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player | number}, duration: number, reason: string)
    local userIds = TableUtil.Map(players, function(player)
        local userId = if typeof(player) == "number"
            then player
            else player.UserId
        return userId
    end)
    local bannableUserIds = TableUtil.Filter(userIds, function(userId)
        local canBan = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        return canBan
    end)
    local success, err = BanService:Ban({
        UserIds = bannableUserIds,
        DisplayReason = reason,
        PrivateReason = reason,
        Duration = duration,
    })
    if not success then
        return `Failed to ban players: {err}`
    end
    local message = ""
    for _, userId in userIds do
        local canKick = CommandPermissionsService:comparePermissions(context.Executor.UserId, userId)
        message ..= if canKick
            then `Banned user ID {userId} successfully\n`
            else `Failed to ban user ID {userId}: Insufficient personnel class\n`
    end
    return string.sub(message, 1, -2)
end