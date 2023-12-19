local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_, target: Player)
    local success, result = pcall(function()
        return Knit.GetService("Identity"):reserveSurname(target)
    end)
    if success then
        return `Reserved surname for {target}! Their new surname is {result}.`
    else
        return `Failed to reserve surname for {target}! {result}`
    end
end