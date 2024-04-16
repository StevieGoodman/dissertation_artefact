local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModerationService = Knit.GetService("Moderation")

local TIME_FORMAT_STRING = "%A %d %B %Y at %I:%M%p"

return function(_, player: Player)
    local moderationRecord = ModerationService:getModerationRecord(player)
    local message = ""
    for id, moderationEvent in moderationRecord do
        local moderatorName = `user ID {moderationEvent.moderator}`
        pcall(function()
            moderatorName = Players:GetNameFromUserIdAsync(moderationEvent.pardon.moderator)
        end)
        local formattedTime = os.date(TIME_FORMAT_STRING, moderationEvent.timestamp)
        message ..= `(#{id}) {moderationEvent.eventType}: {moderationEvent.reason}\nModerated by {moderatorName} on {formattedTime}\n`
        if moderationEvent.pardon then
            moderatorName = `user ID {moderationEvent.pardon.moderator}`
            pcall(function()
                moderatorName = Players:GetNameFromUserIdAsync(moderationEvent.pardon.moderator)
            end)
            formattedTime = os.date(TIME_FORMAT_STRING, moderationEvent.pardon.timestamp)
            message ..= `Pardoned: {moderationEvent.pardon.reason}\nPardoned by {moderatorName} on {formattedTime}\n`
        end
        message ..= "\n"
    end
    message = string.sub(message, 1, -3) -- Remove the last line break
    if message == "" then
        message = `{player.Name} has no moderation record.`
    end
    return message
end