local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModerationService = Knit.GetService("Moderation")

return function(_, player: Player)
    local moderationRecord = ModerationService:getModerationRecord(player)
    local message = ""
    for id, moderationEvent in moderationRecord do
        local moderatorName = "Unknown"
        message ..= `Event ID: {id}\n`
        message ..= `Event Type: {moderationEvent.eventType}\n`
        message ..= `Moderator: {moderatorName} ({moderationEvent.moderator})\n`
        message ..= `Reason: {moderationEvent.reason}\n`
        local formattedTime = os.date("!%A %d %B at %I:%M%p", moderationEvent.timestamp)
        message ..= `Timestamp: {formattedTime}\n`
        if moderationEvent.pardon then
            moderatorName = "Unknown"
            pcall(function()
                moderatorName = Players:GetNameFromUserIdAsync(moderationEvent.pardon.moderator)
            end)
            message ..= `Pardoned by: {moderatorName} ({moderationEvent.pardon.moderator})\n`
            message ..= `Pardon Reason: {moderationEvent.pardon.reason}\n`
            formattedTime = os.date("!%A %d %B at %I:%M%p", moderationEvent.pardon.timestamp)
            message ..= `Pardon Timestamp: {formattedTime}\n`
        end
        message ..= "----------------\n"
    end
    message = string.sub(message, 1, -18) -- Remove the last line break
    if message == "" then
        message = `{player.Name} has no moderation record.`
    end
    return message
end