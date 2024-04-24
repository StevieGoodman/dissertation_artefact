local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local service = Knit.CreateService {
    Name = "Money",
    Client = {
        money = Knit.CreateProperty(0)
    }
}

service.AddResult = {
    Ok = "Successfully added money",
    NegativeAmount = "Cannot add a negative amount",
}

service.RemoveResult = {
    Ok = "Successfully removed money",
    NotEnoughMoney = "Not enough money to remove",
    NegativeAmount = "Cannot remove a negative amount",
}

function service:KnitInit()
    self.playerDataService = Knit.GetService("PlayerData")
end

function service:KnitStart()
    Observers.observePlayer(function(player)
        self.Client.money:SetFor(player, self:get(player))
    end)
end

function service:get(player: Player | number)
    local userId = if type(player) == "number" then player else player.UserId
    return service.playerDataService:getProfile(userId).Data.money
end

function service:add(player: Player | number, amount: number)
    if amount < 0 then
        return self.AddResult.NegativeAmount
    else
        local userId = if type(player) == "number" then player else player.UserId
        local updateData = {
            service = "Money",
            functionName = "_add",
            args = {amount},
        }
        service.playerDataService:createProfileUpdate(userId, updateData)
        return self.AddResult.Ok
    end
end

function service:_add(profile: table, userId: number, amount: number)
    local newTotal = profile.Data.money + amount
    profile.Data.money = newTotal
    local player = Players:GetPlayerByUserId(userId)
    if not player then return end
    self.Client.money:SetFor(player, newTotal)
end

function service:remove(player: Player | number, amount: number)
    local userId = if type(player) == "number" then player else player.UserId
    if self:get(player) < amount then
        return self.RemoveResult.NotEnoughMoney
    elseif amount < 0 then
        return self.RemoveResult.NegativeAmount
    else
        local updateData = {
            service = "Money",
            functionName = "_remove",
            args = {amount},
        }
        service.playerDataService:createProfileUpdate(userId, updateData)
        return self.RemoveResult.Ok
    end
end

function service:_remove(profile: table, userId: number, amount: number)
    local newTotal = profile.Data.money - amount
    profile.Data.money = newTotal
    local player = Players:GetPlayerByUserId(userId)
    if not player then return end
    self.Client.money:SetFor(player, newTotal)
end

return service