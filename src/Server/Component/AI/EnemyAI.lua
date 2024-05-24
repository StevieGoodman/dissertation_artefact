local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local component = Component.new {
    Tag = "EnemyAI",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:HasTag("PathfindingNavigation") then
        self.Instance:AddTag("PathfindingNavigation")
    end
    Component.PathfindingNavigation:WaitForInstance(self.Instance, 5)
    :andThen(function(pathfindingNavigation)
        self.pathfindingNavigation = pathfindingNavigation
    end)
    :catch(function()
        warn(`Failed to get PathfindingNavigation component for {self.Instance:GetFullName()}`)
    end)
end

function component:SteppedUpdate()
    local validTargets = self:getValidTargets()
    self.target = self:selectClosest(validTargets)
    if self.target then
        self.pathfindingNavigation:setTarget(self.target.Position)
    else
        self.pathfindingNavigation:removeTarget()
    end
end

--[=[
    Gets a list of valid targets for the instance to attack.
    @return {BasePart} -- A list of valid targets
]=]
function component:getValidTargets()
    local targets = {}
    for _, player in game.Players:GetPlayers() do
        if not player.Character then continue end
        if not player.Character.PrimaryPart then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        table.insert(targets, player.Character.PrimaryPart)
    end
    targets = TableUtil.Filter(targets, function(target)
        return self.pathfindingNavigation:canPath(target.Position)
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
    Selects the closest target from a list of targets.
    @param targets {BasePart} -- A list of targets
    @return BasePart -- The closest target
]=]
function component:selectClosest(targets: {BasePart})
    local closest = TableUtil.Reduce(targets, function(a, b)
        local previousDistance = (a.Position - self:getPosition()).Magnitude
        local distance = (b.Position - self:getPosition()).Magnitude
        return if previousDistance < distance then a else b
    end)
    return closest
end

--[=[
    Gets the position of the instance.
    @return Vector3 -- The position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end


return component