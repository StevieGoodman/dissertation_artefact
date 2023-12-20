local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local HUMANOID_DESCRIPTION_TAGS = {
    ["Class-D Personnel"] = "ClassDHumanoidDescriptions",
    ["Research Department"] = "ResearchHumanoidDescriptions",
    ["Medical Department"] = "MedicalHumanoidDescriptions",
    ["Security Department"] = "SecurityHumanoidDescriptions",
}

local service = Knit.CreateService {
    Name = "Respawn",
}

function service:KnitStart()
    self.assetService = Knit.GetService("Asset")
end

function service:respawn(player: Player, as: Team?)
    if as then
        player.Team = as
    end
    local description = self:getHumanoidDescription(player.Team)
    player:LoadCharacterWithHumanoidDescription(description)
    return `Successfully respawned {player} as a member of {as}!`
end

function service.Client:respawn(player: Player, as: Team?)
    if player.Character then
        error(`Cannot respawn {player}: Character is spawned in`)
    end
    return self.Server:respawn(player, as)
end

function service:getHumanoidDescription(team: Team)
    local descriptions = self.assetService:getAssetsInFolder(HUMANOID_DESCRIPTION_TAGS[team.Name])
    local selectedDescription = TableUtil.Sample(descriptions, 1)[1]
    return selectedDescription
end

function service:removeCharacter(player: Player)
    if player.Character then
        player.Character:Destroy()
        player.Character = nil
    end
end

service.Client.removeCharacter = service.removeCharacter

return service