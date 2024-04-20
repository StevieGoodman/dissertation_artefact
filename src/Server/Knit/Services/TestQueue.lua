local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local service = Knit.CreateService {
    Name = "TestQueue",
}

-- Result Enums
service.GetResult = {
    Ok = "Ok",
    QueueEmpty = "QueueEmpty",
}

service.AddResult = {
    Ok = "Ok",
    NotClassD = "NotClassD",
    AlreadyInQueue = "AlreadyInQueue",
}

service.RemoveResult = {
    Ok = "Ok",
    NotInQueue = "NotInQueue",
}

service.PopResult = {
    Ok = "Ok",
    NoPlayersInQueue = "NoPlayersInQueue",
    NotEnoughPlayersInQueue = "NotEnoughPlayersInQueue",
    InvalidAmount = "InvalidAmount",
}

service.ClearResult = {
    Ok = "Ok",
    QueueEmpty = "QueueEmpty",
}

function service:KnitInit()
    self._queue = {}
end

function service:KnitStart()
    Observers.observeCharacter(function(player: Player, _)
        return function()
            self:remove(player)
        end
    end)
end

--[[
    Returns the contents of the current test queue.
--]]
function service:get()
    if #self._queue == 0 then
        return self.GetResult.QueueEmpty, {}
    else
        return self.GetResult.Ok, table.clone(self._queue)
    end
end

--[[
    Adds a player to the test queue. Players must be Class-D Personnel to be added.
--]]
function service:add(player: Player): string
    local isClassD = player.Team.Name ~= "Class-D Personnel"
    if isClassD then
        return self.AddResult.NotClassD
    elseif table.find(self._queue, player) then
        return self.AddResult.AlreadyInQueue
    else
        table.insert(self._queue, player)
        return self.AddResult.Ok
    end
end

--[[
    Removes a player from the test queue.
--]]
function service:remove(player: Player): string
    for index, playerInQueue in self._queue do
        if player ~= playerInQueue then continue end
        table.remove(self._queue, index)
        return self.RemoveResult.Ok
    end
    return self.RemoveResult.NotInQueue
end

--[[
    Removes a specified amount of players from the front of test queue.
    Amount must be a positive, non-zero integer.
--]]
function service:pop(amount: number): (string, {Player})
    local players = {}
    if amount <= 0 then
        return self.PopResult.InvalidAmount, nil
    elseif #self._queue == 0 then
        return self.PopResult.NoPlayersInQueue, {}
    end
    repeat
        local player = self._queue[1]
        table.insert(players, player)
        self:remove(player)
    until #players == amount or #self._queue
    if #players < amount then
        return self.PopResult.NotEnoughPlayersInQueue, players
    else
        return self.PopResult.Ok, players
    end
end

--[[
    Clears the test queue.
--]]
function service:clear(): string
    if #self._queue == 0 then
        return self.ClearResult.QueueEmpty
    else
        self._queue = {}
        return self.ClearResult.Ok
    end
end

return service