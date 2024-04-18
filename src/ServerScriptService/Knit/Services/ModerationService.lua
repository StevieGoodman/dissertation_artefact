local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local service = Knit.CreateService {
    Name = "Moderation",
}

service.EventType = {
    Kick = "Kick",
    Ban = "Ban",
}

function service:KnitStart()
    self.PlayerDataService = Knit.GetService("PlayerData")
    Observers.observePlayer(function(player)
        self:screenPlayer(player)
    end)
    for _, player in Players:GetPlayers() do
        self:screenPlayer(player)
    end
end

--[[
    Verifies a player isn't banned from the game.
--]]
function service:screenPlayer(player: Player)
    local profileData = self.PlayerDataService:getProfile(player.UserId).Data
    for _, moderationEvent in profileData.moderationRecord do
        if moderationEvent.eventType ~= service.EventType.Ban
        or moderationEvent.details.endTimestamp < os.time()
        or moderationEvent.pardon then
            continue
        end
        local hour = os.date("%I", moderationEvent.details.endTimestamp)
        hour = if hour:sub(1, 1) == "0" then hour:sub(2) else hour -- Remove leading zero
        local moderatorName = `user ID {moderationEvent.moderator}`
        pcall(function()
            moderatorName = Players:GetNameFromUserIdAsync(moderationEvent.moderator)
        end)
        local kickMsg = os.date(
            `You have been temporarily banned from the game by {moderatorName} for \"{moderationEvent.reason}\". Your ban will be lifted on %A %d %B at {hour}%p.`, 
            moderationEvent.details.endTimestamp
        )
        player:Kick(kickMsg)
        break
    end
end

--[[
    Records a moderation event in a player's permanent moderation record.
--]]
function service:logModerationEvent(profile: table, moderator: Player, eventType: string, reason: string, details: table)
    local moderationEvent = {
        eventType = eventType,
        reason = reason,
        details = details,
        moderator = moderator.UserId,
        timestamp = os.time(),
    }
    table.insert(
        profile.Data.moderationRecord,
        moderationEvent
    )
    print(`{moderator} successfully logged "{eventType}" moderation event in {player.Name}'s moderation record.`)
end

--[[
    Pardons a moderation event in a player's moderation record. This doesn't delete the event,
    but it marks it as pardoned, logging the pardoning moderator, reason and timestamp.
--]]
function service:pardonModerationEvent(profile, moderator: Player, id: number, reason: string)
    local profileData = profile.Data
    local playerName = `user ID {profile.UserIds[1]}`
    pcall(function()
        playerName = Players:GetNameFromUserIdAsync(profile.UserIds[1])
    end)
    local moderationEvent = profileData.moderationRecord[id]
    if not moderationEvent then
        return `Moderation event with ID {id} does not exist in {playerName}'s moderation record!`
    elseif moderationEvent.pardon then
        return `Moderation event with ID {id} has already been pardoned in {playerName}'s moderation record!`
    end
    moderationEvent.pardon = {
        moderator = moderator.UserId,
        reason = reason,
        timestamp = os.time(),
    }
    return `Successfully pardoned moderation event ID {id} in {playerName}'s moderation record.`
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
    local updateData = {
        service = "Moderation",
        functionName = "logModerationEvent",
        args = { moderator, service.EventType.Kick, reason },
    }
    self.PlayerDataService:createProfileUpdate(player.UserId, updateData)
    player:Kick(`You have been kicked from this server by {moderator.Name} for "{reason}".`)
end

--[[
    Bans a player from the game temporarily and logs a new ban event in their moderation record.
--]]
function service:banTemporarily(player: Player, moderator: Player, reason: string, endTimestamp: number)
    local updateData = {
        service = "Moderation",
        functionName = "logModerationEvent",
        args = { moderator, service.EventType.Ban, reason, { endTimestamp = endTimestamp } },
    }
    self.PlayerDataService:createProfileUpdate(player.UserId, updateData)
    local hour = os.date("%I", endTimestamp)
    hour = if hour:sub(1, 1) == "0" then hour:sub(2) else hour -- Remove leading zero
    local kickMsg = os.date(
        `You have been temporarily banned from the game by {moderator.Name} for \"{reason}\". Your ban will be lifted on %A %d %B at {hour}%p.`,
        endTimestamp
    )
    --player:Kick(kickMsg)
end

return service