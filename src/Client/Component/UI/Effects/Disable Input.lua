local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Disable Input",
    Ancestors = { PLAYER.PlayerGui }
}

function component:Construct()
    Knit.OnStart():await()
    self.inputController = Knit.GetController("Input")
end

function component:Start()
    self.inputController:disableInput(self.Instance)
end

function component:Stop()
    self.inputController:enableInput(self.Instance)
end

return component