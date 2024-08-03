local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local service = Knit.CreateService {
    Name = "EnemyAI",
}

function service:KnitInit()
    self.pathfindingNavigationService = Knit.GetService("PathfindingNavigation")
end

--[=[
    Gets a list of valid targets for the instance to attack.
    @return {BasePart} -- A list of valid targets
]=]
function service:getValidTargets(origin: {BasePart}, path: Path)
    local targets = {}
    for _, player in game.Players:GetPlayers() do
        if not player.Character then continue end
        if not player.Character.PrimaryPart then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        table.insert(targets, player.Character.PrimaryPart)
    end
    targets = TableUtil.Filter(targets, function(target)
        local result
        self.pathfindingNavigationService:canPath(origin, target.Position, path)
        :andThen(function(canPath)
            result = canPath
        end)
        :catch(function()
            result = false
        end)
        :await()
        return result
    end)
    return targets
end

--[=[
    Selects the closest target to orihin from a list of targets.
    @param origin {Vector3} -- The position to compare distances from
    @param targets {BasePart} -- A list of targets
    @return BasePart -- The closest target
]=]
function service:selectClosest(origin: {Vector3}, targets: {BasePart}): BasePart?
    local closest = TableUtil.Reduce(targets, function(a, b)
        local previousDistance = (a.Position - origin).Magnitude
        local distance = (b.Position - self:getPosition()).Magnitude
        return if previousDistance < distance then a else b
    end)
    return closest
end

--[=[
    Gets the best target for an enemy to attack.
    @param origin {BasePart} -- The origin of the instance
    @param path Path -- The path object to use
    @return BasePart -- The best target
]=]
function service:getBestTarget(origin: {BasePart}, path: Path): BasePart?
    local validTargets = self:getValidTargets(origin, path)
    return self:selectClosest(origin, validTargets)
end

--[=[
    Determines if there is a reachable target that can be found.
    @param origin {BasePart} -- The origin of the instance
    @param path Path -- The path object to use
    @return boolean -- Whether a target can be found
]=]
function service:canFindTarget(origin: {BasePart}, path: Path): boolean
    return self:getBestTarget(origin, path) ~= nil
end

return service