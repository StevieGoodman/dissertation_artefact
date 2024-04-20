local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local teleportLocationFolder = CollectionService:GetTagged("TeleportLocationsFolder")[1]

return function(_, players: {Players}, locationName)
    local reply = ``
    local location = teleportLocationFolder:FindFirstChild(locationName)
    if location == nil then
        return `No location registered with name "{locationName}" found.`
    else
        local teleportService = Knit.GetService("Teleport")
        local teleportStatuses = teleportService:teleportGroup(players, location.CFrame)
        for player, status in teleportStatuses do
            if status then
                reply ..= `Successfully teleported {player.Name} to {locationName}\n`
            else
                reply ..= `Failed to teleport {player.Name} to {locationName}\n`
            end
        end
        reply = string.sub(reply, 1, -2)
        return reply
    end
end