local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)

local component = Component.new {
    Tag = "DamageOnTouch",
    Ancestors = { workspace }
}

function component:Construct()
    self.damage = self.Instance:GetAttribute("DamagePerTouch") or -1
    self.debounceTime = self.Instance:GetAttribute("DamageDebounce") or 1
    self.canDamage = true
end

function component:Start()
    self.Instance.Touched:Connect(function(part)
        self:tryDamageHumanoid(part)
    end)
end

function component:tryDamageHumanoid(part: BasePart)
    local humanoid = self:getHumanoidFromPart(part)
    if not humanoid or not self.canDamage then
        return
    end
    self.canDamage = false
    self.damage = self.Instance:GetAttribute("DamagePerTouch") or -1
    local damage = if self.damage < 0 then humanoid.MaxHealth else self.damage
    humanoid:TakeDamage(damage)
    Promise.delay(self.debounceTime)
    :andThen(function()
        self.canDamage = true
    end)
end

function component:getHumanoidFromPart(part: BasePart)
    return part.Parent:FindFirstChild("Humanoid")
end

return component