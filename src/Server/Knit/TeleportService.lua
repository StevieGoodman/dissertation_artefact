local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Teleport",
}

function service:canTeleportPlayer(player: Player)
    return player.Character ~= nil
end

function service:teleport(player: Player, to: CFrame)
    if not self:canTeleportPlayer(player) then return false end
    player.Character.HumanoidRootPart.CFrame = to
    return true
end

function service:teleportGroup(players: {Player}, to: CFrame)
    local teleportStatus = {}
    for _, player in players do
        teleportStatus[player] = self:teleport(player, to)
    end
    return teleportStatus
end

return service