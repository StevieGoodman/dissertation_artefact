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

function service.Client:fire(player: Player, at: Vector3)
    local gun = self.Server:getGunFromPlayer(player)
    if not gun then return end
    gun:fire(at, player)
end

function service.Client:reload(player: Player)
    local gun = self.Server:getGunFromPlayer(player)
    if not gun then return end
    gun:reload()
end

return service