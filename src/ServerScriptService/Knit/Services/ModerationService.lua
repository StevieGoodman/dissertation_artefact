local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Moderation",
}

function service:kick(player: Player, reason: string)
    player:Kick(reason)
end

return service