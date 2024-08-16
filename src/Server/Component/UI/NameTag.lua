local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
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
    self.Trove = Trove.new()
    self.Text = self.Instance.Content :: TextLabel
    self.Stroke = self.Text.Stroke :: UIStroke
    self.Character = self.Instance.Parent.Parent :: Model
    self.Player = Players:GetPlayerFromCharacter(self.Character) :: Player
end

function component:Start()
    local identity = self.identityService:getPlayerIdentity(self.Player)
    self.Text.Text = string.upper(identity)
    self.Text.BackgroundColor3 = self.Player.TeamColor.Color
    local connection = self.Character.Head:GetPropertyChangedSignal("Transparency"):Connect(function()
        local newTransparency = self.Character.Head.Transparency
        self.Text.TextTransparency = newTransparency
        self.Text.BackgroundTransparency = newTransparency
        self.Stroke.Transparency = newTransparency
    end)
    self.Trove:Add(connection)
end

function component:Stop()
    self.Trove:Clean()
end

Observers.observeCharacter(function(_, character)
    component.new(character)
end)

return component