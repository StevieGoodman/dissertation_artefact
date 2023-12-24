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

function component:fire(at: Vector3, player: Player)
    local bulletOrigin = self:getBulletOrigin()
    if not bulletOrigin then return end
    local shotInstance = self:getShotInstance(bulletOrigin, at, player)
    local humanoid = self:getHumanoidFromPart(shotInstance)
    if not humanoid then return end
    local range = (bulletOrigin - at).Magnitude
    local damage = self:getDamageFromRange(range)
    humanoid:TakeDamage(damage)
end

function component:getShotInstance(from: Vector3, at: Vector3, player: Player)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { player.Character }
    local raycastResult = workspace:Raycast(
        from,
        (at - from).Unit * self.maxRange,
        raycastParams
    )
    if raycastResult then
        return raycastResult.Instance
    end
end

function component:getHumanoidFromPart(part: BasePart)
    local character = part:FindFirstAncestorOfClass("Model")
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid
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