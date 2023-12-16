local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

function respawn(_, player: Player, as: Team?)
    if as then
        player.Team = as
    end
    player:LoadCharacter()
    return `Successfully respawned {player} as a member of {as}!`
end

function respawnClient(self, player: Player, as: Team?)
    if player.Character then
        error(`Cannot respawn {player}: Character is spawned in`)
    end
    return respawn(self, player, as)
end

local service = Knit.CreateService {
    Name    = "Respawn",
    Respawn = respawn,
    Client  = {
        respawn = respawnClient,
    },
}

return service