local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Signal = require(ReplicatedStorage.Packages.Signal)

local service = Knit.CreateService {
    Name = "TestQueue",
    Client = {
        playerAdded = Knit.CreateSignal(),
        playerRemoved = Knit.CreateSignal(),
        newTest = Knit.CreateSignal(),
    }
}

-- Result Enums
service.GetResult = {
    Ok = "Ok",
    QueueEmpty = "QueueEmpty",
}

service.GetPlaceInQueue = {
    Ok = "Ok",
    NotInQueue = "NotInQueue",
}

service.AddResult = {
    Ok = "Ok",
    NotSpawnedIn = "NotSpawnedIn",
    NotClassD = "NotClassD",
    AlreadyInQueue = "AlreadyInQueue",
}

service.RemoveResult = {
    Ok = "Ok",
    NotInQueue = "NotInQueue",
}

service.RequestResult = {
    Ok = "Ok",
    QueueEmpty = "QueueEmpty",
    NotEnoughPlayersInQueue = "NotEnoughPlayersInQueue",
    InvalidAmount = "InvalidAmount",
    NotResearchOrMedical = "NotResearchOrMedical",
}

service.ClearResult = {
    Ok = "Ok",
    QueueEmpty = "QueueEmpty",
}

function service:KnitInit()
    self._queue = {}
    self.playerAdded = Signal.new()
    self.playerRemoved = Signal.new()
    self.newTest = Signal.new()
end

function service:KnitStart()
    self.newTest:Connect(function(...)
        self:sendTestNotifications(...)
    end)
    Observers.observeCharacter(function(player: Player, _)
        self:add(player)
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
    Returns the place of a player in the test queue.
--]]
function service:getPlaceInQueue(player: Player): (string, number?)
    local place = table.find(self._queue, player)
    if place then
        return self.GetPlaceInQueue.Ok, place
    else
        return self.GetPlaceInQueue.NotInQueue, nil
    end
end

--[[
    Adds a player to the test queue. Players must be Class-D Personnel to be added.
--]]
function service:add(player: Player): string
    if not player.Character then
        return self.AddResult.NotSpawnedIn
    elseif player.Team.Name ~= "Class-D Personnel" then
        return self.AddResult.NotClassD
    elseif table.find(self._queue, player) then
        return self.AddResult.AlreadyInQueue
    else
        table.insert(self._queue, player)
        self.playerAdded:Fire(player)
        self.Client.playerAdded:FireAll(player)
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
        self.playerRemoved:Fire(player)
        self.Client.playerRemoved:FireAll(player)
        return self.RemoveResult.Ok
    end
    return self.RemoveResult.NotInQueue
end

--[[
    Removes a specified amount of players from the front of test queue.
    Amount must be a positive, non-zero integer.
--]]
function service:request(requester: Player, amount: number, location: string): (string, {Player})
    if requester.Team.Name ~= "Research Department" and requester.Team.Name ~= "Medical Department" then
        return self.RequestResult.NotResearchOrMedical, nil
    elseif amount <= 0 then
        return self.RequestResult.InvalidAmount, nil
    elseif #self._queue == 0 then
        return self.RequestResult.QueueEmpty, {}
    elseif amount > #self._queue then
        return self.RequestResult.NotEnoughPlayersInQueue, #self._queue
    else
        local players = {}
        repeat
            local player = self._queue[1]
            table.insert(players, player)
            self:remove(player)
        until #players == amount
        self.newTest:Fire(requester, location, players)
        self.Client.newTest:FireAll(requester, location, players)
        return self.RequestResult.Ok, players
    end
end

--[[
    Clears the test queue.
--]]
function service:clear(): string
    if #self._queue == 0 then
        return self.ClearResult.QueueEmpty
    else
        for _, player in self._queue do
            self:remove(player)
        end
        return self.ClearResult.Ok
    end
end

return service