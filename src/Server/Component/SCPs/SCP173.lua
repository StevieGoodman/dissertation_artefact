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
    self.observed = false
    self.controllerManager = self.Instance.ControllerManager :: ControllerManager
    self.groundController = self.Instance.ControllerManager.GroundController :: GroundController
    self.sightProbes = Waiter.get.descendants(self.Instance, "SightProbe") :: {Attachment}
    self.mesh = Waiter.get.descendant(self.Instance, "Mesh") :: MeshPart
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
        self.mesh:SetAttribute("DamagePerTouch", 0)
        self.mesh.Anchored = true
        self.mesh.CanCollide = true
    else
        self.groundController.TurnSpeedFactor = 1
        self.groundController.MoveSpeedFactor = 1
        self.mesh:SetAttribute("DamagePerTouch", -1)
        self.mesh.Anchored = false
        self.mesh.CanCollide = false
    end
end



return component