local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "EnemyAI",
    Ancestors = { workspace }
}

function component:Construct()
    self.controllerManager = self.Instance.ControllerManager :: ControllerManager
    self.groundController = self.Instance.ControllerManager.GroundController :: GroundController
    self.target = nil
    self.path = PathfindingService:CreatePath({
        AgentRadius = 1.5,
        AgentHeight = 6,
        AgentCanJump = false,
        AgentCanClimb = false,
        WaypointSpacing = 4,
    })
    self.movementSFX = Waiter.get.descendant(self.Instance, "Movement SFX") :: Sound
end

function component:SteppedUpdate()
    local validTargets = self:getValidTargets()
    self.target = self:selectClosest(validTargets)
    if self.target then
        self:moveTo(self.target)
    else
        self.controllerManager.MovingDirection = Vector3.new()
    end
    -- Play movement sound effect
    if not self.movementSFX then return end
    if self.groundController.MoveSpeedFactor > 0 and self.controllerManager.MovingDirection.Magnitude > 0 then
        if self.movementSFX.IsPlaying then return end
        self.movementSFX:Play()
    else
        if not self.movementSFX.IsPlaying then return end
        self.movementSFX:Stop()
    end
end

function component:getPosition()
    return self.Instance.PrimaryPart.Position
end

function component:computePath(from: Vector3, to: Vector3)
    return Promise.new(function(resolve, reject)
        self.path:ComputeAsync(from, to)
        if self.path.Status == Enum.PathStatus.Success then
            resolve(self.path:GetWaypoints())
        else
            reject(self.path.Status)
        end
    end)
end

function component:getValidTargets()
    local targets = {}
    for _, player in game.Players:GetPlayers() do
        if not player.Character then continue end
        if not player.Character.PrimaryPart then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        table.insert(targets, player.Character.PrimaryPart)
    end
    targets = TableUtil.Filter(targets, function(target)
        return self:computePath(self:getPosition(), target.Position)
        :andThen(function()
            return true
        end)
        :catch(function()
            return false
        end)
    end)
    return targets
end

function component:selectClosest(targets: {BasePart})
    local closest = TableUtil.Reduce(targets, function(a, b)
        local previousDistance = (a.Position - self:getPosition()).Magnitude
        local distance = (b.Position - self:getPosition()).Magnitude
        return if previousDistance < distance then a else b
    end)
    return closest
end

function component:moveTo(target: BasePart)
    self:computePath(self:getPosition(), target.Position)
    :andThen(function(waypoints)
        local waypoint = waypoints[2]
        if waypoint then
            local direction = (waypoint.Position - self:getPosition()).Unit
            self.controllerManager.FacingDirection = Vector3.new(direction.X, 0, direction.Z).Unit
            self.controllerManager.MovingDirection = direction
        else
            self.controllerManager.MovingDirection = Vector3.new()
        end
    end)
    :catch(function()
        self.controllerManager.MovingDirection = Vector3.new()
    end)
end

return component