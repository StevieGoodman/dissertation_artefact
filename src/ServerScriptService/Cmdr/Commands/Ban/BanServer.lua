local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModerationService = Knit.GetService("Moderation")
local CommandPermissionsService = Knit.GetService("CommandPermissions")

return function(context, players: {Player}, duration: number, reason: string)
    local message = ""
    for _, player in players do
        local canKick = CommandPermissionsService:comparePermissions(context.Executor, player)
        if not canKick then
            message ..= `You do not have a high enough personnel class to ban {player.Name}!\n`
            continue
        end
        local currentTime = os.date("!*t", os.time())
        local endTimestamp = os.time(
            {
                year = currentTime.year,
                month = currentTime.month,
                day = currentTime.day + 1,
                hour = 0,
                min = 0,
                sec = 0
            }
        )
        endTimestamp += duration
        ModerationService:banTemporarily(player, context.Executor, reason, endTimestamp)
        message ..= `Successfully banned {player.Name}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end