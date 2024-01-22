local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)

local component = Component.new {
    Tag = "InteractableObject",
    Ancestors = { workspace }
}

component.interacted = Signal.new()

function component:Start()
    self.interacted:Connect(function(player)
        print(`{player} interacted with {self.Instance}!`)
    end)
end

function component:tryInteract(player)
    self.interacted:Fire(player)
end

return component