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
    InvalidTeam = "InvalidTeam",
}

function service:KnitInit()
    self.moneyService = Knit.GetService("Money")
end

function service:KnitStart()
    self:registerShopItems()
end

function service:registerShopItems()
    -- Medical Keycard
    self:registerShopItem {
        Id = "MedicalKeycard",
        DisplayName = "Keycard (Medical)",
        Price = 20,
        Callback = function(player: Player)
            local tool = Knit.GetService("Asset"):getAsset("Keycard (Medical)", "Tool")
            tool.Parent = player.Backpack
        end,
        Icon = "rbxassetid://17274918007",
    }
    -- Research Keycard
    self:registerShopItem {
        Id = "ResearchKeycard",
        DisplayName = "Keycard (Research)",
        Price = 20,
        Callback = function(player: Player)
            local tool = Knit.GetService("Asset"):getAsset("Keycard (Research)", "Tool")
            tool.Parent = player.Backpack
        end,
        Icon = "rbxassetid://17274919616",
    }
    -- Security Keycard
    self:registerShopItem {
        Id = "SecurityKeycard",
        DisplayName = "Keycard (Security)",
        Price = 50,
        Callback = function(player: Player)
            local tool = Knit.GetService("Asset"):getAsset("Keycard (Security)", "Tool")
            tool.Parent = player.Backpack
        end,
        Icon = "rbxassetid://17274921053",
    }
    -- Pistol
    self:registerShopItem {
        Id = "Pistol",
        DisplayName = "Pistol",
        Price = 50,
        Callback = function(player: Player)
            local tool = Knit.GetService("Asset"):getAsset("Pistol", "Tool")
            tool.Parent = player.Backpack
        end,
        Icon = "rbxassetid://17274938073"
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
    elseif player.Team.Name ~= "Class-D Personnel" then
        return self.PurchaseResult.InvalidTeam
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