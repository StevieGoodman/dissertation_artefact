local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Sprint",
}

function getHumanoidFromPlayer(player: Player)
    local character = player.Character
    if character then
        return character.Humanoid
    end
end

function service.Client:sprint(player: Player)
    local humanoid = getHumanoidFromPlayer(player)
    humanoid.WalkSpeed *= 2
end

function service.Client:walk(player: Player)
    local humanoid = getHumanoidFromPlayer(player)
    humanoid.WalkSpeed /= 2
end

return service