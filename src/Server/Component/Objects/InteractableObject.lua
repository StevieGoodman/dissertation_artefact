local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)

local component = Component.new {
    Tag = "InteractableObject",
    Ancestors = { workspace }
}

function component:Construct()
    self.interacted = Signal.new()
end

function component:tryInteract(player)
    self.interacted:Fire(player)
end

return component