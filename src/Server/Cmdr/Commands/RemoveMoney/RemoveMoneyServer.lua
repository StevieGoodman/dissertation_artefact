local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_, players: {Player}, amount: number)
    local MoneyService = Knit.GetService("Money")

    local msg = ""
    for _, player in players do
        local result = MoneyService:remove(player, amount)
        msg ..= `{player}: {result}\n`
    end
    msg = msg:sub(1, -2)
    return msg
end