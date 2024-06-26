local GroupService = game:GetService("GroupService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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
    if RunService:IsStudio() then
        print(`Testing in Studio. Permission has been approved!`)
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
function service:comparePermissions(playerId1: number, playerId2: number): boolean
    if RunService:IsStudio() then
        print(`Testing in Studio. Permission has been approved!`)
        return true
    end
    if playerId1 <= 0 then
        print(`User ID {playerId1} is a test player account. Their permission has been approved!`)
        return true
    end
    local player1Rank = 0
    local player2Rank = 0
    for _, group in GroupService:GetGroupsAsync(playerId1) do
        if group.Id == GROUP_ID then
            player1Rank = group.Rank
            break
        end
    end
    for _, group in GroupService:GetGroupsAsync(playerId2) do
        if group.Id == GROUP_ID then
            player2Rank = group.Rank
            break
        end
    end
    return player1Rank > player2Rank
end

function service.Client:checkPermissions(_, player: Player, commandGroup: string)
    return self.Server:checkPermissions(player, commandGroup)
end

return service