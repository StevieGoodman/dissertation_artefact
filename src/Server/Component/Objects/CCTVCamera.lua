local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "CCTVCamera",
    Ancestors = { workspace }
}

function component:Construct()
    self.horizontalHinge = WaiterV5.get.descendant(self.Instance, "HorizontalHinge") :: HingeConstraint
    self.direction = "clockwise"
    self.canRotate = true
end

function component:HeartbeatUpdate(dt)
    self.oscillationDuration = self.Instance:GetAttribute("OscillationDuration") or 10
    self.waitDuration = self.Instance:GetAttribute("WaitDuration") or 5
    if not self.canRotate then return end
    if self.horizontalHinge.TargetAngle == self.horizontalHinge.UpperAngle then
        self.direction = "counterclockwise"
        self.canRotate = false
        task.wait(self.waitDuration)
        self.canRotate = true
    elseif self.horizontalHinge.TargetAngle == self.horizontalHinge.LowerAngle then
        self.direction = "clockwise"
        self.canRotate = false
        task.wait(self.waitDuration)
        self.canRotate = true
    end
    local deltaAngle = dt * (self.horizontalHinge.UpperAngle - self.horizontalHinge.LowerAngle) / self.oscillationDuration
    local newAngle = nil
    if self.direction == "clockwise" then
        newAngle = self.horizontalHinge.TargetAngle + deltaAngle
    else
        newAngle = self.horizontalHinge.TargetAngle - deltaAngle
    end
    self.horizontalHinge.TargetAngle = math.clamp(newAngle, self.horizontalHinge.LowerAngle, self.horizontalHinge.UpperAngle)
end

return component