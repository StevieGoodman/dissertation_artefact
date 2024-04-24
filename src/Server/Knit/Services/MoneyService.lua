local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Money",
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

function service:_add(profile: table, _: number, amount: number)
    profile.Data.money += amount
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

function service:_remove(profile: table, _: number, amount: number)
    profile.Data.money -= amount
end

return service