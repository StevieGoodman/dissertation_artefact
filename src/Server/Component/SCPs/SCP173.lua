local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

Knit.OnStart():await()
local EnemyAIService = Knit.GetService("EnemyAI")
local PathfindingNavigationService = Knit.GetService("PathfindingNavigation")

local SightProbe = Component.SightProbeServer

local component = Component.new {
    Tag = "SCP173",
    Ancestors = { workspace }
}

function component:Construct()
    -- Constants
    self.controllerManager = self.Instance.ControllerManager :: ControllerManager
    self.groundController = self.Instance.ControllerManager.GroundController :: GroundController
    self.mesh = Waiter.get.descendant(self.Instance, "Mesh") :: MeshPart
    self.sightProbes = Waiter.get.descendants(self.Instance, "SightProbe") :: {Attachment}
    -- Variables
    self.observed = false
    -- Assertions
    assert(self.controllerManager, `Failed to get ControllerManager for {self.Instance:GetFullName()}`)
    assert(self.groundController, `Failed to get GroundController for {self.Instance:GetFullName()}`)
    assert(self.mesh, `Failed to get Mesh for {self.Instance:GetFullName()}`)
end

function component:SteppedUpdate()
    self:tryUpdateState()
end

function component:isObserved()
    return TableUtil.Some(self.sightProbes, function(sightProbe)
        return SightProbe:FromInstance(sightProbe).isObserved
    end)
end

function component:tryUpdateState()
    if self.observed and not self:isObserved() then
        self:updateState(false)
    elseif not self.observed and self:isObserved() then
        self:updateState(true)
    end
end

function component:updateState(observed)
    self.observed = observed
    if observed then
        self.groundController.TurnSpeedFactor = 0
        self.groundController.MoveSpeedFactor = 0
        self.mesh:RemoveTag("DamageOnTouch")
        self.mesh.Anchored = true
        self.mesh.CanCollide = true
    else
        self.groundController.TurnSpeedFactor = 1
        self.groundController.MoveSpeedFactor = 1
        self.mesh:AddTag("DamageOnTouch")
        self.mesh.Anchored = false
        self.mesh.CanCollide = false
        local path = PathfindingNavigationService:createPath(self.Instance)
        local canFindTarget = EnemyAIService:canFindTarget(self:getPosition(), path)
        if canFindTarget then
            self.Instance:RemoveTag("WanderAI")
            self.Instance:AddTag("EnemyAI")
        else
            self.Instance:RemoveTag("EnemyAI")
            self.Instance:AddTag("WanderAI")
        end
    end
end

--[=[
    Gets the position of the instance.
    @return Vector3 -- The position of the instance
]=]
function component:getPosition()
    return self.Instance.PrimaryPart.Position
end

return component