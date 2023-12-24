local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local Pistol = require(ServerScriptService.Component.Tools.PistolServer)

local service = Knit.CreateService {
    Name = "Gun",
}

function service:getGunFromPlayer(player: Player)
    local character = player.Character
    if not character then return end
    local gun = Waiter.get.child(character, { tag = "Pistol" })
    if not gun then return end
    return Pistol:FromInstance(gun) :: Tool
end

function service:getShotInstance(from: Vector3, to: Vector3, player: Player)
    local gun = self:getGunFromPlayer(player)
    if not gun then return end
    local maxRange = gun.maxRange
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { player.Character }
    local raycastResult = workspace:Raycast(
        from,
        (to - from).Unit * maxRange,
        raycastParams
    )
    if raycastResult then
        return raycastResult.Instance
    end
end

function service:getHumanoidFromPart(part: BasePart)
    local character = part:FindFirstAncestorOfClass("Model")
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid
end

function service.Client:fire(player: Player, at: Vector3)
    local gun = self.Server:getGunFromPlayer(player)
    local bulletOrigin = gun:getBulletOrigin()
    if not bulletOrigin or not gun then return end
    local shotInstance = self.Server:getShotInstance(bulletOrigin, at, player)
    local humanoid = self.Server:getHumanoidFromPart(shotInstance)
    if not humanoid then return end
    local range = (bulletOrigin - at).Magnitude
    local damage = gun:getDamageFromRange(range)
    humanoid:TakeDamage(damage)
end

return service