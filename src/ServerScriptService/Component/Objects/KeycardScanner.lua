local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local InteractionObjectComponent = require(script.Parent.InteractionObject)

local component = Component.new {
    Tag = "KeycardScanner",
    Ancestors = { workspace }
}

function component:Construct()
    self.interactionObjectComponent = InteractionObjectComponent:FromInstance(self.Instance)
end

function hook(player)
    return player.Team.Name ~= "Class-D Personnel"
end

function component:Start()
    self.interactionObjectComponent.hook = hook
end

return component