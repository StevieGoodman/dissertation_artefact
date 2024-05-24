local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()
local PathfindingNavigationService = Knit.GetService("PathfindingNavigation")

local component = Component.new {
    Tag = "WanderAI",
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
    -- Constants
    self.wanderDistance = self.Instance:GetAttribute("WanderDistance") or NumberRange.new(10, 20)
    self.wanderInterval = self.Instance:GetAttribute("WanderInterval") or NumberRange.new(5, 10)
    -- Variables
    self.timeUntilWander = math.random(self.wanderInterval.Min, self.wanderInterval.Max)
    self.wanderDestinationPromise = nil
end

function component:SteppedUpdate(deltaTime)
    self.timeUntilWander -= deltaTime
    if self.timeUntilWander > 0 then return end
    self.timeUntilWander = math.random(self.wanderInterval.Min, self.wanderInterval.Max)
    self.wanderDestinationPromise = self:getWanderDestination()
    :andThen(function(destination)
        self.pathfindingNavigation:setTarget(destination)
    end)
end

function component:Stop()
    if not self.wanderDestinationPromise then return end
    self.wanderDestinationPromise:cancel()
    self.pathfindingNavigation:removeTarget()
end

--[=[
    Gets a valid destination for the instance to wander to.
    @return Promise<Vector3> -- The destination to wander to
]=]
function component:getWanderDestination()
    return Promise.new(function(resolve, reject, onCancel)
        local cancel = false
        onCancel(function()
            cancel = true
        end)
        local destination
        repeat
            local distance = math.random(-self.wanderDistance.Min, self.wanderDistance.Max)
            local angle = math.random(0, math.pi * 2)
            local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
            local attempt = self:getPosition() + offset
            local query = workspace:GetPartBoundsInBox(CFrame.new(attempt) , Vector3.new(2, 0.5, 2), OverlapParams.new())
            if #query == 1 then continue end -- Only allow the instance to wander to empty floor spaces
            local path = PathfindingNavigationService:createPath(self.Instance)
            PathfindingNavigationService:canPath(self:getPosition(), attempt, path)
            :andThen(function(canPath)
                if not canPath then return end
                destination = attempt
            end)
            task.wait()
        until cancel or destination
        if destination then
            resolve(destination)
        else
            reject()
        end
    end)
end

--[=[
    Gets the position of the instance.
    @return Vector3 -- The position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end


return component