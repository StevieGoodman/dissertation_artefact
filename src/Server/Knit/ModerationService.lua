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
        local moderatorName = `user ID {moderationEvent.moderator}`
        pcall(function()
            moderatorName = Players:GetNameFromUserIdAsync(moderationEvent.moderator)
        end)
        local kickMsg = os.date(
            `You have been temporarily banned from the game by {moderatorName} for \"{moderationEvent.reason}\". Your ban will be lifted on %A %d %B at %I:%M%p.`,
            moderationEvent.details.endTimestamp
        )
        player:Kick(kickMsg)
        break
    end
end

--[[
    Records a moderation event in a player's permanent moderation record.
--]]
function service:logModerationEvent(profile: table, userId: number, moderator: number, eventType: string, reason: string, details: table)
    local moderationEvent = {
        eventType = eventType,
        reason = reason,
        details = details,
        moderator = moderator,
        timestamp = os.time(),
    }
    table.insert(
        profile.Data.moderationRecord,
        moderationEvent
    )
    if Players:GetPlayerByUserId(userId) then
        self:screenPlayer(Players:GetPlayerByUserId(userId))
    end
end

--[[
    Pardons a moderation event in a player's moderation record. This doesn't delete the event,
    but it marks it as pardoned, logging the pardoning moderator, reason and timestamp.
--]]
function service:pardonModerationEvent(profile, _, moderatorId: number, id: number, reason: string)
    local profileData = profile.Data
    local moderationEvent = profileData.moderationRecord[id]
    if not moderationEvent or moderationEvent.pardon then
        return
    end
    moderationEvent.pardon = {
        moderator = moderatorId,
        reason = reason,
        timestamp = os.time(),
    }
end

--[[
    Returns a player's moderation record.
--]]
function service:getModerationRecord(playerId: number)
    local profile = self.PlayerDataService:getProfile(playerId)
    if profile then
        return profile.Data.moderationRecord
    else
        return nil
    end
end

return service