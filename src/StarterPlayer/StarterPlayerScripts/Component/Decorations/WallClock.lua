local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "WallClock",
    Ancestors = { workspace }
}

function component:Construct()
    self.hourHand = WaiterV5.get.child(self.Instance, "HourHand") :: MeshPart
    self.minuteHand = WaiterV5.get.child(self.Instance, "MinuteHand") :: MeshPart
    self.secondHand = WaiterV5.get.child(self.Instance, "SecondHand") :: MeshPart
end

function component:Start()
    Timer.Simple(
        1,
        function()
            self:increment()
        end,
        true)
end

function component:increment()
    local secondPivotCFrame = self.secondHand:GetPivot() * CFrame.Angles(-math.rad(6), 0, 0)
    local minutePivotCFrame = self.minuteHand:GetPivot() * CFrame.Angles(-math.rad(6) / 60, 0, 0)
    local hourPivotCFrame = self.hourHand:GetPivot() * CFrame.Angles(-math.rad(6) / 60 / 12, 0, 0)

    self.secondHand:PivotTo(secondPivotCFrame)
    self.minuteHand:PivotTo(minutePivotCFrame)
    self.hourHand:PivotTo(hourPivotCFrame)
end

return component