local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context)
    local TestQueueService = Knit.GetService("TestQueue")
    local removeResult = TestQueueService:remove(context.Executor)
    if removeResult == TestQueueService.RemoveResult.NotInQueue then
        return "You are not in the test queue."
    else
        return "You have been removed from the test queue."
    end
end