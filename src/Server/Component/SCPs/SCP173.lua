local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local SightProbe = require(ServerScriptService.Component.Probes.SightProbeServer)

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
    if self.observed then
        if not self:isObserved() then
            self:updateState(false)
        end
    else
        if self:isObserved() then
            self:updateState(true)
        end
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
    end
end



return component