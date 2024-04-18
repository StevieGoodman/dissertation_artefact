local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerDataService = Knit.GetService("PlayerData")
local CommandPermissionsService = Knit.GetService("CommandPermissions")


function calculateEndTimestamp(duration: number)
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
    return endTimestamp
end

function ban(player: Player | number, moderator: Player, reason: string, endTimestamp: number)
    local playerId = if type(player) == "number" then player else player.UserId
    local updateData = {
        service = "Moderation",
        functionName = "logModerationEvent",
        args = { moderator.UserId, "Ban", reason, { endTimestamp = endTimestamp } },
    }
    PlayerDataService:createProfileUpdate(playerId, updateData)
    player:Kick(`You have been kicked from this server by a moderator for "{reason}".`)
end

function kick(player: Player, moderator: Player, reason: string, endTimestamp: number)
    local hour = os.date("%I", endTimestamp)
    hour = if hour:sub(1, 1) == "0" then hour:sub(2) else hour -- Remove leading zero
    local kickMsg = os.date(
        `You have been temporarily banned from the game by {moderator.Name} for \"{reason}\". Your ban will be lifted on %A %d %B at {hour}%p.`,
        endTimestamp
    )
    player:Kick(kickMsg)
end

return function(context, players: {Player | number}, duration: number, reason: string)
    local message = ""
    for _, player in players do
        -- Check permissions
        local canKick = CommandPermissionsService:comparePermissions(context.Executor, player)
        if not canKick then
            message ..= `You do not have a high enough personnel class to ban {player.Name}!\n`
            continue
        end
        local endTimestamp = calculateEndTimestamp(duration)
        ban(player, context.Executor, reason, endTimestamp)
        kick(player, context.Executor, reason, endTimestamp)
        message ..= `Successfully banned {player.Name}!\n`
    end
    message = string.sub(message, 1, -2)
    return message
end

