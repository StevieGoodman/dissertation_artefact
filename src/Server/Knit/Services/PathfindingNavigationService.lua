local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local service = Knit.CreateService {
    Name = "PathfindingNavigation",
}

--[=[
    Creates a new Path object with settings
    @param instance Instance -- The instance to draw path parameters from
    @return Path -- The new Path object
]=]
function service:createPath(instance: Instance)
    return PathfindingService:CreatePath({
        AgentRadius = instance:GetAttribute("AgentRadius") or 1.5,
        AgentHeight = instance:GetAttribute("AgentHeight") or 5,
        AgentCanJump = instance:GetAttribute("AgentCanJump") or false,
        AgentCanClimb = instance:GetAttribute("AgentCanClimb")or false,
        WaypointSpacing = instance:GetAttribute("WaypointSpacing") or 4,
    })
end

--[=[
    Determines a path can be found between two points.
    @param from Vector3 -- The starting position
    @param to Vector3 -- The target position
    @param path Path -- The path object to use
    @return boolean -- Whether a path was found.
]=]
function service:canPath(from: Vector3, to: Vector3, path: Path): boolean
    return Promise.new(function(resolve, _, _)
        path:ComputeAsync(from, to)
        resolve(path.Status == Enum.PathStatus.Success)
        path:Destroy()
    end)
end

return service