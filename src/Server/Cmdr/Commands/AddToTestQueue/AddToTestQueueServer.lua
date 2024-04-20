local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context, players: {Player}, reassignTeam: boolean?)
    local TestQueueService = Knit.GetService("TestQueue")

    local msg = ""
    for _, player in players do
        if reassignTeam and player.Character then
            context.Executor.Team = Teams["Class-D Personnel"]
            Knit.GetService("Respawn"):respawn(player)
        end
        local addResult = TestQueueService:add(player)
        if addResult == TestQueueService.AddResult.NotSpawnedIn then
            msg ..= `{player} is not spawned in and cannot join the test queue.`
        elseif addResult == TestQueueService.AddResult.NotClassD then
            msg ..= `{player} is not Class-D Personnel and cannot join the test queue.`
        elseif addResult == TestQueueService.AddResult.AlreadyInQueue then
            local _, place = TestQueueService:getPlaceInQueue(player)
            msg ..= `{player} is already in the test queue at position number {place}.`
        else
            local _, place = TestQueueService:getPlaceInQueue(player)
            msg ..= `{player} has been added to the test queue at position number {place}.`
        end
        msg ..= "\n"
    end
    msg = msg:sub(1, -2)
    return msg
end