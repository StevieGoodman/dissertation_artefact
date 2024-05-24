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
        return self.pathfindingNavigationService:canPath(origin, target.Position, path)
        :andThen(function(canPath)
            return canPath
        end)
        :catch(function()
            return false
        end)
    end)
    return targets
end

--[=[
    Selects the closest target to orihin from a list of targets.
    @param origin {Vector3} -- The position to compare distances from
    @param targets {BasePart} -- A list of targets
    @return BasePart -- The closest target
]=]
function service:selectClosest(origin: {Vector3}, targets: {BasePart})
    local closest = TableUtil.Reduce(targets, function(a, b)
        local previousDistance = (a.Position - origin).Magnitude
        local distance = (b.Position - self:getPosition()).Magnitude
        return if previousDistance < distance then a else b
    end)
    return closest
end

return service