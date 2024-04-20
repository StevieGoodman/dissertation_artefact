local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context, amount: number, location: string)
    local TestQueueService = Knit.GetService("TestQueue")
    local requestResult, players = TestQueueService:request(context.Executor, amount, location)
    if requestResult == TestQueueService.RequestResult.InvalidAmount then
        return "You must request at least 1 player!"
    elseif requestResult == TestQueueService.RequestResult.NotResearchOrMedical then
        return "You must be reseacher or medical officer to request a test!"
    elseif requestResult == TestQueueService.RequestResult.QueueEmpty then
        return "There are currently no players in the test queue!"
    elseif requestResult == TestQueueService.RequestResult.NotEnoughPlayersInQueue then
        return `There are only {players} players in the test queue!`
    else
        local msg = `You have requested {amount} players from the test queue:`
        for _, player in players do
            local identity = Knit.GetService("Identity"):getPlayerIdentity(player)
            msg ..= `\n{identity}`
        end
        return msg
    end
end