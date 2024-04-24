local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Money Label",
    Ancestors = { PLAYER.PlayerGui }
}

function component:Construct()
    self.moneyService = Knit.GetService("Money")
    self.Instance = self.Instance :: TextLabel
end

function component:Start()
    self.moneyService.money:Observe(function(money)
        self.Instance.Text = `${money}`
    end)
end

return component