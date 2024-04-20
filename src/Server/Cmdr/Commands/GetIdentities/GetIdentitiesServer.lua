local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_)
    local success, result = pcall(function()
        return Knit.GetService("Identity").identities
    end)
    if success then
        local message = ``
        for player, identity in pairs(result) do
            message = `{message}[{player}]: {identity}\n`
        end
        message = message:sub(1, -2)
        return message
    else
        return `Failed to get identities list! {result}`
    end
end