local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)

local component = Component.new {
    Tag = "Button",
}

function component:Construct()
    self.objects = {
        button = self.Instance :: TextButton,
        uiStroke = self.Instance.Stroke :: UIStroke,
    }
    self.events = {
        highlighted = Signal.new(),
        unhighlighted = Signal.new(),
        selected = Signal.new(),
    }
end

return component