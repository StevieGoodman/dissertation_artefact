local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    self.bulletOrigin = Waiter.get.descendant(self.Instance, { tag = "BulletOrigin" })
end

function component:fire(at: Vector3, player: Player)
    local bulletOrigin = self:getBulletOrigin()
    if not bulletOrigin then return end
    if self.Instance:GetAttribute("Ammo") <= 0 then return end
    if self.Instance:GetAttribute("Reloading") then return end
    local shotInstance = self:getShotInstance(bulletOrigin, at, player)
    local ammo = self.Instance:GetAttribute("Ammo")
    self.Instance:SetAttribute("Ammo", ammo - 1)
    local humanoid = self:getHumanoidFromPart(shotInstance)
    if not humanoid then return end
    
    local range = (bulletOrigin - at).Magnitude
    local damage = self:getDamageFromRange(range)
    humanoid:TakeDamage(damage)
end

function component:reload()
    if self.Instance:GetAttribute("Reloading") then return end
    local reloadTime = self.Instance:GetAttribute("ReloadTime")
    local ammoCapacity = self.Instance:GetAttribute("AmmoCapacity")
    self.Instance:SetAttribute("Reloading", true)
    Promise.delay(reloadTime):andThen(function()
        self.Instance:SetAttribute("Ammo", ammoCapacity)
        self.Instance:SetAttribute("Reloading", false)
    end)
end

function component:getBulletOrigin()
    return self.bulletOrigin.WorldCFrame.Position
end

function component:getShotInstance(from: Vector3, at: Vector3, player: Player)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { player.Character }
    local raycastResult = workspace:Raycast(
        from,
        (at - from).Unit * self.Instance:GetAttribute("MaxRange"),
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
    local maxRange = self.Instance:GetAttribute("MaxRange")
    local lethalRange = self.Instance:GetAttribute("LethalRange")
    local damage = self.Instance:GetAttribute("Damage")
    if range <= lethalRange then
        return self.Instance:GetAttribute("Damage")
    else
        local distanceRange = maxRange - lethalRange
        local rangeBeyondLethal = range - lethalRange
        return damage * (1 - (rangeBeyondLethal / distanceRange))
    end
end

return component