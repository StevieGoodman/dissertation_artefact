local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "InteractionPermissions",
}

function service:checkPermissions(player: Player)
    return player.Team.Name ~= "Class-D Personnel" or player:GetAttribute("InteractionPermissionsOverride")
end

function service.Client:checkPermissions(player: Player)
    return self.Server:checkPermissions(player)
end

return service