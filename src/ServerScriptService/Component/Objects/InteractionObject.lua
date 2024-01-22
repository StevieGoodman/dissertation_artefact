local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local InteractableObjectComponent = require(script.Parent.InteractableObject)

local component = Component.new {
    Tag = "InteractionObject",
    Ancestors = { workspace }
}

function component:Construct()
    self.prompt = self.Instance :: ProximityPrompt
    self.connections = WaiterV5.get.descendants(self.Instance, "InteractionObjectConnection") :: { ObjectValue }
end

function component:Start()
    self.prompt.Triggered:Connect(function(player)
        self:tryInteract(player)
    end)
end

function component:tryInteract(player)
    if self.hook and not self.hook(player) then return end
    self:interact(player)
end

function component:interact(player)
    for _, connection in self.connections do
        local interactableObject = InteractableObjectComponent:FromInstance(connection.Value)
        if not interactableObject then return end
        interactableObject:tryInteract(player)
    end
end

return component