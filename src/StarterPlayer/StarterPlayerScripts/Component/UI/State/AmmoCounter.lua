local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)

local component = Component.new {
    Tag = "AmmoCounter",
}

function component:Start()
    Observers.observeTag("Pistol", function(pistol)
        self.Instance.Visible = true
        local unbindCallback = self:bindAmmoChangedEvent(pistol)
        return function()
            unbindCallback()
            self.Instance.Visible = false
        end
    end,
    { Players.LocalPlayer.Character })
end

function component:bindAmmoChangedEvent(pistol: Tool)
    return Observers.observeAttribute(
        pistol,
        "Ammo",
        function(ammo)
            self.Instance.Text = `{ammo}/{pistol:GetAttribute("AmmoCapacity")}`
        end
    )
end

return component