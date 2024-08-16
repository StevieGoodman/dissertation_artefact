local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)

local component = Component.new {
    Tag = "IntervalledDamage",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`IntervalledDamage component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    self.damageAmount = 0
    self.damageInterval = 1
end

function component:Start()
    self.timer = Timer.Simple(self.damageInterval, function()
        self.Instance.Health -= self.damageAmount
    end)
end

function component:Stop()
    self.timer:Disconnect()
end

--[[
    Factory method for setting the amount of damage dealt per interval.
    Because this method returns the component back, it may be chained with other methods.
--]]
function component:SetDamageAmount(damageAmount: number | NumberRange)
    if typeof(damageAmount) == "NumberRange" then
        damageAmount = math.random(damageAmount.Min, damageAmount.Max)
    end
    self.damageAmount = damageAmount
    return self
end

--[[
    Factory method for setting the interval between damage applications.
    Because this method returns the component back, it may be chained with other methods.
--]]
function component:SetDamageInterval(damageInterval: number | NumberRange)
    if typeof(damageInterval) == "NumberRange" then
        damageInterval = math.random(damageInterval.Min, damageInterval.Max)
    end
    damageInterval = math.clamp(damageInterval, 0, math.huge)
    self.damageInterval = damageInterval
    self.timer:Disconnect()
    self.timer = Timer.Simple(self.damageInterval, function()
        self.Instance.Health -= self.damageAmount
    end)
    return self
end

return component