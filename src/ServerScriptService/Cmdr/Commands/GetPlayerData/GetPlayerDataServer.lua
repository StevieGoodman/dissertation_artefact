local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

function parseData(data, indent: number?)
    if not indent then
        indent = 0
    end
    -- Parse data
    local parsedData = "{\n"
    for key, value in data do
        parsedData ..= string.rep(" ", indent + 4)
        if type(value) == "table" then
            value = parseData(value, indent + 4)
        end
        parsedData ..= `{key}: {value}\n`
    end
    parsedData ..= string.rep(" ", indent) .. "}\n"
    parsedData = string.sub(parsedData, 1, -2)
    return parsedData
end

return function(_, player: Player | number)
    local playerId = if type(player) == "number" then player else player.UserId
    local profile = Knit.GetService("PlayerData"):getProfile(playerId)
    if not profile then
        local playerName = `User ID {playerId}`
        pcall(function()
            playerName = Players:GetNameFromUserIdAsync(playerId)
        end)
        return `{playerName} has never joined the game.`
    end
    local message = parseData(profile.Data)
    return message
end