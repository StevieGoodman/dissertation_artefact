local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_)
    local success, result = pcall(function()
        return Knit.GetService("Identity").surnames
    end)
    if success then
        local message = ``
        for surname, player in pairs(result) do
            message = `{message}[{surname}]: {player}\n`
        end
        message = message:sub(1, -2)
        return message
    else
        return `Failed to get surnames list! {result}`
    end
end