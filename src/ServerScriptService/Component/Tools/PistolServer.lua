local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    self.pistol = self.Instance :: Tool
    self.bulletOrigin = Waiter.get.descendant(self.pistol, { tag = "BulletOrigin" })
    self.damage = self.pistol:GetAttribute("Damage") or 10
    self.lethalRange = self.pistol:GetAttribute("LethalRange") or 128
    self.maxRange = self.pistol:GetAttribute("MaxRange") or 256
end

function component:getDamageFromRange(range: number)
    if range <= self.lethalRange then
        return self.damage
    else
        local distanceRange = self.maxRange - self.lethalRange
        local rangeBeyondLethal = range - self.lethalRange
        local damage = self.damage * (1 - (rangeBeyondLethal / distanceRange))
        return damage
    end
end

function component:getBulletOrigin()
    return self.bulletOrigin.WorldCFrame.Position
end

return component