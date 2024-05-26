local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "EnemyAI",
    Ancestors = { workspace }
}

function component:Construct()
    Knit.OnStart():await()
    if not self.Instance:HasTag("PathfindingNavigation") then
        self.Instance:AddTag("PathfindingNavigation")
    end
    -- Constants
    Component.PathfindingNavigation:WaitForInstance(self.Instance, 5)
    :andThen(function(pathfindingNavigation)
        self.pathfindingNavigation = pathfindingNavigation
    end)
    :catch(function()
        warn(`Failed to get PathfindingNavigation component for {self.Instance:GetFullName()}`)
    end)
    :await()
    self.service = Knit.GetService("EnemyAI")
end

function component:SteppedUpdate()
    local validTargets = self.service:getValidTargets(self:getPosition(), self.pathfindingNavigation.path)
    self.target = self.service:selectClosest(self:getPosition(), validTargets)
    if self.target then
        self.pathfindingNavigation:setTarget(self.target.Position)
    else
        self.pathfindingNavigation:removeTarget()
    end
end

function component:Stop()
    self.pathfindingNavigation:removeTarget()
end

--[=[
    Gets the position of the instance.
    @return Vector3 -- The position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end


return component