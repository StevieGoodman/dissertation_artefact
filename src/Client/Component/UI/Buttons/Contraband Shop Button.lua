local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Contraband Shop Button",
    Ancestors = { PLAYER.PlayerGui }
}

function component:Construct()
    Knit.OnStart():await()
    self.contrabandShopService = Knit.GetService("Contraband Shop")
    self.notificationController = Knit.GetController("Notification")
    self.itemId = self.Instance:GetAttribute("ItemId")
    self.displayName = self.Instance:GetAttribute("DisplayName")
    self.price = self.Instance:GetAttribute("Price")
    assert(self.itemId, "ItemId attribute must be set")
end

function component:Start()
    self.Instance.MouseButton1Click:Connect(function()
        self.contrabandShopService:purchase(self.itemId):andThen(function(purchaseResult)
            if purchaseResult == "Ok" then
                self.notificationController:send("PURCHASE SUCCESSFUL", `You have successfully purchased a {self.displayName} for ${self.price}`)
            elseif purchaseResult == "NotEnoughMoney" then
                self.notificationController:send("NOT ENOUGH MONEY", `You do not have enough money to purchase a {self.displayName}`)
            elseif purchaseResult == "InvalidItemId" then
                self.notificationController:send("INVALID SHOP ITEM ID", `{self.itemId} is not a valid shop item ID\nContact ithacaTheEnby immediately`)
            elseif purchaseResult == "InvalidTeam" then
                self.notificationController:send("INVALID TEAM", `You must be Class-D Personnel to purchase items from the contraband shop`)
            end
        end)
    end)
end

return component