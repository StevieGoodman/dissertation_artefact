local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local BanService = Knit.GetService("Ban")

local TIME_FORMAT_STRING = "%A %d %B %Y at %I:%M%p"

return function(_, player: Player | number)
    local userId = if type(player) == "number" then player else player.UserId
    local success, result = BanService:GetHistory(userId)
    if not success then
        return `Failed to get moderation record: {result}`
    end
    local banHistory = result
    local noHistory = TableUtil.IsEmpty(banHistory)
    if noHistory then
        return `User ID {userId} has no bans on record.`
    end
    local message = ""
    for id, event in banHistory do
        local formattedTime = os.date(TIME_FORMAT_STRING, event.StartTime)
        local eventType = if event.Ban then "Ban" else "Unban"
        message ..= `(#{id}) {eventType}, {formattedTime}: {event.PrivateReason}\n`
    end
    return string.sub(message, 1, -2) -- Remove the last line break
end