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

local service = Knit.CreateService {
    Name = "Identity",
}

function service:KnitInit()
    self.surnames = {}
    for _, surname in SURNAMES do
        self.surnames[surname] = false
    end
end

function service:KnitStart()
    Observers.observeCharacter(function(player)
        self:reserveSurname(player)
        return function()
            self:releaseSurname(player)
        end
    end)
end

function service:isSurnameAvailable(surname: string)
    return self.surnames[surname] == false
end

function service:getPlayerSurname(player: Player)
    local _, playerSurname = TableUtil.Find(self.surnames, function(otherPlayer)
        return player == otherPlayer
    end)
    return playerSurname
end

function service:reserveSurname(player: Player)
    local playerSurname = self:getPlayerSurname(player)
    if playerSurname then
        error(`{player} ({playerSurname}) already has a surname!`)
    else
        local _, surname = TableUtil.Find(self.surnames, function(_, key)
            return self:isSurnameAvailable(key)
        end)
        self.surnames[surname] = player
        return surname
    end
end

function service:releaseSurname(player: Player)
    self.surnames = TableUtil.Map(self.surnames, function(value)
        if value == player then
            return false
        else
            return value
        end
    end)
end

return service