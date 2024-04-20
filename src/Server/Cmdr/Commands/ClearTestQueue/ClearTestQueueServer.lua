local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_)
    local TestQueueService = Knit.GetService("TestQueue")
    local clearResult = TestQueueService:clear()
    if clearResult == TestQueueService.ClearResult.QueueEmpty then
        return "The test queue is already empty!"
    else
        return "The test queue has been cleared."
    end
end