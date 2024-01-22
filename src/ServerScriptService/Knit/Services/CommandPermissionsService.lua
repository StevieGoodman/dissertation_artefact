local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local GROUP_ID = 4373288
local PERMS_TABLE = {
    development = 255,
    classA = 3,
    classB = 2,
    classC = 1
}

local service = Knit.CreateService {
    Name = "CommandPermissions",
}

function service:checkPermissions(player: Player, commandGroup: string)
    if not commandGroup then return end
    local rank = player:GetRankInGroup(GROUP_ID)
    local requiredRank = PERMS_TABLE[commandGroup]
    if not requiredRank then
        error(`There is no rank assigned for the command group "{commandGroup}"!`)
    end
    return rank >= requiredRank
end

function service.Client:checkPermissions(_, player: Player, commandGroup: string)
    return self.Server:checkPermissions(player, commandGroup)
end

return service