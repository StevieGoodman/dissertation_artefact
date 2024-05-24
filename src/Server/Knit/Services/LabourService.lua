local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PuddleService

local service = Knit.CreateService {
    Name = "Labour",
}

service.spillLabourGroupConfig = {
    groupName = "SpillLabour",
    types = {
        {
            colour = BrickColor.new("Medium blue"),
            transparency = 0.75,
            moneyReward = 2,
        },
    },
    spawnInterval = NumberRange.new(1, 5),
    spawnDelay = 5,
    maxAmount = 5,
}

function service:KnitInit()
    PuddleService = Knit.GetService("Puddle")
end

function service:KnitStart()
    PuddleService:registerGroup(service.spillLabourGroupConfig)
end

return service