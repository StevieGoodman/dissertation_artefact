local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_, target: Player)
    local success, result = pcall(function()
        return Knit.GetService("Identity"):releaseSurname(target)
    end)
    if success then
        return `Released surname for {target}! They no longer have a surname.`
    else
        return `Failed to release surname for {target}! {result}`
    end
end