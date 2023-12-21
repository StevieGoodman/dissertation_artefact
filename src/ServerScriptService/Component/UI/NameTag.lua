local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

local component = Component.new {
    Tag = "NameTag",
    Ancestors = { workspace }
}

component.assetService = Knit.GetService("Asset")
component.identityService = Knit.GetService("Identity")

function component.new(character: Model)
    local nameTag = component.assetService:getAsset("NameTag")
    if character.Head then
        nameTag.Parent = character.Head
    end
end

function component:Construct()
    self.text = self.Instance.Content :: TextLabel
    self.player = Players:GetPlayerFromCharacter(self.Instance.Parent.Parent) :: Player
end

function component:Start()
    local identity = self.identityService:getPlayerIdentity(self.player)
    self.text.Text = string.upper(identity)
    self.text.BackgroundColor3 = self.player.TeamColor.Color
end

Observers.observeCharacter(function(_, character)
    component.new(character)
end)

return component