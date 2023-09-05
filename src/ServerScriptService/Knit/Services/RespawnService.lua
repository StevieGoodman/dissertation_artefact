--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local REPL_STORE = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local KNIT = require(REPL_STORE.Packages.Knit)

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function Respawn(_, player: Player, as: Team?)
    if as then
        player.Team = as
    end
    player:LoadCharacter()
    return `Successfully respawned {player} as a member of {as}!`
end

function RespawnClient(self, player: Player, as: Team?)
    if player.Character then
        error(`Cannot respawn {player}: Character is spawned in`)
    end
    return Respawn(self, player, as)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local service = KNIT.CreateService {
    Name    = "Respawn",
    Respawn = Respawn,
    Client  = {
        Respawn = RespawnClient,
    },
}

return service