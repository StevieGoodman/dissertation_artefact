local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local teleportLocationFolder = CollectionService:GetTagged("TeleportLocationsFolder")[1]

return function(_, players: {Players}, location: string | Player)
    local destination = nil
    -- Convert location into destination CFrame
    if type(location) == "string" then
        location = teleportLocationFolder:FindFirstChild(location)
        if location == nil then
            return `No location registered with name "{location}" found.`
        else
            destination = location.CFrame
        end
    else
        if not location.Character then
            return `Player {location} isn't spawned in.`
        else
            destination =
            location.Character.HumanoidRootPart.CFrame *
            CFrame.new(0, 0, -5) * CFrame.Angles(0, math.rad(180), 0)
        end
    end
    -- Teleport players
    local teleportService = Knit.GetService("Teleport")
    local teleportStatuses = teleportService:teleportGroup(players, destination)
    local reply = ``
    for player, status in teleportStatuses do
        if status then
            reply ..= `Successfully teleported {player.Name} to {location}\n`
        else
            reply ..= `Failed to teleport {player.Name} to {location}\n`
        end
    end
    reply = string.sub(reply, 1, -2)
    return reply
end