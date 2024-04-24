local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Contraband Shop Items List",
    Ancestors = { PLAYER.PlayerGui }
}

function component:Construct()
    Knit.OnStart():await()
    self.contrabandShopService = Knit.GetService("Contraband Shop")
    self.itemButtonTemplate = Waiter.get.child(self.Instance, "Contraband Shop Button Template")
    assert(self.itemButtonTemplate, "No Contraband Shop Button Template found in Contraband Shop!")
end

function component:Start()
    self.contrabandShopService.itemRegistry:Observe(function(...)
        self:refreshList(...)
    end)
end

function component:refreshList(items)
    -- Clear current list
    local buttons = Waiter.get.children(self.Instance, "Contraband Shop Button")
    TableUtil.Filter(buttons, function(button)
        return button ~= self.itemButtonTemplate -- Don't remove the template
    end)
    -- Add items to list
    for _, item in items do
        local button = self.itemButtonTemplate:Clone()
        button.Name = item.Id
        button.Parent = self.Instance
        button.Visible = true
        button.Image = item.Icon
        Waiter.get.child(button, "Shop Price Label").Text = `${item.Price}`
        button:SetAttribute("ItemId", item.Id)
        button:SetAttribute("DisplayName", item.DisplayName)
        button:SetAttribute("Price", item.Price)
        button:RemoveTag("Contraband Shop Button Template")
        button:AddTag("Contraband Shop Button")
    end
end

return component