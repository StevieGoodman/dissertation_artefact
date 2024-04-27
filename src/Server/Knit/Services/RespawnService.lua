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

service.Client.RespawnResult = {
    Ok = "Ok",
    PlayerSpawnedIn = "PlayerSpawnedIn",
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
    self:giveTools(player)
    return self.RespawnResult.Ok
end

function service.Client:respawn(player: Player, as: Team?): string
    if player.Character and player.Character.Humanoid.Health > 0 then
        return self.RespawnResult.PlayerSpawnedIn
    else
        self.Server:respawn(player, as)
        return self.RespawnResult.Ok
    end
end

function service:giveTools(player: Player)
    local tools = player.Team:GetChildren()
    for _, tool in tools do
        tool:Clone().Parent = player.Backpack
    end
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
    player.Backpack:ClearAllChildren()
end

service.Client.removeCharacter = service.removeCharacter

return service