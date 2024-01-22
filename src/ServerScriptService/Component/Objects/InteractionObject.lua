local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local InteractableObjectComponent = require(script.Parent.InteractableObject)

local component = Component.new {
    Tag = "InteractionObject",
    Ancestors = { workspace }
}

function component:Construct()
    self.connections = WaiterV5.get.descendants(self.Instance, "InteractionObjectConnection") :: { ObjectValue }
end

function component:interact(player)
    for _, connection in ipairs(self.connections) do
        local interactableObject = InteractableObjectComponent:FromInstance(connection.Value)
        if not interactableObject then return end
        interactableObject:tryInteract(player)
    end
end

return component