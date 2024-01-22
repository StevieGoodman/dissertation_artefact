local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local InteractionObjectComponent = require(script.Parent.InteractionObject)

local component = Component.new {
    Tag = "InteractionButton",
    Ancestors = { workspace }
}

function component:Construct()
    self.interactionObjectComponent = InteractionObjectComponent:FromInstance(self.Instance)
    self.prompt = self.Instance :: ProximityPrompt
end

function component:Start()
    self.prompt.Triggered:Connect(function(player)
        self.interactionObjectComponent:interact(player)
    end)
end

return component