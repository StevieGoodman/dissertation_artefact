local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context)
    local TestQueueService = Knit.GetService("TestQueue")
    local addResult = TestQueueService:add(context.Executor)
    if addResult == TestQueueService.AddResult.NotSpawnedIn then
        return "You must be spawned in to join the test queue!"
    elseif addResult == TestQueueService.AddResult.NotClassD then
        return "You must be Class-D Personnel to join the test queue!"
    elseif addResult == TestQueueService.AddResult.AlreadyInQueue then
        local _, place = TestQueueService:getPlaceInQueue(context.Executor)
        return `You are already in the test queue at position number {place}.`
    else
        local _, place = TestQueueService:getPlaceInQueue(context.Executor)
        return `You have been added to the test queue at position number {place}.`
    end
end