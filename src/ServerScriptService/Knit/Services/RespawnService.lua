local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Respawn",
}

function service:respawn(player: Player, as: Team?)
    if as then
        player.Team = as
    end
    player:LoadCharacter()
    return `Successfully respawned {player} as a member of {as}!`
end

function service.Client:respawn(player: Player, as: Team?)
    if player.Character then
        error(`Cannot respawn {player}: Character is spawned in`)
    end
    return self.Server:respawn(player, as)
end

function service:removeCharacter(player: Player)
    if player.Character then
        player.Character:Destroy()
        player.Character = nil
    end
end

service.Client.removeCharacter = service.removeCharacter

return service