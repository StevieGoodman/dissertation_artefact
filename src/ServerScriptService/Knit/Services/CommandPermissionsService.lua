local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local GROUP_ID = 4373288
local PERMS_TABLE = {
    development = 255,
    moderation = 2,
    classA = 3,
    classB = 2,
    classC = 1
}

local service = Knit.CreateService {
    Name = "CommandPermissions",
}

function service:checkPermissions(player: Player, commandGroup: string)
    if player.UserId <= 0 then
        print(`{player.Name} is a test player account. Their permission has been approved!`)
        return true
    end
    if not commandGroup then return true end
    local rank = player:GetRankInGroup(GROUP_ID)
    local requiredRank = PERMS_TABLE[commandGroup]
    if not requiredRank then
        error(`There is no rank assigned for the command group "{commandGroup}"!`)
    end
    return rank >= requiredRank
end

--[[
    Compares two player's permissions in the main Foundation group and returns
    true if player1 has higher permissions than player2.
--]]
function service:comparePermissions(player1: Player, player2: Player): boolean
    return player1:GetRankInGroup(GROUP_ID) > player2:GetRankInGroup(GROUP_ID) or player1.UserId < 0
end

function service.Client:checkPermissions(_, player: Player, commandGroup: string)
    return self.Server:checkPermissions(player, commandGroup)
end

return service