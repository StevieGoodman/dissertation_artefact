local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "PathfindingNavigation",
    Ancestors = { workspace }
}

function component:Construct()
    Knit.OnStart():await()
    -- Constants
    self.service = Knit.GetService("PathfindingNavigation")
    self.controllerManager = self.Instance.ControllerManager :: ControllerManager
    self.groundController = self.Instance.ControllerManager.GroundController :: GroundController
    self.movementSFX = Waiter.get.descendant(self.Instance, "Movement SFX") :: Sound
    self.path = self.service:createPath(self.Instance)
    -- Variables
    self.target = nil :: Vector3?
    -- Assertions
    assert(self.controllerManager, `Failed to get ControllerManager for {self.Instance:GetFullName()}`)
    assert(self.groundController, `Failed to get GroundController for {self.Instance:GetFullName()}`)
end

function component:SteppedUpdate()
    self:updateMovementDirection()
    self:updateSFX()
end

--[=[
    Changes the navigation target of the instance.
    @param target Vector3 -- The new target position
]=]
function component:setTarget(target: Vector3)
    self.target = target
end

--[=[
    Removes the navigation target of the instance.
]=]
function component:removeTarget()
    self.target = nil
end

--[=[
    Updates the movement direction of the instance's associated ControllerManager based on the target position.
]=]
function component:updateMovementDirection()
    self:computePath()
    :andThen(function(waypoints)
        local waypoint = waypoints[2]
        if waypoint then -- Player is still moving towards the target
            local direction = (waypoint.Position - self:getPosition()).Unit
            self.controllerManager.MovingDirection = direction
        else -- Player has arrived at the target
            self.controllerManager.MovingDirection = Vector3.new()
        end
    end)
    :catch(function()
        self.controllerManager.MovingDirection = Vector3.new()
    end)
end

--[=[
    Updates the instance's associated movement SFX based on the current movement state.
]=]
function component:updateSFX()
    if not self.movementSFX then return end
    local moving =
        self.groundController.MoveSpeedFactor > 0 and
        self.controllerManager.MovingDirection.Magnitude > 0
    if moving then
        if self.movementSFX.IsPlaying then return end
        self.movementSFX:Play()
    else
        if not self.movementSFX.IsPlaying then return end
        self.movementSFX:Stop()
    end
end

--[=[
    Returns the current position of the instance.
    @return Vector3 -- The current position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end

--[=[
    Computes a path from the instance's current position to the current target position.
    @return Promise -- A promise that resolves with the computed waypoints if the path was successfully computed, or rejects with the path status if the path computation failed
]=]
function component:computePath()
    local from = self:getPosition()
    local to = self.target
    return Promise.new(function(resolve, reject, _)
        self.path:ComputeAsync(from, to)
        if self.path.Status == Enum.PathStatus.Success then
            resolve(self.path:GetWaypoints())
        else
            reject(self.path.Status)
        end
    end)
end

return component