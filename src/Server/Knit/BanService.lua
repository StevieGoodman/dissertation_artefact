local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local KICK_DURATION = 60*60
local MAX_BAN_DURATION = 60*60*24*365
local BAN_DURATION_RANGE = NumberRange.new(KICK_DURATION, MAX_BAN_DURATION)

local Service = Knit.CreateService {
    Name = "Ban",
}

function Service:KnitInit()
    self.KickDuration = KICK_DURATION
    self.MaxBanDuration = MAX_BAN_DURATION
    self.BanDurationRange = BAN_DURATION_RANGE
end

function Service:Ban(config: table): (boolean, string?)
    if not config.DisplayReason then
        return false, "DisplayReason is required"
    end
    if not config.PrivateReason then
        return false, "PrivateReason is required"
    end
    if not config.Duration then
        return false, "Duration is required"
    end
    config.ExcludeAltAccounts = false
    config.ApplyToUniverse = true
    config.DisplayReason ..= ". To appeal this ban, contact Site 74 staff."
    local durationWithinRange =
        config.Duration == -1 or
        BAN_DURATION_RANGE.Min <= config.Duration and config.Duration <= BAN_DURATION_RANGE.Max
    if not durationWithinRange then
        return false, `Ban duration must be within {BAN_DURATION_RANGE.Min} and {BAN_DURATION_RANGE.Max} seconds`
    end
    local success, err = pcall(Players.BanAsync, Players, config)
    return success, err
end

function Service:Unban(config: table): (boolean, string?)
    config.ApplyToUniverse = true
    local success, err = pcall(Players.UnbanAsync, Players, config)
    return success, err
end

function Service:GetHistory(userId: number): (boolean, table | string)
    local success, result = pcall(Players.GetBanHistoryAsync, Players, userId)
    if not success then
        return false, `Cannot get ban history: {result}`
    end
    local banHistory = {}
    local banHistoryPages = result :: BanHistoryPages
    while not banHistoryPages.IsFinished do
        table.insert(banHistory, banHistoryPages:GetCurrentPage())
        local success, err = pcall(banHistoryPages.AdvanceToNextPageAsync, banHistoryPages)
        if not success then
            return false, `Cannot get next ban history page: {err}`
        end
    end
    return true, banHistory
end

return Service