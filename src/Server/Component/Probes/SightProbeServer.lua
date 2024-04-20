local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)

local component = Component.new {
    Tag = "SightProbe",
    Ancestors = { workspace }
}

function component:Construct()
    self.observers = {}
    self.isObserved = false
    self.observed = Signal.new()
    self.unobserved = Signal.new()
    self.observerAdded = Signal.new()
    self.observerRemoved = Signal.new()
end

function component:addObserver(player: Player)
    table.insert(self.observers, player)
    self.observerAdded:Fire(player)
    self:tryUpdateState()
end

function component:removeObserver(player: Player)
    local index = table.find(self.observers, player)
    table.remove(self.observers, index)
    self.observerRemoved:Fire(player)
    self:tryUpdateState()
end

function component:tryUpdateState()
    if #self.observers > 0 and not self.isObserved then
        self.isObserved = true
        self.observed:Fire()
    elseif #self.observers == 0 and self.isObserved then
        self.isObserved = false
        self.unobserved:Fire()
    end
end

return component