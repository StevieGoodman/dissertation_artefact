local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "WanderAI",
    Ancestors = { workspace }
}

function component:Construct()
    print("AI Wander")
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

function component:Stop()
    print("AI Wander Stop")
end

function component:SteppedUpdate()
    
end

--[=[
    Gets the position of the instance.
    @return Vector3 -- The position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end


return component