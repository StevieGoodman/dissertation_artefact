local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

export type PuddleType = {
    colour: BrickColor, -- The colour of the puddle.
    transparency: number, -- The transparency of the puddle.
    moneyReward: number, -- The money reward for cleaning up the puddle.
}

export type PuddleGroupConfig = {
    groupName: string, -- The name of the group.
    types: {PuddleType}, -- The types of puddles that can be spawned.
    spawnInterval: NumberRange, -- The rate at which the puddles spawn.
    spawnDelay: number, -- The delay before the puddles spawn.
    maxAmount: number, -- The maximum number of puddles that can be spawned.
}

export type PuddleGroup = {
    config: PuddleGroupConfig, -- The configuration of the group.
    spawnIntervalRemaining: number, -- The remaining time until the next spawn.
}

local service = Knit.CreateService {
    Name = "Puddle",
}

function service:KnitInit()
    self.groups = {}
end

function service:KnitStart()
    RunService.Stepped:Connect(function(_, deltaTime)
        self:steppedUpdate(deltaTime)
    end)
end

function service:steppedUpdate(deltaTime: number)
    for _, group in self.groups do
        self:updateGroup(group, deltaTime)
    end
end

--[=[
    Updates a group of puddles.
    @param group -- The group to update.
    @param deltaTime -- The time since the last update.
]=]
function service:updateGroup(group: PuddleGroup, deltaTime: number)
    group.spawnIntervalRemaining -= deltaTime
    local belowMax = self:getAmountSpawned(group.config.groupName) < group.config.maxAmount
    if group.spawnIntervalRemaining > 0 or not belowMax then return end
    group.spawnIntervalRemaining = group.random:NextNumber(
        group.config.spawnInterval.Min,
        group.config.spawnInterval.Max
    )
    self:trySpawnPuddle(group)
end

--[=[
    Attempts to spawn a puddle in a group.
    @param group -- The group to spawn the puddle in.
]=]
function service:trySpawnPuddle(group: PuddleGroup)
    local sources = self:getSourcesInGroup(group.config.groupName)
    for _, source in sources do
        local timeSinceLastClean = os.clock() - source.lastCleanTime
        local shouldSpawn = timeSinceLastClean > group.config.spawnDelay
        if not source:canSpawn() or not shouldSpawn then continue end
        local selectedType = TableUtil.Sample(group.config.types, 1)[1]
        source:spawn(selectedType)
        break
    end
end

--[=[
    Returns the number of puddles spawned in a group.
    @param groupName -- The name of the group.
    @return number -- The number of puddles spawned.
]=]
function service:getAmountSpawned(groupName: string)
    local sources = self:getSourcesInGroup(groupName)
    local spawned = TableUtil.Filter(sources, function(source)
        return not source:canSpawn()
    end)
    return #spawned
end

--[=[
    Returns all puddles in a group.
    @param groupName -- The name of the group.
    @return table -- A table of puddles in the group.
]=]
function service:getSourcesInGroup(groupName: string)
    local all = Component.PuddleSource:GetAll()
    local group = TableUtil.Filter(all, function(source)
        return source.group == groupName
    end)
    return group
end

--[=[
    Registers a new group of puddles
    @param config -- The configuration of the group.
]=]
function service:registerGroup(config: PuddleGroupConfig)
    local random = Random.new()
    self.groups[config.groupName] = {
        config = config,
        random = random,
        spawnIntervalRemaining = random:NextNumber(
            config.spawnInterval.Min,
            config.spawnInterval.Max
        )
    }
end

return service