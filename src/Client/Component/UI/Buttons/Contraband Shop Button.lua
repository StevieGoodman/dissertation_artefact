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
    self.shopItemId = self.Instance:GetAttribute("ShopItemId")
    assert(self.shopItemId, "ShopItemId attribute must be set")
end

function component:Start()
    self.Instance.MouseButton1Click:Connect(function()
        self.contrabandShopService:purchase(self.shopItemId):andThen(function(purchaseResult)
            if purchaseResult == "Ok" then
                self.notificationController:send("PURCHASE SUCCESSFUL", "You have successfully purchased the shop item")
            elseif purchaseResult == "NotEnoughMoney" then
                self.notificationController:send("NOT ENOUGH MONEY", "You do not have enough money to purchase that shop item")
            elseif purchaseResult == "InvalidItemId" then
                self.notificationController:send("INVALID SHOP ITEM ID", `{self.shopItemId} is not a valid shop item ID\nContact ithacaTheEnby immediately`)
            end
        end)
    end)
end

return component