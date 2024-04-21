local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local teleportLocationFolder = CollectionService:GetTagged("TeleportLocationsFolder")[1]

return function(context, location: string | Player)
    local destination = nil
    -- Convert location into destination CFrame
    if type(location) == "string" then
        location = teleportLocationFolder:FindFirstChild(location)
        if location == nil then
            return `No location registered with name "{location}" found.`
        end
        destination = location.CFrame
    else
        if not location.Character then
            return `Player {location} isn't spawned in.`
        end
        destination =
        location.Character.HumanoidRootPart.CFrame *
        CFrame.new(0, 0, -5) * CFrame.Angles(0, math.rad(180), 0)
    end
    -- Teleport player
    local teleportService = Knit.GetService("Teleport")
    local teleportStatus = teleportService:teleport(context.Executor, destination)
    if teleportStatus then
        return `Successfully teleported to {location}`
    else
        return `Failed to teleport to {location}`
    end
end