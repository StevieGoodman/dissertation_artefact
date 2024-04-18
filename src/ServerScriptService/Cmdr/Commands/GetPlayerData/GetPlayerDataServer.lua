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

return function(_, player: Player)
    local success, result = pcall(function()
        return Knit.GetService("PlayerData"):getProfile(player.UserId).Data
    end)
    if success then
        local message = parseData(result)
        return message
    else
        return `Failed to get player data! {result}`
    end
end