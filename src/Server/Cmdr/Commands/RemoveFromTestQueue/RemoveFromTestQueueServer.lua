local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_, players: {Player})
    local TestQueueService = Knit.GetService("TestQueue")

    local msg = ""
    for _, player in players do
        local removeResult = TestQueueService:remove(player)
        if removeResult == TestQueueService.RemoveResult.NotInQueue then
            msg ..= `{player} is not in the test queue.`
        else
            msg ..= `{player} has been removed from the test queue.`
        end
        msg ..= "\n"
    end
    msg = msg:sub(1, -2)
    return msg
end