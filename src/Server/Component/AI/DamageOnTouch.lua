local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "DamageOnTouch",
    Ancestors = { workspace }
}

function component:Construct()
    self.damage = self.Instance:GetAttribute("DamagePerTouch") or -1
    self.debounceTime = self.Instance:GetAttribute("DamageDebounce") or 1
    self.canDamage = true
    self.damageSFX = Waiter.get.descendant(self.Instance, "Damage SFX") :: Sound
end

function component:Start()
    self.connection = self.Instance.Touched:Connect(function(part)
        self:tryDamageHumanoid(part)
    end)
end

function component:Stop()
    self.connection:Disconnect()
end

function component:tryDamageHumanoid(part: BasePart)
    local humanoid = self:getHumanoidFromPart(part)
    if not humanoid or humanoid.Health <= 0 or not self.canDamage then
        return
    end
    self.canDamage = false
    self.damage = self.Instance:GetAttribute("DamagePerTouch") or -1
    local damage = if self.damage < 0 then humanoid.MaxHealth else self.damage
    humanoid:TakeDamage(damage)
    if self.damageSFX then
        self.damageSFX:Play()
    end
    Promise.delay(self.debounceTime)
    :andThen(function()
        self.canDamage = true
    end)
end

function component:getHumanoidFromPart(part: BasePart)
    return part.Parent:FindFirstChild("Humanoid")
end

return component