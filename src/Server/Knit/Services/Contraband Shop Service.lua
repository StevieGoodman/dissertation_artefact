local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local service = Knit.CreateService {
    Name = "Contraband Shop",
    Client = {
        itemRegistry = Knit.CreateProperty({})
    },
}

service.RegisterItemResult = {
    Ok = "Ok",
    NoId = "NoId",
    NoDisplayName = "NoDisplayName",
    NoPrice = "NoPrice",
    NegativePrice = "NegativePrice",
    NoCallback = "NoCallback",
}

service.Client.PurchaseResult = {
    Ok = "Ok",
    InvalidItemId = "InvalidItemId",
    NotEnoughMoney = "NotEnoughMoney",
}

function service:KnitInit()
    self.moneyService = Knit.GetService("Money")
end

function service:KnitStart()
    self:registerShopItems()
end

function service:registerShopItems()
    -- Pistol
    self:registerShopItem {
        Id = "Pistol",
        DisplayName = "Pistol",
        Price = 50,
        Callback = function(player: Player)
            local pistol = Knit.GetService("Asset"):getAsset("Pistol", "Tool")
            pistol.Parent = player.Backpack
        end,
    }
end

function service:registerShopItem(itemInfo)
    if not itemInfo.Id then
        return self.RegisterItemResult.NoId
    elseif not itemInfo.DisplayName then
        return self.RegisterItemResult.NoDisplayName
    elseif not itemInfo.Price then
        return self.RegisterItemResult.NoPrice
    elseif itemInfo.Price < 0 then
        return self.RegisterItemResult.NegativePrice
    elseif not itemInfo.Callback then
        return self.RegisterItemResult.NoCallback
    else
        local itemRegistry = self.Client.itemRegistry:Get()
        itemRegistry[itemInfo.Id] = itemInfo
        self.Client.itemRegistry:Set(itemRegistry)
        return self.RegisterItemResult.Ok
    end
end

function service.Client:purchase(player: Player, itemId: string)
    if not self.itemRegistry:Get()[itemId] then
        return self.PurchaseResult.NoItem
    else
        local price = self.itemRegistry:Get()[itemId].Price
        local result = self.Server.moneyService:remove(player, price)
        if result == self.Server.moneyService.RemoveResult.Ok then
            self.itemRegistry:Get()[itemId].Callback(player)
            return self.PurchaseResult.Ok
        else
            return self.PurchaseResult.NotEnoughMoney
        end
    end
end

return service