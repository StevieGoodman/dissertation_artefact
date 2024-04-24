local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_, player: Player)
    local MoneyService = Knit.GetService("Money")
    local money = MoneyService:get(player)
    return `Player has {money} money.`
end