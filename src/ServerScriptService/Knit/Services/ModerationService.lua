local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Moderation",
}

service.EventType = {
    Kick = "Kick",
}

function service:KnitStart()
    self.PlayerDataService = Knit.GetService("PlayerData")
end

--[[
    Records a moderation event in a player's permanent moderation record.
--]]
function service:logModerationEvent(player: Player, moderator: Player, eventType: string, reason: string, details: table)
    local profileData = self.PlayerDataService:getProfileData(player)
    local moderationEvent = {
        eventType = eventType,
        reason = reason,
        details = details,
        moderator = moderator.UserId,
        timestamp = os.time(),
    }
    table.insert(
        profileData.moderationRecord,
        moderationEvent
    )
    print(`{moderator} successfully logged "{eventType}" moderation event in {player.Name}'s moderation record.`)
end

--[[
    Pardons a moderation event in a player's moderation record. This doesn't delete the event,
    but it marks it as pardoned, logging the pardoning moderator, reason and timestamp.
--]]
function service:pardonModerationEvent(player: Player, moderator: Player, id: number, reason: string)
    local profileData = self.PlayerDataService:getProfileData(player)
    local moderationEvent = profileData.moderationRecord[id]
    if not moderationEvent then
        return `Moderation event with ID {id} does not exist in {player.Name}'s moderation record!`
    elseif moderationEvent.pardon then
        return `Moderation event with ID {id} has already been pardoned in {player.Name}'s moderation record!`
    end
    moderationEvent.pardon = {
        moderator = moderator.UserId,
        reason = reason,
        timestamp = os.time(),
    }
    print(`{moderator} successfully pardoned moderation event ID {id} in {player.Name}'s moderation record.`)
    return `Successfully pardoned moderation event ID {id} in {player.Name}'s moderation record.`
end

--[[
    Returns a player's moderation record.
--]]
function service:getModerationRecord(player: Player)
    local profileData = self.PlayerDataService:getProfileData(player)
    return profileData.moderationRecord
end

--[[
    Kicks a player from the server and logs a new kick event in their moderation record.
--]]
function service:kick(player: Player, moderator: Player, reason: string)
    self:logModerationEvent(player, moderator, self.EventType.Kick, reason)
    player:Kick(
        `You have been kicked from this server by {moderator.Name} for "{reason}".\
        Your moderation record has been updated appropriately.`
    )
end

return service