local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context, reassignTeam: boolean?)
    local TestQueueService = Knit.GetService("TestQueue")
    if reassignTeam then
        context.Executor.Team = Teams["Class-D Personnel"]
        context.Executor:LoadCharacter()
    end
    local addResult = TestQueueService:add(context.Executor)
    if addResult == TestQueueService.AddResult.NotClassD then
        return "You must be Class-D Personnel to join the test queue!"
    elseif addResult == TestQueueService.AddResult.AlreadyInQueue then
        local place = TestQueueService:getPlaceInQueue(context.Executor)
        return `You are already in the test queue at position number {place}.`
    else
        local place = TestQueueService:getPlaceInQueue(context.Executor)
        return `You have been added to the test queue at position number {place}.`
    end
end