local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_)
    local TestQueueService = Knit.GetService("TestQueue")
    local getResult, queue = TestQueueService:get()
    if getResult == TestQueueService.GetResult.QueueEmpty then
        return "The test queue is empty."
    else
        local msg = `The test queue contains {#queue} players:`
        for index, player in queue do
            local identity = Knit.GetService("Identity"):getPlayerIdentity(player)
            msg ..= `\n{index}. {player.Name} ({identity})`
        end
        return msg
    end
end