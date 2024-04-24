local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Service = Knit.CreateService {
    Name = "Contraband Shop",
    RegisterItemResult = {
        Ok = "Ok",
        NoId = "NoId",
        NoDisplayName = "NoDisplayName",
        NoPrice = "NoPrice",
        NegativePrice = "NegativePrice",
        NoCallback = "NoCallback",
    },
    Client = {
        PurchaseResult = {
            Ok = "Ok",
            InvalidItemId = "InvalidItemId",
            NotEnoughMoney = "NotEnoughMoney",
        }
    },
}

function Service:KnitInit()
    self.itemRegistry = {}
    self.moneyService = Knit.GetService("Money")
end

function Service:KnitStart()
    self:registerShopItems()
end

function Service:registerShopItems()
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

function Service:registerShopItem(itemInfo)
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
        self.itemRegistry[itemInfo.Id] = itemInfo
        return self.RegisterItemResult.Ok
    end
end

function Service.Client:purchase(player: Player, itemId: string)
    if not self.Server.itemRegistry[itemId] then
        return self.PurchaseResult.NoItem
    else
        local price = self.Server.itemRegistry[itemId].Price
        local result = self.Server.moneyService:remove(player, price)
        if result == self.Server.moneyService.RemoveResult.Ok then
            self.Server.itemRegistry[itemId].Callback(player)
            return self.PurchaseResult.Ok
        else
            return self.PurchaseResult.NotEnoughMoney
        end
    end
end

return Service