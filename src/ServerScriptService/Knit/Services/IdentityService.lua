local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Observers = require(ReplicatedStorage.Packages.Observers)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)

local SURNAMES = {
    "Smith", "Brown", "Wilson", "Thomson", "Robertson", "Campbell", "Stewart",
    "Anderson", "MacDonald", "Scott", "Reid", "Murray", "Taylor", "Clark",
    "Mitchell", "Ross", "Walker", "Paterson", "Young", "Watson", "Morrison",
    "Fraser", "Davidson", "Gray",
}
local HONORIFICS = {
    ["Research Department"] = "Dr.",
    ["Medical Department"] = "Dr.",
    ["Security Department"] = "Officer",
}

local service = Knit.CreateService {
    Name = "Identity",
}

function service:KnitInit()
    self.identities = {} :: {[Player]: string}
end

function service:KnitStart()
    Observers.observeCharacter(function(player)
        self:assignIdentity(player)
        return function()
            self:revokeIdentity(player)
        end
    end)
end

function service:isIdentityAvailable(surname: string)
    return TableUtil.Every(TableUtil.Values(self.identities), function(value)
        return value ~= surname
    end)
end

function service:getPlayerIdentity(player: Player)
    return self.identities[player]
end

function service:assignIdentity(player: Player, identity: string?)
    local playerSpawnedIn = player.Character
    if not playerSpawnedIn then
        error(`{player} isn't spawned in!`)
    else
        if identity then
            self:assignCustomIdentity(player, identity)
            return identity
        end
        local isClassD = player.Team.Name == "Class-D Personnel"
        if isClassD then
            return self:assignDesignation(player)
        else
            return self:assignSurname(player)
        end
    end
end

function service:assignCustomIdentity(player: Player, identity: string)
    self.identities[player] = identity
end

function service:assignDesignation(player: Player)
    local identity
    repeat
        identity = tostring(math.random(1, 9999))
        while #identity < 4 do
            identity = `0{identity}`
        end
        identity = `D-{identity}`
    until self:isIdentityAvailable(identity)
    self.identities[player] = identity
    return identity
end

function service:assignSurname(player: Player)
    local honorific = HONORIFICS[player.Team.Name]
    local identity = TableUtil.Find(SURNAMES, function(surname)
        return self:isIdentityAvailable(surname)
    end)
    identity = if honorific then `{honorific} {identity}` else identity
    self.identities[player] = identity
    return identity
end

function service:revokeIdentity(player: Player)
    self.identities[player] = nil
end

return service